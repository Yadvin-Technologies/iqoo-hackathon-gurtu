import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Something shared to Gurtu from another app (Gurtu shows in the phone's
/// Share menu): photos, PDFs, or text.
class SharedContent {
  const SharedContent({this.paths = const [], this.text = ''});

  final List<String> paths;
  final String text;

  bool get isEmpty => paths.isEmpty && text.trim().isEmpty;

  static SharedContent? fromMap(Object? raw) {
    if (raw is! Map) return null;
    final shared = SharedContent(
      paths: [for (final p in raw['paths'] as List? ?? const []) '$p'],
      text: '${raw['text'] ?? ''}'.trim(),
    );
    return shared.isEmpty ? null : shared;
  }
}

/// Android's Share menu, behind an interface so tests can share.
abstract class ShareInbox {
  static ShareInbox instance = DeviceShareInbox();

  /// What was shared to start the app, if anything.
  Future<SharedContent?> initial();

  /// Shares that arrive while it runs.
  Stream<SharedContent> get incoming;

  /// Marks what was received as handled.
  Future<void> done();
}

/// Shares received by MainActivity (it copies each file into the app) over
/// the `gurtu/share` channel.
class DeviceShareInbox implements ShareInbox {
  static const _channel = MethodChannel('gurtu/share');

  final _incoming = StreamController<SharedContent>.broadcast();
  bool _listening = false;

  bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  void _listen() {
    if (_listening || !_supported) return;
    _listening = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'shared') return;
      if (SharedContent.fromMap(call.arguments) case final shared?) {
        _incoming.add(shared);
      }
    });
  }

  @override
  Future<SharedContent?> initial() async {
    if (!_supported) return null;
    _listen();
    try {
      return SharedContent.fromMap(await _channel.invokeMethod('initial'));
    } on Object catch (e) {
      debugPrint('Reading the share failed: $e');
      return null;
    }
  }

  @override
  Stream<SharedContent> get incoming {
    _listen();
    return _incoming.stream;
  }

  @override
  Future<void> done() async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('done');
    } on Object {
      // Nothing to clear.
    }
  }
}
