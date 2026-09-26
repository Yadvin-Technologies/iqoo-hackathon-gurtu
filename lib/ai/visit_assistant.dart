import '../data/care_models.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import 'visit_knowledge.dart';

/// What the patient told Gurtu while preparing for a visit.
class PrepAnswers {
  const PrepAnswers({
    required this.symptoms,
    this.description = '',
    this.newMedicine,
    this.extraNote = '',
    this.intake = const [],
  });

  final List<SymptomAnswer> symptoms;
  final String description;
  final bool? newMedicine;
  final String extraNote;

  /// Answers to the follow-ups Gurtu AI chose to ask.
  final List<IntakeAnswer> intake;
}

/// A follow-up question for the family, with one-tap answers, as shown.
class FollowUp {
  const FollowUp({
    required this.id,
    required this.question,
    this.options = const [],
  });

  /// The question's id in the question bank.
  final String id;
  final String question;

  /// Same order as the bank's, so a tap maps back to the bank's option.
  final List<AnswerOption> options;
}

/// How the conversation continues after the patient's first description.
class IntakePlan {
  const IntakePlan({
    required this.symptoms,
    required this.followUps,
    this.medicineChanged = false,
  });

  /// Symptoms understood from the description (keywords included).
  final Set<Symptom> symptoms;
  final List<FollowUp> followUps;

  /// They said a medicine was started, stopped or changed recently.
  final bool medicineChanged;
}

/// What to take to the appointment.
class PrepSuggestion {
  const PrepSuggestion({required this.questions, this.byAi = false});

  final List<DoctorQuestion> questions;

  /// Written by the on-device model rather than the offline rules.
  final bool byAi;
}

/// The AI behind "Questions for the doctor".
///
/// The UI only talks to this interface: [GemmaVisitAssistant] uses the
/// on-device model and falls back to [LocalVisitAssistant] whenever the model
/// isn't installed or its answer doesn't pass checks.
abstract class VisitAssistant {
  const VisitAssistant();

  /// Symptoms mentioned in the patient's own words, matched by keyword.
  Set<Symptom> detectSymptoms(String text, Map<Symptom, List<String>> keywords);

  /// Reads the first description and decides what to ask next. Null means
  /// the assistant can't plan a conversation, and the fixed questions (since
  /// when, how bad…) are asked instead.
  Future<IntakePlan?> planIntake({
    required PatientProfile patient,
    required Set<Symptom> picked,
    required String description,
    required Map<Symptom, List<String>> keywords,
    required AppLanguage language,
  }) async => null;

  Future<PrepSuggestion> suggestQuestions({
    required PatientProfile patient,
    required PrepAnswers answers,
    required AppLanguage language,
  });
}

/// Rule-based assistant, used when the on-device model isn't available.
/// Deterministic and offline: it picks from a fixed set of safe, general
/// questions based on duration and severity, and never gives medical advice
/// itself.
class LocalVisitAssistant extends VisitAssistant {
  const LocalVisitAssistant();

  @override
  Set<Symptom> detectSymptoms(
    String text,
    Map<Symptom, List<String>> keywords,
  ) {
    final said = text.toLowerCase();
    if (said.trim().isEmpty) return {};
    return {
      for (final MapEntry(key: symptom, value: words) in keywords.entries)
        if (words.any((w) => w.isNotEmpty && said.contains(w.toLowerCase())))
          symptom,
    };
  }

  @override
  Future<PrepSuggestion> suggestQuestions({
    required PatientProfile patient,
    required PrepAnswers answers,
    required AppLanguage language,
  }) async => PrepSuggestion(questions: questionsFor(patient, answers));

  /// Template questions, in order of importance.
  List<DoctorQuestion> questionsFor(
    PatientProfile patient,
    PrepAnswers answers,
  ) {
    var n = 0;
    DoctorQuestion q(
      QuestionKind kind, {
      Symptom? symptom,
      List<String> conditions = const [],
      String text = '',
    }) => DoctorQuestion(
      id: 'dq_${n++}',
      kind: kind,
      symptom: symptom,
      conditions: conditions,
      text: text,
    );

    final out = <DoctorQuestion>[];
    if (answers.description.trim().isNotEmpty) {
      out.add(q(QuestionKind.tellDoctor, text: answers.description.trim()));
    }

    // Worst first, so the most important questions are asked before time
    // runs out.
    final symptoms = [...answers.symptoms]
      ..sort((a, b) => _weight(b).compareTo(_weight(a)));
    for (final s in symptoms) {
      final long =
          s.since == SymptomSince.week || s.since == SymptomSince.monthPlus;
      final severe = s.severity == Severity.severe;
      out.add(q(QuestionKind.cause, symptom: s.symptom));
      if (severe || long) out.add(q(QuestionKind.tests, symptom: s.symptom));
      if (s.severity != Severity.mild) {
        out.add(q(QuestionKind.warningSigns, symptom: s.symptom));
      }
      if (!severe && !s.symptom.isRedFlag) {
        out.add(q(QuestionKind.homeCare, symptom: s.symptom));
      }
      // Once, on the most serious symptom, rather than repeating per symptom.
      if (patient.conditions.isNotEmpty && s == symptoms.first) {
        out.add(
          q(
            QuestionKind.conditionLink,
            symptom: s.symptom,
            conditions: patient.conditions,
          ),
        );
      }
    }

    if (answers.newMedicine == true) out.add(q(QuestionKind.sideEffect));
    if (answers.extraNote.trim().isNotEmpty) {
      out.add(q(QuestionKind.tellDoctor, text: answers.extraNote.trim()));
    }
    out
      ..add(q(QuestionKind.medicinesStillRight))
      ..add(q(QuestionKind.nextCheckup));
    return out;
  }

  static int _weight(SymptomAnswer s) =>
      (s.severity?.index ?? 0) * 10 +
      (s.since?.index ?? 0) +
      (s.symptom.isRedFlag ? 5 : 0);
}
