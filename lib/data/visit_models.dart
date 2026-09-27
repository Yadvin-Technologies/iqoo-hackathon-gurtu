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
/// saved list follows the app language; only [custom], [tellDoctor] and [ai]
/// keep their words as written.
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

  /// Written by the on-device model, in the language used at the time.
  ai,
}

/// What a question helps the family understand, so the list reads in the
/// order a consultation goes.
enum QuestionTopic { understand, tests, treatment, home, followUp }

/// One follow-up the assistant asked while preparing, with the answer given.
class IntakeAnswer {
  const IntakeAnswer({
    required this.question,
    required this.answer,
    this.id,
    this.choice,
  });

  /// As shown, in the language used at the time.
  final String question;
  final String answer;

  /// The question's id in the question bank (`visit_knowledge.dart`), or
  /// `ai_…` for one Gurtu AI wrote itself.
  final String? id;

  /// Index of the tapped option; null when the answer was typed or spoken.
  final int? choice;

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    'id': id,
    'choice': choice,
  };

  factory IntakeAnswer.fromJson(Map<String, dynamic> j) => IntakeAnswer(
    question: j['question'] as String? ?? '',
    answer: j['answer'] as String? ?? '',
    id: j['id'] as String?,
    choice: j['choice'] as int?,
  );
}

class DoctorQuestion {
  DoctorQuestion({
    required this.id,
    required this.kind,
    this.symptom,
    this.conditions = const [],
    this.text = '',
    this.topic,
    this.asked = false,
  });

  final String id;
  final QuestionKind kind;
  final Symptom? symptom;

  /// Set on questions written by the model; null on template questions.
  final QuestionTopic? topic;

  /// `HealthCondition` names, for [QuestionKind.conditionLink].
  final List<String> conditions;

  /// Words as written, for [QuestionKind.custom], [QuestionKind.tellDoctor]
  /// and [QuestionKind.ai].
  final String text;

  /// Ticked off during the visit.
  bool asked;

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'symptom': symptom?.name,
    'conditions': conditions,
    'text': text,
    'topic': topic?.name,
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
    topic: QuestionTopic.values.asNameMap()[j['topic']],
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
    this.intake = const [],
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

  /// The follow-up questions Gurtu AI asked, with the answers given.
  final List<IntakeAnswer> intake;
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
    'intake': [for (final a in intake) a.toJson()],
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
    intake: [
      for (final a in (j['intake'] as List? ?? const []))
        IntakeAnswer.fromJson(a as Map<String, dynamic>),
    ],
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
    List<VisitMedicine>? medicines,
    this.tests = '',
    this.nextVisit,
    this.prepId,
    this.sample,
    List<VisitAttachment>? attachments,
  }) : medicines = medicines ?? [],
       attachments = attachments ?? [];

  final String id;
  final String patientId;
  final DateTime date;

  /// CareMember id.
  final String createdBy;
  final String doctorName;
  final String reason;

  /// What the doctor said, spoken into the phone or typed.
  final String notes;

  /// Each medicine the doctor gave, with its photos and voice notes.
  final List<VisitMedicine> medicines;

  /// No longer asked for when recording; kept for visits that have it.
  final String tests;
  final DateTime? nextVisit;

  /// The [VisitPrep] whose questions were taken to this visit.
  final String? prepId;
  final SampleVisit? sample;

  /// Photos and voice notes, added while recording or later.
  final List<VisitAttachment> attachments;

  bool get isSample => sample != null;

  List<VisitAttachment> attachmentsFor(VisitSection section) => [
    for (final a in attachments)
      if (a.section == section) a,
  ];

  /// Photos and voice notes of one of [medicines].
  List<VisitAttachment> attachmentsOf(VisitMedicine medicine) => [
    for (final a in attachments)
      if (a.itemId == medicine.id) a,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'date': date.toIso8601String(),
    'createdBy': createdBy,
    'doctorName': doctorName,
    'reason': reason,
    'notes': notes,
    'medicineList': [for (final m in medicines) m.toJson()],
    'tests': tests,
    'nextVisit': nextVisit?.toIso8601String(),
    'prepId': prepId,
    'sample': sample?.name,
    'attachments': [for (final a in attachments) a.toJson()],
  };

  factory DoctorVisit.fromJson(Map<String, dynamic> j) {
    final id = j['id'] as String;
    var attachments = [
      for (final a in j['attachments'] as List? ?? const [])
        VisitAttachment.fromJson(a as Map<String, dynamic>),
    ];
    final List<VisitMedicine> medicines;
    if (j['medicineList'] case final List list) {
      medicines = [
        for (final m in list) VisitMedicine.fromJson(m as Map<String, dynamic>),
      ];
    } else {
      // Saved before medicines were a list: one text and loose photos
      // become the first medicine.
      final text = (j['medicines'] as String? ?? '').trim();
      final loose = attachments.any(
        (a) => a.section == VisitSection.medicines && a.itemId == null,
      );
      final first = VisitMedicine(id: 'vm_${id}_0', note: text);
      medicines = [if (text.isNotEmpty || loose) first];
      attachments = [
        for (final a in attachments)
          a.section == VisitSection.medicines && a.itemId == null
              ? a.forItem(first.id)
              : a,
      ];
    }
    return DoctorVisit(
      id: id,
      patientId: j['patientId'] as String,
      date: DateTime.parse(j['date'] as String),
      createdBy: j['createdBy'] as String? ?? '',
      doctorName: j['doctorName'] as String? ?? '',
      reason: j['reason'] as String? ?? '',
      notes: j['notes'] as String? ?? '',
      medicines: medicines,
      tests: j['tests'] as String? ?? '',
      nextVisit: j['nextVisit'] == null
          ? null
          : DateTime.parse(j['nextVisit'] as String),
      prepId: j['prepId'] as String?,
      sample: j['sample'] == null
          ? null
          : SampleVisit.values.byName(j['sample'] as String),
      attachments: attachments,
    );
  }
}

/// One medicine the doctor gave: its name and how to take it, as typed or
/// spoken. Photos of the strip or prescription and a voice note of what the
/// doctor said about it are [VisitAttachment]s with this [id].
class VisitMedicine {
  const VisitMedicine({required this.id, this.note = ''});

  final String id;
  final String note;

  VisitMedicine withNote(String note) => VisitMedicine(id: id, note: note);

  Map<String, dynamic> toJson() => {'id': id, 'note': note};

  factory VisitMedicine.fromJson(Map<String, dynamic> j) =>
      VisitMedicine(id: j['id'] as String, note: j['note'] as String? ?? '');
}

/// The part of a visit a photo or voice note belongs to. [doctor] holds
/// recordings of the doctor talking. [tests] is no longer offered when
/// recording; older visits may still have them.
enum VisitSection { medicines, tests, nextVisit, doctor }

enum AttachmentKind { photo, audio }

/// A photo (prescription, test slip, appointment card) or a voice note kept
/// with a visit. The file lives in the app's own storage on this phone
/// (`AttachmentStore`); only its name is saved here, so the record survives
/// the app's folder moving.
class VisitAttachment {
  const VisitAttachment({
    required this.id,
    required this.kind,
    required this.section,
    required this.file,
    required this.createdAt,
    this.duration,
    this.itemId,
  });

  final String id;
  final AttachmentKind kind;
  final VisitSection section;

  /// The [VisitMedicine] it belongs to, for medicine photos and notes.
  final String? itemId;

  /// File name inside the attachment folder.
  final String file;
  final DateTime createdAt;

  /// How long a voice note is.
  final Duration? duration;

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'section': section.name,
    'file': file,
    'createdAt': createdAt.toIso8601String(),
    'durationMs': duration?.inMilliseconds,
    'itemId': itemId,
  };

  VisitAttachment forItem(String itemId) => VisitAttachment(
    id: id,
    kind: kind,
    section: section,
    file: file,
    createdAt: createdAt,
    duration: duration,
    itemId: itemId,
  );

  factory VisitAttachment.fromJson(Map<String, dynamic> j) => VisitAttachment(
    id: j['id'] as String,
    kind: AttachmentKind.values.byName(j['kind'] as String),
    section: VisitSection.values.byName(j['section'] as String),
    file: j['file'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    duration: j['durationMs'] == null
        ? null
        : Duration(milliseconds: j['durationMs'] as int),
    itemId: j['itemId'] as String?,
  );
}
