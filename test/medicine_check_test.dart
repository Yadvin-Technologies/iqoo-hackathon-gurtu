import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/medicine_check.dart';
import 'package:gurtutest/data/medicine_models.dart';

Medicine med(
  String id,
  String patient,
  String name,
  String strength,
  List<DoseTime> times, {
  String alsoCalled = '',
}) => Medicine(
  id: id,
  patientId: patient,
  name: name,
  alsoCalled: alsoCalled,
  strength: strength,
  times: times,
  createdAt: DateTime(2026),
);

void main() {
  final list = [
    med('m1', 'amma', 'Metformin', '500 mg', [
      DoseTime.morning,
      DoseTime.night,
    ], alsoCalled: 'Glycomet'),
    med('m2', 'amma', 'Amlodipine', '5 mg', [DoseTime.morning]),
    med('m3', 'amma', 'Vitamin D3', '', []),
    med('n1', 'nanna', 'Telmisartan', '40 mg', [
      DoseTime.morning,
    ], alsoCalled: 'Telma'),
  ];
  final morning = DateTime(2026, 9, 26, 8, 30);
  const strip = 'GLYCOMET 500\nMetformin Hydrochloride Tablets IP\n500 mg';

  MedicineCheck check(
    String text, {
    DateTime? now,
    List<DoseRecord> doses = const [],
  }) => const MedicineVerifier().check(
    text: text,
    patientId: 'amma',
    medicines: list,
    doses: doses,
    now: now ?? morning,
  );

  group('MedicineVerifier', () {
    test('right medicine, due now', () {
      final c = check(strip);
      expect(c.verdict, Verdict.takeNow);
      expect(c.medicine!.id, 'm1');
      expect(c.slot, DoseTime.morning);
      expect(c.next, DoseTime.night);
    });

    test('brand name alone and small OCR slips still match', () {
      expect(check('GLYCOMET-500').medicine?.id, 'm1');
      expect(check('METF0RMIN 500 mg').medicine?.id, 'm1');
    });

    test('a match is only claimed when the strength is readable', () {
      expect(check(strip).strengthConfirmed, isTrue);
      // "GLYCOMET 500" with no unit still confirms 500 mg.
      expect(check('GLYCOMET 500').strengthConfirmed, isTrue);
      // No strength visible: never assume it matches.
      final c = check('Glycomet tablets');
      expect(c.verdict, Verdict.takeNow);
      expect(c.strengthConfirmed, isFalse);
      // A bare number that differs is not proof of a mismatch either.
      expect(check('GLYCOMET 1000').verdict, isNot(Verdict.wrongStrength));
      expect(check('GLYCOMET 1000').strengthConfirmed, isFalse);
    });

    test('a dose already taken is not offered again', () {
      final c = check(
        strip,
        doses: [
          DoseRecord(
            medicineId: 'm1',
            patientId: 'amma',
            slot: DoseTime.morning,
            day: DateTime(2026, 9, 26),
            at: DateTime(2026, 9, 26, 8, 5),
          ),
        ],
      );
      expect(c.verdict, Verdict.alreadyTaken);
      expect(c.taken!.at.minute, 5);
    });

    test('not due in the afternoon; next dose is at night', () {
      final c = check(strip, now: DateTime(2026, 9, 26, 14));
      expect(c.verdict, Verdict.notNow);
      expect(c.next, DoseTime.night);
    });

    test('1 AM counts as the previous night', () {
      final c = check(
        strip,
        now: DateTime(2026, 9, 27, 1),
        doses: [
          DoseRecord(
            medicineId: 'm1',
            patientId: 'amma',
            slot: DoseTime.night,
            day: DateTime(2026, 9, 26),
            at: DateTime(2026, 9, 26, 21),
          ),
        ],
      );
      expect(c.verdict, Verdict.alreadyTaken);
    });

    test('a different strength is stopped', () {
      final c = check('GLYCOMET 1000\nMetformin 1000 mg');
      expect(c.verdict, Verdict.wrongStrength);
      expect(c.foundStrength, '1000 mg');
      expect(c.verdict.isStop, isTrue);
    });

    test("another family member's medicine is named", () {
      final c = check('TELMA 40\nTelmisartan Tablets 40 mg');
      expect(c.verdict, Verdict.otherPatient);
      expect(c.medicine!.patientId, 'nanna');
    });

    test('unknown medicine and unreadable text', () {
      expect(check('DOLO 650 Paracetamol').verdict, Verdict.notOnList);
      expect(check('  ').verdict, Verdict.unreadable);
    });

    test('a medicine without times asks for them', () {
      expect(check('Vitamin D3 60000 IU').verdict, Verdict.noTimes);
    });
  });

  group('PrescriptionReader', () {
    const reader = PrescriptionReader();

    test('reads names, strengths and Indian dosing shorthand', () {
      final found = reader.readPrescription('''
Dr. Meena Rao MBBS
Rx
1) Tab. Metformin 500 mg 1-0-1 after food
2) Tab Amlodipine 5mg OD
3) Cap. Pantoprazole 40 mg 1-0-0 AC
Review after 1 month
''');
      expect(found.map((d) => d.name), [
        'Metformin',
        'Amlodipine',
        'Pantoprazole',
      ]);
      expect(found[0].strength, '500 mg');
      expect(found[0].times, [DoseTime.morning, DoseTime.night]);
      expect(found[0].food, FoodTiming.afterFood);
      expect(found[1].times, [DoseTime.morning]);
      expect(found[2].food, FoodTiming.beforeFood);
    });

    test('reads the name and strength off a strip', () {
      final d = reader.readStrip(strip)!;
      expect(d.name, 'Glycomet');
      expect(d.strength, '500 mg');
    });
  });
}
