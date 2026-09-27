import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/cloud/cloud_sync.dart';
import 'package:gurtutest/cloud/gurtu_api.dart';
import 'package:gurtutest/cloud/push_service.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/data/medicine_models.dart';
import 'package:gurtutest/data/visit_models.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/main.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:gurtutest/reminders/dose_alert.dart';
import 'package:gurtutest/reminders/dose_reminder_page.dart';
import 'package:gurtutest/reminders/medicine_plan.dart';
import 'package:gurtutest/reminders/reminder_review_page.dart';
import 'package:gurtutest/visits/visit_detail_page.dart';
import 'package:gurtutest/visits/visit_recorder_page.dart';
import 'package:gurtutest/widgets/gurtu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cloud_test.dart' show FakePush, FakeServer;
import 'visits_test.dart' show openPage, seeText, tapText;

/// Speaks and plays nothing; remembers what it was asked to.
class FakeVoice implements ReminderVoice {
  final said = <String>[];
  final played = <String>[];

  @override
  Future<void> speak(String text, {required String languageCode}) async =>
      said.add('$languageCode: $text');

  @override
  Future<void> play(String url) async => played.add(url);

  @override
  Future<void> stop() async {}
}

PlannedMedicine read(String text) =>
    const MedicineRules().read(text, visitMedicineId: 'vm1');

/// A reminder push as the backend sends it (see reminders.js `doseData`).
PushMessage reminderPush({
  String doseId = 'd1',
  String type = 'reminder',
  String title = 'Time for Metformin 500 mg',
  String body = 'After food',
}) => PushMessage(
  title: title,
  body: body,
  data: {
    'type': type,
    'doseId': doseId,
    'reminderId': 'r1',
    'circleId': 'circle-1',
    'medicine': 'Metformin 500 mg',
    'food': 'afterFood',
    'note': '',
    'slot': 'morning',
    'time': '08:00',
    'patient': 'Amma',
    'audioUrl': 'https://iqoo.yadvin.tech/v1/files/abc',
    'followUp': '0',
  },
);

void main() {
  late FakeVoice voice;

  setUp(() {
    PushService.instance = FakePush();
    ReminderVoice.instance = voice = FakeVoice();
  });
  tearDown(() {
    PushService.instance = FirebasePushService();
    ReminderVoice.instance = DeviceReminderVoice();
  });

  group('reading medicine notes without Gurtu AI', () {
    test('English short forms, food and a course', () {
      final p = read('Metformin 500 mg 1-0-1 after food for 5 days');
      expect(p.name, 'Metformin');
      expect(p.strength, '500 mg');
      expect(p.orderedTimes, [DoseTime.morning, DoseTime.night]);
      expect(p.food, FoodTiming.afterFood);
      expect(p.days, 5);
    });

    test('Hindi', () {
      final p = read('Amlodipine 5 mg रात को खाने के बाद');
      expect(p.name, 'Amlodipine');
      expect(p.orderedTimes, [DoseTime.night]);
      expect(p.food, FoodTiming.afterFood);
      expect(p.days, isNull);
    });

    test('Telugu: "a day" is not a number of days', () {
      final p = read('Pantop 40 రోజుకు రెండు సార్లు భోజనానికి ముందు 1 week');
      expect(p.name, 'Pantop');
      expect(p.orderedTimes, [DoseTime.morning, DoseTime.night]);
      expect(p.food, FoodTiming.beforeFood);
      expect(p.days, 7);
    });

    test('instruction words are not part of the name', () {
      final p = read('Paracetamol twice a day');
      expect(p.name, 'Paracetamol');
      expect(p.orderedTimes, [DoseTime.morning, DoseTime.night]);
    });
  });

  group("checking Gurtu AI's answer", () {
    final rules = PlannedMedicine(
      visitMedicineId: 'vm1',
      name: 'Metformin',
      strength: '500 mg',
      times: {DoseTime.morning},
      food: FoodTiming.afterFood,
    );

    test('a good answer is used', () {
      final p = MedicinePlanner.parseAiAnswer(
        'Sure! {"name": "Metformin", "strength": "500 mg", "times": '
        '["morning", "Night"], "food": "beforeFood", "days": 10, '
        '"note": "with warm water"}',
        rules,
      )!;
      expect(p.byAi, isTrue);
      expect(p.orderedTimes, [DoseTime.morning, DoseTime.night]);
      expect(p.food, FoodTiming.beforeFood);
      expect(p.days, 10);
      expect(p.note, 'with warm water');
    });

    test('gaps and nonsense fall back to the rules', () {
      final p = MedicinePlanner.parseAiAnswer(
        '{"name": "", "times": ["noonish"], "food": "sometimes", '
        '"days": -3}',
        rules,
      )!;
      expect(p.name, 'Metformin');
      expect(p.orderedTimes, [DoseTime.morning]);
      expect(p.food, FoodTiming.afterFood);
      expect(p.days, isNull);
      expect(MedicinePlanner.parseAiAnswer('I cannot help', rules), isNull);
    });
  });

  group('reminders on the server', () {
    Future<(CloudSync, FakeServer, SharedPreferences)> linked() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final server = FakeServer();
      final sync = CloudSync(prefs, api: GurtuApi(client: server.client));
      await sync.start(language: 'en');
      final repo = CareRepository(prefs)
        ..createFromOnboarding(
          OnboardingState()
            ..careFor = CareFor.parent
            ..patientName = 'Amma'
            ..yourName = 'Sai',
        );
      await sync.createCircle(
        repo.selectedPatient!.id,
        CloudSync.circlePayload(repo.selectedPatient!, myName: 'Sai'),
      );
      return (sync, server, prefs);
    }

    test('one reminder per medicine and time; turned-off times go', () async {
      final (sync, server, _) = await linked();
      final patientId = sync.patientForCircle('circle-1')!;
      final metformin = read('Metformin 500 mg 1-0-1 after food for 5 days');
      await sync.setVisitReminders(
        patientId: patientId,
        visitId: 'v1',
        plan: [metformin],
      );
      final puts = server.requests.where((r) => r.startsWith('PUT /v1/c'));
      expect(puts, [
        'PUT /v1/circles/circle-1/medicine-reminders/v1%3Avm1%3Amorning',
        'PUT /v1/circles/circle-1/medicine-reminders/v1%3Avm1%3Anight',
      ]);
      final body =
          server.bodies['PUT /v1/circles/circle-1/medicine-reminders/'
              'v1%3Avm1%3Anight']!;
      expect(body['time'], '21:00');
      expect(body['slot'], 'night');
      expect((body['medicine'] as Map)['food'], 'afterFood');
      expect(body['until'], isNotNull);
      expect(sync.hasWaitingReminders('v1'), isFalse);

      // Night is turned off: its reminder is deleted.
      metformin.times.remove(DoseTime.night);
      await sync.setVisitReminders(
        patientId: patientId,
        visitId: 'v1',
        plan: [metformin],
      );
      expect(
        server.requests.last,
        'DELETE /v1/circles/circle-1/medicine-reminders/v1%3Avm1%3Anight',
      );
      expect(sync.planFor('v1')!.single.orderedTimes, [DoseTime.morning]);
    });

    test('offline, reminders and answers wait and are sent later', () async {
      final (sync, server, prefs) = await linked();
      final patientId = sync.patientForCircle('circle-1')!;
      server.offline = true;
      await sync.setVisitReminders(
        patientId: patientId,
        visitId: 'v1',
        plan: [read('Metformin 500 mg after breakfast')],
      );
      expect(await sync.ackDose('d1', 'taken'), isFalse);
      expect(sync.hasWaitingReminders('v1'), isTrue);
      expect(sync.hasWaitingAnswers, isTrue);

      // After a restart, back online.
      server.offline = false;
      server.requests.clear();
      final later = CloudSync(prefs, api: GurtuApi(client: server.client));
      await later.start(language: 'en');
      expect(
        server.requests,
        containsAll([
          'PUT /v1/circles/circle-1/medicine-reminders/v1%3Avm1%3Amorning',
          'POST /v1/doses/d1/ack',
        ]),
      );
      expect(server.bodies['POST /v1/doses/d1/ack'], {'status': 'taken'});
      expect(later.hasWaitingReminders('v1'), isFalse);
      expect(later.hasWaitingAnswers, isFalse);
    });
  });

  test('doses taken on other phones are ticked here', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = CareRepository(await SharedPreferences.getInstance())
      ..createFromOnboarding(
        OnboardingState()
          ..careFor = CareFor.parent
          ..patientName = 'Amma'
          ..yourName = 'Sai',
      );
    final patientId = repo.selectedPatient!.id;
    repo.saveFromReminders(patientId, [
      (
        name: 'Metformin',
        strength: '500 mg',
        times: [DoseTime.morning],
        food: FoodTiming.afterFood,
      ),
    ]);
    final metformin = repo.medicineList.single;
    final at = DateTime.now();
    final remote = [
      {
        'medicine': {'name': 'Metformin', 'strength': '500 mg'},
        'slot': 'morning',
        'scheduledAt': at.toUtc().toIso8601String(),
        'status': 'taken',
        'takenAt': at.toUtc().toIso8601String(),
        'takenBy': 'Sai',
      },
      {
        'medicine': {'name': 'Metformin'},
        'slot': 'night',
        'scheduledAt': at.toUtc().toIso8601String(),
        'status': 'pending',
      },
    ];
    expect(repo.applyRemoteDoses(patientId, remote), 1);
    expect(repo.doseTaken(metformin, DoseTime.morning, at), isNotNull);
    expect(repo.doseTaken(metformin, DoseTime.night, at), isNull);
    // Seen again: not ticked twice.
    expect(repo.applyRemoteDoses(patientId, remote), 0);

    // Turning the same medicine's reminders on again updates it.
    repo.saveFromReminders(patientId, [
      (
        name: 'metformin',
        strength: '',
        times: [DoseTime.night, DoseTime.morning],
        food: FoodTiming.afterFood,
      ),
    ]);
    expect(repo.medicineList.single.times, [DoseTime.morning, DoseTime.night]);
    expect(repo.medicineList.single.strength, '500 mg');
  });

  /// Gurtu with Amma's care circle saved on the (fake) server.
  Future<(CareRepository, FakeServer)> openLinked(
    WidgetTester tester, {
    String language = 'en',
    Size size = const Size(1080, 2400),
    bool auto = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'app_language': language,
      'auto_medicine_reminders': auto,
    });
    final prefs = await SharedPreferences.getInstance();
    final seed = CareRepository(prefs)
      ..createFromOnboarding(
        OnboardingState()
          ..careFor = CareFor.parent
          ..patientName = 'Amma'
          ..yourName = 'Sai'
          ..age = 64,
      );
    final server = FakeServer();
    final sync = CloudSync(prefs, api: GurtuApi(client: server.client));
    await sync.createCircle(
      seed.selectedPatient!.id,
      CloudSync.circlePayload(seed.selectedPatient!, myName: 'Sai'),
    );
    await tester.pumpWidget(
      GurtuApp(
        key: UniqueKey(),
        prefs: prefs,
        ai: GurtuAi(prefs)..init(),
        cloud: sync,
        online: true,
      ),
    );
    await tester.pumpAndSettle();
    final repo = CareScope.of(tester.element(find.byType(Scaffold).first));
    return (repo, server);
  }

  DoctorVisit addVisit(CareRepository repo) => repo.addVisit(
    date: DateTime.now(),
    doctorName: 'Dr. Rao',
    medicines: const [
      VisitMedicine(id: 'vm1', note: 'Metformin 500 mg 1-0-1 after food'),
      VisitMedicine(id: 'vm2', note: 'Amlodipine 5 mg रात को'),
    ],
  )!;

  testWidgets('the family checks what Gurtu read, then turns reminders on', (
    tester,
  ) async {
    final (repo, server) = await openLinked(tester);
    final visit = addVisit(repo);
    await openPage(tester, VisitDetailPage(visitId: visit.id));
    await tapText(tester, 'Set up reminders');

    expect(find.text('Medicine reminders'), findsOneWidget);
    expect(find.text('Read from your notes'), findsWidgets);
    expect(find.widgetWithText(TextField, 'Metformin'), findsOneWidget);

    // Amlodipine at night only: add the morning too, for 3 days.
    await seeText(tester, 'Amlodipine');
    expect(find.widgetWithText(TextField, 'Amlodipine'), findsOneWidget);
    final amlodipine = find.ancestor(
      of: find.widgetWithText(TextField, 'Amlodipine'),
      matching: find.byType(Column),
    );
    final morning = find.descendant(
      of: amlodipine.first,
      matching: find.text('Morning'),
    );
    await tester.ensureVisible(morning);
    await tester.pumpAndSettle();
    await tester.tap(morning);
    await tester.pump();
    final course = find.descendant(
      of: amlodipine.first,
      matching: find.text('For 5 days'),
    );
    await tester.ensureVisible(course);
    await tester.pumpAndSettle();
    await tester.tap(course);
    await tester.pump();
    for (var i = 0; i < 2; i++) {
      await tester.tap(
        find.descendant(
          of: amlodipine.first,
          matching: find.byIcon(Icons.remove_rounded),
        ),
      );
      await tester.pump();
    }
    expect(find.text('For 3 days'), findsOneWidget);
    // Amma isn't on Gurtu: the family gets the reminders.
    await tester.scrollUntilVisible(
      find.textContaining("Amma doesn't use Gurtu"),
      200,
      scrollable: find
          .descendant(
            of: find.byType(GurtuPage).last,
            matching: find.byType(Scrollable),
          )
          .first,
    );

    await tapText(tester, 'Turn on reminders');
    expect(find.text('4 reminders are on'), findsOneWidget);
    expect(
      server.requests.where((r) => r.contains('medicine-reminders')).length,
      4,
    );
    final amlo =
        server.bodies['PUT /v1/circles/circle-1/medicine-reminders/'
            '${visit.id}%3Avm2%3Amorning']!;
    expect(amlo['until'], isNotNull);

    // They are on the medicine list now, and the visit shows them.
    final list = repo.medicineList.map((m) => m.label).toList();
    expect(list, ['Amlodipine 5 mg', 'Metformin 500 mg']);
    expect(repo.medicineList.first.times, [DoseTime.morning, DoseTime.night]);
    expect(find.text('Change reminders'), findsOneWidget);
    expect(
      find.textContaining('Metformin 500 mg · Morning, Night'),
      findsOneWidget,
    );
  });

  /// Lets automatic reminders notice the change, read and send.
  Future<void> settleAuto(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  Iterable<String> reminderCalls(FakeServer server) =>
      server.requests.where((r) => r.contains('medicine-reminders'));

  testWidgets('Gurtu AI turns reminders on by itself and follows changes', (
    tester,
  ) async {
    final (repo, server) = await openLinked(tester, auto: true);
    final visit = addVisit(repo);
    await settleAuto(tester);

    // Metformin 1-0-1 and Amlodipine at night: three reminders.
    final id = visit.id;
    const path = 'PUT /v1/circles/circle-1/medicine-reminders/';
    expect(reminderCalls(server), [
      '$path$id%3Avm1%3Amorning',
      '$path$id%3Avm1%3Anight',
      '$path$id%3Avm2%3Anight',
    ]);
    expect(
      find.text('Reminders are on for Metformin 500 mg, Amlodipine 5 mg'),
      findsOneWidget,
    );
    expect(repo.medicineList.map((m) => m.label), [
      'Amlodipine 5 mg',
      'Metformin 500 mg',
    ]);

    // Nothing about the medicines changed: nothing is read again.
    server.requests.clear();
    repo.dismissSetupCard();
    await settleAuto(tester);
    expect(reminderCalls(server), isEmpty);

    // The family corrects one by hand: that is kept.
    await openPage(tester, ReminderReviewPage(visitId: id));
    final night = find.text('Night').first;
    await tester.ensureVisible(night);
    await tester.pumpAndSettle();
    await tester.tap(night);
    await tester.pump();
    await tapText(tester, 'Turn on reminders');
    await settleAuto(tester);
    // Saving sends what stays on again; nothing reads it back over.
    expect(
      reminderCalls(server),
      unorderedEquals([
        '$path$id%3Avm1%3Amorning',
        '$path$id%3Avm2%3Anight',
        'DELETE /v1/circles/circle-1/medicine-reminders/$id%3Avm1%3Anight',
      ]),
    );

    // A note changes: that medicine is read again.
    server.requests.clear();
    repo.updateVisitMedicine(
      visit,
      const VisitMedicine(id: 'vm2', note: 'Amlodipine 5 mg morning'),
    );
    await settleAuto(tester);
    expect(
      reminderCalls(server),
      unorderedEquals([
        '$path$id%3Avm1%3Amorning',
        '$path$id%3Avm2%3Amorning',
        'DELETE /v1/circles/circle-1/medicine-reminders/$id%3Avm2%3Anight',
      ]),
    );

    // A medicine removed, then the whole visit: their reminders go.
    server.requests.clear();
    repo.removeVisitMedicine(visit, visit.medicines.first);
    await settleAuto(tester);
    expect(
      reminderCalls(server),
      unorderedEquals([
        '$path$id%3Avm2%3Amorning',
        'DELETE /v1/circles/circle-1/medicine-reminders/$id%3Avm1%3Amorning',
      ]),
    );
    repo.deleteVisit(visit);
    await settleAuto(tester);
    expect(
      reminderCalls(server).last,
      'DELETE /v1/circles/circle-1/medicine-reminders/$id%3Avm2%3Amorning',
    );
  });

  testWidgets('with automatic reminders, saving a visit is all it takes', (
    tester,
  ) async {
    final (_, server) = await openLinked(tester, auto: true);
    await openPage(tester, const VisitRecorderPage());
    await seeText(tester, 'e.g. Metformin 500 mg after breakfast');
    await tester.enterText(
      find.widgetWithText(TextField, 'e.g. Metformin 500 mg after breakfast'),
      'Metformin 500 mg 1-0-1 after food',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save visit'));
    await tester.pumpAndSettle();
    expect(find.byType(ReminderReviewPage), findsNothing);
    expect(
      find.text('Visit saved. Gurtu is setting up the medicine reminders.'),
      findsOneWidget,
    );
    await settleAuto(tester);
    expect(reminderCalls(server).length, 2);
  });

  testWidgets('Profile turns automatic reminders off and sends a test', (
    tester,
  ) async {
    final (repo, server) = await openLinked(tester, auto: true);
    await tester.tap(find.text('Profile').first);
    await tester.pumpAndSettle();
    final profile = find
        .descendant(
          of: find.byKey(const ValueKey('profile')),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('Send a test reminder now'),
      300,
      scrollable: profile,
    );
    expect(find.text('Automatic medicine reminders'), findsOneWidget);

    // Off: a new visit's medicines wait for the family.
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect((tester.widget(find.byType(Switch)) as Switch).value, isFalse);
    addVisit(repo);
    await settleAuto(tester);
    expect(reminderCalls(server), isEmpty);

    // The test goes through the server straight away.
    await tester.tap(find.text('Send a test reminder now'));
    await tester.pumpAndSettle();
    expect(
      server.requests,
      contains('POST /v1/circles/circle-1/medicine-reminders/test'),
    );
    final sent =
        server.bodies['POST /v1/circles/circle-1/medicine-reminders/test']!;
    expect((sent['medicine'] as Map)['name'], 'Test medicine');
    expect(find.text('Sent to 1 phone'), findsOneWidget);

    // It arrives like any reminder, marked as a test; answering it doesn't
    // tick the real medicine.
    repo.saveFromReminders(repo.selectedPatient!.id, [
      (
        name: 'Metformin',
        strength: '500 mg',
        times: [DoseTime.morning],
        food: FoodTiming.afterFood,
      ),
    ]);
    (PushService.instance as FakePush).messages.add(
      PushMessage(
        title: 'Time for Metformin 500 mg',
        body: '',
        data: {
          ...reminderPush(doseId: 'test-1').data!,
          'test': '1',
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('TEST'), findsOneWidget);
    await tester.tap(find.text("I've taken it"));
    await tester.pumpAndSettle();
    expect(server.bodies['POST /v1/doses/test-1/ack'], {'status': 'taken'});
    expect(repo.doseTaken(repo.medicineList.single, DoseTime.morning), isNull);
  });

  testWidgets('a reminder opens full screen, is read out and answered', (
    tester,
  ) async {
    final (repo, server) = await openLinked(tester);
    repo.saveFromReminders(repo.selectedPatient!.id, [
      (
        name: 'Metformin',
        strength: '500 mg',
        times: [DoseTime.morning],
        food: FoodTiming.afterFood,
      ),
    ]);
    final push = PushService.instance as FakePush;
    push.messages.add(reminderPush());
    await tester.pumpAndSettle();

    expect(find.byType(DoseReminderPage), findsOneWidget);
    expect(find.text('MEDICINE REMINDER'), findsOneWidget);
    expect(find.text('Metformin 500 mg'), findsOneWidget);
    expect(find.text('Due at 8:00 AM'), findsOneWidget);
    expect(find.text('After food'), findsOneWidget);
    // Read aloud in the app's language, then the doctor's voice note.
    expect(voice.said, ['en: Time for Metformin 500 mg. After food']);
    expect(voice.played, ['https://iqoo.yadvin.tech/v1/files/abc']);

    // A follow-up for the same dose doesn't open a second screen.
    push.messages.add(reminderPush());
    await tester.pumpAndSettle();
    expect(find.byType(DoseReminderPage), findsOneWidget);

    await tester.tap(find.text("I've taken it"));
    await tester.pumpAndSettle();
    expect(find.byType(DoseReminderPage), findsNothing);
    expect(find.text('Marked as taken. Well done!'), findsOneWidget);
    expect(server.bodies['POST /v1/doses/d1/ack'], {'status': 'taken'});
    final metformin = repo.medicineList.single;
    expect(repo.doseTaken(metformin, DoseTime.morning), isNotNull);
  });

  testWidgets('skipping asks first, then the family is told', (tester) async {
    final (_, server) = await openLinked(tester);
    final push = PushService.instance as FakePush;
    push.messages.add(reminderPush(doseId: 'd3'));
    await tester.pumpAndSettle();

    // Changed their mind: the reminder stays, nothing is sent.
    await tester.tap(find.text('Skip this time'));
    await tester.pumpAndSettle();
    expect(find.text('Skip this dose?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(DoseReminderPage), findsOneWidget);
    expect(server.requests, isNot(contains('POST /v1/doses/d3/ack')));

    await tester.tap(find.text('Skip this time'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip this time').last);
    await tester.pumpAndSettle();
    expect(find.byType(DoseReminderPage), findsNothing);
    expect(server.bodies['POST /v1/doses/d3/ack'], {'status': 'skipped'});

    // On a family phone: the notice shows, and the doses are fetched.
    server.requests.clear();
    push.messages.add(
      const PushMessage(
        title: 'Amma skipped Metformin 500 mg',
        body: 'It was due at 8:00 am. You may want to check on Amma.',
        data: {'type': 'dose_skipped', 'doseId': 'd3', 'circleId': 'circle-1'},
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Amma skipped Metformin 500 mg'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(server.requests, contains('GET /v1/circles/circle-1/doses'));
    await tester.pump(const Duration(seconds: 6));
  });

  testWidgets('the family sees a missed dose in red and can mark it', (
    tester,
  ) async {
    final (_, server) = await openLinked(tester);
    final push = PushService.instance as FakePush;
    push.taps.add(
      reminderPush(
        doseId: 'd2',
        type: 'missed_dose',
        title: 'Amma hasn’t taken Metformin 500 mg',
        body: 'It was due at 8:00 am.',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MissedDosePage), findsOneWidget);
    expect(find.text('MISSED DOSE'), findsOneWidget);
    expect(find.text('Amma hasn’t taken Metformin 500 mg'), findsOneWidget);
    // Nothing is read out to the family.
    expect(voice.said, isEmpty);

    await tester.tap(find.text("I'll check on them"));
    await tester.pumpAndSettle();
    expect(find.byType(MissedDosePage), findsNothing);
    expect(server.requests, isNot(contains('POST /v1/doses/d2/ack')));

    push.taps.add(reminderPush(doseId: 'd2', type: 'missed_dose'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark as taken'));
    await tester.pumpAndSettle();
    expect(server.bodies['POST /v1/doses/d2/ack'], {'status': 'taken'});
  });

  // Small 360dp phone, every language: overflow anywhere fails the test.
  for (final lang in AppLanguage.values) {
    testWidgets('reminder screens fit in ${lang.englishName}', (tester) async {
      final (repo, _) = await openLinked(
        tester,
        language: lang.code,
        size: const Size(990, 2145),
      );
      final visit = addVisit(repo);
      await openPage(tester, ReminderReviewPage(visitId: visit.id));
      final list = find
          .descendant(
            of: find.byType(GurtuPage).last,
            matching: find.byType(Scrollable),
          )
          .first;
      for (var i = 0; i < 10; i++) {
        await tester.drag(list, const Offset(0, -300));
        await tester.pump();
      }
      Navigator.of(tester.element(list)).pop();
      await tester.pumpAndSettle();

      final push = PushService.instance as FakePush;
      push.messages.add(reminderPush());
      await tester.pumpAndSettle();
      expect(find.byType(DoseReminderPage), findsOneWidget);
      Navigator.of(tester.element(find.byType(DoseReminderPage))).pop();
      await tester.pumpAndSettle();
      push.messages.add(reminderPush(doseId: 'd9', type: 'missed_dose'));
      await tester.pumpAndSettle();
      expect(find.byType(MissedDosePage), findsOneWidget);
      Navigator.of(tester.element(find.byType(MissedDosePage))).pop();
      await tester.pumpAndSettle();

      // Profile, with the automatic reminders switch and the test button.
      final l = lookupAppLocalizations(Locale(lang.code));
      await tester.tap(find.text(l.navProfile).first);
      await tester.pumpAndSettle();
      final profile = find
          .descendant(
            of: find.byKey(const ValueKey('profile')),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text(l.testReminderHint),
        300,
        scrollable: profile,
      );
      expect(find.text(l.autoReminders), findsOneWidget);
    });
  }
}
