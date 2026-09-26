import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

import '../services/device_monitor.dart';
import '../services/gemma_service.dart';
import '../widgets/sparkline.dart';

const _cpuColor = Color(0xFF4FA3FF);
const _gpuColor = Color(0xFF3DDC97);
const _npuColor = Color(0xFFC08BFF);
const _memColor = Color(0xFF3CC8D8);
const _powerColor = Color(0xFFFFC145);
const _heatColor = Color(0xFFFF6B6B);

const _presets = <String, String>{
  'Quick': 'In three sentences, explain why the sky is blue.',
  'Logic': 'A bat and a ball cost \$1.10 in total. The bat costs \$1.00 more than the ball. '
      'How much does the ball cost? Explain your answer.',
  'Math': 'What is 17 × 24 + 356 ÷ 4? Show each step.',
  'Code': 'Write a Dart function that checks whether a string is a palindrome, '
      'ignoring case, spaces and punctuation. Include two example calls.',
  'Long': 'Write a 250-word short story about a robot that learns to paint.',
};

/// Benchmark screen: live CPU / GPU / NPU / memory / power / thermal
/// telemetry alongside Gemma 4 (E2B or E4B) inference on a selectable backend,
/// with thinking on or off.
class BenchScreen extends StatefulWidget {
  const BenchScreen({super.key});

  @override
  State<BenchScreen> createState() => _BenchScreenState();
}

class _BenchScreenState extends State<BenchScreen> {
  final monitor = DeviceMonitor();
  late final gemma = GemmaService(monitor);
  final promptCtrl = TextEditingController(text: _presets['Logic']);

  bool thinking = false;
  double maxOutputTokens = 1536;
  PreferredBackend selectedBackend = PreferredBackend.gpu;
  String? batchLabel;

  @override
  void initState() {
    super.initState();
    monitor.start();
    gemma.checkInstalled();
  }

  @override
  void dispose() {
    gemma.dispose();
    monitor.dispose();
    promptCtrl.dispose();
    super.dispose();
  }

  Future<void> _runOnce() => gemma.run(
        prompt: promptCtrl.text.trim(),
        thinking: thinking,
        maxOutputTokens: maxOutputTokens.round(),
      );

  /// Same prompt, thinking OFF then ON, with a short cool-down between.
  Future<void> _runThinkingAB() async {
    final prompt = promptCtrl.text.trim();
    for (final t in [false, true]) {
      setState(() => batchLabel = 'A/B · thinking ${t ? 'ON' : 'OFF'}');
      final r = await gemma.run(prompt: prompt, thinking: t, maxOutputTokens: maxOutputTokens.round());
      if (r == null || r.stopped || r.error != null) break;
      if (!t) await Future<void>.delayed(const Duration(seconds: 3));
    }
    setState(() => batchLabel = null);
  }

  /// Reloads the model on CPU, GPU and NPU in turn and runs the same prompt.
  Future<void> _runBackendSweep() async {
    final prompt = promptCtrl.text.trim();
    for (final b in PreferredBackend.values) {
      setState(() => batchLabel = 'Sweep · loading ${b.label}');
      await gemma.load(b);
      if (gemma.phase != ModelPhase.ready) break;
      setState(() => batchLabel = 'Sweep · running on ${gemma.activeBackend?.label ?? '?'}');
      final r = await gemma.run(prompt: prompt, thinking: thinking, maxOutputTokens: maxOutputTokens.round());
      if (r == null || r.stopped || r.error != null) break;
      await Future<void>.delayed(const Duration(seconds: 3));
    }
    setState(() {
      batchLabel = null;
      selectedBackend = gemma.requestedBackend;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([monitor, gemma]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Gemma 4 ${gemma.model.id} · On-device Bench'),
            actions: [
              if (gemma.results.isNotEmpty)
                IconButton(
                  tooltip: 'Clear results',
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: gemma.isGenerating ? null : gemma.clearResults,
                ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              children: [
                _DeviceHeader(monitor: monitor, gemma: gemma),
                const SizedBox(height: 12),
                _TelemetryGrid(monitor: monitor, gemma: gemma),
                const SizedBox(height: 16),
                _ModelCard(
                  gemma: gemma,
                  selectedBackend: selectedBackend,
                  onBackendChanged: (b) => setState(() => selectedBackend = b),
                  busy: batchLabel != null,
                ),
                const SizedBox(height: 16),
                _TestCard(
                  gemma: gemma,
                  promptCtrl: promptCtrl,
                  thinking: thinking,
                  onThinking: (v) => setState(() => thinking = v),
                  maxOutputTokens: maxOutputTokens,
                  onMaxOutput: (v) => setState(() => maxOutputTokens = v),
                  batchLabel: batchLabel,
                  onRun: _runOnce,
                  onAB: _runThinkingAB,
                  onSweep: _runBackendSweep,
                ),
                if (gemma.live != null) ...[
                  const SizedBox(height: 16),
                  _LiveOutput(run: gemma.live!, gemma: gemma),
                ],
                if (gemma.results.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _ComparisonTable(results: gemma.results),
                  const SizedBox(height: 12),
                  for (final r in gemma.results) _ResultCard(result: r),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// ───────────────────────────── Device header ─────────────────────────────

class _DeviceHeader extends StatelessWidget {
  const _DeviceHeader({required this.monitor, required this.gemma});
  final DeviceMonitor monitor;
  final GemmaService gemma;

  @override
  Widget build(BuildContext context) {
    final info = monitor.info;
    final t = Theme.of(context).textTheme;
    final hasNpuSensor = monitor.latest?.npuTempC != null || monitor.rails.available;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.memory, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info?.model ?? 'Reading device…', style: t.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    info == null
                        ? ''
                        : '${info.socName}\n${info.cores} cores · ${(info.totalRamMb / 1024).toStringAsFixed(1)} GB RAM · Android ${info.androidRelease} (API ${info.sdkInt})',
                    style: t.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 6, children: [
                    _Chip('CPU', _cpuColor, true),
                    _Chip('Adreno GPU', _gpuColor, monitor.latest?.gpuBusyPercent != null),
                    _Chip('Hexagon NPU', _npuColor, hasNpuSensor && (info?.isQualcomm ?? false)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.color, this.available);
  final String label;
  final Color color;
  final bool available;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: available ? 0.18 : 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: available ? 0.6 : 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(available ? Icons.check_circle : Icons.help_outline, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─────────────────────────────── Telemetry ───────────────────────────────

class _TelemetryGrid extends StatelessWidget {
  const _TelemetryGrid({required this.monitor, required this.gemma});
  final DeviceMonitor monitor;
  final GemmaService gemma;

  static String _f(double? v, [int digits = 0, String unit = '']) =>
      v == null ? '—' : '${v.toStringAsFixed(digits)}$unit';

  static const _thermalNames = ['None', 'Light', 'Moderate', 'Severe', 'Critical', 'Emergency', 'Shutdown'];

  @override
  Widget build(BuildContext context) {
    final h = monitor.history;
    final s = monitor.latest;
    final info = monitor.info;
    final running = gemma.isGenerating;
    final active = gemma.activeBackend;

    double? minOf(double? Function(DeviceSample) f) {
      final v = h.map(f).whereType<double>();
      return v.isEmpty ? null : v.reduce((a, b) => a < b ? a : b);
    }

    final npuIdle = minOf((x) => x.npuTempC);
    final npuDelta = (s?.npuTempC != null && npuIdle != null) ? s!.npuTempC! - npuIdle : null;
    final hasRails = monitor.rails.available;
    final lastRail = monitor.rails.latest;
    final railNote = lastRail == null
        ? 'power rail: first reading in ≤30 s'
        : '30 s window · ${DateTime.now().difference(lastRail.end).inSeconds}s ago';
    final plugged = s?.plugged == true;

    final tiles = <Widget>[
      _MetricTile(
        title: 'CPU · app',
        value: _f(s?.appCpuPercent, 0, '%'),
        sub: 'system ${_f(s?.systemCpuPercent, 0, '%')} · ${_f(s?.cpuTempC, 1, '°C')}',
        detail: 'clock ${_f(s?.avgCoreFreqPercent, 0, '%')} of max${hasRails ? ' · ${_f(s?.cpuPowerW, 2, ' W')}' : ''}',
        color: _cpuColor,
        values: h.map((x) => x.appCpuPercent).toList(),
        min: 0,
        max: 100,
        active: running && active == PreferredBackend.cpu,
        footer: s == null
            ? null
            : s.coreBusyPercent.isNotEmpty
                ? _CoreBars(s.coreBusyPercent)
                : s.coreFreqPercent.isEmpty
                    ? null
                    : _CoreBars(s.coreFreqPercent),
        hint: "Big number: this app's CPU time across all cores (the model's cost). "
            'System: every process, from kernel idle accounting. Bars: busy % per core.',
      ),
      _MetricTile(
        title: 'GPU · Adreno',
        value: _f(s?.gpuBusyPercent, 0, '%'),
        sub: 'busy · ${_f(s?.gpuTempC, 1, '°C')}',
        detail: hasRails ? 'rail ${_f(s?.gpuPowerW, 2, ' W')}' : null,
        color: _gpuColor,
        values: h.map((x) => x.gpuBusyPercent).toList(),
        min: 0,
        max: 100,
        active: running && active == PreferredBackend.gpu,
        hint: 'Adreno driver busy time over its last ~1 s window (kgsl gpubusy).',
      ),
      hasRails
          ? _MetricTile(
              title: 'NPU · Hexagon',
              value: s?.npuLoadPercent == null ? '—' : '~${s!.npuLoadPercent!.toStringAsFixed(0)}%',
              sub: 'NSP ${_f(s?.npuPowerW, 2, ' W')} · ${_f(s?.npuTempC, 1, '°C')}',
              detail: railNote,
              color: _npuColor,
              values: h.map((x) => x.npuLoadPercent).toList(),
              min: 0,
              max: 100,
              active: running && active == PreferredBackend.npu,
              hint: 'Android gives apps no NPU utilisation counter. Load is estimated from the measured '
                  'NSP power rail as a share of its peak (at least '
                  '${PowerRails.npuReferenceFloorW.toStringAsFixed(0)} W). '
                  'The OS refreshes rail energy about every 30 s.',
            )
          : _MetricTile(
              title: 'NPU · Hexagon',
              value: _f(s?.npuTempC, 1, '°C'),
              sub: npuDelta == null ? 'no NSP sensor' : 'Δ ${npuDelta >= 0 ? '+' : ''}${npuDelta.toStringAsFixed(1)}°C vs idle',
              color: _npuColor,
              values: h.map((x) => x.npuTempC).toList(),
              active: running && active == PreferredBackend.npu,
              hint: 'No power rails on this device, and Android exposes no NPU load counter; NSP heat is the signal.',
            ),
      _MetricTile(
        title: 'Memory · app',
        value: s?.appRamMb == null ? '—' : '${(s!.appRamMb! / 1024).toStringAsFixed(2)} GB',
        sub: 'free ${s?.availRamMb == null ? '—' : (s!.availRamMb! / 1024).toStringAsFixed(1)} of ${info == null ? '—' : (info.totalRamMb / 1024).toStringAsFixed(1)} GB',
        detail: s?.appGraphicsMb == null ? null : 'GPU buffers ${s!.appGraphicsMb!.toStringAsFixed(0)} MB',
        color: _memColor,
        values: h.map((x) => x.appRamMb).toList(),
        min: 0,
        hint: 'Proportional set size (shared pages split fairly) including GPU buffers.',
      ),
      _MetricTile(
        title: plugged ? 'Power · SoC' : 'Power · device',
        value: _f(plugged ? s?.socPowerW : s?.powerWatts, 2, ' W'),
        sub: plugged
            ? (hasRails ? 'plugged in · CPU+GPU+NPU rails' : 'plugged in — unplug for real draw')
            : 'battery ${s?.batteryPercent ?? '—'}% · ${_f(s?.batteryTempC, 1, '°C')}',
        detail: !plugged && hasRails ? 'SoC rails ${_f(s?.socPowerW, 2, ' W')}' : null,
        color: _powerColor,
        values: h.map((x) => plugged ? x.socPowerW : x.powerWatts).toList(),
        min: 0,
        hint: 'Unplugged: whole-phone draw from battery current × voltage. '
            'Plugged in, battery current shows charging, so the measured SoC rails are shown instead.',
      ),
      _MetricTile(
        title: 'Thermal',
        value: s?.thermalStatus == null ? '—' : _thermalNames[s!.thermalStatus!.clamp(0, 6)],
        sub: 'headroom ${_f(s?.thermalHeadroom, 2)} · SoC ${_f(s?.cpuTempC, 1, '°C')}',
        color: _heatColor,
        values: h.map((x) => x.cpuTempC).toList(),
      ),
    ];

    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth > 700 ? 3 : 2;
      const gap = 10.0;
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final t in tiles) SizedBox(width: w, child: t)],
      );
    });
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.sub,
    required this.color,
    required this.values,
    this.min,
    this.max,
    this.active = false,
    this.footer,
    this.hint,
    this.detail,
  });

  final String title;
  final String value;
  final String sub;
  final Color color;
  final List<double?> values;
  final double? min;
  final double? max;
  final bool active;
  final Widget? footer;
  final String? hint;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: active ? color : Colors.transparent, width: 1.5),
        boxShadow: active ? [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 12)] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Expanded(child: Text(title, style: t.labelMedium, overflow: TextOverflow.ellipsis)),
            if (active)
              Text('ACTIVE', style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w800)),
            if (hint != null)
              Tooltip(
                message: hint!,
                triggerMode: TooltipTriggerMode.tap,
                child: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.info_outline, size: 14),
                ),
              ),
          ]),
          const SizedBox(height: 6),
          Text(value, style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: color)),
          Text(sub, style: t.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (detail != null)
            Text(detail!,
                style: t.labelSmall?.copyWith(color: t.bodySmall?.color?.withValues(alpha: 0.7)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Sparkline(values: values, color: color, min: min, max: max),
          if (footer != null) ...[const SizedBox(height: 6), footer!],
        ],
      ),
    );
    return tile;
  }
}

class _CoreBars extends StatelessWidget {
  const _CoreBars(this.percents);
  final List<double> percents;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final p in percents)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: FractionallySizedBox(
                  heightFactor: (p / 100).clamp(0.06, 1.0),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _cpuColor.withValues(alpha: 0.4 + 0.6 * p / 100),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Model card ──────────────────────────────

class _ModelCard extends StatelessWidget {
  const _ModelCard({
    required this.gemma,
    required this.selectedBackend,
    required this.onBackendChanged,
    required this.busy,
  });

  final GemmaService gemma;
  final PreferredBackend selectedBackend;
  final ValueChanged<PreferredBackend> onBackendChanged;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final phase = gemma.phase;
    final canPickBackend =
        (phase == ModelPhase.installed || phase == ModelPhase.ready) && !gemma.isGenerating && !busy;
    final model = gemma.model;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Model', style: t.labelLarge),
            const SizedBox(height: 6),
            SegmentedButton<GemmaModelSpec>(
              showSelectedIcon: false,
              segments: [
                for (final m in GemmaModelSpec.all)
                  ButtonSegment(
                    value: m,
                    label: Text('${m.id} · ${m.sizeGb} GB'),
                    icon: Icon(gemma.installedModels.contains(m) ? Icons.download_done : Icons.cloud_download_outlined),
                  ),
              ],
              selected: {model},
              onSelectionChanged: gemma.canSwitchModel && !busy ? (s) => gemma.selectModel(s.first) : null,
            ),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.auto_awesome),
              const SizedBox(width: 8),
              Expanded(child: Text(model.name, style: t.titleMedium)),
              Text('${model.sizeGb} GB · .litertlm', style: t.bodySmall),
            ]),
            const SizedBox(height: 4),
            Text(
              'flutter_gemma + flutter_gemma_litertlm (LiteRT-LM) · context ${GemmaModelSpec.contextTokens} tokens',
              style: t.bodySmall,
            ),
            const SizedBox(height: 12),
            ..._body(context),
            if (phase == ModelPhase.installed || phase == ModelPhase.ready || phase == ModelPhase.loading) ...[
              const SizedBox(height: 12),
              Text('Backend', style: t.labelLarge),
              const SizedBox(height: 6),
              SegmentedButton<PreferredBackend>(
                segments: const [
                  ButtonSegment(value: PreferredBackend.cpu, label: Text('CPU'), icon: Icon(Icons.developer_board)),
                  ButtonSegment(value: PreferredBackend.gpu, label: Text('GPU'), icon: Icon(Icons.grid_view)),
                  ButtonSegment(value: PreferredBackend.npu, label: Text('NPU'), icon: Icon(Icons.bolt)),
                ],
                selected: {selectedBackend},
                onSelectionChanged: canPickBackend ? (s) => onBackendChanged(s.first) : null,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text('Speculative decoding'),
                subtitle: const Text('Draft-and-verify decode (CPU/GPU). Applied on next load.'),
                value: gemma.speculativeDecoding,
                onChanged: canPickBackend ? gemma.setSpeculativeDecoding : null,
              ),
              Row(children: [
                FilledButton.icon(
                  onPressed: canPickBackend ? () => gemma.load(selectedBackend) : null,
                  icon: Icon(phase == ModelPhase.ready ? Icons.refresh : Icons.play_arrow),
                  label: Text(phase == ModelPhase.ready ? 'Reload on ${selectedBackend.label}' : 'Load on ${selectedBackend.label}'),
                ),
                const SizedBox(width: 8),
                if (phase == ModelPhase.ready)
                  OutlinedButton(onPressed: canPickBackend ? gemma.unload : null, child: const Text('Unload')),
                const Spacer(),
                if (phase == ModelPhase.installed || phase == ModelPhase.ready)
                  IconButton(
                    tooltip: 'Delete model file',
                    onPressed: canPickBackend ? () => _confirmDelete(context) : null,
                    icon: const Icon(Icons.delete_outline),
                  ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context) {
    final t = Theme.of(context).textTheme;
    switch (gemma.phase) {
      case ModelPhase.checking:
        return [const LinearProgressIndicator()];
      case ModelPhase.notInstalled:
        return [
          Text('Model not on device yet. Downloads once from Hugging Face (no token needed). '
              'Stay on this screen while it downloads.'),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: gemma.download,
            icon: const Icon(Icons.download),
            label: Text('Download ${gemma.model.sizeGb} GB'),
          ),
        ];
      case ModelPhase.downloading:
        return [
          Row(children: [
            Expanded(child: LinearProgressIndicator(value: gemma.downloadPercent / 100)),
            const SizedBox(width: 12),
            Text('${gemma.downloadPercent}%'),
          ]),
          const SizedBox(height: 4),
          Text(
            '${(gemma.model.sizeGb * gemma.downloadPercent / 100).toStringAsFixed(2)} / ${gemma.model.sizeGb} GB',
            style: t.bodySmall,
          ),
          TextButton(onPressed: gemma.cancelDownload, child: const Text('Cancel')),
        ];
      case ModelPhase.installed:
        return [const _StatusLine(icon: Icons.check_circle_outline, text: 'Installed · not loaded')];
      case ModelPhase.loading:
        return [
          _StatusLine(
            icon: Icons.hourglass_top,
            text: 'Loading on ${gemma.requestedBackend.label}… (first GPU/NPU load compiles kernels, can take a while)',
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
        ];
      case ModelPhase.ready:
        final active = gemma.activeBackend;
        return [
          Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
            _Pill('Requested', gemma.requestedBackend.label, Colors.blueGrey),
            _Pill('Running on', active?.label ?? 'unknown', _backendColor(active)),
            if (gemma.loadMs != null) _Pill('Load', '${(gemma.loadMs! / 1000).toStringAsFixed(1)} s', Colors.blueGrey),
            if (gemma.speculativeDecoding) _Pill('Spec. decode', 'on', Colors.blueGrey),
          ]),
          if (gemma.fellBack) ...[
            const SizedBox(height: 10),
            _FallbackNote(requested: gemma.requestedBackend, active: active!),
          ],
        ];
      case ModelPhase.error:
        return [
          Text(gemma.error ?? 'Unknown error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: gemma.checkInstalled, child: const Text('Retry')),
        ];
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete model?'),
        content: Text('Removes ${gemma.model.fileName} (${gemma.model.sizeGb} GB). You will need to download it again.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) await gemma.deleteModel();
  }
}

Color _backendColor(PreferredBackend? b) => switch (b) {
      PreferredBackend.cpu => _cpuColor,
      PreferredBackend.gpu => _gpuColor,
      PreferredBackend.npu => _npuColor,
      null => Colors.grey,
    };

class _FallbackNote extends StatelessWidget {
  const _FallbackNote({required this.requested, required this.active});
  final PreferredBackend requested;
  final PreferredBackend active;

  @override
  Widget build(BuildContext context) {
    final npu = requested == PreferredBackend.npu;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _powerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _powerColor.withValues(alpha: 0.4)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.warning_amber_rounded, color: _powerColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            npu
                ? 'LiteRT-LM fell back NPU → ${active.label}. The NPU needs a .litertlm compiled for this '
                    'exact Snapdragon; the Gemma 4 E4B repo only ships the generic CPU/GPU build, so '
                    'the Hexagon NPU cannot run it. Results below are ${active.label} numbers.'
                : 'LiteRT-LM fell back ${requested.label} → ${active.label}.',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ]),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) =>
      Row(children: [Icon(icon, size: 18), const SizedBox(width: 8), Expanded(child: Text(text))]);
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, this.value, this.color);
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: '$label  ', style: const TextStyle(fontSize: 11)),
        TextSpan(text: value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ])),
    );
  }
}

// ─────────────────────────────── Test card ───────────────────────────────

class _TestCard extends StatelessWidget {
  const _TestCard({
    required this.gemma,
    required this.promptCtrl,
    required this.thinking,
    required this.onThinking,
    required this.maxOutputTokens,
    required this.onMaxOutput,
    required this.batchLabel,
    required this.onRun,
    required this.onAB,
    required this.onSweep,
  });

  final GemmaService gemma;
  final TextEditingController promptCtrl;
  final bool thinking;
  final ValueChanged<bool> onThinking;
  final double maxOutputTokens;
  final ValueChanged<double> onMaxOutput;
  final String? batchLabel;
  final VoidCallback onRun;
  final VoidCallback onAB;
  final VoidCallback onSweep;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final ready = gemma.phase == ModelPhase.ready;
    final idle = ready && !gemma.isGenerating && batchLabel == null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Test', style: t.titleMedium),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final e in _presets.entries)
                ActionChip(
                  label: Text(e.key),
                  onPressed: gemma.isGenerating ? null : () => promptCtrl.text = e.value,
                ),
            ]),
            const SizedBox(height: 10),
            TextField(
              controller: promptCtrl,
              minLines: 2,
              maxLines: 5,
              enabled: !gemma.isGenerating,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Prompt'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Thinking mode'),
              subtitle: Text(thinking
                  ? 'Gemma 4 reasons first (streamed separately), then answers'
                  : 'Direct answer, no reasoning phase'),
              value: thinking,
              onChanged: gemma.isGenerating ? null : onThinking,
            ),
            Row(children: [
              Text('Max output', style: t.bodyMedium),
              Expanded(
                child: Slider(
                  value: maxOutputTokens,
                  min: 256,
                  max: 3072,
                  divisions: 22,
                  label: '${maxOutputTokens.round()}',
                  onChanged: gemma.isGenerating ? null : onMaxOutput,
                ),
              ),
              SizedBox(width: 48, child: Text('${maxOutputTokens.round()}', textAlign: TextAlign.end)),
            ]),
            const SizedBox(height: 4),
            if (!ready)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Load the model above to run tests.', style: t.bodySmall),
              ),
            if (batchLabel != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(batchLabel!, style: t.labelLarge?.copyWith(color: _npuColor)),
              ),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (gemma.isGenerating)
                FilledButton.tonalIcon(
                  onPressed: gemma.stop,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                )
              else
                FilledButton.icon(
                  onPressed: idle ? onRun : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Run'),
                ),
              OutlinedButton.icon(
                onPressed: idle ? onAB : null,
                icon: const Icon(Icons.compare_arrows),
                label: const Text('Thinking OFF vs ON'),
              ),
              OutlinedButton.icon(
                onPressed: idle ? onSweep : null,
                icon: const Icon(Icons.speed),
                label: const Text('Sweep CPU / GPU / NPU'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────── Live output ─────────────────────────────

class _LiveOutput extends StatefulWidget {
  const _LiveOutput({required this.run, required this.gemma});
  final LiveRun run;
  final GemmaService gemma;

  @override
  State<_LiveOutput> createState() => _LiveOutputState();
}

class _LiveOutputState extends State<_LiveOutput> {
  late final Timer _tick;

  @override
  void initState() {
    super.initState();
    // Keep the elapsed clock moving during prefill, before any token arrives.
    _tick = Timer.periodic(const Duration(milliseconds: 100), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final run = widget.run;
    final t = Theme.of(context).textTheme;
    final elapsed = run.stopwatch.elapsedMilliseconds / 1000;
    final phase = run.firstTokenMs == null
        ? 'Prefill…'
        : run.inThinkingPhase
            ? 'Thinking…'
            : 'Answering…';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 10),
              Text(phase, style: t.titleSmall),
              const Spacer(),
              Text('${elapsed.toStringAsFixed(1)} s · ${run.chunks} chunks', style: t.bodySmall),
            ]),
            if (run.firstTokenMs != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('first token ${run.firstTokenMs} ms', style: t.bodySmall),
              ),
            if (run.thinking) ...[
              const SizedBox(height: 10),
              _ThinkingBox(text: run.thinkingText.toString(), initiallyOpen: true),
            ],
            const SizedBox(height: 10),
            SelectableText(run.answer.isEmpty ? '…' : run.answer.toString()),
          ],
        ),
      ),
    );
  }
}

class _ThinkingBox extends StatelessWidget {
  const _ThinkingBox({required this.text, this.initiallyOpen = false});
  final String text;
  final bool initiallyOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _npuColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _npuColor.withValues(alpha: 0.3)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyOpen,
          dense: true,
          leading: const Icon(Icons.psychology_alt_outlined, color: _npuColor),
          title: Text('Thinking (${text.length} chars)', style: const TextStyle(fontSize: 13)),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: SingleChildScrollView(
                reverse: initiallyOpen,
                child: SelectableText(
                  text.isEmpty ? '…' : text,
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey.shade400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────── Results ─────────────────────────────────

String _ms(int? ms) => ms == null ? '—' : (ms >= 1000 ? '${(ms / 1000).toStringAsFixed(2)} s' : '$ms ms');
String _n(double? v, [int d = 1, String u = '']) => v == null ? '—' : '${v.toStringAsFixed(d)}$u';

/// Rail numbers arrive with the next power-monitor snapshot after a run, so
/// show "…" while they are on their way rather than a misleading dash.
String _rail(UsageWindow u, double? v, int d, String unit, [String prefix = '']) =>
    v != null ? '$prefix${v.toStringAsFixed(d)}$unit' : (u.railsPending ? '…' : '—');

/// Whole-phone energy from the battery when unplugged, else SoC rail energy.
String _energy(BenchResult r) {
  final battery = r.usage.avgPower, soc = r.usage.socPowerW;
  if (battery != null) return '${(battery * r.totalMs / 1000).toStringAsFixed(0)} J';
  if (soc != null) return '${(soc * r.totalMs / 1000).toStringAsFixed(0)} J SoC';
  return r.usage.railsPending ? '…' : '—';
}

String _backendText(BenchResult r) => r.activeBackend == null
    ? '${r.requestedBackend.label}→?'
    : r.activeBackend == r.requestedBackend
        ? r.activeBackend!.label
        : '${r.requestedBackend.label}→${r.activeBackend!.label}';

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.results});
  final List<BenchResult> results;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    DataCell c(String s) => DataCell(Text(s, style: const TextStyle(fontSize: 12)));
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Comparison', style: t.titleMedium),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                headingRowHeight: 36,
                dataRowMinHeight: 32,
                dataRowMaxHeight: 36,
                headingTextStyle: t.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('Model')),
                  DataColumn(label: Text('Backend')),
                  DataColumn(label: Text('Think')),
                  DataColumn(label: Text('TTFT'), numeric: true),
                  DataColumn(label: Text('Think time'), numeric: true),
                  DataColumn(label: Text('Total'), numeric: true),
                  DataColumn(label: Text('Prefill t/s'), numeric: true),
                  DataColumn(label: Text('Decode t/s'), numeric: true),
                  DataColumn(label: Text('Out tok'), numeric: true),
                  DataColumn(label: Text('CPU app'), numeric: true),
                  DataColumn(label: Text('CPU sys'), numeric: true),
                  DataColumn(label: Text('GPU avg'), numeric: true),
                  DataColumn(label: Text('NPU load'), numeric: true),
                  DataColumn(label: Text('NPU W'), numeric: true),
                  DataColumn(label: Text('SoC W'), numeric: true),
                  DataColumn(label: Text('Power avg'), numeric: true),
                  DataColumn(label: Text('Energy'), numeric: true),
                ],
                rows: [
                  for (final r in results)
                    DataRow(cells: [
                      c('${r.index}'),
                      c(r.model.id),
                      DataCell(Text(_backendText(r),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _backendColor(r.activeBackend)))),
                      c(r.thinking ? 'ON' : 'off'),
                      c(_ms(r.metrics?.timeToFirstTokenMs?.round() ?? r.firstTokenMs)),
                      c(_ms(r.thinkingMs)),
                      c(_ms(r.totalMs)),
                      c(_n(r.prefillTokPerSec, 0)),
                      c(_n(r.decodeTokPerSec)),
                      c(r.outputTokens?.toString() ?? '—'),
                      c(_n(r.usage.avgCpu, 0, '%')),
                      c(_n(r.usage.avgSystemCpu, 0, '%')),
                      c(_n(r.usage.avgGpu, 0, '%')),
                      c(_rail(r.usage, r.usage.npuLoadPercent, 0, '%', '~')),
                      c(_rail(r.usage, r.usage.npuPowerW, 2, ' W')),
                      c(_rail(r.usage, r.usage.socPowerW, 2, ' W')),
                      c(_n(r.usage.avgPower, 2, ' W')),
                      c(_energy(r)),
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});
  final BenchResult result;

  @override
  Widget build(BuildContext context) {
    final r = result;
    final t = Theme.of(context).textTheme;
    final color = _backendColor(r.activeBackend);
    final stats = <(String, String)>[
      ('Time to first token', _ms(r.metrics?.timeToFirstTokenMs?.round() ?? r.firstTokenMs)),
      if (r.thinking) ('Thinking time', _ms(r.thinkingMs)),
      ('Total time', _ms(r.totalMs)),
      ('Prefill speed', _n(r.prefillTokPerSec, 0, ' tok/s')),
      ('Decode speed', _n(r.decodeTokPerSec, 1, ' tok/s')),
      ('Tokens in / out', '${r.inputTokens ?? '—'} / ${r.outputTokens ?? '—'}'),
      ('CPU app avg / peak', '${_n(r.usage.avgCpu, 0, '%')} / ${_n(r.usage.peakCpu, 0, '%')}'),
      ('CPU system avg', _n(r.usage.avgSystemCpu, 0, '%')),
      ('GPU avg / peak', '${_n(r.usage.avgGpu, 0, '%')} / ${_n(r.usage.peakGpu, 0, '%')}'),
      ('NPU load (est.)', _rail(r.usage, r.usage.npuLoadPercent, 0, '%', '~')),
      ('Rail W CPU / GPU / NPU',
          '${_rail(r.usage, r.usage.cpuPowerW, 2, '')} / ${_rail(r.usage, r.usage.gpuPowerW, 2, '')} / ${_rail(r.usage, r.usage.npuPowerW, 2, '')}'),
      ('Energy', _energy(r)),
      ('Peak temp CPU / GPU / NPU',
          '${_n(r.usage.peakCpuTemp, 0, '°')} / ${_n(r.usage.peakGpuTemp, 0, '°')} / ${_n(r.usage.peakNpuTemp, 0, '°')}'),
      ('Power avg / peak', '${_n(r.usage.avgPower, 2, ' W')} / ${_n(r.usage.peakPower, 2, ' W')}'),
      ('Peak app RAM', r.usage.peakRam == null ? '—' : '${(r.usage.peakRam! / 1024).toStringAsFixed(2)} GB'),
      if (r.usage.peakGraphicsRam != null) ('Peak GPU buffers', '${r.usage.peakGraphicsRam!.toStringAsFixed(0)} MB'),
    ];

    return Card(
      child: ExpansionTile(
        shape: const Border(),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text('${r.index}', style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        ),
        title: Text('${r.model.id} · ${_backendText(r)} · thinking ${r.thinking ? 'ON' : 'OFF'}${r.speculative ? ' · spec' : ''}'),
        subtitle: Text(
          r.error != null
              ? 'Error'
              : '${_n(r.decodeTokPerSec)} tok/s · ${_ms(r.totalMs)}${r.stopped ? ' · stopped' : ''}',
          style: t.bodySmall,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (r.error != null)
            Text(r.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          Text(r.prompt, style: t.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          for (final (k, v) in stats)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                Expanded(child: Text(k, style: t.bodySmall)),
                Text(v, style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ]),
            ),
          if (r.thinking) ...[
            const SizedBox(height: 10),
            _ThinkingBox(text: r.thinkingText),
          ],
          const SizedBox(height: 10),
          SelectableText(r.answer.isEmpty ? '(empty answer)' : r.answer),
        ],
      ),
    );
  }
}
