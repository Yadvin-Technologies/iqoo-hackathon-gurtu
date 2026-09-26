import 'package:flutter/material.dart';

import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_widgets.dart';
import 'onboarding_flow.dart';

/// Shared layout for every onboarding question: top bar with back + progress,
/// eyebrow, big title, subtitle, scrollable body and a pinned bottom action.
class StepScaffold extends StatelessWidget {
  const StepScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.bottom,
    this.subtitle,
    this.onSkip,
    this.skipLabel,
    this.hero,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget bottom;
  final VoidCallback? onSkip;
  final String? skipLabel;

  /// Optional visual above the title (e.g. icon badge).
  final Widget? hero;

  @override
  Widget build(BuildContext context) {
    final flow = OnboardingFlow.of(context);
    final step = OnboardingFlow.stepIndexOf(context);
    final phase = flow.phaseAt(step);
    final t = Theme.of(context).textTheme;
    final l = context.l10n;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
            child: Row(
              children: [
                if (step == 0)
                  const SizedBox(width: 48, height: 48)
                else
                  IconButton(
                    onPressed: flow.back,
                    tooltip: l.back,
                    iconSize: 26,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: GurtuColors.textPrimary,
                    ),
                  ),
                const SizedBox(width: 4),
                Expanded(
                  child: phase == null
                      ? const SizedBox.shrink()
                      : SegmentedProgress(
                          total: OnboardingPhase.values.length,
                          current: phase.index,
                        ),
                ),
                // Sized by its label: translations vary a lot in length.
                if (onSkip == null)
                  const SizedBox(width: 48)
                else
                  TextButton(
                    onPressed: onSkip,
                    child: Text(
                      skipLabel ?? l.skip,
                      style: const TextStyle(
                        color: GurtuColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                GurtuSpace.gutter,
                20,
                GurtuSpace.gutter,
                24,
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hero != null) ...[hero!, const SizedBox(height: 20)],
                  if (phase != null) Eyebrow(flow.phaseLabelAt(l, step)),
                  const SizedBox(height: 10),
                  Text(title, style: t.headlineMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: 10),
                    Text(subtitle!, style: t.bodyLarge),
                  ],
                  const SizedBox(height: 28),
                  body,
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              GurtuSpace.gutter,
              12,
              GurtuSpace.gutter,
              16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  GurtuColors.background.withValues(alpha: 0),
                  GurtuColors.background,
                ],
              ),
            ),
            child: bottom,
          ),
        ],
      ),
    );
  }
}
