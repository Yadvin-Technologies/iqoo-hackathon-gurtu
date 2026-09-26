import 'dart:io';

import 'package:flutter/services.dart';

/// Device facts and thermal state from `MainActivity` (`gurtu/device`).
abstract final class DeviceProbe {
  static const _channel = MethodChannel('gurtu/device');

  static Future<Map<String, Object?>> info() async =>
      Map<String, Object?>.from(await _channel.invokeMethod('info') ?? {});

  /// `status` 0..6 (none, light, moderate, severe, critical, emergency,
  /// shutdown), `headroom` (≥1.0 means throttling), `batteryTempC`.
  static Future<Map<String, Object?>> thermal() async =>
      Map<String, Object?>.from(await _channel.invokeMethod('thermal') ?? {});

  static const thermalNames = [
    'none',
    'light',
    'moderate',
    'severe',
    'critical',
    'emergency',
    'shutdown',
  ];

  /// Resident set size of this process (includes the embedding isolates and
  /// LiteRT's native heap), in bytes; null off Linux/Android.
  static int? rssBytes() {
    try {
      final status = File('/proc/self/status').readAsLinesSync();
      final line = status.firstWhere((l) => l.startsWith('VmRSS:'));
      final kb = int.parse(RegExp(r'\d+').firstMatch(line)!.group(0)!);
      return kb * 1024;
    } catch (_) {
      return null;
    }
  }
}
