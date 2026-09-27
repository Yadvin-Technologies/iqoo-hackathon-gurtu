import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/gemma_visit_assistant.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/ai/visit_assistant.dart';
import 'package:gurtutest/ai/visit_knowledge.dart';
import 'package:gurtutest/data/care_models.dart';
import 'package:gurtutest/data/visit_models.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stands in for the on-device model: answers each call with the next of
/// [replies] (the last one repeats) and remembers what it was asked.
class _FakeAi extends GurtuAi {
  _FakeAi(super.prefs, this.replies, {this.ready = true});

  final List<String> replies;
  final bool ready;
  final prompts = <String>[];
  final systems = <String>[];

  @override
  bool get isReady => ready;

  @override
  Future<String> generate({
    required String system,
    required String prompt,
    int maxOutputTokens = 512,
    Duration timeout = const Duration(seconds: 60),
    ValueChanged<String>? onPartial,
  }) async {
    systems.add(system);
    prompts.add(prompt);
    final reply = replies[(prompts.length - 1).clamp(0, replies.length - 1)];
    // Streamed in two pieces, like the model writing it.
    if (onPartial != null) {
      onPartial(reply.substring(0, reply.length ~/ 2));
      onPartial(reply);
    }
    return reply;
  }
}

void main() {
  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  final mother = PatientProfile(
    id: 'p1',
    name: 'Amma',
    age: 64,
    gender: 'female',
    conditions: const ['diabetes'],
    careFor: 'parent',
    createdAt: DateTime(2026),
  );
  final me = PatientProfile(
    id: 'p2',
    name: 'Me',
    age: 20,
    gender: 'male',
    isSelf: true,
    careFor: 'myself',
    createdAt: DateTime(2026),
  );
  const keywords = {
    Symptom.headache: ['headache'],
    Symptom.dizziness: ['dizzy'],
  };

  group('planIntake', () {
    test('the model writes its own follow-ups, danger checks kept', () async {
      final ai = _FakeAi(prefs, [
        // 1. understanding what was said
        '{"symptoms": ["headache", "flu"], "medicineChanged": false}',
        // 2. the follow-ups
        '{"followUps": ['
            '{"id": "new", "question": "Is your headache worse in the morning or at night?", '
            '"options": ["Morning", "Night", "No difference"]},'
            '{"id": "hd_danger", "question": "Did your headache start suddenly, as the worst headache ever?", '
            '"options": ["No, it came slowly", "Yes, sudden and severe"]},'
            '{"id": "new", "question": "Should you take 500 mg of paracetamol?", '
            '"options": ["Yes", "No"]},'
            '{"id": "new", "question": "Is your headache worse in the morning or at night?", '
            '"options": ["Morning", "Night"]},'
            '{"id": "new", "question": "Does long screen time make your headache worse?", '
            '"options": "Yes | No | Not sure"}'
            ']}',
      ]);
      final plan = await GemmaVisitAssistant(ai).planIntake(
        patient: me,
        picked: {},
        description: 'bad headache since morning',
        keywords: keywords,
        language: AppLanguage.english,
      );

      expect(plan!.symptoms, {Symptom.headache}); // "flu" is not ours
      // Only its first question up front, and every danger check: the rest
      // are written one at a time, from the answers.
      expect(plan.adaptive, isTrue);
      expect(plan.followUps.map((f) => f.question), [
        'Is your headache worse in the morning or at night?',
        // Left out by the model: asked anyway, right after the first.
        'Does it come with vomiting, blurred vision, weakness or confusion?',
        'Did your headache start suddenly, as the worst headache ever?',
      ]);
      expect(plan.followUps.first.id, startsWith('ai_'));
      // Danger answers carry their urgency to the chat, reworded or not.
      for (final id in ['hd_danger', 'hd_signs']) {
        final danger = plan.followUps.firstWhere((f) => f.id == id);
        expect(danger.options.last.urgency, Urgency.emergency);
      }
      // What they said and the checks reach the model.
      expect(ai.prompts.last, contains('bad headache since morning'));
      expect(ai.prompts.last, contains('hd_signs'));
    });

    test('speaks to a caregiver about the patient', () async {
      final ai = _FakeAi(prefs, [
        '{"symptoms": ["dizziness"], "medicineChanged": true}',
        '{"followUps": ['
            '{"id": "dz_danger", "question": "Is she unwell?", '
            '"options": ["No", "Yes"]},'
            '{"id": "new", "question": "Does your mother feel dizzy when she stands up?", '
            '"options": ["Yes", "No"]}'
            ']}',
      ]);
      final plan = await GemmaVisitAssistant(ai).planIntake(
        patient: mother,
        picked: {},
        description: 'dizzy since the doctor changed her BP tablet',
        keywords: keywords,
        language: AppLanguage.english,
      );
      expect(plan!.medicineChanged, isTrue);
      expect(ai.systems.last, contains('your mother'));
      expect(ai.prompts.last, contains('Diabetes'));
      expect(ai.prompts.last, contains('medicine was started'));
      // A danger check reworded out of its meaning keeps the bank's words.
      final danger = plan.followUps.firstWhere((f) => f.id == 'dz_danger');
      expect(
        danger.question,
        'Any slurred speech, drooping face, or weakness on one side?',
      );
      expect(danger.options.last.urgency, Urgency.emergency);
    });

    test('then one question at a time, from the answers so far', () async {
      final ai = _FakeAi(prefs, [
        '{"done": false, "question": "Does your headache get worse after '
            'looking at a screen?", "options": "Yes | No | Not sure"}',
      ]);
      final partials = <String>[];
      final next = await GemmaVisitAssistant(ai).nextFollowUp(
        patient: me,
        description: 'bad headache since morning',
        symptoms: {Symptom.headache},
        answers: [
          IntakeAnswer(
            question: 'Is your headache worse in the morning or at night?',
            answer: 'Night',
            id: 'ai_0',
            choice: 1,
          ),
        ],
        ownAsked: 1,
        language: AppLanguage.english,
        careNotes: 'Medicines they take: Paracetamol',
        onPartial: partials.add,
      );
      expect(
        next!.question,
        'Does your headache get worse after looking at a screen?',
      );
      expect(next.options.map((o) => o.text), ['Yes', 'No', 'Not sure']);
      expect(next.id, startsWith('ai_'));
      // It sees every answer, the saved context, and how many are left.
      expect(ai.prompts.single, contains('worse in the morning or at night?'));
      expect(ai.prompts.single, contains('→ Night'));
      expect(ai.prompts.single, contains('Paracetamol'));
      expect(ai.systems.single, contains('ONE short question at a time'));
      expect(ai.systems.single, contains('at most 3 more'));
      // Streamed as it was written.
      expect(partials, hasLength(2));
      // Half written: the question so far.
      expect(
        GemmaVisitAssistant.partialQuestions(partials.first).single,
        startsWith('Does your headache get worse'),
      );
    });

    test('the conversation ends when enough is known, or it goes wrong', () async {
      Future<FollowUp?> next(String reply, {int ownAsked = 1}) =>
          GemmaVisitAssistant(_FakeAi(prefs, [reply])).nextFollowUp(
            patient: me,
            description: 'headache',
            symptoms: {Symptom.headache},
            answers: [
              IntakeAnswer(
                question: 'Is it worse at night?',
                answer: 'Yes',
                id: 'ai_0',
              ),
            ],
            ownAsked: ownAsked,
            language: AppLanguage.english,
          );
      expect(await next('{"done": true}'), isNull);
      // Asked already, in other words it would loop.
      expect(
        await next(
          '{"done": false, "question": "Is it worse at night?", '
          '"options": ["Yes", "No"]}',
        ),
        isNull,
      );
      // A dose is never written.
      expect(
        await next(
          '{"done": false, "question": "Did you take 500 mg of paracetamol?", '
          '"options": ["Yes", "No"]}',
        ),
        isNull,
      );
      expect(await next('I am not sure what to ask.'), isNull);
      // The limit on its own questions.
      expect(
        await next(
          '{"done": false, "question": "Does light bother your eyes?", '
          '"options": ["Yes", "No"]}',
          ownAsked: 4,
        ),
        isNull,
      );
      // Without the model: nothing more to ask.
      expect(
        await GemmaVisitAssistant(_FakeAi(prefs, ['{}'], ready: false))
            .nextFollowUp(
              patient: me,
              description: '',
              symptoms: const {},
              answers: const [],
              ownAsked: 0,
              language: AppLanguage.english,
            ),
        isNull,
      );
    });

    test('questions show while they are being written', () {
      expect(
        GemmaVisitAssistant.partialQuestions(
          '{"questions": [{"topic": "understand", "question": "What could be '
          'causing \\"it\\"?"}, {"topic": "tests", "question": "Which te',
        ),
        ['What could be causing "it"?', 'Which te'],
      );
      expect(GemmaVisitAssistant.partialQuestions('{"quest'), isEmpty);
    });

    test('in English, the bank follow-ups when nothing is usable', () async {
      final ai = _FakeAi(prefs, ['Sorry, I cannot help.']);
      final plan = await GemmaVisitAssistant(ai).planIntake(
        patient: me,
        picked: {Symptom.headache},
        description: '',
        keywords: keywords,
        language: AppLanguage.english,
      );
      final ids = plan!.followUps.map((f) => f.id);
      expect(ids, containsAll(['g_onset', 'hd_danger', 'hd_signs', 'g_tried']));
    });

    test('in Hindi, only Hindi questions, danger checks translated', () async {
      final ai = _FakeAi(prefs, [
        '{"followUps": ['
            '{"id": "hd_danger", "question": "क्या यह अचानक शुरू हुआ?", '
            '"options": "नहीं (No) | हाँ, अचानक (Yes, sudden)"},'
            '{"id": "new", "question": "Is it worse at night?", '
            '"options": ["Yes", "No"]},'
            '{"id": "new", "question": "क्या रात में सिरदर्द ज़्यादा होता है?", '
            '"options": ["हाँ", "नहीं"]}'
            ']}',
        // The danger check the model left out, translated.
        '{"followUps": [{"id": "hd_signs", '
            '"question": "क्या उल्टी, धुंधला दिखना या कमजोरी भी है?", '
            '"options": ["नहीं", "हाँ"]}]}',
      ]);
      final plan = await GemmaVisitAssistant(ai).planIntake(
        patient: me,
        picked: {Symptom.headache},
        description: '',
        keywords: keywords,
        language: AppLanguage.hindi,
      );
      expect(plan!.followUps.map((f) => f.question), [
        'क्या यह अचानक शुरू हुआ?',
        'क्या उल्टी, धुंधला दिखना या कमजोरी भी है?',
        'क्या रात में सिरदर्द ज़्यादा होता है?',
      ]);
      final danger = plan.followUps.firstWhere((f) => f.id == 'hd_danger');
      expect(danger.options.map((o) => o.text), ['नहीं', 'हाँ, अचानक']);
      expect(danger.options.last.urgency, Urgency.emergency);
      expect(
        plan.followUps
            .firstWhere((f) => f.id == 'hd_signs')
            .options
            .last
            .urgency,
        Urgency.emergency,
      );
    });

    test('in Hindi, no plan when nothing is usable', () async {
      final plan = await GemmaVisitAssistant(_FakeAi(prefs, ['{}'])).planIntake(
        patient: me,
        picked: {Symptom.headache},
        description: '',
        keywords: keywords,
        language: AppLanguage.hindi,
      );
      expect(plan, isNull);
    });

    test('no plan without the model', () async {
      final plan =
          await GemmaVisitAssistant(_FakeAi(prefs, ['{}'], ready: false))
              .planIntake(
                patient: me,
                picked: {Symptom.headache},
                description: '',
                keywords: keywords,
                language: AppLanguage.english,
              );
      expect(plan, isNull);
    });
  });

  group('suggestQuestions', () {
    const answers = PrepAnswers(
      symptoms: [],
      description: 'dizzy when she stands up',
      intake: [
        IntakeAnswer(
          question: 'Has anything helped so far?',
          answer: 'Nothing helped',
          id: 'g_tried',
          choice: 2,
        ),
        IntakeAnswer(
          question: 'Does she feel dizzy after her morning tablets?',
          answer: 'Yes',
          id: 'ai_0',
          choice: 0,
        ),
      ],
    );

    Future<PrepSuggestion> suggest(
      _FakeAi ai, {
      PatientProfile? patient,
      AppLanguage language = AppLanguage.english,
    }) => GemmaVisitAssistant(ai).suggestQuestions(
      patient: patient ?? mother,
      answers: PrepAnswers(
        symptoms: [SymptomAnswer(Symptom.dizziness)],
        description: answers.description,
        intake: answers.intake,
      ),
      language: language,
    );

    test('written for this patient, every topic covered', () async {
      final ai = _FakeAi(prefs, [
        '{"questions": ['
            '{"topic": "understand", "question": "What could be causing my mother\'s dizziness when she stands up?"},'
            '{"topic": "understand", "question": "Could her diabetes be linked to the dizziness?"},'
            '{"topic": "treatment", "question": "Could her morning tablets be making her dizzy?"},'
            '{"topic": "treatment", "question": "Should she take 500 mg of something?"},'
            '{"topic": "home", "question": "What can I do at home for my dizziness?"},'
            '{"topic": "home", "question": "How can we stop my mother from falling when she feels dizzy?"},'
            '{"topic": "tests", "question": "Should her sugar and blood pressure be checked?"},'
            '{"topic": "Follow-up", "question": "When should we bring my mother back if it does not settle?"},'
            '{"topic": "understand", "question": "What could be causing my mother\'s dizziness when she stands up?"}'
            ']}',
      ]);
      final s = await suggest(ai);

      expect(s.byAi, isTrue);
      expect(s.questions.map((q) => q.text), [
        "What could be causing my mother's dizziness when she stands up?",
        'Could her diabetes be linked to the dizziness?',
        'Should her sugar and blood pressure be checked?',
        'Could her morning tablets be making her dizzy?',
        'How can we stop my mother from falling when she feels dizzy?',
        'When should we bring my mother back if it does not settle?',
        // Always asked, even when the model forgets.
        'Which warning signs mean going to the hospital straight away?',
      ]);
      // A dose, the wrong voice and a repeat are dropped.
      expect(
        s.questions.map((q) => q.topic).toSet(),
        QuestionTopic.values.toSet(),
      );
      // Everything learned reaches the model, and what it must cover.
      expect(ai.prompts.last, contains('after her morning tablets? → Yes'));
      expect(ai.systems.last, contains('Nothing tried so far has helped'));
      expect(ai.systems.last, contains('long-term conditions'));
      expect(ai.systems.last, contains('my mother'));
    });

    test('in Hindi, missing topics from the app\'s own questions', () async {
      final ai = _FakeAi(prefs, [
        '{"questions": ['
            '{"topic": "understand", "question": "माँ को खड़े होने पर चक्कर क्यों आता है?"},'
            '{"topic": "understand", "question": "Could it be her sugar?"},'
            '{"topic": "treatment", "question": "क्या सुबह की दवा से चक्कर आ सकता है?"},'
            '{"topic": "home", "question": "घर पर माँ को गिरने से कैसे बचाएँ?"},'
            '{"topic": "followUp", "question": "किन लक्षणों पर तुरंत अस्पताल जाना चाहिए?"},'
            '{"topic": "followUp", "question": "अगर ठीक न हो तो दोबारा कब आएँ?"}'
            ']}',
      ]);
      final s = await suggest(ai, language: AppLanguage.hindi);
      expect(s.byAi, isTrue);
      expect(s.questions.where((q) => q.kind == QuestionKind.ai), hasLength(5));
      final tests = s.questions.singleWhere(
        (q) => q.topic == QuestionTopic.tests,
      );
      expect(tests.kind, QuestionKind.tests);
      expect(tests.symptom, Symptom.dizziness);
    });

    test('in English, a sensible bank list even without the model', () async {
      final s = await suggest(
        _FakeAi(prefs, ['{}'], ready: false),
        patient: me,
      );
      expect(s.byAi, isFalse);
      expect(
        s.questions.map((q) => q.topic).toSet(),
        QuestionTopic.values.toSet(),
      );
    });

    test('falls back on an unusable answer', () async {
      for (final reply in [
        'Sorry, I cannot help.',
        '{"questions": "x"}',
        '{"questions": [{"topic": "tests", "question": "Is a blood test needed?"}]}',
      ]) {
        final s = await suggest(_FakeAi(prefs, [reply]));
        expect(s.byAi, isFalse, reason: reply);
        expect(s.questions, isNotEmpty);
      }
    });
  });

  test('a prep keeps its topics and conversation when saved', () {
    final prep = VisitPrep(
      id: 'x',
      patientId: 'p1',
      createdAt: DateTime(2026),
      intake: const [
        IntakeAnswer(
          question: 'Since when?',
          answer: 'A week',
          id: 'g_onset',
          choice: 2,
        ),
      ],
      questions: [
        DoctorQuestion(
          id: 'q',
          kind: QuestionKind.ai,
          text: 'Why?',
          topic: QuestionTopic.tests,
        ),
      ],
    );
    final back = VisitPrep.fromJson(prep.toJson());
    expect(back.intake.single.answer, 'A week');
    expect(back.intake.single.choice, 2);
    expect(back.questions.single.topic, QuestionTopic.tests);
  });
}
