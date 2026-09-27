import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

/// Every appointment for the selected patient, in the order people think
/// about them: what's next (and the questions for it), a few numbers, then
/// each past visit. Pull down to refresh.
class VisitsPage extends StatelessWidget {
  const VisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final visits = repo.doctorVisits;
    final prep = repo.openPrep;
    final next = repo.nextPlannedVisit();

    return GurtuPage(
      title: l.visitsTitle,
      subtitle: l.visitsSubtitle,
      onRefresh: repo.reload,
      bottom: GurtuButton(
        label: l.recordVisit,
        icon: Icons.mic_rounded,
        onPressed: () => pushPage(context, VisitRecorderPage(prepId: prep?.id)),
      ),
      children: [
        _NextVisitCard(
          next: next,
          // The visit where the doctor asked to come back then.
          from: next == null
              ? null
              : visits
                    .where(
                      (v) =>
                          v.nextVisit != null &&
                          DateUtils.isSameDay(v.nextVisit, next),
                    )
                    .firstOrNull,
          prep: prep,
        ),
        if (visits.isNotEmpty) ...[
          const SizedBox(height: 16),
          _Summary(visits: visits),
        ],
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

/// "Today", "Tomorrow" or "In 31 days".
String _fromToday(AppLocalizations l, DateTime date) {
  final days = DateUtils.dateOnly(date)
      .difference(DateUtils.dateOnly(DateTime.now()))
      .inDays;
  return switch (days) {
    <= 0 => l.today,
    1 => l.tomorrow,
    _ => l.inDays(days),
  };
}

/// Formats with the app language, falling back to English where the phone
/// has no date names for it.
String _format(BuildContext context, String pattern, DateTime date) {
  final tag = Localizations.localeOf(context).toLanguageTag();
  try {
    return DateFormat(pattern, tag).format(date);
  } on Object {
    return DateFormat(pattern, 'en').format(date);
  }
}

/// The next appointment and the questions to take to it, together: the
/// two things to act on.
class _NextVisitCard extends StatelessWidget {
  const _NextVisitCard({
    required this.next,
    required this.from,
    required this.prep,
  });

  final DateTime? next;
  final DoctorVisit? from;
  final VisitPrep? prep;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final next = this.next;
    final prep = this.prep;

    return GurtuCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      borderColor: next == null
          ? GurtuColors.outline
          : GurtuColors.leaf.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Eyebrow(
            l.nextVisit.toUpperCase(),
            color: next == null ? GurtuColors.textMuted : GurtuColors.leaf,
          ),
          const SizedBox(height: 10),
          if (next == null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IconBadge(
                  icon: Icons.event_busy_rounded,
                  color: GurtuColors.textMuted,
                  size: 48,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.notPlanned, style: t.titleMedium),
                      const SizedBox(height: 2),
                      Text(l.noNextVisitHint, style: t.bodyMedium),
                    ],
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                _DateBlock(date: next, color: GurtuColors.leaf),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateLabel(context, next),
                        style: t.titleLarge?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      _Chip(
                        icon: Icons.schedule_rounded,
                        text: _fromToday(l, next),
                        color: GurtuColors.leaf,
                      ),
                      if (from != null && from!.doctorName.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          l.withDoctor(from!.doctorName),
                          style: t.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          const Divider(height: 32, color: GurtuColors.outline),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBadge(
                icon: Icons.record_voice_over_rounded,
                color: GurtuColors.orange,
                size: 40,
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
                      style: t.bodyMedium?.copyWith(
                        color: prep == null ? null : GurtuColors.amber,
                        fontWeight: prep == null ? null : FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (prep != null)
            for (final q in prep.questions.take(2))
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 52),
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

/// Visits so far, doctors seen, and when the last one was.
class _Summary extends StatelessWidget {
  const _Summary({required this.visits});

  final List<DoctorVisit> visits;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final doctors = {
      for (final v in visits)
        if (v.doctorName.isNotEmpty) v.doctorName.trim().toLowerCase(),
    }.length;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _Tile(
              icon: Icons.event_available_rounded,
              text: l.visitsCount(visits.length),
            ),
          ),
          // Only when doctors' names were written down.
          if (doctors > 0) ...[
            const SizedBox(width: 10),
            Expanded(
              child: _Tile(
                icon: Icons.medical_services_rounded,
                text: l.doctorsCount(doctors),
              ),
            ),
          ],
          const SizedBox(width: 10),
          Expanded(
            child: _Tile(
              icon: Icons.history_rounded,
              label: l.lastVisit,
              text: MaterialLocalizations.of(context)
                  .formatShortMonthDay(visits.first.date),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.text, this.label});

  final IconData icon;
  final String text;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      decoration: BoxDecoration(
        color: GurtuColors.surface,
        borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
        border: Border.all(color: GurtuColors.outline, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: GurtuColors.primary),
          const SizedBox(height: 8),
          if (label != null)
            Text(
              label!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.bodySmall,
            ),
          Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.titleMedium?.copyWith(fontSize: 15),
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

/// Day and month, stacked like a calendar page.
class _DateBlock extends StatelessWidget {
  const _DateBlock({required this.date, this.color = GurtuColors.primary});

  final DateTime date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _format(context, 'MMM', date).toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: color,
            ),
          ),
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 24,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            '${date.year}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: GurtuColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// One past visit: when, which doctor and why, the doctor's words, and what
/// was kept with it (recordings, medicines, photos, next date).
class VisitCard extends StatelessWidget {
  const VisitCard({super.key, required this.visit});

  final DoctorVisit visit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final doctor = l.doctorLabel(visit);
    final reason = l.reasonOf(visit);
    final notes = l.notesOf(visit);
    final tests = l.testsOf(visit);
    final recordings = visit.attachmentsFor(VisitSection.doctor).length;
    final photos = visit.attachments
        .where((a) => a.kind == AttachmentKind.photo)
        .length;
    final medicines = visit.medicines.length;
    final sampleMedicines = visit.isSample && l.medicinesOf(visit).isNotEmpty;

    return GurtuCard(
      padding: const EdgeInsets.all(16),
      onTap: () => pushPage(context, VisitDetailPage(visitId: visit.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DateBlock(date: visit.date),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(doctor, style: t.titleMedium)),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: GurtuColors.textMuted,
                    ),
                  ],
                ),
                if (reason.isNotEmpty && reason != doctor)
                  Text(reason, style: t.bodyMedium),
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    decoration: BoxDecoration(
                      color: GurtuColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.format_quote_rounded,
                              size: 16,
                              color: GurtuColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                l.doctorSaid,
                                style: t.bodySmall?.copyWith(
                                  color: GurtuColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notes,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMedium?.copyWith(
                            color: GurtuColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (recordings > 0 ||
                    medicines > 0 ||
                    sampleMedicines ||
                    photos > 0 ||
                    tests.isNotEmpty ||
                    visit.nextVisit != null) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (recordings > 0)
                        _Chip(
                          icon: Icons.graphic_eq_rounded,
                          text: l.recordingsCount(recordings),
                        ),
                      if (medicines > 0)
                        _Chip(
                          icon: Icons.medication_rounded,
                          text: l.medicinesCount(medicines),
                        )
                      else if (sampleMedicines)
                        _Chip(
                          icon: Icons.medication_rounded,
                          text: l.medicinesSection,
                        ),
                      if (photos > 0)
                        _Chip(
                          icon: Icons.photo_rounded,
                          text: l.photosCount(photos),
                        ),
                      if (tests.isNotEmpty)
                        _Chip(
                          icon: Icons.biotech_rounded,
                          text: l.testsSection,
                        ),
                      if (visit.nextVisit != null)
                        _Chip(
                          icon: Icons.event_rounded,
                          text: l.nextVisitOn(
                            dateLabel(context, visit.nextVisit!),
                          ),
                          color: GurtuColors.leaf,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.text,
    this.color = GurtuColors.textSecondary,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color == GurtuColors.textSecondary
            ? GurtuColors.surfaceHigh
            : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
