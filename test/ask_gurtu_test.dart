import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/ask/ask_gurtu_page.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/data/medicine_models.dart';
import 'package:gurtutest/data/visit_models.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/main.dart';
import 'package:gurtutest/memory/knowledge.dart';
import 'package:gurtutest/memory/memory_page.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gurtu AI that is "installed" and answers from a script, keeping what it
/// was told.
class FakeAi extends GurtuAi {
  FakeAi(super.prefs, this.answers);

  final List<String> answers;
  final systems = <String>[];
  final prompts = <String>[];

  @override
  bool get isReady => true;

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
    return answers.isEmpty ? '' : answers.removeAt(0);
  }
}

/// Amma, with diabetes and a penicillin allergy, one medicine, a visit
/// whose next appointment is tomorrow, a saved doctor question and a note.
Future<(SharedPreferences, CareRepository)> amma(DateTime now) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_complete': true,
    'app_language': 'en',
  });
  final prefs = await SharedPreferences.getInstance();
  final repo = CareRepository(prefs)
    ..createFromOnboarding(
      OnboardingState()
        ..careFor = CareFor.parent
        ..patientName = 'Amma'
        ..yourName = 'Sai'
        ..age = 64
        ..conditions.add(HealthCondition.diabetes)
        ..allergies.add(Allergy.penicillin),
    );
  repo
    ..addMedicine(
      name: 'Metformin',
      strength: '500 mg',
      times: const [DoseTime.morning, DoseTime.night],
      food: FoodTiming.afterFood,
    )
    ..addVisit(
      date: now.subtract(const Duration(days: 20)),
      doctorName: 'Dr. Rao',
      notes: 'Sugar is a little high. Walk every evening.',
      nextVisit: now.add(const Duration(days: 1)),
    )
    ..savePrep(
      (id, patientId) => VisitPrep(
        id: id,
        patientId: patientId,
        createdAt: now,
        questions: [
          DoctorQuestion(
            id: 'q1',
            kind: QuestionKind.custom,
            text: 'Should the sugar be checked at home?',
          ),
        ],
      ),
    )
    ..addNote('Felt dizzy after the morning walk');
  return (prefs, repo);
}

void main() {
  test('Gurtu AI is told about the person, not only what matched', () async {
    final now = DateTime(2026, 9, 27, 10);
    final (_, repo) = await amma(now);
    final prompt = AskGurtuPage.buildPrompt(
      question: 'What should I ask the doctor tomorrow?',
      patient: repo.selectedPatient!,
      repo: repo,
      related: const [],
      history: const [('Which medicine is at night?', 'Metformin 500 mg.')],
      now: now,
    );
    // The date, so "tomorrow" means something.
    expect(prompt, contains('Today is Sunday 2026-09-27 (today).'));
    expect(prompt, contains('Next visit: Monday 2026-09-28 (tomorrow)'));
    // The profile from onboarding.
    expect(prompt, contains('Their age: 64 years'));
    expect(prompt, contains('Health conditions: Sugar (Diabetes)'));
    expect(prompt, contains('Allergies: Penicillin'));
    // Medicines, the last visit, open questions, recent notes, the chat.
    expect(prompt, contains('- Metformin 500 mg: Morning, Night, after food'));
    expect(prompt, contains('Dr. Rao'));
    expect(prompt, contains('Sugar is a little high'));
    expect(prompt, contains('- Should the sugar be checked at home?'));
    expect(prompt, contains('Felt dizzy after the morning walk'));
    expect(prompt, contains('Family: Which medicine is at night?'));
    expect(
      prompt,
      endsWith(
        'QUESTION FROM THE FAMILY: What should I ask the doctor tomorrow?',
      ),
    );
    // Short enough to leave the model room to answer.
    expect(prompt.length, lessThan(6000));

    final system = AskGurtuPage.systemPrompt(
      repo.selectedPatient!,
      AppLanguage.hindi,
    );
    expect(system, contains('practical questions'));
    expect(system, contains('Never make up facts'));
    expect(system, contains('Never diagnose'));
    expect(system, contains('Reply in Hindi'));
  });

  test('Gurtu AI sees the whole history of doctor visits', () async {
    final now = DateTime(2026, 9, 27, 10);
    final (_, repo) = await amma(now);
    final id = repo.selectedPatient!.id;
    // A year of monthly visits, the oldest about the knee.
    for (var i = 1; i <= 30; i++) {
      repo.addVisit(
        date: now.subtract(Duration(days: 30 * i + 5)),
        doctorName: i == 30 ? 'Dr. Mehta' : 'Dr. Rao',
        reason: i == 30 ? 'knee pain' : 'sugar check',
        notes: i == 30
            ? 'X-ray shows wear in the left knee. Physiotherapy twice a week.'
            : 'Visit $i: sugar steady, keep walking every evening, '
                  'less rice at night, check feet daily.',
        medicines: [VisitMedicine(id: 'm$i', note: 'Metformin 500 mg 1-0-1')],
      );
    }
    final latest = repo.visits
        .where((v) => v.patientId == id)
        .reduce((a, b) => a.date.isAfter(b.date) ? a : b);
    // Questions taken to the latest visit, and a recording of the doctor.
    repo.savePrep(
      (pid, patientId) => VisitPrep(
        id: pid,
        patientId: patientId,
        createdAt: now,
        visitId: latest.id,
        questions: [
          DoctorQuestion(
            id: 'qa',
            kind: QuestionKind.custom,
            text: 'Is the dizziness from the medicine?',
            asked: true,
          ),
        ],
      ),
    );
    repo.addAttachment(
      latest,
      VisitAttachment(
        id: 'rec1',
        kind: AttachmentKind.audio,
        section: VisitSection.doctor,
        file: 'rec1.m4a',
        createdAt: now,
      ),
    );
    final knee = repo.visits.firstWhere((v) => v.doctorName == 'Dr. Mehta');

    final prompt = AskGurtuPage.buildPrompt(
      question: 'What did the doctor say about the knee?',
      patient: repo.selectedPatient!,
      repo: repo,
      // The search found the old knee visit.
      related: [
        KnowledgeDoc(
          id: 'visit:${knee.id}',
          patientId: id,
          kind: KnowledgeKind.visit,
          title: 'Dr. Mehta · knee pain',
          text: knee.notes,
          date: knee.date,
          visitId: knee.id,
        ),
      ],
      now: now,
    );
    expect(prompt, contains('DOCTOR VISIT HISTORY (31 saved, newest first)'));
    // The latest visit in full, with what was asked and kept.
    expect(
      prompt,
      contains('  Doctor said: Sugar is a little high. Walk every evening.'),
    );
    expect(
      prompt,
      contains(
        '  Questions asked at this visit: Is the dizziness from the medicine?',
      ),
    );
    expect(
      prompt,
      contains('  Kept with it: 1 voice recording(s), 0 photo(s)'),
    );
    // Older ones in a line each, within a budget...
    expect(prompt, contains('Dr. Rao, for sugar check: Visit 5: sugar steady'));
    expect(prompt, contains('(and '));
    // ...but the old knee visit the question is about is always there, in
    // full, and only once.
    expect(
      prompt,
      contains(
        '  Doctor said: X-ray shows wear in the left knee. '
        'Physiotherapy twice a week.',
      ),
    );
    expect('Physiotherapy'.allMatches(prompt).length, 1);
    expect(prompt.length, lessThan(8000));

    // A short history: every visit is there.
    final (_, few) = await amma(now);
    final small = AskGurtuPage.buildPrompt(
      question: 'q',
      patient: few.selectedPatient!,
      repo: few,
      related: const [],
      now: now,
    );
    expect(small, contains('DOCTOR VISIT HISTORY (1 saved, newest first)'));
    expect(small, isNot(contains('older visits')));
    expect(
      small,
      contains('  Asked to come back: Monday 2026-09-28 (tomorrow)'),
    );
  });

  test('answers are shown as plain text', () {
    expect(
      AskGurtuPage.cleanAnswer(
        '## Questions\n\n\n**1.** Is the sugar okay?\n* Ask about the walk\n',
      ),
      'Questions\n\n1. Is the sugar okay?\n• Ask about the walk',
    );
  });

  testWidgets('Ask Gurtu answers from the whole care memory', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final (prefs, _) = await amma(DateTime.now());
    final ai = FakeAi(prefs, [
      '**1.** Ask if the sugar should be checked at home.\n'
          '**2.** Mention the dizziness after the morning walk.',
      'Metformin 500 mg, after food.',
    ]);
    await tester.pumpWidget(GurtuApp(key: UniqueKey(), prefs: prefs, ai: ai));
    await tester.pumpAndSettle();
    await tester.tap(find.text('AI'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('What should I ask the doctor tomorrow?'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        '1. Ask if the sugar should be checked at home.\n'
        '2. Mention the dizziness after the morning walk.',
      ),
      findsOneWidget,
    );
    expect(ai.prompts.single, contains('Health conditions: Sugar (Diabetes)'));
    expect(ai.prompts.single, contains('(tomorrow)'));
    expect(ai.systems.single, contains('Amma'));

    // A follow-up carries the conversation.
    await tester.enterText(
      find.descendant(
        of: find.byType(AskGurtuPage),
        matching: find.byType(TextField),
      ),
      'and which medicine is at night?',
    );
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
    expect(find.text('Metformin 500 mg, after food.'), findsOneWidget);
    expect(
      ai.prompts.last,
      contains('Family: What should I ask the doctor tomorrow?'),
    );
    expect(ai.prompts.last, contains('Gurtu: 1. Ask if the sugar'));
  });

  testWidgets('the Memory tab starts with what the profile says', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final (prefs, _) = await amma(DateTime.now());
    await tester.pumpWidget(
      GurtuApp(key: UniqueKey(), prefs: prefs, ai: GurtuAi(prefs)..init()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Memory'));
    await tester.pumpAndSettle();

    final first = tester.widget<KnowledgeTile>(
      find.byType(KnowledgeTile).first,
    );
    expect(first.doc.kind, KnowledgeKind.profile);
    expect(first.doc.title, 'About Amma');
    expect(first.doc.text, contains('Health conditions: Sugar (Diabetes)'));
    // Found by what it says, too.
    await tester.enterText(find.byType(TextField).first, 'penicillin');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('About Amma'), findsOneWidget);
    await tester.tap(find.text('About Amma'));
    await tester.pumpAndSettle();
    expect(find.text('Edit details'), findsOneWidget);
  });
}
