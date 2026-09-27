import 'package:flutter/material.dart';

import '../../data/care_models.dart';
import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../memory/memory_detail_page.dart';
import '../../widgets/gurtu_page.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../care_text.dart';

/// The latest few care moments. Each one keeps its source one tap away —
/// nothing on Home reads as unexplained truth.
class RecentMemory extends StatelessWidget {
  const RecentMemory({super.key, required this.onViewAll});

  final VoidCallback onViewAll;

  static const _maxOnHome = 3;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final moments = repo.recentMoments.take(_maxOnHome).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l.recentMemory,
          action: moments.isEmpty ? null : l.viewAll,
          onAction: onViewAll,
        ),
        GurtuCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: moments.isEmpty
              ? const _Empty()
              : Column(
                  children: [
                    for (var i = 0; i < moments.length; i++) ...[
                      MomentRow(moment: moments[i]),
                      if (i != moments.length - 1)
                        const Divider(height: 1, color: GurtuColors.outline),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.auto_stories_rounded,
            color: GurtuColors.primary,
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l.emptyMemory,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class MomentRow extends StatelessWidget {
  const MomentRow({super.key, required this.moment});

  final CareMoment moment;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final by = repo.memberById(moment.createdBy);
    final byName = by == null ? null : (by.isYou ? l.rowYou : by.name);
    final detail = l.momentDetail(moment);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(
            icon: momentIcon(moment.type),
            color: momentColor(moment.type),
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.momentTitle(moment), style: t.titleMedium),
                if (detail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMedium?.copyWith(
                      color: GurtuColors.textPrimary,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  [
                    whenLabel(context, moment.timestamp),
                    if (byName != null) l.addedBy(byName),
                  ].join(' · '),
                  style: t.bodySmall,
                ),
                // Source is always one tap away.
                TextButton.icon(
                  onPressed: () => moment.isSample
                      ? showSourceSheet(context, moment)
                      : pushPage(
                          context,
                          MemoryDetailPage(momentId: moment.id),
                        ),
                  icon: Icon(
                    moment.type == MomentType.voice
                        ? Icons.play_circle_rounded
                        : Icons.open_in_new_rounded,
                    size: 18,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: GurtuColors.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(48, 40),
                    alignment: Alignment.centerLeft,
                    textStyle: const TextStyle(
                      fontFamily: GurtuFonts.sans,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  label: Text(
                    '${l.sourceAction(moment.type)} · ${l.sourceLabel(moment.type)}',
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

Future<void> showSourceSheet(BuildContext context, CareMoment moment) =>
    showGurtuSheet(context, (_) => _SourceSheet(moment: moment));

class _SourceSheet extends StatelessWidget {
  const _SourceSheet({required this.moment});

  final CareMoment moment;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final by = repo.memberById(moment.createdBy);
    final detail = l.momentDetail(moment);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetGrabber(),
            const SizedBox(height: 16),
            Eyebrow(l.sourceTitle),
            const SizedBox(height: 8),
            Row(
              children: [
                IconBadge(
                  icon: momentIcon(moment.type),
                  color: momentColor(moment.type),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.sourceLabel(moment.type), style: t.titleLarge),
                      Text(
                        whenLabel(context, moment.timestamp),
                        style: t.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l.momentTitle(moment), style: t.titleMedium),
            if (detail.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                detail,
                style: t.bodyLarge?.copyWith(color: GurtuColors.textPrimary),
              ),
            ],
            if (by != null) ...[
              const SizedBox(height: 8),
              Text(
                l.addedBy(by.isYou ? l.rowYou : by.name),
                style: t.bodySmall,
              ),
            ],
            // TODO: play / show the original once capture stores files in
            // SourceRef.reference.
            if (moment.isSample) ...[
              const SizedBox(height: 16),
              InfoBanner(
                text: l.sourceSampleNote,
                icon: Icons.info_rounded,
                color: GurtuColors.info,
              ),
            ],
            const SizedBox(height: 20),
            GurtuButton(
              label: l.close,
              style: GurtuButtonStyle.ghost,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
