import 'package:flutter/material.dart';

import '../ai/medicine_check.dart';
import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import '../widgets/voice_input.dart';
import 'medicine_scanner.dart';
import 'medicine_text.dart';

/// Add or edit one medicine: its name, the other name printed on the strip,
/// strength, and when to take it.
class MedicineEditorPage extends StatefulWidget {
  const MedicineEditorPage({super.key, this.medicineId});

  /// Null to add a new medicine.
  final String? medicineId;

  @override
  State<MedicineEditorPage> createState() => _MedicineEditorPageState();
}

class _MedicineEditorPageState extends State<MedicineEditorPage> {
  final _name = TextEditingController();
  final _alsoCalled = TextEditingController();
  final _strength = TextEditingController();
  final _times = <DoseTime>{};
  var _food = FoodTiming.afterFood;
  Medicine? _editing;
  var _loaded = false;
  var _scanning = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final m = CareScope.of(context).medicines
        .where((m) => m.id == widget.medicineId)
        .firstOrNull;
    if (m == null) return;
    _editing = m;
    _name.text = m.name;
    _alsoCalled.text = m.alsoCalled;
    _strength.text = m.strength;
    _times.addAll(m.times);
    _food = m.food;
  }

  @override
  void dispose() {
    _name.dispose();
    _alsoCalled.dispose();
    _strength.dispose();
    super.dispose();
  }

  Future<void> _scanStrip() async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    setState(() => _scanning = true);
    try {
      final text = await MedicineScanner.instance.scan();
      final draft = text == null
          ? null
          : const PrescriptionReader().readStrip(text);
      if (text != null && draft == null) {
        messenger.showSnackBar(SnackBar(content: Text(l.scanFailed)));
      }
      if (draft != null) {
        setState(() {
          _name.text = draft.name;
          if (draft.strength.isNotEmpty) _strength.text = draft.strength;
        });
      }
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l.scanFailed)));
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  void _save() {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final times = [
      for (final t in DoseTime.values)
        if (_times.contains(t)) t,
    ];
    final editing = _editing;
    if (editing == null) {
      repo.addMedicine(
        name: _name.text,
        alsoCalled: _alsoCalled.text,
        strength: _strength.text,
        times: times,
        food: _food,
      );
    } else {
      repo.updateMedicine(
        editing.copyWith(
          name: _name.text.trim(),
          alsoCalled: _alsoCalled.text.trim(),
          strength: _strength.text.trim(),
          times: times,
          food: _food,
        ),
      );
    }
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text(l.medicineSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = _editing;
    return GurtuPage(
      title: editing == null ? l.addMedicine : l.editMedicine,
      bottom: GurtuButton(
        label: l.saveMedicine,
        icon: Icons.check_rounded,
        onPressed: _name.text.trim().isEmpty ? null : _save,
      ),
      children: [
        if (MedicineScanner.instance.available) ...[
          GurtuButton(
            label: _scanning ? l.readingStrip : l.scanToFill,
            style: GurtuButtonStyle.ghost,
            icon: Icons.document_scanner_rounded,
            onPressed: _scanning ? null : _scanStrip,
          ),
          const SizedBox(height: 20),
        ],
        FieldLabel(l.medicineName, icon: Icons.medication_rounded),
        DictationField(
          controller: _name,
          hint: l.medicineNameHint,
          minLines: 1,
          maxLines: 2,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        FieldLabel(l.alsoCalled, optional: true),
        TextField(
          controller: _alsoCalled,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(hintText: l.alsoCalledHint),
        ),
        const SizedBox(height: 16),
        FieldLabel(l.strength, optional: true),
        TextField(
          controller: _strength,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(hintText: l.strengthHint),
        ),
        const SizedBox(height: 24),
        FieldLabel(l.whenToTake, icon: Icons.schedule_rounded),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in DoseTime.values)
              GurtuChip(
                label: l.doseLabel(t),
                icon: t.icon,
                selected: _times.contains(t),
                onTap: () => setState(
                  () => _times.contains(t) ? _times.remove(t) : _times.add(t),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final f in FoodTiming.values)
              GurtuChip(
                label: l.foodLabel(f),
                icon: Icons.restaurant_rounded,
                selected: _food == f,
                onTap: () => setState(() => _food = f),
              ),
          ],
        ),
        if (editing != null) ...[
          const SizedBox(height: 32),
          GurtuButton(
            label: l.deleteMedicine,
            style: GurtuButtonStyle.ghost,
            icon: Icons.delete_outline_rounded,
            onPressed: () async {
              final repo = CareScope.of(context);
              final ok = await confirmAction(
                context,
                title: l.deleteMedicine,
                body: l.deleteMedicineConfirm,
                confirm: l.delete,
              );
              if (!ok || !context.mounted) return;
              Navigator.pop(context);
              repo.deleteMedicine(editing);
            },
          ),
        ],
        const SizedBox(height: 8),
        Text(
          l.verifyDisclaimer,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: GurtuColors.textMuted),
        ),
      ],
    );
  }
}
