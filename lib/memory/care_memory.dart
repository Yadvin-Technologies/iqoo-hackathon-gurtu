import 'dart:typed_data';

import 'chunker.dart';
import 'embedding/nomic_embedder.dart';
import 'models.dart';
import 'store/memory_store.dart';
import 'store/vector_codec.dart';

/// Tunables for storage and retrieval.
class MemoryConfig {
  const MemoryConfig({
    this.dims = 768,
    this.maxChunkChars = 400,
    this.minSimilarity = 0.50,
    this.keywordFloor = 0.25,
    this.candidates = 20,
    this.rrfK = 60,
  });

  /// Vector width kept on disk. nomic-embed-text-v1 is not Matryoshka-
  /// trained, so it is stored at its full 768 (as int8: 772 B/vector);
  /// truncating costs more quality than it does for v1.5.
  final int dims;

  /// nomic-embed-text-v1's LiteRT graph reads 128 tokens (incl. prefix,
  /// [CLS], [SEP]); 400 chars of English is ~100 tokens.
  final int maxChunkChars;

  /// Cosine a chunk must reach to count as evidence. Below it, retrieval
  /// returns nothing and the assistant must say it has no source. Calibrate
  /// with the benchmark's answerable/unanswerable score split.
  final double minSimilarity;

  /// Lower bar for chunks that keyword search also found (exact drug name,
  /// dose), since lexical agreement is independent evidence of relevance.
  final double keywordFloor;

  /// How many candidates each retriever contributes before fusion.
  final int candidates;

  /// Reciprocal-rank-fusion constant.
  final int rrfK;
}

/// The care-memory layer: stores Care Moments and returns cited evidence
/// for a question.
///
/// ```dart
/// final memory = await CareMemory.open(dbPath: path, embedder: embedder);
/// await memory.addMoment(moment);
/// final evidence = await memory.retrieve('What did the doctor say about '
///     'the evening medicine?', filter: SearchFilter(patientId: 'amma'));
/// final context = CareMemory.formatForPrompt(evidence);
/// ```
class CareMemory {
  CareMemory._(this.store, this.embedder, this.config)
    : _chunker = Chunker(maxChars: config.maxChunkChars);

  final MemoryStore store;
  final TextEmbedder embedder;
  final MemoryConfig config;
  final Chunker _chunker;

  static Future<CareMemory> open({
    required String dbPath,
    required TextEmbedder embedder,
    MemoryConfig config = const MemoryConfig(),
  }) async {
    if (config.dims > embedder.dimension) {
      throw ArgumentError(
        'config.dims ${config.dims} > model width ${embedder.dimension}',
      );
    }
    final store = MemoryStore.open(
      dbPath,
      dims: config.dims,
      modelKey: '${embedder.modelId}@${config.dims}/int8',
    );
    return CareMemory._(store, embedder, config);
  }

  /// A memory over an in-memory database, for tests and benchmarks.
  static CareMemory inMemory({
    required TextEmbedder embedder,
    MemoryConfig config = const MemoryConfig(),
  }) => CareMemory._(
    MemoryStore.inMemory(
      dims: config.dims,
      modelKey: '${embedder.modelId}@${config.dims}/int8',
    ),
    embedder,
    config,
  );

  /// Chunks, embeds and stores [moment]. Re-adding the same id replaces it.
  Future<List<int>> addMoment(CareMoment moment) async =>
      (await addMoments([moment])).single;

  /// Batched [addMoment]: one embedding pass, one transaction.
  Future<List<List<int>>> addMoments(List<CareMoment> moments) async {
    final split = [for (final m in moments) _chunker.split(m)];
    final texts = [
      for (final chunks in split)
        for (final c in chunks) c.text,
    ];
    final vectors = await embedder.embedDocuments(texts);
    var v = 0;
    final items = <(CareMoment, List<EncodedChunk>)>[];
    for (var i = 0; i < moments.length; i++) {
      items.add((
        moments[i],
        [for (final c in split[i]) _encode(c, vectors[v++])],
      ));
    }
    return store.putMoments(items);
  }

  EncodedChunk _encode(Chunk c, Float32List full) {
    final (q, scale) = VectorCodec.quantize(
      VectorCodec.truncateNormalize(full, config.dims),
    );
    return EncodedChunk(c, q, scale);
  }

  void deleteMoment(String momentId) => store.deleteMoment(momentId);

  /// Hybrid retrieval: vector scan + FTS5 keyword search, fused with
  /// reciprocal rank fusion, then gated by similarity so that weak matches
  /// are dropped rather than handed to the LLM as "evidence".
  ///
  /// For a non-English [question], pass Gemma 4's English rendering as
  /// [englishQuestion]: that is embedded, while keyword search uses both
  /// (so a Telugu question still matches Telugu words stored verbatim).
  ///
  /// An empty result means: no source for this question.
  Future<List<Evidence>> retrieve(
    String question, {
    String? englishQuestion,
    int k = 5,
    SearchFilter filter = const SearchFilter(),
  }) async {
    final q = VectorCodec.truncateNormalize(
      await embedder.embedQuery(englishQuestion ?? question),
      config.dims,
    );
    final keywords = englishQuestion == null
        ? question
        : '$question $englishQuestion';
    return retrieveWithVector(keywords, q, k: k, filter: filter);
  }

  /// [retrieve] with an already-embedded, truncated, unit query.
  /// [keywords] is the text given to keyword search.
  List<Evidence> retrieveWithVector(
    String keywords,
    Float32List query, {
    int k = 5,
    SearchFilter filter = const SearchFilter(),
  }) {
    final vec = store.vectorSearch(query, k: config.candidates, filter: filter);
    final kw = store.keywordSearch(
      keywords,
      k: config.candidates,
      filter: filter,
    );

    final score = <int, double>{for (final (id, s) in vec) id: s};
    final fused = <int, double>{};
    for (var i = 0; i < vec.length; i++) {
      fused.update(
        vec[i].$1,
        (x) => x + 1 / (config.rrfK + i + 1),
        ifAbsent: () => 1 / (config.rrfK + i + 1),
      );
    }
    final kwRank = <int, int>{};
    for (var i = 0; i < kw.length; i++) {
      kwRank[kw[i]] = i + 1;
      fused.update(
        kw[i],
        (x) => x + 1 / (config.rrfK + i + 1),
        ifAbsent: () => 1 / (config.rrfK + i + 1),
      );
      score.putIfAbsent(kw[i], () => store.scoreChunk(query, kw[i]) ?? 0);
    }

    final kept = fused.keys.where((id) {
      final s = score[id]!;
      return s >= config.minSimilarity ||
          (kwRank.containsKey(id) && s >= config.keywordFloor);
    }).toList()..sort((a, b) => fused[b]!.compareTo(fused[a]!));

    final records = store.getChunks(kept.take(k));
    return [
      for (final r in records)
        Evidence(
          chunkId: r.chunkId,
          momentId: r.momentId,
          text: r.text,
          originalText: r.originalText,
          sourceType: r.sourceType,
          createdAt: r.createdAt,
          sourceUri: r.sourceUri,
          author: r.author,
          startMs: r.startMs,
          endMs: r.endMs,
          verified: r.verified,
          vectorScore: score[r.chunkId]!,
          keywordRank: kwRank[r.chunkId],
          fusedScore: fused[r.chunkId]!,
        ),
    ];
  }

  /// Re-embeds chunks stored under an older model key (after changing
  /// [MemoryConfig.dims] or the model). Returns how many were updated.
  Future<int> reindex({int batch = 64}) async {
    var total = 0;
    while (true) {
      final stale = store.staleChunks(limit: batch);
      if (stale.isEmpty) return total;
      final vectors = await embedder.embedDocuments(
        stale.map((s) => s.$2).toList(),
      );
      for (var i = 0; i < stale.length; i++) {
        final e = _encode(Chunk(stale[i].$2), vectors[i]);
        store.replaceVector(stale[i].$1, e.vector, e.scale);
      }
      total += stale.length;
    }
  }

  /// Renders evidence as a numbered context block for the Gemma 4 prompt.
  /// The model cites `[S1]`, `[S2]`...; the UI maps those back to
  /// [Evidence.sourceUri] / [Evidence.startMs] to play the clip or show the
  /// scan.
  static String formatForPrompt(List<Evidence> evidence) {
    if (evidence.isEmpty) {
      return 'NO EVIDENCE FOUND in the care memory for this question.';
    }
    final b = StringBuffer();
    for (var i = 0; i < evidence.length; i++) {
      final e = evidence[i];
      final when = e.createdAt.toIso8601String().substring(0, 16);
      final clip = e.startMs == null ? '' : ' @${_mmss(e.startMs!)}';
      final who = e.author == null ? '' : ', by ${e.author}';
      final ok = e.verified ? ', verified' : '';
      b.writeln('[S${i + 1}] (${e.sourceType.name}$clip, $when$who$ok)');
      if (e.originalText != e.text && !e.originalText.contains(e.text)) {
        b.writeln('Original: ${e.originalText}');
        b.writeln('English: ${e.text}');
      } else {
        b.writeln(e.text);
      }
      b.writeln();
    }
    return b.toString().trimRight();
  }

  static String _mmss(int ms) {
    final s = ms ~/ 1000;
    return '${(s ~/ 60).toString().padLeft(2, '0')}:'
        '${(s % 60).toString().padLeft(2, '0')}';
  }

  void close() => store.close();
}
