/// Where a Care Moment came from. Mirrors the "Capture Care" inputs.
enum SourceType {
  doctorAudio,
  nurseAudio,
  pharmacistAudio,
  familyVoice,
  prescription,
  labReport,
  dischargeSummary,
  medicinePackage,
  vitalReading,
  note,
  task,
}

/// One timed piece of a transcript, as speech-to-text emits it.
class TranscriptSegment {
  const TranscriptSegment(this.text, {required this.startMs, this.endMs});

  final String text;
  final int startMs;
  final int? endMs;
}

/// A single thing that happened in the care journey: a recorded
/// conversation, a scanned prescription, a BP reading, a family note.
///
/// Give [segments] for audio so answers can point at the exact clip;
/// otherwise [text] is chunked by sentence.
///
/// nomic-embed-text-v1 is an English model. For Telugu, Hindi or
/// code-mixed moments pass an English [translation] (Gemma 4 produces it at
/// capture time): that is what gets embedded, while [text] stays the source
/// of truth shown to the family and remains keyword-searchable.
class CareMoment {
  CareMoment({
    required this.id,
    required this.patientId,
    required this.sourceType,
    required this.createdAt,
    String? text,
    this.segments,
    this.sourceUri,
    this.author,
    this.language,
    this.translation,
    this.verified = false,
  }) : text = text ?? segments?.map((s) => s.text).join(' ') ?? '' {
    if (this.text.trim().isEmpty) {
      throw ArgumentError('CareMoment $id has no text');
    }
  }

  final String id;
  final String patientId;
  final SourceType sourceType;
  final DateTime createdAt;
  final String text;
  final List<TranscriptSegment>? segments;

  /// Original evidence: audio file, scan image, document.
  final String? sourceUri;

  /// Circle member who captured it.
  final String? author;

  /// BCP-47 hint from STT/OCR (e.g. `te`, `hi`, `en`); informational only.
  final String? language;

  /// English rendering of [text] when [text] is not English.
  final String? translation;

  /// What the embedding model sees.
  String get embeddingText => translation ?? text;

  /// Whether a family member confirmed the extracted content.
  final bool verified;
}

/// A retrieved chunk plus everything needed to cite it.
class Evidence {
  const Evidence({
    required this.chunkId,
    required this.momentId,
    required this.text,
    required this.originalText,
    required this.sourceType,
    required this.createdAt,
    required this.vectorScore,
    required this.fusedScore,
    this.keywordRank,
    this.sourceUri,
    this.author,
    this.startMs,
    this.endMs,
    this.verified = false,
  });

  final int chunkId;
  final String momentId;

  /// The chunk as embedded (English).
  final String text;

  /// The moment's original words, in the language they were captured in.
  final String originalText;

  final SourceType sourceType;
  final DateTime createdAt;
  final String? sourceUri;
  final String? author;

  /// Clip bounds within [sourceUri], when the source is audio.
  final int? startMs;
  final int? endMs;
  final bool verified;

  /// Cosine similarity between the question and this chunk.
  final double vectorScore;

  /// 1-based rank in keyword (FTS5) results; null if keyword search missed.
  final int? keywordRank;

  /// Reciprocal-rank-fusion score used for ordering.
  final double fusedScore;
}
