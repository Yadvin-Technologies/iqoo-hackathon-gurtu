import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/care_repository.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import '../widgets/voice_input.dart';
import 'visit_text.dart';

/// Used during the appointment: keep listening while the doctor talks, tick
/// off the prepared questions, then note medicines, tests and the next date.
class VisitRecorderPage extends StatefulWidget {
  const VisitRecorderPage({super.key, this.prepId});

  /// Questions prepared for this visit, shown as a checklist.
  final String? prepId;

  @override
  State<VisitRecorderPage> createState() => _VisitRecorderPageState();
}

class _VisitRecorderPageState extends State<VisitRecorderPage> {
  final _doctor = TextEditingController();
  final _reason = TextEditingController();
  final _notes = TextEditingController();
  final _medicines = TextEditingController();
  final _tests = TextEditingController();
  late final _listening = DictationController(_notes, continuous: true);
  DateTime _date = DateTime.now();
  DateTime? _next;
  bool _leaving = false;

  List<TextEditingController> get _fields => [
    _doctor,
    _reason,
    _notes,
    _medicines,
    _tests,
  ];

  bool get _hasContent =>
      _fields.any((c) => c.text.trim().isNotEmpty) || _next != null;

  @override
  void initState() {
    super.initState();
    for (final c in _fields) {
      c.addListener(_refresh);
    }
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _listening.dispose();
    for (final c in _fields) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 20),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickNext() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _next ?? today.add(const Duration(days: 30)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _next = picked);
  }

  Future<void> _save() async {
    await _listening.stop();
    if (!mounted) return;
    final repo = CareScope.of(context);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    repo.addVisit(
      date: _date,
      doctorName: _doctor.text,
      reason: _reason.text,
      notes: _notes.text,
      medicines: _medicines.text,
      tests: _tests.text,
      nextVisit: _next,
      prep: repo.prepById(widget.prepId),
    );
    HapticFeedback.mediumImpact();
    setState(() => _leaving = true);
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text(l.visitSaved)));
  }

  Future<void> _confirmLeave() async {
    final l = context.l10n;
    final ok = await confirmAction(
      context,
      title: l.leaveVisitTitle,
      body: l.leaveVisitBody,
      confirm: l.discard,
      cancel: l.keepEditing,
    );
    if (!ok || !mounted) return;
    await _listening.stop();
    setState(() => _leaving = true);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final prep = repo.prepById(widget.prepId);

    return PopScope(
      // Never lose what the doctor said to an accidental back swipe.
      canPop: _leaving || !_hasContent,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: GurtuPage(
        title: l.recordVisit,
        bottom: GurtuButton(
          label: l.saveVisit,
          icon: Icons.check_rounded,
          onPressed: _hasContent ? _save : null,
        ),
        children: [
          InfoBanner(
            text: l.recordingConsent,
            icon: Icons.handshake_rounded,
            color: GurtuColors.info,
          ),
          const SizedBox(height: 20),
          FieldLabel(l.doctorName, icon: Icons.medical_services_rounded),
          TextField(
            controller: _doctor,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(hintText: l.doctorNameHint),
          ),
          const SizedBox(height: 16),
          FieldLabel(l.visitReason, optional: true),
          TextField(
            controller: _reason,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(hintText: l.visitReasonHint),
          ),
          const SizedBox(height: 16),
          FieldLabel(l.visitDate),
          _DateButton(
            icon: Icons.calendar_today_rounded,
            label: dateLabel(context, _date),
            onTap: _pickDate,
          ),
          const SizedBox(height: 24),

          FieldLabel(l.doctorSaid, icon: Icons.record_voice_over_rounded),
          VoiceButton(
            controller: _listening,
            label: l.listenToDoctor,
            large: true,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            minLines: 5,
            maxLines: 14,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(fontSize: 17, height: 1.4),
            decoration: InputDecoration(hintText: l.doctorSaidHint),
          ),

          if (prep != null && prep.questions.isNotEmpty) ...[
            const SizedBox(height: 24),
            FieldLabel(l.yourQuestions, icon: Icons.help_outline_rounded),
            Text(l.tickWhenAsked, style: t.bodyMedium),
            const SizedBox(height: 8),
            GurtuCard(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Column(
                children: [
                  for (final q in prep.questions)
                    CheckboxListTile(
                      value: q.asked,
                      onChanged: (v) {
                        HapticFeedback.selectionClick();
                        q.asked = v ?? false;
                        repo.updatePrep(prep);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: GurtuColors.leaf,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: Text(
                        l.questionText(q),
                        style: t.bodyLarge?.copyWith(
                          color: q.asked
                              ? GurtuColors.textMuted
                              : GurtuColors.textPrimary,
                          decoration: q.asked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          FieldLabel(
            l.medicinesSection,
            optional: true,
            icon: Icons.medication_rounded,
          ),
          DictationField(controller: _medicines, hint: l.medicinesHint),
          const SizedBox(height: 20),
          FieldLabel(
            l.testsSection,
            optional: true,
            icon: Icons.biotech_rounded,
          ),
          DictationField(controller: _tests, hint: l.testsHint),
          const SizedBox(height: 20),
          FieldLabel(l.nextVisit, optional: true, icon: Icons.event_rounded),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _DateButton(
                icon: _next == null
                    ? Icons.add_rounded
                    : Icons.event_available_rounded,
                label: _next == null
                    ? l.addNextVisit
                    : dateLabel(context, _next!),
                onTap: _pickNext,
              ),
              if (_next != null)
                TextButton(
                  onPressed: () => setState(() => _next = null),
                  style: TextButton.styleFrom(
                    foregroundColor: GurtuColors.textSecondary,
                    minimumSize: const Size(48, 48),
                  ),
                  child: Text(l.remove),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: GurtuColors.primary,
          backgroundColor: GurtuColors.surface,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          side: const BorderSide(color: GurtuColors.outline, width: 1.4),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: GurtuFonts.sans,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
