import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bench/bench_runner.dart';
import 'memory_controller.dart';
import 'widgets.dart';

class BenchScreen extends StatefulWidget {
  const BenchScreen({super.key, required this.c});

  final MemoryController c;

  @override
  State<BenchScreen> createState() => _BenchScreenState();
}

class _BenchScreenState extends State<BenchScreen> with AutomaticKeepAliveClientMixin {
  final _lines = <String>[];
  final _scroll = ScrollController();
  var _loadN = 1000;
  BenchRunner? _running;

  @override
  bool get wantKeepAlive => true;

  void _log(String line) {
    debugPrint('[GURTU] $line');
    if (!mounted) return;
    setState(() => _lines.addAll(line.split('\n')));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  Future<void> _run(Future<void> Function(BenchRunner r) body) async {
    setState(_lines.clear);
    try {
      await widget.c.ensureMemory();
    } catch (e) {
      _log('Model not ready: $e');
      return;
    }
    final r = BenchRunner(embedder: widget.c.embedder!, outDir: widget.c.benchDir, log: _log);
    setState(() => _running = r);
    try {
      await body(r);
    } finally {
      if (mounted) setState(() => _running = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final busy = _running != null;
    final ready = widget.c.isInstalled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: busy || !ready ? null : () => _run((r) => r.runAll(loadTestMoments: _loadN)),
                icon: const Icon(Icons.speed),
                label: const Text('Run benchmark'),
              ),
              OutlinedButton.icon(
                onPressed: busy || !ready ? null : () => _run((r) => r.sustained()),
                icon: const Icon(Icons.local_fire_department_outlined),
                label: const Text('Sustained 60 s'),
              ),
              DropdownButton<int>(
                value: _loadN,
                items: [
                  for (final n in [250, 1000, 5000, 20000])
                    DropdownMenuItem(value: n, child: Text('load test $n')),
                ],
                onChanged: busy ? null : (v) => setState(() => _loadN = v!),
              ),
              if (busy)
                TextButton.icon(
                  onPressed: () => _running?.cancel(),
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
              IconButton(
                tooltip: 'Copy log',
                onPressed: _lines.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: _lines.join('\n')));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Log copied')));
                      },
                icon: const Icon(Icons.copy_all),
              ),
            ],
          ),
        ),
        if (busy) const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            child: _lines.isEmpty
                ? Center(
                    child: Text(ready
                        ? 'Runs latency, throughput, retrieval quality on the mock\n'
                            'record, a bulk-ingest load test and search scaling.'
                        : 'Download the model on the Memory tab first.',
                        textAlign: TextAlign.center),
                  )
                : SelectionArea(
                    child: ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.all(12),
                      itemCount: _lines.length,
                      itemBuilder: (_, i) => Text(_lines[i], style: monoStyle(context)),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
