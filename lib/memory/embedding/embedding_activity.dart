/// Process-wide count of embeddings computed and the time they took, so a
/// live dashboard can show model throughput without being wired into every
/// caller.
abstract final class EmbeddingActivity {
  static int _count = 0;
  static int _micros = 0;

  static void record(int embeddings, Duration took) {
    _count += embeddings;
    _micros += took.inMicroseconds;
  }

  static ({int count, int micros}) snapshot() => (count: _count, micros: _micros);
}
