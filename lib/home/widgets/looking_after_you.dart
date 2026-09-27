import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../cloud/cloud_sync.dart';
import '../../data/care_models.dart';
import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../care_text.dart';

/// For the person being cared for, on their own Home: who looks after them,
/// and one big "Ask family for help" that notifies everyone in their circle.
/// With no one yet, it invites them to share the family code.
class LookingAfterYou extends StatelessWidget {
  const LookingAfterYou({super.key, required this.onOpenCircle});

  final VoidCallback onOpenCircle;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final cloud = CloudScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final patient = repo.selectedPatient!;
    final circle = cloud.circleFor(patient.id);
    // From the server when connected (it knows who joined), else local.
    final helpers = circle != null
        ? [
            for (final m in circle.members)
              if (!m.isYou && m.role != CareRole.patient.name)
                (id: m.id, name: m.name, role: m.role),
          ]
        : [
            for (final m in repo.circle)
              if (!m.isYou && m.role != CareRole.patient)
                (id: m.id, name: m.name, role: m.role.name),
          ];

    return GurtuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.favorite_rounded,
                color: GurtuColors.danger,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.lookingAfterYou, style: t.titleLarge),
                    Text(
                      l.lookingAfterCount(helpers.length),
                      style: t.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (helpers.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 10,
              children: [
                for (final h in helpers)
                  SizedBox(
                    width: 72,
                    child: Column(
                      children: [
                        InitialsAvatar(
                          label: initialOf(h.name),
                          color: avatarColor(h.id),
                          size: 48,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          h.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: t.titleSmall,
                        ),
                        Text(
                          l.roleLabel(
                            CareRole.values.asNameMap()[h.role] ??
                                CareRole.family,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: t.bodySmall,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          if (helpers.isNotEmpty && circle != null)
            GurtuButton(
              label: l.askForHelp,
              icon: Icons.volunteer_activism_rounded,
              style: GurtuButtonStyle.amber,
              onPressed: () => _askForHelp(context, cloud, patient.id),
            )
          else ...[
            Text(l.inviteFamilyHint, style: t.bodyMedium),
            const SizedBox(height: 12),
            GurtuButton(
              label: l.inviteFamily,
              icon: Icons.group_add_rounded,
              style: GurtuButtonStyle.ghost,
              onPressed: onOpenCircle,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _askForHelp(
    BuildContext context,
    CloudSync cloud,
    String patientId,
  ) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GurtuColors.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(l.askForHelpTitle),
        content: Text(l.askForHelpBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.send),
          ),
        ],
      ),
    );
    if (ok != true) return;
    HapticFeedback.heavyImpact();
    final sent = await cloud.askForHelp(patientId);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          persist: false,
          content: Text(sent == null ? l.connectionFailed : l.helpSent(sent)),
        ),
      );
  }
}
