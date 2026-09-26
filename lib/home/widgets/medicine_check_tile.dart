import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../medicines/medicine_list_page.dart';
import '../../medicines/verify_page.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_page.dart';

/// "Is this the right tablet, right now?" — one tap from Home, for the
/// moment of doubt with a strip in hand. The medicine list sits underneath.
class MedicineCheckTile extends StatelessWidget {
  const MedicineCheckTile({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final count = repo.medicineList.length;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: GurtuColors.surface,
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        border: Border.all(
          color: GurtuColors.leaf.withValues(alpha: 0.45),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: GurtuColors.primaryDeep.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            Semantics(
              button: true,
              label: '${l.scanVerify}. ${l.scanVerifyHint}',
              excludeSemantics: true,
              child: InkWell(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(GurtuSpace.radius),
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  pushPage(context, const VerifyPage());
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: GurtuColors.leaf.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.document_scanner_rounded,
                          color: GurtuColors.leaf,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.scanVerify, style: t.titleMedium),
                            const SizedBox(height: 2),
                            Text(l.scanVerifyHint, style: t.bodySmall),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: GurtuColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: GurtuColors.outline),
            InkWell(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(GurtuSpace.radius),
              ),
              onTap: () => pushPage(context, const MedicineListPage()),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medication_rounded,
                        size: 20,
                        color: GurtuColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          count == 0
                              ? l.medicineList
                              : '${l.medicineList} · ${l.medicinesCount(count)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: GurtuColors.primary,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: GurtuColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
