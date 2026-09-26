import 'package:flutter/material.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../onboarding_flow.dart';
import '../onboarding_state.dart';
import '../step_scaffold.dart';

/// Picks the phrasing for "you" vs. a named family member.
String _ask(
  OnboardingState d,
  String forSelf,
  String Function(String) forOther,
) => d.isForSelf ? forSelf : forOther(d.patientLabel);

class ConditionsPage extends StatelessWidget {
  const ConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final d = OnboardingScope.of(context);
    final flow = OnboardingFlow.of(context);
    final l = context.l10n;
    const none = HealthCondition.none;
    return StepScaffold(
      title: _ask(d, l.conditionsTitleSelf, l.conditionsTitleOther),
      subtitle: l.conditionsSubtitle,
      onSkip: flow.next,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final c in HealthCondition.values)
                GurtuChip(
                  label: c.label(l),
                  icon: c == none ? Icons.block_rounded : null,
                  selected: d.conditions.contains(c),
                  onTap: () => d.toggle(d.conditions, c, exclusive: none),
                ),
            ],
          ),
          const SizedBox(height: 24),
          InfoBanner(
            text: l.notADoctor,
            icon: Icons.health_and_safety_rounded,
            color: GurtuColors.amber,
          ),
        ],
      ),
      bottom: GurtuButton(
        label: l.continueLabel,
        onPressed: d.conditions.isEmpty ? null : flow.next,
      ),
    );
  }
}

class MedicinesPage extends StatelessWidget {
  const MedicinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final d = OnboardingScope.of(context);
    final flow = OnboardingFlow.of(context);
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    return StepScaffold(
      title: _ask(d, l.medicinesTitleSelf, l.medicinesTitleOther),
      subtitle: l.medicinesSubtitle,
      onSkip: flow.next,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (v, icon) in const [
            (YesNoUnsure.yes, Icons.medication_rounded),
            (YesNoUnsure.no, Icons.do_not_disturb_on_rounded),
            (YesNoUnsure.unsure, Icons.help_rounded),
          ]) ...[
            ChoiceTile(
              title: v.label(l),
              icon: icon,
              selected: d.takesMedicines == v,
              onTap: () => d.update(() => d.takesMedicines = v),
            ),
            const SizedBox(height: 12),
          ],
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: d.takesMedicines != YesNoUnsure.yes
                ? const SizedBox(width: double.infinity)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(l.howMany, style: t.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final c in MedicineCount.values)
                            GurtuChip(
                              label: c.label(l),
                              selected: d.medicineCount == c,
                              onTap: () => d.update(() => d.medicineCount = c),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InfoBanner(
                        text: l.scanLaterTip,
                        icon: Icons.document_scanner_rounded,
                        color: GurtuColors.info,
                      ),
                    ],
                  ),
          ),
        ],
      ),
      bottom: GurtuButton(
        label: l.continueLabel,
        onPressed: d.takesMedicines == null ? null : flow.next,
      ),
    );
  }
}

class AllergiesPage extends StatelessWidget {
  const AllergiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final d = OnboardingScope.of(context);
    final flow = OnboardingFlow.of(context);
    final l = context.l10n;
    const none = Allergy.none;
    return StepScaffold(
      title: _ask(d, l.allergiesTitleSelf, l.allergiesTitleOther),
      subtitle: l.allergiesSubtitle,
      onSkip: flow.next,
      body: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final a in Allergy.values)
            GurtuChip(
              label: a.label(l),
              icon: switch (a) {
                Allergy.none => Icons.check_rounded,
                Allergy.unsure => Icons.help_outline_rounded,
                _ => null,
              },
              selected: d.allergies.contains(a),
              onTap: () => d.toggle(d.allergies, a, exclusive: none),
            ),
        ],
      ),
      bottom: GurtuButton(
        label: l.continueLabel,
        onPressed: d.allergies.isEmpty ? null : flow.next,
      ),
    );
  }
}

class MobilityPage extends StatelessWidget {
  const MobilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final d = OnboardingScope.of(context);
    final flow = OnboardingFlow.of(context);
    final l = context.l10n;
    return StepScaffold(
      title: _ask(d, l.mobilityTitleSelf, l.mobilityTitleOther),
      subtitle: l.mobilitySubtitle,
      onSkip: flow.next,
      body: Column(
        children: [
          for (final m in Mobility.values) ...[
            ChoiceTile(
              title: m.label(l),
              hint: m.hint(l),
              icon: m.icon,
              selected: d.mobility == m,
              onTap: () => d.update(() => d.mobility = m),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
      bottom: GurtuButton(
        label: l.continueLabel,
        onPressed: d.mobility == null ? null : flow.next,
      ),
    );
  }
}

class HospitalVisitPage extends StatelessWidget {
  const HospitalVisitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final d = OnboardingScope.of(context);
    final flow = OnboardingFlow.of(context);
    final l = context.l10n;
    return StepScaffold(
      title: _ask(d, l.hospitalTitleSelf, l.hospitalTitleOther),
      subtitle: l.hospitalSubtitle,
      onSkip: flow.next,
      body: Column(
        children: [
          for (final (v, icon) in const [
            (YesNoUnsure.yes, Icons.local_hospital_rounded),
            (YesNoUnsure.no, Icons.home_rounded),
          ]) ...[
            ChoiceTile(
              title: v.label(l),
              icon: icon,
              selected: d.recentHospitalVisit == v,
              onTap: () => d.update(() => d.recentHospitalVisit = v),
            ),
            const SizedBox(height: 12),
          ],
          if (d.recentHospitalVisit == YesNoUnsure.yes) ...[
            const SizedBox(height: 8),
            InfoBanner(
              text: l.hospitalTip,
              icon: Icons.tips_and_updates_rounded,
              color: GurtuColors.amber,
            ),
          ],
        ],
      ),
      bottom: GurtuButton(
        label: l.continueLabel,
        onPressed: d.recentHospitalVisit == null ? null : flow.next,
      ),
    );
  }
}
