import 'package:flutter/material.dart';

import '../data/care_repository.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import 'visit_text.dart';
import 'widgets/attachment_tray.dart';

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
    final medicines = l.medicinesOf(visit);
    final tests = l.testsOf(visit);
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
        if (notes.isNotEmpty)
          _Section(
            icon: Icons.record_voice_over_rounded,
            title: l.doctorSaid,
            child: Text(notes, style: t.bodyLarge),
          ),
        // Always shown, so a prescription photo or voice note can be added
        // after the visit (at the pharmacy, at home).
        _Section(
          icon: Icons.medication_rounded,
          title: l.medicinesSection,
          child: _withTray(
            repo,
            visit,
            VisitSection.medicines,
            medicines.isEmpty ? null : Text(medicines, style: t.bodyLarge),
          ),
        ),
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
