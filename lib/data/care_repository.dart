import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/onboarding_state.dart';
import 'care_models.dart';

/// Local store for all care data. Every read for the UI goes through
/// [selectedPatient], so switching patients switches the whole context.
///
/// Local-first (SharedPreferences JSON) for now; a sync backend can sit
/// behind this class later without the UI changing.
class CareRepository extends ChangeNotifier {
  CareRepository(this._prefs) {
    _load();
  }

  static const _key = 'care_data_v1';
  final SharedPreferences _prefs;

  String userName = '';
  final List<PatientProfile> patients = [];
  final List<CareMember> members = [];
  final List<CareMoment> moments = [];
  final List<CareTask> tasks = [];
  String? _selectedId;
  bool setupCardDismissed = false;

  bool get hasPatient => patients.isNotEmpty;
  bool get hasSampleData =>
      patients.any((p) => p.isSample) ||
      members.any((m) => m.isSample) ||
      moments.any((m) => m.isSample) ||
      tasks.any((t) => t.isSample);

  PatientProfile? get selectedPatient {
    if (patients.isEmpty) return null;
    return patients.firstWhere(
      (p) => p.id == _selectedId,
      orElse: () => patients.first,
    );
  }

  // --- Reads, always for the selected patient only ---------------------------

  List<CareMember> get circle {
    final id = selectedPatient?.id;
    final list = members.where((m) => m.patientId == id).toList();
    // Patient first, then you, then everyone else.
    int rank(CareMember m) =>
        m.role == CareRole.patient ? 0 : (m.isYou ? 1 : 2);
    list.sort((a, b) => rank(a).compareTo(rank(b)));
    return list;
  }

  CareMember? get you =>
      circle.where((m) => m.isYou).cast<CareMember?>().firstOrNull;

  CareMember? memberById(String? id) =>
      members.where((m) => m.id == id).cast<CareMember?>().firstOrNull;

  List<CareMoment> get recentMoments {
    final id = selectedPatient?.id;
    return moments.where((m) => m.patientId == id).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<CareTask> todaysTasks([DateTime? now]) {
    final id = selectedPatient?.id;
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    return tasks
        .where(
          (t) => t.patientId == id && DateUtils.isSameDay(t.dueDate, today),
        )
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  /// Pending tasks for today whose time has already passed.
  bool needsAttention([DateTime? now]) {
    final t = now ?? DateTime.now();
    return todaysTasks(t).any((x) => !x.isDone && x.dueDate.isBefore(t));
  }

  /// "Getting Gurtu ready" steps.
  bool get hasCareCircle =>
      circle.any((m) => !m.isYou && m.role != CareRole.patient);

  // TODO: true once Phase 5 (emergency contacts) exists.
  bool get hasEmergencyContact => false;

  // --- Writes ------------------------------------------------------------------

  /// Saves what was collected during onboarding as the first patient.
  void createFromOnboarding(OnboardingState d) {
    final now = DateTime.now();
    final patientId = 'p_${now.microsecondsSinceEpoch}';
    userName = (d.isForSelf ? d.patientName : d.yourName).trim();
    patients.add(
      PatientProfile(
        id: patientId,
        name: d.patientName.trim(),
        age: d.age,
        gender: d.gender?.name,
        conditions: [
          for (final c in d.conditions)
            if (c != HealthCondition.none) c.name,
        ],
        allergies: [
          for (final a in d.allergies)
            if (a != Allergy.none && a != Allergy.unsure) a.name,
        ],
        isSelf: d.isForSelf,
        createdAt: now,
      ),
    );
    members.add(
      CareMember(
        id: '${patientId}_patient',
        patientId: patientId,
        name: d.patientName.trim(),
        role: CareRole.patient,
        isYou: d.isForSelf,
      ),
    );
    if (!d.isForSelf) {
      members.add(
        CareMember(
          id: '${patientId}_you',
          patientId: patientId,
          name: userName,
          role: CareRole.caregiver,
          isYou: true,
        ),
      );
    }
    _selectedId = patientId;
    _save();
  }

  void selectPatient(String id) {
    _selectedId = id;
    _save();
  }

  void toggleTask(CareTask task) {
    if (task.isDone) {
      task
        ..status = TaskStatus.pending
        ..completedAt = null
        ..completedBy = null;
    } else {
      task
        ..status = TaskStatus.done
        ..completedAt = DateTime.now()
        ..completedBy = you?.id;
    }
    _save();
  }

  void addNote(String text) {
    final patient = selectedPatient;
    if (patient == null || text.trim().isEmpty) return;
    final now = DateTime.now();
    moments.add(
      CareMoment(
        id: 'm_${now.microsecondsSinceEpoch}',
        patientId: patient.id,
        createdBy: you?.id ?? '',
        type: MomentType.note,
        detail: text.trim(),
        timestamp: now,
        source: const SourceRef(type: MomentType.note),
      ),
    );
    _save();
  }

  void dismissSetupCard() {
    setupCardDismissed = true;
    _save();
  }

  /// Adds clearly marked sample content so the dashboard can be previewed.
  void addSampleData({required String secondPatientName}) {
    final patient = selectedPatient;
    if (patient == null || hasSampleData) return;
    _sampleFor(patient.id, withCircle: true);

    final second = PatientProfile(
      id: 'sample_patient_2',
      name: secondPatientName,
      age: 72,
      isSample: true,
      createdAt: DateTime.now(),
    );
    patients.add(second);
    members.add(
      CareMember(
        id: 'sample_patient_2_patient',
        patientId: second.id,
        name: second.name,
        role: CareRole.patient,
        isSample: true,
      ),
    );
    if (you != null) {
      members.add(
        CareMember(
          id: 'sample_patient_2_you',
          patientId: second.id,
          name: userName,
          role: CareRole.caregiver,
          isYou: true,
          isSample: true,
        ),
      );
    }
    // Deliberately lighter so switching visibly changes the context.
    final today = DateUtils.dateOnly(DateTime.now());
    tasks.add(
      CareTask(
        id: 'sample_t2_1',
        patientId: second.id,
        sample: SampleText.taskMorningMedicine,
        dueDate: today.add(const Duration(hours: 20)),
      ),
    );
    _save();
  }

  void removeSampleData() {
    final samplePatients = {
      for (final p in patients)
        if (p.isSample) p.id,
    };
    patients.removeWhere((p) => p.isSample);
    members.removeWhere(
      (m) => m.isSample || samplePatients.contains(m.patientId),
    );
    moments.removeWhere(
      (m) => m.isSample || samplePatients.contains(m.patientId),
    );
    tasks.removeWhere(
      (t) => t.isSample || samplePatients.contains(t.patientId),
    );
    if (samplePatients.contains(_selectedId)) _selectedId = patients.first.id;
    _save();
  }

  void _sampleFor(String patientId, {required bool withCircle}) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final youId = you?.id ?? '';
    var sister = youId;
    if (withCircle) {
      final extra = [('Anu', CareRole.family), ('Ravi', CareRole.helper)];
      for (final (name, role) in extra) {
        final m = CareMember(
          id: '${patientId}_sample_$name',
          patientId: patientId,
          name: name,
          role: role,
          isSample: true,
        );
        members.add(m);
        if (role == CareRole.family) sister = m.id;
      }
    }

    tasks.addAll([
      CareTask(
        id: 'sample_t1',
        patientId: patientId,
        sample: SampleText.taskMorningMedicine,
        assignedTo: youId,
        dueDate: today.add(const Duration(hours: 8)),
        status: TaskStatus.done,
        completedAt: today.add(const Duration(hours: 8, minutes: 10)),
        completedBy: youId,
      ),
      CareTask(
        id: 'sample_t2',
        patientId: patientId,
        sample: SampleText.taskRecordBp,
        assignedTo: youId,
        dueDate: today.add(const Duration(hours: 9)),
        status: TaskStatus.done,
        completedAt: today.add(const Duration(hours: 9, minutes: 5)),
        completedBy: youId,
      ),
      CareTask(
        id: 'sample_t3',
        patientId: patientId,
        sample: SampleText.taskBloodTest,
        assignedTo: sister,
        dueDate: today.add(const Duration(hours: 16)),
      ),
      CareTask(
        id: 'sample_t4',
        patientId: patientId,
        sample: SampleText.taskDoctorVisit,
        dueDate: today.add(const Duration(hours: 18, minutes: 30)),
      ),
    ]);

    moments.addAll([
      CareMoment(
        id: 'sample_m1',
        patientId: patientId,
        createdBy: youId,
        type: MomentType.voice,
        sample: SampleText.momentDoctorTalk,
        timestamp: now.subtract(const Duration(hours: 2)),
        source: const SourceRef(type: MomentType.voice),
      ),
      CareMoment(
        id: 'sample_m2',
        patientId: patientId,
        createdBy: sister,
        type: MomentType.scan,
        sample: SampleText.momentPrescription,
        timestamp: today.subtract(const Duration(hours: 6)),
        source: const SourceRef(type: MomentType.scan),
      ),
      CareMoment(
        id: 'sample_m3',
        patientId: patientId,
        createdBy: youId,
        type: MomentType.vital,
        sample: SampleText.momentBp,
        timestamp: today.subtract(const Duration(hours: 15, minutes: 30)),
        source: const SourceRef(type: MomentType.vital),
      ),
    ]);
  }

  // --- Persistence -----------------------------------------------------------

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      userName = j['userName'] as String? ?? '';
      _selectedId = j['selectedId'] as String?;
      setupCardDismissed = j['setupCardDismissed'] as bool? ?? false;
      List<Map<String, dynamic>> list(String k) =>
          (j[k] as List? ?? const []).cast<Map<String, dynamic>>();
      patients.addAll(list('patients').map(PatientProfile.fromJson));
      members.addAll(list('members').map(CareMember.fromJson));
      moments.addAll(list('moments').map(CareMoment.fromJson));
      tasks.addAll(list('tasks').map(CareTask.fromJson));
    } catch (_) {
      // Unreadable data from an older build: start clean rather than crash.
      patients.clear();
      members.clear();
      moments.clear();
      tasks.clear();
    }
  }

  void _save() {
    _prefs.setString(
      _key,
      jsonEncode({
        'userName': userName,
        'selectedId': _selectedId,
        'setupCardDismissed': setupCardDismissed,
        'patients': [for (final p in patients) p.toJson()],
        'members': [for (final m in members) m.toJson()],
        'moments': [for (final m in moments) m.toJson()],
        'tasks': [for (final t in tasks) t.toJson()],
      }),
    );
    notifyListeners();
  }

  /// Wipes everything (used by "Restart onboarding").
  void clear() {
    patients.clear();
    members.clear();
    moments.clear();
    tasks.clear();
    userName = '';
    _selectedId = null;
    setupCardDismissed = false;
    _prefs.remove(_key);
    notifyListeners();
  }
}

class CareScope extends InheritedNotifier<CareRepository> {
  const CareScope({
    super.key,
    required CareRepository repository,
    required super.child,
  }) : super(notifier: repository);

  static CareRepository of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CareScope>()!.notifier!;
}
