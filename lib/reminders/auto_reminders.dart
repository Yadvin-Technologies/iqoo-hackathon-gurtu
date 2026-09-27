import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ai/on_device_ai.dart';
import '../cloud/cloud_sync.dart';
import '../data/care_repository.dart';
import '../data/visit_models.dart';
import 'medicine_plan.dart';

/// Automatic medicine reminders: whenever a visit's medicines are saved or
/// changed, Gurtu AI (the built-in rules when it isn't installed) reads
/// them and turns their reminders on by itself, and adds them to the
/// medicine list. The family can still check or change them on the visit.
///
/// A medicine is read again only when its notes, photo or voice note
/// change, so what the family corrected by hand stays as they set it.
/// Removed medicines and deleted visits lose their reminders either way.
class AutoReminders extends ChangeNotifier {
  AutoReminders({
    required this.prefs,
    required this.repo,
    required this.cloud,
    required this.ai,
    this.delay = const Duration(seconds: 2),
  });

  static const _key = 'auto_medicine_reminders';

  /// Visits older than this aren't set up by themselves: their medicines
  /// are likely finished.
  static const recent = Duration(days: 30);

  final SharedPreferences prefs;
  final CareRepository repo;
  final CloudSync cloud;
  final GurtuAi ai;

  /// Waits for edits to settle (a photo, then a note...) before reading.
  final Duration delay;

  /// Called with the medicines of a visit whose reminders it turned on.
  void Function(DoctorVisit visit, List<PlannedMedicine> medicines)? onSet;

  Timer? _timer;
  bool _running = false;
  bool _again = false;
  bool _started = false;
  bool _disposed = false;

  /// On unless the family switched it off in Profile.
  bool get enabled => prefs.getBool(_key) ?? true;

  set enabled(bool on) {
    prefs.setBool(_key, on);
    notifyListeners();
    if (on) schedule();
  }

  /// Reading medicines right now.
  bool get busy => _running;

  /// Follows every change to the care data from now on.
  void start() {
    if (_started) return;
    _started = true;
    repo.addListener(schedule);
    schedule();
  }

  void schedule() {
    if (_disposed) return;
    _timer?.cancel();
    _timer = Timer(delay, run);
  }

  /// One pass over every visit; another follows if something changed
  /// meanwhile.
  Future<void> run() async {
    if (_disposed) return;
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    notifyListeners();
    try {
      do {
        _again = false;
        await _pass();
      } while (_again && !_disposed);
    } on Object catch (e) {
      debugPrint('Automatic reminders failed: $e');
    } finally {
      _running = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _pass() async {
    final visitIds = {for (final v in repo.visits) v.id};
    for (final id in cloud.plannedVisits) {
      if (!visitIds.contains(id)) unawaited(cloud.forgetVisit(id));
    }
    final since = DateTime.now().subtract(recent);
    for (final visit in [...repo.visits]) {
      if (_disposed) return;
      if (visit.isSample) continue;
      final saved = {
        for (final p in cloud.planFor(visit.id) ?? const <PlannedMedicine>[])
          p.visitMedicineId: p,
      };
      final current = {for (final m in visit.medicines) m.id};
      final removed = saved.keys.any((id) => !current.contains(id));
      final toRead = <String>{
        if (enabled && !visit.date.isBefore(since))
          for (final m in visit.medicines)
            if (_needsReading(saved[m.id], visit, m)) m.id,
      };
      if (!removed && toRead.isEmpty) continue;

      final fresh = toRead.isEmpty
          ? const <PlannedMedicine>[]
          : await MedicinePlanner(ai: ai).plan(visit, only: toRead);
      if (_disposed) return;
      // Deleted while it was being read.
      if (!repo.visits.contains(visit)) continue;
      final read = {for (final p in fresh) p.visitMedicineId: p};
      final plan = [
        for (final m in visit.medicines) ?(read[m.id] ?? saved[m.id]),
      ];
      // Sent in the background; kept and retried when offline.
      unawaited(
        cloud.setVisitReminders(
          patientId: visit.patientId,
          visitId: visit.id,
          plan: plan,
        ),
      );
      final on = [
        for (final p in fresh)
          if (p.isOn) p,
      ];
      if (on.isEmpty) continue;
      repo.saveFromReminders(visit.patientId, [
        for (final p in on)
          (
            name: p.name,
            strength: p.strength,
            times: p.orderedTimes,
            food: p.food,
          ),
      ]);
      onSet?.call(visit, on);
    }
  }

  /// Never read before, or its notes, photo or voice note changed since.
  static bool _needsReading(
    PlannedMedicine? saved,
    DoctorVisit visit,
    VisitMedicine m,
  ) {
    if (saved == null) return true;
    // Set up before automatic reminders: left as the family set it.
    final source = saved.source;
    return source != null && source != MedicinePlanner.sourceOf(visit, m);
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    if (_started) repo.removeListener(schedule);
    super.dispose();
  }
}

class AutoScope extends InheritedNotifier<AutoReminders> {
  const AutoScope({
    super.key,
    required AutoReminders? auto,
    required super.child,
  }) : super(notifier: auto);

  /// Null where Gurtu runs without the server (tests).
  static AutoReminders? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AutoScope>()?.notifier;
}
