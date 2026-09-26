// Runs realistic patients through "Prepare for the doctor" on the real
// on-device model and logs every follow-up and question, for review when the
// prompts or the question bank change.
//
// On a phone with Gurtu AI installed (it uses the app's downloaded model):
//   flutter build apk --debug -t tool/prompt_eval.dart
//   adb install -r build/app/outputs/flutter-apk/app-debug.apk
//   adb logcat -s flutter        (then open the app; ends with "EVAL DONE")
// Reinstall the normal app afterwards.

import 'package:flutter/material.dart';
import 'package:gurtutest/ai/gemma_visit_assistant.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/ai/visit_assistant.dart';
import 'package:gurtutest/ai/visit_knowledge.dart';
import 'package:gurtutest/data/care_models.dart';
import 'package:gurtutest/data/visit_models.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/visits/visit_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Case {
  const _Case(
    this.name,
    this.patient, {
    this.picked = const {},
    this.said = '',
    this.choices = const {},
    this.language = AppLanguage.english,
  });

  final String name;
  final PatientProfile patient;
  final Set<Symptom> picked;
  final String said;

  /// Option to tap per follow-up id; the first option otherwise.
  final Map<String, int> choices;
  final AppLanguage language;
}

PatientProfile _p(
  int age,
  String gender, {
  bool self = true,
  String? careFor,
  List<String> conditions = const [],
  String? mobility,
}) => PatientProfile(
  id: 'eval',
  name: 'Eval',
  age: age,
  gender: gender,
  isSelf: self,
  careFor: careFor ?? (self ? 'myself' : null),
  conditions: conditions,
  mobility: mobility,
  takesMedicines: conditions.isEmpty ? 'no' : 'yes',
  medicineCount: conditions.isEmpty ? null : 'threeFive',
  createdAt: DateTime(2026),
);

final _cases = [
  _Case(
    'Headache, a week, nothing helps (self, 20 M)',
    _p(20, 'male'),
    picked: {Symptom.headache},
    choices: {'g_onset': 2, 'g_tried': 2, 'g_course': 1},
  ),
  _Case(
    'Mother dizzy on standing after new BP tablet (64 F, diabetes, BP)',
    _p(
      64,
      'female',
      self: false,
      careFor: 'parent',
      conditions: ['diabetes', 'highBp'],
      mobility: 'someHelp',
    ),
    said:
        'she feels dizzy when she stands up, it started after the doctor '
        'changed her BP tablet',
    choices: {'dz_when': 0, 'dz_falls': 1, 'g_medicine': 0},
  ),
  _Case(
    'Father breathless on stairs, swollen feet — Hindi (72 M, heart)',
    _p(72, 'male', self: false, careFor: 'parent', conditions: ['heart']),
    said: 'papa ko seedhi chadhne par saans phoolti hai aur pairon mein sujan hai',
    choices: {'br_swelling': 1},
    language: AppLanguage.hindi,
  ),
  _Case(
    'Son, fever 3 days and night cough (6 M)',
    _p(6, 'male', self: false, careFor: 'child'),
    picked: {Symptom.fever, Symptom.cough},
    said: 'fever since 3 days and coughing at night',
    choices: {'fe_temp': 2, 'co_danger': 2},
  ),
  _Case(
    'Tired, low, poor sleep (self, 45 F, thyroid)',
    _p(45, 'female', conditions: ['thyroid']),
    said: 'always tired, feeling low and I cannot sleep properly',
    choices: {'md_often': 1, 'ti_sleep': 0, 'sl_kind': 1},
  ),
  _Case(
    'Loose motions and vomiting since yesterday (self, 30 M)',
    _p(30, 'male'),
    said: 'loose motions and vomiting since yesterday',
    choices: {'st_fluids': 0, 'st_main': 2},
  ),
  _Case(
    'Chest pain spreading to arm — danger (self, 55 M, BP)',
    _p(55, 'male', conditions: ['highBp']),
    said: 'chest pain going to my left arm since this morning',
    choices: {'cp_danger': 1},
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Text('Running prompt eval…'))),
    ),
  );
  final prefs = await SharedPreferences.getInstance();
  final ai = GurtuAi(prefs);
  await ai.init();
  if (!ai.isReady) {
    debugPrint('EVAL ABORT: Gurtu AI is ${ai.status.name}');
    return;
  }
  final assistant = GemmaVisitAssistant(ai);
  final en = lookupAppLocalizations(const Locale('en'));

  for (final c in _cases) {
    final l = lookupAppLocalizations(c.language.locale);
    final watch = Stopwatch()..start();
    debugPrint('\n######## ${c.name}');
    final plan = await assistant.planIntake(
      patient: c.patient,
      picked: c.picked,
      description: c.said,
      keywords: l.symptomKeywords,
      language: c.language,
    );
    debugPrint('intake plan: ${watch.elapsed.inMilliseconds} ms');
    if (plan == null) {
      debugPrint('NO PLAN (fixed questions would be used)');
      continue;
    }
    debugPrint(
      'symptoms: ${plan.symptoms.map(en.symptomLabel).join(', ')}'
      '${plan.medicineChanged ? ' · medicine changed' : ''}',
    );
    final intake = <IntakeAnswer>[];
    for (final f in plan.followUps) {
      final i = c.choices[f.id] ?? 0;
      final option = f.options.isEmpty ? null : f.options[i];
      debugPrint(
        '  FOLLOW-UP [${f.id}] ${f.question}\n'
        '     options: ${f.options.map((o) => o.urgency == Urgency.none ? o.text : '${o.text} (!${o.urgency.name})').join(' | ')}\n'
        '     answer: ${option?.text}',
      );
      if (option != null) {
        intake.add(
          IntakeAnswer(
            question: f.question,
            answer: option.text,
            id: f.id,
            choice: i,
          ),
        );
      }
    }
    watch.reset();
    final s = await assistant.suggestQuestions(
      patient: c.patient,
      answers: PrepAnswers(
        symptoms: [for (final x in plan.symptoms) SymptomAnswer(x)],
        description: c.said,
        intake: intake,
        newMedicine: plan.medicineChanged ? true : null,
      ),
      language: c.language,
    );
    debugPrint(
      'questions: ${watch.elapsed.inMilliseconds} ms · byAi=${s.byAi}',
    );
    for (final q in s.questions) {
      debugPrint('  Q [${q.topic?.name ?? q.kind.name}] ${l.questionText(q)}');
    }
  }
  debugPrint('EVAL DONE');
}
