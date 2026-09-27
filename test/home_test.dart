import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/main.dart';
import 'package:gurtutest/home/widgets/sos_button.dart';
import 'package:gurtutest/memory/memory_editor_page.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Opens the app straight on Home, as if onboarding for "Amma" (64) was
/// done by "Sai".
Future<SharedPreferences> openHome(
  WidgetTester tester, {
  String language = 'en',
  bool sample = false,
  bool self = false,
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
        ..careFor = self ? CareFor.myself : CareFor.parent
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
    expect(find.text('Caring for'), findsOneWidget);
    expect(find.text('Amma'), findsWidgets);
    expect(find.text('64 years'), findsOneWidget);
    // SOS is hidden until it can really reach someone.
    expect(find.text('SOS'), findsNothing);
    expect(find.text('Gurtu'), findsOneWidget);

    // Live numbers from the records, nothing made up.
    expect(find.bySemanticsLabel('Medicines: 0'), findsOneWidget);
    expect(find.bySemanticsLabel('Taken today: —'), findsOneWidget);
    expect(find.bySemanticsLabel('Next visit: —'), findsOneWidget);

    // No setup card, no sample data offer, no scan tile.
    expect(find.text('GETTING GURTU READY'), findsNothing);
    expect(find.text('Scan & verify medicine'), findsNothing);
    expect(find.text('Nothing urgent right now.'), findsOneWidget);
    // Caring for Amma: the people strip, with a way to add someone.
    expect(find.text('People you care for'), findsOneWidget);
    expect(find.bySemanticsLabel('Add someone to care for'), findsOneWidget);
    expect(find.text('Capture Care'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Doctor visit'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    for (final tab in ['Home', 'Memory', 'Circle', 'AI', 'Profile']) {
      expect(find.text(tab), findsOneWidget);
    }

    await tester.scrollUntilVisible(
      find.text('Your care story starts here.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.scrollUntilVisible(
      find.text('Care is easier together.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
  });

  testWidgets('sample data fills Home and patients never mix', (tester) async {
    await openHome(tester, sample: true);

    expect(find.text('Showing sample care data'), findsOneWidget);
    expect(find.text('2 of 4 done'), findsOneWidget);
    expect(find.text('Blood test'), findsOneWidget);

    // Ticking a task updates progress.
    final semantics = tester.ensureSemantics();
    await tester.ensureVisible(find.bySemanticsLabel('Mark as done').first);
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Mark as done').first);
    semantics.dispose();
    await tester.pumpAndSettle();
    expect(find.text('3 of 4 done'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Doctor conversation'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.scrollUntilVisible(
      find.text('Anu'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    // Switch to the second person: none of Amma's care shows.
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, 3000),
      3000,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Caring for'));
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

    await tester.ensureVisible(find.text('Capture Care'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Capture Care'));
    await tester.pumpAndSettle();
    expect(find.text('What happened?'), findsOneWidget);
    await tester.tap(find.text('Note'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Felt dizzy after walking');
    await tester.pump();
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Felt dizzy after walking'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Open · Written note'), findsOneWidget);
    expect(prefs.getString('care_data_v1'), contains('Felt dizzy'));
  });

  testWidgets('Capture Care offers a document scan and a note only', (
    tester,
  ) async {
    DocumentCamera.instance = _NoCamera();
    addTearDown(() => DocumentCamera.instance = DeviceDocumentCamera());
    await openHome(tester);
    await tester.ensureVisible(find.text('Capture Care'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Capture Care'));
    await tester.pumpAndSettle();
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Note'), findsOneWidget);
    for (final gone in ['Voice', 'Vital', 'Document', 'Coming soon']) {
      expect(find.text(gone), findsNothing);
    }
    expect(find.text('Report, prescription or any document'), findsOneWidget);
    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();
    // Straight to the camera, saving into the care memory.
    expect(find.byType(MemoryEditorPage), findsOneWidget);
  });

  testWidgets('pulling down on Home shows what is saved', (tester) async {
    final prefs = await openHome(tester);
    expect(find.text('Felt better today'), findsNothing);

    // Saved by another part of the app (or another screen) meanwhile.
    CareRepository(prefs).addNote('Felt better today');
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Felt better today'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
  });

  testWidgets('SOS needs a 2-second hold and says nothing was sent', (
    tester,
  ) async {
    await openHome(tester);
    // Hidden on Home for now; the button itself still works.
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Center(child: SosButton())),
          ),
        );
    await tester.pumpAndSettle();

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

  // The person cared for, on their own phone: no people strip, "Looking
  // after you" instead of the circle preview.
  for (final lang in AppLanguage.values) {
    testWidgets('your own Home fits in ${lang.englishName}', (tester) async {
      await openHome(
        tester,
        language: lang.code,
        self: true,
        size: const Size(990, 2145),
      );
      final l = lookupAppLocalizations(lang.locale);
      expect(find.text(l.yourCare), findsOneWidget);
      expect(find.text(l.peopleYouCareFor), findsNothing);
      final list = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.text(l.lookingAfterYou),
        200,
        scrollable: list,
      );
      expect(find.text(l.inviteFamily), findsOneWidget);
      for (var i = 0; i < 12; i++) {
        await tester.drag(list, const Offset(0, -300));
        await tester.pump();
      }
    });
  }
}

/// The camera, cancelled straight away.
class _NoCamera implements DocumentCamera {
  @override
  bool get available => true;

  @override
  Future<String?> pick({required bool fromGallery}) async => null;
}
