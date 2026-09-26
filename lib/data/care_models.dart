// Care data for Home and the sections that follow. Everything is scoped by
// patientId so one person's care information never mixes with another's.

enum CareRole { patient, caregiver, family, helper }

enum MomentType { voice, scan, vital, document, note, medicine }

enum TaskStatus { pending, done }

/// Built-in sample content. Its text is looked up in l10n at display time so
/// it follows the app language; real user content is stored as typed.
enum SampleText {
  taskMorningMedicine,
  taskRecordBp,
  taskBloodTest,
  taskDoctorVisit,
  momentDoctorTalk,
  momentPrescription,
  momentBp,
}

class PatientProfile {
  PatientProfile({
    required this.id,
    required this.name,
    this.age,
    this.gender,
    this.conditions = const [],
    this.allergies = const [],
    this.isSelf = false,
    this.isSample = false,
    required this.createdAt,
  });

  final String id;
  final String name;
  final int? age;
  final String? gender;

  /// `HealthCondition` / `Allergy` enum names from onboarding.
  final List<String> conditions;
  final List<String> allergies;

  /// The app user is caring for themself.
  final bool isSelf;
  final bool isSample;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'gender': gender,
    'conditions': conditions,
    'allergies': allergies,
    'isSelf': isSelf,
    'isSample': isSample,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PatientProfile.fromJson(Map<String, dynamic> j) => PatientProfile(
    id: j['id'] as String,
    name: j['name'] as String,
    age: j['age'] as int?,
    gender: j['gender'] as String?,
    conditions: List<String>.from(j['conditions'] as List? ?? const []),
    allergies: List<String>.from(j['allergies'] as List? ?? const []),
    isSelf: j['isSelf'] as bool? ?? false,
    isSample: j['isSample'] as bool? ?? false,
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
}

/// A person in one patient's Care Circle.
class CareMember {
  CareMember({
    required this.id,
    required this.patientId,
    required this.name,
    required this.role,
    this.isYou = false,
    this.isSample = false,
  });

  final String id;
  final String patientId;
  final String name;
  final CareRole role;
  final bool isYou;
  final bool isSample;

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'name': name,
    'role': role.name,
    'isYou': isYou,
    'isSample': isSample,
  };

  factory CareMember.fromJson(Map<String, dynamic> j) => CareMember(
    id: j['id'] as String,
    patientId: j['patientId'] as String,
    name: j['name'] as String,
    role: CareRole.values.byName(j['role'] as String),
    isYou: j['isYou'] as bool? ?? false,
    isSample: j['isSample'] as bool? ?? false,
  );
}

/// Where a piece of care memory came from. Every AI-derived item keeps one so
/// the original can be opened.
class SourceRef {
  const SourceRef({required this.type, this.reference});

  final MomentType type;

  /// File path / id of the original recording, scan or photo, once capture
  /// exists. Null for typed notes and for sample data.
  final String? reference;

  Map<String, dynamic> toJson() => {'type': type.name, 'reference': reference};

  factory SourceRef.fromJson(Map<String, dynamic> j) => SourceRef(
    type: MomentType.values.byName(j['type'] as String),
    reference: j['reference'] as String?,
  );
}

class CareMoment {
  CareMoment({
    required this.id,
    required this.patientId,
    required this.createdBy,
    required this.type,
    required this.timestamp,
    required this.source,
    this.title = '',
    this.detail = '',
    this.sample,
    this.verified = false,
  });

  final String id;
  final String patientId;

  /// CareMember id.
  final String createdBy;
  final MomentType type;
  final String title;
  final String detail;
  final SampleText? sample;
  final DateTime timestamp;
  final SourceRef source;
  final bool verified;

  bool get isSample => sample != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'createdBy': createdBy,
    'type': type.name,
    'title': title,
    'detail': detail,
    'sample': sample?.name,
    'timestamp': timestamp.toIso8601String(),
    'source': source.toJson(),
    'verified': verified,
  };

  factory CareMoment.fromJson(Map<String, dynamic> j) => CareMoment(
    id: j['id'] as String,
    patientId: j['patientId'] as String,
    createdBy: j['createdBy'] as String,
    type: MomentType.values.byName(j['type'] as String),
    title: j['title'] as String? ?? '',
    detail: j['detail'] as String? ?? '',
    sample: j['sample'] == null
        ? null
        : SampleText.values.byName(j['sample'] as String),
    timestamp: DateTime.parse(j['timestamp'] as String),
    source: SourceRef.fromJson(j['source'] as Map<String, dynamic>),
    verified: j['verified'] as bool? ?? false,
  );
}

class CareTask {
  CareTask({
    required this.id,
    required this.patientId,
    required this.dueDate,
    this.title = '',
    this.sample,
    this.assignedTo,
    this.status = TaskStatus.pending,
    this.completedAt,
    this.completedBy,
  });

  final String id;
  final String patientId;
  final String title;
  final SampleText? sample;

  /// CareMember id, or null when open to the whole Care Circle.
  final String? assignedTo;
  final DateTime dueDate;
  TaskStatus status;
  DateTime? completedAt;
  String? completedBy;

  bool get isSample => sample != null;
  bool get isDone => status == TaskStatus.done;

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'title': title,
    'sample': sample?.name,
    'assignedTo': assignedTo,
    'dueDate': dueDate.toIso8601String(),
    'status': status.name,
    'completedAt': completedAt?.toIso8601String(),
    'completedBy': completedBy,
  };

  factory CareTask.fromJson(Map<String, dynamic> j) => CareTask(
    id: j['id'] as String,
    patientId: j['patientId'] as String,
    title: j['title'] as String? ?? '',
    sample: j['sample'] == null
        ? null
        : SampleText.values.byName(j['sample'] as String),
    assignedTo: j['assignedTo'] as String?,
    dueDate: DateTime.parse(j['dueDate'] as String),
    status: TaskStatus.values.byName(j['status'] as String),
    completedAt: j['completedAt'] == null
        ? null
        : DateTime.parse(j['completedAt'] as String),
    completedBy: j['completedBy'] as String?,
  );
}
