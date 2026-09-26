// A patient's medicine list and the doses taken from it. Used by "Scan &
// verify" to check a strip against what the doctor prescribed. Scoped by
// patientId like all care data.

import 'package:flutter/material.dart';

/// When in the day a dose is due. Indian prescriptions write these as
/// "1-0-1" (morning-afternoon-night).
enum DoseTime {
  morning(Icons.wb_twilight_rounded, 5),
  afternoon(Icons.wb_sunny_rounded, 11),
  evening(Icons.wb_cloudy_rounded, 16),
  night(Icons.bedtime_rounded, 20);

  const DoseTime(this.icon, this.startHour);
  final IconData icon;

  /// Hour this dose window opens; it runs until the next one opens.
  final int startHour;

  static DoseTime at(DateTime t) {
    final h = t.hour;
    if (h >= night.startHour || h < morning.startHour) return night;
    if (h >= evening.startHour) return evening;
    if (h >= afternoon.startHour) return afternoon;
    return morning;
  }
}

enum FoodTiming { afterFood, beforeFood, any }

enum MedicineSource { manual, strip, prescription }

class Medicine {
  Medicine({
    required this.id,
    required this.patientId,
    required this.name,
    required this.createdAt,
    this.alsoCalled = '',
    this.strength = '',
    this.times = const [],
    this.food = FoodTiming.any,
    this.source = MedicineSource.manual,
    this.isSample = false,
  });

  final String id;
  final String patientId;

  /// As written on the prescription, e.g. "Metformin".
  final String name;

  /// Brand or generic name printed on the strip, e.g. "Glycomet".
  final String alsoCalled;

  /// e.g. "500 mg". Empty when unknown.
  final String strength;
  final List<DoseTime> times;
  final FoodTiming food;
  final MedicineSource source;
  final bool isSample;
  final DateTime createdAt;

  String get label => strength.isEmpty ? name : '$name $strength';

  Medicine copyWith({
    String? name,
    String? alsoCalled,
    String? strength,
    List<DoseTime>? times,
    FoodTiming? food,
  }) => Medicine(
    id: id,
    patientId: patientId,
    name: name ?? this.name,
    alsoCalled: alsoCalled ?? this.alsoCalled,
    strength: strength ?? this.strength,
    times: times ?? this.times,
    food: food ?? this.food,
    source: source,
    isSample: isSample,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'name': name,
    'alsoCalled': alsoCalled,
    'strength': strength,
    'times': [for (final t in times) t.name],
    'food': food.name,
    'source': source.name,
    'isSample': isSample,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Medicine.fromJson(Map<String, dynamic> j) => Medicine(
    id: j['id'] as String,
    patientId: j['patientId'] as String,
    name: j['name'] as String,
    alsoCalled: j['alsoCalled'] as String? ?? '',
    strength: j['strength'] as String? ?? '',
    times: [
      for (final t in (j['times'] as List? ?? const []))
        DoseTime.values.byName(t as String),
    ],
    food: FoodTiming.values.byName(j['food'] as String? ?? 'any'),
    source: MedicineSource.values.byName(j['source'] as String? ?? 'manual'),
    isSample: j['isSample'] as bool? ?? false,
    createdAt: DateTime.parse(j['createdAt'] as String),
  );
}

/// One dose marked as taken.
class DoseRecord {
  DoseRecord({
    required this.medicineId,
    required this.patientId,
    required this.slot,
    required this.day,
    required this.at,
    this.by,
  });

  final String medicineId;
  final String patientId;
  final DoseTime slot;

  /// The care day the dose belongs to (see [careDay]).
  final DateTime day;
  final DateTime at;

  /// CareMember id.
  final String? by;

  Map<String, dynamic> toJson() => {
    'medicineId': medicineId,
    'patientId': patientId,
    'slot': slot.name,
    'day': day.toIso8601String(),
    'at': at.toIso8601String(),
    'by': by,
  };

  factory DoseRecord.fromJson(Map<String, dynamic> j) => DoseRecord(
    medicineId: j['medicineId'] as String,
    patientId: j['patientId'] as String,
    slot: DoseTime.values.byName(j['slot'] as String),
    day: DateTime.parse(j['day'] as String),
    at: DateTime.parse(j['at'] as String),
    by: j['by'] as String?,
  );
}

/// The night dose runs past midnight, so a 1 AM dose still belongs to the
/// previous day.
DateTime careDay(DateTime t) {
  final day = DateUtils.dateOnly(t);
  return t.hour < DoseTime.morning.startHour
      ? day.subtract(const Duration(days: 1))
      : day;
}
