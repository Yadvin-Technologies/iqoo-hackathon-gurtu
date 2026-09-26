import 'package:flutter/material.dart';

import '../bench/bench_corpus.dart';
import '../memory/memory.dart';
import '../mock/mock_care_data.dart';
import 'memory_controller.dart';
import 'widgets.dart';

/// Ask the care memory directly: shows what the Gemma 4 layer will receive.
class AskScreen extends StatefulWidget {
  const AskScreen({super.key, required this.c});

  final MemoryController c;

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> with AutomaticKeepAliveClientMixin {
  final _query = TextEditingController();
  final _english = TextEditingController();
  List<Evidence>? _results;
  String? _status;
  var _busy = false;

  static final _examples = [
    for (final id in ['q1', 'q2', 'q11', 'q14', 'q18', 'q21', 'u2'])
      evalQueries.firstWhere((q) => q.id == id),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _query.dispose();
    _english.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    final q = _query.text.trim();
    if (q.isEmpty) return;
    final en = _english.text.trim();
    setState(() {
      _busy = true;
      _status = 'Searching…';
    });
    try {
      final m = await widget.c.ensureMemory();
      if (m.store.chunkCount == 0) {
        setState(() => _status = 'Memory is empty. Store the mock data on the Memory tab.');
        return;
      }
      final sw = Stopwatch()..start();
      final r = await m.retrieve(
        q,
        englishQuestion: en.isEmpty ? null : en,
        filter: SearchFilter(patientId: mockPatient.id),
      );
      sw.stop();
      setState(() {
        _results = r;
        _status = r.isEmpty
            ? 'No evidence: the assistant must say it has no source for this.'
            : '${r.length} sources in ${sw.elapsedMilliseconds} ms '
                '(embed question + search ${m.store.chunkCount} chunks)';
      });
    } catch (e) {
      setState(() => _status = 'Error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final t = Theme.of(context).textTheme;
    final results = _results;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        TextField(
          controller: _query,
          minLines: 1,
          maxLines: 3,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _ask(),
          decoration: const InputDecoration(
            labelText: 'Question (any language)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _english,
          minLines: 1,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'English rendering (Gemma 4 will fill this; optional for English)',
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _busy ? null : _ask,
          icon: const Icon(Icons.search),
          label: const Text('Search memory'),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final ex in _examples)
              ActionChip(
                label: Text(ex.text, style: t.labelSmall),
                onPressed: _busy
                    ? null
                    : () {
                        _query.text = ex.text;
                        _english.text = ex.english ?? '';
                        _ask();
                      },
              ),
          ],
        ),
        if (_busy) const Padding(
          padding: EdgeInsets.only(top: 12),
          child: LinearProgressIndicator(minHeight: 2),
        ),
        if (_status != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(_status!, style: t.bodySmall),
          ),
        if (results != null)
          for (final (i, e) in results.indexed) _EvidenceCard(index: i + 1, e: e),
        if (results != null && results.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Context block handed to Gemma 4', style: t.titleSmall),
          const SizedBox(height: 4),
          CodeBlock(CareMemory.formatForPrompt(results)),
        ],
      ],
    );
  }
}

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({required this.index, required this.e});

  final int index;
  final Evidence e;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final translated = e.originalText != e.text && !e.originalText.contains(e.text);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(sourceIcon(e.sourceType), size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '[S$index] ${sourceLabel(e.sourceType)} · ${formatTime(e.createdAt)}'
                    '${e.author == null ? '' : ' · ${e.author}'}'
                    '${e.verified ? ' · verified' : ''}',
                    style: t.labelMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(translated ? e.originalText : e.text),
            if (translated)
              Text('↳ ${e.text}', style: t.bodySmall!.copyWith(color: muted, fontStyle: FontStyle.italic)),
            const SizedBox(height: 4),
            Text(
              'cosine ${e.vectorScore.toStringAsFixed(3)}'
              '${e.keywordRank == null ? '' : ' · keyword #${e.keywordRank}'}'
              '${e.startMs == null ? '' : ' · clip ${e.startMs! ~/ 1000}–${(e.endMs ?? e.startMs!) ~/ 1000} s'}'
              '${e.sourceUri == null ? '' : ' · ${e.sourceUri}'}',
              style: t.labelSmall!.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}
