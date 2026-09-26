import 'package:flutter/material.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../../widgets/language_grid.dart';
import '../onboarding_flow.dart';
import '../step_scaffold.dart';

/// First onboarding screen. Tapping a language switches the whole app to it
/// straight away, including this screen, so people can see it is right.
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final current = LanguageScope.of(context).value;
    final l = context.l10n;

    return StepScaffold(
      hero: const GurtuLogo(size: 44),
      title: l.languageTitle,
      subtitle: [
        l.languageSubtitle,
        // Keep an English hint in case someone lands on the wrong language.
        if (current != AppLanguage.english) 'Choose your language',
      ].join('\n'),
      body: Column(
        children: [
          const LanguageGrid(),
          const SizedBox(height: 20),
          InfoBanner(
            text: l.languageMixNote,
            icon: Icons.translate_rounded,
            color: GurtuColors.info,
          ),
        ],
      ),
      bottom: GurtuButton(
        label: l.continueLabel,
        icon: Icons.arrow_forward_rounded,
        onPressed: OnboardingFlow.of(context).next,
      ),
    );
  }
}
