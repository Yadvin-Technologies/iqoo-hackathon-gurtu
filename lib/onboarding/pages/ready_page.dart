import 'package:flutter/material.dart';

import '../../ai/on_device_ai.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/ai_status.dart';
import '../../widgets/gurtu_widgets.dart';
import '../onboarding_flow.dart';
import '../onboarding_state.dart';

class ReadyPage extends StatelessWidget {
  const ReadyPage({super.key, required this.onEnter});

  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final d = OnboardingScope.of(context);
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final language = LanguageScope.of(context).value;
    final greetName = (d.isForSelf ? d.patientName : d.yourName).trim();

    String join(Iterable<String> items) =>
        items.isEmpty ? l.notAdded : items.join(', ');

    final rows = <(IconData, String, String)>[
      (
        Icons.person_rounded,
        d.isForSelf ? l.rowYou : l.rowCaringFor,
        [
          if (d.patientName.trim().isNotEmpty) d.patientName.trim(),
          if (d.age != null) l.ageYears(d.age!),
        ].join(' · '),
      ),
      (
        Icons.monitor_heart_rounded,
        l.rowHealth,
        join(d.conditions.map((c) => c.label(l))),
      ),
      (
        Icons.warning_amber_rounded,
        l.rowAllergies,
        join(d.allergies.map((a) => a.label(l))),
      ),
      (Icons.translate_rounded, l.rowLanguage, language.nativeName),
      (
        Icons.auto_awesome_rounded,
        l.rowAi,
        aiStatusLine(l, AiScope.of(context)),
      ),
    ];

    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: IconButton(
                onPressed: OnboardingFlow.of(context).back,
                tooltip: l.back,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: GurtuColors.textPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: GurtuSpace.gutter,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const _SuccessBadge(),
                  const SizedBox(height: 24),
                  Text(
                    greetName.isEmpty ? l.allSet : l.allSetName(greetName),
                    textAlign: TextAlign.center,
                    style: t.displaySmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    d.isForSelf ? l.readySelf : l.readyOther(d.patientLabel),
                    textAlign: TextAlign.center,
                    style: t.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  GurtuCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < rows.length; i++) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  rows[i].$1,
                                  size: 22,
                                  color: GurtuColors.amber,
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 110,
                                  child: Text(rows[i].$2, style: t.bodyMedium),
                                ),
                                Expanded(
                                  child: Text(
                                    rows[i].$3,
                                    style: t.titleMedium?.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i != rows.length - 1)
                            const Divider(
                              height: 1,
                              color: GurtuColors.outline,
                            ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l.careQuote,
                    textAlign: TextAlign.center,
                    style: GurtuFonts.handwritten(
                      context,
                      color: GurtuColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              GurtuSpace.gutter,
              8,
              GurtuSpace.gutter,
              16,
            ),
            child: GurtuButton(
              label: l.enterGurtu,
              icon: Icons.arrow_forward_rounded,
              style: GurtuButtonStyle.amber,
              onPressed: onEnter,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: GurtuColors.iqooGradient,
          boxShadow: [
            BoxShadow(
              color: GurtuColors.orange.withValues(alpha: 0.45),
              blurRadius: 48,
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: GurtuColors.surface,
          ),
          child: const Center(
            child: Icon(Icons.eco_rounded, size: 56, color: GurtuColors.leaf),
          ),
        ),
      ),
    );
  }
}
