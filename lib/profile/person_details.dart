import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cloud/cloud_sync.dart';
import '../data/care_models.dart';
import '../data/care_repository.dart';
import '../l10n/language.dart';
import '../onboarding/onboarding_state.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';

extension PersonText on AppLocalizations {
  String genderLabel(String? g) => switch (g) {
    'female' => female,
    'male' => male,
    'other' => genderOther,
    _ => notAdded,
  };

  String listOf<T extends Enum>(
    List<T> all,
    List<String> picked,
    String Function(T) label,
  ) {
    final out = [
      for (final name in picked)
        if (all.asNameMap()[name] case final v?) label(v),
    ];
    return out.isEmpty ? notAdded : out.join(', ');
  }

  String? oneOf<T extends Enum>(
    List<T> all,
    String? picked,
    String Function(T) label,
  ) {
    final v = all.asNameMap()[picked];
    return v == null ? null : label(v);
  }
}

/// Profile: what was told about the person during onboarding (and you),
/// shown plainly, with a way to change it.
class PersonDetailsCard extends StatelessWidget {
  const PersonDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = repo.selectedPatient;
    if (p == null) return const SizedBox.shrink();

    final medicines = switch (YesNoUnsure.values
        .asNameMap()[p.takesMedicines]) {
      null => l.notAdded,
      YesNoUnsure.yes => [
        l.yes,
        ?l.oneOf(MedicineCount.values, p.medicineCount, (c) => c.label(l)),
      ].join(' · '),
      final v => v.label(l),
    };
    final rows = <(IconData, String, String)>[
      (
        Icons.badge_rounded,
        p.isSelf ? l.yourName : l.whatDoYouCallThem,
        p.name,
      ),
      (
        Icons.cake_rounded,
        p.isSelf ? l.yourAge : l.theirAge,
        p.age == null ? l.notAdded : l.ageYears(p.age!),
      ),
      (Icons.wc_rounded, l.gender, l.genderLabel(p.gender)),
      (
        Icons.monitor_heart_rounded,
        l.conditionsLabel,
        l.listOf(HealthCondition.values, p.conditions, (c) => c.label(l)),
      ),
      (
        Icons.warning_amber_rounded,
        l.rowAllergies,
        l.listOf(Allergy.values, p.allergies, (a) => a.label(l)),
      ),
      (Icons.medication_rounded, l.dailyMedicinesLabel, medicines),
      (
        Icons.directions_walk_rounded,
        l.gettingAroundLabel,
        l.oneOf(Mobility.values, p.mobility, (m) => m.label(l)) ?? l.notAdded,
      ),
      (
        Icons.local_hospital_rounded,
        l.recentHospitalLabel,
        l.oneOf(YesNoUnsure.values, p.recentHospitalVisit, (v) => v.label(l)) ??
            l.notAdded,
      ),
      if (!p.isSelf && repo.userName.isNotEmpty)
        (Icons.person_rounded, l.yourName, repo.userName),
    ];

    return GurtuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              InitialsAvatar(
                label: p.name.isEmpty ? '?' : p.name.characters.first,
                color: GurtuColors.primary,
                size: 48,
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(l.aboutPerson(p.name), style: t.titleLarge)),
            ],
          ),
          const SizedBox(height: 12),
          for (final (icon, label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: GurtuColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: t.bodySmall?.copyWith(
                            color: GurtuColors.textMuted,
                          ),
                        ),
                        Text(
                          value,
                          style: t.titleSmall?.copyWith(
                            color: value == l.notAdded
                                ? GurtuColors.textMuted
                                : GurtuColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          GurtuButton(
            label: l.editDetails,
            style: GurtuButtonStyle.ghost,
            icon: Icons.edit_rounded,
            onPressed: () => pushPage(context, EditPersonPage(patientId: p.id)),
          ),
        ],
      ),
    );
  }
}

/// Changes what onboarding asked, with the same choices.
class EditPersonPage extends StatefulWidget {
  const EditPersonPage({super.key, required this.patientId});

  final String patientId;

  @override
  State<EditPersonPage> createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  PatientProfile? _p;
  final _name = TextEditingController();
  final _you = TextEditingController();
  int? _age;
  String? _gender;
  final _conditions = <String>{};
  final _allergies = <String>{};
  String? _takesMedicines;
  String? _medicineCount;
  String? _mobility;
  String? _hospital;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_p != null) return;
    final repo = CareScope.of(context);
    final p = _p = repo.patientById(widget.patientId);
    if (p == null) return;
    _name.text = p.name;
    _you.text = repo.userName;
    _age = p.age;
    _gender = p.gender;
    _conditions.addAll(p.conditions);
    _allergies.addAll(p.allergies);
    _takesMedicines = p.takesMedicines;
    _medicineCount = p.medicineCount;
    _mobility = p.mobility;
    _hospital = p.recentHospitalVisit;
  }

  @override
  void dispose() {
    _name.dispose();
    _you.dispose();
    super.dispose();
  }

  void _toggle(Set<String> set, String value, String none) {
    setState(() {
      if (value == none) {
        set
          ..clear()
          ..add(none);
      } else {
        set.remove(none);
        if (!set.remove(value)) set.add(value);
      }
    });
  }

  void _save() {
    final p = _p;
    if (p == null || _name.text.trim().isEmpty) return;
    final repo = CareScope.of(context);
    final cloud = CloudScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    final saved = repo.updatePatient(
      PatientProfile(
        id: p.id,
        name: _name.text.trim(),
        age: _age,
        gender: _gender,
        conditions: [
          for (final c in HealthCondition.values)
            if (_conditions.contains(c.name)) c.name,
        ],
        allergies: [
          for (final a in Allergy.values)
            if (_allergies.contains(a.name)) a.name,
        ],
        careFor: p.careFor,
        takesMedicines: _takesMedicines,
        medicineCount: _takesMedicines == YesNoUnsure.yes.name
            ? _medicineCount
            : null,
        mobility: _mobility,
        recentHospitalVisit: _hospital,
        isSelf: p.isSelf,
        isSample: p.isSample,
        createdAt: p.createdAt,
      ),
    );
    if (!p.isSelf) repo.setUserName(_you.text);
    // The family's phones see the change too.
    if (saved != null) cloud.updatePatient(saved);
    HapticFeedback.mediumImpact();
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text(l.changesSaved)));
  }

  Widget _chips<T extends Enum>(
    List<T> values,
    bool Function(T) selected,
    String Function(T) label,
    void Function(T) onTap,
  ) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final v in values)
        GurtuChip(
          label: label(v),
          selected: selected(v),
          onTap: () => onTap(v),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = _p;
    if (p == null) return const SizedBox.shrink();
    return GurtuPage(
      title: l.editDetails,
      subtitle: l.aboutPerson(_name.text.trim().isEmpty ? p.name : _name.text),
      bottom: GurtuButton(
        label: l.saveChanges,
        icon: Icons.check_rounded,
        onPressed: _name.text.trim().isEmpty ? null : _save,
      ),
      children: [
        FieldLabel(p.isSelf ? l.yourName : l.whatDoYouCallThem),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(fontSize: 17),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        FieldLabel(p.isSelf ? l.yourAge : l.theirAge),
        Row(
          children: [
            IconButton.filledTonal(
              tooltip: l.decreaseAge,
              onPressed: (_age ?? 60) > 1
                  ? () => setState(() => _age = (_age ?? 60) - 1)
                  : null,
              icon: const Icon(Icons.remove_rounded),
            ),
            Expanded(
              child: Text(
                _age == null ? l.notAdded : l.ageYears(_age!),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton.filledTonal(
              tooltip: l.increaseAge,
              onPressed: (_age ?? 60) < 120
                  ? () => setState(() => _age = (_age ?? 59) + 1)
                  : null,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 20),
        FieldLabel(l.gender),
        _chips(
          Gender.values,
          (g) => _gender == g.name,
          (g) => l.genderLabel(g.name),
          (g) => setState(() => _gender = g.name),
        ),
        const SizedBox(height: 20),
        FieldLabel(l.conditionsLabel, icon: Icons.monitor_heart_rounded),
        _chips(
          HealthCondition.values,
          (c) => _conditions.contains(c.name),
          (c) => c.label(l),
          (c) => _toggle(_conditions, c.name, HealthCondition.none.name),
        ),
        const SizedBox(height: 20),
        FieldLabel(l.rowAllergies, icon: Icons.warning_amber_rounded),
        _chips(
          Allergy.values,
          (a) => _allergies.contains(a.name),
          (a) => a.label(l),
          (a) => _toggle(_allergies, a.name, Allergy.none.name),
        ),
        const SizedBox(height: 20),
        FieldLabel(l.dailyMedicinesLabel, icon: Icons.medication_rounded),
        _chips(
          YesNoUnsure.values,
          (v) => _takesMedicines == v.name,
          (v) => v.label(l),
          (v) => setState(() => _takesMedicines = v.name),
        ),
        if (_takesMedicines == YesNoUnsure.yes.name) ...[
          const SizedBox(height: 12),
          FieldLabel(l.howMany),
          _chips(
            MedicineCount.values,
            (c) => _medicineCount == c.name,
            (c) => c.label(l),
            (c) => setState(() => _medicineCount = c.name),
          ),
        ],
        const SizedBox(height: 20),
        FieldLabel(l.gettingAroundLabel, icon: Icons.directions_walk_rounded),
        _chips(
          Mobility.values,
          (m) => _mobility == m.name,
          (m) => m.label(l),
          (m) => setState(() => _mobility = m.name),
        ),
        const SizedBox(height: 20),
        FieldLabel(l.recentHospitalLabel, icon: Icons.local_hospital_rounded),
        _chips(
          YesNoUnsure.values,
          (v) => _hospital == v.name,
          (v) => v.label(l),
          (v) => setState(() => _hospital = v.name),
        ),
        if (!p.isSelf) ...[
          const SizedBox(height: 20),
          FieldLabel(l.yourName, icon: Icons.person_rounded),
          TextField(
            controller: _you,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ],
    );
  }
}
