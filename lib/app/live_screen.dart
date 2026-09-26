import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../memory/memory.dart';
import '../perf/load_generator.dart';
import '../perf/telemetry.dart';
import 'memory_controller.dart';
import 'widgets.dart';

const _cpuColor = Color(0xFF14B8A6);
const _gpuColor = Color(0xFF8B5CF6);
const _npuColor = Color(0xFFF59E0B);
const _modelColor = Color(0xFF3B82F6);
const _powerColor = Color(0xFFEF4444);

const _thermalNames = ['None', 'Light', 'Moderate', 'Severe', 'Critical', 'Emergency', 'Shutdown'];

/// Real-time load on CPU, GPU and NPU while the memory layer works.
class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key, required this.c, required this.t, required this.load});

  final MemoryController c;
  final TelemetryService t;
  final LoadGenerator load;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([c, t, load]),
    builder: (context, _) {
      final s = t.latest;
      final h = t.history;
      return ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _WorkloadCard(c: c, load: load, s: s),
          if (s == null)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Collecting the first samples…')),
            )
          else ...[
            _MetricCard(
              color: _cpuColor,
              icon: Icons.memory,
              title: 'CPU · Snapdragon 8 Elite Gen 5',
              value: _pct(s.appCpuPct),
              unit: 'of all ${t.cores} cores',
              caption: s.appCpuCores == null
                  ? 'App CPU time not readable'
                  : 'This app is keeping ${s.appCpuCores!.toStringAsFixed(1)} cores busy',
              series: [for (final x in h) x.appCpuPct],
              max: 100,
              percent: true,
              extra: _CoreClocks(s: s, maxMhz: t.coreMaxMhz),
              temp: s.cpuTempC,
            ),
            _MetricCard(
              color: _gpuColor,
              icon: Icons.grid_view,
              title: 'GPU · Adreno 840',
              value: _pct(s.gpuBusyPct),
              unit: 'busy',
              caption: s.gpuBusyPct == null
                  ? 'GPU counters not readable on this phone'
                  : c.accelerator == NomicAccelerator.gpu && load.running
                  ? 'Includes the embedding model (GPU mode) + screen drawing'
                  : 'Screen drawing only: the model is not on the GPU',
              series: [for (final x in h) x.gpuBusyPct],
              max: 100,
              percent: true,
              temp: s.gpuTempC,
            ),
            _NpuCard(s: s, h: h, c: c),
            _MetricCard(
              color: _modelColor,
              icon: Icons.bolt,
              title: 'Embedding model · nomic-embed-text-v1',
              value: s.embedsPerSec.toStringAsFixed(1),
              unit: 'embeddings / s',
              caption: s.embedLatencyMs == null
                  ? 'Idle'
                  : '${s.embedLatencyMs!.toStringAsFixed(1)} ms per embedding · '
                        'on ${c.accelerator.name.toUpperCase()}',
              series: [for (final x in h) x.embedsPerSec],
              max: math.max(10, h.fold<double>(0, (m, x) => math.max(m, x.embedsPerSec)) * 1.2),
            ),
            _PowerCard(s: s, h: h),
            _SourcesNote(t: t),
          ],
        ],
      );
    },
  );

  static String _pct(double? v) => v == null ? '–' : v.toStringAsFixed(0);
}

class _WorkloadCard extends StatelessWidget {
  const _WorkloadCard({required this.c, required this.load, required this.s});

  final MemoryController c;
  final LoadGenerator load;
  final TelemetrySample? s;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final busy = c.status == ModelStatus.loading;
    final ref = c.referenceCosine;
    return Section(
      title: 'Workload',
      subtitle: 'Start the load to keep the memory model embedding continuously, then '
          'watch where the work lands. Switch the model between processors to compare.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<NomicAccelerator?>(
            segments: const [
              ButtonSegment(value: NomicAccelerator.cpu, label: Text('CPU'), icon: Icon(Icons.memory)),
              ButtonSegment(value: NomicAccelerator.gpu, label: Text('GPU (exp.)'), icon: Icon(Icons.grid_view)),
              ButtonSegment(value: null, label: Text('NPU'), icon: Icon(Icons.blur_on), enabled: false),
            ],
            selected: {c.accelerator},
            onSelectionChanged: !c.isInstalled || busy || load.running
                ? null
                : (sel) async {
                    final a = sel.single;
                    if (a == null) return;
                    try {
                      await c.useAccelerator(a);
                      await c.verify();
                    } catch (_) {}
                  },
          ),
          const SizedBox(height: 4),
          Text(
            'NPU: no Hexagon build of Nomic exists (it needs a model compiled for SM8850), '
            'so the model cannot be placed there.',
            style: t.labelSmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: !c.isInstalled || busy
                      ? null
                      : load.running
                      ? load.stop
                      : () => load.start(),
                  icon: Icon(load.running ? Icons.stop : Icons.play_arrow),
                  label: Text(load.running ? 'Stop load' : 'Start load'),
                  style: load.running ? FilledButton.styleFrom(backgroundColor: _powerColor) : null,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: !c.isInstalled || busy || load.running ? null : () => c.verify().ignore(),
                child: const Text('Verify output'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _Pill(
                busy ? 'Loading model on ${c.accelerator.name.toUpperCase()}…' : 'Model on ${c.accelerator.name.toUpperCase()}',
                busy ? Colors.orange : Colors.teal,
              ),
              if (load.running) _Pill('Running · ${load.embedded} embedded', _modelColor),
              if (ref != null)
                _Pill(
                  ref >= 0.99
                      ? '✓ Output matches Arm reference (${ref.toStringAsFixed(4)})'
                      : '✗ Output differs from reference (${ref.toStringAsFixed(4)})',
                  ref >= 0.99 ? Colors.green : Colors.red,
                ),
            ],
          ),
          if (c.error != null || load.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(c.error ?? load.error!, style: t.bodySmall!.copyWith(color: Colors.red)),
            ),
          if (!c.isInstalled)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Download the model on the Memory tab first.', style: t.bodySmall),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, this.color);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.5)),
    ),
    child: Text(text, style: Theme.of(context).textTheme.labelSmall!.copyWith(color: color)),
  );
}

/// Big current value + 60 s chart + optional extras.
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.caption,
    required this.series,
    required this.max,
    this.extra,
    this.temp,
    this.percent = false,
  });

  final bool percent;
  final Color color;
  final IconData icon;
  final String title, value, unit, caption;
  final List<double?> series;
  final double max;
  final Widget? extra;
  final double? temp;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(title, style: t.titleSmall)),
                if (temp != null) _Temp(temp!),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: t.displaySmall!.copyWith(color: color, fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(percent ? '%  $unit' : unit, style: t.bodyMedium),
                ),
              ],
            ),
            Text(caption, style: t.bodySmall),
            const SizedBox(height: 8),
            LineChart(series, color: color, max: max),
            if (extra != null) ...[const SizedBox(height: 10), extra!],
          ],
        ),
      ),
    );
  }
}

class _Temp extends StatelessWidget {
  const _Temp(this.c);

  final double c;

  @override
  Widget build(BuildContext context) {
    final color = c >= 45 ? Colors.red : (c >= 40 ? Colors.orange : Colors.green);
    return Row(
      children: [
        Icon(Icons.thermostat, size: 16, color: color),
        Text('${c.toStringAsFixed(1)} °C', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: color)),
      ],
    );
  }
}

/// One bar per core, grouped by cluster, height = current clock / max clock.
class _CoreClocks extends StatelessWidget {
  const _CoreClocks({required this.s, required this.maxMhz});

  final TelemetrySample s;
  final List<int?> maxMhz;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    if (s.coreFreqPct.isEmpty) return const SizedBox.shrink();
    // Group cores by their max clock: the SM8850 has 6 performance cores and
    // 2 prime cores.
    final groups = <int?, List<int>>{};
    for (var i = 0; i < s.coreFreqPct.length; i++) {
      groups.putIfAbsent(maxMhz[i], () => []).add(i);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Core clocks (how hard the scheduler is driving each core)', style: t.labelSmall),
        const SizedBox(height: 6),
        SizedBox(
          height: 78,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final MapEntry(key: max, value: idx) in groups.entries) ...[
                Expanded(
                  flex: idx.length,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final i in idx)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text((s.coreFreqMhz[i] / 1000).toStringAsFixed(1),
                                          style: t.labelSmall!.copyWith(fontSize: 9)),
                                      const SizedBox(height: 2),
                                      Flexible(
                                        child: FractionallySizedBox(
                                          heightFactor: (s.coreFreqPct[i] / 100).clamp(0.03, 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color.lerp(_cpuColor.withValues(alpha: 0.35), _cpuColor,
                                                  s.coreFreqPct[i] / 100),
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${idx.length} × ${max == null ? '?' : (max / 1000).toStringAsFixed(1)} GHz '
                        '${max != null && max > 4000 ? 'prime' : 'perf'}',
                        style: t.labelSmall!.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        Text('GHz now · bar = % of that core\'s max clock', style: t.labelSmall!.copyWith(fontSize: 10)),
      ],
    );
  }
}

class _NpuCard extends StatelessWidget {
  const _NpuCard({required this.s, required this.h, required this.c});

  final TelemetrySample s;
  final List<TelemetrySample> h;
  final MemoryController c;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final temps = [for (final x in h) x.npuTempC];
    final known = temps.whereType<double>().toList();
    final lo = known.isEmpty ? 30.0 : known.reduce(math.min) - 1;
    final hi = known.isEmpty ? 50.0 : math.max(known.reduce(math.max) + 1, lo + 6);
    final delta = known.length < 2 ? null : known.last - known.first;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.blur_on, color: _npuColor, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text('NPU · Hexagon (HVX vector + HMX matrix)', style: t.titleSmall)),
                if (s.npuTempC != null) _Temp(s.npuTempC!),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Not used', style: t.displaySmall!.copyWith(color: _npuColor, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    delta == null ? '' : 'ΔT ${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)} °C over ${h.length} s',
                    style: t.bodyMedium,
                  ),
                ),
              ],
            ),
            Text(
              'The memory model runs on ${c.accelerator.name.toUpperCase()}, so no work is sent to the NPU. '
              'Android gives apps no NPU utilization counter. The NPU\'s own temperature '
              'sensors are the only signal: they rise only when the NPU computes.',
              style: t.bodySmall,
            ),
            const SizedBox(height: 8),
            LineChart(temps, color: _npuColor, min: lo, max: hi, unit: '°C'),
          ],
        ),
      ),
    );
  }
}

class _PowerCard extends StatelessWidget {
  const _PowerCard({required this.s, required this.h});

  final TelemetrySample s;
  final List<TelemetrySample> h;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final status = s.thermalStatus;
    final headroom = s.thermalHeadroom;
    final watts = [for (final x in h) x.powerW];
    final peak = watts.whereType<double>().fold<double>(0, math.max);
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.battery_charging_full, color: _powerColor, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text('Power & thermals · whole phone', style: t.titleSmall)),
                if (s.batteryTempC != null) _Temp(s.batteryTempC!),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  s.powerW == null ? '–' : s.powerW!.toStringAsFixed(2),
                  style: t.displaySmall!.copyWith(color: _powerColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(s.powerW == null ? '' : 'W from battery', style: t.bodyMedium),
                ),
              ],
            ),
            Text(
              s.plugged == true
                  ? 'Plugged in: unplug the phone to measure battery power draw.'
                  : 'Battery current × voltage, as reported by Android.',
              style: t.bodySmall,
            ),
            const SizedBox(height: 8),
            LineChart(watts, color: _powerColor, max: math.max(4, peak * 1.2), unit: 'W'),
            const SizedBox(height: 10),
            KeyValues([
              ('Thermal status', status == null ? '–' : _thermalNames[status.clamp(0, 6)]),
              ('Thermal headroom', headroom == null
                  ? '–'
                  : '${(headroom * 100).toStringAsFixed(0)}% of the throttling limit (100% = throttling)'),
              ('Temperatures', '${[
                if (s.cpuTempC != null) 'CPU ${s.cpuTempC!.toStringAsFixed(1)}',
                if (s.gpuTempC != null) 'GPU ${s.gpuTempC!.toStringAsFixed(1)}',
                if (s.npuTempC != null) 'NPU ${s.npuTempC!.toStringAsFixed(1)}',
                if (s.ddrTempC != null) 'RAM ${s.ddrTempC!.toStringAsFixed(1)}',
              ].join(' · ')} °C'),
              ('App memory (RSS)', s.rssBytes == null ? '–' : formatBytes(s.rssBytes!)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _SourcesNote extends StatelessWidget {
  const _SourcesNote({required this.t});

  final TelemetryService t;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Section(
      title: 'Where these numbers come from',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CPU % = this app\'s CPU time (/proc/self/stat) ÷ all cores; core bars = cpufreq. '
            'GPU % = Adreno gpubusy. NPU/CPU/GPU °C = Qualcomm thermal zones '
            '(nsphvx/nsphmx, cpu-*, gpuss-*). Power = BatteryManager current × voltage. '
            'Sampled every second, last 60 s shown.',
            style: tt.bodySmall,
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final MapEntry(:key, :value) in t.availability.entries)
                _Pill('${value ? '✓' : '✗'} $key', value ? Colors.teal : Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}

/// Minimal 60 s line chart with grid lines; nulls leave gaps.
class LineChart extends StatelessWidget {
  const LineChart(this.values, {super.key, required this.color, this.min = 0, required this.max, this.unit = '%'});

  final List<double?> values;
  final Color color;
  final double min, max;
  final String unit;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 90,
    width: double.infinity,
    child: CustomPaint(
      painter: _LinePainter(
        values,
        color,
        min,
        max,
        unit,
        Theme.of(context).colorScheme.outlineVariant,
        Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 9),
      ),
    ),
  );
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.values, this.color, this.min, this.max, this.unit, this.grid, this.label);

  final List<double?> values;
  final Color color, grid;
  final double min, max;
  final String unit;
  final TextStyle label;

  static const slots = 60;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 30.0;
    final w = size.width - left, hgt = size.height;
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 0.5;
    for (var i = 0; i <= 4; i++) {
      final y = hgt - hgt * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), gridPaint);
      final v = min + (max - min) * i / 4;
      final tp = TextPainter(
        text: TextSpan(text: v >= 10 ? v.toStringAsFixed(0) : v.toStringAsFixed(1), style: label),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(left - tp.width - 4, (y - tp.height / 2).clamp(0, hgt - tp.height)));
    }
    if (values.isEmpty) return;
    final dx = w / (slots - 1);
    final start = slots - values.length;
    Offset pt(int i, double v) =>
        Offset(left + (start + i) * dx, hgt - ((v - min) / (max - min)).clamp(0.0, 1.0) * hgt);

    final line = Path(), fill = Path();
    var open = false;
    Offset? first, last;
    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      if (v == null) {
        open = false;
        continue;
      }
      final p = pt(i, v);
      if (!open) {
        line.moveTo(p.dx, p.dy);
        if (first == null) {
          fill.moveTo(p.dx, hgt);
          first = p;
        }
        fill.lineTo(p.dx, p.dy);
        open = true;
      } else {
        line.lineTo(p.dx, p.dy);
        fill.lineTo(p.dx, p.dy);
      }
      last = p;
    }
    if (first == null || last == null) return;
    fill
      ..lineTo(last.dx, hgt)
      ..close();
    canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.15));
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(last, 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_LinePainter old) => true;
}
