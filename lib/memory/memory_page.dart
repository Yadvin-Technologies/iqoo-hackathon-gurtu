import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../data/attachment_store.dart';
import '../data/care_repository.dart';
import '../home/care_text.dart';
import '../home/widgets/quick_capture.dart';
import '../l10n/language.dart';
import '../medicines/medicine_list_page.dart';
import '../profile/person_details.dart';
import '../theme/gurtu_theme.dart';
import '../visits/visit_detail_page.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import 'knowledge.dart';
import 'memory_detail_page.dart';
import 'memory_editor_page.dart';
import 'smart_search.dart';

enum MemoryFilter {
  all(null),
  notes({KnowledgeKind.note}),
  documents({KnowledgeKind.scan, KnowledgeKind.document}),
  visits({KnowledgeKind.visit}),
  medicines({KnowledgeKind.medicine});

  const MemoryFilter(this.kinds);
  final Set<KnowledgeKind>? kinds;

  String label(AppLocalizations l) => switch (this) {
    all => l.memoryAll,
    notes => l.memoryNotes,
    documents => l.memoryDocuments,
    visits => l.visitsTitle,
    medicines => l.medicinesSection,
  };
}

IconData knowledgeIcon(KnowledgeKind k) => switch (k) {
  KnowledgeKind.note => Icons.edit_note_rounded,
  KnowledgeKind.scan => Icons.document_scanner_rounded,
  KnowledgeKind.document => Icons.description_rounded,
  KnowledgeKind.visit => Icons.medical_services_rounded,
  KnowledgeKind.medicine => Icons.medication_rounded,
  KnowledgeKind.profile => Icons.badge_rounded,
};

Color knowledgeColor(KnowledgeKind k) => switch (k) {
  KnowledgeKind.note => GurtuColors.orange,
  KnowledgeKind.scan => GurtuColors.info,
  KnowledgeKind.document => GurtuColors.primary,
  KnowledgeKind.visit => GurtuColors.leaf,
  KnowledgeKind.medicine => GurtuColors.amber,
  KnowledgeKind.profile => GurtuColors.primaryDeep,
};

/// Opens what a search found: the memory, the visit or the medicine list.
void openKnowledge(BuildContext context, KnowledgeDoc doc) {
  if (doc.momentId case final id?) {
    pushPage(context, MemoryDetailPage(momentId: id));
  } else if (doc.visitId case final id?) {
    pushPage(context, VisitDetailPage(visitId: id));
  } else if (doc.kind == KnowledgeKind.medicine) {
    pushPage(context, const MedicineListPage());
  } else if (doc.kind == KnowledgeKind.profile) {
    pushPage(context, EditPersonPage(patientId: doc.patientId));
  }
}

/// The Memory tab: everything saved about the person — notes, scanned and
/// shared reports, doctor visits, medicines — searchable in their own
/// words and language.
class MemoryPage extends StatefulWidget {
  const MemoryPage({super.key});

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  final _query = TextEditingController();
  MemoryFilter _filter = MemoryFilter.all;
  List<KnowledgeHit>? _hits;
  Timer? _debounce;
  int _run = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Runs again whenever the memory, or the person shown, changes.
    KnowledgeScope.of(context).l = context.l10n;
    CareScope.of(context);
    _search();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final run = ++_run;
    final knowledge = KnowledgeScope.read(context);
    final patientId = context
        .getInheritedWidgetOfExactType<CareScope>()
        ?.notifier
        ?.selectedPatient
        ?.id;
    final hits = await knowledge.search(
      _query.text,
      patientId,
      kinds: _filter.kinds,
      limit: 60,
    );
    if (mounted && run == _run) setState(() => _hits = hits);
  }

  void _queryChanged(String _) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _search);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final repo = CareScope.of(context);
    final name = repo.selectedPatient?.name ?? '';
    final hits = _hits;
    final searching = _query.text.trim().isNotEmpty;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          GurtuSpace.gutter,
          16,
          GurtuSpace.gutter,
          32,
        ),
        children: [
          Row(
            children: [
              Expanded(child: Text(l.navMemory, style: t.headlineMedium)),
              IconButton.filled(
                onPressed: () => showCaptureSheet(context),
                tooltip: l.addToMemory,
                style: IconButton.styleFrom(
                  backgroundColor: GurtuColors.primary,
                ),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(l.memorySubtitle(name), style: t.bodyLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _query,
            onChanged: _queryChanged,
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: l.memorySearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searching
                  ? IconButton(
                      tooltip: l.clearSearch,
                      onPressed: () {
                        _query.clear();
                        _queryChanged('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in MemoryFilter.values) ...[
                  ChoiceChip(
                    label: Text(f.label(l)),
                    selected: _filter == f,
                    selectedColor: GurtuColors.primarySoft,
                    onSelected: (_) {
                      setState(() => _filter = f);
                      _search();
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          const SmartSearchCard(),
          if (hits == null)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(color: GurtuColors.primary),
              ),
            )
          else if (hits.isEmpty)
            _Empty(query: searching ? _query.text.trim() : null)
          else
            for (final h in hits)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KnowledgeTile(
                  doc: h.doc,
                  query: _query.text,
                  onTap: () => openKnowledge(context, h.doc),
                ),
              ),
        ],
      ),
    );
  }
}

/// One saved thing in a list: what kind, its title, a line of it, when.
class KnowledgeTile extends StatelessWidget {
  const KnowledgeTile({
    super.key,
    required this.doc,
    required this.onTap,
    this.query = '',
  });

  final KnowledgeDoc doc;
  final VoidCallback onTap;
  final String query;

  /// The line that matches the search, or the first one.
  String _snippet() {
    final lines = doc.text
        .split('\n')
        .map((s) => s.trim())
        // The title (often the text's first line) is shown already.
        .where((s) => s.isNotEmpty && s != doc.title.trim())
        .toList();
    if (lines.isEmpty) return '';
    final words = WordIndex.words(query);
    final hit = lines.firstWhere(
      (s) => words.any((w) => w.length > 2 && s.toLowerCase().contains(w)),
      orElse: () => lines.first,
    );
    return hit;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final repo = CareScope.of(context);
    final snippet = _snippet();
    final moment = doc.momentId == null ? null : repo.momentById(doc.momentId!);
    final photo = moment?.files.where(isImageFile).firstOrNull;
    final store = AttachmentStore.instance;
    return GurtuCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(
            icon: knowledgeIcon(doc.kind),
            color: knowledgeColor(doc.kind),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: t.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (snippet.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    snippet,
                    style: t.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  whenLabel(context, doc.date),
                  style: t.bodySmall?.copyWith(color: GurtuColors.textMuted),
                ),
              ],
            ),
          ),
          if (photo != null && store.available) ...[
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
              child: Image.file(
                File(store.pathOf(photo)),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({this.query});

  final String? query;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return GurtuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.auto_stories_rounded),
          const SizedBox(height: 12),
          Text(
            query == null ? l.emptyMemory : l.memoryNoResults(query!),
            style: t.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(l.memoryEmptyBody, style: t.bodyMedium),
          const SizedBox(height: 14),
          GurtuButton(
            label: l.addToMemory,
            icon: Icons.add_rounded,
            onPressed: () => showCaptureSheet(context),
          ),
        ],
      ),
    );
  }
}

/// Offers the smart-search model (or shows its download), where the phone
/// can run it and it isn't on yet.
class SmartSearchCard extends StatelessWidget {
  const SmartSearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final smart = SmartSearchScope.maybeOf(context);
    if (smart == null ||
        smart.status == SmartSearchStatus.unavailable ||
        smart.status == SmartSearchStatus.ready) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final downloading = smart.status == SmartSearchStatus.downloading;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GurtuCard(
        color: GurtuColors.primarySoft,
        borderColor: GurtuColors.primarySoft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: GurtuColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(l.smartSearchTitle, style: t.titleMedium)),
              ],
            ),
            const SizedBox(height: 6),
            Text(l.smartSearchBody(SmartSearch.sizeMb), style: t.bodyMedium),
            const SizedBox(height: 12),
            if (downloading) ...[
              LinearProgressIndicator(
                value: smart.progress > 0 ? smart.progress : null,
                color: GurtuColors.primary,
                backgroundColor: GurtuColors.surface,
              ),
              const SizedBox(height: 6),
              Text(
                l.smartSearchProgress((smart.progress * 100).round()),
                style: t.bodySmall,
              ),
            ] else
              GurtuButton(
                label: smart.status == SmartSearchStatus.failed
                    ? l.tryAgain
                    : l.smartSearchDownload,
                icon: Icons.download_rounded,
                onPressed: smart.install,
              ),
          ],
        ),
      ),
    );
  }
}

class SmartSearchScope extends InheritedNotifier<SmartSearch> {
  const SmartSearchScope({
    super.key,
    required SmartSearch? smart,
    required super.child,
  }) : super(notifier: smart);

  static SmartSearch? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SmartSearchScope>()?.notifier;
}
