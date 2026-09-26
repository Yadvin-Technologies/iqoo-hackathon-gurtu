import 'package:flutter/material.dart';

import '../data/care_repository.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import 'prep_chat_page.dart';
import 'prep_questions_page.dart';
import 'visit_detail_page.dart';
import 'visit_recorder_page.dart';
import 'visit_text.dart';

/// Every appointment for the selected patient: a summary across all visits,
/// the questions ready for the next one, and the visits themselves.
class VisitsPage extends StatelessWidget {
  const VisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final visits = repo.doctorVisits;
    final prep = repo.openPrep;

    return GurtuPage(
      title: l.visitsTitle,
      subtitle: l.visitsSubtitle,
      bottom: GurtuButton(
        label: l.recordVisit,
        icon: Icons.mic_rounded,
        onPressed: () => pushPage(context, VisitRecorderPage(prepId: prep?.id)),
      ),
      children: [
        if (visits.isNotEmpty) ...[
          _Overview(visits: visits, next: repo.nextPlannedVisit()),
          const SizedBox(height: 16),
        ],
        _QuestionsCard(prep: prep),
        const SizedBox(height: 28),
        SectionHeader(title: l.pastVisits),
        if (visits.isEmpty)
          const _NoVisits()
        else
          for (final v in visits) ...[
            VisitCard(visit: v),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

/// The summary of all visits: how many, with whom, what's next and which
/// tests are still to be done.
class _Overview extends StatelessWidget {
  const _Overview({required this.visits, required this.next});

  final List<DoctorVisit> visits;
  final DateTime? next;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final last = visits.first;
    final doctors = {
      for (final v in visits)
        if (v.doctorName.isNotEmpty) v.doctorName.toLowerCase(),
    }.length;
    final tests = visits
        .map(l.testsOf)
        .firstWhere((x) => x.isNotEmpty, orElse: () => '');
    final medicines = visits
        .map(l.medicinesOf)
        .firstWhere((x) => x.isNotEmpty, orElse: () => '');

    return GurtuCard(
      color: GurtuColors.primarySoft,
      borderColor: GurtuColors.primary.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.visitsOverview, style: t.titleLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Stat(
                icon: Icons.event_available_rounded,
                text: l.visitsCount(visits.length),
              ),
              if (doctors > 0)
                _Stat(
                  icon: Icons.medical_services_rounded,
                  text: l.doctorsCount(doctors),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _Line(
            icon: Icons.history_rounded,
            label: l.lastVisit,
            value: '${dateLabel(context, last.date)} · ${l.doctorLabel(last)}',
          ),
          _Line(
            icon: Icons.event_rounded,
            label: l.nextVisit,
            value: next == null ? l.notPlanned : dateLabel(context, next!),
            color: next == null ? null : GurtuColors.leaf,
          ),
          if (medicines.isNotEmpty)
            _Line(
              icon: Icons.medication_rounded,
              label: l.medicinesSection,
              value: medicines,
            ),
          if (tests.isNotEmpty)
            _Line(
              icon: Icons.biotech_rounded,
              label: l.testsSection,
              value: tests,
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: GurtuColors.surface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: GurtuColors.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: GurtuColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Label on its own line with the value underneath, so long translations
/// never squeeze side by side.
class _Line extends StatelessWidget {
  const _Line({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color ?? GurtuColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: t.bodySmall),
                Text(
                  value,
                  style: t.titleMedium?.copyWith(
                    fontSize: 15,
                    color: color ?? GurtuColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionsCard extends StatelessWidget {
  const _QuestionsCard({required this.prep});

  final VisitPrep? prep;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final prep = this.prep;
    return GurtuCard(
      borderColor: GurtuColors.amberBright.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.record_voice_over_rounded,
                color: GurtuColors.orange,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.questionsForNextVisit, style: t.titleMedium),
                    Text(
                      prep == null
                          ? l.prepareQuestionsHint
                          : l.questionsReady(prep.questions.length),
                      style: t.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (prep != null)
            for (final q in prep.questions.take(2))
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.help_outline_rounded,
                        size: 18,
                        color: GurtuColors.amber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l.questionText(q),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMedium?.copyWith(
                          color: GurtuColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 14),
          GurtuButton(
            label: prep == null ? l.prepareQuestions : l.viewQuestions,
            style: GurtuButtonStyle.amber,
            icon: Icons.arrow_forward_rounded,
            onPressed: () => pushPage(
              context,
              prep == null
                  ? const PrepChatPage()
                  : PrepQuestionsPage(prepId: prep.id),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoVisits extends StatelessWidget {
  const _NoVisits();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return GurtuCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.medical_services_rounded, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.noVisitsTitle, style: t.titleMedium),
                const SizedBox(height: 2),
                Text(l.noVisitsBody, style: t.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One past visit: when, who, why, and a short excerpt of what was said.
class VisitCard extends StatelessWidget {
  const VisitCard({super.key, required this.visit});

  final DoctorVisit visit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final reason = l.reasonOf(visit);
    final notes = l.notesOf(visit);
    final medicines = l.medicinesOf(visit);
    final tests = l.testsOf(visit);

    return GurtuCard(
      onTap: () => pushPage(context, VisitDetailPage(visitId: visit.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(dateLabel(context, visit.date), color: GurtuColors.info),
          const SizedBox(height: 6),
          Text(l.doctorLabel(visit), style: t.titleMedium),
          if (reason.isNotEmpty) Text(reason, style: t.bodyMedium),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              notes,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.bodyMedium?.copyWith(color: GurtuColors.textPrimary),
            ),
          ],
          if (medicines.isNotEmpty ||
              tests.isNotEmpty ||
              visit.nextVisit != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (medicines.isNotEmpty)
                  _Tag(Icons.medication_rounded, l.medicinesSection),
                if (tests.isNotEmpty)
                  _Tag(Icons.biotech_rounded, l.testsSection),
                if (visit.nextVisit != null)
                  _Tag(
                    Icons.event_rounded,
                    l.nextVisitOn(dateLabel(context, visit.nextVisit!)),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: GurtuColors.surfaceHigh,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: GurtuColors.textSecondary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: GurtuColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
