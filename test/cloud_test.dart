import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/circle/circle_page.dart';
import 'package:gurtutest/cloud/cloud_models.dart';
import 'package:gurtutest/cloud/cloud_sync.dart';
import 'package:gurtutest/cloud/gurtu_api.dart';
import 'package:gurtutest/cloud/push_service.dart';
import 'package:gurtutest/data/care_models.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/main.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:gurtutest/widgets/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Push without Firebase: a fixed token, and messages the test sends.
class FakePush implements PushService {
  final messages = StreamController<PushMessage>.broadcast();

  @override
  Future<bool> init() async => true;
  @override
  Future<String?> token() async => 'fcm-token-1';
  @override
  Stream<String> get tokenRefresh => const Stream.empty();
  @override
  Stream<PushMessage> get foreground => messages.stream;
  final taps = StreamController<PushMessage>.broadcast();
  @override
  Stream<PushMessage> get opened => taps.stream;
  @override
  Future<String> timeZone() async => 'Asia/Kolkata';
  @override
  Future<bool?> notificationsAllowed() async => true;
}

/// Just enough of the backend (see backend/src) to test the app against.
class FakeServer {
  bool offline = false;
  final requests = <String>[];
  final bodies = <String, Map<String, dynamic>>{};
  Map<String, dynamic>? circle;
  int notified = 0;

  /// What `GET .../doses` answers (doses sent, and whether taken).
  List<Map<String, dynamic>> doses = [];

  static const code = '482915';

  Map<String, dynamic> _circle(Map<String, dynamic> patient, String me) => {
    'id': 'circle-1',
    'code': code,
    'patient': patient,
    'me': {'memberId': 'm1', 'role': 'caregiver', 'isOwner': true},
    'members': [
      {
        'id': 'm1',
        'name': me,
        'role': 'caregiver',
        'isOwner': true,
        'isYou': true,
        'usesApp': true,
        'notificationsOn': true,
      },
      {
        'id': 'm2',
        'name': patient['name'],
        'role': 'patient',
        'usesApp': false,
      },
    ],
  };

  late final client = MockClient((req) async {
    if (offline) throw const SocketException('No route to host');
    final key = '${req.method} ${req.url.path}';
    requests.add(key);
    final body = req.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(req.body) as Map<String, dynamic>;
    bodies[key] = body;
    http.Response json(int status, Object j) => http.Response(
      jsonEncode(j),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
    if (key != 'POST /v1/devices' &&
        req.headers['authorization'] != 'Bearer dev-1.secret') {
      return json(401, {'error': 'unauthorized'});
    }
    if (key == 'POST /v1/circles/circle-1/medicine-reminders/test') {
      return json(200, {'doseId': 'test-1', 'sent': 1});
    }
    if (key.startsWith('PUT /v1/circles/circle-1/medicine-reminders/') ||
        key.startsWith('DELETE /v1/circles/circle-1/medicine-reminders/')) {
      return json(200, {'ok': true});
    }
    if (key.startsWith('POST /v1/doses/')) {
      return json(200, {'status': body['status']});
    }
    return switch (key) {
      'POST /v1/devices' => json(201, {
        'deviceId': 'dev-1',
        'token': 'dev-1.secret',
      }),
      'PUT /v1/devices/me' => json(200, {'ok': true}),
      'POST /v1/circles' => json(
        201,
        circle = _circle(
          body['patient'] as Map<String, dynamic>,
          (body['me'] as Map)['name'] as String,
        ),
      ),
      'POST /v1/circles/join' when body['role'] == 'patient' =>
        body['code'] == code
            ? json(200, {
                ..._circle({
                  'name': 'Amma',
                  'age': 64,
                  'conditions': ['diabetes'],
                }, 'Sai'),
                'members': [
                  {
                    'id': 'm1',
                    'name': 'Sai',
                    'role': 'caregiver',
                    'usesApp': true,
                    'notificationsOn': true,
                  },
                  {
                    'id': 'm4',
                    'name': 'Anu',
                    'role': 'family',
                    'usesApp': true,
                  },
                  {
                    'id': 'm2',
                    'name': 'Amma',
                    'role': 'patient',
                    'isYou': true,
                    'usesApp': true,
                  },
                ],
              })
            : json(404, {'error': 'invalid_code'}),
      'POST /v1/circles/join' =>
        body['code'] == code
            ? json(
                200,
                _circle({
                    'name': 'Amma',
                    'age': 64,
                    'conditions': ['diabetes'],
                    'allergies': <String>[],
                  }, 'Sai')
                  ..['members'] = [
                    {'id': 'm1', 'name': 'Sai', 'role': 'caregiver'},
                    {
                      'id': 'm3',
                      'name': body['name'],
                      'role': body['role'],
                      'isYou': true,
                      'usesApp': true,
                      'notificationsOn': true,
                    },
                  ],
              )
            : json(404, {'error': 'invalid_code'}),
      'GET /v1/circles/circle-1' => json(200, circle!),
      'GET /v1/circles/circle-1/doses' => json(200, {'doses': doses}),
      'POST /v1/circles/circle-1/notify' => json(200, {'sent': ++notified}),
      'POST /v1/circles/circle-1/help' => json(200, {'sent': 2, 'reached': 2}),
      _ => json(404, {'error': 'not_found'}),
    };
  });
}

void main() {
  setUp(() {
    PushService.instance = FakePush();
    // permission_handler: 1 == PermissionStatus.granted.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/permissions/methods'),
          (call) async => switch (call.method) {
            'checkPermissionStatus' => 1,
            'requestPermissions' => {17: 1},
            _ => null,
          },
        );
  });
  tearDown(() => PushService.instance = FirebasePushService());

  Future<SharedPreferences> prefsWith([
    Map<String, Object> saved = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(saved);
    return SharedPreferences.getInstance();
  }

  PatientProfile amma() => PatientProfile(
    id: 'p1',
    name: 'Amma',
    age: 64,
    conditions: const ['diabetes'],
    careFor: 'parent',
    createdAt: DateTime(2026, 9, 27),
  );

  test('onboarding is saved with this phone and its push token', () async {
    final server = FakeServer();
    final prefs = await prefsWith();
    final sync = CloudSync(prefs, api: GurtuApi(client: server.client));
    await sync.start(language: 'te');

    expect(server.requests, ['POST /v1/devices']);
    expect(server.bodies['POST /v1/devices'], {
      'fcmToken': 'fcm-token-1',
      'platform': 'android',
      'language': 'te',
      'timezone': 'Asia/Kolkata',
      'notificationsAllowed': true,
    });

    await sync.createCircle(
      'p1',
      CloudSync.circlePayload(amma(), myName: 'Sai'),
    );
    final sent = server.bodies['POST /v1/circles']!;
    expect(sent['patientIsMe'], false);
    expect(sent['me'], {'name': 'Sai', 'role': 'caregiver'});
    expect((sent['patient'] as Map)['conditions'], ['diabetes']);
    expect(sync.circleFor('p1')!.code, FakeServer.code);
    expect(sync.isPending('p1'), isFalse);

    // Survives a restart, device and all: no second registration.
    final again = CloudSync(prefs, api: GurtuApi(client: server.client));
    expect(again.circleFor('p1')!.code, FakeServer.code);
    server.requests.clear();
    await again.start(language: 'te');
    // Token and language are refreshed each launch; then the circle.
    expect(server.requests.take(2), [
      'PUT /v1/devices/me',
      'GET /v1/circles/circle-1',
    ]);
    // Then what the family marked as taken on other phones.
    expect(server.requests, contains('GET /v1/circles/circle-1/doses'));
  });

  test('offline onboarding is kept and saved once online', () async {
    final server = FakeServer()..offline = true;
    final prefs = await prefsWith();
    final sync = CloudSync(prefs, api: GurtuApi(client: server.client));
    await sync.start(language: 'en');
    expect(sync.error, ApiError.offline);

    await sync.createCircle(
      'p1',
      CloudSync.circlePayload(amma(), myName: 'Sai'),
    );
    expect(sync.isPending('p1'), isTrue);
    expect(sync.circleFor('p1'), isNull);

    // Next launch, back online.
    server.offline = false;
    final later = CloudSync(prefs, api: GurtuApi(client: server.client));
    expect(later.isPending('p1'), isTrue);
    await later.start(language: 'en');
    expect(later.isPending('p1'), isFalse);
    expect(later.circleFor('p1')!.code, FakeServer.code);
    expect(later.error, isNull);
  });

  test('joining says why a code was refused', () async {
    final server = FakeServer();
    final sync = CloudSync(
      await prefsWith(),
      api: GurtuApi(client: server.client),
    );
    await expectLater(
      sync.join(code: '111111', name: 'Anu', role: 'family'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.error,
          'error',
          ApiError.invalidCode,
        ),
      ),
    );
    final circle = await sync.join(
      code: FakeServer.code,
      name: 'Anu',
      role: 'family',
    );
    expect(circle.patientName, 'Amma');
  });

  test('joined circle becomes this phone’s patient and members', () async {
    final prefs = await prefsWith();
    final repo = CareRepository(prefs);
    final circle = CircleInfo.fromJson({
      'id': 'c9',
      'code': '123456',
      'patient': {
        'name': 'Nanna',
        'age': 70,
        'conditions': ['highBp'],
      },
      'members': [
        {'id': 'a', 'name': 'Ravi', 'role': 'caregiver', 'isOwner': true},
        {'id': 'b', 'name': 'Nanna', 'role': 'patient'},
        {'id': 'c', 'name': 'Anu', 'role': 'family', 'isYou': true},
      ],
    });
    final id = repo.createFromCircle(circle, myName: 'Anu');
    expect(repo.selectedPatient!.id, id);
    expect(repo.selectedPatient!.name, 'Nanna');
    expect(repo.selectedPatient!.conditions, ['highBp']);
    expect(repo.userName, 'Anu');
    expect(repo.you!.name, 'Anu');
    expect(repo.circle.map((m) => m.name), ['Nanna', 'Anu', 'Ravi']);

    // Joining the same circle again doesn't make a second patient.
    repo.createFromCircle(circle, myName: 'Anu');
    expect(repo.patients, hasLength(1));
  });

  Future<(SharedPreferences, FakeServer)> openApp(
    WidgetTester tester, {
    bool onboarded = true,
    bool online = false,
    Future<void>? boot,
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final prefs = await prefsWith({
      'onboarding_complete': onboarded,
      'app_language': 'en',
    });
    if (onboarded) {
      CareRepository(prefs).createFromOnboarding(
        OnboardingState()
          ..careFor = CareFor.parent
          ..patientName = 'Amma'
          ..yourName = 'Sai'
          ..age = 64,
      );
    }
    final server = FakeServer();
    await tester.pumpWidget(
      GurtuApp(
        key: UniqueKey(),
        prefs: prefs,
        ai: GurtuAi(prefs)..init(),
        cloud: CloudSync(prefs, api: GurtuApi(client: server.client)),
        boot: boot,
        online: online,
      ),
    );
    await tester.pump();
    return (prefs, server);
  }

  testWidgets('the splash shows while Gurtu starts, then goes', (tester) async {
    final boot = Completer<void>();
    await openApp(tester, boot: boot.future);
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Remember. Care. Together.'), findsOneWidget);

    // Still waiting for start-up after the minimum time.
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(SplashScreen), findsOneWidget);

    boot.complete();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.text('Welcome to Gurtu, Sai'), findsOneWidget);
  });

  testWidgets('Circle shows the family code, members and a test push', (
    tester,
  ) async {
    await openApp(tester);
    await tester.tap(find.text('Circle'));
    await tester.pumpAndSettle();

    // Set up before the server existed: made on "Try again".
    expect(find.text("Couldn't reach the Gurtu server"), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('482 915'), findsOneWidget);
    expect(find.text('Gets reminders'), findsOneWidget);
    expect(find.text('Not on the app'), findsOneWidget);
    expect(find.text('You'), findsOneWidget);
    expect(find.text('Make a new code'), findsOneWidget);

    String? copied;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        });
    await tester.tap(find.text('Copy code'));
    await tester.pumpAndSettle();
    expect(copied, FakeServer.code);
    expect(find.text('Code copied'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Send a test notification'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(CirclePage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send a test notification'));
    await tester.pumpAndSettle();
    expect(find.text('Sent to 1 phone'), findsOneWidget);
  });

  testWidgets('a family member joins with the code during onboarding', (
    tester,
  ) async {
    final (prefs, server) = await openApp(tester, onboarded: false);
    Future<void> settle() async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    await tester.tap(find.text('Continue'));
    await settle();
    await tester.tap(find.text('I have a family code'));
    await settle();
    expect(find.text('Join a care circle'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '111111');
    await tester.enterText(find.byType(TextField).last, 'Anu');
    await settle();
    await tester.tap(find.text('Join the circle'));
    await settle();
    expect(
      find.text(
        "That code doesn't match any family. Check the digits and try again.",
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).first, FakeServer.code);
    await tester.tap(find.text('Trusted helper'));
    await settle();
    await tester.tap(find.text('Join the circle'));
    await settle();
    await settle();
    await tester.pump(const Duration(seconds: 1));

    expect(server.bodies['POST /v1/circles/join'], {
      'code': FakeServer.code,
      'name': 'Anu',
      'role': 'helper',
    });
    // Straight into Home, caring for the family's patient.
    expect(find.text('Amma'), findsWidgets);
    expect(prefs.getBool('onboarding_complete'), isTrue);
    expect(find.text("You joined Amma's care circle"), findsOneWidget);
    // It goes by itself.
    await tester.pump(const Duration(seconds: 6));
    expect(find.text("You joined Amma's care circle"), findsNothing);
  });

  testWidgets('a push that arrives while Gurtu is open is shown', (
    tester,
  ) async {
    final (_, server) = await openApp(tester, online: true);
    await tester.pumpAndSettle();
    // Online at start: this phone registered with its push token.
    expect(server.requests.first, 'POST /v1/devices');

    (PushService.instance as FakePush).messages.add(
      const PushMessage(title: 'Metformin', body: 'After breakfast'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Metformin'), findsOneWidget);
    expect(find.text('After breakfast'), findsOneWidget);
    // Once it has slid in, tapping it closes it.
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Metformin'));
    await tester.pump();
    expect(find.text('Metformin'), findsNothing);
  });

  testWidgets('the person cared for joins with the code and sees their care', (
    tester,
  ) async {
    final (prefs, server) = await openApp(tester, onboarded: false);
    Future<void> settle() async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    await tester.tap(find.text('Continue'));
    await settle();
    await tester.tap(find.text('I have a family code'));
    await settle();
    await tester.enterText(find.byType(TextField).first, FakeServer.code);
    await tester.tap(find.text("I'm the one being cared for"));
    await settle();
    // Their name is already in the circle: nothing to type.
    expect(find.text('Your name'), findsNothing);
    await tester.tap(find.text('Join the circle'));
    await settle();
    await settle();
    await tester.pump(const Duration(seconds: 1));

    expect(server.bodies['POST /v1/circles/join'], {
      'code': FakeServer.code,
      'role': 'patient',
    });
    final repo = CareScope.of(tester.element(find.byType(Scaffold).first));
    expect(repo.selectedPatient!.isSelf, isTrue);
    expect(repo.userName, 'Amma');

    // Their own Home: "Your care", who looks after them, no people strip.
    expect(find.text('Your care'), findsOneWidget);
    expect(find.text('Caring for'), findsNothing);
    expect(find.text('People you care for'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Looking after you'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('2 people look after you'), findsOneWidget);
    expect(find.text('Sai'), findsOneWidget);

    // One tap (and a confirm) tells the family.
    await tester.ensureVisible(find.text('Ask family for help'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ask family for help'));
    await tester.pumpAndSettle();
    expect(find.text('Send a message to your family?'), findsOneWidget);
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(server.requests, contains('POST /v1/circles/circle-1/help'));
    expect(find.text('Sent to 2 people'), findsOneWidget);
    expect(prefs.getBool('onboarding_complete'), isTrue);
  });

  testWidgets('a caregiver adds a second person and switches between them', (
    tester,
  ) async {
    final (_, server) = await openApp(tester);
    Future<void> settle() async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    Future<void> tap(String text) async {
      await tester.tap(find.text(text).last);
      await settle();
    }

    expect(find.text('People you care for'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Add someone to care for'));
    await settle();
    expect(find.text('Set up for someone new'), findsOneWidget);
    expect(find.text('Join with a family code'), findsOneWidget);
    await tap('Set up for someone new');

    // Only the questions about them. Not yet on the phone yourself, so
    // "Myself" is still offered.
    expect(find.text('Myself'), findsOneWidget);
    await tap('My parent');
    await tap('Continue');
    await tester.enterText(find.byType(TextField).at(0), 'Nanna');
    await tester.enterText(find.byType(TextField).at(1), '70');
    await settle();
    // Your own name is kept from before.
    expect(find.text('Sai'), findsOneWidget);
    await tap('Continue');
    await tap('High BP');
    await tap('Continue');
    await tap('No');
    await tap('Continue');
    await tap('No known allergies');
    await tap('Continue');
    await tap('Needs some help');
    await tap('Continue');
    await tap('No');
    await tap('Continue');
    await tap('Enter Gurtu');
    await tester.pumpAndSettle();

    // Back on Home, now on Nanna, with both people in the strip.
    final repo = CareScope.of(tester.element(find.byType(Scaffold).first));
    expect(repo.patients.map((p) => p.name), ['Amma', 'Nanna']);
    expect(repo.selectedPatient!.name, 'Nanna');
    expect(repo.userName, 'Sai');
    expect(find.bySemanticsLabel(RegExp('^Amma, ')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('^Nanna, ')), findsOneWidget);
    // Nanna gets her own circle and code.
    expect(server.requests, contains('POST /v1/circles'));

    await tester.tap(find.bySemanticsLabel(RegExp('^Amma, ')));
    await tester.pumpAndSettle();
    expect(repo.selectedPatient!.name, 'Amma');
  });

  test('one phone can be you and someone you care for', () async {
    final prefs = await prefsWith();
    final repo = CareRepository(prefs)
      ..createFromOnboarding(
        OnboardingState()
          ..careFor = CareFor.myself
          ..patientName = 'Sai'
          ..age = 40,
      );
    expect(repo.hasSelf, isTrue);
    repo.createFromCircle(
      CircleInfo.fromJson({
        'id': 'c2',
        'code': '222222',
        'patient': {'name': 'Amma'},
        'members': [
          {'id': 'x', 'name': 'Amma', 'role': 'patient'},
          {'id': 'y', 'name': 'Sai', 'role': 'caregiver', 'isYou': true},
        ],
      }),
      myName: 'Sai',
    );
    expect(repo.patients.map((p) => (p.name, p.isSelf)), [
      ('Sai', true),
      ('Amma', false),
    ]);
    expect(repo.userName, 'Sai');
    expect(repo.selectedPatient!.name, 'Amma');
  });

  test('a push token that arrives late still reaches the server', () async {
    final push = _SlowPush();
    PushService.instance = push;
    final server = FakeServer();
    final prefs = await prefsWith();
    final sync = CloudSync(prefs, api: GurtuApi(client: server.client));
    // No token yet at start: registered without one...
    await sync.start(language: 'en');
    expect(server.bodies['POST /v1/devices']!.containsKey('fcmToken'), isFalse);
    // ...then the token arrives and is sent, never an empty one.
    push.refresh.add('late-token');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(server.requests.last, 'PUT /v1/devices/me');
    expect(server.bodies['PUT /v1/devices/me']!['fcmToken'], 'late-token');
    sync.dispose();
  });
}

/// Firebase that hasn't handed out a token yet.
class _SlowPush extends FakePush {
  final refresh = StreamController<String>.broadcast();

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefresh => refresh.stream;
}
