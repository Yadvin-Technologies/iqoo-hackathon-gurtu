import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ai/medicine_check.dart';
import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../home/care_text.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import '../widgets/voice_input.dart';
import 'medicine_editor_page.dart';
import 'medicine_list_page.dart';
import 'medicine_scanner.dart';
import 'medicine_text.dart';
import 'prescription_import_page.dart';

/// "Scan & verify": is this strip the right medicine, the right strength,
/// and due right now? Checked only against the saved medicine list.
class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key, this.clock = DateTime.now});

  /// "Due now" depends on the time of day; tests pass a fixed clock.
  final DateTime Function() clock;

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _typed = TextEditingController();
  final _scroll = ScrollController();

  /// What was read or typed; the verdict is recomputed from it on every
  /// build, so marking a dose as taken updates the answer at once.
  String? _read;
  bool _reading = false;

  @override
  void dispose() {
    _typed.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    setState(() => _reading = true);
    try {
      final text = await MedicineScanner.instance.scan();
      if (text != null) _show(text);
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l.scanFailed)));
    } finally {
      if (mounted) setState(() => _reading = false);
    }
  }

  void _checkTyped() {
    FocusScope.of(context).unfocus();
    _show(_typed.text);
  }

  void _show(String text) {
    HapticFeedback.mediumImpact();
    setState(() => _read = text.trim());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _reset() => setState(() {
    _read = null;
    _typed.clear();
  });

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final patient = repo.selectedPatient;
    final name = patient?.name ?? '';
    final scanner = MedicineScanner.instance;

    if (repo.medicineList.isEmpty) {
      return GurtuPage(
        title: l.scanVerify,
        children: [
          InfoBanner(
            text: l.addMedicinesFirst(name),
            icon: Icons.medication_rounded,
            color: GurtuColors.primary,
          ),
          const SizedBox(height: 16),
          GurtuButton(
            label: l.addMedicine,
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
        ],
      );
    }

    final check = _read == null || patient == null
        ? null
        : const MedicineVerifier().check(
            text: _read!,
            patientId: patient.id,
            medicines: repo.medicines,
            doses: repo.doses,
            now: widget.clock(),
          );

    return GurtuPage(
      title: l.scanVerify,
      subtitle: l.scanVerifySubtitle(name),
      controller: _scroll,
      children: [
        if (check != null) ...[
          _Result(
            check: check,
            read: _read!,
            patientName: name,
            clock: widget.clock,
          ),
          const SizedBox(height: 12),
          GurtuButton(
            label: l.checkAnother,
            style: GurtuButtonStyle.ghost,
            icon: Icons.refresh_rounded,
            onPressed: _reset,
          ),
          const SizedBox(height: 28),
        ],
        if (check == null) ...[
          if (scanner.available)
            GurtuButton(
              label: _reading ? l.readingStrip : l.scanWithCamera,
              style: GurtuButtonStyle.amber,
              icon: Icons.document_scanner_rounded,
              onPressed: _reading ? null : _scan,
            )
          else
            InfoBanner(
              text: l.cameraUnavailable,
              icon: Icons.photo_camera_rounded,
              color: GurtuColors.info,
            ),
          const SizedBox(height: 24),
          FieldLabel(l.orTypeName, icon: Icons.keyboard_rounded),
          DictationField(
            controller: _typed,
            hint: l.typeNameHint,
            minLines: 1,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          GurtuButton(
            label: l.checkMedicine,
            icon: Icons.fact_check_rounded,
            onPressed: _typed.text.trim().isEmpty ? null : _checkTyped,
          ),
          const SizedBox(height: 28),
        ],
        GurtuCard(
          onTap: () => pushPage(context, const MedicineListPage()),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const IconBadge(icon: Icons.medication_rounded, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.medicineList,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      l.medicinesCount(repo.medicineList.length),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: GurtuColors.textMuted,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InfoBanner(text: l.verifyDisclaimer, icon: Icons.verified_user_rounded),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({
    required this.check,
    required this.read,
    required this.patientName,
    required this.clock,
  });

  final MedicineCheck check;
  final String read;
  final String patientName;
  final DateTime Function() clock;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final v = check.verdict;
    final m = check.medicine;
    final own = m != null && v != Verdict.otherPatient;

    final (color, icon) = switch (v) {
      Verdict.takeNow => (GurtuColors.leaf, Icons.check_circle_rounded),
      Verdict.notNow ||
      Verdict.alreadyTaken ||
      Verdict.noTimes => (GurtuColors.amber, Icons.schedule_rounded),
      Verdict.wrongStrength ||
      Verdict.notOnList ||
      Verdict.otherPatient => (GurtuColors.danger, Icons.block_rounded),
      Verdict.unreadable => (GurtuColors.textSecondary, Icons.help_rounded),
    };
    final headline = switch (v) {
      Verdict.takeNow => l.verdictTakeNow,
      Verdict.notNow => l.verdictNotNow,
      Verdict.alreadyTaken => l.verdictAlreadyTaken,
      Verdict.noTimes => l.verdictNoTimes,
      Verdict.wrongStrength => l.verdictWrongStrength,
      Verdict.notOnList => l.verdictNotOnList(patientName),
      Verdict.otherPatient => l.verdictOtherPatient(
        repo.patientById(m!.patientId)?.name ?? '',
        patientName,
      ),
      Verdict.unreadable => l.verdictUnreadable,
    };

    return Semantics(
      liveRegion: true,
      child: Container(
        decoration: BoxDecoration(
          color: GurtuColors.surface,
          borderRadius: BorderRadius.circular(GurtuSpace.radius),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(GurtuSpace.radius - 2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headline,
                          style: t.titleLarge?.copyWith(
                            color: color,
                            fontSize: 20,
                          ),
                        ),
                        if (v.isStop) ...[
                          const SizedBox(height: 4),
                          Text(
                            l.verdictCheckFirst,
                            style: t.bodyMedium?.copyWith(
                              color: GurtuColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (m != null) ...[
                    Text(m.label, style: t.titleLarge),
                    if (m.alsoCalled.isNotEmpty)
                      Text(m.alsoCalled, style: t.bodyMedium),
                    const SizedBox(height: 10),
                  ],
                  if (own) _Row(Icons.check_rounded, l.rowOnList, ok: true),
                  if (own && v == Verdict.wrongStrength)
                    _Row(
                      Icons.close_rounded,
                      l.rowStrengthDiffers(check.foundStrength!, m.strength),
                      ok: false,
                    )
                  else if (own && check.strengthConfirmed)
                    _Row(
                      Icons.check_rounded,
                      l.rowStrengthMatches(m.strength),
                      ok: true,
                    )
                  else if (own && m.strength.isNotEmpty)
                    // Couldn't read the strength: ask, never assume.
                    _Row(
                      Icons.visibility_rounded,
                      l.rowStrengthCheck(m.strength),
                    ),
                  if (v == Verdict.takeNow)
                    _Row(
                      Icons.alarm_on_rounded,
                      l.rowDueNow(l.doseLabel(check.slot!)),
                      ok: true,
                    ),
                  if (v == Verdict.alreadyTaken)
                    _Row(
                      Icons.done_all_rounded,
                      l.rowTakenAt(
                        l.doseLabel(check.slot!),
                        timeLabel(context, check.taken!.at),
                      ),
                    ),
                  if ((v == Verdict.notNow || v == Verdict.alreadyTaken) &&
                      check.next != null &&
                      check.next != check.slot)
                    _Row(
                      Icons.schedule_rounded,
                      l.rowNextDose(l.doseLabel(check.next!)),
                    ),
                  if (v == Verdict.noTimes)
                    _Row(Icons.edit_calendar_rounded, l.rowSetTimes),
                  if (own && m.food != FoodTiming.any && !v.isStop)
                    _Row(Icons.restaurant_rounded, l.foodLabel(m.food)),
                  const SizedBox(height: 8),
                  Text(l.readFromStrip(_short(read)), style: t.bodySmall),
                  if (v == Verdict.takeNow) ...[
                    const SizedBox(height: 14),
                    GurtuButton(
                      label: l.markTaken,
                      icon: Icons.check_rounded,
                      onPressed: () {
                        final slot = check.slot!;
                        repo.markTaken(m!, slot, clock());
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(l.markedTaken),
                              action: SnackBarAction(
                                label: l.undo,
                                onPressed: () =>
                                    repo.undoTaken(m, slot, clock()),
                              ),
                            ),
                          );
                      },
                    ),
                  ],
                  if (v == Verdict.noTimes) ...[
                    const SizedBox(height: 14),
                    GurtuButton(
                      label: l.editMedicine,
                      style: GurtuButtonStyle.ghost,
                      icon: Icons.edit_rounded,
                      onPressed: () => pushPage(
                        context,
                        MedicineEditorPage(medicineId: m!.id),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _short(String s) {
    final one = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return one.length <= 80 ? one : '${one.substring(0, 80)}…';
  }
}

class _Row extends StatelessWidget {
  const _Row(this.icon, this.text, {this.ok});

  final IconData icon;
  final String text;

  /// Green when true, red when false, neutral when null.
  final bool? ok;

  @override
  Widget build(BuildContext context) {
    final color = switch (ok) {
      true => GurtuColors.leaf,
      false => GurtuColors.danger,
      null => GurtuColors.textSecondary,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ok == false
                    ? GurtuColors.danger
                    : GurtuColors.textPrimary,
                fontWeight: ok == false ? FontWeight.w700 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
