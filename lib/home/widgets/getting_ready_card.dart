import 'package:flutter/material.dart';

import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';

/// First-time checklist. Nothing is forced; it can be hidden anytime.
class GettingReadyCard extends StatelessWidget {
  const GettingReadyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final steps = [
      (l.readyYourProfile, true),
      (l.readyPatientProfile, true),
      (l.readyCareCircle, repo.hasCareCircle),
      (l.readyEmergencyContact, repo.hasEmergencyContact),
    ];
    final done = steps.where((s) => s.$2).length;

    return GurtuCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Expanded(child: Eyebrow(l.gettingReady)),
                Text(
                  '$done / ${steps.length}',
                  style: t.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (final (label, ok) in steps)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Icon(
                    ok
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: ok ? GurtuColors.leaf : GurtuColors.textMuted,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: t.bodyLarge?.copyWith(
                        color: ok
                            ? GurtuColors.textSecondary
                            : GurtuColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            children: [
              if (!repo.hasSampleData)
                TextButton.icon(
                  onPressed: () =>
                      repo.addSampleData(secondPatientName: l.fatherName),
                  icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                  style: _linkStyle(GurtuColors.primary),
                  label: Text(l.previewSampleData),
                ),
              TextButton(
                onPressed: repo.dismissSetupCard,
                style: _linkStyle(GurtuColors.textSecondary),
                child: Text(l.hide),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static ButtonStyle _linkStyle(Color color) => TextButton.styleFrom(
    foregroundColor: color,
    minimumSize: const Size(48, 48),
    textStyle: const TextStyle(
      fontFamily: GurtuFonts.sans,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    ),
  );
}
