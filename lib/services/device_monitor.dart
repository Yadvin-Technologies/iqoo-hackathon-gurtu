import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Static facts about the phone, read once.
class DeviceInfo {
  const DeviceInfo({
    required this.model,
    required this.socModel,
    required this.androidRelease,
    required this.sdkInt,
    required this.cores,
    required this.totalRamMb,
    required this.coreMaxKhz,
    this.coreMinKhz = const [],
  });

  final String model;
  final String socModel;
  final String androidRelease;
  final int sdkInt;
  final int cores;
  final int totalRamMb;
  final List<int> coreMaxKhz;
  final List<int> coreMinKhz;

  /// Friendly chip name for the Qualcomm parts people are likely to test on.
  String get socName => switch (socModel.toUpperCase()) {
        'SM8850' => 'Snapdragon 8 Elite Gen 5 (SM8850)',
        'SM8750' => 'Snapdragon 8 Elite (SM8750)',
        'SM8650' => 'Snapdragon 8 Gen 3 (SM8650)',
        'SM8550' => 'Snapdragon 8 Gen 2 (SM8550)',
        _ => socModel,
      };

  bool get isQualcomm => socModel.toUpperCase().startsWith('SM') || socModel.toUpperCase().startsWith('QCS');
}

/// One sample of live device telemetry. Fields are null when the sandbox
/// doesn't allow reading the underlying counter on this device.
class DeviceSample {
  const DeviceSample({
    required this.at,
    this.appCpuPercent,
    this.systemCpuPercent,
    this.coreBusyPercent = const [],
    this.coreFreqPercent = const [],
    this.gpuBusyPercent,
    this.cpuTempC,
    this.gpuTempC,
    this.npuTempC,
    this.cpuPowerW,
    this.gpuPowerW,
    this.npuPowerW,
    this.npuLoadPercent,
    this.appRamMb,
    this.appGraphicsMb,
    this.availRamMb,
    this.powerWatts,
    this.batteryTempC,
    this.batteryPercent,
    this.charging,
    this.plugged,
    this.thermalStatus,
    this.thermalHeadroom,
  });

  final DateTime at;

  /// This app's CPU time as a share of all cores (0-100). Inference threads
  /// run inside this process, so this is the model's CPU cost.
  final double? appCpuPercent;

  /// Whole-device CPU busy share across online cores (0-100), all processes.
  final double? systemCpuPercent;

  /// Busy % of each core over the last sample interval.
  final List<double> coreBusyPercent;

  /// Current frequency of each core as % of its max.
  final List<double> coreFreqPercent;

  /// Adreno busy % over the driver's last ~1 s window, from kgsl `gpubusy`.
  final double? gpuBusyPercent;

  final double? cpuTempC;
  final double? gpuTempC;

  /// Hexagon NSP (NPU) temperature, hottest of the HMX / HVX sensors.
  final double? npuTempC;

  /// Measured rail power (on-device power monitor, API 35+). The OS refreshes
  /// these for apps about every 30 s, so each is the average of the last window.
  final double? cpuPowerW;
  final double? gpuPowerW;
  final double? npuPowerW;

  /// NPU load estimate: NSP rail power as a share of the NSP's peak power.
  /// Android exposes no NPU utilisation counter to apps, so this is derived.
  final double? npuLoadPercent;

  /// Proportional set size incl. graphics buffers when available, else RSS.
  final double? appRamMb;

  /// GPU / graphics memory attributed to this app (memtrack).
  final double? appGraphicsMb;
  final double? availRamMb;

  /// Battery discharge power. Null while plugged in: battery current then
  /// reflects charging, not what the phone draws.
  final double? powerWatts;
  final double? batteryTempC;
  final int? batteryPercent;
  final bool? charging;
  final bool? plugged;
  final int? thermalStatus;
  final double? thermalHeadroom;

  double? get avgCoreFreqPercent => coreFreqPercent.isEmpty
      ? null
      : coreFreqPercent.reduce((a, b) => a + b) / coreFreqPercent.length;

  /// CPU + GPU + NPU rail power, the SoC compute draw.
  double? get socPowerW {
    final parts = [cpuPowerW, gpuPowerW, npuPowerW].whereType<double>();
    return parts.isEmpty ? null : parts.reduce((a, b) => a + b);
  }
}

/// One power-monitor window: energy per subsystem between two OS snapshots.
class RailWindow {
  RailWindow(this.start, this.end, this.joules);

  final DateTime start;
  final DateTime end;
  final Map<RailGroup, double> joules;

  double get seconds => end.difference(start).inMicroseconds / 1e6;
  double? watts(RailGroup g) => joules[g] == null || seconds <= 0 ? null : joules[g]! / seconds;
}

enum RailGroup { cpu, gpu, npu }

/// Turns cumulative per-rail energy snapshots into per-window power, and
/// attributes energy to arbitrary time spans (a benchmark run).
class PowerRails {
  /// Floor for the NPU peak reference so a lightly loaded NSP isn't shown as 100%.
  static const npuReferenceFloorW = 1.0;

  final List<RailWindow> windows = [];
  Map<RailGroup, int>? _lastEnergyUws;
  DateTime? _lastAt;
  int? _lastTsMs;
  double _npuPeakW = 0;

  /// False until the first snapshot arrives; stays false if the device has no rails.
  bool available = false;

  RailWindow? get latest => windows.isEmpty ? null : windows.last;

  static RailGroup? groupOf(String rail) {
    final n = rail.toLowerCase();
    if (n.contains('nsp') || n.contains('cdsp') || n.contains('npu') || n.contains('tpu')) return RailGroup.npu;
    if (n.contains('gpu')) return RailGroup.gpu;
    if (n.contains('cpu')) return RailGroup.cpu;
    return null;
  }

  double get npuReferenceW => math.max(npuReferenceFloorW, _npuPeakW);

  double? npuLoadPercent(double? watts) =>
      watts == null ? null : (watts / npuReferenceW * 100).clamp(0, 100).toDouble();

  void ingest(Map<Object?, Object?> raw, DateTime now) {
    final rails = raw['rails'];
    final nowElapsed = (raw['nowElapsedMs'] as num?)?.toInt();
    if (rails is! List || nowElapsed == null) return;

    final energy = <RailGroup, int>{};
    var tsMs = 0;
    for (final r in rails.whereType<Map<Object?, Object?>>()) {
      final g = groupOf('${r['name']}');
      final e = (r['energyUws'] as num?)?.toInt();
      final ts = (r['timestampMs'] as num?)?.toInt();
      if (g == null || e == null || e < 0 || ts == null) continue;
      energy[g] = (energy[g] ?? 0) + e;
      tsMs = math.max(tsMs, ts);
    }
    if (energy.isEmpty || tsMs == 0) return;
    available = true;

    // Dedupe on the OS timestamp: the wall-clock conversion jitters by a few ms.
    if (_lastTsMs != null && tsMs <= _lastTsMs!) return;
    final at = now.subtract(Duration(milliseconds: nowElapsed - tsMs));
    final prev = _lastEnergyUws, prevAt = _lastAt;
    _lastEnergyUws = energy;
    _lastAt = at;
    _lastTsMs = tsMs;
    if (prev == null || prevAt == null) return;

    final joules = <RailGroup, double>{};
    for (final g in energy.keys) {
      final d = energy[g]! - (prev[g] ?? energy[g]!);
      if (d >= 0) joules[g] = d / 1e6;
    }
    final w = RailWindow(prevAt, at, joules);
    windows.add(w);
    if (windows.length > 120) windows.removeAt(0);
    final npu = w.watts(RailGroup.npu);
    if (npu != null) _npuPeakW = math.max(_npuPeakW, npu);
  }

  /// Average power of [g] during [start, end], or null until the power
  /// monitor has a snapshot on both sides of the span.
  ///
  /// Windows are ~30 s, so a run rarely lines up with one. The energy of every
  /// window touching the run is summed and the idle draw (from the window just
  /// before) is subtracted for the part of those windows outside the run.
  double? averageWatts(RailGroup g, DateTime start, DateTime end) {
    final runSec = end.difference(start).inMicroseconds / 1e6;
    if (runSec <= 0 || windows.isEmpty || windows.last.end.isBefore(end)) return null;
    final i0 = windows.indexWhere((w) => w.end.isAfter(start));
    if (i0 < 0 || windows[i0].start.isAfter(start)) return null;
    var joules = 0.0;
    var spanSec = 0.0;
    for (var i = i0; i < windows.length && windows[i].start.isBefore(end); i++) {
      final j = windows[i].joules[g];
      if (j == null) return null;
      joules += j;
      spanSec += windows[i].seconds;
    }
    final idleW = i0 > 0 ? (windows[i0 - 1].watts(g) ?? 0) : 0.0;
    return math.max(0, (joules - idleW * (spanSec - runSec)) / runSec).toDouble();
  }
}

/// Polls CPU, GPU, NPU, memory, power and thermal counters on a timer and
/// keeps a short rolling history for sparklines.
class DeviceMonitor extends ChangeNotifier {
  DeviceMonitor({this.interval = const Duration(milliseconds: 500), this.historyLength = 120});

  static const _channel = MethodChannel('gurtutest/device_stats');

  final Duration interval;
  final int historyLength;

  DeviceInfo? info;
  final List<DeviceSample> history = [];
  DeviceSample? get latest => history.isEmpty ? null : history.last;

  final rails = PowerRails();

  Timer? _timer;
  bool _sampling = false;
  int _tick = 0;

  // Previous readings for rate-based metrics.
  int? _lastCpuTicks;
  DateTime? _lastCpuAt;
  final _cpuLoad = _CpuLoadReader();

  // Slow counters refreshed every few ticks.
  Map<Object?, Object?> _memory = const {};

  // Thermal zone paths grouped by subsystem, discovered once.
  final List<String> _cpuZones = [];
  final List<String> _gpuZones = [];
  final List<String> _npuZones = [];

  static const _clockTicksPerSecond = 100; // USER_HZ on Android arm64.

  Future<void> start() async {
    if (_timer != null) return;
    info ??= await _readDeviceInfo();
    _cpuLoad.cores = info!.cores;
    await _discoverThermalZones();
    await _sample();
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

  Future<DeviceInfo> _readDeviceInfo() async {
    Map<Object?, Object?> raw = const {};
    try {
      raw = await _channel.invokeMapMethod<Object?, Object?>('deviceInfo') ?? const {};
    } catch (_) {}
    final cores = (raw['cores'] as int?) ?? Platform.numberOfProcessors;
    final maxKhz = <int>[], minKhz = <int>[];
    for (var i = 0; i < cores; i++) {
      maxKhz.add(await _readInt('/sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_max_freq') ?? 0);
      minKhz.add(await _readInt('/sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_min_freq') ?? 0);
    }
    final memInfo = await _readMemInfo();
    return DeviceInfo(
      model: '${raw['manufacturer'] ?? ''} ${raw['model'] ?? 'Unknown'}'.trim(),
      socModel: (raw['socModel'] as String?) ?? 'unknown',
      androidRelease: (raw['release'] as String?) ?? '?',
      sdkInt: (raw['sdkInt'] as int?) ?? 0,
      cores: cores,
      totalRamMb: ((memInfo['MemTotal'] ?? 0) / 1024).round(),
      coreMaxKhz: maxKhz,
      coreMinKhz: minKhz,
    );
  }

  Future<void> _discoverThermalZones() async {
    if (_cpuZones.isNotEmpty || _gpuZones.isNotEmpty || _npuZones.isNotEmpty) return;
    final dir = Directory('/sys/class/thermal');
    try {
      final zones = dir.listSync().whereType<Directory>().where((d) => d.path.contains('thermal_zone'));
      for (final z in zones) {
        final type = await _readString('${z.path}/type');
        if (type == null) continue;
        final tempPath = '${z.path}/temp';
        if (await _readInt(tempPath) == null) continue;
        // Qualcomm naming: cpu-*/cpullc-* (CPU), gpuss-* (Adreno),
        // nsphvx-*/nsphmx-* (Hexagon NPU vector / matrix units).
        if (type.startsWith('cpu-') && !type.contains('trip')) {
          _cpuZones.add(tempPath);
        } else if (type.startsWith('gpuss') || type.startsWith('gpu')) {
          _gpuZones.add(tempPath);
        } else if (type.startsWith('nsp') || type.contains('cdsp') || type.contains('npu')) {
          _npuZones.add(tempPath);
        }
      }
    } catch (_) {}
  }

  Future<void> _sample() async {
    if (_sampling) return;
    _sampling = true;
    try {
      final now = DateTime.now();
      final tick = _tick++;
      final results = await Future.wait<Object?>([
        _appCpuPercent(now),
        _coreFreqs(),
        _gpuBusy(),
        _maxTemp(_cpuZones),
        _maxTemp(_gpuZones),
        _maxTemp(_npuZones),
        _appRssMb(),
        _readMemInfo(),
        _invoke('power'),
        _cpuLoad.read(info),
        // Rails only change every ~30 s and memory walks smaps; poll those slower.
        if (tick % 2 == 0) _invoke('powerRails') else Future.value(null),
        if (tick % 4 == 0) _invoke('memory') else Future.value(null),
      ]);
      final mem = results[7] as Map<String, int>;
      final power = results[8] as Map<Object?, Object?>;
      final cpuLoad = results[9] as _CpuLoad?;
      final railsRaw = results[10] as Map<Object?, Object?>?;
      if (railsRaw != null) rails.ingest(railsRaw, now);
      if (results[11] != null) _memory = results[11] as Map<Object?, Object?>;

      final plugged = power['plugged'] as bool? ?? power['charging'] as bool?;
      final pssKb = (_memory['totalPssKb'] as num?)?.toDouble();
      final gfxKb = (_memory['graphicsKb'] as num?)?.toDouble();
      final rail = rails.latest;
      final npuW = rail?.watts(RailGroup.npu);

      history.add(DeviceSample(
        at: now,
        appCpuPercent: results[0] as double?,
        systemCpuPercent: cpuLoad?.system,
        coreBusyPercent: cpuLoad?.perCore ?? const [],
        coreFreqPercent: results[1] as List<double>,
        gpuBusyPercent: results[2] as double?,
        cpuTempC: results[3] as double?,
        gpuTempC: results[4] as double?,
        npuTempC: results[5] as double?,
        cpuPowerW: rail?.watts(RailGroup.cpu),
        gpuPowerW: rail?.watts(RailGroup.gpu),
        npuPowerW: npuW,
        npuLoadPercent: rails.npuLoadPercent(npuW),
        appRamMb: pssKb != null && pssKb > 0 ? pssKb / 1024 : results[6] as double?,
        appGraphicsMb: gfxKb == null ? null : gfxKb / 1024,
        availRamMb: mem['MemAvailable'] == null ? null : mem['MemAvailable']! / 1024,
        powerWatts: plugged == true ? null : _batteryWatts(power),
        batteryTempC: (power['batteryTempDeciC'] as num?) == null ? null : (power['batteryTempDeciC'] as num) / 10,
        batteryPercent: power['levelPercent'] as int?,
        charging: power['charging'] as bool?,
        plugged: plugged,
        thermalStatus: power['thermalStatus'] as int?,
        thermalHeadroom: (power['thermalHeadroom'] as num?)?.toDouble(),
      ));
      if (history.length > historyLength) history.removeAt(0);
      notifyListeners();
    } finally {
      _sampling = false;
    }
  }

  /// Battery discharge power from CURRENT_NOW × voltage. Only valid unplugged.
  static double? _batteryWatts(Map<Object?, Object?> power) {
    final raw = (power['currentMicroAmps'] as num?)?.abs();
    final millivolts = power['voltageMilliVolts'] as num?;
    if (raw == null || raw == 0 || millivolts == null || millivolts <= 0) return null;
    // The API contract is µA. A few OEMs report mA; an unplugged, screen-on
    // phone never draws under 10 mA, so a value that small must be mA.
    final amps = raw < 10000 ? raw / 1e3 : raw / 1e6;
    return amps * millivolts / 1000;
  }

  Future<double?> _appCpuPercent(DateTime now) async {
    final stat = await _readString('/proc/self/stat');
    if (stat == null) return null;
    // Fields after the ")" of the comm field; utime/stime are fields 14/15.
    final rest = stat.substring(stat.lastIndexOf(')') + 2).split(' ');
    final ticks = int.parse(rest[11]) + int.parse(rest[12]);
    final prevTicks = _lastCpuTicks, prevAt = _lastCpuAt;
    _lastCpuTicks = ticks;
    _lastCpuAt = now;
    if (prevTicks == null || prevAt == null) return null;
    final wallSec = now.difference(prevAt).inMicroseconds / 1e6;
    if (wallSec <= 0) return null;
    final cpuSec = (ticks - prevTicks) / _clockTicksPerSecond;
    final cores = info?.cores ?? Platform.numberOfProcessors;
    return (cpuSec / wallSec / cores * 100).clamp(0, 100).toDouble();
  }

  Future<List<double>> _coreFreqs() async {
    final max = info?.coreMaxKhz ?? const [];
    final out = <double>[];
    for (var i = 0; i < max.length; i++) {
      final cur = await _readInt('/sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq');
      if (cur == null || max[i] == 0) continue;
      out.add((cur / max[i] * 100).clamp(0, 100).toDouble());
    }
    return out;
  }

  Future<double?> _gpuBusy() async {
    // Adreno: "<busy> <total>" µs for the driver's last ~1 s window; "0 0"
    // once the GPU has power-collapsed, i.e. idle.
    final s = await _readString('/sys/class/kgsl/kgsl-3d0/gpubusy');
    if (s != null) {
      final parts = s.trim().split(RegExp(r'\s+'));
      if (parts.length == 2) {
        final busy = int.tryParse(parts[0]) ?? 0, total = int.tryParse(parts[1]) ?? 0;
        return total == 0 ? 0 : (busy / total * 100).clamp(0, 100).toDouble();
      }
    }
    final pct = await _readInt('/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage');
    return pct?.toDouble();
  }

  Future<double?> _maxTemp(List<String> paths) async {
    double? best;
    for (final p in paths) {
      final milli = await _readInt(p);
      if (milli == null || milli <= -40000) continue;
      final c = milli / 1000;
      best = best == null ? c : math.max(best, c);
    }
    return best;
  }

  Future<double?> _appRssMb() async {
    final s = await _readString('/proc/self/status');
    if (s == null) return null;
    final m = RegExp(r'VmRSS:\s+(\d+)\s+kB').firstMatch(s);
    return m == null ? null : int.parse(m.group(1)!) / 1024;
  }

  Future<Map<String, int>> _readMemInfo() async {
    final s = await _readString('/proc/meminfo');
    final out = <String, int>{};
    if (s == null) return out;
    for (final line in s.split('\n')) {
      final m = RegExp(r'^(\w+):\s+(\d+)').firstMatch(line);
      if (m != null) out[m.group(1)!] = int.parse(m.group(2)!);
    }
    return out;
  }

  Future<Map<Object?, Object?>> _invoke(String method) async {
    try {
      return await _channel.invokeMapMethod<Object?, Object?>(method) ?? const {};
    } catch (_) {
      return const {};
    }
  }

  static Future<String?> _readString(String path) async {
    try {
      return await File(path).readAsString();
    } catch (_) {
      return null;
    }
  }

  static Future<int?> _readInt(String path) async {
    final s = await _readString(path);
    return s == null ? null : int.tryParse(s.trim());
  }
}

class _CpuLoad {
  const _CpuLoad(this.system, this.perCore);
  final double? system;
  final List<double> perCore;
}

/// Whole-device CPU utilisation. Uses /proc/stat when the sandbox allows it
/// (exact kernel accounting); otherwise per-core cpuidle residency, which apps
/// can read on Qualcomm devices.
class _CpuLoadReader {
  int cores = 0;

  // /proc/stat: per core (busy, total) jiffies.
  Map<int, (int, int)>? _prevStat;
  bool _statReadable = true;

  // cpuidle: per core (idle µs, idle entries) and the wall clock of the read.
  final _clock = Stopwatch()..start();
  Map<int, (int, int)>? _prevIdle;
  int? _prevIdleAtUs;
  Map<int, List<String>>? _idleStates;

  Future<_CpuLoad?> read(DeviceInfo? info) async {
    if (_statReadable) {
      final r = await _fromProcStat();
      if (r != null) return r;
    }
    return _fromCpuIdle(info);
  }

  Future<_CpuLoad?> _fromProcStat() async {
    final s = await DeviceMonitor._readString('/proc/stat');
    if (s == null) {
      _statReadable = false;
      return null;
    }
    final now = <int, (int, int)>{};
    for (final line in s.split('\n')) {
      final m = RegExp(r'^cpu(\d+)\s+(.*)$').firstMatch(line);
      if (m == null) continue;
      final f = m.group(2)!.trim().split(RegExp(r'\s+')).map(int.parse).toList();
      if (f.length < 5) continue;
      // user nice system idle iowait irq softirq steal
      final total = f.take(8).reduce((a, b) => a + b);
      final idle = f[3] + f[4];
      now[int.parse(m.group(1)!)] = (total - idle, total);
    }
    final prev = _prevStat;
    _prevStat = now;
    if (prev == null || now.isEmpty) return const _CpuLoad(null, []);
    return _combine({
      for (final c in now.keys)
        if (prev[c] != null && now[c]!.$2 > prev[c]!.$2)
          c: (now[c]!.$1 - prev[c]!.$1) / (now[c]!.$2 - prev[c]!.$2) * 100,
    });
  }

  Future<_CpuLoad?> _fromCpuIdle(DeviceInfo? info) async {
    final states = _idleStates ??= _discoverIdleStates();
    if (states.isEmpty) return null;
    final atUs = _clock.elapsedMicroseconds;
    final now = <int, (int, int)>{};
    for (final c in states.keys) {
      if (await DeviceMonitor._readString('/sys/devices/system/cpu/cpu$c/online') case final o? when o.trim() == '0') {
        continue; // offline cores aren't available capacity
      }
      var time = 0, usage = 0;
      for (final dir in states[c]!) {
        time += await DeviceMonitor._readInt('$dir/time') ?? 0;
        usage += await DeviceMonitor._readInt('$dir/usage') ?? 0;
      }
      now[c] = (time, usage);
    }
    final prev = _prevIdle, prevAt = _prevIdleAtUs;
    _prevIdle = now;
    _prevIdleAtUs = atUs;
    if (prev == null || prevAt == null) return const _CpuLoad(null, []);
    final wallUs = atUs - prevAt;
    if (wallUs <= 0) return null;

    final busy = <int, double>{};
    for (final c in now.keys) {
      final p = prev[c];
      if (p == null) continue;
      final idleUs = now[c]!.$1 - p.$1, entries = now[c]!.$2 - p.$2;
      if (idleUs == 0 && entries == 0) {
        // cpuidle books idle time on exit, so a core that never entered or left
        // idle this window was either pegged or asleep throughout. Its clock
        // tells which: governors park sleeping cores at the minimum frequency.
        busy[c] = await _looksBusy(c, info) ? 100 : 0;
      } else {
        busy[c] = (1 - idleUs / wallUs) * 100;
      }
    }
    return _combine(busy);
  }

  Future<bool> _looksBusy(int core, DeviceInfo? info) async {
    final cur = await DeviceMonitor._readInt('/sys/devices/system/cpu/cpu$core/cpufreq/scaling_cur_freq');
    final max = (info?.coreMaxKhz.length ?? 0) > core ? info!.coreMaxKhz[core] : 0;
    final min = (info?.coreMinKhz.length ?? 0) > core ? info!.coreMinKhz[core] : 0;
    if (cur == null || max <= min) return false;
    return cur > min + (max - min) * 0.15;
  }

  Map<int, List<String>> _discoverIdleStates() {
    final out = <int, List<String>>{};
    for (var c = 0; c < cores; c++) {
      try {
        final dirs = Directory('/sys/devices/system/cpu/cpu$c/cpuidle')
            .listSync()
            .whereType<Directory>()
            .where((d) => d.path.split('/').last.startsWith('state'))
            .map((d) => d.path)
            .toList();
        if (dirs.isNotEmpty) out[c] = dirs;
      } catch (_) {}
    }
    return out;
  }

  _CpuLoad _combine(Map<int, double> busy) {
    if (busy.isEmpty) return const _CpuLoad(null, []);
    final perCore = [for (var c = 0; c < cores; c++) (busy[c] ?? 0).clamp(0, 100).toDouble()];
    final online = busy.values.map((v) => v.clamp(0, 100).toDouble());
    return _CpuLoad(online.reduce((a, b) => a + b) / online.length, perCore);
  }
}

/// Aggregates samples taken while a generation runs.
class UsageWindow {
  UsageWindow({this.rails, DateTime? start}) : start = start ?? DateTime.now();

  final PowerRails? rails;
  final DateTime start;
  DateTime? end;

  final List<DeviceSample> _samples = [];

  void add(DeviceSample s) => _samples.add(s);
  void finish() => end ??= DateTime.now();
  bool get isEmpty => _samples.isEmpty;

  double? _avg(double? Function(DeviceSample) f) {
    final v = _samples.map(f).whereType<double>().toList();
    return v.isEmpty ? null : v.reduce((a, b) => a + b) / v.length;
  }

  double? _max(double? Function(DeviceSample) f) {
    final v = _samples.map(f).whereType<double>().toList();
    return v.isEmpty ? null : v.reduce(math.max);
  }

  double? get avgCpu => _avg((s) => s.appCpuPercent);
  double? get peakCpu => _max((s) => s.appCpuPercent);
  double? get avgSystemCpu => _avg((s) => s.systemCpuPercent);
  double? get avgGpu => _avg((s) => s.gpuBusyPercent);
  double? get peakGpu => _max((s) => s.gpuBusyPercent);
  double? get avgPower => _avg((s) => s.powerWatts);
  double? get peakPower => _max((s) => s.powerWatts);
  double? get peakCpuTemp => _max((s) => s.cpuTempC);
  double? get peakGpuTemp => _max((s) => s.gpuTempC);
  double? get peakNpuTemp => _max((s) => s.npuTempC);
  double? get peakRam => _max((s) => s.appRamMb);
  double? get peakGraphicsRam => _max((s) => s.appGraphicsMb);

  /// Rail power attributed to this run. Null until the power monitor has a
  /// snapshot after the run ended (up to ~30 s later) or on unsupported devices.
  double? railWatts(RailGroup g) {
    final e = end;
    return e == null ? null : rails?.averageWatts(g, start, e);
  }

  double? get npuPowerW => railWatts(RailGroup.npu);
  double? get gpuPowerW => railWatts(RailGroup.gpu);
  double? get cpuPowerW => railWatts(RailGroup.cpu);
  double? get npuLoadPercent => rails?.npuLoadPercent(npuPowerW);

  double? get socPowerW {
    final parts = [cpuPowerW, gpuPowerW, npuPowerW].whereType<double>();
    return parts.isEmpty ? null : parts.reduce((a, b) => a + b);
  }

  /// True while a run's rail numbers are still waiting for the next OS snapshot.
  bool get railsPending =>
      (rails?.available ?? false) && end != null && (rails!.windows.isEmpty || rails!.windows.last.end.isBefore(end!));
}
