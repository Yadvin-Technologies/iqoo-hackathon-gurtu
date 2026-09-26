import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/services/device_monitor.dart';
import 'package:gurtutest/services/gemma_service.dart';

BenchResult _result({
  bool thinking = false,
  int? firstTokenMs = 500,
  int? firstAnswerTokenMs = 500,
  int totalMs = 5500,
  SessionMetrics? metrics,
}) =>
    BenchResult(
      index: 1,
      model: GemmaModelSpec.e4b,
      prompt: 'p',
      thinking: thinking,
      requestedBackend: PreferredBackend.npu,
      activeBackend: PreferredBackend.gpu,
      speculative: false,
      thinkingText: '',
      answer: 'a',
      firstTokenMs: firstTokenMs,
      firstAnswerTokenMs: firstAnswerTokenMs,
      totalMs: totalMs,
      metrics: metrics,
      usage: UsageWindow(),
      stopped: false,
    );

void main() {
  test('decode speed is derived from output tokens after the first token', () {
    final r = _result(metrics: SessionMetrics(inputTokens: 100, outputTokens: 100));
    expect(r.decodeTokPerSec, closeTo(20, 1e-9)); // 100 tokens over 5 s
    expect(r.prefillTokPerSec, closeTo(200, 1e-9)); // 100 tokens in 0.5 s
  });

  test('engine-reported speed wins over the derived one', () {
    final r = _result(metrics: SessionMetrics(outputTokens: 100, tokensPerSecond: 42));
    expect(r.decodeTokPerSec, 42);
  });

  test('thinking time spans first token to first answer token', () {
    expect(_result(thinking: true, firstTokenMs: 400, firstAnswerTokenMs: 3400).thinkingMs, 3000);
    expect(_result(thinking: false).thinkingMs, isNull);
  });

  test('usage window aggregates only the counters that were readable', () {
    final w = UsageWindow()
      ..add(DeviceSample(at: DateTime(2026), appCpuPercent: 20, powerWatts: 4))
      ..add(DeviceSample(at: DateTime(2026), appCpuPercent: 40));
    expect(w.avgCpu, 30);
    expect(w.peakCpu, 40);
    expect(w.avgPower, 4);
    expect(w.avgGpu, isNull);
  });

  group('power rails', () {
    final t0 = DateTime(2026, 9, 26, 12);

    // One OS snapshot every 30 s; [nspJoules] is the cumulative NSP energy.
    Map<Object?, Object?> snapshot(int sec, double nspJoules, {double gpuJoules = 0}) => {
          'nowElapsedMs': 1000000 + sec * 1000,
          'rails': [
            {'name': 'nsp', 'energyUws': (nspJoules * 1e6).round(), 'timestampMs': 1000000 + sec * 1000},
            {'name': 'gpu', 'energyUws': (gpuJoules * 1e6).round(), 'timestampMs': 1000000 + sec * 1000},
            {'name': 'debug-0', 'energyUws': 5, 'timestampMs': 1000000 + sec * 1000},
          ],
        };

    PowerRails feed(List<(int, double)> points) {
      final r = PowerRails();
      for (final (sec, j) in points) {
        r.ingest(snapshot(sec, j), t0.add(Duration(seconds: sec)));
      }
      return r;
    }

    test('consecutive snapshots become per-window watts', () {
      final r = feed([(0, 0), (30, 30)]);
      expect(r.windows, hasLength(1));
      expect(r.latest!.watts(RailGroup.npu), closeTo(1.0, 1e-9));
      expect(r.latest!.watts(RailGroup.gpu), 0);
    });

    test('a repeated snapshot does not create an empty window', () {
      final r = PowerRails()
        ..ingest(snapshot(0, 0), t0)
        ..ingest(snapshot(0, 0), t0.add(const Duration(seconds: 1)));
      expect(r.windows, isEmpty);
    });

    test('run power removes idle draw from the rest of the window', () {
      // Idle 0.1 W, then a 10 s NPU run at 2 W inside the 30-60 s window.
      final r = feed([(0, 0), (30, 3), (60, 3 + 3 + 19)]);
      final start = t0.add(const Duration(seconds: 40)), end = t0.add(const Duration(seconds: 50));
      expect(r.averageWatts(RailGroup.npu, start, end), closeTo(2.0, 1e-9));
    });

    test('run power is pending until a snapshot lands after the run', () {
      final r = feed([(0, 0), (30, 3)]);
      final start = t0.add(const Duration(seconds: 40)), end = t0.add(const Duration(seconds: 50));
      expect(r.averageWatts(RailGroup.npu, start, end), isNull);
      final u = UsageWindow(rails: r, start: start)..end = end;
      expect(u.railsPending, isTrue);
    });

    test('NPU load is relative to peak with a 1 W floor', () {
      final r = feed([(0, 0), (30, 3)]); // 0.1 W peak so far
      expect(r.npuLoadPercent(0.5), closeTo(50, 1e-9));
      r.ingest(snapshot(60, 3 + 120), t0.add(const Duration(seconds: 60))); // 4 W window
      expect(r.npuLoadPercent(2.0), closeTo(50, 1e-9));
    });
  });
}
