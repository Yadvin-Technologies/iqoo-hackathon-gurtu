/// What the backend knows about this install.
class DeviceInfo {
  const DeviceInfo({
    this.fcmToken,
    required this.platform,
    required this.language,
    required this.timezone,
    this.notificationsAllowed,
  });

  /// Null when the phone has none yet: then it's left out, so the server
  /// keeps the last good one instead of forgetting it.
  final String? fcmToken;
  final String platform;
  final String language;
  final String timezone;

  /// Android lets Gurtu show notifications. Null when unknown.
  final bool? notificationsAllowed;

  Map<String, dynamic> toJson() => {
    'fcmToken': ?fcmToken,
    'platform': platform,
    'language': language,
    'timezone': timezone,
    'notificationsAllowed': ?notificationsAllowed,
  };
}

/// One person in a care circle.
class CircleMember {
  const CircleMember({
    required this.id,
    required this.name,
    required this.role,
    this.isOwner = false,
    this.isYou = false,
    this.usesApp = false,
    this.notificationsOn = false,
  });

  final String id;
  final String name;

  /// `patient`, `caregiver`, `family` or `helper` (`CareRole` names).
  final String role;
  final bool isOwner;
  final bool isYou;

  /// False for a patient who doesn't have Gurtu on their own phone.
  final bool usesApp;

  /// Their phone can receive reminders.
  final bool notificationsOn;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'isOwner': isOwner,
    'isYou': isYou,
    'usesApp': usesApp,
    'notificationsOn': notificationsOn,
  };

  factory CircleMember.fromJson(Map<String, dynamic> j) => CircleMember(
    id: j['id'] as String,
    name: j['name'] as String? ?? '',
    role: j['role'] as String? ?? 'family',
    isOwner: j['isOwner'] as bool? ?? false,
    isYou: j['isYou'] as bool? ?? false,
    usesApp: j['usesApp'] as bool? ?? false,
    notificationsOn: j['notificationsOn'] as bool? ?? false,
  );
}

/// A family's shared care circle: the person cared for, everyone helping,
/// and the 6-digit code others join with.
class CircleInfo {
  const CircleInfo({
    required this.id,
    required this.code,
    required this.patient,
    required this.members,
    this.isOwner = false,
  });

  final String id;
  final String code;

  /// The onboarding profile, as enum names (see `PatientProfile`).
  final Map<String, dynamic> patient;
  final List<CircleMember> members;

  /// This device created the circle (can make a new code).
  final bool isOwner;

  String get patientName => patient['name'] as String? ?? '';

  /// This phone belongs to the person being cared for.
  bool get iAmPatient => members.any((m) => m.isYou && m.role == 'patient');

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'patient': patient,
    'members': [for (final m in members) m.toJson()],
    'me': {'isOwner': isOwner},
  };

  factory CircleInfo.fromJson(Map<String, dynamic> j) => CircleInfo(
    id: j['id'] as String,
    code: j['code'] as String,
    patient: Map<String, dynamic>.from(j['patient'] as Map? ?? const {}),
    members: [
      for (final m in j['members'] as List? ?? const [])
        CircleMember.fromJson(m as Map<String, dynamic>),
    ],
    isOwner: (j['me'] as Map?)?['isOwner'] as bool? ?? false,
  );
}
