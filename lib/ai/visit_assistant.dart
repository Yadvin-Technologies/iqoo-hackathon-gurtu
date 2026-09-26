import '../data/care_models.dart';
import '../data/visit_models.dart';

/// What the patient told Gurtu while preparing for a visit.
class PrepAnswers {
  const PrepAnswers({
    required this.symptoms,
    this.description = '',
    this.newMedicine,
    this.extraNote = '',
  });

  final List<SymptomAnswer> symptoms;
  final String description;
  final bool? newMedicine;
  final String extraNote;
}

/// The AI behind "Questions for the doctor".
///
/// The UI only talks to this interface, so the on-device model or a cloud
/// model (Firebase) can replace [LocalVisitAssistant] without screen changes.
/// Questions are returned as [DoctorQuestion] templates, not text, so they
/// stay readable when the app language changes.
abstract class VisitAssistant {
  /// Symptoms mentioned in the patient's own words.
  Set<Symptom> detectSymptoms(String text, Map<Symptom, List<String>> keywords);

  Future<List<DoctorQuestion>> suggestQuestions({
    required PatientProfile patient,
    required PrepAnswers answers,
  });
}

/// Rule-based stand-in used until a real model is connected. Deterministic
/// and offline: it picks from a fixed set of safe, general questions based
/// on duration and severity, and never gives medical advice itself.
class LocalVisitAssistant implements VisitAssistant {
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
  Future<List<DoctorQuestion>> suggestQuestions({
    required PatientProfile patient,
    required PrepAnswers answers,
  }) async {
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
