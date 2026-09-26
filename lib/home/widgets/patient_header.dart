import 'package:flutter/material.dart';

import '../../data/care_models.dart';
import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';

/// Who is being cared for, and whether today is on track. The one dark,
/// "iQOO" surface on Home; everything below it stays light and calm.
class PatientHeader extends StatelessWidget {
  const PatientHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final patient = repo.selectedPatient!;
    final l = context.l10n;
    final attention = repo.needsAttention();

    return Semantics(
      button: true,
      label: '${l.caringFor}: ${patient.name}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(GurtuSpace.radiusLg),
          onTap: () => showGurtuSheet(context, (_) => const _PatientSwitcher()),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GurtuSpace.radiusLg),
              gradient: const LinearGradient(
                colors: [Color(0xFF1B1733), Color(0xFF2B2358)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: GurtuColors.primaryDeep.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              // Keep the glow inside the rounded corners.
              clipBehavior: Clip.hardEdge,
              children: [
                // Soft iQOO amber glow in the corner — the only accent here.
                // Sits fully inside the card: the radial fade is transparent at
                // its box corners, so nothing shows past the rounded edge.
                Positioned(
                  right: 8,
                  top: -20,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          GurtuColors.amberBright.withValues(alpha: 0.28),
                          GurtuColors.amberBright.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      _PatientAvatar(patient: patient, size: 68),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.caringFor.toUpperCase(),
                              style: const TextStyle(
                                color: GurtuColors.amberBright,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    patient.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      height: 1.15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white70,
                                  size: 26,
                                ),
                              ],
                            ),
                            if (patient.age != null)
                              Text(
                                l.ageYears(patient.age!),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            const SizedBox(height: 10),
                            _StatusChip(attention: attention),
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
    final color = attention ? GurtuColors.amberBright : const Color(0xFF6FE3A1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
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
  const _PatientSwitcher();

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
                title: p.name,
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
              hint: l.comingSoon,
              icon: Icons.person_add_alt_1_rounded,
              selected: false,
              trailing: const SizedBox.shrink(),
              // TODO(phase 3): open the patient setup flow.
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
