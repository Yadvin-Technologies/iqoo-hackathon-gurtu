import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/care_models.dart';
import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../people/add_person.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';

/// For caregivers: everyone they look after, side by side, with a dot for
/// who needs attention today. Tap to switch Home to that person; "Add" sets
/// up or joins one more. Yourself (if you're on this phone too) comes
/// first, as "You".
class PeopleStrip extends StatelessWidget {
  const PeopleStrip({super.key});

  /// Shown once there is more than one person, or you look after someone.
  static bool shownFor(CareRepository repo) =>
      repo.patients.length > 1 ||
      (repo.selectedPatient != null && !repo.selectedPatient!.isSelf);

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final selected = repo.selectedPatient?.id;
    final people = [...repo.patients]
      ..sort((a, b) => (b.isSelf ? 1 : 0).compareTo(a.isSelf ? 1 : 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (people.any((p) => !p.isSelf))
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 8),
            child: Text(
              l.peopleYouCareFor,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: GurtuColors.textSecondary),
            ),
          ),
        SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              for (final p in people) ...[
                _Person(
                  patient: p,
                  label: p.isSelf ? l.rowYou : p.name,
                  selected: p.id == selected,
                  attention: repo.needsAttentionFor(p.id),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    repo.selectPatient(p.id);
                  },
                ),
                const SizedBox(width: 10),
              ],
              _AddPerson(onTap: () => showAddPersonSheet(context)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Person extends StatelessWidget {
  const _Person({
    required this.patient,
    required this.label,
    required this.selected,
    required this.attention,
    required this.onTap,
  });

  final PatientProfile patient;
  final String label;
  final bool selected;
  final bool attention;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, ${attention ? l.statusNeedsAttention : l.statusOnTrack}',
      excludeSemantics: true,
      child: Material(
        color: selected ? GurtuColors.primarySoft : GurtuColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GurtuSpace.radius),
          side: BorderSide(
            color: selected ? GurtuColors.primary : GurtuColors.outline,
            width: selected ? 2 : 1.4,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(GurtuSpace.radius),
          onTap: onTap,
          child: SizedBox(
            width: 84,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InitialsAvatar(
                      label: initialOf(patient.name),
                      color: avatarColor(patient.id),
                      size: 44,
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: attention
                              ? GurtuColors.amberBright
                              : GurtuColors.leaf,
                          border: Border.all(
                            color: GurtuColors.surface,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: selected
                          ? GurtuColors.primaryDeep
                          : GurtuColors.textPrimary,
                    ),
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

class _AddPerson extends StatelessWidget {
  const _AddPerson({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      button: true,
      label: l.addPersonTitle,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        onTap: onTap,
        child: Container(
          width: 84,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(GurtuSpace.radius),
            border: Border.all(
              color: GurtuColors.primary.withValues(alpha: 0.35),
              width: 1.4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: GurtuColors.primarySoft,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: GurtuColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l.add,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: GurtuColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
