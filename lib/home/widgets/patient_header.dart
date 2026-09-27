import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/care_models.dart';
import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../medicines/medicine_list_page.dart';
import '../../onboarding/onboarding_state.dart';
import '../../people/add_person.dart';
import '../../theme/gurtu_theme.dart';
import '../../visits/visits_page.dart';
import '../../widgets/gurtu_page.dart';
import '../../widgets/gurtu_widgets.dart';

/// Who is being cared for, how today is going, and three live numbers from
/// their records: medicines, doses taken today, next doctor visit. Tap the
/// name to switch person; tap a number to open it.
class PatientHeader extends StatelessWidget {
  const PatientHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final patient = repo.selectedPatient!;
    final l = context.l10n;
    final attention = repo.needsAttention();
    final medicines = repo.medicineList.length;
    final doses = repo.dosesToday();
    final next = repo.nextPlannedVisit();
    final conditions = [
      for (final c in patient.conditions)
        if (HealthCondition.values.asNameMap()[c] case final cond?)
          cond.label(l),
    ];
    final about = [
      if (patient.age != null) l.ageYears(patient.age!),
      ...conditions,
    ].join(' · ');

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GurtuSpace.radiusLg),
        boxShadow: [
          BoxShadow(
            color: GurtuColors.primary.withValues(alpha: 0.32),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(GurtuSpace.radiusLg),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B5CFF), Color(0xFF4F36C9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Soft rings in the corner, echoing the splash screen.
              Positioned(
                right: -40,
                top: -50,
                child: _Ring(size: 170, alpha: 0.10),
              ),
              Positioned(
                right: 30,
                top: -80,
                child: _Ring(size: 120, alpha: 0.07),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      button: true,
                      label:
                          '${patient.isSelf ? l.yourCare : l.caringFor}: '
                          '${patient.name}',
                      excludeSemantics: true,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => showGurtuSheet(
                            context,
                            (_) => _PatientSwitcher(host: context),
                          ),
                          child: Row(
                            children: [
                              _PatientAvatar(patient: patient, size: 60),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient.isSelf ? l.yourCare : l.caringFor,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.75,
                                        ),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            patient.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              height: 1.2,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          width: 26,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(
                                              alpha: 0.18,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (about.isNotEmpty)
                                      Text(
                                        about,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _StatusChip(attention: attention),
                    ),
                    const SizedBox(height: 14),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _Stat(
                              icon: Icons.medication_rounded,
                              value: '$medicines',
                              label: l.medicinesSection,
                              onTap: () =>
                                  pushPage(context, const MedicineListPage()),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _Stat(
                              icon: Icons.task_alt_rounded,
                              value: doses.total == 0
                                  ? '—'
                                  : '${doses.taken}/${doses.total}',
                              label: l.takenToday,
                              onTap: () =>
                                  pushPage(context, const MedicineListPage()),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _Stat(
                              icon: Icons.event_rounded,
                              value: next == null
                                  ? '—'
                                  : MaterialLocalizations.of(context)
                                        .formatShortMonthDay(next),
                              label: l.nextVisit,
                              onTap: () =>
                                  pushPage(context, const VisitsPage()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.alpha});

  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    ),
  );
}

/// One number from the records on the patient card.
class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label: $value',
      excludeSemantics: true,
      child: Material(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: GurtuColors.amberBright),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
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

/// Icon + words, never colour alone.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.attention});

  final bool attention;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final color = attention ? GurtuColors.amber : GurtuColors.leaf;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            attention
                ? Icons.error_outline_rounded
                : Icons.check_circle_rounded,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              attention ? l.statusNeedsAttention : l.statusOnTrack,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientAvatar extends StatelessWidget {
  const _PatientAvatar({required this.patient, required this.size});

  final PatientProfile patient;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Amber ring: the one iQOO accent on the patient.
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: GurtuColors.iqooGradient,
      ),
      child: InitialsAvatar(
        label: initialOf(patient.name),
        color: avatarColor(patient.id),
        size: size - 6,
      ),
    );
  }
}

/// Switches the whole Home context to another person. Nothing is shared
/// between patients: every section reads from the selected one only.
class _PatientSwitcher extends StatelessWidget {
  const _PatientSwitcher({required this.host});

  /// Home, which outlives this sheet: "Add" opens its own sheet from it.
  final BuildContext host;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final selected = repo.selectedPatient?.id;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetGrabber(),
            const SizedBox(height: 16),
            Text(
              l.switchPatientTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            for (final p in repo.patients) ...[
              ChoiceTile(
                title: p.isSelf ? '${p.name} (${l.rowYou})' : p.name,
                hint: p.age == null ? null : l.ageYears(p.age!),
                leading: _PatientAvatar(patient: p, size: 48),
                selected: p.id == selected,
                onTap: () {
                  repo.selectPatient(p.id);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
            ChoiceTile(
              title: l.addAnotherPerson,
              icon: Icons.person_add_alt_1_rounded,
              selected: false,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                showAddPersonSheet(host);
              },
            ),
          ],
        ),
      ),
    );
  }
}
