import 'models.dart';

/// A piece of a Care Moment small enough for the embedding window.
class Chunk {
  const Chunk(this.text, {this.startMs, this.endMs});

  final String text;
  final int? startMs;
  final int? endMs;
}

/// Splits moments into chunks of at most [maxChars].
///
/// Character budget rather than tokens: the embedder's tokenizer lives in
/// its worker isolate. Chunks are English (originals are translated before
/// embedding), where ~4 chars make a WordPiece token.
class Chunker {
  const Chunker({this.maxChars = 400});

  final int maxChars;

  // Sentence ends in Latin, Devanagari (।) and Telugu text (which uses '.').
  static final _sentenceEnd = RegExp(r'(?<=[.!?।॥])\s+');

  /// Chunks [CareMoment.embeddingText]. Translated audio keeps the whole
  /// recording's span per chunk: translated sentences no longer line up
  /// with individual transcript segments.
  List<Chunk> split(CareMoment m) {
    final segments = m.segments;
    final hasSegments = segments != null && segments.isNotEmpty;
    if (hasSegments && m.translation == null) return _mergeSegments(segments);
    final start = hasSegments ? segments.first.startMs : null;
    final end = hasSegments ? (segments.last.endMs ?? segments.last.startMs) : null;
    return _packSentences(m.embeddingText)
        .map((t) => Chunk(t, startMs: start, endMs: end))
        .toList();
  }

  /// Merges consecutive transcript segments, keeping the clip span of each
  /// chunk so the UI can play exactly the evidence.
  List<Chunk> _mergeSegments(List<TranscriptSegment> segments) {
    final out = <Chunk>[];
    final buf = StringBuffer();
    int? start;
    int? end;
    void flush() {
      if (buf.isEmpty) return;
      out.add(Chunk(buf.toString(), startMs: start, endMs: end));
      buf.clear();
      start = null;
      end = null;
    }

    for (final s in segments) {
      final text = s.text.trim();
      if (text.isEmpty) continue;
      if (buf.isNotEmpty && buf.length + 1 + text.length > maxChars) flush();
      for (final piece in _hardSplit(text)) {
        if (buf.isNotEmpty && buf.length + 1 + piece.length > maxChars) {
          flush();
        }
        if (buf.isNotEmpty) buf.write(' ');
        buf.write(piece);
        start ??= s.startMs;
        end = s.endMs ?? s.startMs;
      }
    }
    flush();
    return out;
  }

  List<String> _packSentences(String text) {
    final out = <String>[];
    final buf = StringBuffer();
    for (final sentence in text.trim().split(_sentenceEnd)) {
      for (final piece in _hardSplit(sentence.trim())) {
        if (piece.isEmpty) continue;
        if (buf.isNotEmpty && buf.length + 1 + piece.length > maxChars) {
          out.add(buf.toString());
          buf.clear();
        }
        if (buf.isNotEmpty) buf.write(' ');
        buf.write(piece);
      }
    }
    if (buf.isNotEmpty) out.add(buf.toString());
    return out;
  }

  /// Breaks a run with no sentence end at whitespace (or mid-word as a last
  /// resort) so no chunk exceeds [maxChars].
  List<String> _hardSplit(String s) {
    if (s.length <= maxChars) return [s];
    final out = <String>[];
    var rest = s;
    while (rest.length > maxChars) {
      var cut = rest.lastIndexOf(' ', maxChars);
      if (cut <= 0) cut = maxChars;
      out.add(rest.substring(0, cut).trim());
      rest = rest.substring(cut).trim();
    }
    if (rest.isNotEmpty) out.add(rest);
    return out;
  }
}
