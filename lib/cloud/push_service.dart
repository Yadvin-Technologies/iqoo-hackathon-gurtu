import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../firebase_options.dart';

/// A notification that arrived while Gurtu was open (Android only shows
/// them itself when the app is in the background).
class PushMessage {
  const PushMessage({required this.title, required this.body, this.data});

  final String title;
  final String body;
  final Map<String, dynamic>? data;
}

/// Firebase Cloud Messaging behind an interface, so tests (and platforms
/// without Google services) run without it.
abstract class PushService {
  /// Replaced in tests.
  static PushService instance = FirebasePushService();

  /// Starts Firebase. False when it isn't available here.
  Future<bool> init();

  /// This install's FCM token, or null when there is none (yet).
  Future<String?> token();

  Stream<String> get tokenRefresh;
  Stream<PushMessage> get foreground;

  /// Notifications the person tapped (app in the background), including
  /// the one that started the app.
  Stream<PushMessage> get opened;

  /// The IANA time zone of the phone, like `Asia/Kolkata`.
  Future<String> timeZone();

  /// Android lets Gurtu show notifications. Null when it can't tell.
  Future<bool?> notificationsAllowed();
}

class FirebasePushService implements PushService {
  bool _ready = false;
  static const _device = MethodChannel('gurtu/device');

  @override
  Future<bool> init() async {
    if (_ready) return true;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      _ready = true;
    } on Object catch (e) {
      debugPrint('Firebase unavailable: $e');
    }
    return _ready;
  }

  @override
  Future<String?> token() async {
    if (!_ready) return null;
    try {
      return await FirebaseMessaging.instance.getToken().timeout(
        const Duration(seconds: 20),
      );
    } on Object catch (e) {
      // No Google Play services, or offline on first launch.
      debugPrint('FCM token unavailable: $e');
      return null;
    }
  }

  @override
  Stream<String> get tokenRefresh =>
      _ready ? FirebaseMessaging.instance.onTokenRefresh : const Stream.empty();

  @override
  Stream<PushMessage> get opened {
    if (!_ready) return const Stream.empty();
    final controller = StreamController<PushMessage>();
    // The tap that launched the app, then taps while it runs.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((m) {
          if (m != null) controller.add(_toMessage(m));
        })
        .catchError((Object _) {});
    controller.addStream(FirebaseMessaging.onMessageOpenedApp.map(_toMessage));
    return controller.stream;
  }

  static PushMessage _toMessage(RemoteMessage m) => PushMessage(
    title: m.notification?.title ?? '',
    body: m.notification?.body ?? '',
    data: m.data,
  );

  @override
  Stream<PushMessage> get foreground => _ready
      ? FirebaseMessaging.onMessage.map(
          (m) => PushMessage(
            title: m.notification?.title ?? '',
            body: m.notification?.body ?? '',
            data: m.data,
          ),
        )
      : const Stream.empty();

  @override
  Future<bool?> notificationsAllowed() async {
    try {
      return (await Permission.notification.status).isGranted;
    } on Object {
      return null;
    }
  }

  @override
  Future<String> timeZone() async {
    try {
      return await _device.invokeMethod<String>('timeZone') ?? 'Asia/Kolkata';
    } on Object {
      return 'Asia/Kolkata';
    }
  }
}
