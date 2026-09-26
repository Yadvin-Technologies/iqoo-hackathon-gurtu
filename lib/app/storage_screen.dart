import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'memory_controller.dart';
import 'widgets.dart';

/// The memory database as a whole: sizes, schema, and raw table rows.
class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key, required this.c});

  final MemoryController c;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: c,
    builder: (context, _) {
      final memory = c.memory;
      if (memory == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Download and load the model on the Memory tab, then store the '
              'mock data to see how it is laid out on disk.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      final s = memory.store.stats();
      final moments = memory.store.moments();
      final full = c.embedder?.dimension ?? 768;
      final f32 = s.float32Bytes(full);
      final t = Theme.of(context).textTheme;
      return ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Section(
            title: 'What is stored',
            subtitle: c.dbPath,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KeyValues([
                  ('Moments', '${s.moments}'),
                  ('Chunks (vectors)', '${s.chunks}'),
                  ('Embedding space', s.modelKey),
                  ('Vectors', '${formatBytes(s.vectorBytes)}  '
                      '(${s.chunks == 0 ? 0 : s.vectorBytes ~/ s.chunks} B each)'),
                  ('Same as float32@$full', formatBytes(f32)),
                  ('Saving', s.vectorBytes == 0 ? '–'
                      : '${(f32 / s.vectorBytes).toStringAsFixed(1)}× smaller'),
                  ('Chunk text', formatBytes(s.textBytes)),
                  ('Database file', '${formatBytes(s.databaseBytes)}  (tables + indexes '
                      '+ FTS + free pages)'),
                  ('RAM scan index', formatBytes(s.indexBytes)),
                ]),
                const SizedBox(height: 10),
                _SizeBar(vectors: s.vectorBytes, text: s.textBytes, total: s.databaseBytes),
              ],
            ),
          ),
          const Section(
            title: 'Schema',
            subtitle: 'SQLite (package:sqlite3, FTS5 built in). One file, app-private.',
            child: CodeBlock('''
moments(
  id TEXT PK, patient_id, source_type, source_uri,
  author, language, translation, verified,
  created_at INTEGER (ms), text           -- original words
)
chunks(
  id INTEGER PK, moment_id → moments ON DELETE CASCADE,
  ordinal, text,                          -- embedded (English)
  original,                               -- original words if translated
  start_ms, end_ms,                       -- audio clip span
  model_key,                              -- nomic-embed-text-v1@768/int8
  scale REAL, vec BLOB                    -- 768 × int8
)
chunks_fts USING fts5(text, original, tokenize = trigram)

RAM: all vectors packed in one Int8List, scanned exactly
     (a family's memory = thousands of chunks → milliseconds)'''),
          ),
          Section(
            title: 'moments  (${moments.length} rows)',
            child: _Table(
              columns: const ['id', 'source_type', 'language', 'author', 'chunks', 'text'],
              rows: [
                for (final m in moments)
                  [
                    m.id,
                    m.sourceType.name,
                    m.language ?? '',
                    m.author ?? '',
                    '${m.chunkCount}',
                    m.text.length > 48 ? '${m.text.substring(0, 48)}…' : m.text,
                  ],
              ],
            ),
          ),
          Section(
            title: 'chunks  (${s.chunks} rows)',
            subtitle: 'vec shows the first 12 of ${s.dims} stored bytes.',
            child: _Table(
              columns: const ['id', 'moment', 'scale', 'vec (hex)', 'text'],
              rows: [
                for (final m in moments)
                  for (final ch in memory.store.chunksOf(m.id))
                    [
                      '${ch.id}',
                      m.id,
                      ch.scale.toStringAsExponential(2),
                      Uint8List.sublistView(ch.vector)
                          .take(12)
                          .map((b) => b.toRadixString(16).padLeft(2, '0'))
                          .join(' '),
                      ch.text.length > 40 ? '${ch.text.substring(0, 40)}…' : ch.text,
                    ],
              ],
            ),
          ),
          if (moments.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Empty. Store the mock data on the Memory tab.', style: t.bodyMedium),
            ),
        ],
      );
    },
  );
}

class _SizeBar extends StatelessWidget {
  const _SizeBar({required this.vectors, required this.text, required this.total});

  final int vectors, text, total;

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();
    final c = Theme.of(context).colorScheme;
    final other = (total - vectors - text).clamp(0, total);
    final t = Theme.of(context).textTheme.labelSmall!;
    Widget seg(int v, Color col) => Expanded(
      flex: (v * 1000 ~/ total).clamp(1, 1000),
      child: Container(height: 14, color: col),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(children: [
            seg(vectors, c.primary),
            seg(text, c.tertiary),
            seg(other, c.outlineVariant),
          ]),
        ),
        const SizedBox(height: 4),
        Wrap(spacing: 12, children: [
          Text('■ vectors', style: t.copyWith(color: c.primary)),
          Text('■ text', style: t.copyWith(color: c.tertiary)),
          Text('■ indexes, FTS, page overhead', style: t.copyWith(color: c.outline)),
        ]),
      ],
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.columns, required this.rows});

  final List<String> columns;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final mono = monoStyle(context, size: 11);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 32,
        dataRowMinHeight: 28,
        dataRowMaxHeight: 36,
        columnSpacing: 16,
        horizontalMargin: 4,
        columns: [for (final col in columns) DataColumn(label: Text(col, style: mono))],
        rows: [
          for (final r in rows)
            DataRow(cells: [for (final v in r) DataCell(Text(v, style: mono))]),
        ],
      ),
    );
  }
}
