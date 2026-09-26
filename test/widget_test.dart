import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    // permission_handler: 1 == PermissionStatus.granted.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/permissions/methods'),
          (call) async => call.method == 'checkPermissionStatus' ? 1 : null,
        );
  });

  Future<SharedPreferences> launch(
    WidgetTester tester, [
    Map<String, Object> saved = const {},
  ]) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(saved);
    final prefs = await SharedPreferences.getInstance();
    // A fresh key makes each launch a real cold start, like reopening the app.
    // Tests don't run on a phone, so Gurtu AI reports itself unsupported.
    await tester.pumpWidget(
      GurtuApp(key: UniqueKey(), prefs: prefs, ai: GurtuAi(prefs)..init()),
    );
    await tester.pump();
    return prefs;
  }

  // The welcome orbit animates forever, so pump fixed durations.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  testWidgets('onboarding walks from language to home', (tester) async {
    final prefs = await launch(tester);

    Future<void> tap(String text) async {
      await tester.tap(find.text(text).last);
      await settle(tester);
    }

    expect(find.text('Choose your language'), findsOneWidget);
    await tap('Continue');

    expect(find.text("Your family's\nmemory of care"), findsOneWidget);
    await tap('Get started');
    await tap('Skip');

    await tap('My parent');
    await tap('Continue');

    expect(find.text('Tell us about them'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'Amma');
    await tester.enterText(find.byType(TextField).at(1), '64');
    await tester.enterText(find.byType(TextField).at(2), 'Priya');
    await settle(tester);
    await tap('Continue');

    expect(
      find.text('Does Amma have any of these health conditions?'),
      findsOneWidget,
    );
    await tap('High BP');
    await tap('Continue');

    expect(find.text('Does Amma take medicines every day?'), findsOneWidget);
    await tap('Yes');
    await tap('Continue');

    await tap('No known allergies');
    await tap('Continue');

    await tap('Needs some help');
    await tap('Continue');

    await tap('Yes');
    await tap('Continue');

    // The permission channel is mocked above to report everything granted.
    expect(find.text('A few permissions to help you'), findsOneWidget);
    await settle(tester);
    expect(find.text('Allow'), findsNothing);
    await tap('Continue');

    expect(find.text("Set up Gurtu's on-device AI"), findsOneWidget);
    expect(
      find.text(
        "This phone can't run Gurtu AI. Gurtu still helps using its "
        'built-in guidance.',
      ),
      findsOneWidget,
    );
    await tap('Continue');

    expect(find.text('All set, Priya!'), findsOneWidget);
    expect(find.text('Amma · 64 years'), findsOneWidget);
    expect(find.text('High BP'), findsOneWidget);
    await tap('Enter Gurtu');

    // Onboarding answers are saved and Home picks them up.
    expect(find.text('Welcome to Gurtu, Priya'), findsOneWidget);
    expect(find.text('Amma'), findsWidgets);
    expect(prefs.getBool('onboarding_complete'), isTrue);
    final saved = prefs.getString('care_data_v1')!;
    expect(saved, contains('"highBp"'));
    // Every onboarding answer is kept, not only the ones Home shows.
    expect(saved, contains('"careFor":"parent"'));
    expect(saved, contains('"takesMedicines":"yes"'));
    expect(saved, contains('"mobility":"someHelp"'));
    expect(saved, contains('"recentHospitalVisit":"yes"'));
    expect(prefs.getString('onboarding_draft_v1'), isNull);
  });

  testWidgets('closing the app mid-onboarding resumes where it left off', (
    tester,
  ) async {
    final prefs = await launch(tester, {
      'onboarding_draft_v1':
          '{"step":4,"answers":{"careFor":"parent","patientName":"Amma",'
          '"age":64,"conditions":["diabetes","notARealCondition"]}}',
    });
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Tell us about them'), findsOneWidget);
    expect(find.text('Amma'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(2), 'Priya');
    await tester.pump();
    expect(prefs.getString('onboarding_draft_v1'), contains('"Priya"'));
    expect(prefs.getString('onboarding_draft_v1'), contains('"diabetes"'));
  });

  testWidgets('picking a language switches the app and is remembered', (
    tester,
  ) async {
    final prefs = await launch(tester);

    await tester.tap(find.text('हिन्दी'));
    await settle(tester);

    // The picker itself switches straight away.
    expect(find.text('अपनी भाषा चुनें'), findsOneWidget);
    expect(prefs.getString('app_language'), 'hi');

    await tester.tap(find.text('आगे बढ़ें').last);
    await settle(tester);
    expect(find.text('शुरू करें'), findsOneWidget);

    // Relaunch: the saved language wins.
    await launch(tester, {'app_language': 'te'});
    expect(find.text('మీ భాషను ఎంచుకోండి'), findsOneWidget);
  });

  testWidgets('every language has a translated language screen', (
    tester,
  ) async {
    for (final lang in AppLanguage.values) {
      await launch(tester, {'app_language': lang.code});
      final l = await AppLocalizations.delegate.load(lang.locale);
      expect(find.text(l.languageTitle), findsOneWidget, reason: lang.name);
      expect(
        lang == AppLanguage.english ||
            l.languageTitle != 'Choose your language',
        isTrue,
        reason: '${lang.name} is not translated',
      );
    }
  });
}
