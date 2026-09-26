import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import 'medicine_editor_page.dart';
import 'medicine_text.dart';
import 'prescription_import_page.dart';
import 'verify_page.dart';

/// The selected patient's medicines with when to take each, and which of
/// today's doses are done. This is what "Scan & verify" checks against.
class MedicineListPage extends StatelessWidget {
  const MedicineListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final list = repo.medicineList;

    return GurtuPage(
      title: l.medicineList,
      subtitle: l.medicineListSubtitle,
      bottom: list.isEmpty
          ? null
          : GurtuButton(
              label: l.scanVerify,
              style: GurtuButtonStyle.amber,
              icon: Icons.document_scanner_rounded,
              onPressed: () => pushPage(context, const VerifyPage()),
            ),
      children: [
        GurtuButton(
          label: l.addMedicine,
          style: list.isEmpty
              ? GurtuButtonStyle.primary
              : GurtuButtonStyle.ghost,
          icon: Icons.add_rounded,
          onPressed: () => pushPage(context, const MedicineEditorPage()),
        ),
        const SizedBox(height: 12),
        GurtuButton(
          label: l.addFromPrescription,
          style: GurtuButtonStyle.ghost,
          icon: Icons.receipt_long_rounded,
          onPressed: () => pushPage(context, const PrescriptionImportPage()),
        ),
        const SizedBox(height: 24),
        if (list.isEmpty)
          GurtuCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IconBadge(icon: Icons.medication_rounded, size: 44),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.noMedicinesTitle, style: t.titleMedium),
                      const SizedBox(height: 2),
                      Text(l.noMedicinesBody, style: t.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          )
        else ...[
          SectionHeader(title: l.medicinesCount(list.length)),
          for (final m in list) ...[
            _MedicineCard(medicine: m),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final m = medicine;

    return GurtuCard(
      onTap: () => pushPage(context, MedicineEditorPage(medicineId: m.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBadge(
                icon: Icons.medication_rounded,
                color: GurtuColors.info,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.label, style: t.titleMedium),
                    if (m.alsoCalled.isNotEmpty)
                      Text(m.alsoCalled, style: t.bodySmall),
                    Text(
                      l.foodLabel(m.food),
                      style: t.bodySmall?.copyWith(
                        color: GurtuColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (m.times.isEmpty)
            Text(
              l.timesNotSet,
              style: t.bodyMedium?.copyWith(
                color: GurtuColors.amber,
                fontWeight: FontWeight.w700,
              ),
            )
          else ...[
            Text(l.takenToday, style: t.bodySmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final slot in m.times)
                  _DoseChip(
                    label: l.doseLabel(slot),
                    icon: slot.icon,
                    taken: repo.doseTaken(m, slot) != null,
                    onTap: () => repo.doseTaken(m, slot) == null
                        ? repo.markTaken(m, slot)
                        : repo.undoTaken(m, slot),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DoseChip extends StatelessWidget {
  const _DoseChip({
    required this.label,
    required this.icon,
    required this.taken,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool taken;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: taken,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: taken
                ? GurtuColors.leaf.withValues(alpha: 0.12)
                : GurtuColors.surfaceHigh,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: taken ? GurtuColors.leaf : GurtuColors.outline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                taken ? Icons.check_circle_rounded : icon,
                size: 18,
                color: taken ? GurtuColors.leaf : GurtuColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: taken ? GurtuColors.leaf : GurtuColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
