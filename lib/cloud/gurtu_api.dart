import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'cloud_models.dart';

/// Where the Gurtu backend (`backend/`) runs: hosted on Dokploy. To try a
/// server on this PC instead, run with
/// `--dart-define=GURTU_API_URL=http://127.0.0.1:4000` after
/// `adb reverse tcp:4000 tcp:4000` (plain http works in debug builds only).
const gurtuApiUrl = String.fromEnvironment(
  'GURTU_API_URL',
  defaultValue: 'https://iqoo.yadvin.tech',
);

/// Why a call failed, in terms the app can act on.
enum ApiError {
  /// No connection, or the server didn't answer in time.
  offline,

  /// The family code doesn't exist.
  invalidCode,

  /// Too many attempts; try again later.
  tooMany,

  /// The device's credentials were not accepted (e.g. the database was
  /// reset): register again.
  unauthorized,

  /// Not a member, or it no longer exists.
  notFound,

  /// Someone already joined as the person being cared for.
  patientTaken,

  /// Anything else the server refused or failed at.
  server,
}

class ApiException implements Exception {
  const ApiException(this.error, [this.detail]);

  final ApiError error;
  final String? detail;

  @override
  String toString() =>
      'ApiException($error${detail == null ? '' : ': $detail'})';
}

/// The backend's HTTP API. Every call but [registerDevice] is signed with
/// the device token it returned.
class GurtuApi {
  GurtuApi({String? baseUrl, http.Client? client})
    : _base = Uri.parse(baseUrl ?? gurtuApiUrl),
      _http = client ?? http.Client();

  final Uri _base;
  final http.Client _http;

  /// Set once the device is registered.
  String? token;

  static const _timeout = Duration(seconds: 15);

  Future<Map<String, dynamic>> _call(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) {
    final request = http.Request(method, _base.resolve(path))
      ..headers['content-type'] = 'application/json'
      ..headers['accept'] = 'application/json';
    if (body != null) request.body = jsonEncode(body);
    return _send(request, _timeout);
  }

  Future<Map<String, dynamic>> _send(
    http.Request request,
    Duration timeout,
  ) async {
    if (token != null) request.headers['authorization'] = 'Bearer $token';
    http.Response res;
    try {
      res = await http.Response.fromStream(
        await _http.send(request).timeout(timeout),
      ).timeout(timeout);
    } on TimeoutException {
      throw const ApiException(ApiError.offline, 'timeout');
    } on SocketException catch (e) {
      throw ApiException(ApiError.offline, e.message);
    } on http.ClientException catch (e) {
      throw ApiException(ApiError.offline, e.message);
    } on HandshakeException catch (e) {
      throw ApiException(ApiError.offline, e.message);
    }
    Map<String, dynamic> json;
    try {
      json = res.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(res.body) as Map<String, dynamic>;
    } on FormatException {
      throw ApiException(ApiError.server, 'HTTP ${res.statusCode}');
    }
    if (res.statusCode >= 200 && res.statusCode < 300) return json;
    final code = json['error'] as String?;
    throw ApiException(switch ((res.statusCode, code)) {
      (404, 'invalid_code') => ApiError.invalidCode,
      (404, _) => ApiError.notFound,
      (401, _) => ApiError.unauthorized,
      (429, _) => ApiError.tooMany,
      (409, 'patient_taken') => ApiError.patientTaken,
      _ => ApiError.server,
    }, '${res.statusCode} ${code ?? ''} ${json['field'] ?? ''}'.trim());
  }

  /// A new install. Returns the token to sign every later call with.
  Future<({String deviceId, String token})> registerDevice(
    DeviceInfo info,
  ) async {
    final j = await _call('POST', '/v1/devices', info.toJson());
    return (deviceId: j['deviceId'] as String, token: j['token'] as String);
  }

  Future<void> updateDevice(DeviceInfo info) =>
      _call('PUT', '/v1/devices/me', info.toJson());

  /// Saves onboarding as a new care circle; returns it with its code.
  Future<CircleInfo> createCircle({
    required Map<String, dynamic> patient,
    required bool patientIsMe,
    required String myName,
    required String myRole,
  }) async => CircleInfo.fromJson(
    await _call('POST', '/v1/circles', {
      'patient': patient,
      'patientIsMe': patientIsMe,
      'me': {'name': myName, 'role': myRole},
    }),
  );

  /// Joins with a family code. With [role] `patient` this phone becomes
  /// the person being cared for, and [name] is not needed.
  Future<CircleInfo> joinCircle({
    required String code,
    required String name,
    required String role,
  }) async => CircleInfo.fromJson(
    await _call('POST', '/v1/circles/join', {
      'code': code,
      'role': role,
      if (role != 'patient') 'name': name,
    }),
  );

  Future<CircleInfo> getCircle(String id) async =>
      CircleInfo.fromJson(await _call('GET', '/v1/circles/$id'));

  Future<CircleInfo> updatePatient(
    String id,
    Map<String, dynamic> patient,
  ) async => CircleInfo.fromJson(
    await _call('PUT', '/v1/circles/$id/patient', {'patient': patient}),
  );

  Future<CircleInfo> newCode(String id) async =>
      CircleInfo.fromJson(await _call('POST', '/v1/circles/$id/code'));

  /// "Ask family for help": pushes to everyone else in the circle, in their
  /// own language. Returns how many phones it reached.
  Future<int> askForHelp(String id) async {
    final j = await _call('POST', '/v1/circles/$id/help');
    return j['sent'] as int? ?? 0;
  }

  /// Stores a photo or voice note for reminders; returns its file id.
  Future<String> uploadFile(
    String circleId,
    List<int> bytes,
    String contentType,
  ) async {
    final request =
        http.Request('POST', _base.resolve('/v1/circles/$circleId/files'))
          ..headers['content-type'] = contentType
          ..headers['accept'] = 'application/json'
          ..bodyBytes = bytes;
    // Photos take longer than JSON on a slow connection.
    final j = await _send(request, const Duration(seconds: 60));
    return j['fileId'] as String;
  }

  /// Saves one medicine reminder under the app's own [clientId]: sending it
  /// again (a retry) updates it rather than adding a second.
  Future<void> putMedicineReminder(
    String circleId,
    String clientId,
    Map<String, dynamic> body,
  ) => _call(
    'PUT',
    '/v1/circles/$circleId/medicine-reminders/${Uri.encodeComponent(clientId)}',
    body,
  );

  Future<void> deleteMedicineReminder(String circleId, String clientId) =>
      _call(
        'DELETE',
        '/v1/circles/$circleId/medicine-reminders/'
            '${Uri.encodeComponent(clientId)}',
      );

  /// "I've taken it" (or skipped) for one reminder sent.
  Future<void> ackDose(String doseId, String status) =>
      _call('POST', '/v1/doses/$doseId/ack', {'status': status});

  /// Doses sent since [since], and whether each was taken.
  Future<List<Map<String, dynamic>>> doses(
    String circleId,
    DateTime since,
  ) async {
    final j = await _call(
      'GET',
      '/v1/circles/$circleId/doses?since='
          '${Uri.encodeQueryComponent(since.toUtc().toIso8601String())}',
    );
    return [
      for (final d in j['doses'] as List? ?? const [])
        Map<String, dynamic>.from(d as Map),
    ];
  }

  /// Pushes a message to everyone in the circle. Returns how many phones
  /// it reached.
  Future<int> notifyCircle(String id, String title, String body) async {
    final j = await _call('POST', '/v1/circles/$id/notify', {
      'title': title,
      'body': body,
    });
    return j['sent'] as int? ?? 0;
  }
}
