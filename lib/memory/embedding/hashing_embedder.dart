import 'dart:typed_data';

import '../store/vector_codec.dart';
import 'nomic_embedder.dart';

/// Model-free [TextEmbedder]: hashes character trigrams into a fixed-width
/// vector. It captures surface overlap only, not meaning — use it for tests
/// and for building UI before the model files are on the device.
class HashingEmbedder implements TextEmbedder {
  HashingEmbedder({this.dimension = 768});

  @override
  final int dimension;

  @override
  String get modelId => 'hashing-trigram';

  Float32List _embed(String text) {
    final v = List<double>.filled(dimension, 0);
    final s = ' ${text.toLowerCase()} ';
    final runes = s.runes.toList();
    for (var i = 0; i + 3 <= runes.length; i++) {
      // FNV-1a over the trigram's code points.
      var h = 0x811c9dc5;
      for (var j = i; j < i + 3; j++) {
        h = ((h ^ runes[j]) * 0x01000193) & 0xffffffff;
      }
      v[h % dimension] += (h >> 31) == 0 ? 1 : -1;
    }
    return VectorCodec.truncateNormalize(v, dimension);
  }

  @override
  Future<Float32List> embedQuery(String text) async => _embed(text);

  @override
  Future<List<Float32List>> embedDocuments(List<String> texts) async =>
      texts.map(_embed).toList();

  @override
  Future<void> close() async {}
}
