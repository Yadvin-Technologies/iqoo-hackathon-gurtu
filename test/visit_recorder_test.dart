import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/data/visit_models.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/visits/visit_recorder_page.dart';
import 'package:gurtutest/widgets/gurtu_page.dart';
import 'package:gurtutest/widgets/voice_input.dart';

import 'home_test.dart' show openHome;
import 'visits_test.dart' show openPage;

/// A recognizer the test drives by hand: what is heard, when a session
/// stops, and what goes wrong.
class ScriptedSpeech implements SpeechService {
  final locales = <String>[];
  int stops = 0;
  void Function(String words, bool isFinal)? _words;
  VoidCallback? _stopped;
  ValueChanged<SpeechFailure>? _failed;

  /// Makes the next start fail with this.
  SpeechFailure? refuse;

  @override
  Future<bool> start({
    required String localeId,
    required void Function(String words, bool isFinal) onWords,
    required VoidCallback onStopped,
    ValueChanged<SpeechFailure>? onFailed,
    ValueChanged<double>? onLevel,
  }) async {
    locales.add(localeId);
    if (refuse case final failure?) {
      refuse = null;
      onFailed?.call(failure);
      return false;
    }
    _words = onWords;
    _stopped = onStopped;
    _failed = onFailed;
    return true;
  }

  @override
  Future<void> stop() async {
    stops++;
    _words = null;
    _stopped = null;
  }

  void hear(String words, {bool done = false}) => _words?.call(words, done);

  /// The recognizer stops on silence, maybe because of [failure].
  void silence([SpeechFailure? failure]) {
    if (failure != null) _failed?.call(failure);
    final stopped = _stopped;
    _words = null;
    _stopped = null;
    stopped?.call();
  }
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  late ScriptedSpeech speech;
  setUp(() => SpeechService.instance = speech = ScriptedSpeech());
  tearDown(() => SpeechService.instance = DeviceSpeechService());

  group('listening to the doctor', () {
    testWidgets('keeps going through pauses, one sentence per line', (
      tester,
    ) async {
      final text = TextEditingController();
      final c = DictationController(text, continuous: true, live: false);
      addTearDown(c.dispose);

      await c.start(const Locale('en'), localeId: 'te_IN');
      expect(speech.locales, ['te_IN']);
      expect(c.listening, isTrue);

      // Words being heard stay out of the field until the sentence ends.
      speech.hear('Take the tablet');
      expect(c.partial, 'Take the tablet');
      expect(text.text, isEmpty);
      speech.hear('Take the tablet after food', done: true);
      expect(text.text, 'Take the tablet after food');
      expect(c.partial, isEmpty);

      // Silence ends the platform session: listening picks up again.
      speech.silence();
      expect(c.listening, isTrue);
      await tester.pump(const Duration(milliseconds: 400));
      expect(speech.locales, hasLength(2));

      // Typing in between is kept; the next sentence goes on a new line.
      text.text = '${text.text} twice a day';
      speech.hear('Come back in two weeks', done: true);
      expect(
        text.text,
        'Take the tablet after food twice a day\nCome back in two weeks',
      );

      // Stopping keeps the half-heard sentence.
      speech.hear('Walk every');
      await c.stop();
      expect(c.listening, isFalse);
      expect(text.text, endsWith('\nWalk every'));
    });

    testWidgets('waits out a lost connection instead of stopping', (
      tester,
    ) async {
      final c = DictationController(
        TextEditingController(),
        continuous: true,
        live: false,
      );
      addTearDown(c.dispose);
      await c.start(const Locale('en'));
      expect(speech.locales, ['en_IN']);

      speech.silence(SpeechFailure.network);
      expect(c.listening, isTrue);
      expect(c.problem, SpeechFailure.network);
      await tester.pump(const Duration(seconds: 1));
      expect(speech.locales, hasLength(1));
      await tester.pump(const Duration(seconds: 2));
      expect(speech.locales, hasLength(2));

      // Words again: the problem is over.
      speech.hear('Back again');
      expect(c.problem, isNull);
      await c.stop();
    });

    testWidgets('stops and says why when the language is missing', (
      tester,
    ) async {
      final c = DictationController(
        TextEditingController(),
        continuous: true,
        live: false,
      );
      addTearDown(c.dispose);
      final failures = <SpeechFailure>[];
      await c.start(
        const Locale('en'),
        localeId: 'te_IN',
        onFailure: failures.add,
      );
      speech.silence(SpeechFailure.language);
      expect(c.listening, isFalse);
      expect(failures, [SpeechFailure.language]);
      await tester.pump(const Duration(seconds: 5));
      expect(speech.locales, hasLength(1));

      // A refused microphone is reported straight away.
      speech.refuse = SpeechFailure.permission;
      expect(await c.start(const Locale('en'), onFailure: failures.add), false);
      expect(c.listening, isFalse);
      expect(failures.last, SpeechFailure.permission);
    });

    testWidgets('switching language carries on in the new one', (tester) async {
      final text = TextEditingController();
      final c = DictationController(text, continuous: true, live: false);
      addTearDown(c.dispose);
      await c.start(const Locale('en'), localeId: 'en_IN');
      speech.hear('BP is fine');
      await c.switchLanguage('hi_IN');
      expect(text.text, 'BP is fine');
      await tester.pump(const Duration(milliseconds: 400));
      expect(speech.locales, ['en_IN', 'hi_IN']);
      expect(c.listening, isTrue);
      await c.stop();
    });

    testWidgets('a Speak field shows words as they come', (tester) async {
      final text = TextEditingController(text: 'Metformin');
      final c = DictationController(text);
      addTearDown(c.dispose);
      await c.start(const Locale('hi'));
      expect(speech.locales, ['hi_IN']);
      speech.hear('500 mg');
      expect(text.text, 'Metformin 500 mg');
      speech.hear('500 mg after breakfast', done: true);
      expect(text.text, 'Metformin 500 mg after breakfast');
      speech.silence();
      expect(c.listening, isFalse);
    });
  });

  test('visits saved before medicines were a list still load', () {
    final old = {
      'id': 'v1',
      'patientId': 'p',
      'date': '2026-09-20T10:00:00.000',
      'createdBy': 'm',
      'medicines': 'Metformin 500 mg after breakfast',
      'tests': 'HbA1c',
      'attachments': [
        {
          'id': 'a1',
          'kind': 'photo',
          'section': 'medicines',
          'file': 'rx.jpg',
          'createdAt': '2026-09-20T10:00:00.000',
        },
        {
          'id': 'a2',
          'kind': 'photo',
          'section': 'nextVisit',
          'file': 'card.jpg',
          'createdAt': '2026-09-20T10:00:00.000',
        },
      ],
    };
    final visit = DoctorVisit.fromJson(old);
    final medicine = visit.medicines.single;
    expect(medicine.note, 'Metformin 500 mg after breakfast');
    expect(visit.attachmentsOf(medicine).single.file, 'rx.jpg');
    expect(visit.attachmentsFor(VisitSection.nextVisit).single.itemId, isNull);
    expect(visit.tests, 'HbA1c');

    // And the new shape reads back the same.
    final back = DoctorVisit.fromJson(visit.toJson());
    expect(back.medicines.single.id, medicine.id);
    expect(back.attachmentsOf(back.medicines.single), hasLength(1));

    // Nothing noted: no empty medicine appears.
    expect(
      DoctorVisit.fromJson({...old, 'medicines': '', 'attachments': []})
          .medicines,
      isEmpty,
    );
  });

  testWidgets('recording a visit: language, live words, medicines, questions', (
    tester,
  ) async {
    final prefs = await openHome(tester);
    final repo = CareScope.of(tester.element(find.byType(Scaffold).first));
    final prep = repo.savePrep(
      (id, patientId) => VisitPrep(
        id: id,
        patientId: patientId,
        createdAt: DateTime(2026, 9, 27),
        questions: [
          DoctorQuestion(
            id: 'q1',
            kind: QuestionKind.custom,
            text: 'Is it serious?',
          ),
          DoctorQuestion(
            id: 'q2',
            kind: QuestionKind.custom,
            text: 'Can she travel?',
          ),
        ],
      ),
    )!;
    await openPage(tester, VisitRecorderPage(prepId: prep.id));

    // Tests to do are no longer asked for.
    expect(find.text('Tests to do'), findsNothing);

    // Pick Telugu and listen.
    expect(find.text('English'), findsOneWidget);
    expect(find.text('हिन्दी'), findsOneWidget);
    await _tap(tester, find.text('తెలుగు'));
    // The text box speaks the doctor's language.
    final te = lookupAppLocalizations(const Locale('te'));
    expect(find.text(te.doctorSaidHint), findsOneWidget);
    expect(find.text(te.transcriptHelp), findsOneWidget);
    expect(find.text("Record the doctor's voice"), findsOneWidget);
    await _tap(tester, find.text('Listen to the doctor'));
    expect(speech.locales, ['te_IN']);
    expect(find.text('Listening · తెలుగు'), findsOneWidget);
    expect(prefs.getString('visit_voice_language'), 'te');

    speech.hear('మందు రోజుకు రెండు సార్లు');
    await tester.pump();
    expect(find.text('మందు రోజుకు రెండు సార్లు'), findsOneWidget);
    speech.hear('మందు రోజుకు రెండు సార్లు వేసుకోండి', done: true);
    await tester.pump();
    final notes = find.widgetWithText(
      TextField,
      'మందు రోజుకు రెండు సార్లు వేసుకోండి',
    );
    expect(notes, findsOneWidget);

    await _tap(tester, find.text('Stop listening'));
    await tester.pumpAndSettle();
    expect(find.text('Listening · తెలుగు'), findsNothing);

    // Remove an unwanted question, with undo on offer.
    await tester.ensureVisible(find.byTooltip('Remove question').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove question').first);
    await tester.pumpAndSettle();
    expect(find.text('Question removed'), findsOneWidget);
    expect(find.text('Is it serious?'), findsNothing);
    expect(prep.questions.map((q) => q.id), ['q2']);

    // Two medicines: one written, one added then dropped.
    const hint = 'e.g. Metformin 500 mg after breakfast';
    expect(find.text('Medicine 1'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, hint),
      'Metformin 500 mg after breakfast',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add another medicine'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add another medicine'));
    await tester.pumpAndSettle();
    expect(find.text('Medicine 2'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Delete medicine').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete medicine').last);
    await tester.pumpAndSettle();
    expect(find.text('Medicine 2'), findsNothing);

    // Once the "Question removed" note has gone from over the button.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save visit'));
    await tester.pumpAndSettle();
    expect(find.text('Visit saved'), findsOneWidget);
    // Straight on to checking the medicine's reminders.
    expect(find.text('Medicine reminders'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Metformin'), findsOneWidget);

    final visit = repo.visits.last;
    expect(visit.notes, 'మందు రోజుకు రెండు సార్లు వేసుకోండి');
    expect(visit.medicines.single.note, 'Metformin 500 mg after breakfast');
    expect(visit.tests, isEmpty);
    expect(prep.visitId, visit.id);
    expect(prefs.getString('care_data_v1'), contains('medicineList'));
  });

  // Small 360dp phone, every language: overflow anywhere fails the test.
  for (final lang in AppLanguage.values) {
    testWidgets('the recorder fits in ${lang.englishName}', (tester) async {
      await openHome(tester, language: lang.code, size: const Size(990, 2145));
      await openPage(tester, const VisitRecorderPage());
      final list = find
          .descendant(
            of: find.byType(GurtuPage).last,
            matching: find.byType(Scrollable),
          )
          .first;

      // Listening, with words on the live panel.
      final listen = find.byWidgetPredicate((w) => w is VoiceButton && w.large);
      await tester.scrollUntilVisible(listen, 200, scrollable: list);
      await tester.ensureVisible(listen);
      await tester.pump();
      await tester.tap(listen);
      await tester.pump();
      speech.hear('Blood pressure is a little high, reduce salt');
      await tester.pump(const Duration(seconds: 2));
      expect(find.textContaining('reduce salt'), findsOneWidget);
      await tester.tap(listen);
      await tester.pumpAndSettle();

      for (var i = 0; i < 10; i++) {
        await tester.drag(list, const Offset(0, -300));
        await tester.pump();
      }
    });
  }
}
