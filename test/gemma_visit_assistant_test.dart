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
  }) async {
    systems.add(system);
    prompts.add(prompt);
    return replies[(prompts.length - 1).clamp(0, replies.length - 1)];
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
    test('follow-ups come from the bank, with every must-ask', () async {
      final ai = _FakeAi(prefs, [
        // 1. understanding what was said
        '{"symptoms": ["headache", "flu"], "medicineChanged": false}',
        // 2. choosing follow-ups: one real id, one made up
        '{"ids": ["hd_where", "made_up"]}',
      ]);
      final plan = await GemmaVisitAssistant(ai).planIntake(
        patient: me,
        picked: {},
        description: 'bad headache',
        keywords: keywords,
        language: AppLanguage.english,
      );

      expect(plan!.symptoms, {Symptom.headache}); // "flu" is not ours
      final ids = plan.followUps.map((f) => f.id).toList();
      // When it started (not said), both danger checks and what was tried
      // are always asked; the invented id is dropped.
      expect(ids, containsAll(['g_onset', 'hd_danger', 'hd_signs', 'g_tried']));
      expect(ids, contains('hd_where'));
      expect(ids, isNot(contains('made_up')));
      // Danger answers carry their urgency to the chat.
      final danger = plan.followUps.firstWhere((f) => f.id == 'hd_danger');
      expect(danger.options.last.urgency, Urgency.emergency);
    });

    test('a medicine change they mention is not asked again', () async {
      final ai = _FakeAi(prefs, [
        '{"symptoms": ["dizziness"], "medicineChanged": true}',
        '{"ids": ["g_medicine", "dz_when"]}',
      ]);
      final plan = await GemmaVisitAssistant(ai).planIntake(
        patient: mother,
        picked: {},
        description: 'dizzy since the doctor changed her BP tablet',
        keywords: keywords,
        language: AppLanguage.english,
      );
      expect(plan!.medicineChanged, isTrue);
      final ids = plan.followUps.map((f) => f.id);
      expect(ids, isNot(contains('g_medicine')));
      // "since" says when it started.
      expect(ids, isNot(contains('g_onset')));
      expect(ids, contains('dz_danger'));
    });

    test('translations keep the options one for one, minus English', () async {
      final ai = _FakeAi(prefs, [
        '{"followUps": [{"id": "hd_danger", '
            '"question": "क्या यह अचानक शुरू हुआ?", '
            '"options": "नहीं (No) | हाँ, अचानक (Yes, sudden)"}]}',
      ]);
      final plan = await GemmaVisitAssistant(ai).planIntake(
        patient: me,
        picked: {Symptom.headache},
        description: '',
        keywords: keywords,
        language: AppLanguage.hindi,
      );
      final danger = plan!.followUps.firstWhere((f) => f.id == 'hd_danger');
      expect(danger.question, 'क्या यह अचानक शुरू हुआ?');
      expect(danger.options.map((o) => o.text), ['नहीं', 'हाँ, अचानक']);
      expect(danger.options.last.urgency, Urgency.emergency);
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
      ],
    );

    Future<PrepSuggestion> suggest(
      _FakeAi ai, {
      PatientProfile? patient,
      PrepAnswers? prep,
    }) => GemmaVisitAssistant(ai).suggestQuestions(
      patient: patient ?? mother,
      answers:
          prep ??
          PrepAnswers(
            symptoms: [SymptomAnswer(Symptom.dizziness)],
            description: answers.description,
            intake: answers.intake,
          ),
      language: AppLanguage.english,
    );

    test('only bank questions, tailored, every topic covered', () async {
      final ai = _FakeAi(prefs, [
        '{"questions": ['
            '{"id": "u_cause", "question": "What do you think is causing my mother\'s dizziness?"},'
            '{"id": "dz_bp", "question": "Could blood pressure or the medicines be causing my mother\'s dizziness?"},'
            '{"id": "made_up", "question": "Is it vertigo?"},'
            '{"id": "m_side", "question": "Should she take 500 mg of something?"},'
            '{"id": "h_do", "question": "What can I do at home for my dizziness?"},'
            '{"id": "t_need", "question": "Is an MRI of the brain needed?"}'
            ']}',
      ]);
      final s = await suggest(ai);
      final texts = {
        for (final q in s.questions) q.id.split('_').skip(2).join('_'): q.text,
      };

      expect(s.byAi, isTrue);
      expect(s.questions.every((q) => q.kind == QuestionKind.ai), isTrue);
      // Tailored wording kept when it stays true to the bank question.
      expect(
        texts['u_cause'],
        "What do you think is causing my mother's dizziness?",
      );
      // Invented question dropped; a dose sends back the bank wording.
      expect(texts.containsKey('made_up'), isFalse);
      expect(texts['m_side'], 'What side effects could the medicines cause?');
      // A caregiver's question must not speak as the patient.
      expect(texts['h_do'], 'What can be done at home to help with this?');
      // New medical words ("MRI", "brain") send back the bank wording.
      expect(texts['t_need'], 'Are any tests needed? What will they tell us?');
      // Always there: what the answers make essential, and every topic.
      expect(texts, contains('m_nothing'));
      expect(texts, contains('f_warning'));
      expect(
        s.questions.map((q) => q.topic).toSet(),
        QuestionTopic.values.toSet(),
      );
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
      for (final reply in ['Sorry, I cannot help.', '{"questions": "x"}']) {
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
