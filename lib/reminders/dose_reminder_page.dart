import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cloud/cloud_sync.dart';
import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../l10n/language.dart';
import '../medicines/medicine_text.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_widgets.dart';
import 'dose_alert.dart';

/// "Time for your medicine", full screen: opened by tapping the reminder, or
/// by itself when it arrives while Gurtu is open. Shows the medicine's
/// photo, reads the reminder aloud, then plays what the doctor said about
/// it.
class DoseReminderPage extends StatefulWidget {
  const DoseReminderPage({super.key, required this.alert});

  final DoseAlert alert;

  @override
  State<DoseReminderPage> createState() => _DoseReminderPageState();
}

class _DoseReminderPageState extends State<DoseReminderPage> {
  bool _speaking = false;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _readAloud());
  }

  @override
  void dispose() {
    ReminderVoice.instance.stop();
    super.dispose();
  }

  /// The notification's own words (already in this phone's language), or
  /// the same said from what the reminder carries.
  String _words(AppLocalizations l) {
    final a = widget.alert;
    final pushed = [a.title, a.body].where((s) => s.trim().isNotEmpty);
    if (pushed.isNotEmpty) return pushed.join('. ');
    return [
      a.medicine,
      if (a.food != FoodTiming.any) l.foodLabel(a.food),
      a.note,
    ].where((s) => s.trim().isNotEmpty).join('. ');
  }

  Future<void> _readAloud() async {
    if (!mounted) return;
    final voice = ReminderVoice.instance;
    final words = _words(context.l10n);
    final language = LanguageScope.of(context).value.code;
    await voice.stop();
    if (!mounted) return;
    setState(() => _speaking = true);
    await voice.speak(words, languageCode: language);
    final audio = widget.alert.audioUrl;
    if (audio != null && mounted && _speaking) await voice.play(audio);
    if (mounted) setState(() => _speaking = false);
  }

  Future<void> _stopVoice() async {
    setState(() => _speaking = false);
    await ReminderVoice.instance.stop();
  }

  void _answer(String status) {
    if (_answered) return;
    _answered = true;
    ReminderVoice.instance.stop();
    final taken = status == 'taken';
    answerDose(context, widget.alert, status);
    HapticFeedback.mediumImpact();
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    Navigator.pop(context);
    if (taken) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.doseTakenThanks)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = widget.alert;
    return _DoseScaffold(
      alert: a,
      eyebrow: l.reminderEyebrow,
      title: a.medicine.isEmpty ? a.title : a.medicine,
      subtitle: a.time.isEmpty ? null : l.dueAt(_clock(context, a.time)),
      extra: GurtuButton(
        label: _speaking ? l.pause : l.readAloud,
        style: GurtuButtonStyle.ghost,
        icon: _speaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
        onPressed: _speaking ? _stopVoice : _readAloud,
      ),
      primary: GurtuButton(
        label: l.takenIt,
        icon: Icons.check_rounded,
        onPressed: () => _answer('taken'),
      ),
      secondary: GurtuButton(
        label: l.skipDose,
        style: GurtuButtonStyle.ghost,
        icon: Icons.skip_next_rounded,
        onPressed: () => _answer('skipped'),
      ),
    );
  }
}

/// The family's red alert: nobody marked a dose as taken after three
/// reminders.
class MissedDosePage extends StatefulWidget {
  const MissedDosePage({super.key, required this.alert});

  final DoseAlert alert;

  @override
  State<MissedDosePage> createState() => _MissedDosePageState();
}

class _MissedDosePageState extends State<MissedDosePage> {
  bool _answered = false;

  void _markTaken() {
    if (_answered) return;
    _answered = true;
    answerDose(context, widget.alert, 'taken');
    HapticFeedback.mediumImpact();
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.doseTakenThanks)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = widget.alert;
    return _DoseScaffold(
      alert: a,
      missed: true,
      eyebrow: l.missedDoseEyebrow,
      title: a.title.isEmpty ? a.medicine : a.title,
      subtitle: a.body.isEmpty ? null : a.body,
      primary: GurtuButton(
        label: l.markTakenForThem,
        icon: Icons.check_rounded,
        onPressed: _markTaken,
      ),
      secondary: GurtuButton(
        label: l.illCheck,
        style: GurtuButtonStyle.ghost,
        icon: Icons.call_rounded,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

/// Tells every family phone (now, or once online) and ticks the dose in
/// this phone's medicine list.
void answerDose(BuildContext context, DoseAlert alert, String status) {
  final cloud = CloudScope.of(context);
  if (status == 'taken') {
    final repo = CareScope.of(context);
    final patientId = cloud.patientForCircle(alert.circleId);
    final medicine = patientId == null
        ? null
        : repo.medicineNamed(patientId, alert.medicine);
    final slot = alert.slot;
    if (medicine != null && slot != null) repo.markTaken(medicine, slot);
  }
  // Kept and retried when offline, so the screen never waits for it.
  unawaited(cloud.ackDose(alert.doseId, status));
}

/// "08:00" as this phone shows times ("8:00 AM").
String _clock(BuildContext context, String hhmm) {
  final parts = hhmm.split(':');
  final h = int.tryParse(parts.first);
  final m = parts.length > 1 ? int.tryParse(parts[1]) : 0;
  if (h == null || m == null) return hhmm;
  return MaterialLocalizations.of(context)
      .formatTimeOfDay(TimeOfDay(hour: h, minute: m));
}

class _DoseScaffold extends StatelessWidget {
  const _DoseScaffold({
    required this.alert,
    required this.eyebrow,
    required this.title,
    required this.primary,
    required this.secondary,
    this.subtitle,
    this.extra,
    this.missed = false,
  });

  final DoseAlert alert;
  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget? extra;
  final Widget primary;
  final Widget secondary;
  final bool missed;

  static const _missedBackground = Color(0xFFFFF1F1);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final a = alert;
    final image = a.imageUrl;
    final accent = missed ? GurtuColors.danger : GurtuColors.primary;

    final body = SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  tooltip: l.close,
                  iconSize: 28,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: GurtuColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                GurtuSpace.gutter,
                0,
                GurtuSpace.gutter,
                24,
              ),
              children: [
                Row(
                  children: [
                    Icon(
                      missed
                          ? Icons.warning_amber_rounded
                          : Icons.medication_rounded,
                      color: accent,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Eyebrow(
                        eyebrow,
                        color: missed ? GurtuColors.danger : GurtuColors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: t.headlineMedium?.copyWith(
                    color: missed ? GurtuColors.danger : null,
                  ),
                ),
                if (subtitle case final s?) ...[
                  const SizedBox(height: 6),
                  Text(s, style: t.titleMedium),
                ],
                if (image != null) ...[
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(GurtuSpace.radius),
                    child: Image.network(
                      image,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: a.medicine,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (a.slot case final slot?)
                      _Fact(icon: slot.icon, text: l.doseLabel(slot)),
                    if (a.food != FoodTiming.any)
                      _Fact(
                        icon: Icons.restaurant_rounded,
                        text: l.foodLabel(a.food),
                      ),
                  ],
                ),
                if (a.note.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(a.note, style: t.bodyLarge),
                ],
                if (extra != null) ...[const SizedBox(height: 24), extra!],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              GurtuSpace.gutter,
              12,
              GurtuSpace.gutter,
              12,
            ),
            decoration: const BoxDecoration(
              color: GurtuColors.surface,
              border: Border(top: BorderSide(color: GurtuColors.outline)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [primary, const SizedBox(height: 8), secondary],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: missed ? _missedBackground : null,
      body: missed ? body : GlowBackground(child: body),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: GurtuColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: GurtuColors.outline, width: 1.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: GurtuColors.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: GurtuColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
