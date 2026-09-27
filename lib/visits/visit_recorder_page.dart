import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/attachment_store.dart';
import '../data/care_repository.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../reminders/auto_reminders.dart';
import '../reminders/reminder_review_page.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import '../widgets/voice_input.dart';
import 'visit_text.dart';
import 'widgets/attachment_tray.dart';
import 'widgets/doctor_listener.dart';
import 'widgets/question_list.dart';
import 'widgets/visit_medicine_card.dart';

/// Used during the appointment: keep listening while the doctor talks, tick
/// off the prepared questions, then note each medicine and the next date.
class VisitRecorderPage extends StatefulWidget {
  const VisitRecorderPage({super.key, this.prepId});

  /// Questions prepared for this visit, shown as a checklist.
  final String? prepId;

  @override
  State<VisitRecorderPage> createState() => _VisitRecorderPageState();
}

/// A medicine being noted: its words, and an id its photos and voice notes
/// point to.
class _MedicineDraft {
  _MedicineDraft() : id = 'vm_${DateTime.now().microsecondsSinceEpoch}_${_n++}';

  static int _n = 0;

  final String id;
  final note = TextEditingController();
}

class _VisitRecorderPageState extends State<VisitRecorderPage> {
  /// The language last used for listening to a doctor.
  static const _languageKey = 'visit_voice_language';

  final _doctor = TextEditingController();
  final _reason = TextEditingController();
  final _notes = TextEditingController();
  late final _listening = DictationController(
    _notes,
    continuous: true,
    live: false,
  );
  late final _recording = DoctorRecorder(onSaved: _addRecording);
  final _medicines = [_MedicineDraft()];
  DateTime _date = DateTime.now();
  DateTime? _next;
  AppLanguage? _language;
  bool _leaving = false;
  bool _wasListening = false;

  /// Photos and voice notes, already kept on the phone; deleted again if the
  /// visit is discarded.
  final _attachments = <VisitAttachment>[];

  List<TextEditingController> get _fields => [_doctor, _reason, _notes];

  bool _hasText(_MedicineDraft m) => m.note.text.trim().isNotEmpty;

  List<VisitAttachment> _attachmentsOf(_MedicineDraft m) => [
    for (final a in _attachments)
      if (a.itemId == m.id) a,
  ];

  bool get _hasContent =>
      _recording.recording ||
      _fields.any((c) => c.text.trim().isNotEmpty) ||
      _medicines.any(_hasText) ||
      _next != null ||
      _attachments.isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final c in _fields) {
      c.addListener(_refresh);
    }
    _medicines.first.note.addListener(_refresh);
    _listening.addListener(_listeningChanged);
    _recording.addListener(_listeningChanged);
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = AppLanguage.fromCode(prefs.getString(_languageKey));
    if (saved != null && mounted && _language == null) {
      setState(() => _language = saved);
    }
  }

  void _pickLanguage(AppLanguage language) {
    setState(() => _language = language);
    SharedPreferences.getInstance().then(
      (p) => p.setString(_languageKey, language.code),
    );
  }

  void _refresh() => setState(() {});

  /// Rebuilds for starting and stopping only, not for every word heard.
  void _listeningChanged() {
    final busy = _listening.listening || _recording.recording;
    if (busy == _wasListening) return;
    setState(() => _wasListening = busy);
  }

  void _addRecording(VisitAttachment a) {
    // Finished after the page closed: nothing to keep it with.
    if (!mounted || _leaving) {
      AttachmentStore.instance.delete(a.file);
      return;
    }
    setState(() => _attachments.add(a));
  }

  @override
  void dispose() {
    _listening.dispose();
    _recording.dispose();
    for (final c in _fields) {
      c.dispose();
    }
    for (final m in _medicines) {
      m.note.dispose();
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

  void _addMedicine() {
    HapticFeedback.selectionClick();
    final m = _MedicineDraft();
    m.note.addListener(_refresh);
    setState(() => _medicines.add(m));
  }

  Future<void> _removeMedicine(_MedicineDraft m) async {
    final files = _attachmentsOf(m);
    if (_hasText(m) || files.isNotEmpty) {
      final l = context.l10n;
      final ok = await confirmAction(
        context,
        title: l.deleteMedicineConfirm,
        body: files.isEmpty ? null : l.removeMedicineBody,
        confirm: l.remove,
      );
      if (!ok || !mounted) return;
    }
    for (final a in files) {
      AttachmentStore.instance.delete(a.file);
    }
    setState(() {
      _medicines.remove(m);
      _attachments.removeWhere((a) => a.itemId == m.id);
    });
    // After the frame, so its field (and any listening in it) is gone.
    WidgetsBinding.instance.addPostFrameCallback((_) => m.note.dispose());
  }

  void _removeQuestion(VisitPrep prep, DoctorQuestion q) {
    final repo = CareScope.of(context);
    final at = prep.questions.indexOf(q);
    if (at < 0) return;
    prep.questions.removeAt(at);
    repo.updatePrep(prep);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.questionRemoved),
          // Goes by itself: it would otherwise sit over "Save visit".
          persist: false,
          action: SnackBarAction(
            label: context.l10n.undo,
            onPressed: () {
              prep.questions.insert(at.clamp(0, prep.questions.length), q);
              repo.updatePrep(prep);
            },
          ),
        ),
      );
  }

  Future<void> _save() async {
    // Keeps the words of the sentence still being heard, and the recording
    // still going.
    await _listening.stop();
    await _recording.stop();
    if (!mounted) return;
    final repo = CareScope.of(context);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final auto = AutoScope.maybeOf(context)?.enabled ?? false;
    final visit = repo.addVisit(
      date: _date,
      doctorName: _doctor.text,
      reason: _reason.text,
      notes: _notes.text,
      medicines: [
        for (final m in _medicines)
          if (_hasText(m) || _attachmentsOf(m).isNotEmpty)
            VisitMedicine(id: m.id, note: m.note.text),
      ],
      nextVisit: _next,
      prep: repo.prepById(widget.prepId),
      attachments: _attachments,
    );
    HapticFeedback.mediumImpact();
    setState(() => _leaving = true);
    final medicines = visit != null && visit.medicines.isNotEmpty;
    if (medicines && !auto) {
      // Straight on to checking what Gurtu read, and turning reminders on.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ReminderReviewPage(visitId: visit.id),
        ),
      );
    } else {
      Navigator.pop(context);
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          // Gurtu AI reads them and turns the reminders on by itself.
          content: Text(medicines && auto ? l.visitSavedAuto : l.visitSaved),
        ),
      );
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
    await _recording.stop(keep: false);
    for (final a in _attachments) {
      AttachmentStore.instance.delete(a.file);
    }
    setState(() => _leaving = true);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final prep = repo.prepById(widget.prepId);
    final appLanguage = LanguageScope.of(context).value;
    final languages = doctorLanguages(appLanguage);
    final language = languages.contains(_language)
        ? _language!
        : languages.contains(appLanguage)
        ? appLanguage
        : AppLanguage.english;
    final localeId = DictationController.localeFor(language.code);

    return PopScope(
      // Never lose what the doctor said to an accidental back swipe.
      canPop: _leaving || (!_hasContent && !_listening.listening),
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

          DoctorListener(
            controller: _listening,
            recorder: _recording,
            recordings: [
              for (final a in _attachments)
                if (a.section == VisitSection.doctor) a,
            ],
            onRemoveRecording: (a) {
              setState(() => _attachments.remove(a));
              AttachmentStore.instance.delete(a.file);
            },
            language: language,
            languages: languages,
            onLanguage: _pickLanguage,
          ),

          if (prep != null && prep.questions.isNotEmpty) ...[
            const SizedBox(height: 24),
            FieldLabel(l.yourQuestions, icon: Icons.help_outline_rounded),
            Text(l.tickWhenAsked, style: t.bodyMedium),
            const SizedBox(height: 8),
            QuestionList(
              questions: prep.questions,
              onToggle: (q) {
                q.asked = !q.asked;
                repo.updatePrep(prep);
              },
              onRemove: (q) => _removeQuestion(prep, q),
            ),
          ],

          const SizedBox(height: 24),
          FieldLabel(
            l.medicinesSection,
            optional: true,
            icon: Icons.medication_rounded,
          ),
          Text(
            l.medicinesVisitHint,
            style: t.bodyMedium?.copyWith(color: GurtuColors.textMuted),
          ),
          const SizedBox(height: 12),
          for (final (i, m) in _medicines.indexed) ...[
            VisitMedicineCard(
              key: ValueKey(m.id),
              number: i + 1,
              onDelete: () => _removeMedicine(m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DictationField(
                    controller: m.note,
                    hint: l.medicinesHint,
                    minLines: 1,
                    maxLines: 4,
                    localeId: localeId,
                    languageName: language.nativeName,
                  ),
                  _tray(VisitSection.medicines, itemId: m.id),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: AddMedicineButton(
              another: _medicines.isNotEmpty,
              onPressed: _addMedicine,
            ),
          ),

          const SizedBox(height: 24),
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
          _tray(VisitSection.nextVisit),
        ],
      ),
    );
  }

  Widget _tray(VisitSection section, {String? itemId}) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: AttachmentTray(
      section: section,
      itemId: itemId,
      showHint: itemId == null,
      attachments: [
        for (final a in _attachments)
          if (a.section == section && a.itemId == itemId) a,
      ],
      onAdd: (a) {
        // Picked after the page closed, or for a medicine removed in the
        // meantime: nothing to keep it with.
        final gone = itemId != null && !_medicines.any((m) => m.id == itemId);
        if (!mounted || _leaving || gone) {
          AttachmentStore.instance.delete(a.file);
          return;
        }
        setState(() => _attachments.add(a));
      },
      onRemove: (a) {
        setState(() => _attachments.remove(a));
        AttachmentStore.instance.delete(a.file);
      },
    ),
  );
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
