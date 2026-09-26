import 'package:flutter/material.dart';

import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../onboarding/onboarding_state.dart';

/// Localized labels for visits and visit preparation. Sample content and
/// question templates resolve through l10n; typed or spoken text is shown
/// exactly as entered.
extension VisitText on AppLocalizations {
  String symptomLabel(Symptom s) => switch (s) {
    Symptom.fever => symFever,
    Symptom.headache => symHeadache,
    Symptom.bodyPain => symBodyPain,
    Symptom.chestPain => symChestPain,
    Symptom.breathless => symBreathless,
    Symptom.cough => symCough,
    Symptom.dizziness => symDizziness,
    Symptom.tiredness => symTiredness,
    Symptom.stomach => symStomach,
    Symptom.poorSleep => symPoorSleep,
    Symptom.poorAppetite => symPoorAppetite,
    Symptom.lowMood => symLowMood,
  };

  String _keywords(Symptom s) => switch (s) {
    Symptom.fever => kwFever,
    Symptom.headache => kwHeadache,
    Symptom.bodyPain => kwBodyPain,
    Symptom.chestPain => kwChestPain,
    Symptom.breathless => kwBreathless,
    Symptom.cough => kwCough,
    Symptom.dizziness => kwDizziness,
    Symptom.tiredness => kwTiredness,
    Symptom.stomach => kwStomach,
    Symptom.poorSleep => kwPoorSleep,
    Symptom.poorAppetite => kwPoorAppetite,
    Symptom.lowMood => kwLowMood,
  };

  /// Words that point to each symptom, in this language plus English, since
  /// people often mix English words ("BP", "fever") into their own language.
  Map<Symptom, List<String>> get symptomKeywords {
    final en = lookupAppLocalizations(const Locale('en'));
    return {
      for (final s in Symptom.values)
        s: {
          symptomLabel(s),
          ..._keywords(s).split(','),
          en.symptomLabel(s),
          ...en._keywords(s).split(','),
        }.map((w) => w.trim()).where((w) => w.isNotEmpty).toList(),
    };
  }

  String sinceLabel(SymptomSince s) => switch (s) {
    SymptomSince.today => sinceToday,
    SymptomSince.fewDays => sinceFewDays,
    SymptomSince.week => sinceWeek,
    SymptomSince.monthPlus => sinceMonth,
  };

  String severityLabel(Severity s) => switch (s) {
    Severity.mild => sevMild,
    Severity.moderate => sevModerate,
    Severity.severe => sevSevere,
  };

  String questionText(DoctorQuestion q) {
    // Mid-sentence, so lower case in scripts that have case.
    final symptom = q.symptom == null
        ? ''
        : symptomLabel(q.symptom!).toLowerCase();
    return switch (q.kind) {
      QuestionKind.cause => qCause(symptom),
      QuestionKind.tests => qTests(symptom),
      QuestionKind.warningSigns => qWarningSigns(symptom),
      QuestionKind.homeCare => qHomeCare(symptom),
      QuestionKind.conditionLink => qConditionLink(
        symptom,
        [
          for (final c in q.conditions)
            if (HealthCondition.values.asNameMap()[c] case final cond?)
              cond.label(this),
        ].join(', '),
      ),
      QuestionKind.sideEffect => qSideEffect,
      QuestionKind.medicinesStillRight => qMedicinesStillRight,
      QuestionKind.nextCheckup => qNextCheckup,
      QuestionKind.tellDoctor => qTellDoctor(q.text),
      QuestionKind.custom => q.text,
    };
  }

  String doctorLabel(DoctorVisit v) =>
      v.doctorName.isEmpty ? doctorFallback : v.doctorName;

  String reasonOf(DoctorVisit v) => switch (v.sample) {
    SampleVisit.diabetesReview => sampleVisitDiabetesReason,
    SampleVisit.kneePain => sampleVisitKneeReason,
    null => v.reason,
  };

  String notesOf(DoctorVisit v) => switch (v.sample) {
    SampleVisit.diabetesReview => sampleVisitDiabetesNotes,
    SampleVisit.kneePain => sampleVisitKneeNotes,
    null => v.notes,
  };

  String medicinesOf(DoctorVisit v) => switch (v.sample) {
    SampleVisit.diabetesReview => sampleVisitDiabetesMeds,
    SampleVisit.kneePain => sampleVisitKneeMeds,
    null => v.medicines,
  };

  String testsOf(DoctorVisit v) => switch (v.sample) {
    SampleVisit.diabetesReview => sampleVisitDiabetesTests,
    SampleVisit.kneePain => '',
    null => v.tests,
  };
}

/// "12 Sep 2026" in the app language.
String dateLabel(BuildContext context, DateTime d) =>
    MaterialLocalizations.of(context).formatMediumDate(d);
