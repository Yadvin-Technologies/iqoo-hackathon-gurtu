import 'dart:math' as math;
import 'dart:typed_data';

/// Compact vector encoding for on-device storage.
///
/// Each component is quantized to int8 with one float scale per vector, so a
/// 768-dim vector costs 768 bytes + 4 instead of 3072. [truncateNormalize]
/// also allows keeping fewer dims for Matryoshka-trained models (the
/// benchmark shows what it costs for nomic-embed-text-v1, which is not).
///
/// Queries stay float32 (asymmetric scoring), which recovers most of the
/// quantization loss for free.
abstract final class VectorCodec {
  /// First [dims] components of [v], L2-normalized.
  static Float32List truncateNormalize(List<double> v, int dims) {
    if (dims > v.length) {
      throw ArgumentError('dims $dims > vector length ${v.length}');
    }
    final out = Float32List(dims);
    var norm = 0.0;
    for (var i = 0; i < dims; i++) {
      out[i] = v[i];
      norm += v[i] * v[i];
    }
    norm = math.sqrt(norm);
    if (norm > 0) {
      for (var i = 0; i < dims; i++) {
        out[i] /= norm;
      }
    }
    return out;
  }

  /// Symmetric int8: q = round(x / scale), scale = max|x| / 127.
  static (Int8List, double) quantize(Float32List unit) {
    var maxAbs = 0.0;
    for (final x in unit) {
      final a = x.abs();
      if (a > maxAbs) maxAbs = a;
    }
    final scale = maxAbs == 0 ? 1.0 : maxAbs / 127.0;
    final q = Int8List(unit.length);
    for (var i = 0; i < unit.length; i++) {
      q[i] = (unit[i] / scale).round().clamp(-127, 127);
    }
    return (q, scale);
  }

  static Float32List dequantize(Int8List q, double scale) {
    final out = Float32List(q.length);
    for (var i = 0; i < q.length; i++) {
      out[i] = q[i] * scale;
    }
    return out;
  }

  /// Cosine between a unit float query and a quantized unit vector stored at
  /// `data[offset, offset + query.length)`.
  static double dotQuantized(
    Float32List query,
    Int8List data,
    int offset,
    double scale,
  ) {
    var acc = 0.0;
    final n = query.length;
    for (var i = 0; i < n; i++) {
      acc += query[i] * data[offset + i];
    }
    return acc * scale;
  }

  static double dot(List<double> a, List<double> b) {
    var acc = 0.0;
    for (var i = 0; i < a.length; i++) {
      acc += a[i] * b[i];
    }
    return acc;
  }

  /// Cosine similarity without assuming unit inputs.
  static double cosine(List<double> a, List<double> b) {
    var ab = 0.0, aa = 0.0, bb = 0.0;
    for (var i = 0; i < a.length; i++) {
      ab += a[i] * b[i];
      aa += a[i] * a[i];
      bb += b[i] * b[i];
    }
    if (aa == 0 || bb == 0) return 0;
    return ab / math.sqrt(aa * bb);
  }
}
