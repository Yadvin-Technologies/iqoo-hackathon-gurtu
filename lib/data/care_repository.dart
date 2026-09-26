import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/onboarding_state.dart';
import 'attachment_store.dart';
import 'care_models.dart';
import 'medicine_models.dart';
import 'visit_models.dart';

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
  final List<DoctorVisit> visits = [];
  final List<VisitPrep> preps = [];
  final List<Medicine> medicines = [];
  final List<DoseRecord> doses = [];
  String? _selectedId;
  bool setupCardDismissed = false;

  bool get hasPatient => patients.isNotEmpty;
  bool get hasSampleData =>
      patients.any((p) => p.isSample) ||
      members.any((m) => m.isSample) ||
      moments.any((m) => m.isSample) ||
      tasks.any((t) => t.isSample) ||
      visits.any((v) => v.isSample) ||
      medicines.any((m) => m.isSample);

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

  /// Doctor visits, newest first.
  List<DoctorVisit> get doctorVisits {
    final id = selectedPatient?.id;
    return visits.where((v) => v.patientId == id).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// The soonest follow-up a doctor asked for that is still ahead.
  DateTime? nextPlannedVisit([DateTime? now]) {
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    final dates = [
      for (final v in doctorVisits)
        if (v.nextVisit != null && !v.nextVisit!.isBefore(today)) v.nextVisit!,
    ]..sort();
    return dates.firstOrNull;
  }

  /// Latest questions not yet taken to a visit.
  VisitPrep? get openPrep {
    final id = selectedPatient?.id;
    final open = preps.where((p) => p.patientId == id && !p.isUsed).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return open.firstOrNull;
  }

  VisitPrep? prepById(String? id) =>
      preps.where((p) => p.id == id).cast<VisitPrep?>().firstOrNull;

  /// The selected patient's medicine list, A to Z.
  List<Medicine> get medicineList {
    final id = selectedPatient?.id;
    return medicines.where((m) => m.patientId == id).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  PatientProfile? patientById(String id) =>
      patients.where((p) => p.id == id).cast<PatientProfile?>().firstOrNull;

  /// When [medicine]'s [slot] dose was taken on the care day of [now].
  DoseRecord? doseTaken(Medicine medicine, DoseTime slot, [DateTime? now]) {
    final day = careDay(now ?? DateTime.now());
    return doses
        .where(
          (d) =>
              d.medicineId == medicine.id &&
              d.slot == slot &&
              d.day.isAtSameMomentAs(day),
        )
        .firstOrNull;
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
        careFor: d.careFor?.name,
        takesMedicines: d.takesMedicines?.name,
        // Only meaningful when they said they take medicines.
        medicineCount: d.takesMedicines == YesNoUnsure.yes
            ? d.medicineCount?.name
            : null,
        mobility: d.mobility?.name,
        recentHospitalVisit: d.recentHospitalVisit?.name,
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

  /// Saves new questions for the selected patient. Older unused ones are
  /// replaced so there is only ever one list to take to the doctor.
  VisitPrep? savePrep(VisitPrep Function(String id, String patientId) build) {
    final patient = selectedPatient;
    if (patient == null) return null;
    preps.removeWhere((p) => p.patientId == patient.id && !p.isUsed);
    final prep = build(
      'q_${DateTime.now().microsecondsSinceEpoch}',
      patient.id,
    );
    preps.add(prep);
    _save();
    return prep;
  }

  /// Call after changing a prep's questions in place.
  void updatePrep(VisitPrep prep) => _save();

  void deletePrep(VisitPrep prep) {
    preps.remove(prep);
    _save();
  }

  /// Records a visit for the selected patient. If questions were taken to
  /// it, they are marked as used.
  DoctorVisit? addVisit({
    required DateTime date,
    String doctorName = '',
    String reason = '',
    String notes = '',
    String medicines = '',
    String tests = '',
    DateTime? nextVisit,
    VisitPrep? prep,
    List<VisitAttachment> attachments = const [],
  }) {
    final patient = selectedPatient;
    if (patient == null) return null;
    final visit = DoctorVisit(
      id: 'v_${DateTime.now().microsecondsSinceEpoch}',
      patientId: patient.id,
      date: date,
      createdBy: you?.id ?? '',
      doctorName: doctorName.trim(),
      reason: reason.trim(),
      notes: notes.trim(),
      medicines: medicines.trim(),
      tests: tests.trim(),
      nextVisit: nextVisit,
      prepId: prep?.id,
      attachments: [...attachments],
    );
    visits.add(visit);
    prep?.visitId = visit.id;
    _save();
    return visit;
  }

  void addAttachment(DoctorVisit visit, VisitAttachment attachment) {
    visit.attachments.add(attachment);
    _save();
  }

  /// Removes it from the visit and deletes the file from the phone.
  void removeAttachment(DoctorVisit visit, VisitAttachment attachment) {
    visit.attachments.remove(attachment);
    AttachmentStore.instance.delete(attachment.file);
    _save();
  }

  /// Every photo and voice note still in use, for clearing out the rest.
  Set<String> get attachmentFiles => {
    for (final v in visits)
      for (final a in v.attachments) a.file,
  };

  void _deleteFiles(Iterable<DoctorVisit> gone) {
    for (final v in gone) {
      for (final a in v.attachments) {
        AttachmentStore.instance.delete(a.file);
      }
    }
  }

  void deleteVisit(DoctorVisit visit) {
    _deleteFiles([visit]);
    visits.remove(visit);
    // Its questions go with it; they belong to that appointment.
    preps.removeWhere((p) => p.visitId == visit.id);
    _save();
  }

  Medicine? addMedicine({
    required String name,
    String alsoCalled = '',
    String strength = '',
    List<DoseTime> times = const [],
    FoodTiming food = FoodTiming.any,
    MedicineSource source = MedicineSource.manual,
  }) {
    final patient = selectedPatient;
    if (patient == null || name.trim().isEmpty) return null;
    final now = DateTime.now();
    final medicine = Medicine(
      id: 'med_${now.microsecondsSinceEpoch}_${medicines.length}',
      patientId: patient.id,
      name: name.trim(),
      alsoCalled: alsoCalled.trim(),
      strength: strength.trim(),
      times: [
        for (final t in DoseTime.values)
          if (times.contains(t)) t,
      ],
      food: food,
      source: source,
      createdAt: now,
    );
    medicines.add(medicine);
    _save();
    return medicine;
  }

  void updateMedicine(Medicine medicine) {
    final i = medicines.indexWhere((m) => m.id == medicine.id);
    if (i < 0) return;
    medicines[i] = medicine;
    _save();
  }

  void deleteMedicine(Medicine medicine) {
    medicines.removeWhere((m) => m.id == medicine.id);
    doses.removeWhere((d) => d.medicineId == medicine.id);
    _save();
  }

  /// Marks [slot]'s dose as taken now. Taking it twice is prevented by the
  /// check screen, not here, so a mistaken tap can still be undone.
  void markTaken(Medicine medicine, DoseTime slot, [DateTime? now]) {
    final at = now ?? DateTime.now();
    if (doseTaken(medicine, slot, at) != null) return;
    doses.add(
      DoseRecord(
        medicineId: medicine.id,
        patientId: medicine.patientId,
        slot: slot,
        day: careDay(at),
        at: at,
        by: you?.id,
      ),
    );
    _save();
  }

  void undoTaken(Medicine medicine, DoseTime slot, [DateTime? now]) {
    final record = doseTaken(medicine, slot, now);
    if (record == null) return;
    doses.remove(record);
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
    medicines.add(
      Medicine(
        id: 'sample_med_nanna_1',
        patientId: second.id,
        name: 'Telmisartan',
        alsoCalled: 'Telma',
        strength: '40 mg',
        times: const [DoseTime.morning],
        food: FoodTiming.any,
        isSample: true,
        createdAt: DateTime.now(),
      ),
    );
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
    bool sampleVisit(DoctorVisit v) =>
        v.isSample || samplePatients.contains(v.patientId);
    _deleteFiles(visits.where(sampleVisit));
    visits.removeWhere(sampleVisit);
    preps.removeWhere((p) => samplePatients.contains(p.patientId));
    final sampleMeds = {
      for (final m in medicines)
        if (m.isSample || samplePatients.contains(m.patientId)) m.id,
    };
    medicines.removeWhere((m) => sampleMeds.contains(m.id));
    doses.removeWhere((d) => sampleMeds.contains(d.medicineId));
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

    visits.addAll([
      DoctorVisit(
        id: 'sample_v1',
        patientId: patientId,
        date: today.subtract(const Duration(days: 12, hours: -11)),
        createdBy: youId,
        doctorName: 'Dr. Meena Rao',
        sample: SampleVisit.diabetesReview,
        nextVisit: today.add(const Duration(days: 18)),
      ),
      DoctorVisit(
        id: 'sample_v2',
        patientId: patientId,
        date: today.subtract(const Duration(days: 47, hours: -17)),
        createdBy: sister,
        doctorName: 'Dr. Arjun Iyer',
        sample: SampleVisit.kneePain,
      ),
    ]);

    Medicine med(
      String id,
      String name,
      String alsoCalled,
      String strength,
      List<DoseTime> times,
      FoodTiming food,
    ) => Medicine(
      id: 'sample_med_$id',
      patientId: patientId,
      name: name,
      alsoCalled: alsoCalled,
      strength: strength,
      times: times,
      food: food,
      source: MedicineSource.prescription,
      isSample: true,
      createdAt: now,
    );
    // Drug names read the same in every language.
    medicines.addAll([
      med('1', 'Metformin', 'Glycomet', '500 mg', const [
        DoseTime.morning,
        DoseTime.night,
      ], FoodTiming.afterFood),
      med('2', 'Amlodipine', 'Amlong', '5 mg', const [
        DoseTime.morning,
      ], FoodTiming.any),
      med('3', 'Atorvastatin', 'Atorva', '10 mg', const [
        DoseTime.night,
      ], FoodTiming.afterFood),
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
      visits.addAll(list('visits').map(DoctorVisit.fromJson));
      preps.addAll(list('preps').map(VisitPrep.fromJson));
      medicines.addAll(list('medicines').map(Medicine.fromJson));
      doses.addAll(list('doses').map(DoseRecord.fromJson));
    } catch (_) {
      // Unreadable data from an older build: start clean rather than crash.
      patients.clear();
      members.clear();
      moments.clear();
      tasks.clear();
      visits.clear();
      preps.clear();
      medicines.clear();
      doses.clear();
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
        'visits': [for (final v in visits) v.toJson()],
        'preps': [for (final p in preps) p.toJson()],
        'medicines': [for (final m in medicines) m.toJson()],
        'doses': [for (final d in doses) d.toJson()],
      }),
    );
    notifyListeners();
  }

  /// Wipes everything (used by "Restart onboarding").
  void clear() {
    AttachmentStore.instance.prune({});
    patients.clear();
    members.clear();
    moments.clear();
    tasks.clear();
    visits.clear();
    preps.clear();
    medicines.clear();
    doses.clear();
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
