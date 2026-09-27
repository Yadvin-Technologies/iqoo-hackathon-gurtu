import 'package:flutter/material.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';

/// One medicine from a visit: "Medicine 2" with edit and delete buttons
/// above whatever was noted for it (text, photos, voice notes).
class VisitMedicineCard extends StatelessWidget {
  const VisitMedicineCard({
    super.key,
    required this.number,
    required this.child,
    this.onEdit,
    this.onDelete,
    this.flat = false,
  });

  final int number;
  final Widget child;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// Without its own card, for a list inside another card.
  final bool flat;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const IconBadge(icon: Icons.medication_rounded, size: 36),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l.medicineNumber(number),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (onEdit != null)
              IconButton(
                onPressed: onEdit,
                tooltip: l.editMedicine,
                color: GurtuColors.textSecondary,
                icon: const Icon(Icons.edit_outlined),
              ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                tooltip: l.deleteMedicine,
                color: GurtuColors.textSecondary,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(padding: const EdgeInsets.only(right: 12), child: child),
      ],
    );
    if (flat) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: content,
      );
    }
    return GurtuCard(
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 16),
      child: content,
    );
  }
}

/// Pill "Add medicine" / "Add another medicine" button under the list.
class AddMedicineButton extends StatelessWidget {
  const AddMedicineButton({
    super.key,
    required this.another,
    required this.onPressed,
  });

  final bool another;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: Text(another ? l.addAnotherMedicine : l.addMedicine),
      style: OutlinedButton.styleFrom(
        foregroundColor: GurtuColors.primary,
        backgroundColor: GurtuColors.surface,
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        side: BorderSide(
          color: GurtuColors.primary.withValues(alpha: 0.4),
          width: 1.4,
        ),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: GurtuFonts.sans,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}
