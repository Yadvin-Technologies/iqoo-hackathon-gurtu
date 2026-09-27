import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../ai/medicine_check.dart';
import '../ai/on_device_ai.dart';
import '../data/attachment_store.dart';
import '../data/medicine_models.dart';
import '../data/visit_models.dart';

/// The clock time each dose slot is reminded at.
const slotTimes = {
  DoseTime.morning: '08:00',
  DoseTime.afternoon: '13:00',
  DoseTime.evening: '18:00',
  DoseTime.night: '21:00',
};

/// One medicine from a visit, as it will be reminded: read from the
/// doctor's notes (and the photo's printed text), then checked by the
/// family on the review screen.
class PlannedMedicine {
  PlannedMedicine({
    required this.visitMedicineId,
    required this.name,
    this.strength = '',
    Set<DoseTime>? times,
    this.food = FoodTiming.any,
    this.days,
    this.note = '',
    this.photoFile,
    this.audioFile,
    this.byAi = false,
    this.source,
  }) : times = times ?? {};

  final String visitMedicineId;
  String name;
  String strength;
  final Set<DoseTime> times;
  FoodTiming food;

  /// A course (e.g. 5 days); null: every day until changed.
  int? days;

  /// Short words shown with the reminder ("with warm water").
  String note;

  /// Attachment file names (see `AttachmentStore`).
  final String? photoFile;
  final String? audioFile;

  /// Read by Gurtu AI (rather than the built-in rules).
  bool byAi;

  /// What it was read from (see [MedicinePlanner.sourceOf]). When the
  /// medicine's notes or photo change, automatic reminders read it again;
  /// null for plans from before, which are left as the family set them.
  String? source;

  bool get isOn => name.trim().isNotEmpty && times.isNotEmpty;

  String get label =>
      [name.trim(), strength.trim()].where((s) => s.isNotEmpty).join(' ');

  List<DoseTime> get orderedTimes => [
    for (final t in DoseTime.values)
      if (times.contains(t)) t,
  ];

  Map<String, dynamic> toJson() => {
    'visitMedicineId': visitMedicineId,
    'name': name,
    'strength': strength,
    'times': [for (final t in orderedTimes) t.name],
    'food': food.name,
    'days': days,
    'note': note,
    'photoFile': photoFile,
    'audioFile': audioFile,
    'byAi': byAi,
    'source': source,
  };

  factory PlannedMedicine.fromJson(Map<String, dynamic> j) => PlannedMedicine(
    visitMedicineId: j['visitMedicineId'] as String,
    name: j['name'] as String? ?? '',
    strength: j['strength'] as String? ?? '',
    times: {
      for (final t in j['times'] as List? ?? const [])
        ?DoseTime.values.asNameMap()[t],
    },
    food: FoodTiming.values.asNameMap()[j['food']] ?? FoodTiming.any,
    days: j['days'] as int?,
    note: j['note'] as String? ?? '',
    photoFile: j['photoFile'] as String?,
    audioFile: j['audioFile'] as String?,
    byAi: j['byAi'] as bool? ?? false,
    source: j['source'] as String?,
  );
}

/// Printed text on a photo, read on the phone (ML Kit). Behind an interface
/// so tests run without it.
abstract class PhotoTextReader {
  static PhotoTextReader instance = DevicePhotoTextReader();

  Future<String> read(String path);
}

class DevicePhotoTextReader implements PhotoTextReader {
  @override
  Future<String> read(String path) async {
    if (kIsWeb) return '';
    final recognizer = TextRecognizer();
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(path),
      );
      return result.text;
    } on Object catch (e) {
      debugPrint('Reading the medicine photo failed: $e');
      return '';
    } finally {
      await recognizer.close().catchError((Object _) {});
    }
  }
}

/// Reads when and how to take a medicine from what the family wrote or
/// said, in English, Hindi or Telugu (and the usual prescription short
/// forms). The fallback when Gurtu AI isn't on this phone, and a check on
/// what it answers.
class MedicineRules {
  const MedicineRules();

  static final _words = <DoseTime, List<String>>{
    DoseTime.morning: [
      'morning',
      'breakfast',
      'am',
      'subah',
      'savere',
      'सुबह',
      'सवेरे',
      'नाश्ते',
      'ఉదయం',
      'పొద్దున',
      'టిఫిన్',
    ],
    DoseTime.afternoon: [
      'afternoon',
      'lunch',
      'noon',
      'dopahar',
      'दोपहर',
      'लंच',
      'మధ్యాహ్నం',
      'భోజనం',
    ],
    DoseTime.evening: ['evening', 'shaam', 'शाम', 'సాయంత్రం'],
    DoseTime.night: [
      'night',
      'dinner',
      'bedtime',
      'bed time',
      'pm',
      'raat',
      'रात',
      'सोने',
      'రాత్రి',
      'పడుకునే',
    ],
  };

  /// What the text says, as far as rules can tell.
  PlannedMedicine read(
    String text, {
    required String visitMedicineId,
    String? photoFile,
    String? audioFile,
  }) {
    final lower = ' ${text.toLowerCase()} ';
    final line = text.replaceAll('\n', ' ');
    final draft = const PrescriptionReader().readPrescription(text).firstOrNull;
    final strip = const PrescriptionReader().readStrip(text);
    final times = <DoseTime>{...?draft?.times};
    if (times.isEmpty) times.addAll(_timesFromWords(lower));
    if (times.isEmpty) times.addAll(_timesFromCount(lower));
    return PlannedMedicine(
      visitMedicineId: visitMedicineId,
      name: _nameOnly(draft?.name ?? strip?.name ?? _firstWords(line)),
      strength: draft?.strength ?? readStrengths(line).firstOrNull ?? '',
      times: times,
      food: _food(lower) ?? draft?.food ?? FoodTiming.any,
      days: _days(lower),
      photoFile: photoFile,
      audioFile: audioFile,
    );
  }

  static Set<DoseTime> _timesFromWords(String lower) => {
    for (final e in _words.entries)
      if (e.value.any((w) => _has(lower, w))) e.key,
  };

  /// "twice a day", "दिन में दो बार", "రోజుకు రెండు సార్లు".
  static Set<DoseTime> _timesFromCount(String lower) {
    bool any(List<String> ws) => ws.any((w) => lower.contains(w));
    if (any(['four times', '4 times', 'चार बार', 'నాలుగు సార్లు', 'qid'])) {
      return DoseTime.values.toSet();
    }
    if (any([
      'three times',
      'thrice',
      '3 times',
      'तीन बार',
      'మూడు సార్లు',
      'tds',
      'tid',
    ])) {
      return {DoseTime.morning, DoseTime.afternoon, DoseTime.night};
    }
    if (any([
      'twice',
      'two times',
      '2 times',
      'दो बार',
      'రెండు సార్లు',
      'bd ',
      'bid',
    ])) {
      return {DoseTime.morning, DoseTime.night};
    }
    if (any([
      'once a day',
      'once daily',
      'one time',
      'एक बार',
      'ఒకసారి',
      'రోజుకు ఒక',
      ' od ',
    ])) {
      return {DoseTime.morning};
    }
    return {};
  }

  static FoodTiming? _food(String lower) {
    bool any(List<String> ws) => ws.any((w) => lower.contains(w));
    if (any([
      'before food',
      'before meal',
      'before breakfast',
      'empty stomach',
      'खाने से पहले',
      'खाली पेट',
      'భోజనానికి ముందు',
      'ఖాళీ కడుపు',
      ' ac ',
    ])) {
      return FoodTiming.beforeFood;
    }
    if (any([
      'after food',
      'after meal',
      'after breakfast',
      'after lunch',
      'after dinner',
      'खाने के बाद',
      'భోజనం తర్వాత',
      'తిన్న తర్వాత',
      ' pc ',
    ])) {
      return FoodTiming.afterFood;
    }
    return null;
  }

  /// "for 5 days", "5 दिन", "5 రోజులు", "1 week". Not "दिन में" or
  /// "రోజుకు" ("a day"), which follow a strength as often as a count.
  static int? _days(String lower) {
    final d = RegExp(r'(\d{1,3})\s*(days?\b|दिन(?!\s*में)|రోజులు|రోజు(?!కు))')
        .firstMatch(lower);
    if (d != null) return int.parse(d.group(1)!).clamp(1, 365);
    final w = RegExp(r'(\d{1,2})\s*(weeks?|हफ्ते|సప్తాహ|వారా)')
        .firstMatch(lower);
    if (w != null) return (int.parse(w.group(1)!) * 7).clamp(1, 365);
    return null;
  }

  static bool _has(String lower, String word) {
    // Short Latin words ("am", "pm") only as whole words.
    if (RegExp(r'^[a-z ]+$').hasMatch(word) && word.length <= 3) {
      return RegExp('\\b${RegExp.escape(word)}\\b').hasMatch(lower);
    }
    return lower.contains(word);
  }

  /// Words that say how to take a medicine, never part of its name.
  static const _instructionWords = {
    'a',
    'after',
    'afternoon',
    'at',
    'bd',
    'bedtime',
    'before',
    'bid',
    'breakfast',
    'daily',
    'day',
    'days',
    'dinner',
    'empty',
    'evening',
    'food',
    'for',
    'hs',
    'lunch',
    'meal',
    'meals',
    'morning',
    'night',
    'od',
    'once',
    'per',
    'qid',
    'sos',
    'stomach',
    'take',
    'tds',
    'thrice',
    'tid',
    'time',
    'times',
    'twice',
    'week',
    'weeks',
    'with',
  };

  /// [name] up to the first instruction word ("Paracetamol Twice Day" is
  /// "Paracetamol").
  static String _nameOnly(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    final kept = words
        .takeWhile((w) => !_instructionWords.contains(w.toLowerCase()))
        .toList();
    return kept.isEmpty ? name.trim() : kept.join(' ');
  }

  /// The first two words, for a name when nothing better is found.
  static String _firstWords(String line) {
    final words = [
      for (final w in line.split(RegExp(r'\s+')))
        if (w.trim().isNotEmpty && !RegExp(r'^\d').hasMatch(w)) w.trim(),
    ];
    return words.take(2).join(' ');
  }
}

/// Turns a visit's medicines into reminders to review. Gurtu AI (Gemma, on
/// this phone) reads the notes and the photo's printed text when it is
/// installed; the built-in rules otherwise, and wherever its answer isn't
/// usable.
class MedicinePlanner {
  const MedicinePlanner({this.ai});

  final GurtuAi? ai;

  static const _system =
      'You read medicine instructions a doctor gave an Indian family. The '
      'notes may be English, Hindi, Telugu or mixed. Reply with JSON only, '
      'no other text: {"name": string, "strength": string, "times": '
      'array of "morning"|"afternoon"|"evening"|"night", "food": '
      '"afterFood"|"beforeFood"|"any", "days": number or null, "note": '
      'string}. "1-0-1" means morning and night; BD means twice a day '
      '(morning, night); TDS three times (morning, afternoon, night); OD '
      'once (morning); HS at bedtime (night). "note" is a few words the '
      'patient must remember, in the language of the notes, or "". Never '
      'invent a medicine or a time that is not in the text: leave "times" '
      'empty if unsure.';

  /// Reads every medicine of [visit], or only those whose ids are in [only].
  Future<List<PlannedMedicine>> plan(
    DoctorVisit visit, {
    Set<String>? only,
  }) async {
    final out = <PlannedMedicine>[];
    for (final m in visit.medicines) {
      if (only != null && !only.contains(m.id)) continue;
      final files = visit.attachmentsOf(m);
      final photo = files
          .where((a) => a.kind == AttachmentKind.photo)
          .firstOrNull
          ?.file;
      final audio = files
          .where((a) => a.kind == AttachmentKind.audio)
          .firstOrNull
          ?.file;
      final printed = photo != null && AttachmentStore.instance.available
          ? await PhotoTextReader.instance.read(
              AttachmentStore.instance.pathOf(photo),
            )
          : '';
      final text = [
        m.note.trim(),
        printed.trim(),
      ].where((s) => s.isNotEmpty).join('\n');
      final rules = const MedicineRules().read(
        text,
        visitMedicineId: m.id,
        photoFile: photo,
        audioFile: audio,
      );
      out.add(
        (await _withAi(text, rules) ?? rules)..source = sourceOf(visit, m),
      );
    }
    return out;
  }

  /// What [m] is read from: its notes and its photo and voice note.
  static String sourceOf(DoctorVisit visit, VisitMedicine m) {
    final files = [for (final a in visit.attachmentsOf(m)) a.file]..sort();
    return [m.note.trim(), ...files].join('\n');
  }

  /// Gurtu AI's reading, filled in by [rules] where it left gaps; null when
  /// the AI isn't installed or answered something unusable.
  Future<PlannedMedicine?> _withAi(String text, PlannedMedicine rules) async {
    final ai = this.ai;
    if (ai == null || !ai.isReady || text.trim().isEmpty) return null;
    try {
      final answer = await ai.generate(
        system: _system,
        prompt:
            'Doctor\'s notes and the text printed on the medicine:\n'
            '$text',
        maxOutputTokens: 200,
        timeout: const Duration(seconds: 45),
      );
      return parseAiAnswer(answer, rules);
    } on Object catch (e) {
      debugPrint('Gurtu AI could not read the medicine: $e');
      return null;
    }
  }

  /// Validates the model's JSON. Anything missing or odd falls back to
  /// what the rules found; a name the notes don't mention is not trusted.
  @visibleForTesting
  static PlannedMedicine? parseAiAnswer(String answer, PlannedMedicine rules) {
    final start = answer.indexOf('{');
    final end = answer.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    Map<String, dynamic> j;
    try {
      j = jsonDecode(answer.substring(start, end + 1)) as Map<String, dynamic>;
    } on Object {
      return null;
    }
    final name = (j['name'] as String? ?? '').trim();
    final times = <DoseTime>{
      for (final t in j['times'] as List? ?? const [])
        ?DoseTime.values.asNameMap()['$t'.trim().toLowerCase()],
    };
    final days = switch (j['days']) {
      final int d when d > 0 && d <= 365 => d,
      final num d when d > 0 && d <= 365 => d.round(),
      _ => rules.days,
    };
    return PlannedMedicine(
      visitMedicineId: rules.visitMedicineId,
      name: name.isNotEmpty && name.length <= 60 ? name : rules.name,
      strength: (j['strength'] as String? ?? '').trim().isNotEmpty
          ? (j['strength'] as String).trim()
          : rules.strength,
      times: times.isNotEmpty ? times : rules.times,
      food: FoodTiming.values.asNameMap()[j['food']] ?? rules.food,
      days: days,
      note: (j['note'] as String? ?? '').trim().characters.take(120).toString(),
      photoFile: rules.photoFile,
      audioFile: rules.audioFile,
      byAi: true,
    );
  }
}
