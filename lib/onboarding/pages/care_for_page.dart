import 'package:flutter/material.dart';

import '../../l10n/language.dart';
import '../../widgets/gurtu_widgets.dart';
import '../onboarding_flow.dart';
import '../onboarding_state.dart';
import '../step_scaffold.dart';

class CareForPage extends StatelessWidget {
  const CareForPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = OnboardingScope.of(context);
    final l = context.l10n;
    return StepScaffold(
      title: l.careForTitle,
      subtitle: l.careForSubtitle,
      body: Column(
        children: [
          for (final c in CareFor.values) ...[
            ChoiceTile(
              title: c.label(l),
              hint: c.hint(l),
              icon: c.icon,
              selected: data.careFor == c,
              onTap: () => data.update(() => data.careFor = c),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
      bottom: GurtuButton(
        label: l.continueLabel,
        onPressed: data.careFor == null
            ? null
            : OnboardingFlow.of(context).next,
      ),
    );
  }
}
