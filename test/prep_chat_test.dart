import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/data/medicine_models.dart';
import 'package:gurtutest/main.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:gurtutest/visits/prep_chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'visits_test.dart' show openPage;

/// Gurtu AI "installed", answering from a script and streaming each answer
/// in pieces; keeps what it was told.
class ScriptedAi extends GurtuAi {
  ScriptedAi(super.prefs, this.replies);

  final List<String> replies;
  final prompts = <String>[];
  final systems = <String>[];

  @override
  bool get isReady => true;

  @override
  void warmUp() {}

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
    final reply = replies.removeAt(0);
    if (onPartial != null) {
      for (var i = 20; i < reply.length; i += 20) {
        onPartial(reply.substring(0, i));
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      onPartial(reply);
    }
    return reply;
  }
}

void main() {
  testWidgets('Gurtu asks one question at a time, each from the answers', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'app_language': 'en',
    });
    final prefs = await SharedPreferences.getInstance();
    CareRepository(prefs)
      ..createFromOnboarding(
        OnboardingState()
          ..careFor = CareFor.myself
          ..patientName = 'Ravi'
          ..age = 40,
      )
      ..addMedicine(
        name: 'Paracetamol',
        strength: '500 mg',
        times: const [DoseTime.night],
      );
    final ai = ScriptedAi(prefs, [
      // Understanding what was said.
      '{"symptoms": ["headache"], "medicineChanged": false}',
      // Up front: its first question and the safety checks.
      '{"followUps": ['
          '{"id": "new", "question": "Is your headache worse in the morning '
          'or at night?", "options": ["Morning", "Night", "No difference"]},'
          '{"id": "hd_danger", "question": "Did it start suddenly, as the '
          'worst headache ever?", "options": ["No, it came slowly", '
          '"Yes, sudden and severe"]},'
          '{"id": "hd_signs", "question": "Does it come with vomiting, '
          'blurred vision, weakness or confusion?", "options": ["No", "Yes"]}'
          ']}',
      // After the answers: the next question, from them.
      '{"done": false, "question": "Does looking at a screen at night make '
          'it worse?", "options": ["Yes", "No", "Not sure"]}',
      // Then enough is known.
      '{"done": true}',
      // The questions for the doctor.
      '{"questions": ['
          '{"topic": "understand", "question": "What could be causing my '
          'headaches at night?"},'
          '{"topic": "tests", "question": "Do I need any tests for these '
          'headaches?"},'
          '{"topic": "treatment", "question": "Is it safe to keep taking '
          'paracetamol for the headache?"},'
          '{"topic": "home", "question": "Should I cut down screen time '
          'at night?"},'
          '{"topic": "followUp", "question": "Which warning signs mean I '
          'should go to the hospital straight away?"}'
          ']}',
    ]);
    await tester.pumpWidget(GurtuApp(key: UniqueKey(), prefs: prefs, ai: ai));
    await tester.pumpAndSettle();
    await openPage(tester, const PrepChatPage());

    await tester.enterText(find.byType(TextField).first, 'bad headache');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    // What they said shows at once, before Gurtu has thought about it.
    await tester.pump();
    expect(find.text('“bad headache”'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('I heard: Headache'), findsOneWidget);

    // Only the first question: nothing written in advance past it.
    expect(
      find.text('Is your headache worse in the morning or at night?'),
      findsOneWidget,
    );
    expect(ai.prompts, hasLength(2));
    // It knows the person's medicines (names, never doses).
    expect(ai.prompts[1], contains('Paracetamol (night)'));
    expect(ai.prompts[1], isNot(contains('500 mg')));

    await tester.tap(find.text('Night'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No, it came slowly'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No').last);
    await tester.pumpAndSettle();

    // The next question was written after hearing every answer.
    expect(ai.prompts, hasLength(3));
    expect(ai.prompts[2], contains('→ Night'));
    expect(ai.prompts[2], contains('→ No, it came slowly'));
    expect(
      find.text('Does looking at a screen at night make it worse?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Not sure'));
    await tester.pumpAndSettle();
    expect(ai.prompts[3], contains('→ Not sure'));

    // Enough known: on to anything else, then the questions.
    expect(find.text('Anything else the doctor should know?'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Which warning signs mean I should go to the hospital '
        'straight away?',
      ),
      findsOneWidget,
    );
    expect(find.text('Save for the visit'), findsOneWidget);
    expect(ai.prompts.last, contains('Paracetamol'));
  });

  testWidgets('a danger answer stops the questions: get help first', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'app_language': 'en',
    });
    final prefs = await SharedPreferences.getInstance();
    CareRepository(prefs).createFromOnboarding(
      OnboardingState()
        ..careFor = CareFor.myself
        ..patientName = 'Ravi'
        ..age = 40,
    );
    final ai = ScriptedAi(prefs, [
      '{"symptoms": ["headache"], "medicineChanged": false}',
      '{"followUps": ['
          '{"id": "new", "question": "Where is the pain?", '
          '"options": ["Forehead", "One side"]},'
          '{"id": "hd_danger", "question": "Did it start suddenly, as the '
          'worst headache ever?", "options": ["No, it came slowly", '
          '"Yes, sudden and severe"]},'
          '{"id": "hd_signs", "question": "Does it come with vomiting, '
          'blurred vision, weakness or confusion?", "options": ["No", "Yes"]}'
          ']}',
    ]);
    await tester.pumpWidget(GurtuApp(key: UniqueKey(), prefs: prefs, ai: ai));
    await tester.pumpAndSettle();
    await openPage(tester, const PrepChatPage());
    await tester.enterText(find.byType(TextField).first, 'headache');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('One side'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes, sudden and severe'));
    await tester.pumpAndSettle();
    expect(find.textContaining('call 108'), findsOneWidget);
    // The last safety check is still asked...
    await tester.tap(find.text('No').last);
    await tester.pumpAndSettle();
    // ...but no more questions of its own: the family should get help.
    expect(ai.prompts, hasLength(2));
    expect(find.text('Anything else the doctor should know?'), findsOneWidget);
  });
}
