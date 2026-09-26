import 'package:flutter/material.dart';

import '../memory/memory.dart';
import '../mock/mock_care_data.dart';
import 'memory_controller.dart';
import 'moment_storage_screen.dart';
import 'widgets.dart';

/// Model setup + the mock care record, with each moment's storage state.
class MemoryScreen extends StatelessWidget {
  const MemoryScreen({super.key, required this.c});

  final MemoryController c;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: c,
    builder: (context, _) {
      final stored = c.storedIds();
      return ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _ModelCard(c: c),
          const _PatientCard(),
          Section(
            title: 'Care Moments (mock data)',
            subtitle:
                '${mockMoments.length} moments · ${stored.length} stored in memory. '
                'Tap one to see exactly how it is stored.',
            trailing: stored.isEmpty ? null : TextButton(
              onPressed: c.clearMemory,
              child: const Text('Clear'),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: c.isInstalled && c.status != ModelStatus.loading
                      ? () => _store(context)
                      : null,
                  icon: const Icon(Icons.save_alt),
                  label: Text(stored.isEmpty ? 'Embed & store all in memory' : 'Re-embed & store all'),
                ),
                const SizedBox(height: 4),
                for (final m in mockMoments)
                  _MomentTile(
                    m: m,
                    stored: stored.contains(m.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MomentStorageScreen(c: c, moment: m),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    },
  );

  Future<void> _store(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final took = await c.storeMockData();
      messenger.showSnackBar(SnackBar(
        content: Text('${mockMoments.length} moments embedded and stored in '
            '${took.inMilliseconds} ms'),
      ));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

class _ModelCard extends StatelessWidget {
  const _ModelCard({required this.c});

  final MemoryController c;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final e = c.embedder;
    final (label, color) = switch (c.status) {
      ModelStatus.notDownloaded => ('Not downloaded', Colors.grey),
      ModelStatus.downloading => ('Downloading', Colors.blue),
      ModelStatus.downloaded => ('Downloaded', Colors.teal),
      ModelStatus.loading => ('Loading', Colors.orange),
      ModelStatus.ready => ('Ready', Colors.green),
      ModelStatus.failed => ('Failed', Colors.red),
    };
    return Section(
      title: 'nomic-embed-text-v1 · LiteRT',
      subtitle: 'INT8 LiteRT model run by flutter_gemma_litertlm on the phone CPU '
          '(XNNPACK/KleidiAI). Installed on the phone by FlutterGemma.installEmbedder() '
          'from huggingface.co/${NomicModel.modelRepo} + tokenizer from '
          '${NomicModel.tokenizerRepo}.',
      trailing: Chip(
        label: Text(label, style: t.labelSmall!.copyWith(color: Colors.white)),
        backgroundColor: color,
        visualDensity: VisualDensity.compact,
        side: BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (c.status == ModelStatus.downloading) ...[
            LinearProgressIndicator(value: c.progress / 100),
            const SizedBox(height: 4),
            Text('${c.progress}% of ~${formatBytes(NomicModel.approxBytes)}', style: t.bodySmall),
          ],
          if (c.status == ModelStatus.loading) const LinearProgressIndicator(),
          if (e != null)
            KeyValues([
              ('Load time', '${e.loadTime.inMilliseconds} ms'),
              ('Input window', '${e.sequenceLength} tokens'),
              ('Output', '${e.dimension} dims → stored as ${c.config.dims} × int8'),
              ('Prefixes', '"${NomicEmbedder.documentPrefix}" / "${NomicEmbedder.queryPrefix}"'),
              ('Model file', formatBytes(e.paths.modelBytes)),
            ]),
          if (c.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(c.error!, style: t.bodySmall!.copyWith(color: Colors.red)),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (c.status == ModelStatus.notDownloaded)
                FilledButton.icon(
                  onPressed: c.download,
                  icon: const Icon(Icons.download),
                  label: Text('Download (~${formatBytes(NomicModel.approxBytes)})'),
                ),
              if (c.status == ModelStatus.downloading)
                OutlinedButton.icon(
                  onPressed: c.cancelDownload,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                ),
              if (c.status == ModelStatus.downloaded || c.status == ModelStatus.failed)
                FilledButton.icon(
                  onPressed: () => c.ensureMemory().ignore(),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Load model'),
                ),
              if (c.isInstalled && c.status != ModelStatus.loading)
                TextButton.icon(
                  onPressed: c.deleteModel,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete model'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Section(
      title: '${mockPatient.name} · ${mockPatient.age}',
      subtitle: '${mockPatient.conditions.join(' · ')}\n'
          '${mockPatient.doctor}, ${mockPatient.hospital}',
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final m in mockCircle)
            Chip(
              avatar: CircleAvatar(child: Text(m.name[0])),
              label: Text('${m.name} · ${m.relation}', style: t.labelSmall),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class _MomentTile extends StatelessWidget {
  const _MomentTile({required this.m, required this.stored, required this.onTap});

  final CareMoment m;
  final bool stored;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(sourceIcon(m.sourceType), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${sourceLabel(m.sourceType)} · ${formatTime(m.createdAt)}'
                    '${m.author == null ? '' : ' · ${m.author}'}'
                    '${m.language == null ? '' : ' · ${m.language}'}',
                    style: t.labelSmall!.copyWith(color: muted),
                  ),
                  const SizedBox(height: 2),
                  Text(m.text, style: t.bodyMedium),
                  if (m.translation != null)
                    Text(
                      '↳ ${m.translation}',
                      style: t.bodySmall!.copyWith(color: muted, fontStyle: FontStyle.italic),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              stored ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18,
              color: stored ? Colors.green : muted,
            ),
          ],
        ),
      ),
    );
  }
}
