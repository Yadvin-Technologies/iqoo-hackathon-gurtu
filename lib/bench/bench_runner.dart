import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:path/path.dart' as p;

import '../memory/memory.dart';
import '../mock/mock_care_data.dart';
import 'bench_corpus.dart';
import 'device_probe.dart';

typedef BenchLog = void Function(String line);

/// Summary statistics over latency samples, in milliseconds.
class Stats {
  Stats(List<double> samples) : _s = [...samples]..sort();

  final List<double> _s;

  double pct(double q) {
    if (_s.isEmpty) return double.nan;
    return _s[((q / 100) * (_s.length - 1)).round()];
  }

  double get mean => _s.isEmpty ? double.nan : _s.reduce((a, b) => a + b) / _s.length;
  double get p50 => pct(50);
  double get p95 => pct(95);
  double get min => _s.isEmpty ? double.nan : _s.first;
  double get max => _s.isEmpty ? double.nan : _s.last;

  Map<String, Object> toJson() => {
    'n': _s.length,
    'mean': _r(mean),
    'p50': _r(p50),
    'p95': _r(p95),
    'min': _r(min),
    'max': _r(max),
  };

  @override
  String toString() =>
      'p50 ${p50.toStringAsFixed(1)} ms · p95 ${p95.toStringAsFixed(1)} ms · '
      'mean ${mean.toStringAsFixed(1)} ms (n=${_s.length})';
}

double _r(double x) => x.isNaN ? -1 : (x * 1000).roundToDouble() / 1000;
double _ms(Stopwatch sw) => sw.elapsedMicroseconds / 1000.0;
String _mb(int? b) => b == null ? '?' : '${(b / 1048576).toStringAsFixed(1)} MB';
String _pc(double x) => '${(x * 100).toStringAsFixed(0)}%';

/// Benchmarks the Nomic memory layer on the device and writes a JSON report.
class BenchRunner {
  BenchRunner({required this.embedder, required this.outDir, required this.log});

  final NomicEmbedder embedder;
  final String outDir;
  final BenchLog log;

  final Map<String, Object?> report = {};
  bool _cancelled = false;

  void cancel() => _cancelled = true;
  void _check() {
    if (_cancelled) throw const _Cancelled();
  }

  void _h(String title) => log('\n━━ $title');

  Future<String?> runAll({int loadTestMoments = 1000}) => _session('bench', () async {
    await device();
    model();
    _check();
    await reference();
    _check();
    await latency();
    _check();
    await throughput();
    _check();
    await quality();
    _check();
    await loadTest(loadTestMoments);
    _check();
    await scanScaling();
  });

  Future<String?> _session(String prefix, Future<void> Function() body) async {
    final started = DateTime.now();
    report
      ..clear()
      ..['startedAt'] = started.toIso8601String()
      ..['model'] = embedder.modelId;
    try {
      await body();
      log('\n✔ Done in ${DateTime.now().difference(started).inSeconds} s');
    } on _Cancelled {
      log('\n■ Cancelled');
      report['cancelled'] = true;
    } catch (e, st) {
      log('\n✖ $e');
      report['error'] = '$e\n$st';
    }
    return _save(started, prefix);
  }

  // ---- Sections -------------------------------------------------------------

  Future<void> device() async {
    _h('Device');
    try {
      final info = await DeviceProbe.info();
      final thermal = await DeviceProbe.thermal();
      report['device'] = {...info, 'thermalAtStart': thermal};
      log('${info['manufacturer']} ${info['model']} · SoC ${info['socModel']} · '
          'Android ${info['release']} (API ${info['sdkInt']}) · '
          '${info['cpuCores']} cores · RAM ${_mb(info['totalMemBytes'] as int?)}');
      log('Thermal ${DeviceProbe.thermalNames[thermal['status'] as int]} · '
          'headroom ${thermal['headroom']} · battery ${thermal['batteryTempC']} °C');
    } catch (e) {
      log('device info unavailable: $e');
    }
  }

  void model() {
    _h('Model');
    final rss = DeviceProbe.rssBytes();
    report['modelLoad'] = {
      'loadMs': embedder.loadTime.inMilliseconds,
      'dim': embedder.dimension,
      'seqLen': embedder.sequenceLength,
      'accelerator': embedder.accelerator.name,
      'file': embedder.paths.model,
      'fileBytes': embedder.paths.modelBytes,
      'processRssBytes': rss,
    };
    log('${embedder.modelId} · LiteRT INT8 ${_mb(embedder.paths.modelBytes)} via flutter_gemma_litertlm '
        '(${embedder.accelerator.name.toUpperCase()}) · '
        '${embedder.sequenceLength} tokens → ${embedder.dimension} dims · loaded in '
        '${embedder.loadTime.inMilliseconds} ms · process RSS ${_mb(rss)}');
  }

  /// Same inputs as Arm's published run → the phone must produce the same
  /// vectors. Catches tokenizer, input-order or numeric problems.
  Future<void> reference() async {
    _h('Correctness vs Arm reference · ${embedder.accelerator.name.toUpperCase()}');
    try {
      final ref = await NomicModel.fetchReference();
      final cos = <double>[];
      for (final (text, want) in ref) {
        cos.add(VectorCodec.cosine(await embedder.embedVerbatim(text), want));
        log('  ${cos.last.toStringAsFixed(5)}  $text');
      }
      final minCos = cos.reduce(math.min);
      report['reference'] = {'cosine': cos.map(_r).toList(), 'min': _r(minCos), 'pass': minCos >= 0.99};
      log(minCos >= 0.99
          ? 'PASS: on-device vectors match Arm\'s (min cosine ${minCos.toStringAsFixed(4)})'
          : '⚠ FAIL: min cosine ${minCos.toStringAsFixed(4)} < 0.99');
    } catch (e) {
      report['reference'] = {'error': '$e'};
      log('skipped (could not fetch reference): $e');
    }
  }

  Future<void> latency() async {
    _h('Latency');
    const warm = 'What did the doctor say about the evening medicine?';
    final longDoc = mockMoments.map((m) => m.embeddingText).join(' ').substring(0, 580);
    for (var i = 0; i < 3; i++) {
      await embedder.embedQuery(warm);
    }
    final q = <double>[], d = <double>[];
    for (var i = 0; i < 30; i++) {
      _check();
      final ev = evalQueries[i % evalQueries.length];
      final sw = Stopwatch()..start();
      await embedder.embedQuery(ev.english ?? ev.text);
      q.add(_ms(sw));
    }
    for (var i = 0; i < 15; i++) {
      _check();
      final sw = Stopwatch()..start();
      await embedder.embedDocuments([longDoc]);
      d.add(_ms(sw));
    }
    report['latency'] = {'query': Stats(q).toJson(), 'doc580chars': Stats(d).toJson()};
    log('question   ${Stats(q)}');
    log('580 chars  ${Stats(d)}');
  }

  Future<void> throughput() async {
    _h('Throughput');
    final texts = List.generate(128, (i) => mockMoments[i % mockMoments.length].embeddingText);
    final sw = Stopwatch()..start();
    await embedder.embedDocuments(texts);
    final s = sw.elapsedMicroseconds / 1e6;
    report['throughput'] = {'docs': texts.length, 'seconds': _r(s), 'docsPerSec': _r(texts.length / s)};
    log('${texts.length} moments in ${s.toStringAsFixed(2)} s → '
        '${(texts.length / s).toStringAsFixed(1)} moments/s');
  }

  /// Retrieval quality on the mock record: per storage format, translated
  /// vs untranslated, and the full hybrid pipeline with its evidence gate.
  Future<void> quality() async {
    _h('Retrieval quality (mock record, ${evalQueries.length} questions)');
    final ids = mockMoments.map((m) => m.id).toList();
    final docsEn = await embedder.embedDocuments(mockMoments.map((m) => m.embeddingText).toList());
    final qsEn = <Float32List>[
      for (final q in evalQueries) await embedder.embedQuery(q.english ?? q.text),
    ];

    ({double hit1, double hit5, double mrr, List<double> ans, List<double> unans}) eval(
      List<Float32List> docs,
      List<Float32List> qs,
      int dims,
      bool int8,
    ) {
      final enc = [
        for (final d in docs)
          () {
            final t = VectorCodec.truncateNormalize(d, dims);
            if (!int8) return t;
            final (q, s) = VectorCodec.quantize(t);
            return VectorCodec.dequantize(q, s);
          }(),
      ];
      var h1 = 0, h5 = 0, n = 0;
      var mrr = 0.0;
      final ans = <double>[], unans = <double>[];
      for (var qi = 0; qi < evalQueries.length; qi++) {
        final qv = VectorCodec.truncateNormalize(qs[qi], dims);
        final scored = [
          for (var di = 0; di < enc.length; di++) (ids[di], VectorCodec.dot(qv, enc[di])),
        ]..sort((a, b) => b.$2.compareTo(a.$2));
        final rel = evalQueries[qi].relevant;
        if (rel.isEmpty) {
          unans.add(scored.first.$2);
          continue;
        }
        n++;
        ans.add(scored.first.$2);
        final rank = scored.indexWhere((s) => rel.contains(s.$1)) + 1;
        if (rank == 1) h1++;
        if (rank >= 1 && rank <= 5) h5++;
        if (rank >= 1) mrr += 1 / rank;
      }
      return (hit1: h1 / n, hit5: h5 / n, mrr: mrr / n, ans: ans, unans: unans);
    }

    final formats = <String, Object>{};
    List<double>? ans, unans;
    // v1 is not Matryoshka-trained: 512/256 show what truncation would cost.
    for (final (dims, int8) in [(768, false), (768, true), (512, true), (256, true)]) {
      final r = eval(docsEn, qsEn, dims, int8);
      final name = '${int8 ? 'int8' : 'f32'}@$dims';
      final bytes = int8 ? dims + 4 : dims * 4;
      formats[name] = {'hit@1': _r(r.hit1), 'hit@5': _r(r.hit5), 'mrr': _r(r.mrr), 'bytesPerVector': bytes};
      log('${name.padRight(9)} hit@1 ${_pc(r.hit1)}  hit@5 ${_pc(r.hit5)}  '
          'MRR ${r.mrr.toStringAsFixed(3)}  ${bytes.toString().padLeft(4)} B/vector');
      if (name == 'int8@768') {
        ans = r.ans;
        unans = r.unans;
      }
    }
    report['qualityFormats'] = formats;

    // Why translation matters: embed the original words instead.
    final docsRaw = await embedder.embedDocuments(mockMoments.map((m) => m.text).toList());
    final qsRaw = <Float32List>[for (final q in evalQueries) await embedder.embedQuery(q.text)];
    final raw = eval(docsRaw, qsRaw, 768, true);
    final en = eval(docsEn, qsEn, 768, true);
    report['translationEffect'] = {
      'translated': {'hit@1': _r(en.hit1), 'hit@5': _r(en.hit5), 'mrr': _r(en.mrr)},
      'originalWords': {'hit@1': _r(raw.hit1), 'hit@5': _r(raw.hit5), 'mrr': _r(raw.mrr)},
    };
    log('untranslated originals (int8@768): hit@1 ${_pc(raw.hit1)}  hit@5 ${_pc(raw.hit5)}  '
        '→ with English renderings: hit@1 ${_pc(en.hit1)}  hit@5 ${_pc(en.hit5)}');

    // Evidence gate: similarity cut that best separates answerable top-1
    // scores from unanswerable ones.
    var bestT = 0.5, bestAcc = -1.0;
    for (var t = 0.20; t <= 0.90; t += 0.01) {
      final acc = (ans!.where((s) => s >= t).length + unans!.where((s) => s < t).length) /
          (ans.length + unans.length);
      if (acc > bestAcc) {
        bestAcc = acc;
        bestT = t;
      }
    }
    log('top-1 cosine · answerable ${Stats(ans!).min.toStringAsFixed(3)}–${Stats(ans).max.toStringAsFixed(3)} '
        '· unanswerable ${Stats(unans!).min.toStringAsFixed(3)}–${Stats(unans).max.toStringAsFixed(3)}');
    log('suggested minSimilarity ${bestT.toStringAsFixed(2)} (separates ${_pc(bestAcc)})');

    // Full pipeline: chunker → int8@768 store → hybrid → gate.
    final memory = CareMemory.inMemory(
      embedder: embedder,
      config: MemoryConfig(minSimilarity: bestT),
    );
    try {
      await memory.addMoments(mockMoments);
      var h1 = 0, h5 = 0, answered = 0, abstained = 0;
      var mrr = 0.0;
      final misses = <String>[];
      final nA = evalQueries.where((q) => q.answerable).length;
      final nU = evalQueries.length - nA;
      for (final q in evalQueries) {
        final ev = await memory.retrieve(q.text, englishQuestion: q.english);
        final got = ev.map((x) => x.momentId).toList();
        if (!q.answerable) {
          if (got.isEmpty) {
            abstained++;
          } else {
            misses.add('${q.id} should abstain, got ${got.take(3).join(',')} '
                '(${ev.first.vectorScore.toStringAsFixed(2)}) · ${q.text}');
          }
          continue;
        }
        if (got.isNotEmpty) answered++;
        final rank = got.indexWhere(q.relevant.contains) + 1;
        if (rank == 1) h1++;
        if (rank >= 1) {
          h5++;
          mrr += 1 / rank;
        }
        if (rank != 1) {
          misses.add('${q.id} rank ${rank == 0 ? '–' : rank}: got ${got.take(3).join(',')} '
              'want ${q.relevant.join(',')} · ${q.text}');
        }
      }
      final telma = await memory.retrieve(evalQueries[1].text);
      final conflict = {'e2', 'e15'}.every(telma.map((x) => x.momentId).contains);
      report['qualityHybrid'] = {
        'minSimilarity': _r(bestT),
        'hit@1': _r(h1 / nA),
        'hit@5': _r(h5 / nA),
        'mrr': _r(mrr / nA),
        'answeredRate': _r(answered / nA),
        'abstainRate': _r(abstained / nU),
        'conflictSurfaced': conflict,
        'misses': misses,
      };
      log('hybrid    hit@1 ${_pc(h1 / nA)}  hit@5 ${_pc(h5 / nA)}  MRR ${(mrr / nA).toStringAsFixed(3)}');
      log('evidence gate: answered ${_pc(answered / nA)} of answerable · '
          'abstained on ${_pc(abstained / nU)} of unanswerable');
      log('Telma conflict (Rx "before" vs doctor "after") both surfaced: ${conflict ? 'yes' : 'NO'}');
      for (final m in misses) {
        log('  · $m');
      }
    } finally {
      memory.close();
    }
  }

  /// Bulk ingest into an on-disk store, then retrieval latency at that size.
  Future<void> loadTest(int n) async {
    _h('Load test · $n moments');
    final dbPath = p.join(outDir, 'loadtest.db');
    Directory(outDir).createSync(recursive: true);
    for (final suffix in ['', '-wal', '-shm']) {
      final f = File('$dbPath$suffix');
      if (f.existsSync()) f.deleteSync();
    }
    final memory = await CareMemory.open(dbPath: dbPath, embedder: embedder);
    try {
      final moments = syntheticMoments(n);
      const batch = 64;
      final batchMs = <double>[];
      final total = Stopwatch()..start();
      for (var i = 0; i < moments.length; i += batch) {
        _check();
        final sw = Stopwatch()..start();
        await memory.addMoments(moments.sublist(i, math.min(i + batch, moments.length)));
        batchMs.add(_ms(sw));
        if ((i ~/ batch) % 4 == 3) {
          log('  ${math.min(i + batch, n)}/$n · ${(batch / (batchMs.last / 1000)).toStringAsFixed(1)} moments/s');
        }
      }
      total.stop();
      final secs = total.elapsedMicroseconds / 1e6;
      final s = memory.store.stats();
      log('ingested $n moments (${s.chunks} chunks) in ${secs.toStringAsFixed(1)} s → '
          '${(n / secs).toStringAsFixed(1)} moments/s');
      log('vectors ${_mb(s.vectorBytes)} · text ${_mb(s.textBytes)} · db file ${_mb(s.databaseBytes)} '
          '· RAM index ${_mb(s.indexBytes)} (float32@768 would be ${_mb(s.float32Bytes(768))})');

      final qs = evalQueries;
      final e2e = <double>[], searchOnly = <double>[];
      final qvecs = <Float32List>[];
      for (var i = 0; i < 40; i++) {
        _check();
        final q = qs[i % qs.length];
        final sw = Stopwatch()..start();
        await memory.retrieve(q.text, englishQuestion: q.english,
            filter: SearchFilter(patientId: 'p${i % 4}'));
        e2e.add(_ms(sw));
        if (i < qs.length) {
          qvecs.add(VectorCodec.truncateNormalize(
            await embedder.embedQuery(q.english ?? q.text), memory.config.dims));
        }
      }
      for (var i = 0; i < 40; i++) {
        final sw = Stopwatch()..start();
        memory.retrieveWithVector(qs[i % qvecs.length].text, qvecs[i % qvecs.length]);
        searchOnly.add(_ms(sw));
      }
      report['loadTest'] = {
        'moments': n,
        'chunks': s.chunks,
        'seconds': _r(secs),
        'momentsPerSec': _r(n / secs),
        'batchMs': Stats(batchMs).toJson(),
        'vectorBytes': s.vectorBytes,
        'textBytes': s.textBytes,
        'dbBytes': s.databaseBytes,
        'indexBytes': s.indexBytes,
        'retrieveEndToEnd': Stats(e2e).toJson(),
        'searchOnly': Stats(searchOnly).toJson(),
      };
      log('retrieve (embed question + hybrid search)  ${Stats(e2e)}');
      log('search only (vector + keyword + gate)      ${Stats(searchOnly)}');
    } finally {
      memory.close();
    }
  }

  /// Exact-scan cost beyond a family's memory, on random int8 vectors.
  Future<void> scanScaling() async {
    _h('Vector scan scaling · int8@768');
    const dims = 768;
    final rnd = math.Random(1);
    final out = <String, Object>{};
    final q = VectorCodec.truncateNormalize(List.generate(dims, (_) => rnd.nextDouble() * 2 - 1), dims);
    for (final n in [10000, 50000, 100000]) {
      _check();
      final m = Int8List(n * dims);
      for (var i = 0; i < m.length; i++) {
        m[i] = rnd.nextInt(255) - 127;
      }
      final times = <double>[];
      for (var r = 0; r < 5; r++) {
        final sw = Stopwatch()..start();
        var best = -1e9;
        for (var row = 0; row < n; row++) {
          final s = VectorCodec.dotQuantized(q, m, row * dims, 0.01);
          if (s > best) best = s;
        }
        times.add(_ms(sw));
      }
      out['$n'] = Stats(times).toJson();
      log('${n.toString().padLeft(7)} vectors (${_mb(n * dims)})  ${Stats(times).p50.toStringAsFixed(1)} ms');
      await Future<void>.delayed(Duration.zero);
    }
    report['scanScaling'] = out;
  }

  /// Continuous embedding for [seconds], sampling throughput and thermals
  /// every 10 s: does the CPU hold its rate, and how hot does the phone get?
  Future<String?> sustained({int seconds = 60}) => _session('sustained', () async {
    _h('Sustained load · $seconds s');
    await device();
    final texts = List.generate(16, (i) => mockMoments[i % mockMoments.length].embeddingText);
    final windows = <Map<String, Object?>>[];
    final total = Stopwatch()..start();
    final window = Stopwatch()..start();
    var windowDocs = 0, allDocs = 0;
    while (total.elapsed.inSeconds < seconds) {
      _check();
      await embedder.embedDocuments(texts);
      windowDocs += texts.length;
      allDocs += texts.length;
      if (window.elapsed.inSeconds >= 10) {
        final rate = windowDocs / (window.elapsedMicroseconds / 1e6);
        final t = await DeviceProbe.thermal();
        windows.add({'t': total.elapsed.inSeconds, 'docsPerSec': _r(rate), ...t});
        log('${total.elapsed.inSeconds.toString().padLeft(4)} s  ${rate.toStringAsFixed(1)} moments/s  '
            'thermal ${DeviceProbe.thermalNames[t['status'] as int]}  '
            'headroom ${(t['headroom'] as num?)?.toStringAsFixed(2)}  battery ${t['batteryTempC']} °C');
        windowDocs = 0;
        window.reset();
      }
    }
    final avg = allDocs / (total.elapsedMicroseconds / 1e6);
    final first = windows.isEmpty ? avg : windows.first['docsPerSec'] as double;
    final last = windows.isEmpty ? avg : windows.last['docsPerSec'] as double;
    report['sustained'] = {
      'seconds': seconds,
      'docs': allDocs,
      'avgDocsPerSec': _r(avg),
      'windows': windows,
      'lastVsFirst': _r(last / first),
    };
    log('avg ${avg.toStringAsFixed(1)} moments/s · last window at ${_pc(last / first)} of first');
  });

  Future<String?> _save(DateTime started, String prefix) async {
    try {
      Directory(outDir).createSync(recursive: true);
      final stamp = started.toIso8601String().replaceAll(RegExp(r'[:.]'), '-').substring(0, 19);
      final path = p.join(outDir, '${prefix}_$stamp.json');
      File(path).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));
      log('report → $path');
      return path;
    } catch (e) {
      log('could not save report: $e');
      return null;
    }
  }
}

class _Cancelled implements Exception {
  const _Cancelled();
}
