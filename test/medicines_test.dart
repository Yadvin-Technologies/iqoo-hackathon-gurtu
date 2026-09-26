import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/medicines/medicine_list_page.dart';
import 'package:gurtutest/medicines/medicine_scanner.dart';
import 'package:gurtutest/medicines/prescription_import_page.dart';
import 'package:gurtutest/medicines/verify_page.dart';

import 'home_test.dart' show openHome;
import 'visits_test.dart' show openPage, tapText;

/// Returns [text] as if the camera had read it.
class FakeScanner implements MedicineScanner {
  FakeScanner(this.text);

  final String text;

  @override
  bool get available => true;

  @override
  Future<String?> scan({bool fromGallery = false}) async => text;
}

DateTime at830() => DateTime(2026, 9, 26, 8, 30);

Future<void> check(WidgetTester tester, String typed) async {
  await tester.enterText(find.byType(TextField).first, typed);
  await tester.pumpAndSettle();
  await tapText(tester, 'Check');
}

void main() {
  tearDown(() => MedicineScanner.instance = DeviceMedicineScanner());

  testWidgets('Home has Scan & verify with the medicine list under it', (
    tester,
  ) async {
    await openHome(tester, sample: true);
    await tester.scrollUntilVisible(find.text('Scan & verify medicine'), 200);
    expect(find.text('Is this the right tablet, right now?'), findsOneWidget);
    expect(find.text('Medicine list · 3 medicines'), findsOneWidget);
  });

  testWidgets('a scanned strip is verified, marked taken, then blocked', (
    tester,
  ) async {
    MedicineScanner.instance = FakeScanner(
      'GLYCOMET 500\nMetformin Hydrochloride Tablets IP 500 mg',
    );
    final prefs = await openHome(tester, sample: true);
    await openPage(tester, const VerifyPage(clock: at830));

    await tapText(tester, 'Scan the medicine');
    expect(
      find.text('Yes — this is the right medicine to take now.'),
      findsOneWidget,
    );
    expect(find.text('Metformin 500 mg'), findsOneWidget);
    expect(find.text('Strength matches: 500 mg'), findsOneWidget);
    expect(find.text('Due now: Morning dose'), findsOneWidget);
    expect(find.text('After food'), findsOneWidget);

    await tapText(tester, 'Mark as taken');
    expect(find.text('Already taken. Don\'t take it again now.'), findsOne);
    expect(find.text('Next dose: Night'), findsOneWidget);
    expect(prefs.getString('care_data_v1'), contains('"slot":"morning"'));
  });

  testWidgets('wrong strength, unknown and other-patient strips are stopped', (
    tester,
  ) async {
    await openHome(tester, sample: true);
    await openPage(tester, const VerifyPage(clock: at830));

    await check(tester, 'Glycomet 1000 mg');
    expect(
      find.text('Stop — the strength is different from the prescription.'),
      findsOneWidget,
    );
    expect(
      find.text('Strip says 1000 mg, prescription says 500 mg'),
      findsOneWidget,
    );
    expect(
      find.text("Don't take it until you check with the doctor or pharmacist."),
      findsOneWidget,
    );

    await tapText(tester, 'Check another medicine');
    await check(tester, 'Glycomet tablets');
    expect(find.text('Check the strip says 500 mg'), findsOneWidget);
    expect(find.textContaining('Strength matches'), findsNothing);

    await tapText(tester, 'Check another medicine');
    await check(tester, 'Telma 40');
    expect(
      find.text("Stop — this medicine is on Nanna's list, not Amma's."),
      findsOneWidget,
    );

    await tapText(tester, 'Check another medicine');
    await check(tester, 'Dolo 650');
    expect(
      find.text("Stop — this medicine is not on Amma's list."),
      findsOneWidget,
    );
  });

  testWidgets('with no medicines, Gurtu asks for the list first', (
    tester,
  ) async {
    await openHome(tester);
    await openPage(tester, const VerifyPage(clock: at830));
    expect(
      find.textContaining('Add Amma\'s medicines first'),
      findsOneWidget,
    );

    await tapText(tester, 'Add medicine');
    await tester.enterText(find.byType(TextField).first, 'Thyronorm');
    await tester.enterText(find.byType(TextField).at(2), '50 mcg');
    await tester.pumpAndSettle();
    await tapText(tester, 'Morning');
    await tapText(tester, 'Before food');
    await tapText(tester, 'Save medicine');

    // The check screen now works against the new list.
    await check(tester, 'THYRONORM 50 mcg');
    expect(
      find.text('Yes — this is the right medicine to take now.'),
      findsOneWidget,
    );
    expect(find.text('Before food'), findsOneWidget);
  });

  testWidgets('medicines are added from a prescription photo', (
    tester,
  ) async {
    MedicineScanner.instance = FakeScanner('''
Rx
1) Tab. Metformin 500 mg 1-0-1 after food
2) Tab Amlodipine 5mg OD
''');
    await openHome(tester);
    await openPage(tester, const MedicineListPage());
    expect(find.text('No medicines added yet'), findsOneWidget);

    await tapText(tester, 'Add from a prescription photo');
    await tapText(tester, 'Take a photo');
    expect(find.text('Metformin 500 mg'), findsOneWidget);
    expect(find.text('Morning, Night · After food'), findsOneWidget);
    await tapText(tester, 'Add 2 medicines');

    expect(find.text('2 medicines added'), findsOneWidget);
    expect(find.text('Amlodipine 5 mg'), findsOneWidget);

    // Ticking a dose on the list marks it as taken for today.
    await tapText(tester, 'Night');
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  // Small 360dp phone, every language: overflow anywhere fails the test.
  for (final lang in AppLanguage.values) {
    testWidgets('medicine screens fit in ${lang.englishName}', (
      tester,
    ) async {
      MedicineScanner.instance = FakeScanner('GLYCOMET 1000 mg');
      await openHome(
        tester,
        language: lang.code,
        sample: true,
        size: const Size(990, 2145),
      );
      await openPage(tester, const VerifyPage(clock: at830));
      await tester.tap(find.byIcon(Icons.document_scanner_rounded).first);
      await tester.pumpAndSettle();
      await openPage(tester, const MedicineListPage());
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -900));
      await tester.pump();
      await openPage(tester, const PrescriptionImportPage());
    });
  }
}
