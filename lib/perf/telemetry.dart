import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../memory/embedding/embedding_activity.dart';

/// One reading of the device, taken once per [TelemetryService.interval].
///
/// Every field is nullable: what an app may read differs per phone and
/// Android version, and an unreadable source is shown as unavailable rather
/// than as zero.
class TelemetrySample {
  const TelemetrySample({
    required this.at,
    this.appCpuPct,
    this.appCpuCores,
    this.coreFreqPct = const [],
    this.coreFreqMhz = const [],
    this.gpuBusyPct,
    this.cpuTempC,
    this.gpuTempC,
    this.npuTempC,
    this.ddrTempC,
    this.batteryTempC,
    this.powerW,
    this.plugged,
    this.thermalStatus,
    this.thermalHeadroom,
    this.rssBytes,
    this.embedsPerSec = 0,
    this.embedLatencyMs,
  });

  final DateTime at;

  /// This app's CPU time as % of all cores (100 % = every core saturated).
  final double? appCpuPct;

  /// The same as a count of fully busy cores (e.g. 1.6 cores).
  final double? appCpuCores;

  /// Per-core current clock as % of that core's max, and in MHz.
  final List<double> coreFreqPct;
  final List<int> coreFreqMhz;

  /// Adreno busy time over the driver's last ~1 s window.
  final double? gpuBusyPct;

  final double? cpuTempC, gpuTempC, npuTempC, ddrTempC, batteryTempC;

  /// Whole-phone battery power draw; null while plugged in.
  final double? powerW;
  final bool? plugged;

  final int? thermalStatus;
  final double? thermalHeadroom;
  final int? rssBytes;

  /// Embeddings completed per second by the memory layer, and their mean
  /// latency over the interval.
  final double embedsPerSec;
  final double? embedLatencyMs;
}

/// Samples CPU, GPU, NPU and power signals about once a second and keeps a
/// rolling history for charts.
///
/// Sources (all readable by a normal app on the iQOO 15 / SM8850):
///  * CPU: this process's utime+stime (`/proc/self/stat`) and each core's
///    clock (`/sys/devices/system/cpu/cpuN/cpufreq`). System-wide CPU load
///    (`/proc/stat`) is blocked for apps since Android 8.
///  * GPU: Adreno `kgsl-3d0/gpubusy` (busy / total µs of the last window).
///  * NPU: Qualcomm exposes no NPU utilization to apps. The Hexagon NPU's
///    HVX (vector) and HMX (matrix) thermal sensors are readable and are the
///    only NPU signal available: they rise only when the NPU works.
///  * Power: BatteryManager current × voltage (through `MainActivity`).
class TelemetryService extends ChangeNotifier {
  TelemetryService({this.interval = const Duration(seconds: 1), this.historyLength = 60});

  final Duration interval;
  final int historyLength;

  final List<TelemetrySample> history = [];
  TelemetrySample? get latest => history.isEmpty ? null : history.last;

  static const _channel = MethodChannel('gurtu/device');
  static const _clkTck = 100; // USER_HZ on Android

  Timer? _timer;
  final int cores = Platform.numberOfProcessors;
  late final List<int?> _coreMaxKhz = List.generate(cores, (i) => _readInt(_cpuFreq(i, 'cpuinfo_max_freq')));
  late final _zones = _discoverZones();

  int? _lastTicks;
  DateTime? _lastAt;
  ({int count, int micros})? _lastActivity;
  bool _sampling = false;

  bool get running => _timer != null;

  void start() {
    if (_timer != null || !Platform.isAndroid) return;
    _sample();
    _timer = Timer.periodic(interval, (_) => _sample());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  /// Max/min cluster info for labelling core bars, e.g. prime vs performance.
  List<int?> get coreMaxMhz => _coreMaxKhz.map((k) => k == null ? null : k ~/ 1000).toList();

  // ---- Sampling ---------------------------------------------------------------

  Future<void> _sample() async {
    if (_sampling) return; // a slow channel call must not pile up
    _sampling = true;
    try {
      final now = DateTime.now();

      // App CPU
      double? cpuPct, cpuCores;
      final ticks = _selfCpuTicks();
      if (ticks != null && _lastTicks != null && _lastAt != null) {
        final secs = now.difference(_lastAt!).inMicroseconds / 1e6;
        if (secs > 0) {
          cpuCores = (ticks - _lastTicks!) / _clkTck / secs;
          cpuPct = (cpuCores / cores * 100).clamp(0, 100).toDouble();
        }
      }
      _lastTicks = ticks;

      // Model activity
      final act = EmbeddingActivity.snapshot();
      var eps = 0.0;
      double? lat;
      final prev = _lastActivity;
      if (prev != null && _lastAt != null) {
        final secs = now.difference(_lastAt!).inMicroseconds / 1e6;
        final n = act.count - prev.count;
        if (secs > 0) eps = n / secs;
        if (n > 0) lat = (act.micros - prev.micros) / n / 1000;
      }
      _lastActivity = act;
      _lastAt = now;

      // Per-core clocks
      final mhz = <int>[];
      final pct = <double>[];
      for (var i = 0; i < cores; i++) {
        final cur = _readInt(_cpuFreq(i, 'scaling_cur_freq'));
        final max = _coreMaxKhz[i];
        mhz.add(cur == null ? 0 : cur ~/ 1000);
        pct.add(cur == null || max == null || max == 0 ? 0 : cur / max * 100);
      }

      // GPU busy: "busy total" in µs for the driver's last window.
      double? gpu;
      final busy = _read('/sys/class/kgsl/kgsl-3d0/gpubusy');
      if (busy != null) {
        final parts = busy.trim().split(RegExp(r'\s+'));
        if (parts.length >= 2) {
          final b = int.tryParse(parts[0]), t = int.tryParse(parts[1]);
          if (b != null && t != null && t > 0) gpu = (b / t * 100).clamp(0, 100).toDouble();
        }
      }

      Map<String, Object?> power = const {};
      try {
        power = Map<String, Object?>.from(await _channel.invokeMethod('power') ?? {});
      } catch (_) {}
      final plugged = power['plugged'] as bool?;
      final ua = (power['currentUa'] as num?)?.toDouble();
      final mv = (power['voltageMv'] as num?)?.toDouble();
      final watts = plugged == false && ua != null && mv != null ? ua.abs() * mv / 1e9 : null;

      history.add(TelemetrySample(
        at: now,
        appCpuPct: cpuPct,
        appCpuCores: cpuCores,
        coreFreqMhz: mhz,
        coreFreqPct: pct,
        gpuBusyPct: gpu,
        cpuTempC: _maxTemp(_zones.cpu),
        gpuTempC: _maxTemp(_zones.gpu),
        npuTempC: _maxTemp(_zones.npu),
        ddrTempC: _maxTemp(_zones.ddr),
        batteryTempC: (power['batteryTempC'] as num?)?.toDouble() ?? _maxTemp(_zones.battery),
        powerW: watts,
        plugged: plugged,
        thermalStatus: power['status'] as int?,
        thermalHeadroom: (power['headroom'] as num?)?.toDouble(),
        rssBytes: _rss(),
        embedsPerSec: eps,
        embedLatencyMs: lat,
      ));
      if (history.length > historyLength) history.removeAt(0);
      notifyListeners();
    } finally {
      _sampling = false;
    }
  }

  // ---- Sources ----------------------------------------------------------------

  static String _cpuFreq(int i, String f) => '/sys/devices/system/cpu/cpu$i/cpufreq/$f';

  static String? _read(String path) {
    try {
      return File(path).readAsStringSync();
    } catch (_) {
      return null;
    }
  }

  static int? _readInt(String path) => int.tryParse(_read(path)?.trim() ?? '');

  /// utime + stime of this process, in clock ticks. Parsed after the last
  /// ')' because the command name may contain spaces.
  static int? _selfCpuTicks() {
    final s = _read('/proc/self/stat');
    if (s == null) return null;
    final f = s.substring(s.lastIndexOf(')') + 2).split(' ');
    // f[0] is field 3 (state); utime is field 14, stime field 15.
    return (int.tryParse(f[11]) ?? 0) + (int.tryParse(f[12]) ?? 0);
  }

  static int? _rss() {
    final s = _read('/proc/self/status');
    if (s == null) return null;
    final m = RegExp(r'VmRSS:\s+(\d+)').firstMatch(s);
    return m == null ? null : int.parse(m.group(1)!) * 1024;
  }

  static ({List<String> cpu, List<String> gpu, List<String> npu, List<String> ddr, List<String> battery})
  _discoverZones() {
    final cpu = <String>[], gpu = <String>[], npu = <String>[], ddr = <String>[], bat = <String>[];
    try {
      for (final z in Directory('/sys/class/thermal').listSync()) {
        final name = z.path.split('/').last;
        if (!name.startsWith('thermal_zone')) continue;
        final type = _read('${z.path}/type')?.trim();
        if (type == null) continue;
        final temp = '${z.path}/temp';
        if (_read(temp) == null) continue;
        if (RegExp(r'^cpu-\d').hasMatch(type)) {
          cpu.add(temp);
        } else if (type.startsWith('gpuss')) {
          gpu.add(temp);
        } else if (type.startsWith('nsp')) {
          npu.add(temp); // nsphvx-* (vector) / nsphmx-* (matrix) = Hexagon NPU
        } else if (type == 'ddr') {
          ddr.add(temp);
        } else if (type == 'battery') {
          bat.add(temp);
        }
      }
    } catch (_) {}
    return (cpu: cpu, gpu: gpu, npu: npu, ddr: ddr, battery: bat);
  }

  static double? _maxTemp(List<String> files) {
    double? best;
    for (final f in files) {
      final v = _readInt(f);
      if (v == null || v <= 0) continue;
      final c = v > 1000 ? v / 1000 : v.toDouble(); // millidegrees on Qualcomm
      best = best == null ? c : math.max(best, c);
    }
    return best;
  }

  /// Which sources this phone lets the app read, for the "sources" note.
  Map<String, bool> get availability => {
    'App CPU time': _selfCpuTicks() != null,
    'Core clocks': _coreMaxKhz.any((k) => k != null),
    'GPU busy': _read('/sys/class/kgsl/kgsl-3d0/gpubusy') != null,
    'CPU temp': _zones.cpu.isNotEmpty,
    'GPU temp': _zones.gpu.isNotEmpty,
    'NPU temp': _zones.npu.isNotEmpty,
    'NPU utilization': false,
  };
}
