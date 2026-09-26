import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/memory/memory.dart';

CareMoment moment(
  String id,
  String text, {
  String patient = 'amma',
  SourceType source = SourceType.note,
  DateTime? at,
}) => CareMoment(
  id: id,
  patientId: patient,
  sourceType: source,
  createdAt: at ?? DateTime(2026, 9, 20),
  text: text,
);

void main() {
  group('VectorCodec', () {
    test('truncateNormalize yields unit vectors', () {
      final v = List<double>.generate(768, (i) => math.sin(i.toDouble()));
      for (final d in [768, 512, 256, 128]) {
        final t = VectorCodec.truncateNormalize(v, d);
        expect(t.length, d);
        expect(VectorCodec.dot(t, t), closeTo(1, 1e-5));
      }
    });

    test('int8 round trip keeps cosine above 0.999', () {
      final rnd = math.Random(7);
      for (var n = 0; n < 50; n++) {
        final v = VectorCodec.truncateNormalize(
          List<double>.generate(256, (_) => rnd.nextDouble() * 2 - 1),
          256,
        );
        final (q, scale) = VectorCodec.quantize(v);
        final back = VectorCodec.dequantize(q, scale);
        expect(VectorCodec.cosine(v, back), greaterThan(0.999));
        // Asymmetric score equals the float dot of the dequantized vector.
        expect(
          VectorCodec.dotQuantized(v, q, 0, scale),
          closeTo(VectorCodec.dot(v, back), 1e-4),
        );
      }
    });
  });

  group('Chunker', () {
    test('keeps chunks within budget and splits on sentence ends', () {
      final text = List.generate(
        40,
        (i) => 'Sentence number $i about the medicine schedule.',
      ).join(' ');
      final chunks = const Chunker(maxChars: 200).split(moment('m', text));
      expect(chunks.length, greaterThan(1));
      for (final c in chunks) {
        expect(c.text.length, lessThanOrEqualTo(200));
        expect(c.text.endsWith('.'), isTrue);
      }
      expect(chunks.map((c) => c.text).join(' '), text);
    });

    test('splits Devanagari on danda', () {
      final chunks = const Chunker(maxChars: 30).split(
        moment('m', 'दवा खाने के बाद लेनी है। सुबह और शाम दोनों समय।'),
      );
      expect(chunks.map((c) => c.text), [
        'दवा खाने के बाद लेनी है।',
        'सुबह और शाम दोनों समय।',
      ]);
    });

    test('merged transcript chunks keep clip bounds', () {
      final m = CareMoment(
        id: 'a',
        patientId: 'amma',
        sourceType: SourceType.doctorAudio,
        createdAt: DateTime(2026),
        segments: const [
          TranscriptSegment('Take Metformin after breakfast.', startMs: 1000, endMs: 3000),
          TranscriptSegment('And after dinner.', startMs: 3000, endMs: 4500),
          TranscriptSegment('Come back in two weeks with the HbA1c report.', startMs: 9000, endMs: 12000),
        ],
      );
      final chunks = const Chunker(maxChars: 50).split(m);
      expect(chunks.first.text, 'Take Metformin after breakfast. And after dinner.');
      expect((chunks.first.startMs, chunks.first.endMs), (1000, 4500));
      expect((chunks.last.startMs, chunks.last.endMs), (9000, 12000));
    });
  });

  group('CareMemory (hashing embedder)', () {
    late CareMemory memory;

    setUp(() async {
      memory = CareMemory.inMemory(
        embedder: HashingEmbedder(),
        config: const MemoryConfig(minSimilarity: 0.2, keywordFloor: 0.0),
      );
      await memory.addMoments([
        moment('bp', 'BP reading 150/95 in the morning, felt dizzy.',
            source: SourceType.vitalReading, at: DateTime(2026, 9, 21)),
        moment('telma', 'Telma 40 once daily before breakfast.',
            source: SourceType.prescription, at: DateTime(2026, 9, 18)),
        moment('lab', 'Blood test tomorrow 9 AM at Vijaya Diagnostics.',
            source: SourceType.task, at: DateTime(2026, 9, 22)),
        moment('dad', 'Dad BP 120/80.', patient: 'nanna',
            source: SourceType.vitalReading),
      ]);
    });

    tearDown(() => memory.close());

    test('keyword hit on a drug name ranks first', () async {
      final ev = await memory.retrieve('When should she take Telma?');
      expect(ev.first.momentId, 'telma');
      expect(ev.first.keywordRank, 1);
    });

    test('patient filter excludes other patients', () async {
      final ev = await memory.retrieve(
        'BP reading',
        filter: const SearchFilter(patientId: 'amma'),
      );
      expect(ev.map((e) => e.momentId), isNot(contains('dad')));
      expect(ev.map((e) => e.momentId), contains('bp'));
    });

    test('time and source filters', () async {
      final ev = await memory.retrieve(
        'BP reading blood test',
        filter: SearchFilter(
          since: DateTime(2026, 9, 22),
          sources: {SourceType.task},
        ),
      );
      expect(ev.map((e) => e.momentId), ['lab']);
    });

    test('re-adding a moment replaces its chunks', () async {
      await memory.addMoment(
        moment('telma', 'Telma 40 changed to after dinner.',
            source: SourceType.prescription),
      );
      expect(memory.store.chunkCount, 4);
      final ev = await memory.retrieve('Telma dinner');
      expect(ev.first.text, contains('after dinner'));
    });

    test('delete removes from both indexes', () async {
      memory.deleteMoment('telma');
      final ev = await memory.retrieve('Telma');
      expect(ev.map((e) => e.momentId), isNot(contains('telma')));
      expect(memory.store.chunkCount, 3);
    });

    test('unrelated question returns no evidence at a strict threshold', () {
      final strict = CareMemory.inMemory(
        embedder: HashingEmbedder(),
        config: const MemoryConfig(minSimilarity: 0.9, keywordFloor: 0.9),
      );
      addTearDown(strict.close);
      final q = VectorCodec.truncateNormalize(
        Float32List.fromList(List.filled(768, 1.0)),
        768,
      );
      expect(strict.retrieveWithVector('zzz qqq', q), isEmpty);
    });

    test('prompt context numbers sources', () async {
      final ev = await memory.retrieve('Telma');
      final ctx = CareMemory.formatForPrompt(ev);
      expect(ctx, startsWith('[S1] (prescription'));
      expect(CareMemory.formatForPrompt(const []), contains('NO EVIDENCE'));
    });
  });

  test('translated moments embed English but keep original searchable', () async {
    final memory = CareMemory.inMemory(
      embedder: HashingEmbedder(),
      config: const MemoryConfig(minSimilarity: 0.2, keywordFloor: 0.0),
    );
    addTearDown(memory.close);
    await memory.addMoment(CareMoment(
      id: 't3',
      patientId: 'amma',
      sourceType: SourceType.note,
      createdAt: DateTime(2026, 9, 21),
      language: 'te',
      text: 'అమ్మ ఈ రోజు మధ్యాహ్నం భోజనం తర్వాత ఎకోస్ప్రిన్ వేసుకుంది.',
      translation: 'Amma took Ecosprin today after lunch.',
    ));
    final chunk = memory.store.chunksOf('t3').single;
    expect(chunk.text, 'Amma took Ecosprin today after lunch.');
    expect(chunk.original, startsWith('అమ్మ'));
    expect(chunk.vector.length, 768);

    // Telugu keyword hits the original; English question hits the embedding.
    final te = await memory.retrieve('ఎకోస్ప్రిన్');
    expect(te.single.originalText, startsWith('అమ్మ'));
    expect(te.single.keywordRank, 1);
    final en = await memory.retrieve('Ecosprin after lunch');
    expect(en.first.text, contains('Ecosprin'));

    final s = memory.store.stats();
    expect((s.moments, s.chunks, s.vectorBytes), (1, 1, 772));
  });

  test('FTS query builder drops short words and stopwords', () {
    expect(MemoryStore.ftsQuery('What did the doctor say about BP?'), '"doctor"');
    expect(MemoryStore.ftsQuery('to be'), isNull);
    expect(MemoryStore.ftsQuery('మందు ఎప్పుడు'), '"మందు" OR "ఎప్పుడు"');
  });
}
