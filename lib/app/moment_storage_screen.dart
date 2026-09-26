import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../memory/memory.dart';
import 'memory_controller.dart';
import 'widgets.dart';

/// One chunk followed through the pipeline.
class _Trace {
  _Trace(this.chunk, this.input, this.vector, this.q, this.scale);

  final Chunk chunk;
  final String input;
  final Float32List vector; // model output: pooled + L2-normalized, 768
  final Int8List q; // what is stored
  final double scale;
}

/// "How is this moment stored?" — every transformation from the captured
/// words to the bytes in SQLite, for one Care Moment.
class MomentStorageScreen extends StatefulWidget {
  const MomentStorageScreen({super.key, required this.c, required this.moment});

  final MemoryController c;
  final CareMoment moment;

  @override
  State<MomentStorageScreen> createState() => _MomentStorageScreenState();
}

class _MomentStorageScreenState extends State<MomentStorageScreen> {
  List<_Trace>? _traces;
  Duration? _embedTime;
  String? _error;
  var _busy = false;

  CareMoment get m => widget.moment;
  MemoryController get c => widget.c;

  late final _chunks = Chunker(maxChars: c.config.maxChunkChars).split(m);

  Future<void> _run() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final memory = await c.ensureMemory();
      final e = c.embedder!;
      final dims = memory.config.dims;
      final sw = Stopwatch()..start();
      final traces = <_Trace>[];
      final vectors = await e.embedDocuments(_chunks.map((ch) => ch.text).toList());
      for (final (i, ch) in _chunks.indexed) {
        final v = VectorCodec.truncateNormalize(vectors[i], dims);
        final (q, scale) = VectorCodec.quantize(v);
        traces.add(_Trace(ch, '${NomicEmbedder.documentPrefix}${ch.text}', vectors[i], q, scale));
      }
      sw.stop();
      setState(() {
        _traces = traces;
        _embedTime = sw.elapsed;
      });
    } catch (err) {
      setState(() => _error = '$err');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _storeThis() async {
    final memory = await c.ensureMemory();
    await memory.addMoment(m);
    c.memoryChanged();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final memory = c.memory;
    final storedChunks = memory?.store.chunksOf(m.id) ?? const <StoredChunk>[];
    final traces = _traces;
    final dims = c.config.dims;
    return Scaffold(
      appBar: AppBar(title: Text('How "${m.id}" is stored')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Section(
            step: 1,
            title: 'Captured Care Moment',
            subtitle: 'The normal data, exactly as the family recorded it.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.text, style: t.bodyLarge),
                const SizedBox(height: 8),
                KeyValues([
                  ('Source', sourceLabel(m.sourceType)),
                  ('When', formatTime(m.createdAt)),
                  if (m.author != null) ('Captured by', m.author!),
                  if (m.language != null) ('Language', m.language!),
                  if (m.sourceUri != null) ('Evidence file', m.sourceUri!),
                  if (m.segments != null)
                    ('Transcript', '${m.segments!.length} timed segment(s)'),
                  ('Verified', m.verified ? 'yes' : 'no'),
                ]),
              ],
            ),
          ),
          Section(
            step: 2,
            title: 'Text the model reads',
            subtitle: m.translation == null
                ? 'English already, so it is embedded as-is.'
                : 'nomic-embed-text-v1 is English-only, so the English rendering '
                    '(from Gemma 4 at capture time) is embedded. The original stays '
                    'stored and keyword-searchable.',
            child: m.translation == null
                ? Text(m.embeddingText)
                : KeyValues([('Original', m.text), ('English', m.translation!)]),
          ),
          Section(
            step: 3,
            title: 'Chunks',
            subtitle: 'Split at sentence ends to ≤ ${c.config.maxChunkChars} characters '
                '(the model reads 128 tokens). Audio chunks keep their clip span so an '
                'answer can play the exact moment.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, ch) in _chunks.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '#$i  ${ch.text.length} chars'
                      '${ch.startMs == null ? '' : ' · clip ${ch.startMs! ~/ 1000}–${(ch.endMs ?? ch.startMs!) ~/ 1000} s'}\n'
                      '${ch.text}',
                      style: t.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          if (traces == null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: _busy || !c.isInstalled ? null : _run,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(c.isInstalled
                        ? 'Run the model on this moment'
                        : 'Download the model first (Memory tab)'),
                  ),
                  if (_busy) const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(),
                  ),
                  if (_error != null)
                    Text(_error!, style: t.bodySmall!.copyWith(color: Colors.red)),
                ],
              ),
            )
          else
            for (final tr in traces) ..._traceSections(context, tr, dims),
          _storedSection(context, storedChunks, traces),
        ],
      ),
    );
  }

  List<Widget> _traceSections(BuildContext context, _Trace tr, int dims) {
    final t = Theme.of(context).textTheme;
    final back = VectorCodec.dequantize(tr.q, tr.scale);
    final fidelity = VectorCodec.cosine(tr.vector, back);
    final n = _traces!.length;
    return [
      Section(
        step: 4,
        title: 'Model input',
        subtitle: 'Nomic is trained with a task prefix: "search_document: " for stored '
            'text, "search_query: " for questions. flutter_gemma\'s WordPiece tokenizer '
            'turns it into [CLS] … [SEP] token ids, padded to 128 with an attention mask '
            '(the two int64 inputs of the LiteRT graph).',
        child: CodeBlock(tr.input),
      ),
      Section(
        step: 5,
        title: 'Model output · ${tr.vector.length} numbers',
        subtitle: 'LiteRT on the phone CPU via flutter_gemma_litertlm. The graph pools '
            'and L2-normalizes itself. Took ${_embedTime!.inMilliseconds} ms'
            '${n > 1 ? ' for $n chunks' : ''}.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VectorStrip(tr.vector),
            const SizedBox(height: 6),
            Text(previewNumbers(tr.vector), style: monoStyle(context)),
            Text(
              'float32 × ${tr.vector.length} = ${formatBytes(tr.vector.length * 4)} if stored as-is · '
              '|v| = ${VectorCodec.dot(tr.vector, tr.vector).toStringAsFixed(4)}',
              style: t.bodySmall,
            ),
          ],
        ),
      ),
      Section(
        step: 6,
        title: 'Quantize to int8',
        subtitle: 'Each number becomes one signed byte: q = round(x / scale), '
            'scale = max|x| / 127. One float scale is kept per vector.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VectorStrip(tr.q),
            const SizedBox(height: 6),
            Text(previewNumbers(tr.q, n: 16), style: monoStyle(context)),
            const SizedBox(height: 6),
            KeyValues([
              ('scale', tr.scale.toStringAsExponential(4)),
              ('Size', '$dims B + 4 B scale = ${dims + 4} B'),
              ('vs float32', '${formatBytes(tr.vector.length * 4)} → ${dims + 4} B '
                  '(${(tr.vector.length * 4 / (dims + 4)).toStringAsFixed(1)}× smaller)'),
              ('Fidelity', 'cosine(before, after) = ${fidelity.toStringAsFixed(5)}'),
            ]),
          ],
        ),
      ),
    ];
  }

  Widget _storedSection(BuildContext context, List<StoredChunk> stored, List<_Trace>? traces) {
    final t = Theme.of(context).textTheme;
    final memory = c.memory;
    if (memory == null) {
      return const Section(
        step: 7,
        title: 'Rows in SQLite',
        child: Text('Load the model to open the memory database.'),
      );
    }
    if (stored.isEmpty) {
      return Section(
        step: 7,
        title: 'Rows in SQLite',
        subtitle: 'Not stored yet.',
        child: FilledButton.icon(
          onPressed: _storeThis,
          icon: const Icon(Icons.save_alt),
          label: const Text('Embed & store this moment'),
        ),
      );
    }
    final row = memory.store.moments().firstWhere((r) => r.id == m.id);
    return Section(
      step: 7,
      title: 'Rows in SQLite (what is actually on disk)',
      subtitle: c.dbPath,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('moments', style: t.labelLarge),
          KeyValues([
            ('id', row.id),
            ('patient_id', row.patientId),
            ('source_type', row.sourceType.name),
            ('created_at', '${row.createdAt.millisecondsSinceEpoch}  (${formatTime(row.createdAt)})'),
            ('text', row.text),
            ('translation', row.translation ?? 'NULL'),
            ('language', row.language ?? 'NULL'),
            ('author', row.author ?? 'NULL'),
            ('source_uri', row.sourceUri ?? 'NULL'),
            ('verified', row.verified ? '1' : '0'),
          ]),
          for (final (i, ch) in stored.indexed) ...[
            const Divider(height: 20),
            Text('chunks  (row ${ch.id})', style: t.labelLarge),
            KeyValues([
              ('moment_id', m.id),
              ('ordinal', '${ch.ordinal}'),
              ('text', ch.text),
              ('original', ch.original ?? 'NULL'),
              ('start_ms / end_ms', '${ch.startMs ?? 'NULL'} / ${ch.endMs ?? 'NULL'}'),
              ('model_key', ch.modelKey),
              ('scale', ch.scale.toStringAsExponential(4)),
              ('vec', 'BLOB, ${ch.vector.length} bytes'),
            ]),
            const SizedBox(height: 6),
            CodeBlock(hexDump(Uint8List.sublistView(ch.vector))),
            if (traces != null && i < traces.length)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  listEquals(traces[i].q, ch.vector)
                      ? '✓ Identical to the bytes computed above'
                      : '≠ Differs from the recomputed vector (stored under another run/model?)',
                  style: t.bodySmall!.copyWith(
                    color: listEquals(traces[i].q, ch.vector) ? Colors.green : Colors.orange,
                  ),
                ),
              ),
          ],
          const Divider(height: 20),
          Text('chunks_fts', style: t.labelLarge),
          Text(
            'FTS5 keyword index (trigram) over chunks.text and chunks.original, so '
            'exact words like drug names match in English and in '
            '${m.language ?? 'the original language'}. Example trigrams: '
            '${_trigrams(m.text).take(8).map((g) => '"$g"').join(' ')}',
            style: t.bodySmall,
          ),
        ],
      ),
    );
  }

  static Iterable<String> _trigrams(String s) sync* {
    final r = s.toLowerCase().runes.toList();
    for (var i = 0; i + 3 <= r.length; i++) {
      final g = String.fromCharCodes(r.sublist(i, i + 3));
      if (!g.contains(' ')) yield g;
    }
  }
}
