import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/ai/on_device_ai.dart';
import 'package:gurtutest/data/attachment_store.dart';
import 'package:gurtutest/data/care_models.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/main.dart';
import 'package:gurtutest/memory/document_reader.dart';
import 'package:gurtutest/memory/knowledge.dart';
import 'package:gurtutest/memory/memory_detail_page.dart';
import 'package:gurtutest/memory/memory_editor_page.dart';
import 'package:gurtutest/memory/share_inbox.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:gurtutest/reminders/medicine_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'memory_test.dart' show FakeInbox, FakeReader, FakeStore;
import 'visits_test.dart' show openPage;

/// The phone's file picker and document reading, scripted.
class FakeDocuments implements DocumentReader {
  FakeDocuments(this.picked, this.texts);

  final List<String> picked;

  /// File name ending -> the words in it.
  final Map<String, String> texts;
  final opened = <String>[];

  @override
  bool get available => true;

  @override
  Future<List<String>> pick() async => picked;

  @override
  Future<String> read(String path) async {
    opened.add(path);
    for (final e in texts.entries) {
      if (path.endsWith(e.key)) return e.value;
    }
    return '';
  }
}

/// Gurtu AI "installed": answers from a script, streaming in pieces.
class SummaryAi extends GurtuAi {
  SummaryAi(super.prefs, this.replies);

  final List<String> replies;
  final prompts = <String>[];
  final systems = <String>[];

  @override
  bool get isReady => true;

  @override
  void warmUp() {}

  @override
  Future<String> generate({
    required String system,
    required String prompt,
    int maxOutputTokens = 512,
    Duration timeout = const Duration(seconds: 60),
    ValueChanged<String>? onPartial,
  }) async {
    systems.add(system);
    prompts.add(prompt);
    final reply = replies.isEmpty ? '' : replies.removeAt(0);
    if (onPartial != null) {
      for (var i = 25; i < reply.length; i += 25) {
        onPartial(reply.substring(0, i));
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      onPartial(reply);
    }
    return reply;
  }
}

const labReport =
    'City Diagnostics\n'
    'Patient: Lakshmi  Date: 12-03-2026\n'
    'HbA1c 8.1 % (High)\n'
    'Fasting glucose 156 mg/dL (High)\n'
    'Creatinine 0.9 mg/dL';

void main() {
  late FakeStore store;

  setUp(() {
    AttachmentStore.instance = store = FakeStore();
    ShareInbox.instance = FakeInbox();
    PhotoTextReader.instance = FakeReader('');
  });
  tearDown(() {
    AttachmentStore.instance = DeviceAttachmentStore();
    ShareInbox.instance = DeviceShareInbox();
    PhotoTextReader.instance = DevicePhotoTextReader();
    DocumentReader.instance = DeviceDocumentReader();
  });

  Future<(CareRepository, SummaryAi)> open(
    WidgetTester tester,
    List<String> replies,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({
      'onboarding_complete': true,
      'app_language': 'en',
    });
    final prefs = await SharedPreferences.getInstance();
    CareRepository(prefs).createFromOnboarding(
      OnboardingState()
        ..careFor = CareFor.parent
        ..patientName = 'Amma'
        ..yourName = 'Sai'
        ..age = 64,
    );
    final ai = SummaryAi(prefs, replies);
    await tester.pumpWidget(GurtuApp(key: UniqueKey(), prefs: prefs, ai: ai));
    await tester.pumpAndSettle();
    final repo = CareScope.of(tester.element(find.byType(Scaffold).first));
    return (repo, ai);
  }

  testWidgets('a PDF is read, summarised by Gurtu AI and saved to memory', (
    tester,
  ) async {
    final docs = DocumentReader.instance = FakeDocuments(
      ['/cache/shared/lab_report_march.pdf'],
      {'.pdf': labReport},
    );
    final (repo, ai) = await open(tester, [
      '```json\n{"title": "Blood sugar report, March 2026", "summary": '
          '"HbA1c is 8.1 % and fasting glucose is 156 mg/dL, both marked '
          'high. Creatinine is 0.9 mg/dL."}\n```',
    ]);

    // Capture Care → Document opens the picker straight away.
    await tester.ensureVisible(find.text('Capture Care'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Capture Care'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Document'));
    await tester.pumpAndSettle();
    expect(find.byType(MemoryEditorPage), findsOneWidget);

    // Kept, and its words read into the page.
    expect(store.files, ['kept_0.pdf']);
    expect(docs.opened, ['/fake/kept_0.pdf']);
    await tester.scrollUntilVisible(
      find.text(labReport),
      200,
      scrollable: find
          .descendant(
            of: find.byType(MemoryEditorPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text(labReport), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Summary by Gurtu AI'),
      -200,
      scrollable: find
          .descendant(
            of: find.byType(MemoryEditorPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    // Gurtu AI read it: its summary and its title.
    expect(find.text('Summary by Gurtu AI'), findsOneWidget);
    expect(
      find.text(
        'HbA1c is 8.1 % and fasting glucose is 156 mg/dL, both marked high. '
        'Creatinine is 0.9 mg/dL.',
      ),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextField, 'Blood sugar report, March 2026'),
      findsOneWidget,
    );
    expect(ai.prompts.single, contains('HbA1c 8.1 %'));
    expect(ai.systems.single, contains('Never add your own interpretation'));

    await tester.tap(find.text('Save to memory').last);
    await tester.pumpAndSettle();
    final saved = repo.moments.last;
    expect(saved.type, MomentType.document);
    expect(saved.title, 'Blood sugar report, March 2026');
    expect(saved.files, ['kept_0.pdf']);
    expect(saved.detail, labReport);
    expect(saved.summary, startsWith('HbA1c is 8.1 %'));

    // Found by what the summary says, and shown with it.
    final kb = KnowledgeScope.read(tester.element(find.byType(Scaffold).first));
    final hits = await kb.search('fasting glucose high', saved.patientId);
    expect(hits.first.doc.momentId, saved.id);
    await openPage(tester, MemoryDetailPage(momentId: saved.id));
    expect(find.text('Summary by Gurtu AI'), findsOneWidget);
    expect(find.textContaining('both marked high'), findsOneWidget);
  });

  testWidgets('a file without readable words is still kept', (tester) async {
    DocumentReader.instance = FakeDocuments([
      '/cache/shared/scan_empty.pdf',
    ], {});
    final (repo, ai) = await open(tester, []);
    await openPage(tester, const MemoryEditorPage(pickDocument: true));
    expect(
      find.textContaining("Gurtu couldn't read the words in this file"),
      findsOneWidget,
    );
    // Named after the file, and nothing for Gurtu AI to read.
    expect(find.widgetWithText(TextField, 'scan empty'), findsOneWidget);
    expect(ai.prompts, isEmpty);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save to memory').last);
    await tester.pumpAndSettle();
    expect(repo.moments.last.files, ['kept_0.pdf']);
    expect(repo.moments.last.summary, isEmpty);
  });

  test('Gurtu AI replies are checked before use', () {
    final ok = parseDocumentSummary(
      'Here it is: {"title": "**Discharge summary**", '
      '"summary": "Admitted for fever on 2 March, sent home on 5 March."}',
    )!;
    expect(ok.title, 'Discharge summary');
    expect(ok.summary, 'Admitted for fever on 2 March, sent home on 5 March.');
    expect(parseDocumentSummary('Sorry, I cannot read this.'), isNull);
    expect(parseDocumentSummary('{"summary": "ok"}'), isNull);
    expect(
      documentSummarySystem(AppLanguage.telugu),
      contains('Write both in Telugu'),
    );
  });

  test('PDFs, Word and text files are read on the phone', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('gurtu_docs');
    addTearDown(() => dir.delete(recursive: true));
    final page1 = File('${dir.path}/p1.png')..writeAsBytesSync([1]);
    final page2 = File('${dir.path}/p2.png')..writeAsBytesSync([2]);
    final note = File('${dir.path}/note.txt')
      ..writeAsStringSync('Walk 30 minutes daily.');
    const channel = MethodChannel('gurtu/documents');
    final calls = <String>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      return switch (call.method) {
        'pdfPages' => [page1.path, page2.path],
        'docxText' => 'Discharge advice: rest for a week.',
        'pick' => ['/cache/shared/a.pdf'],
        _ => null,
      };
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    PhotoTextReader.instance = FakeReader('Page words');

    final reader = DeviceDocumentReader();
    expect(await reader.pick(), ['/cache/shared/a.pdf']);
    // Every page read, and the page pictures cleared away.
    expect(
      await reader.read('${dir.path}/report.pdf'),
      'Page words\n\nPage words',
    );
    expect(page1.existsSync(), isFalse);
    expect(page2.existsSync(), isFalse);
    expect(
      await reader.read('${dir.path}/letter.docx'),
      'Discharge advice: rest for a week.',
    );
    expect(await reader.read(note.path), 'Walk 30 minutes daily.');
    expect(await reader.read('${dir.path}/old.doc'), '');
    expect(calls, ['pick', 'pdfPages', 'docxText']);
  });
}
