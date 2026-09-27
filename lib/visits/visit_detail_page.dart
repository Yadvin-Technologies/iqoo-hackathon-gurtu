import 'package:flutter/material.dart';

import '../cloud/cloud_sync.dart';
import '../data/attachment_store.dart';
import '../data/care_repository.dart';
import '../data/visit_models.dart';
import '../data/medicine_models.dart';
import '../l10n/language.dart';
import '../medicines/medicine_text.dart';
import '../reminders/medicine_plan.dart';
import '../reminders/auto_reminders.dart';
import '../reminders/reminder_review_page.dart';
import '../reminders/test_reminder_button.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import '../widgets/voice_input.dart';
import 'visit_text.dart';
import 'widgets/attachment_tray.dart';
import 'widgets/visit_medicine_card.dart';

/// Everything noted at one appointment, section by section.
class VisitDetailPage extends StatefulWidget {
  const VisitDetailPage({super.key, required this.visitId});

  final String visitId;

  @override
  State<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends State<VisitDetailPage> {
  DoctorVisit? _shown;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    // Keeps the last version on screen while the page closes after a delete.
    final visit = _shown =
        repo.visits.where((v) => v.id == widget.visitId).firstOrNull ?? _shown;
    if (visit == null) return const SizedBox.shrink();

    final reason = l.reasonOf(visit);
    final notes = l.notesOf(visit);
    final tests = l.testsOf(visit);
    final recordings = visit.attachmentsFor(VisitSection.doctor);
    final prep = repo.prepById(visit.prepId);
    final by = repo.memberById(visit.createdBy);

    return GurtuPage(
      title: l.doctorLabel(visit),
      subtitle: [
        dateLabel(context, visit.date),
        if (reason.isNotEmpty) reason,
      ].join(' · '),
      children: [
        if (by != null) ...[
          Text(l.addedBy(by.isYou ? l.rowYou : by.name), style: t.bodySmall),
          const SizedBox(height: 16),
        ],
        if (notes.isNotEmpty || recordings.isNotEmpty)
          _Section(
            icon: Icons.record_voice_over_rounded,
            title: l.doctorSaid,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (notes.isNotEmpty) Text(notes, style: t.bodyLarge),
                if (notes.isNotEmpty && recordings.isNotEmpty)
                  const SizedBox(height: 14),
                for (final (i, a) in recordings.indexed) ...[
                  if (i > 0) const SizedBox(height: 8),
                  VoiceNoteTile(
                    key: ValueKey(a.id),
                    attachment: a,
                    title:
                        '${l.recordingNumber(i + 1)} · '
                        '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(a.createdAt))}',
                    onRemove: () async {
                      final ok = await confirmAction(
                        context,
                        title: l.removeAttachmentTitle,
                        body: l.removeAttachmentBody,
                        confirm: l.remove,
                      );
                      if (ok) repo.removeAttachment(visit, a);
                    },
                  ),
                ],
              ],
            ),
          ),
        // Always shown, so a medicine, its photo or a voice note can be
        // added after the visit (at the pharmacy, at home).
        _Section(
          icon: Icons.medication_rounded,
          title: l.medicinesSection,
          child: _Medicines(visit: visit),
        ),
        // No longer asked for; shown for visits that have it.
        if (tests.isNotEmpty ||
            visit.attachmentsFor(VisitSection.tests).isNotEmpty)
          _Section(
            icon: Icons.biotech_rounded,
            title: l.testsSection,
            child: _withTray(
              repo,
              visit,
              VisitSection.tests,
              tests.isEmpty ? null : Text(tests, style: t.bodyLarge),
            ),
          ),
        _Section(
          icon: Icons.event_rounded,
          title: l.nextVisit,
          child: _withTray(
            repo,
            visit,
            VisitSection.nextVisit,
            visit.nextVisit == null
                ? null
                : Text(
                    dateLabel(context, visit.nextVisit!),
                    style: t.titleMedium?.copyWith(color: GurtuColors.leaf),
                  ),
          ),
        ),
        if (prep != null && prep.questions.isNotEmpty)
          _Section(
            icon: Icons.help_outline_rounded,
            title: l.questionsAsked,
            trailing: l.askedOf(prep.askedCount, prep.questions.length),
            child: Column(
              children: [
                for (final q in prep.questions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          q.asked
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 20,
                          color: q.asked
                              ? GurtuColors.leaf
                              : GurtuColors.textMuted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(l.questionText(q), style: t.bodyMedium),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        GurtuButton(
          label: l.deleteVisit,
          style: GurtuButtonStyle.ghost,
          icon: Icons.delete_outline_rounded,
          onPressed: () async {
            final ok = await confirmAction(
              context,
              title: l.deleteVisit,
              body: l.deleteVisitConfirm,
              confirm: l.delete,
            );
            if (!ok || !context.mounted) return;
            Navigator.pop(context);
            repo.deleteVisit(visit);
          },
        ),
      ],
    );
  }
}

Widget _withTray(
  CareRepository repo,
  DoctorVisit visit,
  VisitSection section,
  Widget? text,
) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    if (text != null) ...[text, const SizedBox(height: 12)],
    AttachmentTray(
      section: section,
      attachments: visit.attachmentsFor(section),
      onAdd: (a) => repo.addAttachment(visit, a),
      onRemove: (a) => repo.removeAttachment(visit, a),
    ),
  ],
);

/// Each medicine with its photos and voice notes, and a button to add one.
class _Medicines extends StatelessWidget {
  const _Medicines({required this.visit});

  final DoctorVisit visit;

  Future<void> _add(BuildContext context, CareRepository repo) async {
    final l = context.l10n;
    final note = await _noteSheet(context, title: l.addMedicine);
    if (note == null) return;
    repo.addVisitMedicine(
      visit,
      VisitMedicine(
        id: 'vm_${DateTime.now().microsecondsSinceEpoch}',
        note: note,
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    CareRepository repo,
    VisitMedicine m,
  ) async {
    final note = await _noteSheet(
      context,
      title: context.l10n.editMedicine,
      initial: m.note,
    );
    if (note != null) repo.updateVisitMedicine(visit, m.withNote(note));
  }

  Future<void> _delete(
    BuildContext context,
    CareRepository repo,
    VisitMedicine m,
  ) async {
    final l = context.l10n;
    final ok = await confirmAction(
      context,
      title: l.deleteMedicineConfirm,
      body: visit.attachmentsOf(m).isEmpty ? null : l.removeMedicineBody,
      confirm: l.remove,
    );
    if (ok) repo.removeVisitMedicine(visit, m);
  }

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sample visits keep their medicines as text.
        if (visit.isSample) ...[
          Text(l.medicinesOf(visit), style: t.bodyLarge),
          const SizedBox(height: 14),
        ],
        for (final (i, m) in visit.medicines.indexed)
          VisitMedicineCard(
            key: ValueKey(m.id),
            flat: true,
            number: i + 1,
            onEdit: () => _edit(context, repo, m),
            onDelete: () => _delete(context, repo, m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (m.note.trim().isNotEmpty) ...[
                  Text(m.note, style: t.bodyLarge),
                  const SizedBox(height: 12),
                ],
                AttachmentTray(
                  section: VisitSection.medicines,
                  itemId: m.id,
                  showHint: false,
                  attachments: visit.attachmentsOf(m),
                  onAdd: (a) {
                    // Deleted while the photo was being taken.
                    if (!visit.medicines.any((x) => x.id == m.id)) {
                      AttachmentStore.instance.delete(a.file);
                      return;
                    }
                    repo.addAttachment(visit, a);
                  },
                  onRemove: (a) => repo.removeAttachment(visit, a),
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: AddMedicineButton(
            another: visit.medicines.isNotEmpty,
            onPressed: () => _add(context, repo),
          ),
        ),
        if (visit.medicines.isNotEmpty && !visit.isSample)
          _Reminders(visit: visit),
      ],
    );
  }
}

/// The medicine reminders of this visit: what is on, and a button to set
/// them up or change them.
class _Reminders extends StatelessWidget {
  const _Reminders({required this.visit});

  final DoctorVisit visit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final cloud = CloudScope.of(context);
    final on = [
      for (final m in cloud.planFor(visit.id) ?? const <PlannedMedicine>[])
        if (m.isOn) m,
    ];
    final reading =
        (AutoScope.maybeOf(context)?.busy ?? false) &&
        cloud.planFor(visit.id) == null;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1, color: GurtuColors.outline),
          const SizedBox(height: 14),
          for (final m in on)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.alarm_on_rounded,
                    size: 20,
                    color: GurtuColors.leaf,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      [
                        m.label,
                        m.orderedTimes.map(l.doseLabel).join(', '),
                        if (m.food != FoodTiming.any) l.foodLabel(m.food),
                        if (m.days case final d?) l.forDays(d),
                      ].join(' · '),
                      style: t.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          if (reading) ...[
            Row(
              children: [
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: GurtuColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(l.readingMedicines, style: t.bodyMedium)),
              ],
            ),
            const SizedBox(height: 12),
          ],
          if (cloud.hasWaitingReminders(visit.id)) ...[
            InfoBanner(
              text: l.remindersPending,
              icon: Icons.cloud_upload_rounded,
              color: GurtuColors.info,
            ),
            const SizedBox(height: 12),
          ],
          GurtuButton(
            label: on.isEmpty ? l.setUpReminders : l.changeReminders,
            style: on.isEmpty
                ? GurtuButtonStyle.primary
                : GurtuButtonStyle.ghost,
            icon: Icons.alarm_add_rounded,
            onPressed: () =>
                pushPage(context, ReminderReviewPage(visitId: visit.id)),
          ),
          if (on.isNotEmpty) ...[
            const SizedBox(height: 8),
            TestReminderButton(visitId: visit.id),
          ],
        ],
      ),
    );
  }
}

/// Type or speak what a medicine is and how to take it. Pops the words, or
/// nothing when closed.
Future<String?> _noteSheet(
  BuildContext context, {
  required String title,
  String initial = '',
}) => showGurtuSheet<String>(
  context,
  (_) => _NoteSheet(title: title, initial: initial),
);

class _NoteSheet extends StatefulWidget {
  const _NoteSheet({required this.title, required this.initial});

  final String title;
  final String initial;

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  late final _text = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetGrabber(),
            const SizedBox(height: 16),
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            DictationField(
              controller: _text,
              hint: l.medicinesHint,
              minLines: 2,
              maxLines: 5,
            ),
            const SizedBox(height: 18),
            GurtuButton(
              label: l.saveMedicine,
              icon: Icons.check_rounded,
              onPressed: () => Navigator.pop(context, _text.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GurtuCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(icon, size: 22, color: GurtuColors.primary),
                Text(title, style: t.titleMedium),
                if (trailing != null)
                  Text(
                    trailing!,
                    style: t.bodySmall?.copyWith(color: GurtuColors.leaf),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
