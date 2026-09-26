import 'dart:typed_data';

import 'package:sqlite3/sqlite3.dart';

import '../chunker.dart';
import '../models.dart';
import 'vector_codec.dart';

/// A chunk ready to be written: text, its span, and its encoded vector.
class EncodedChunk {
  const EncodedChunk(this.chunk, this.vector, this.scale);

  final Chunk chunk;
  final Int8List vector;
  final double scale;
}

/// Stored chunk row joined with its moment, for building [Evidence].
class ChunkRecord {
  const ChunkRecord({
    required this.chunkId,
    required this.momentId,
    required this.text,
    required this.originalText,
    required this.sourceType,
    required this.createdAt,
    this.sourceUri,
    this.author,
    this.startMs,
    this.endMs,
    this.verified = false,
  });

  final int chunkId;
  final String momentId;
  final String text;
  final String originalText;
  final SourceType sourceType;
  final DateTime createdAt;
  final String? sourceUri;
  final String? author;
  final int? startMs;
  final int? endMs;
  final bool verified;
}

/// A moment row as stored, for inspection.
class StoredMoment {
  const StoredMoment({
    required this.id,
    required this.patientId,
    required this.sourceType,
    required this.createdAt,
    required this.text,
    required this.chunkCount,
    this.translation,
    this.language,
    this.author,
    this.sourceUri,
    this.verified = false,
  });

  final String id;
  final String patientId;
  final SourceType sourceType;
  final DateTime createdAt;
  final String text;
  final String? translation;
  final String? language;
  final String? author;
  final String? sourceUri;
  final bool verified;
  final int chunkCount;
}

/// A chunk row as stored, including its raw vector bytes.
class StoredChunk {
  const StoredChunk({
    required this.id,
    required this.ordinal,
    required this.text,
    required this.modelKey,
    required this.scale,
    required this.vector,
    this.original,
    this.startMs,
    this.endMs,
  });

  final int id;
  final int ordinal;

  /// Embedded (English) text.
  final String text;

  /// Original-language text, when the moment was translated.
  final String? original;
  final int? startMs;
  final int? endMs;
  final String modelKey;

  /// Per-vector int8 scale: component i = vector[i] * scale.
  final double scale;

  /// The BLOB exactly as stored: one signed byte per dimension.
  final Int8List vector;
}

/// Sizes of what is stored.
class StoreStats {
  const StoreStats({
    required this.moments,
    required this.chunks,
    required this.dims,
    required this.modelKey,
    required this.databaseBytes,
    required this.vectorBytes,
    required this.textBytes,
    required this.indexBytes,
  });

  final int moments;
  final int chunks;
  final int dims;
  final String modelKey;

  /// Whole SQLite file (tables, B-tree indexes, FTS index, free pages).
  final int databaseBytes;

  /// Sum of vector BLOBs + their 4-byte scales.
  final int vectorBytes;

  /// UTF-8 bytes of chunk text (embedded + original).
  final int textBytes;

  /// In-memory scan index.
  final int indexBytes;

  /// What the same vectors would take as float32 at the model's full width.
  int float32Bytes(int fullDims) => chunks * fullDims * 4;
}

/// Optional scope for a search.
class SearchFilter {
  const SearchFilter({this.patientId, this.since, this.until, this.sources});

  final String? patientId;
  final DateTime? since;
  final DateTime? until;
  final Set<SourceType>? sources;
}

/// SQLite-backed care memory storage.
///
/// SQLite is the source of truth (moments, chunks, int8 vectors, and an FTS5
/// trigram index for exact words like drug names). Vectors are also held in
/// one packed in-memory matrix for scanning: a family's memory is thousands
/// of chunks, where an exact scan costs a few milliseconds and needs no ANN
/// index that could miss evidence.
class MemoryStore {
  MemoryStore._(this._db, this.dims, this.modelKey) {
    _loadIndex();
  }

  /// Opens (creating if needed) the store at [path]. [dims] is the
  /// Matryoshka width vectors are kept at; [modelKey] identifies the
  /// embedding space, e.g. `embeddinggemma-300m@256/int8`.
  factory MemoryStore.open(
    String path, {
    required int dims,
    required String modelKey,
  }) {
    final db = sqlite3.open(path);
    _migrate(db);
    return MemoryStore._(db, dims, modelKey);
  }

  factory MemoryStore.inMemory({required int dims, required String modelKey}) {
    final db = sqlite3.openInMemory();
    _migrate(db);
    return MemoryStore._(db, dims, modelKey);
  }

  final Database _db;
  final int dims;
  final String modelKey;

  static const _schemaVersion = 2;

  static void _migrate(Database db) {
    db.execute('PRAGMA journal_mode = WAL;');
    db.execute('PRAGMA foreign_keys = ON;');
    db.execute('PRAGMA synchronous = NORMAL;');
    final version = db.select('PRAGMA user_version').single.values.first as int;
    if (version != 0 && version != _schemaVersion) {
      // Pre-release schema: the memory is re-creatable from its sources.
      db.execute('''
        DROP TABLE IF EXISTS chunks_fts;
        DROP TABLE IF EXISTS chunks;
        DROP TABLE IF EXISTS moments;
      ''');
    }
    db.execute('''
      CREATE TABLE IF NOT EXISTS moments (
        id          TEXT PRIMARY KEY,
        patient_id  TEXT NOT NULL,
        source_type TEXT NOT NULL,
        source_uri  TEXT,
        author      TEXT,
        language    TEXT,
        translation TEXT,
        verified    INTEGER NOT NULL DEFAULT 0,
        created_at  INTEGER NOT NULL,
        text        TEXT NOT NULL
      );
      CREATE INDEX IF NOT EXISTS moments_patient_time
        ON moments (patient_id, created_at);

      CREATE TABLE IF NOT EXISTS chunks (
        id          INTEGER PRIMARY KEY,
        moment_id   TEXT NOT NULL REFERENCES moments (id) ON DELETE CASCADE,
        ordinal     INTEGER NOT NULL,
        text        TEXT NOT NULL,
        original    TEXT,
        start_ms    INTEGER,
        end_ms      INTEGER,
        model_key   TEXT NOT NULL,
        scale       REAL NOT NULL,
        vec         BLOB NOT NULL
      );
      CREATE INDEX IF NOT EXISTS chunks_moment ON chunks (moment_id);

      -- Keyword index over both the embedded English and the original
      -- words. trigram = language-agnostic substring matching: works for
      -- Telugu and Devanagari (unicode61 splits words at their combining
      -- vowel signs) and for partial drug names ("Telma" matches "Telma-40").
      CREATE VIRTUAL TABLE IF NOT EXISTS chunks_fts USING fts5 (
        text, original,
        content = 'chunks', content_rowid = 'id', tokenize = 'trigram'
      );
      CREATE TRIGGER IF NOT EXISTS chunks_ai AFTER INSERT ON chunks BEGIN
        INSERT INTO chunks_fts (rowid, text, original)
          VALUES (new.id, new.text, new.original);
      END;
      CREATE TRIGGER IF NOT EXISTS chunks_ad AFTER DELETE ON chunks BEGIN
        INSERT INTO chunks_fts (chunks_fts, rowid, text, original)
          VALUES ('delete', old.id, old.text, old.original);
      END;
    ''');
    db.execute('PRAGMA user_version = $_schemaVersion');
  }

  // ---- In-memory vector index ----------------------------------------------

  var _count = 0;
  var _ids = Int64List(0);
  var _scales = Float32List(0);
  var _createdAt = Int64List(0);
  var _patient = Int32List(0);
  var _source = Int8List(0);
  var _matrix = Int8List(0);
  final _idToRow = <int, int>{};
  final _patientIds = <String, int>{};

  int get chunkCount => _count;

  /// Bytes held by the in-memory vector index.
  int get indexBytes =>
      _count * (dims + 8 + 4 + 8 + 4 + 1); // vec, id, scale, time, patient, src

  void _ensureCapacity(int n) {
    if (n <= _ids.length) return;
    final cap = n < 64 ? 64 : (n > _ids.length * 2 ? n : _ids.length * 2);
    _ids = Int64List(cap)..setRange(0, _count, _ids);
    _scales = Float32List(cap)..setRange(0, _count, _scales);
    _createdAt = Int64List(cap)..setRange(0, _count, _createdAt);
    _patient = Int32List(cap)..setRange(0, _count, _patient);
    _source = Int8List(cap)..setRange(0, _count, _source);
    _matrix = Int8List(cap * dims)..setRange(0, _count * dims, _matrix);
  }

  void _indexAdd(
    int id,
    Int8List vec,
    double scale,
    String patientId,
    SourceType source,
    int createdAtMs,
  ) {
    _ensureCapacity(_count + 1);
    final row = _count++;
    _ids[row] = id;
    _scales[row] = scale;
    _createdAt[row] = createdAtMs;
    _patient[row] = _patientIds.putIfAbsent(patientId, () => _patientIds.length);
    _source[row] = source.index;
    _matrix.setRange(row * dims, row * dims + dims, vec);
    _idToRow[id] = row;
  }

  void _loadIndex() {
    final rows = _db.select(
      '''
      SELECT c.id, c.scale, c.vec, m.patient_id, m.source_type, m.created_at
      FROM chunks c JOIN moments m ON m.id = c.moment_id
      WHERE c.model_key = ?
      ORDER BY c.id
      ''',
      [modelKey],
    );
    _ensureCapacity(rows.length);
    for (final r in rows) {
      final vec = r['vec'] as Uint8List;
      if (vec.length != dims) continue;
      _indexAdd(
        r['id'] as int,
        Int8List.sublistView(vec),
        (r['scale'] as num).toDouble(),
        r['patient_id'] as String,
        SourceType.values.byName(r['source_type'] as String),
        r['created_at'] as int,
      );
    }
  }

  // ---- Writes ---------------------------------------------------------------

  /// Inserts (or replaces) [moment] with its already-embedded chunks in one
  /// transaction. Returns the new chunk ids.
  List<int> putMoment(CareMoment moment, List<EncodedChunk> chunks) =>
      putMoments([(moment, chunks)]).single;

  /// Batched [putMoment]: one transaction for all of them, which is what
  /// makes bulk ingest fast on flash storage.
  List<List<int>> putMoments(List<(CareMoment, List<EncodedChunk>)> items) {
    final out = <List<int>>[];
    final pendingIndex = <void Function()>[];
    _db.execute('BEGIN');
    try {
      final existing = _db.prepare('SELECT id FROM chunks WHERE moment_id = ?');
      final delMoment = _db.prepare('DELETE FROM moments WHERE id = ?');
      final insMoment = _db.prepare('''
        INSERT INTO moments
          (id, patient_id, source_type, source_uri, author, language,
           translation, verified, created_at, text)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''');
      final insChunk = _db.prepare('''
        INSERT INTO chunks
          (moment_id, ordinal, text, original, start_ms, end_ms, model_key,
           scale, vec)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''');
      final removedIds = <int>[];
      try {
        for (final (m, chunks) in items) {
          removedIds.addAll(
            existing.select([m.id]).map((r) => r['id'] as int),
          );
          delMoment.execute([m.id]);
          final createdAtMs = m.createdAt.millisecondsSinceEpoch;
          insMoment.execute([
            m.id,
            m.patientId,
            m.sourceType.name,
            m.sourceUri,
            m.author,
            m.language,
            m.translation,
            m.verified ? 1 : 0,
            createdAtMs,
            m.text,
          ]);
          final ids = <int>[];
          for (var i = 0; i < chunks.length; i++) {
            final c = chunks[i];
            if (c.vector.length != dims) {
              throw ArgumentError(
                'vector has ${c.vector.length} dims, store keeps $dims',
              );
            }
            insChunk.execute([
              m.id,
              i,
              c.chunk.text,
              m.translation == null ? null : m.text,
              c.chunk.startMs,
              c.chunk.endMs,
              modelKey,
              c.scale,
              Uint8List.sublistView(c.vector),
            ]);
            final id = _db.lastInsertRowId;
            ids.add(id);
            pendingIndex.add(
              () => _indexAdd(
                id,
                c.vector,
                c.scale,
                m.patientId,
                m.sourceType,
                createdAtMs,
              ),
            );
          }
          out.add(ids);
        }
      } finally {
        existing.close();
        delMoment.close();
        insMoment.close();
        insChunk.close();
      }
      _db.execute('COMMIT');
      if (removedIds.isNotEmpty) _indexRemove(removedIds.toSet());
      for (final add in pendingIndex) {
        add();
      }
      return out;
    } catch (_) {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  void deleteMoment(String momentId) {
    final ids = _db
        .select('SELECT id FROM chunks WHERE moment_id = ?', [momentId])
        .map((r) => r['id'] as int)
        .toSet();
    _db.execute('DELETE FROM moments WHERE id = ?', [momentId]);
    _indexRemove(ids);
  }

  /// Compacts removed rows out of the packed index.
  void _indexRemove(Set<int> ids) {
    if (ids.isEmpty) return;
    var w = 0;
    for (var r = 0; r < _count; r++) {
      if (ids.contains(_ids[r])) continue;
      if (w != r) {
        _ids[w] = _ids[r];
        _scales[w] = _scales[r];
        _createdAt[w] = _createdAt[r];
        _patient[w] = _patient[r];
        _source[w] = _source[r];
        _matrix.setRange(w * dims, w * dims + dims, _matrix, r * dims);
      }
      w++;
    }
    _count = w;
    _idToRow.clear();
    for (var r = 0; r < _count; r++) {
      _idToRow[_ids[r]] = r;
    }
  }

  // ---- Reads ----------------------------------------------------------------

  bool _passes(int row, SearchFilter f, int? patient) {
    if (f.patientId != null && _patient[row] != patient) return false;
    if (f.since != null &&
        _createdAt[row] < f.since!.millisecondsSinceEpoch) {
      return false;
    }
    if (f.until != null &&
        _createdAt[row] > f.until!.millisecondsSinceEpoch) {
      return false;
    }
    final s = f.sources;
    if (s != null && !s.contains(SourceType.values[_source[row]])) {
      return false;
    }
    return true;
  }

  /// Exact top-[k] by cosine. [query] must be unit length at [dims].
  List<(int, double)> vectorSearch(
    Float32List query, {
    int k = 10,
    SearchFilter filter = const SearchFilter(),
  }) {
    if (query.length != dims) {
      throw ArgumentError('query has ${query.length} dims, store keeps $dims');
    }
    final patient = filter.patientId == null
        ? null
        : _patientIds[filter.patientId];
    if (filter.patientId != null && patient == null) return const [];

    // Small sorted top-k buffer; k is tiny relative to the scan.
    final topIds = <int>[];
    final topScores = <double>[];
    for (var row = 0; row < _count; row++) {
      if (!_passes(row, filter, patient)) continue;
      final s = VectorCodec.dotQuantized(query, _matrix, row * dims, _scales[row]);
      if (topScores.length == k && s <= topScores.last) continue;
      var i = topScores.length;
      while (i > 0 && topScores[i - 1] < s) {
        i--;
      }
      topScores.insert(i, s);
      topIds.insert(i, _ids[row]);
      if (topScores.length > k) {
        topScores.removeLast();
        topIds.removeLast();
      }
    }
    return [for (var i = 0; i < topIds.length; i++) (topIds[i], topScores[i])];
  }

  /// Cosine for specific chunks (e.g. keyword hits the vector scan ranked
  /// below its cut-off).
  double? scoreChunk(Float32List query, int chunkId) {
    final row = _idToRow[chunkId];
    if (row == null) return null;
    return VectorCodec.dotQuantized(query, _matrix, row * dims, _scales[row]);
  }

  /// FTS5 BM25 keyword search, returns chunk ids best-first.
  List<int> keywordSearch(
    String query, {
    int k = 10,
    SearchFilter filter = const SearchFilter(),
  }) {
    final match = ftsQuery(query);
    if (match == null) return const [];
    final where = <String>['chunks_fts MATCH ?', 'c.model_key = ?'];
    final args = <Object?>[match, modelKey];
    if (filter.patientId != null) {
      where.add('m.patient_id = ?');
      args.add(filter.patientId);
    }
    if (filter.since != null) {
      where.add('m.created_at >= ?');
      args.add(filter.since!.millisecondsSinceEpoch);
    }
    if (filter.until != null) {
      where.add('m.created_at <= ?');
      args.add(filter.until!.millisecondsSinceEpoch);
    }
    if (filter.sources != null) {
      where.add(
        'm.source_type IN (${List.filled(filter.sources!.length, '?').join(',')})',
      );
      args.addAll(filter.sources!.map((s) => s.name));
    }
    args.add(k);
    try {
      return _db
          .select('''
            SELECT c.id FROM chunks_fts
            JOIN chunks c ON c.id = chunks_fts.rowid
            JOIN moments m ON m.id = c.moment_id
            WHERE ${where.join(' AND ')}
            ORDER BY bm25(chunks_fts) LIMIT ?
          ''', args)
          .map((r) => r['id'] as int)
          .toList();
    } on SqliteException {
      return const [];
    }
  }

  static const _stopwords = {
    'the', 'and', 'what', 'did', 'does', 'was', 'were', 'for', 'about',
    'when', 'which', 'who', 'how', 'should', 'she', 'her', 'his', 'him',
    'they', 'with', 'from', 'that', 'this', 'have', 'has', 'had', 'are',
    'any', 'can', 'mom', 'amma', 'say', 'said', 'tell', 'take', 'taken',
  };

  /// OR of quoted terms of 3+ chars (trigram's minimum), minus stopwords.
  static String? ftsQuery(String q) {
    final terms = q
        .toLowerCase()
        .split(RegExp(r'[\s,.;:!?()"\x27/\\\[\]{}<>|।॥-]+'))
        .where((t) => t.runes.length >= 3 && !_stopwords.contains(t))
        .toSet();
    if (terms.isEmpty) return null;
    return terms.map((t) => '"${t.replaceAll('"', '""')}"').join(' OR ');
  }

  List<ChunkRecord> getChunks(Iterable<int> ids) {
    final list = ids.toList();
    if (list.isEmpty) return const [];
    final rows = _db.select('''
      SELECT c.id, c.moment_id, c.text, c.start_ms, c.end_ms,
             m.text AS original_text,
             m.source_type, m.source_uri, m.author, m.verified, m.created_at
      FROM chunks c JOIN moments m ON m.id = c.moment_id
      WHERE c.id IN (${List.filled(list.length, '?').join(',')})
    ''', list);
    final byId = {
      for (final r in rows)
        r['id'] as int: ChunkRecord(
          chunkId: r['id'] as int,
          momentId: r['moment_id'] as String,
          text: r['text'] as String,
          originalText: r['original_text'] as String,
          sourceType: SourceType.values.byName(r['source_type'] as String),
          createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
          sourceUri: r['source_uri'] as String?,
          author: r['author'] as String?,
          startMs: r['start_ms'] as int?,
          endMs: r['end_ms'] as int?,
          verified: (r['verified'] as int) == 1,
        ),
    };
    return [for (final id in list) ?byId[id]];
  }

  /// Chunks whose vectors were written under a different [modelKey] and need
  /// re-embedding (e.g. after changing dims or the model).
  List<(int, String)> staleChunks({int limit = 500}) => _db
      .select(
        'SELECT id, text FROM chunks WHERE model_key != ? LIMIT ?',
        [modelKey, limit],
      )
      .map((r) => (r['id'] as int, r['text'] as String))
      .toList();

  void replaceVector(int chunkId, Int8List vec, double scale) {
    _db.execute(
      'UPDATE chunks SET model_key = ?, scale = ?, vec = ? WHERE id = ?',
      [modelKey, scale, Uint8List.sublistView(vec), chunkId],
    );
    final r = _db.select('''
      SELECT m.patient_id, m.source_type, m.created_at
      FROM chunks c JOIN moments m ON m.id = c.moment_id WHERE c.id = ?
    ''', [chunkId]).single;
    _indexRemove({chunkId});
    _indexAdd(
      chunkId,
      vec,
      scale,
      r['patient_id'] as String,
      SourceType.values.byName(r['source_type'] as String),
      r['created_at'] as int,
    );
  }

  // ---- Inspection -----------------------------------------------------------

  List<StoredMoment> moments({String? patientId}) => _db
      .select(
        '''
        SELECT m.*, (SELECT COUNT(*) FROM chunks c WHERE c.moment_id = m.id)
               AS chunk_count
        FROM moments m
        ${patientId == null ? '' : 'WHERE m.patient_id = ?'}
        ORDER BY m.created_at DESC
        ''',
        [?patientId],
      )
      .map(
        (r) => StoredMoment(
          id: r['id'] as String,
          patientId: r['patient_id'] as String,
          sourceType: SourceType.values.byName(r['source_type'] as String),
          createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int),
          text: r['text'] as String,
          translation: r['translation'] as String?,
          language: r['language'] as String?,
          author: r['author'] as String?,
          sourceUri: r['source_uri'] as String?,
          verified: (r['verified'] as int) == 1,
          chunkCount: r['chunk_count'] as int,
        ),
      )
      .toList();

  List<StoredChunk> chunksOf(String momentId) => _db
      .select(
        'SELECT * FROM chunks WHERE moment_id = ? ORDER BY ordinal',
        [momentId],
      )
      .map(
        (r) => StoredChunk(
          id: r['id'] as int,
          ordinal: r['ordinal'] as int,
          text: r['text'] as String,
          original: r['original'] as String?,
          startMs: r['start_ms'] as int?,
          endMs: r['end_ms'] as int?,
          modelKey: r['model_key'] as String,
          scale: (r['scale'] as num).toDouble(),
          vector: Int8List.fromList(r['vec'] as Uint8List),
        ),
      )
      .toList();

  StoreStats stats() {
    final r = _db.select('''
      SELECT (SELECT COUNT(*) FROM moments) AS moments,
             COUNT(*) AS chunks,
             COALESCE(SUM(length(vec) + 4), 0) AS vector_bytes,
             COALESCE(SUM(length(CAST(text AS BLOB))
                        + COALESCE(length(CAST(original AS BLOB)), 0)), 0)
               AS text_bytes
      FROM chunks
    ''').single;
    return StoreStats(
      moments: r['moments'] as int,
      chunks: r['chunks'] as int,
      dims: dims,
      modelKey: modelKey,
      databaseBytes: databaseBytes,
      vectorBytes: r['vector_bytes'] as int,
      textBytes: r['text_bytes'] as int,
      indexBytes: indexBytes,
    );
  }

  /// Deletes every moment (and its chunks, vectors and keyword entries).
  void clear() {
    _db.execute('DELETE FROM moments');
    _indexRemove({for (var r = 0; r < _count; r++) _ids[r]});
  }

  /// On-disk size of the database (main file only).
  int get databaseBytes {
    final r = _db.select(
      'SELECT page_count * page_size AS b FROM pragma_page_count(), pragma_page_size()',
    );
    return r.single['b'] as int;
  }

  void close() => _db.close();
}
