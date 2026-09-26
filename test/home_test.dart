import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/main.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Opens the app straight on Home, as if onboarding for "Amma" (64) was
/// done by "Sai".
Future<SharedPreferences> openHome(
  WidgetTester tester, {
  String language = 'en',
  bool sample = false,
  Size size = const Size(1080, 2400),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({
    'onboarding_complete': true,
    'app_language': language,
  });
  final prefs = await SharedPreferences.getInstance();
  final repo = CareRepository(prefs)
    ..createFromOnboarding(
      OnboardingState()
        ..careFor = CareFor.parent
        ..patientName = 'Amma'
        ..yourName = 'Sai'
        ..age = 64,
    );
  if (sample) repo.addSampleData(secondPatientName: 'Nanna');

  await tester.pumpWidget(
    GurtuApp(key: UniqueKey(), prefs: prefs, ai: GurtuAi(prefs)..init()),
  );
  await tester.pumpAndSettle();
  return prefs;
}

void main() {
  testWidgets('first-time Home shows context, empty states and navigation', (
    tester,
  ) async {
    await openHome(tester);

    expect(find.text('Welcome to Gurtu, Sai'), findsOneWidget);
    expect(find.text('CARING FOR'), findsOneWidget);
    expect(find.text('Amma'), findsWidgets);
    expect(find.text('64 years'), findsOneWidget);
    expect(find.text('SOS'), findsOneWidget);
    expect(find.text('Nothing urgent right now.'), findsOneWidget);
    expect(find.text('Capture Care'), findsOneWidget);
    expect(find.text('Doctor visit'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('GETTING GURTU READY'), 200);
    for (final tab in ['Home', 'Memory', 'Circle', 'AI', 'Profile']) {
      expect(find.text(tab), findsOneWidget);
    }

    await tester.scrollUntilVisible(
      find.text('Your care story starts here.'),
      200,
    );
    await tester.scrollUntilVisible(find.text('Care is easier together.'), 200);
  });

  testWidgets('sample data fills Home and patients never mix', (tester) async {
    await openHome(tester, sample: true);

    expect(find.text('Showing sample care data'), findsOneWidget);
    expect(find.text('2 of 4 done'), findsOneWidget);
    expect(find.text('Blood test'), findsOneWidget);

    // Ticking a task updates progress.
    final semantics = tester.ensureSemantics();
    await tester.tap(find.bySemanticsLabel('Mark as done').first);
    semantics.dispose();
    await tester.pumpAndSettle();
    expect(find.text('3 of 4 done'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Doctor conversation'), 200);
    await tester.scrollUntilVisible(find.text('Anu'), 200);

    // Switch to the second person: none of Amma's care shows.
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

    expect(find.text('0 of 1 done'), findsOneWidget);
    expect(find.text('Blood test'), findsNothing);
    expect(find.text('Doctor conversation'), findsNothing);
    expect(find.text('Anu'), findsNothing);
  });

  testWidgets('a note captured on Home appears in recent memory', (
    tester,
  ) async {
    final prefs = await openHome(tester);

    await tester.tap(find.text('Capture Care'));
    await tester.pumpAndSettle();
    expect(find.text('What happened?'), findsOneWidget);
    await tester.tap(find.text('Note'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Felt dizzy after walking');
    await tester.pump();
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Felt dizzy after walking'), 200);
    expect(find.text('Open · Written note'), findsOneWidget);
    expect(prefs.getString('care_data_v1'), contains('Felt dizzy'));
  });

  testWidgets('SOS needs a 2-second hold and says nothing was sent', (
    tester,
  ) async {
    await openHome(tester);

    await tester.tap(find.text('SOS'));
    await tester.pumpAndSettle();
    expect(find.textContaining('This is a preview'), findsOneWidget);

    // A quick tap does nothing.
    await tester.tap(find.byIcon(Icons.sos_rounded).last);
    await tester.pumpAndSettle();
    expect(find.text('Preview finished. No one was alerted.'), findsNothing);

    final hold = await tester.startGesture(
      tester.getCenter(find.byIcon(Icons.sos_rounded).last),
    );
    for (var i = 0; i < 22; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await hold.up();
    await tester.pumpAndSettle();
    expect(find.text('Preview finished. No one was alerted.'), findsOneWidget);
  });

  // A small 360dp phone, every language, the fullest Home: any overflow
  // throws and fails the test.
  for (final lang in AppLanguage.values) {
    testWidgets('Home fits in ${lang.englishName}', (tester) async {
      await openHome(
        tester,
        language: lang.code,
        sample: true,
        size: const Size(990, 2145),
      );
      final list = find.byType(Scrollable).first;
      for (var i = 0; i < 12; i++) {
        await tester.drag(list, const Offset(0, -300));
        await tester.pump();
      }
      // Any overflow is reported by the test framework and fails the test.
    });
  }
}
