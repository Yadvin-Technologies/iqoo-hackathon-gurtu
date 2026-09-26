import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import 'gurtu_widgets.dart';

/// Two-column picker of all app languages. Tapping one switches the whole
/// app immediately. Used in onboarding and in Profile.
class LanguageGrid extends StatelessWidget {
  const LanguageGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LanguageScope.of(context);
    final current = controller.value;
    return LayoutBuilder(
      builder: (context, box) {
        const gap = 12.0;
        final width = (box.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final lang in AppLanguage.values)
              SizedBox(
                width: width,
                child: _LanguageCard(
                  language: lang,
                  selected: lang == current,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    controller.select(lang);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${language.nativeName}, ${language.englishName}',
      excludeSemantics: true,
      child: GurtuCard(
        onTap: onTap,
        color: selected ? GurtuColors.primarySoft : GurtuColors.surface,
        borderColor: selected ? GurtuColors.primary : GurtuColors.outline,
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
        child: Row(
          children: [
            // The check sits on the letter tile so the name keeps the full
            // width — some native names are long (മലയാളം, ગુજરાતી).
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: selected ? GurtuColors.primaryGradient : null,
                    color: selected ? null : GurtuColors.surfaceHigh,
                  ),
                  child: Text(
                    language.glyph,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : GurtuColors.primary,
                    ),
                  ),
                ),
                if (selected)
                  Positioned(
                    right: -5,
                    bottom: -5,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: GurtuColors.surface,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: GurtuColors.leaf,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.nativeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: GurtuColors.textPrimary,
                    ),
                  ),
                  Text(
                    language.englishName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: GurtuColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
