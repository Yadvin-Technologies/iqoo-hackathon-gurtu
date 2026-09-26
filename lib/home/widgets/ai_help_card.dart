import 'package:flutter/material.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';

/// Entry to Gurtu AI. One card only, with two example questions so people
/// see what kind of thing to ask.
class AiHelpCard extends StatelessWidget {
  const AiHelpCard({super.key, required this.onAsk});

  /// Opens the AI tab, optionally with a question already typed.
  final ValueChanged<String?> onAsk;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        gradient: LinearGradient(
          colors: [GurtuColors.primarySoft, GurtuColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: GurtuColors.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: GurtuColors.primaryGradient,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.askGurtuTitle, style: t.titleLarge),
                    Text(l.askGurtuPrompt, style: t.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final q in [l.askQuestion, l.askExampleBloodTest]) ...[
            _Example(text: q, onTap: () => onAsk(q)),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.verified_user_rounded,
                size: 16,
                color: GurtuColors.leaf,
              ),
              const SizedBox(width: 6),
              Expanded(child: Text(l.askGurtuNote, style: t.bodySmall)),
            ],
          ),
          const SizedBox(height: 12),
          GurtuButton(
            label: l.askGurtuTitle,
            icon: Icons.arrow_forward_rounded,
            onPressed: () => onAsk(null),
          ),
        ],
      ),
    );
  }
}

class _Example extends StatelessWidget {
  const _Example({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GurtuColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18,
                  color: GurtuColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: GurtuColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
