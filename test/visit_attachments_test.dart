import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gurtutest/data/attachment_store.dart';
import 'package:gurtutest/data/care_repository.dart';
import 'package:gurtutest/data/visit_models.dart';
import 'package:gurtutest/l10n/language.dart';
import 'package:gurtutest/onboarding/onboarding_state.dart';
import 'package:gurtutest/visits/visit_detail_page.dart';
import 'package:gurtutest/widgets/gurtu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_test.dart' show openHome;
import 'visits_test.dart' show openPage, tapText;

/// Keeps "files" in memory and remembers what was deleted.
class _FakeStore implements AttachmentStore {
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
    final file = 'kept_${_n++}.jpg';
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

VisitAttachment _photo(String file, VisitSection section, {String? itemId}) =>
    VisitAttachment(
      id: 'id_$file',
      kind: AttachmentKind.photo,
      section: section,
      file: file,
      createdAt: DateTime(2026, 9, 27),
      itemId: itemId,
    );

VisitAttachment _voice(String file, VisitSection section, {String? itemId}) =>
    VisitAttachment(
      id: 'id_$file',
      kind: AttachmentKind.audio,
      section: section,
      file: file,
      createdAt: DateTime(2026, 9, 27),
      duration: const Duration(seconds: 42),
      itemId: itemId,
    );

const _tablet = VisitMedicine(id: 'm1', note: 'Tablet after food');

void main() {
  late _FakeStore store;
  setUp(() => AttachmentStore.instance = store = _FakeStore());
  tearDown(() => AttachmentStore.instance = DeviceAttachmentStore());

  test('attachments are saved with the visit and read back', () {
    final visit = DoctorVisit(
      id: 'v',
      patientId: 'p',
      date: DateTime(2026, 9, 27),
      createdBy: 'm',
      attachments: [
        _photo('rx.jpg', VisitSection.medicines),
        _voice('note.m4a', VisitSection.nextVisit),
      ],
    );
    final back = DoctorVisit.fromJson(visit.toJson());
    expect(back.attachmentsFor(VisitSection.medicines).single.file, 'rx.jpg');
    final note = back.attachmentsFor(VisitSection.nextVisit).single;
    expect(note.kind, AttachmentKind.audio);
    expect(note.duration, const Duration(seconds: 42));
    expect(back.attachmentsFor(VisitSection.tests), isEmpty);

    // Visits saved before attachments existed still load.
    final old = visit.toJson()..remove('attachments');
    expect(DoctorVisit.fromJson(old).attachments, isEmpty);
  });

  test('the repository keeps, removes and cleans up the files', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = CareRepository(prefs)
      ..createFromOnboarding(
        OnboardingState()
          ..careFor = CareFor.parent
          ..patientName = 'Amma'
          ..yourName = 'Sai',
      );
    store.files.addAll(['rx.jpg', 'slip.jpg', 'note.m4a', 'stray.jpg']);

    final visit = repo.addVisit(
      date: DateTime(2026, 9, 27),
      attachments: [_photo('rx.jpg', VisitSection.medicines)],
    )!;
    repo.addAttachment(visit, _photo('slip.jpg', VisitSection.tests));
    repo.addAttachment(visit, _voice('note.m4a', VisitSection.medicines));
    expect(repo.attachmentFiles, {'rx.jpg', 'slip.jpg', 'note.m4a'});

    // Survives a restart.
    final reloaded = CareRepository(prefs);
    expect(reloaded.visits.single.attachments, hasLength(3));

    // Left over from a visit that was never saved: cleared at start-up.
    await store.prune(reloaded.attachmentFiles);
    expect(store.deleted, ['stray.jpg']);

    repo.removeAttachment(
      visit,
      visit.attachmentsFor(VisitSection.tests).single,
    );
    expect(store.deleted, contains('slip.jpg'));
    expect(visit.attachments, hasLength(2));

    repo.deleteVisit(visit);
    expect(store.deleted, containsAll(['rx.jpg', 'note.m4a']));
    expect(store.files, isEmpty);
  });

  testWidgets('photos and voice notes can be added and removed later', (
    tester,
  ) async {
    await openHome(tester);
    final repo = CareScope.of(tester.element(find.byType(Scaffold).first));
    store.files.addAll(['rx.jpg', 'note.m4a']);
    final visit = repo.addVisit(
      date: DateTime(2026, 9, 27),
      doctorName: 'Dr. Rao',
      medicines: [_tablet],
      attachments: [
        _photo('rx.jpg', VisitSection.medicines, itemId: 'm1'),
        _voice('note.m4a', VisitSection.medicines, itemId: 'm1'),
      ],
    )!;
    await openPage(tester, VisitDetailPage(visitId: visit.id));

    // The medicine and the next visit can take more; tests are no longer
    // asked for.
    expect(find.text('Add photo'), findsNWidgets(2));
    expect(find.text('Record voice note'), findsNWidgets(2));
    expect(find.text('Tests to do'), findsNothing);
    expect(find.text('Medicine 1'), findsOneWidget);
    expect(find.text('Tablet after food'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'View photo',
      ),
      findsOneWidget,
    );
    expect(find.text('Voice note'), findsOneWidget);
    expect(find.text('0:42'), findsOneWidget);

    // Removing asks first, then deletes the file from the phone.
    await tester.tap(find.byTooltip('Remove'));
    await tester.pumpAndSettle();
    expect(find.text('Remove this?'), findsOneWidget);
    await tapText(tester, 'Remove');
    expect(find.text('Voice note'), findsNothing);
    expect(store.deleted, ['note.m4a']);
    expect(visit.attachments.single.file, 'rx.jpg');
  });

  testWidgets('recordings of the doctor play and can be deleted', (
    tester,
  ) async {
    await openHome(tester);
    final repo = CareScope.of(tester.element(find.byType(Scaffold).first));
    store.files.addAll(['talk1.m4a', 'talk2.m4a']);
    final visit = repo.addVisit(
      date: DateTime(2026, 9, 27),
      notes: 'Reduce salt',
      attachments: [
        _voice('talk1.m4a', VisitSection.doctor),
        _voice('talk2.m4a', VisitSection.doctor),
      ],
    )!;

    // Survives a restart.
    final prefs = await SharedPreferences.getInstance();
    expect(
      CareRepository(prefs).visits.single.attachmentsFor(VisitSection.doctor),
      hasLength(2),
    );

    await openPage(tester, VisitDetailPage(visitId: visit.id));
    expect(find.text('Reduce salt'), findsOneWidget);
    expect(find.textContaining('Recording 1'), findsOneWidget);
    expect(find.textContaining('Recording 2'), findsOneWidget);
    expect(find.byTooltip('Play'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Remove').first);
    await tester.pumpAndSettle();
    await tapText(tester, 'Remove');
    expect(find.textContaining('Recording 2'), findsNothing);
    expect(store.deleted, ['talk1.m4a']);
    expect(visit.attachments.single.file, 'talk2.m4a');
  });

  // Small 360dp phone, every language: overflow anywhere fails the test.
  for (final lang in AppLanguage.values) {
    testWidgets('attachments fit in ${lang.englishName}', (tester) async {
      await openHome(tester, language: lang.code, size: const Size(990, 2145));
      final repo = CareScope.of(tester.element(find.byType(Scaffold).first));
      final visit = repo.addVisit(
        date: DateTime(2026, 9, 27),
        medicines: [
          _tablet,
          const VisitMedicine(id: 'm2', note: 'Metformin 500 mg'),
        ],
        attachments: [
          _photo('rx.jpg', VisitSection.medicines, itemId: 'm1'),
          _voice('note.m4a', VisitSection.medicines, itemId: 'm1'),
          _voice('strip.m4a', VisitSection.medicines, itemId: 'm2'),
          _voice('card.m4a', VisitSection.nextVisit),
          _voice('talk.m4a', VisitSection.doctor),
        ],
      )!;
      await openPage(tester, VisitDetailPage(visitId: visit.id));
      final list = find
          .descendant(
            of: find.byType(GurtuPage).last,
            matching: find.byType(Scrollable),
          )
          .first;
      for (var i = 0; i < 8; i++) {
        await tester.drag(list, const Offset(0, -300));
        await tester.pump();
      }
    });
  }
}
