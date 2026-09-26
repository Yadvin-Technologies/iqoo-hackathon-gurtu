import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../onboarding_flow.dart';
import '../onboarding_state.dart';
import '../step_scaffold.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _name = TextEditingController();
  final _yourName = TextEditingController();
  final _age = TextEditingController();
  bool _restored = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pages are rebuilt when the user comes back, so refill from saved answers.
    if (_restored) return;
    _restored = true;
    final data = OnboardingScope.of(context);
    _name.text = data.patientName;
    _yourName.text = data.yourName;
    _age.text = data.age?.toString() ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _yourName.dispose();
    _age.dispose();
    super.dispose();
  }

  void _setAge(OnboardingState data, int? value) {
    final clamped = value?.clamp(1, 120);
    data.update(() => data.age = clamped);
    final text = clamped?.toString() ?? '';
    if (_age.text != text) {
      _age.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = OnboardingScope.of(context);
    final self = data.isForSelf;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;

    final valid =
        data.patientName.trim().isNotEmpty &&
        data.age != null &&
        (self || data.yourName.trim().isNotEmpty);

    return StepScaffold(
      title: self ? l.profileTitleSelf : l.profileTitleOther,
      subtitle: self ? l.profileSubtitleSelf : l.profileSubtitleOther,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Label(self ? l.yourName : l.whatDoYouCallThem),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: _inputStyle,
            decoration: InputDecoration(
              hintText: l.exampleName(self ? l.sampleSelfName : l.motherName),
              prefixIcon: const Icon(Icons.badge_rounded),
            ),
            onChanged: (v) => data.update(() => data.patientName = v),
          ),
          const SizedBox(height: 24),
          _Label(self ? l.yourAge : l.theirAge),
          _AgeStepper(
            controller: _age,
            age: data.age,
            onChanged: (v) => _setAge(data, v),
          ),
          const SizedBox(height: 24),
          _Label(l.gender, optional: true),
          Row(
            children: [
              for (final (g, label, icon) in [
                (Gender.female, l.female, Icons.female_rounded),
                (Gender.male, l.male, Icons.male_rounded),
                (Gender.other, l.genderOther, Icons.transgender_rounded),
              ]) ...[
                Expanded(
                  child: _GenderOption(
                    label: label,
                    icon: icon,
                    selected: data.gender == g,
                    onTap: () => data.update(
                      () => data.gender = data.gender == g ? null : g,
                    ),
                  ),
                ),
                if (g != Gender.other) const SizedBox(width: 10),
              ],
            ],
          ),
          if (!self) ...[
            const SizedBox(height: 32),
            Text(l.andYou, style: t.titleLarge),
            const SizedBox(height: 4),
            Text(l.andYouBody, style: t.bodyMedium),
            const SizedBox(height: 14),
            _Label(l.yourName),
            TextField(
              controller: _yourName,
              textCapitalization: TextCapitalization.words,
              style: _inputStyle,
              decoration: InputDecoration(
                hintText: l.exampleName(l.sampleYourName),
                prefixIcon: const Icon(Icons.person_rounded),
              ),
              onChanged: (v) => data.update(() => data.yourName = v),
            ),
          ],
        ],
      ),
      bottom: GurtuButton(
        label: l.continueLabel,
        onPressed: valid ? OnboardingFlow.of(context).next : null,
      ),
    );
  }

  static const _inputStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: GurtuColors.textPrimary,
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text, {this.optional = false});

  final String text;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text.rich(
        TextSpan(
          text: text,
          style: Theme.of(context).textTheme.titleMedium,
          children: [
            if (optional)
              TextSpan(
                text: '  ${context.l10n.optional}',
                style: const TextStyle(
                  color: GurtuColors.textMuted,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Large − [age] + control; easier than a tiny keyboard for elders.
class _AgeStepper extends StatelessWidget {
  const _AgeStepper({
    required this.controller,
    required this.age,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int? age;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon, String label, int delta) => Semantics(
      button: true,
      label: label,
      child: Material(
        color: GurtuColors.surfaceHigh,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged((age ?? (delta > 0 ? 59 : 61)) + delta);
          },
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(icon, color: GurtuColors.textPrimary, size: 28),
          ),
        ),
      ),
    );

    return GurtuCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          btn(Icons.remove_rounded, context.l10n.decreaseAge, -1),
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: GurtuColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: '—',
                    hintStyle: TextStyle(
                      fontSize: 40,
                      color: GurtuColors.textMuted,
                    ),
                  ),
                  onChanged: (v) => onChanged(int.tryParse(v)),
                ),
                Text(
                  context.l10n.years,
                  style: const TextStyle(
                    color: GurtuColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          btn(Icons.add_rounded, context.l10n.increaseAge, 1),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: GurtuCard(
        onTap: onTap,
        color: selected ? GurtuColors.primarySoft : GurtuColors.surface,
        borderColor: selected ? GurtuColors.primary : GurtuColors.outline,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: selected ? GurtuColors.amber : GurtuColors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: GurtuColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
