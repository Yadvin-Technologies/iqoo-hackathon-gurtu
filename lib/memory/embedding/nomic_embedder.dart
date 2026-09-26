import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/core/embedding/embedding_worker.dart';
import 'package:flutter_gemma_embeddings/flutter_gemma_embeddings.dart';

import 'embedding_activity.dart';
import 'nomic_litert_forward_pass.dart';

export 'nomic_litert_forward_pass.dart' show NomicAccelerator;

/// Anything that turns text into unit-length vectors in one embedding space.
/// [NomicEmbedder] is the real one; tests and UI work before the model is
/// installed can use `HashingEmbedder`.
abstract interface class TextEmbedder {
  /// Identifies the embedding space; stored next to every vector.
  String get modelId;

  /// Native output width.
  int get dimension;

  Future<Float32List> embedQuery(String text);
  Future<List<Float32List>> embedDocuments(List<String> texts);
  Future<void> close();
}

/// Paths of an installed Nomic model.
class NomicModelPaths {
  const NomicModelPaths({required this.model, required this.tokenizer});

  final String model;
  final String tokenizer;

  int get modelBytes => File(model).lengthSync();
}

/// nomic-embed-text-v1 as a LiteRT model, installed on the phone by
/// flutter_gemma's own downloader (`FlutterGemma.installEmbedder()`):
///  * model: Arm's INT8 LiteRT export (Apache-2.0, not gated), 133 MB
///  * tokenizer: Nomic's `tokenizer.json` (uncased BERT WordPiece)
abstract final class NomicModel {
  static const modelRepo = 'Arm/nomic-embed-text-v1-int8-litert';
  static const modelFile = 'nomic-embed-text-v1_litert_optimized.tflite';
  static const tokenizerRepo = 'nomic-ai/nomic-embed-text-v1';
  static const tokenizerFile = 'tokenizer.json';

  static const modelUrl = 'https://huggingface.co/$modelRepo/resolve/main/$modelFile';
  static const tokenizerUrl = 'https://huggingface.co/$tokenizerRepo/resolve/main/$tokenizerFile';

  /// Arm's reference outputs for three sample texts, used to check that the
  /// phone computes the same vectors.
  static const referenceUrl = 'https://huggingface.co/$modelRepo/resolve/main/embeddings.json';

  static const approxBytes = 139690440 + 711396;

  static Future<bool> isInstalled() async =>
      await FlutterGemma.isModelInstalled(modelFile) &&
      await FlutterGemma.isModelInstalled(tokenizerFile);

  /// Downloads (or finds already-downloaded) files and returns their paths.
  /// [onProgress] reports 0–100 over both files.
  static Future<NomicModelPaths> install({
    void Function(int percent)? onProgress,
    CancelToken? cancelToken,
  }) async {
    var builder = FlutterGemma.installEmbedder()
        .modelFromNetwork(modelUrl)
        .tokenizerFromNetwork(tokenizerUrl)
        // The model is 99.5 % of the bytes; the tokenizer finishes the bar.
        .withModelProgress((p) => onProgress?.call((p * 0.99).round()))
        .withTokenizerProgress((p) => onProgress?.call(99 + (p / 100).round()));
    if (cancelToken != null) builder = builder.withCancelToken(cancelToken);
    final installation = await builder.install();
    final paths = await FlutterGemmaPlugin.instance.modelManager.getModelFilePaths(installation.spec);
    if (paths == null) throw StateError('Nomic model installed but its files were not found');
    final model = paths.values.firstWhere((v) => v.endsWith('.tflite'));
    final tokenizer = paths.values.firstWhere((v) => v.endsWith('.json'));
    return NomicModelPaths(model: model, tokenizer: tokenizer);
  }

  /// Removes the model files through flutter_gemma.
  static Future<void> uninstall() => FlutterGemma.uninstallEmbedder();

  /// Arm's published (text, vector) pairs for [referenceUrl].
  static Future<List<(String, List<double>)>> fetchReference() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 20);
    try {
      final res = await (await client.getUrl(Uri.parse(referenceUrl))).close();
      if (res.statusCode != 200) throw HttpException('HTTP ${res.statusCode}');
      final ref = jsonDecode(await res.transform(utf8.decoder).join()) as Map<String, dynamic>;
      final texts = (ref['texts'] as List).cast<String>();
      final vecs = ref['embeddings'] as List;
      return [
        for (var i = 0; i < texts.length; i++)
          (texts[i], (vecs[i] as List).map((x) => (x as num).toDouble()).toList()),
      ];
    } finally {
      client.close();
    }
  }
}

/// nomic-embed-text-v1 running on the phone through flutter_gemma_litertlm's
/// LiteRT runtime (CPU, XNNPACK/KleidiAI int8 kernels).
///
/// flutter_gemma supplies the WordPiece tokenizer and the background
/// isolate; [NomicLiteRtForwardPass] feeds the two-input LiteRT graph. Task
/// prefixes are Nomic's (`search_document: ` / `search_query: `), passed to
/// the worker directly — flutter_gemma's EmbeddingModel API would apply
/// EmbeddingGemma's instead.
class NomicEmbedder implements TextEmbedder {
  NomicEmbedder._(this.paths, this.accelerator, this._worker, this.loadTime);

  final NomicModelPaths paths;
  final NomicAccelerator accelerator;
  final EmbeddingWorker _worker;

  /// Isolate spawn + tokenizer load + LiteRT compile.
  final Duration loadTime;

  static const documentPrefix = 'search_document: ';
  static const queryPrefix = 'search_query: ';

  @override
  String get modelId => 'nomic-embed-text-v1';

  @override
  int get dimension => _worker.outputDimension;

  /// Fixed input window of the LiteRT graph, in tokens (incl. [CLS]/[SEP]).
  int get sequenceLength => _worker.inputSequenceLength;

  static Future<NomicEmbedder> load(
    NomicModelPaths paths, {
    NomicAccelerator accelerator = NomicAccelerator.cpu,
  }) async {
    final sw = Stopwatch()..start();
    final worker = await EmbeddingWorker.spawn(
      descriptor: ForwardPassDescriptor(
        engineTag: 'LiteRT-${accelerator.name}',
        modelPath: encodeNomicSpec(paths.model, accelerator),
        factory: createNomicLiteRtForwardPass,
        tokenizerFactory: const GemmaEmbeddingTokenizers().factory,
        outputContract: EmbeddingOutputContract.pooledFinal,
      ),
      tokenizerPath: paths.tokenizer,
    );
    sw.stop();
    return NomicEmbedder._(paths, accelerator, worker, sw.elapsed);
  }

  Future<List<double>> _embed(String text, String prefix) => _worker.embed(text, prefix: prefix);

  Future<T> _timed<T>(int n, Future<T> Function() f) async {
    final sw = Stopwatch()..start();
    final r = await f();
    EmbeddingActivity.record(n, sw.elapsed);
    return r;
  }

  /// Embeds [text] exactly as given (caller supplies any prefix). Used to
  /// compare against Arm's reference vectors.
  Future<Float32List> embedVerbatim(String text) async =>
      Float32List.fromList(await _timed(1, () => _embed(text, '')));

  @override
  Future<Float32List> embedQuery(String text) async =>
      Float32List.fromList(await _timed(1, () => _embed(text, queryPrefix)));

  @override
  Future<List<Float32List>> embedDocuments(List<String> texts) async {
    final out = await _timed(
      texts.length,
      () => Future.wait(texts.map((t) => _embed(t, documentPrefix))),
    );
    return [for (final v in out) Float32List.fromList(v)];
  }

  /// Lowest cosine between this embedder's output and Arm's reference
  /// vectors (≥ 0.99 means the phone computes the same embeddings).
  Future<double> referenceCosine(List<(String, List<double>)> reference) async {
    var worst = 1.0;
    for (final (text, want) in reference) {
      final got = await embedVerbatim(text);
      var ab = 0.0, aa = 0.0, bb = 0.0;
      for (var i = 0; i < got.length; i++) {
        ab += got[i] * want[i];
        aa += got[i] * got[i];
        bb += want[i] * want[i];
      }
      worst = math.min(worst, aa == 0 || bb == 0 ? 0 : ab / math.sqrt(aa * bb));
    }
    return worst;
  }

  @override
  Future<void> close() => _worker.close();
}
