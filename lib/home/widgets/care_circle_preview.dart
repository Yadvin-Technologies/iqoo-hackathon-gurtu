import 'package:flutter/material.dart';

import '../../data/care_models.dart';
import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../care_text.dart';

/// Who is helping — avatar, name and role only. Full profiles live in the
/// Circle tab.
class CareCirclePreview extends StatelessWidget {
  const CareCirclePreview({super.key, required this.onManage});

  final VoidCallback onManage;

  static const _maxOnHome = 4;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final circle = repo.circle.take(_maxOnHome).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l.yourCareCircle,
          action: l.manageCircle,
          onAction: onManage,
        ),
        GurtuCard(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final m in circle) Expanded(child: _Member(member: m)),
                  // Keep columns the same width however many people there are.
                  for (var i = circle.length; i < _maxOnHome; i++)
                    const Expanded(child: SizedBox.shrink()),
                ],
              ),
              if (!repo.hasCareCircle) ...[
                const Divider(height: 28, color: GurtuColors.outline),
                // Stacked, not side by side: a long translated button label
                // would otherwise squeeze the text.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.emptyCircle, style: t.bodyMedium),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
                        onPressed: onManage,
                        icon: const Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 18,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: GurtuColors.primarySoft,
                          foregroundColor: GurtuColors.primaryDeep,
                          minimumSize: const Size(48, 48),
                          textStyle: const TextStyle(
                            fontFamily: GurtuFonts.sans,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        label: Text(l.addFamilyMember),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Member extends StatelessWidget {
  const _Member({required this.member});

  final CareMember member;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final name = member.isYou && member.role != CareRole.patient
        ? l.rowYou
        : member.name;
    return Semantics(
      label: '$name, ${l.roleLabel(member.role)}',
      excludeSemantics: true,
      child: Column(
        children: [
          InitialsAvatar(
            label: initialOf(member.name),
            color: avatarColor(member.id),
            size: 52,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: t.titleMedium?.copyWith(fontSize: 15),
          ),
          Text(
            l.roleLabel(member.role),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: t.bodySmall,
          ),
        ],
      ),
    );
  }
}
