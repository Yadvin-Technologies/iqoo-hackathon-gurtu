import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show DateUtils;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import '../data/attachment_store.dart';
import '../data/care_models.dart';
import '../reminders/medicine_plan.dart';
import 'cloud_models.dart';
import 'gurtu_api.dart';
import 'push_service.dart';

/// Keeps this phone connected to the Gurtu backend: registers it with its
/// FCM token (for reminders), saves each person's onboarding as a care
/// circle with a family code, and joins circles by code.
///
/// Local first: everything works without the server. Work that couldn't
/// reach it (a circle made offline) is kept and retried on the next start
/// or refresh, so onboarding never waits for the network.
class CloudSync extends ChangeNotifier {
  CloudSync(this._prefs, {GurtuApi? api}) : _api = api ?? GurtuApi() {
    _load();
  }

  static const _key = 'cloud_v1';

  final SharedPreferences _prefs;
  final GurtuApi _api;

  String? _deviceId;
  String? _fcmToken;
  String _language = 'en';
  String _timeZone = 'Asia/Kolkata';
  bool? _notificationsAllowed;

  /// What the server last accepted about this phone (token, language...).
  /// Anything different is sent again, so a push token that arrives after
  /// the phone registered is never lost.
  String? _sentInfo;
  int _tokenTries = 0;
  Timer? _tokenRetry;

  /// Local patient id → circle id.
  final _links = <String, String>{};
  final _circles = <String, CircleInfo>{};

  /// Local patient id → the circle to create for them, not yet saved.
  final _pending = <String, Map<String, dynamic>>{};

  final _subs = <StreamSubscription<Object?>>[];
  Future<bool>? _registering;
  final _busy = <String>{};
  ApiError? _error;
  bool _disposed = false;

  /// Called with the latest circle of a local patient, to show its members.
  void Function(String patientId, CircleInfo circle)? onCircle;

  /// Messages that arrived while the app was open.
  final _messages = StreamController<PushMessage>.broadcast();
  Stream<PushMessage> get messages => _messages.stream;

  /// Notifications the person tapped (to open the reminder screen).
  final _opened = StreamController<PushMessage>.broadcast();
  Stream<PushMessage> get opened => _opened.stream;

  /// Visit id -> the medicine plan the family confirmed (JSON).
  final _visitPlans = <String, List<Map<String, dynamic>>>{};

  /// Reminder id -> work still to send: {patientId, op: put|delete, body,
  /// photo, audio}. Kept across restarts; retried until the server has it.
  final _jobs = <String, Map<String, dynamic>>{};

  /// Attachment file name -> the server's file id (uploaded once).
  final _uploaded = <String, String>{};

  /// Dose id -> "taken" or "skipped", answered but not yet sent (offline).
  final _acks = <String, String>{};

  /// Called with doses the family marked on other phones.
  void Function(String patientId, List<Map<String, dynamic>> doses)? onDoses;

  bool get registered => _api.token != null;
  String? get deviceId => _deviceId;

  /// Why the last call failed, until one succeeds.
  ApiError? get error => _error;

  CircleInfo? circleFor(String? patientId) => _circles[_links[patientId ?? '']];

  /// Its circle is waiting to be saved (the server was out of reach).
  bool isPending(String? patientId) => _pending.containsKey(patientId);

  bool isBusy(String? patientId) => _busy.contains(patientId);

  // --- Start-up ---------------------------------------------------------------

  /// Starts push, registers the device, and sends anything left waiting.
  /// Never throws: problems are kept in [error].
  Future<void> start({required String language}) async {
    _language = language;
    final push = PushService.instance;
    if (await push.init()) {
      _subs
        ..add(push.tokenRefresh.listen(_tokenChanged))
        ..add(push.foreground.listen(_messages.add))
        ..add(push.opened.listen(_opened.add));
    }
    _timeZone = await push.timeZone();
    await _readPhone();
    if (await _ensureDevice()) await syncAll();
  }

  /// The push token and notification permission, as the phone has them now.
  /// A missing token (first launch, slow Play services) is asked for again
  /// a little later rather than registered as "no notifications".
  Future<void> _readPhone() async {
    final push = PushService.instance;
    _fcmToken = await push.token() ?? _fcmToken;
    _notificationsAllowed = await push.notificationsAllowed();
    if (_fcmToken == null && _tokenTries < 5 && !_disposed) {
      _tokenTries++;
      _tokenRetry?.cancel();
      _tokenRetry = Timer(Duration(seconds: 15 * _tokenTries), () async {
        await _readPhone();
        if (_fcmToken != null) unawaited(_ensureDevice());
      });
    }
  }

  /// Back in the app (maybe after allowing notifications in Settings):
  /// tell the server if anything changed.
  Future<void> recheckPhone() async {
    if (_disposed) return;
    await _readPhone();
    await _ensureDevice();
  }

  void _tokenChanged(String token) {
    _fcmToken = token;
    _save();
    unawaited(_ensureDevice());
  }

  /// Follows the app language, so server-written pushes read right.
  Future<void> setLanguage(String code) async {
    if (code == _language) return;
    _language = code;
    await _ensureDevice();
  }

  DeviceInfo get _info => DeviceInfo(
    fcmToken: _fcmToken,
    platform: defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
    language: _language,
    timezone: _timeZone,
    notificationsAllowed: _notificationsAllowed,
  );

  /// Registers once; after that keeps the token and language current.
  Future<bool> _ensureDevice() async {
    // Something else is registering: wait for it, then send whatever
    // changed meanwhile (typically the push token arriving late).
    while (_registering != null) {
      await _registering;
    }
    final run = _registering = _register();
    try {
      return await run;
    } finally {
      if (identical(_registering, run)) _registering = null;
    }
  }

  Future<bool> _register() async {
    try {
      if (_api.token == null) {
        final info = _info;
        final creds = await _api.registerDevice(info);
        _deviceId = creds.deviceId;
        _api.token = creds.token;
        _sentInfo = jsonEncode(info.toJson());
        _save();
      }
      // Until the server has exactly what the phone has now.
      for (var i = 0; i < 3; i++) {
        final info = _info;
        final json = jsonEncode(info.toJson());
        if (json == _sentInfo) break;
        await _api.updateDevice(info);
        _sentInfo = json;
      }
      _setError(null);
      return true;
    } on ApiException catch (e) {
      if (e.error == ApiError.unauthorized) {
        // The server no longer knows this device: start again as a new one.
        _api.token = null;
        _deviceId = null;
        _save();
        return _register();
      }
      _setError(e.error);
      return false;
    }
  }

  /// Saves waiting circles and refreshes every linked one.
  Future<void> syncAll() async {
    for (final patientId in _pending.keys.toList()) {
      await _createPending(patientId);
    }
    for (final patientId in _links.keys.toList()) {
      await refresh(patientId);
      await pullDoses(patientId);
    }
    await _flushJobs();
    await _flushAcks();
  }

  // --- Circles ----------------------------------------------------------------

  /// What the backend needs from a finished onboarding.
  static Map<String, dynamic> circlePayload(
    PatientProfile p, {
    required String myName,
  }) => {
    'patient': {
      'name': p.name,
      'age': p.age,
      'gender': p.gender,
      'conditions': p.conditions,
      'allergies': p.allergies,
      'careFor': p.careFor,
      'takesMedicines': p.takesMedicines,
      'medicineCount': p.medicineCount,
      'mobility': p.mobility,
      'recentHospitalVisit': p.recentHospitalVisit,
    },
    'patientIsMe': p.isSelf,
    'myName': myName.trim().isEmpty ? p.name : myName.trim(),
    'myRole': p.isSelf ? 'patient' : 'caregiver',
  };

  /// Saves a new person's care circle; waits for the network if needed.
  Future<void> createCircle(String patientId, Map<String, dynamic> payload) {
    _pending[patientId] = payload;
    _save();
    notifyListeners();
    return _createPending(patientId);
  }

  Future<void> _createPending(String patientId) async {
    final payload = _pending[patientId];
    if (payload == null || _busy.contains(patientId)) return;
    _setBusy(patientId, true);
    try {
      if (!await _ensureDevice()) return;
      final circle = await _call(
        () => _api.createCircle(
          patient: Map<String, dynamic>.from(payload['patient'] as Map),
          patientIsMe: payload['patientIsMe'] as bool? ?? false,
          myName: payload['myName'] as String,
          myRole: payload['myRole'] as String,
        ),
      );
      if (circle == null) return;
      _pending.remove(patientId);
      link(patientId, circle);
    } finally {
      _setBusy(patientId, false);
    }
  }

  /// Joins a family by code. Throws [ApiException] so the screen can say
  /// what went wrong (wrong code, offline...).
  Future<CircleInfo> join({
    required String code,
    required String name,
    required String role,
  }) async {
    if (!await _ensureDevice()) {
      throw ApiException(_error ?? ApiError.offline);
    }
    try {
      final circle = await _api.joinCircle(code: code, name: name, role: role);
      _setError(null);
      return circle;
    } on ApiException catch (e) {
      if (e.error == ApiError.offline || e.error == ApiError.server) {
        _setError(e.error);
      }
      rethrow;
    }
  }

  /// Remembers that [patientId] on this phone is [circle] on the server.
  void link(String patientId, CircleInfo circle) {
    _links[patientId] = circle.id;
    _circles[circle.id] = circle;
    _save();
    onCircle?.call(patientId, circle);
    notifyListeners();
  }

  /// Fetches the latest members. Returns why it failed, or null.
  Future<ApiError?> refresh(String? patientId) async {
    if (patientId == null) return null;
    if (_pending.containsKey(patientId)) {
      await _createPending(patientId);
      return _pending.containsKey(patientId) ? _error : null;
    }
    final id = _links[patientId];
    if (id == null) return null;
    _setBusy(patientId, true);
    try {
      if (!await _ensureDevice()) return _error;
      final circle = await _call(() => _api.getCircle(id));
      if (circle != null) link(patientId, circle);
      return circle == null ? _error : null;
    } finally {
      _setBusy(patientId, false);
    }
  }

  /// A fresh family code (owner only).
  Future<ApiError?> newCode(String patientId) async {
    final id = _links[patientId];
    if (id == null) return ApiError.notFound;
    final circle = await _call(() => _api.newCode(id));
    if (circle != null) link(patientId, circle);
    return circle == null ? _error : null;
  }

  /// Asks everyone else in the circle to call or check in; returns the
  /// phones reached, or null when it couldn't be sent.
  Future<int?> askForHelp(String patientId) async {
    final id = _links[patientId];
    if (id == null) return null;
    return _call(() => _api.askForHelp(id));
  }

  /// Pushes a message to everyone in the circle; returns the phones reached,
  /// or null when it couldn't be sent.
  Future<int?> notify(String patientId, String title, String body) async {
    final id = _links[patientId];
    if (id == null) return null;
    return _call(() => _api.notifyCircle(id, title, body));
  }

  /// Runs [request]; on failure keeps the error and returns null.
  Future<T?> _call<T>(Future<T> Function() request) async {
    try {
      final result = await request();
      _setError(null);
      return result;
    } on ApiException catch (e) {
      if (e.error == ApiError.unauthorized) {
        _api.token = null;
        _save();
      }
      _setError(e.error);
      debugPrint('Gurtu server: $e');
      return null;
    }
  }

  // --- Medicine reminders ------------------------------------------------------

  /// The plan confirmed for [visitId], or null when none was set up.
  List<PlannedMedicine>? planFor(String visitId) =>
      _visitPlans[visitId]?.map(PlannedMedicine.fromJson).toList();

  /// Reminders of [visitId] still waiting for the server.
  bool hasWaitingReminders(String visitId) =>
      _jobs.keys.any((k) => k.startsWith('$visitId:'));

  /// The local patient a circle belongs to on this phone.
  String? patientForCircle(String? circleId) =>
      _links.entries.where((e) => e.value == circleId).firstOrNull?.key;

  /// Turns the confirmed [plan] of a visit into reminders: one per medicine
  /// and dose time, with its photo and voice note. Times turned off are
  /// removed. Sent now, or as soon as the phone is online.
  Future<void> setVisitReminders({
    required String patientId,
    required String visitId,
    required List<PlannedMedicine> plan,
  }) async {
    String idOf(String medicineId, String slot) => '$visitId:$medicineId:$slot';
    final old = {
      for (final m in planFor(visitId) ?? const <PlannedMedicine>[])
        for (final t in m.times) idOf(m.visitMedicineId, t.name),
    };
    final today = DateUtils.dateOnly(DateTime.now());
    final wanted = <String>{};
    for (final m in plan.where((m) => m.isOn)) {
      final until = m.days == null
          ? null
          : today.add(Duration(days: m.days! - 1));
      for (final t in m.orderedTimes) {
        final id = idOf(m.visitMedicineId, t.name);
        wanted.add(id);
        _jobs[id] = {
          'patientId': patientId,
          'op': 'put',
          'photo': m.photoFile,
          'audio': m.audioFile,
          'body': {
            'medicine': {
              'name': m.name.trim(),
              'strength': m.strength.trim(),
              'food': m.food.name,
              'note': m.note.trim(),
            },
            'slot': t.name,
            'time': slotTimes[t],
            'timezone': _timeZone,
            'visitId': visitId,
            'until': until == null
                ? null
                : '${until.year.toString().padLeft(4, '0')}-'
                      '${until.month.toString().padLeft(2, '0')}-'
                      '${until.day.toString().padLeft(2, '0')}',
          },
        };
      }
    }
    for (final id in old.difference(wanted)) {
      _jobs[id] = {'patientId': patientId, 'op': 'delete'};
    }
    _visitPlans[visitId] = [for (final m in plan) m.toJson()];
    _save();
    notifyListeners();
    await _flushJobs();
  }

  /// Sends waiting reminder work; stops at the first network problem.
  Future<void> _flushJobs() async {
    if (_jobs.isEmpty || !await _ensureDevice()) return;
    for (final id in _jobs.keys.toList()) {
      final job = _jobs[id]!;
      final circleId = _links[job['patientId']];
      if (circleId == null) continue; // Its circle isn't saved yet.
      try {
        if (job['op'] == 'delete') {
          await _api.deleteMedicineReminder(circleId, id);
        } else {
          final body = Map<String, dynamic>.from(job['body'] as Map);
          body['imageFileId'] = await _upload(
            circleId,
            job['photo'] as String?,
          );
          body['audioFileId'] = await _upload(
            circleId,
            job['audio'] as String?,
          );
          await _api.putMedicineReminder(circleId, id, body);
        }
        _jobs.remove(id);
        _save();
        _setError(null);
      } on ApiException catch (e) {
        _setError(e.error);
        if (e.error == ApiError.offline) break;
        // Refused for good (bad data): don't retry forever.
        if (e.error == ApiError.server || e.error == ApiError.notFound) {
          _jobs.remove(id);
          _save();
        }
      }
    }
    if (!_disposed) notifyListeners();
  }

  /// The server id of a photo or voice note, uploading it the first time.
  Future<String?> _upload(String circleId, String? file) async {
    if (file == null || !AttachmentStore.instance.available) return null;
    final known = _uploaded['$circleId/$file'];
    if (known != null) return known;
    final f = File(AttachmentStore.instance.pathOf(file));
    if (!await f.exists()) return null;
    final lower = file.toLowerCase();
    final type = lower.endsWith('.png')
        ? 'image/png'
        : lower.endsWith('.webp')
        ? 'image/webp'
        : lower.endsWith('.m4a') || lower.endsWith('.aac')
        ? 'audio/mp4'
        : 'image/jpeg';
    final id = await _api.uploadFile(circleId, await f.readAsBytes(), type);
    _uploaded['$circleId/$file'] = id;
    _save();
    return id;
  }

  /// "I've taken it" / "Skip" for one reminder sent. False when it
  /// couldn't be sent yet: it is kept and sent once the phone is online.
  Future<bool> ackDose(String doseId, String status) async {
    _acks[doseId] = status;
    _save();
    await _flushAcks();
    return !_acks.containsKey(doseId);
  }

  /// Answered doses still waiting for the server.
  bool get hasWaitingAnswers => _acks.isNotEmpty;

  Future<void> _flushAcks() async {
    if (_acks.isEmpty || !await _ensureDevice()) return;
    for (final e in _acks.entries.toList()) {
      try {
        await _api.ackDose(e.key, e.value);
        _acks.remove(e.key);
        _setError(null);
      } on ApiException catch (err) {
        _setError(err.error);
        if (err.error == ApiError.notFound || err.error == ApiError.server) {
          // Gone, or refused for good: don't retry forever.
          _acks.remove(e.key);
          continue;
        }
        if (err.error == ApiError.unauthorized) _api.token = null;
        break;
      } finally {
        _save();
      }
    }
  }

  /// Every family's doses (back in the app, or after a "taken" push).
  Future<void> pullAllDoses() async {
    for (final patientId in _links.keys.toList()) {
      await pullDoses(patientId);
    }
  }

  /// Doses of the last day, so "taken" shows on every family phone.
  Future<void> pullDoses(String patientId) async {
    final id = _links[patientId];
    if (id == null) return;
    final doses = await _call(
      () => _api.doses(id, DateTime.now().subtract(const Duration(days: 1))),
    );
    if (doses != null && doses.isNotEmpty) onDoses?.call(patientId, doses);
  }

  /// Forgets every circle link (restarting onboarding). The device itself
  /// stays registered.
  void forgetCircles() {
    _links.clear();
    _circles.clear();
    _pending.clear();
    _visitPlans.clear();
    _jobs.clear();
    _uploaded.clear();
    _acks.clear();
    _save();
    notifyListeners();
  }

  void _setBusy(String patientId, bool busy) {
    busy ? _busy.add(patientId) : _busy.remove(patientId);
    if (!_disposed) notifyListeners();
  }

  void _setError(ApiError? error) {
    if (_error == error) return;
    _error = error;
    if (!_disposed) notifyListeners();
  }

  // --- Persistence --------------------------------------------------------------

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      _deviceId = j['deviceId'] as String?;
      _api.token = j['token'] as String?;
      _fcmToken = j['fcmToken'] as String?;
      _language = j['language'] as String? ?? _language;
      _links.addAll(Map<String, String>.from(j['links'] as Map? ?? const {}));
      for (final c in (j['circles'] as Map? ?? const {}).values) {
        final circle = CircleInfo.fromJson(Map<String, dynamic>.from(c as Map));
        _circles[circle.id] = circle;
      }
      for (final e in (j['pending'] as Map? ?? const {}).entries) {
        _pending[e.key as String] = Map<String, dynamic>.from(e.value as Map);
      }
      for (final e in (j['visitPlans'] as Map? ?? const {}).entries) {
        _visitPlans[e.key as String] = [
          for (final m in e.value as List) Map<String, dynamic>.from(m as Map),
        ];
      }
      for (final e in (j['jobs'] as Map? ?? const {}).entries) {
        _jobs[e.key as String] = Map<String, dynamic>.from(e.value as Map);
      }
      _uploaded.addAll(
        Map<String, String>.from(j['uploaded'] as Map? ?? const {}),
      );
      _acks.addAll(Map<String, String>.from(j['acks'] as Map? ?? const {}));
    } on Object catch (e) {
      debugPrint('Cloud state unreadable, starting fresh: $e');
    }
  }

  void _save() {
    _prefs.setString(
      _key,
      jsonEncode({
        'deviceId': _deviceId,
        'token': _api.token,
        'fcmToken': _fcmToken,
        'language': _language,
        'links': _links,
        'circles': {for (final c in _circles.values) c.id: c.toJson()},
        'pending': _pending,
        'visitPlans': _visitPlans,
        'jobs': _jobs,
        'uploaded': _uploaded,
        'acks': _acks,
      }),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _tokenRetry?.cancel();
    for (final s in _subs) {
      s.cancel();
    }
    _messages.close();
    _opened.close();
    super.dispose();
  }
}

class CloudScope extends InheritedNotifier<CloudSync> {
  const CloudScope({super.key, required CloudSync sync, required super.child})
    : super(notifier: sync);

  static CloudSync of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CloudScope>()!.notifier!;
}
