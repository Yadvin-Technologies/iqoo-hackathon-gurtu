import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ai/medicine_check.dart';
import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import 'medicine_scanner.dart';
import 'medicine_text.dart';

/// Photograph a printed prescription; Gurtu lists the medicines it finds
/// (with "1-0-1" style timings) and the family ticks which to add.
class PrescriptionImportPage extends StatefulWidget {
  const PrescriptionImportPage({super.key, this.initialText});

  /// Text already read off a prescription (a scan saved to memory): its
  /// medicines are listed straight away.
  final String? initialText;

  @override
  State<PrescriptionImportPage> createState() => _PrescriptionImportPageState();
}

class _PrescriptionImportPageState extends State<PrescriptionImportPage> {
  List<MedicineDraft>? _found;
  final _picked = <MedicineDraft>{};
  var _reading = false;

  @override
  void initState() {
    super.initState();
    final text = widget.initialText;
    if (text != null) {
      _found = medicinesIn(text);
      _picked.addAll(_found!);
    }
  }

  Future<void> _scan({required bool fromGallery}) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    setState(() => _reading = true);
    try {
      final text = await MedicineScanner.instance.scan(
        fromGallery: fromGallery,
      );
      if (text == null) return;
      final found = const PrescriptionReader().readPrescription(text);
      HapticFeedback.mediumImpact();
      setState(() {
        _found = found;
        _picked
          ..clear()
          ..addAll(found);
      });
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l.scanFailed)));
    } finally {
      if (mounted) setState(() => _reading = false);
    }
  }

  void _add() {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    var added = 0;
    for (final d in _found!) {
      if (!_picked.contains(d)) continue;
      final m = repo.addMedicine(
        name: d.name,
        strength: d.strength,
        times: d.times,
        food: d.food,
        source: MedicineSource.prescription,
      );
      if (m != null) added++;
    }
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text(l.medicinesAdded(added))));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final found = _found;
    final available = MedicineScanner.instance.available;

    return GurtuPage(
      title: l.prescriptionTitle,
      subtitle: l.prescriptionHint,
      bottom: found == null || found.isEmpty
          ? null
          : GurtuButton(
              label: l.addSelected(_picked.length),
              icon: Icons.check_rounded,
              onPressed: _picked.isEmpty ? null : _add,
            ),
      children: [
        if (!available)
          InfoBanner(
            text: l.cameraUnavailable,
            icon: Icons.photo_camera_rounded,
            color: GurtuColors.info,
          )
        else ...[
          GurtuButton(
            label: _reading ? l.readingStrip : l.takePhoto,
            icon: Icons.photo_camera_rounded,
            style: found == null
                ? GurtuButtonStyle.primary
                : GurtuButtonStyle.ghost,
            onPressed: _reading ? null : () => _scan(fromGallery: false),
          ),
          const SizedBox(height: 12),
          GurtuButton(
            label: l.chooseFromGallery,
            icon: Icons.photo_library_rounded,
            style: GurtuButtonStyle.ghost,
            onPressed: _reading ? null : () => _scan(fromGallery: true),
          ),
        ],
        const SizedBox(height: 16),
        InfoBanner(
          text: l.handwrittenNote,
          icon: Icons.draw_rounded,
          color: GurtuColors.amber,
        ),
        if (found != null) ...[
          const SizedBox(height: 24),
          if (found.isEmpty)
            GurtuCard(child: Text(l.nothingFound, style: t.bodyLarge))
          else ...[
            SectionHeader(title: l.medicinesFound),
            Text(l.tickToAdd, style: t.bodyMedium),
            const SizedBox(height: 10),
            GurtuCard(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  for (final d in found)
                    CheckboxListTile(
                      value: _picked.contains(d),
                      onChanged: (v) => setState(
                        () => v == true ? _picked.add(d) : _picked.remove(d),
                      ),
                      activeColor: GurtuColors.primary,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        d.strength.isEmpty ? d.name : '${d.name} ${d.strength}',
                        style: t.titleMedium,
                      ),
                      subtitle: Text(
                        [
                          if (d.times.isEmpty)
                            l.timesNotSet
                          else
                            d.times.map(l.doseLabel).join(', '),
                          l.foodLabel(d.food),
                        ].join(' · '),
                        style: t.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }
}
