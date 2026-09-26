// Doctor visits and visit preparation. Like the rest of the care data, every
// record carries a patientId and answers are stored as enums, never as
// display text, so they read correctly in any app language.

import 'package:flutter/material.dart';

enum Symptom {
  fever(Icons.thermostat_rounded),
  headache(Icons.psychology_alt_rounded),
  bodyPain(Icons.accessibility_new_rounded),
  chestPain(Icons.favorite_rounded),
  breathless(Icons.air_rounded),
  cough(Icons.sick_rounded),
  dizziness(Icons.motion_photos_on_rounded),
  tiredness(Icons.battery_2_bar_rounded),
  stomach(Icons.lunch_dining_rounded),
  poorSleep(Icons.bedtime_rounded),
  poorAppetite(Icons.no_meals_rounded),
  lowMood(Icons.sentiment_dissatisfied_rounded);

  const Symptom(this.icon);
  final IconData icon;

  /// Severe forms of these should not wait for an appointment.
  bool get isRedFlag => this == chestPain || this == breathless;
}

enum SymptomSince { today, fewDays, week, monthPlus }

enum Severity { mild, moderate, severe }

/// One symptom and what the patient said about it.
class SymptomAnswer {
  SymptomAnswer(this.symptom, {this.since, this.severity});

  final Symptom symptom;
  SymptomSince? since;
  Severity? severity;

  bool get isUrgent => symptom.isRedFlag && severity == Severity.severe;

  Map<String, dynamic> toJson() => {
    'symptom': symptom.name,
    'since': since?.name,
    'severity': severity?.name,
  };

  factory SymptomAnswer.fromJson(Map<String, dynamic> j) => SymptomAnswer(
    Symptom.values.byName(j['symptom'] as String),
    since: j['since'] == null
        ? null
        : SymptomSince.values.byName(j['since'] as String),
    severity: j['severity'] == null
        ? null
        : Severity.values.byName(j['severity'] as String),
  );
}

/// Question templates. The text is resolved from l10n at display time, so a
/// saved list follows the app language; only [custom] and [tellDoctor] keep
/// the words the user typed or spoke.
enum QuestionKind {
  cause,
  tests,
  warningSigns,
  homeCare,
  conditionLink,
  sideEffect,
  medicinesStillRight,
  nextCheckup,
  tellDoctor,
  custom,
}

class DoctorQuestion {
  DoctorQuestion({
    required this.id,
    required this.kind,
    this.symptom,
    this.conditions = const [],
    this.text = '',
    this.asked = false,
  });

  final String id;
  final QuestionKind kind;
  final Symptom? symptom;

  /// `HealthCondition` names, for [QuestionKind.conditionLink].
  final List<String> conditions;

  /// User's own words, for [QuestionKind.custom] and [QuestionKind.tellDoctor].
  final String text;

  /// Ticked off during the visit.
  bool asked;

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'symptom': symptom?.name,
    'conditions': conditions,
    'text': text,
    'asked': asked,
  };

  factory DoctorQuestion.fromJson(Map<String, dynamic> j) => DoctorQuestion(
    id: j['id'] as String,
    kind: QuestionKind.values.byName(j['kind'] as String),
    symptom: j['symptom'] == null
        ? null
        : Symptom.values.byName(j['symptom'] as String),
    conditions: List<String>.from(j['conditions'] as List? ?? const []),
    text: j['text'] as String? ?? '',
    asked: j['asked'] as bool? ?? false,
  );
}

/// The result of "Questions for the doctor": what the patient reported and
/// the questions to take to the appointment.
class VisitPrep {
  VisitPrep({
    required this.id,
    required this.patientId,
    required this.createdAt,
    this.symptoms = const [],
    this.description = '',
    this.newMedicine,
    this.extraNote = '',
    List<DoctorQuestion>? questions,
    this.visitId,
  }) : questions = questions ?? [];

  final String id;
  final String patientId;
  final DateTime createdAt;
  final List<SymptomAnswer> symptoms;

  /// What the patient said or typed in their own words.
  final String description;

  /// Was a medicine started or changed recently? Null when not sure.
  final bool? newMedicine;
  final String extraNote;
  final List<DoctorQuestion> questions;

  /// Set once these questions were taken to a recorded visit.
  String? visitId;

  bool get isUsed => visitId != null;
  int get askedCount => questions.where((q) => q.asked).length;

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'createdAt': createdAt.toIso8601String(),
    'symptoms': [for (final s in symptoms) s.toJson()],
    'description': description,
    'newMedicine': newMedicine,
    'extraNote': extraNote,
    'questions': [for (final q in questions) q.toJson()],
    'visitId': visitId,
  };

  factory VisitPrep.fromJson(Map<String, dynamic> j) => VisitPrep(
    id: j['id'] as String,
    patientId: j['patientId'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    symptoms: [
      for (final s in (j['symptoms'] as List? ?? const []))
        SymptomAnswer.fromJson(s as Map<String, dynamic>),
    ],
    description: j['description'] as String? ?? '',
    newMedicine: j['newMedicine'] as bool?,
    extraNote: j['extraNote'] as String? ?? '',
    questions: [
      for (final q in (j['questions'] as List? ?? const []))
        DoctorQuestion.fromJson(q as Map<String, dynamic>),
    ],
    visitId: j['visitId'] as String?,
  );
}

/// Built-in sample visits. Their text is looked up in l10n at display time.
enum SampleVisit { diabetesReview, kneePain }

/// What happened at one appointment.
class DoctorVisit {
  DoctorVisit({
    required this.id,
    required this.patientId,
    required this.date,
    required this.createdBy,
    this.doctorName = '',
    this.reason = '',
    this.notes = '',
    this.medicines = '',
    this.tests = '',
    this.nextVisit,
    this.prepId,
    this.sample,
  });

  final String id;
  final String patientId;
  final DateTime date;

  /// CareMember id.
  final String createdBy;
  final String doctorName;
  final String reason;

  /// What the doctor said, spoken into the phone or typed.
  final String notes;
  final String medicines;
  final String tests;
  final DateTime? nextVisit;

  /// The [VisitPrep] whose questions were taken to this visit.
  final String? prepId;
  final SampleVisit? sample;

  bool get isSample => sample != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'date': date.toIso8601String(),
    'createdBy': createdBy,
    'doctorName': doctorName,
    'reason': reason,
    'notes': notes,
    'medicines': medicines,
    'tests': tests,
    'nextVisit': nextVisit?.toIso8601String(),
    'prepId': prepId,
    'sample': sample?.name,
  };

  factory DoctorVisit.fromJson(Map<String, dynamic> j) => DoctorVisit(
    id: j['id'] as String,
    patientId: j['patientId'] as String,
    date: DateTime.parse(j['date'] as String),
    createdBy: j['createdBy'] as String? ?? '',
    doctorName: j['doctorName'] as String? ?? '',
    reason: j['reason'] as String? ?? '',
    notes: j['notes'] as String? ?? '',
    medicines: j['medicines'] as String? ?? '',
    tests: j['tests'] as String? ?? '',
    nextVisit: j['nextVisit'] == null
        ? null
        : DateTime.parse(j['nextVisit'] as String),
    prepId: j['prepId'] as String?,
    sample: j['sample'] == null
        ? null
        : SampleVisit.values.byName(j['sample'] as String),
  );
}
