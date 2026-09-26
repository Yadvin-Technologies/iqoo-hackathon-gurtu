import 'dart:math' as math;

import '../data/medicine_models.dart';

/// The answer to "is this the right medicine, right now?".
enum Verdict {
  /// On the list, strength matches, due now and not yet taken.
  takeNow,

  /// Right medicine, but no dose is due in this part of the day.
  notNow,

  /// The dose for this part of the day was already marked as taken.
  alreadyTaken,

  /// Right medicine, but no times were saved for it.
  noTimes,

  /// Same medicine name, different strength from the prescription.
  wrongStrength,

  /// Not on this patient's list.
  notOnList,

  /// On another family member's list, not this patient's.
  otherPatient,

  /// No readable medicine name.
  unreadable;

  bool get isStop =>
      this == wrongStrength || this == notOnList || this == otherPatient;
}

class MedicineCheck {
  const MedicineCheck(
    this.verdict, {
    this.medicine,
    this.foundStrength,
    this.slot,
    this.next,
    this.taken,
    this.strengthConfirmed = false,
  });

  final Verdict verdict;

  /// The strip visibly shows the prescribed strength. False when it could
  /// not be read, so the screen asks the person to look rather than claiming
  /// a match.
  final bool strengthConfirmed;

  /// The list entry the strip matched (another patient's for
  /// [Verdict.otherPatient]).
  final Medicine? medicine;

  /// Strength printed on the strip, e.g. "1000 mg".
  final String? foundStrength;

  /// This part of the day.
  final DoseTime? slot;

  /// The next dose after this one.
  final DoseTime? next;
  final DoseRecord? taken;
}

/// Checks text read from a strip against the saved medicine list. It only
/// compares with what the family saved; it never recommends a medicine.
class MedicineVerifier {
  const MedicineVerifier();

  MedicineCheck check({
    required String text,
    required String patientId,
    required List<Medicine> medicines,
    required List<DoseRecord> doses,
    required DateTime now,
  }) {
    final upper = text.toUpperCase();
    final tokens = _tokens(upper);
    if (tokens.isEmpty) return const MedicineCheck(Verdict.unreadable);

    bool matches(Medicine m) => _nameMatches(m, upper, tokens);
    final own = medicines
        .where((m) => m.patientId == patientId && matches(m))
        .toList();
    if (own.isEmpty) {
      final other = medicines
          .where((m) => m.patientId != patientId && matches(m))
          .firstOrNull;
      return other == null
          ? const MedicineCheck(Verdict.notOnList)
          : MedicineCheck(Verdict.otherPatient, medicine: other);
    }

    final found = readStrengths(text);
    final foundKeys = found.map(_strengthKey).toSet();
    // Brand strips often print just "GLYCOMET 500"; a bare number that equals
    // the prescribed amount confirms it, but never proves a mismatch (batch
    // numbers and prices are bare numbers too).
    final bare = {
      for (final n in RegExp(r'\d+(\.\d+)?').allMatches(text)) n.group(0)!,
    };
    bool confirms(Medicine m) =>
        foundKeys.contains(_strengthKey(m.strength)) ||
        (found.isEmpty &&
            bare.contains(RegExp(r'\d+(\.\d+)?').stringMatch(m.strength)));
    final medicine = own.where(confirms).firstOrNull ?? own.first;
    final confirmed = medicine.strength.isNotEmpty && confirms(medicine);
    if (medicine.strength.isNotEmpty &&
        found.isNotEmpty &&
        !foundKeys.contains(_strengthKey(medicine.strength))) {
      return MedicineCheck(
        Verdict.wrongStrength,
        medicine: medicine,
        foundStrength: found.first,
      );
    }

    if (medicine.times.isEmpty) {
      return MedicineCheck(
        Verdict.noTimes,
        medicine: medicine,
        strengthConfirmed: confirmed,
      );
    }
    final slot = DoseTime.at(now);
    final next = _nextSlot(medicine.times, slot);
    if (!medicine.times.contains(slot)) {
      return MedicineCheck(
        Verdict.notNow,
        medicine: medicine,
        slot: slot,
        next: next,
        strengthConfirmed: confirmed,
      );
    }
    final day = careDay(now);
    final taken = doses
        .where(
          (d) =>
              d.medicineId == medicine.id &&
              d.slot == slot &&
              d.day.isAtSameMomentAs(day),
        )
        .firstOrNull;
    return MedicineCheck(
      taken == null ? Verdict.takeNow : Verdict.alreadyTaken,
      medicine: medicine,
      slot: slot,
      next: next,
      taken: taken,
      strengthConfirmed: confirmed,
    );
  }

  static bool _nameMatches(Medicine m, String upper, List<String> tokens) {
    for (final name in [m.name, m.alsoCalled]) {
      final n = name.trim().toUpperCase();
      if (n.length < 3) continue;
      if (upper.contains(n)) return true;
      // Strips often print only the first word; allow small OCR slips.
      final key = _tokens(n).firstOrNull;
      if (key == null) continue;
      final allowed = key.length <= 4 ? 0 : (key.length <= 7 ? 1 : 2);
      if (tokens.any((t) => _distance(t, key) <= allowed)) return true;
    }
    return false;
  }

  static DoseTime _nextSlot(List<DoseTime> times, DoseTime from) {
    for (var i = 1; i <= DoseTime.values.length; i++) {
      final t = DoseTime.values[(from.index + i) % DoseTime.values.length];
      if (times.contains(t)) return t;
    }
    return from;
  }
}

/// A medicine read from a prescription or strip, for the family to confirm.
class MedicineDraft {
  MedicineDraft({
    required this.name,
    this.strength = '',
    this.times = const [],
    this.food = FoodTiming.any,
  });

  final String name;
  final String strength;
  final List<DoseTime> times;
  final FoodTiming food;
}

/// Pulls medicine names, strengths and timings out of OCR text.
class PrescriptionReader {
  const PrescriptionReader();

  /// One draft per medicine line, e.g. "1) Tab. Metformin 500 mg 1-0-1 PC".
  List<MedicineDraft> readPrescription(String text) {
    final out = <MedicineDraft>[];
    final seen = <String>{};
    for (final raw in text.split('\n')) {
      final line = raw.trim();
      if (line.length < 4) continue;
      final hasForm = _form.hasMatch(line);
      final strength = readStrengths(line).firstOrNull ?? '';
      if (!hasForm && strength.isEmpty) continue;
      final name = _nameFrom(line);
      if (name == null || !seen.add(name.toUpperCase())) continue;
      out.add(
        MedicineDraft(
          name: name,
          strength: strength,
          times: _times(line),
          food: _food(line),
        ),
      );
    }
    return out;
  }

  /// Best guess at the name and strength printed on a strip or box.
  MedicineDraft? readStrip(String text) {
    final lines = [
      for (final l in text.split('\n'))
        if (l.trim().isNotEmpty) l.trim(),
    ];
    final strength = readStrengths(text).firstOrNull ?? '';
    // The line with the strength usually carries the name too.
    for (final line in lines) {
      if (readStrengths(line).isEmpty) continue;
      final name = _nameFrom(line);
      if (name != null) return MedicineDraft(name: name, strength: strength);
    }
    for (final line in lines) {
      final name = _nameFrom(line);
      if (name != null) return MedicineDraft(name: name, strength: strength);
    }
    return null;
  }

  static final _form = RegExp(
    r'^\s*(\d+\s*[\).]\s*)?(tab|tablet|cap|capsule|syp|syrup|inj|drops?)\b',
    caseSensitive: false,
  );

  static String? _nameFrom(String line) {
    var s = line.replaceFirst(_form, ' ');
    s = s.replaceFirst(RegExp(r'^\s*\d+\s*[\).]'), ' ');
    // Stop at the strength or dosing pattern.
    final cut = RegExp(
      r'(\d+(\.\d+)?\s*(mg|mcg|µg|g|ml|iu|%))|(\b[01½]\s*-\s*[01½])',
      caseSensitive: false,
    ).firstMatch(s);
    if (cut != null) s = s.substring(0, cut.start);
    final words = [
      for (final w in s.split(RegExp(r'[^A-Za-z0-9\-]+')))
        // Bare numbers ("GLYCOMET 500") are strengths, not part of the name.
        if (w.length >= 2 &&
            !RegExp(r'^\d+$').hasMatch(w) &&
            !_stopwords.contains(w.toUpperCase()))
          w,
    ].take(3).toList();
    if (words.isEmpty || !RegExp(r'[A-Za-z]{3,}').hasMatch(words.first)) {
      return null;
    }
    return words.map(_title).join(' ');
  }

  static String _title(String w) => w.length <= 3 && w == w.toUpperCase()
      ? w
      : w[0].toUpperCase() + w.substring(1).toLowerCase();

  static List<DoseTime> _times(String line) {
    final u = ' ${line.toUpperCase()} ';
    final dashes = RegExp(
      r'\b([01½])\s*-\s*([01½])\s*-\s*([01½])(\s*-\s*([01½]))?\b',
    ).firstMatch(u);
    if (dashes != null) {
      bool on(int g) => dashes.group(g) != null && dashes.group(g) != '0';
      // 1-0-1 is morning-afternoon-night; 1-0-0-1 adds evening.
      return dashes.group(5) == null
          ? [
              if (on(1)) DoseTime.morning,
              if (on(2)) DoseTime.afternoon,
              if (on(3)) DoseTime.night,
            ]
          : [
              if (on(1)) DoseTime.morning,
              if (on(2)) DoseTime.afternoon,
              if (on(3)) DoseTime.evening,
              if (on(5)) DoseTime.night,
            ];
    }
    bool has(String code) => RegExp('\\b$code\\b').hasMatch(u);
    if (has('QID')) return DoseTime.values;
    if (has('TDS') || has('TID')) {
      return [DoseTime.morning, DoseTime.afternoon, DoseTime.night];
    }
    if (has('BD') || has('BID')) return [DoseTime.morning, DoseTime.night];
    if (has('HS')) return [DoseTime.night];
    if (has('OD') || has('QD')) return [DoseTime.morning];
    return const [];
  }

  static FoodTiming _food(String line) {
    final u = ' ${line.toUpperCase()} ';
    if (RegExp(r'\b(AC|BEFORE FOOD|BEFORE MEALS?|EMPTY STOMACH)\b')
        .hasMatch(u)) {
      return FoodTiming.beforeFood;
    }
    if (RegExp(r'\b(PC|AFTER FOOD|AFTER MEALS?)\b').hasMatch(u)) {
      return FoodTiming.afterFood;
    }
    return FoodTiming.any;
  }

  static const _stopwords = {
    'TAB',
    'TABS',
    'TABLET',
    'TABLETS',
    'CAP',
    'CAPS',
    'CAPSULE',
    'CAPSULES',
    'IP',
    'USP',
    'BP',
    'EACH',
    'FILM',
    'COATED',
    'CONTAINS',
    'BATCH',
    'MFG',
    'MFD',
    'EXP',
    'MRP',
    'RX',
    'DR',
    'SCHEDULE',
    'PRESCRIPTION',
    'DRUG',
    'WARNING',
    'STORE',
    'HYDROCHLORIDE',
    'SR',
    'ER',
    'XR',
    'THE',
    'AND',
  };
}

/// "500 mg", "2.5 mg", "10 ml" found in [text], normalised.
List<String> readStrengths(String text) => [
  for (final m in RegExp(
    r'(\d+(?:\.\d+)?)\s*(mg|mcg|µg|g|ml|iu)\b',
    caseSensitive: false,
  ).allMatches(text))
    '${m.group(1)} ${m.group(2)!.toLowerCase()}',
];

String _strengthKey(String s) => s.toUpperCase().replaceAll(RegExp(r'\s'), '');

List<String> _tokens(String upper) => [
  for (final m in RegExp(r'[A-Z][A-Z0-9]{2,}').allMatches(upper)) m.group(0)!,
];

int _distance(String a, String b) {
  if ((a.length - b.length).abs() > 2) return 99;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 1; i <= a.length; i++) {
    final cur = [i, ...List.filled(b.length, 0)];
    for (var j = 1; j <= b.length; j++) {
      cur[j] = math.min(
        math.min(cur[j - 1] + 1, prev[j] + 1),
        prev[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1),
      );
    }
    prev = cur;
  }
  return prev[b.length];
}
