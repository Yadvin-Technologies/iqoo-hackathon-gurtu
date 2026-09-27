import 'dart:math' as math;

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
///
/// A calm white card: the ring around the photo fills as today's doses are
/// taken, so the day's progress is seen at a glance and stays in step with
/// the medicine list.
class PatientHeader extends StatelessWidget {
  const PatientHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final patient = repo.selectedPatient!;
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
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
    final progress = doses.total == 0 ? null : doses.taken / doses.total;

    return Container(
      decoration: BoxDecoration(
        color: GurtuColors.surface,
        borderRadius: BorderRadius.circular(GurtuSpace.radiusLg),
        border: Border.all(color: GurtuColors.outline, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: GurtuColors.primaryDeep.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(GurtuSpace.radiusLg),
                ),
                onTap: () => showGurtuSheet(
                  context,
                  (_) => _PatientSwitcher(host: context),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: Row(
                    children: [
                      _ProgressAvatar(patient: patient, progress: progress),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.isSelf ? l.yourCare : l.caringFor,
                              style: t.bodySmall?.copyWith(
                                color: GurtuColors.textMuted,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
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
                                      color: GurtuColors.textPrimary,
                                      fontSize: 22,
                                      height: 1.25,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.expand_more_rounded,
                                  color: GurtuColors.textMuted,
                                  size: 22,
                                ),
                              ],
                            ),
                            if (about.isNotEmpty)
                              Text(
                                about,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: t.bodyMedium?.copyWith(
                                  color: GurtuColors.textSecondary,
                                ),
                              ),
                            const SizedBox(height: 8),
                            _StatusChip(attention: attention),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: GurtuColors.outline),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _Stat(
                    icon: Icons.medication_rounded,
                    value: '$medicines',
                    label: l.medicinesSection,
                    onTap: () => pushPage(context, const MedicineListPage()),
                  ),
                ),
                const _StatDivider(),
                Expanded(
                  child: _Stat(
                    icon: Icons.task_alt_rounded,
                    value: doses.total == 0
                        ? '—'
                        : '${doses.taken}/${doses.total}',
                    label: l.takenToday,
                    highlight: doses.total > 0 && doses.taken == doses.total,
                    onTap: () => pushPage(context, const MedicineListPage()),
                  ),
                ),
                const _StatDivider(),
                Expanded(
                  child: _Stat(
                    icon: Icons.event_rounded,
                    value: next == null
                        ? '—'
                        : MaterialLocalizations.of(context)
                              .formatShortMonthDay(next),
                    label: l.nextVisit,
                    onTap: () => pushPage(context, const VisitsPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The photo inside a ring that fills with today's doses (amber to orange,
/// the iQOO accent). Without doses today it is a quiet, even ring.
class _ProgressAvatar extends StatelessWidget {
  const _ProgressAvatar({required this.patient, required this.progress});

  final PatientProfile patient;

  /// 0–1: doses taken today; null when none are due.
  final double? progress;

  static const _size = 68.0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: progress ?? 0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => CustomPaint(
        painter: _RingPainter(value: value, active: progress != null),
        child: child,
      ),
      child: SizedBox.square(
        dimension: _size,
        child: Center(
          child: InitialsAvatar(
            label: initialOf(patient.name),
            color: avatarColor(patient.id),
            size: _size - 14,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.value, required this.active});

  final double value;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 4.0;
    final rect = Offset.zero & size;
    final circle = rect.deflate(stroke / 2);
    canvas.drawArc(
      circle,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = active ? GurtuColors.outline : GurtuColors.primarySoft,
    );
    if (!active || value <= 0) return;
    canvas.drawArc(
      circle,
      -math.pi / 2,
      2 * math.pi * value.clamp(0.0, 1.0),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
          colors: [GurtuColors.amberBright, GurtuColors.orange],
          transform: GradientRotation(-math.pi / 2),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.active != active;
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 14),
    child: VerticalDivider(width: 1, thickness: 1, color: GurtuColors.outline),
  );
}

/// One number from the records on the patient card.
class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback onTap;

  /// All done: shown in green.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '$label: $value',
      excludeSemantics: true,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: highlight ? GurtuColors.leaf : GurtuColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: highlight
                            ? GurtuColors.leaf
                            : GurtuColors.textPrimary,
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: t.bodySmall?.copyWith(
                  color: GurtuColors.textMuted,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A small dot and words, never colour alone.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.attention});

  final bool attention;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final color = attention ? GurtuColors.amber : GurtuColors.leaf;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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
            size: 15,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              attention ? l.statusNeedsAttention : l.statusOnTrack,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
