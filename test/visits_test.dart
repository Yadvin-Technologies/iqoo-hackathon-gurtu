import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/visits/prep_chat_page.dart';
import 'package:gurtutest/visits/visits_page.dart';
import 'package:gurtutest/widgets/gurtu_page.dart';
import 'package:gurtutest/widgets/voice_input.dart';

import 'home_test.dart' show openHome;

/// Pretends the recognizer heard [words] as soon as listening starts.
class FakeSpeech implements SpeechService {
  FakeSpeech(this.words);

  final String words;
  int starts = 0;

  @override
  Future<bool> start({
    required String localeId,
    required void Function(String words, bool isFinal) onWords,
    required VoidCallback onStopped,
  }) async {
    starts++;
    onWords(words, true);
    return true;
  }

  @override
  Future<void> stop() async {}
}

Future<void> tapText(
  WidgetTester tester,
  String text, {
  bool settle = true,
}) async {
  final finder = find.text(text).last;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  // The listening indicator pulses forever, so it never settles.
  settle ? await tester.pumpAndSettle() : await tester.pump();
}

Future<void> openPage(WidgetTester tester, Widget page) async {
  final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
  nav.push(MaterialPageRoute(builder: (_) => page));
  await tester.pumpAndSettle();
}

Future<void> goBack(WidgetTester tester) async {
  tester.state<NavigatorState>(find.byType(Navigator).first).pop();
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() => SpeechService.instance = DeviceSpeechService());

  testWidgets('Home has one-tap doors to visits and doctor questions', (
    tester,
  ) async {
    await openHome(tester);
    expect(find.text('Doctor visit'), findsOneWidget);
    expect(find.text('Questions for the doctor'), findsOneWidget);
    expect(find.text('Gurtu helps you prepare'), findsOneWidget);
  });

  testWidgets('Gurtu asks about symptoms and suggests questions to save', (
    tester,
  ) async {
    final prefs = await openHome(tester);

    await tester.tap(find.text('Questions for the doctor'));
    await tester.pumpAndSettle();
    expect(find.textContaining("Let's get ready for the doctor"), findsOne);

    await tapText(tester, 'Fever');
    await tapText(tester, 'Continue');
    expect(find.text('Fever — since when?'), findsOneWidget);
    await tapText(tester, 'About a week');
    expect(find.text('Fever — how bad is it?'), findsOneWidget);
    await tapText(tester, 'Moderate');
    await tapText(tester, 'No');
    expect(find.text('Anything else the doctor should know?'), findsWidgets);
    await tapText(tester, 'Skip');

    expect(find.text('What could be causing the fever?'), findsOneWidget);
    expect(find.text('Does the fever need any tests?'), findsOneWidget);
    expect(find.text('When should we come back for a check-up?'), findsOne);

    // Drop one, add one of our own.
    await tester.ensureVisible(find.byTooltip('Remove question').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove question').first);
    await tester.pumpAndSettle();
    expect(find.text('What could be causing the fever?'), findsNothing);
    await tester.enterText(find.byType(TextField).last, 'Can she travel?');
    await tester.pumpAndSettle();
    await tapText(tester, 'Add');
    expect(find.text('Can she travel?'), findsOneWidget);

    await tapText(tester, 'Save for the visit');
    expect(find.text('Questions saved for the visit'), findsOneWidget);
    expect(find.textContaining('Fever · About a week · Moderate'), findsOne);
    expect(prefs.getString('care_data_v1'), contains('Can she travel?'));

    // Home now says the questions are ready.
    await goBack(tester);
    expect(find.textContaining('questions ready'), findsOneWidget);
  });

  testWidgets('spoken words are understood and red flags are called out', (
    tester,
  ) async {
    SpeechService.instance = FakeSpeech('chest pain since this morning');
    await openHome(tester);
    await openPage(tester, const PrepChatPage());

    await tapText(tester, 'Speak', settle: false);
    expect(find.text('chest pain since this morning'), findsOneWidget);
    await tester.tap(find.text('Stop listening'));
    await tester.pumpAndSettle();
    await tapText(tester, 'Continue');

    expect(find.text('I heard: Chest pain'), findsOneWidget);
    await tapText(tester, 'Since today');
    await tapText(tester, 'Severe');
    expect(find.textContaining('can be an emergency'), findsOneWidget);
  });

  testWidgets('a visit is recorded with what the doctor said', (
    tester,
  ) async {
    SpeechService.instance = FakeSpeech('Take the tablet after food.');
    final prefs = await openHome(tester);

    await tester.tap(find.text('Doctor visit'));
    await tester.pumpAndSettle();
    expect(find.text('No visits recorded yet'), findsOneWidget);

    await tapText(tester, 'Record a visit');
    await tester.enterText(find.byType(TextField).first, 'Dr. Rao');
    await tapText(tester, 'Listen to the doctor', settle: false);
    expect(find.text('Take the tablet after food.'), findsOneWidget);
    await tester.tap(find.text('Stop listening'));
    await tester.pumpAndSettle();
    await tapText(tester, 'Save visit');

    expect(find.text('Visit saved'), findsOneWidget);
    expect(find.text('All visits at a glance'), findsOneWidget);
    expect(find.text('1 visit'), findsOneWidget);
    expect(find.textContaining('Dr. Rao'), findsWidgets);
    expect(prefs.getString('care_data_v1'), contains('after food'));

    await tester.scrollUntilVisible(
      find.text('Take the tablet after food.'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(GurtuPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tapText(tester, 'Take the tablet after food.');
    expect(find.text('What the doctor said'), findsOneWidget);
  });

  testWidgets('leaving an unsaved visit asks first', (tester) async {
    await openHome(tester);
    await openPage(tester, const VisitsPage());
    await tapText(tester, 'Record a visit');
    await tester.enterText(find.byType(TextField).first, 'Dr. Rao');
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Leave without saving?'), findsOneWidget);
    await tapText(tester, 'Keep editing');
    expect(find.text('Dr. Rao'), findsOneWidget);
  });

  testWidgets('sample visits summarise and stay with their patient', (
    tester,
  ) async {
    await openHome(tester, sample: true);
    await tester.scrollUntilVisible(find.textContaining('Next visit:'), 200);
    await openPage(tester, const VisitsPage());

    expect(find.text('2 visits'), findsOneWidget);
    expect(find.text('2 doctors'), findsOneWidget);
    expect(find.textContaining('Dr. Meena Rao'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Dr. Arjun Iyer'), 200);

    // Switch to the second person from Home: none of Amma's visits.
    await goBack(tester);
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, 3000),
      3000,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('CARING FOR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nanna').last);
    await tester.pumpAndSettle();
    await openPage(tester, const VisitsPage());
    expect(find.text('No visits recorded yet'), findsOneWidget);
    expect(find.textContaining('Dr. Meena Rao'), findsNothing);
  });

  // Small 360dp phone, every language: overflow anywhere fails the test.
  for (final lang in AppLanguage.values) {
    testWidgets('visit screens fit in ${lang.englishName}', (tester) async {
      await openHome(
        tester,
        language: lang.code,
        sample: true,
        size: const Size(990, 2145),
      );
      Future<void> scrollThrough() async {
        final list = find
            .descendant(
              of: find.byType(GurtuPage).last,
              matching: find.byType(Scrollable),
            )
            .first;
        for (var i = 0; i < 8; i++) {
          await tester.drag(list, const Offset(0, -300));
          await tester.pump();
        }
      }

      await openPage(tester, const VisitsPage());
      await scrollThrough();
      await tester.tap(find.byType(VisitCard).first);
      await tester.pumpAndSettle();
      await scrollThrough();
      await goBack(tester);
      await goBack(tester);

      await openPage(tester, const PrepChatPage());
      await scrollThrough();
    });
  }
}
