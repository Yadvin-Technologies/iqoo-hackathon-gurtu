import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ask/ask_gurtu_page.dart';
import 'package:gurtutest/data/attachment_store.dart';
import 'package:gurtutest/data/care_models.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/data/medicine_models.dart';
import 'package:gurtutest/data/visit_models.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/medicines/prescription_import_page.dart';
import 'package:gurtutest/memory/knowledge.dart';
import 'package:gurtutest/memory/memory_detail_page.dart';
import 'package:gurtutest/memory/memory_editor_page.dart';
import 'package:gurtutest/memory/memory_page.dart';
import 'package:gurtutest/memory/share_inbox.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:gurtutest/profile/person_details.dart';
import 'package:gurtutest/reminders/medicine_plan.dart';
import 'package:gurtutest/widgets/gurtu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_test.dart' show openHome;
import 'visits_test.dart' show openPage, tapText;

/// Files kept in memory, never on disk.
class FakeStore implements AttachmentStore {
  final files = <String>{};
  final deleted = <String>[];
  var _n = 0;

  @override
  bool get available => true;
  @override
  Future<void> init() async {}
  @override
  String pathOf(String file) => '/fake/$file';
  @override
  Future<String> keep(String sourcePath) async {
    final ext = sourcePath.split('.').last;
    final file = 'kept_${_n++}.$ext';
    files.add(file);
    return file;
  }

  @override
  ({String file, String path}) create(String extension) {
    final file = 'new_${_n++}.$extension';
    files.add(file);
    return (file: file, path: pathOf(file));
  }

  @override
  Future<void> delete(String file) async {
    files.remove(file);
    deleted.add(file);
  }

  @override
  Future<void> prune(Set<String> inUse) async {
    for (final f in files.where((f) => !inUse.contains(f)).toList()) {
      await delete(f);
    }
  }
}

/// A camera that "takes" the given photos, in turn.
class FakeCamera implements DocumentCamera {
  FakeCamera(this.photos);

  final List<String> photos;

  @override
  bool get available => true;

  @override
  Future<String?> pick({required bool fromGallery}) async =>
      photos.isEmpty ? null : photos.removeAt(0);
}

class FakeReader implements PhotoTextReader {
  FakeReader(this.text);

  final String text;

  @override
  Future<String> read(String path) async => text;
}

class FakeInbox implements ShareInbox {
  SharedContent? first;
  final shares = StreamController<SharedContent>.broadcast();
  int handled = 0;

  @override
  Future<SharedContent?> initial() async => first;
  @override
  Stream<SharedContent> get incoming => shares.stream;
  @override
  Future<void> done() async => handled++;
}

const report =
    'City Diagnostics\n'
    'HbA1c 7.2 %\n'
    'Fasting blood sugar 142 mg/dL\n'
    'Metformin 500 mg 1-0-1 after food';

void main() {
  late FakeStore store;
  late FakeInbox inbox;

  setUp(() {
    AttachmentStore.instance = store = FakeStore();
    ShareInbox.instance = inbox = FakeInbox();
    PhotoTextReader.instance = FakeReader(report);
  });
  tearDown(() {
    AttachmentStore.instance = DeviceAttachmentStore();
    ShareInbox.instance = DeviceShareInbox();
    PhotoTextReader.instance = DevicePhotoTextReader();
    DocumentCamera.instance = DeviceDocumentCamera();
  });

  CareRepository repoOf(WidgetTester tester) =>
      CareScope.of(tester.element(find.byType(Scaffold).first));

  KnowledgeDoc doc(String id, String title, String text) => KnowledgeDoc(
    id: id,
    patientId: 'p',
    kind: KnowledgeKind.note,
    title: title,
    text: text,
    date: DateTime(2026, 9, 1),
  );

  test('shares from Android arrive on the gurtu/share channel', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('gurtu/share');
    final calls = <String>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      return call.method == 'initial'
          ? {
              'paths': ['/cache/shared/1_report.pdf'],
              'text': '  From the lab  ',
            }
          : null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

    final inbox = DeviceShareInbox();
    final shared = await inbox.initial();
    expect(shared!.paths, ['/cache/shared/1_report.pdf']);
    expect(shared.text, 'From the lab');
    await inbox.done();
    expect(calls, ['initial', 'done']);
    expect(SharedContent.fromMap({'paths': <String>[], 'text': ' '}), isNull);
  });

  group('word search', () {
    final docs = [
      doc('a', 'Blood test report', 'HbA1c 7.2 %, fasting sugar 142'),
      doc('b', 'Knee pain', 'Walked less today, knee hurts'),
      doc('c', 'रात की दवा', 'अम्लोडिपिन रात को खाने के बाद'),
      doc('d', 'షుగర్ రిపోర్ట్', 'ఉపవాసం షుగర్ 142'),
    ];

    List<String> best(String q) {
      final scores = WordIndex(docs).score(q);
      return [
        for (final (i, s) in scores.indexed)
          if (s >= 0.15) docs[i].id,
      ];
    }

    test('whole words, word starts and near spellings', () {
      expect(best('blood test'), ['a']);
      expect(best('diab sugar'), ['a']);
      expect(best('hba1c'), ['a']);
      // A typo still finds it.
      expect(best('kne pian'), ['b']);
      // Question words don't match everything.
      expect(best('what did the report say about my knee'), ['a', 'b']);
    });

    test('Hindi and Telugu words are found as written', () {
      expect(best('रात'), ['c']);
      expect(best('షుగర్'), ['d']);
      expect(best('nothing like this'), isEmpty);
    });
  });

  test('the memory holds notes, visits and medicines, newest first', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = CareRepository(await SharedPreferences.getInstance())
      ..createFromOnboarding(
        OnboardingState()
          ..careFor = CareFor.parent
          ..patientName = 'Amma'
          ..yourName = 'Sai',
      );
    repo
      ..addNote('Felt dizzy after the morning walk')
      ..addVisit(
        date: DateTime(2026, 9, 20),
        doctorName: 'Dr. Rao',
        notes: 'Sugar is high. Repeat HbA1c in 3 months.',
        medicines: const [VisitMedicine(id: 'vm1', note: 'Metformin 500 mg')],
      )
      ..addMedicine(
        name: 'Amlodipine',
        strength: '5 mg',
        times: const [DoseTime.night],
      );
    final kb = KnowledgeBase(repo: repo, vectorFile: () async => null);
    addTearDown(kb.dispose);
    final id = repo.selectedPatient!.id;

    final all = await kb.search('', id);
    expect(all.map((h) => h.doc.kind), [
      // Who they are, always first.
      KnowledgeKind.profile,
      KnowledgeKind.medicine,
      KnowledgeKind.note,
      KnowledgeKind.visit,
    ]);
    final sugar = await kb.search('when is the next hba1c test', id);
    expect(sugar.first.doc.kind, KnowledgeKind.visit);
    expect(sugar.first.doc.title, contains('Dr. Rao'));
    final night = await kb.search('amlodipine', id);
    expect(night.first.doc.kind, KnowledgeKind.medicine);
    final notes = await kb.search('', id, kinds: {KnowledgeKind.note});
    expect(notes.single.doc.text, 'Felt dizzy after the morning walk');
  });

  testWidgets('a scanned report is read, saved, found and its medicine added', (
    tester,
  ) async {
    DocumentCamera.instance = FakeCamera(['/camera/page1.jpg']);
    await openHome(tester);
    final repo = repoOf(tester);

    await openPage(tester, const MemoryEditorPage(scan: true));
    // The photo was taken and its printed text read on the phone.
    expect(find.text(report), findsOneWidget);
    expect(find.widgetWithText(TextField, 'City Diagnostics'), findsOneWidget);
    expect(store.files, ['kept_0.jpg']);

    await tester.tap(find.text('Save to memory').last);
    await tester.pumpAndSettle();
    final saved = repo.moments.last;
    expect(saved.type, MomentType.scan);
    expect(saved.title, 'City Diagnostics');
    expect(saved.files, ['kept_0.jpg']);
    // Kept through the start-up clean-up.
    expect(repo.attachmentFiles, contains('kept_0.jpg'));

    // A prescription opens once saved, its medicine one tap from the list.
    expect(find.byType(MemoryDetailPage), findsOneWidget);
    await tapText(tester, 'Add 1 medicine to the list');
    await tester.pumpAndSettle();
    expect(find.byType(PrescriptionImportPage), findsOneWidget);
    expect(find.text('Metformin 500 mg'), findsOneWidget);
    Navigator.of(tester.element(find.byType(PrescriptionImportPage))).pop();
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(MemoryDetailPage))).pop();
    await tester.pumpAndSettle();

    // The Memory tab finds it by what it says.
    await tester.tap(find.text('Memory'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'hba1c');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('City Diagnostics'), findsOneWidget);
    expect(find.text('HbA1c 7.2 %'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'xray of the hand');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('Nothing found for “xray of the hand”.'), findsOneWidget);

    // Opened, then deleted with its photo.
    await tester.enterText(find.byType(TextField).first, '');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('City Diagnostics'));
    await tester.pumpAndSettle();
    expect(find.byType(MemoryDetailPage), findsOneWidget);
    await tapText(tester, 'Delete');
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(repo.moments.where((m) => m.id == saved.id), isEmpty);
    expect(store.deleted, contains('kept_0.jpg'));
  });

  testWidgets('leaving the scan unsaved deletes its photo', (tester) async {
    DocumentCamera.instance = FakeCamera(['/camera/page1.jpg']);
    await openHome(tester);
    await openPage(tester, const MemoryEditorPage(scan: true));
    expect(store.files, ['kept_0.jpg']);
    Navigator.of(tester.element(find.byType(MemoryEditorPage))).pop();
    await tester.pumpAndSettle();
    expect(store.deleted, ['kept_0.jpg']);
  });

  testWidgets('things shared from other apps are saved to memory', (
    tester,
  ) async {
    inbox.first = const SharedContent(paths: ['/share/discharge.pdf']);
    await openHome(tester);
    final repo = repoOf(tester);

    // Shared to start the app: the save screen opens with it.
    expect(find.byType(MemoryEditorPage), findsOneWidget);
    expect(find.widgetWithText(TextField, 'discharge'), findsOneWidget);
    expect(inbox.handled, greaterThan(0));
    await tester.tap(find.text('Save to memory').last);
    await tester.pumpAndSettle();
    expect(repo.moments.last.type, MomentType.document);
    expect(repo.moments.last.files, ['kept_0.pdf']);

    // Once the "saved" note has gone from over the button.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Shared while it runs: a WhatsApp message from the doctor.
    inbox.shares.add(
      const SharedContent(text: 'Dr. Rao: stop the iron tablet for a week'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dr. Rao: stop the iron tablet for a week'), findsWidgets);
    await tester.tap(find.text('Save to memory').last);
    await tester.pumpAndSettle();
    expect(repo.moments.last.type, MomentType.note);
    expect(
      repo.moments.last.detail,
      'Dr. Rao: stop the iron tablet for a week',
    );
  });

  testWidgets('Ask Gurtu answers from memory, warning signs first', (
    tester,
  ) async {
    await openHome(tester);
    final repo = repoOf(tester);
    repo.addMoment(
      type: MomentType.scan,
      title: 'Sugar report',
      detail: 'HbA1c 7.2 %. Fasting sugar 142.',
    );
    await tester.tap(find.text('AI'));
    await tester.pumpAndSettle();
    expect(find.byType(AskGurtuPage), findsOneWidget);

    // Without Gurtu AI on the phone: what the memory holds.
    await tester.enterText(
      find.descendant(
        of: find.byType(AskGurtuPage),
        matching: find.byType(TextField),
      ),
      'what was the sugar report',
    );
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        "Gurtu AI isn't on this phone yet, so here is what I found in the memory:",
      ),
      findsOneWidget,
    );
    expect(find.text('Sugar report'), findsOneWidget);
    await tester.tap(find.text('Sugar report'));
    await tester.pumpAndSettle();
    expect(find.byType(MemoryDetailPage), findsOneWidget);
    Navigator.of(tester.element(find.byType(MemoryDetailPage))).pop();
    await tester.pumpAndSettle();

    // Chest pain: get help now, whatever else.
    await tester.enterText(
      find.descendant(
        of: find.byType(AskGurtuPage),
        matching: find.byType(TextField),
      ),
      'Amma has chest pain',
    );
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();
    expect(find.textContaining('call 108'), findsOneWidget);
  });

  testWidgets('a question tapped on Home is asked on the AI tab', (
    tester,
  ) async {
    await openHome(tester);
    await tapText(tester, 'When is the blood test?');
    expect(find.byType(AskGurtuPage), findsOneWidget);
    // Asked straight away: the question, then what the memory holds.
    expect(find.text('When is the blood test?'), findsOneWidget);
    expect(
      find.textContaining("I couldn't find anything about that"),
      findsOneWidget,
    );
  });

  testWidgets('Profile shows what onboarding asked, and it can be changed', (
    tester,
  ) async {
    await openHome(tester);
    final repo = repoOf(tester);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('About Amma'), findsOneWidget);
    expect(find.text('64 years'), findsWidgets);
    // No "Remove" anywhere in Profile any more.
    final profile = find
        .descendant(
          of: find.byKey(const ValueKey('profile')),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('Restart onboarding'),
      300,
      scrollable: profile,
    );
    expect(find.text('Remove'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Edit details'),
      -300,
      scrollable: profile,
    );

    await tester.tap(find.text('Edit details'));
    await tester.pumpAndSettle();
    expect(find.byType(EditPersonPage), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Amma'), 'Amma ji');
    await tester.pump();
    await tester.tap(find.byTooltip('Increase age'));
    await tester.pump();
    await tapText(tester, 'Sugar (Diabetes)');
    await tapText(tester, 'Penicillin');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final p = repo.selectedPatient!;
    expect(p.name, 'Amma ji');
    expect(p.age, 65);
    expect(p.conditions, ['diabetes']);
    expect(p.allergies, ['penicillin']);
    expect(find.text('Changes saved'), findsOneWidget);
    expect(find.text('About Amma ji'), findsOneWidget);
    expect(find.text('Sugar (Diabetes)'), findsOneWidget);
  });

  // Small 360dp phone, every language: overflow anywhere fails the test.
  for (final lang in AppLanguage.values) {
    testWidgets('memory screens fit in ${lang.englishName}', (tester) async {
      await openHome(
        tester,
        language: lang.code,
        sample: true,
        size: const Size(990, 2145),
      );
      final l = lookupAppLocalizations(Locale(lang.code));
      repoOf(tester).addMoment(
        type: MomentType.scan,
        title: 'City Diagnostics',
        detail: report,
        files: const ['kept_9.jpg'],
      );
      Future<void> scrollThrough(Finder list) async {
        for (var i = 0; i < 8; i++) {
          await tester.drag(list, const Offset(0, -300));
          await tester.pump();
        }
      }

      await tester.tap(find.text(l.navMemory).last);
      await tester.pumpAndSettle();
      await scrollThrough(
        find
            .descendant(
              of: find.byType(MemoryPage),
              matching: find.byType(Scrollable),
            )
            .last,
      );
      await tester.tap(find.text(l.navAi).last);
      await tester.pumpAndSettle();
      await openPage(tester, const MemoryEditorPage());
      await scrollThrough(
        find
            .descendant(
              of: find.byType(GurtuPage).last,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      Navigator.of(tester.element(find.byType(MemoryEditorPage))).pop();
      await tester.pumpAndSettle();
      final id = repoOf(tester).moments.last.id;
      await openPage(tester, MemoryDetailPage(momentId: id));
      Navigator.of(tester.element(find.byType(MemoryDetailPage))).pop();
      await tester.pumpAndSettle();
      await openPage(
        tester,
        EditPersonPage(patientId: repoOf(tester).selectedPatient!.id),
      );
      await scrollThrough(
        find
            .descendant(
              of: find.byType(GurtuPage).last,
              matching: find.byType(Scrollable),
            )
            .first,
      );
    });
  }
}
