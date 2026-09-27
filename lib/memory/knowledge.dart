import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../data/care_models.dart';
import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../data/visit_models.dart';
import '../home/care_text.dart';
import '../l10n/language.dart';
import '../medicines/medicine_text.dart';
import '../onboarding/onboarding_state.dart';
import '../profile/person_details.dart';
import '../visits/visit_text.dart';
import 'smart_search.dart';

enum KnowledgeKind { note, scan, document, visit, medicine, profile }

/// One thing Gurtu knows about a person: a note, a scanned or shared
/// document, a doctor visit, a medicine. Built fresh from the care data, so
/// it is never out of date.
class KnowledgeDoc {
  const KnowledgeDoc({
    required this.id,
    required this.patientId,
    required this.kind,
    required this.title,
    required this.text,
    required this.date,
    this.momentId,
    this.visitId,
  });

  final String id;
  final String patientId;
  final KnowledgeKind kind;
  final String title;
  final String text;
  final DateTime date;
  final String? momentId;
  final String? visitId;

  String get body => [title, text].where((s) => s.isNotEmpty).join('\n');
}

class KnowledgeHit {
  const KnowledgeHit(this.doc, this.score);

  final KnowledgeDoc doc;

  /// 0–1: how well it answers the search.
  final double score;
}

/// The person's care memory, searchable by words (any language, instantly)
/// and, once [SmartSearch] is on the phone, by meaning. Meaning vectors are
/// worked out in the background and kept in a file, so searching stays
/// quick.
class KnowledgeBase extends ChangeNotifier {
  KnowledgeBase({
    required this.repo,
    this.smart,
    Future<File?> Function()? vectorFile,
  }) : _vectorFile = vectorFile ?? _defaultFile {
    repo.addListener(_changed);
    smart?.addListener(_changed);
    unawaited(_loadVectors());
  }

  final CareRepository repo;
  final SmartSearch? smart;
  final Future<File?> Function() _vectorFile;

  /// Labels for sample content; the app's language once a screen has
  /// searched.
  AppLocalizations l = lookupAppLocalizations(const Locale('en'));

  /// Doc id -> (text it was worked out from, its vector).
  final _vectors = <String, ({int hash, List<double> vector})>{};
  Timer? _debounce;
  bool _indexing = false;
  bool _disposed = false;

  static Future<File?> _defaultFile() async {
    if (kIsWeb) return null;
    try {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/knowledge_vectors.json');
    } on Object {
      return null;
    }
  }

  // --- What there is to know ---------------------------------------------------

  /// Everything saved about [patientId], newest first.
  List<KnowledgeDoc> docsFor(String? patientId) {
    if (patientId == null) return const [];
    final out = <KnowledgeDoc>[
      for (final m in repo.moments)
        if (m.patientId == patientId)
          KnowledgeDoc(
            id: 'moment:${m.id}',
            patientId: patientId,
            kind: switch (m.type) {
              MomentType.note || MomentType.voice => KnowledgeKind.note,
              MomentType.scan || MomentType.medicine => KnowledgeKind.scan,
              _ => KnowledgeKind.document,
            },
            title: l.momentTitle(m),
            // Gurtu AI's summary first: the gist, then every word.
            text: [
              m.summary,
              l.momentDetail(m),
            ].where((s) => s.trim().isNotEmpty).join('\n\n'),
            date: m.timestamp,
            momentId: m.id,
          ),
      for (final v in repo.visits)
        if (v.patientId == patientId) _visitDoc(v),
      for (final m in repo.medicines)
        if (m.patientId == patientId) _medicineDoc(m),
    ]..sort((a, b) => b.date.compareTo(a.date));
    // Who they are comes first, always.
    if (repo.patientById(patientId) case final p?) out.insert(0, profileDoc(p));
    return out;
  }

  /// The person's details from onboarding (and Profile), as one memory.
  KnowledgeDoc profileDoc(PatientProfile p) =>
      profileKnowledge(p, l, userName: repo.userName);

  KnowledgeDoc _visitDoc(DoctorVisit v) {
    final reason = l.reasonOf(v);
    final next = v.nextVisit;
    return KnowledgeDoc(
      id: 'visit:${v.id}',
      patientId: v.patientId,
      kind: KnowledgeKind.visit,
      title: [l.doctorLabel(v), if (reason.isNotEmpty) reason].join(' · '),
      text: [
        l.notesOf(v),
        l.medicinesOf(v),
        l.testsOf(v),
        if (next != null)
          '${l.nextVisit}: ${next.year}-${_two(next.month)}-${_two(next.day)}',
      ].where((s) => s.trim().isNotEmpty).join('\n'),
      date: v.date,
      visitId: v.id,
    );
  }

  KnowledgeDoc _medicineDoc(Medicine m) => KnowledgeDoc(
    id: 'medicine:${m.id}',
    patientId: m.patientId,
    kind: KnowledgeKind.medicine,
    title: m.label,
    text: [
      if (m.alsoCalled.isNotEmpty) m.alsoCalled,
      m.times.map(l.doseLabel).join(', '),
      if (m.food != FoodTiming.any) l.foodLabel(m.food),
    ].where((s) => s.isNotEmpty).join(' · '),
    date: m.createdAt,
  );

  static String _two(int n) => n.toString().padLeft(2, '0');

  // --- Search ------------------------------------------------------------------

  /// The best matches for [query] among [patientId]'s memory; everything,
  /// newest first, when the query is empty.
  Future<List<KnowledgeHit>> search(
    String query,
    String? patientId, {
    int limit = 30,
    Set<KnowledgeKind>? kinds,
  }) async {
    final docs = [
      for (final d in docsFor(patientId))
        if (kinds == null || kinds.contains(d.kind)) d,
    ];
    if (query.trim().isEmpty) {
      return [for (final d in docs.take(limit)) KnowledgeHit(d, 1)];
    }
    final lexical = WordIndex(docs).score(query);
    final meaning = await smart?.embed(query, query: true);
    final hits = <KnowledgeHit>[];
    for (final (i, d) in docs.indexed) {
      final lex = lexical[i];
      var score = lex;
      final v = _vectors[d.id];
      if (meaning != null && v != null && v.hash == _hash(d.body)) {
        // Gecko's similar texts score ~0.6-0.9; unrelated ones ~0.4-0.55.
        final sem = ((_cosine(meaning, v.vector) - 0.55) / 0.3).clamp(0.0, 1.0);
        score = math.max(lex, 0.5 * lex + 0.6 * sem).clamp(0.0, 1.0);
      }
      if (score >= 0.15) hits.add(KnowledgeHit(d, score));
    }
    hits.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      return byScore != 0 ? byScore : b.doc.date.compareTo(a.doc.date);
    });
    return hits.take(limit).toList();
  }

  // --- Meaning vectors, worked out in the background ---------------------------

  void _changed() {
    if (_disposed) return;
    notifyListeners();
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () => unawaited(_index()));
  }

  Future<void> _index() async {
    final smart = this.smart;
    if (_indexing || smart == null || !smart.isReady || _disposed) return;
    _indexing = true;
    var changed = false;
    try {
      final docs = [for (final p in repo.patients) ...docsFor(p.id)];
      final live = {for (final d in docs) d.id};
      final before = _vectors.length;
      _vectors.removeWhere((id, _) => !live.contains(id));
      changed = _vectors.length != before;
      for (final d in docs) {
        if (_disposed) return;
        final hash = _hash(d.body);
        if (_vectors[d.id]?.hash == hash) continue;
        final v = await smart.embed(d.body, query: false);
        if (v == null) break;
        _vectors[d.id] = (hash: hash, vector: v);
        changed = true;
      }
    } finally {
      _indexing = false;
      if (changed) await _saveVectors();
    }
  }

  Future<void> _loadVectors() async {
    try {
      final f = await _vectorFile();
      if (f == null || !await f.exists()) return;
      final j = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      for (final e in j.entries) {
        final m = e.value as Map<String, dynamic>;
        _vectors[e.key] = (
          hash: m['h'] as int,
          vector: [for (final x in m['v'] as List) (x as num).toDouble()],
        );
      }
    } on Object catch (e) {
      debugPrint('Search index unreadable, rebuilding: $e');
    }
    _changed();
  }

  Future<void> _saveVectors() async {
    try {
      final f = await _vectorFile();
      if (f == null) return;
      await f.writeAsString(
        jsonEncode({
          for (final e in _vectors.entries)
            e.key: {'h': e.value.hash, 'v': e.value.vector},
        }),
      );
    } on Object catch (e) {
      debugPrint('Search index not saved: $e');
    }
  }

  /// A stable hash (String.hashCode may change between runs).
  static int _hash(String s) {
    var h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0xffffffff;
    }
    return h;
  }

  static double _cosine(List<double> a, List<double> b) {
    if (a.length != b.length || a.isEmpty) return 0;
    var dot = 0.0, na = 0.0, nb = 0.0;
    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    return na == 0 || nb == 0 ? 0 : dot / (math.sqrt(na) * math.sqrt(nb));
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    repo.removeListener(_changed);
    smart?.removeListener(_changed);
    super.dispose();
  }
}

/// Word search that works in every Indian script: whole words, word starts
/// ("diab" finds "diabetes") and near spellings (three-letter pieces), each
/// weighted by how rare the word is.
class WordIndex {
  WordIndex(this.docs) : _words = [for (final d in docs) words(d.body)];

  final List<KnowledgeDoc> docs;
  final List<List<String>> _words;

  static final _word = RegExp(r'[\p{L}\p{M}\p{N}]+', unicode: true);

  static const _stop = {
    'a',
    'an',
    'the',
    'is',
    'are',
    'was',
    'of',
    'to',
    'in',
    'on',
    'for',
    'and',
    'or',
    'my',
    'me',
    'i',
    'what',
    'when',
    'where',
    'which',
    'did',
    'does',
    'do',
    'how',
    'about',
    'with',
    'at',
    'it',
    'this',
    'that',
    'be',
    'has',
    'have',
    'had',
    'can',
    'should',
    'we',
    'our',
    'her',
    'his',
    'there',
    'any',
    'tell',
    'show',
  };

  static List<String> words(String text) => [
    for (final m in _word.allMatches(text.toLowerCase())) m.group(0)!,
  ];

  static Set<String> _grams(String w) {
    final padded = ' $w ';
    return {
      for (var i = 0; i + 3 <= padded.length; i++) padded.substring(i, i + 3),
    };
  }

  /// A 0–1 score for every doc, in order.
  List<double> score(String query) {
    final q = {
      for (final w in words(query))
        if (!_stop.contains(w) && (w.length > 1 || RegExp(r'\d').hasMatch(w)))
          w,
    };
    if (q.isEmpty || docs.isEmpty) return List.filled(docs.length, 0);
    final sets = [for (final ws in _words) ws.toSet()];
    double idf(String w) {
      final n = sets.where((s) => s.contains(w)).length;
      return math.log((docs.length + 1) / (n + 0.5)) + 1;
    }

    final weights = {for (final w in q) w: idf(w)};
    final total = weights.values.fold(0.0, (a, b) => a + b);
    return [
      for (final s in sets)
        weights.entries.fold(
              0.0,
              (sum, e) => sum + e.value * _match(e.key, s),
            ) /
            total,
    ];
  }

  static double _match(String q, Set<String> doc) {
    if (doc.contains(q)) return 1;
    var best = 0.0;
    final qg = q.length >= 3 ? _grams(q) : const <String>{};
    for (final w in doc) {
      if (q.length >= 3 &&
          w.length >= 3 &&
          (w.startsWith(q) || q.startsWith(w))) {
        best = math.max(best, 0.8);
        continue;
      }
      if (qg.isEmpty || w.length < 3) continue;
      final wg = _grams(w);
      final common = qg.intersection(wg).length;
      final sim = common / (qg.length + wg.length - common);
      if (sim >= 0.45) best = math.max(best, 0.6 * sim);
    }
    return best;
  }
}

/// [p]'s details from onboarding (and Profile), in [l]'s language, as one
/// memory. [userName] is who looks after them.
KnowledgeDoc profileKnowledge(
  PatientProfile p,
  AppLocalizations l, {
  String userName = '',
}) {
  String? line(String label, String? value) =>
      value == null || value.isEmpty || value == l.notAdded
      ? null
      : '$label: $value';
  final medicines = switch (YesNoUnsure.values.asNameMap()[p.takesMedicines]) {
    null => null,
    YesNoUnsure.yes => [
      l.yes,
      ?l.oneOf(MedicineCount.values, p.medicineCount, (c) => c.label(l)),
    ].join(' · '),
    final v => v.label(l),
  };
  return KnowledgeDoc(
    id: 'profile:${p.id}',
    patientId: p.id,
    kind: KnowledgeKind.profile,
    title: l.aboutPerson(p.name),
    text: [
      ?line(p.isSelf ? l.yourName : l.whatDoYouCallThem, p.name),
      ?line(
        p.isSelf ? l.yourAge : l.theirAge,
        p.age == null ? null : l.ageYears(p.age!),
      ),
      ?line(l.gender, p.gender == null ? null : l.genderLabel(p.gender)),
      ?line(
        l.conditionsLabel,
        l.listOf(HealthCondition.values, p.conditions, (c) => c.label(l)),
      ),
      ?line(
        l.rowAllergies,
        l.listOf(Allergy.values, p.allergies, (a) => a.label(l)),
      ),
      ?line(l.dailyMedicinesLabel, medicines),
      ?line(
        l.gettingAroundLabel,
        l.oneOf(Mobility.values, p.mobility, (m) => m.label(l)),
      ),
      ?line(
        l.recentHospitalLabel,
        l.oneOf(YesNoUnsure.values, p.recentHospitalVisit, (v) => v.label(l)),
      ),
      if (!p.isSelf) ?line(l.yourName, userName),
    ].join('\n'),
    date: p.createdAt,
  );
}

class KnowledgeScope extends InheritedNotifier<KnowledgeBase> {
  const KnowledgeScope({
    super.key,
    required KnowledgeBase knowledge,
    required super.child,
  }) : super(notifier: knowledge);

  static KnowledgeBase of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<KnowledgeScope>()!.notifier!;

  static KnowledgeBase read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<KnowledgeScope>()!.notifier!;
}
