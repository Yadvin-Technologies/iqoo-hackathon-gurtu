import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../visits/prep_chat_page.dart';
import '../../visits/prep_questions_page.dart';
import '../../visits/visit_text.dart';
import '../../visits/visits_page.dart';
import '../../widgets/gurtu_page.dart';

/// Two one-tap doorways right under Capture Care: everything from past
/// appointments, and help deciding what to ask at the next one.
class DoctorShortcuts extends StatelessWidget {
  const DoctorShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final next = repo.nextPlannedVisit();
    final last = repo.doctorVisits.firstOrNull;
    final prep = repo.openPrep;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _Tile(
              icon: Icons.medical_services_rounded,
              color: GurtuColors.info,
              title: l.doctorVisit,
              subtitle: next != null
                  ? l.nextVisitOn(dateLabel(context, next))
                  : last != null
                  ? l.lastVisitOn(dateLabel(context, last.date))
                  : l.doctorVisitHint,
              onTap: () => pushPage(context, const VisitsPage()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Tile(
              icon: Icons.record_voice_over_rounded,
              color: GurtuColors.orange,
              highlight: true,
              title: l.askDoctor,
              subtitle: prep != null
                  ? l.questionsReady(prep.questions.length)
                  : l.askDoctorHint,
              onTap: () => pushPage(
                context,
                prep != null
                    ? PrepQuestionsPage(prepId: prep.id)
                    : const PrepChatPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  /// Amber-tinted, so the AI helper stands out as the thing to try.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      excludeSemantics: true,
      // Shadow outside the Material so the ink layer doesn't clip it into a
      // square.
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(GurtuSpace.radius),
          boxShadow: [
            BoxShadow(
              color: GurtuColors.primaryDeep.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(GurtuSpace.radius),
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GurtuColors.surface,
                gradient: highlight
                    ? LinearGradient(
                        colors: [
                          GurtuColors.amberBright.withValues(alpha: 0.18),
                          GurtuColors.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(GurtuSpace.radius),
                border: Border.all(
                  color: highlight
                      ? GurtuColors.amberBright.withValues(alpha: 0.6)
                      : GurtuColors.outline,
                  width: 1.4,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(icon, color: color, size: 24),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: GurtuColors.textMuted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: t.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: t.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
