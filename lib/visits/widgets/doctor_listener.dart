import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';

import '../../data/attachment_store.dart';
import '../../data/visit_models.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_page.dart';
import '../../widgets/voice_input.dart';
import 'attachment_tray.dart';

/// Languages a doctor can be listened to in: English, Hindi and Telugu,
/// plus the app language when it is another one.
List<AppLanguage> doctorLanguages(AppLanguage app) => [
  AppLanguage.english,
  AppLanguage.hindi,
  AppLanguage.telugu,
  if (!const {
    AppLanguage.english,
    AppLanguage.hindi,
    AppLanguage.telugu,
  }.contains(app))
    app,
];

/// Records the doctor talking into the visit's private folder on this phone
/// (`AttachmentStore`). [onSaved] gets each finished recording; one cut
/// short (under a second) or cancelled is deleted.
class DoctorRecorder extends ChangeNotifier {
  DoctorRecorder({required this.onSaved});

  final ValueChanged<VisitAttachment> onSaved;

  /// Made on first use, so nothing touches the microphone before then.
  AudioRecorder? _recorder;
  StreamSubscription<Amplitude>? _amplitude;
  final _clock = Stopwatch();
  DateTime _startedAt = DateTime.now();
  String? _file;
  bool _starting = false;
  static int _n = 0;

  bool get recording => _file != null;
  Duration get elapsed => _clock.elapsed;

  /// Loudness, 0 to 1.
  final level = ValueNotifier<double>(0);

  /// Null once recording, otherwise why it couldn't start.
  Future<SpeechFailure?> start() async {
    if (recording || _starting) return null;
    if (!AttachmentStore.instance.available) return SpeechFailure.unavailable;
    _starting = true;
    try {
      await Mic.claim(this, stop);
      final recorder = _recorder ??= AudioRecorder();
      if (!await recorder.hasPermission()) {
        Mic.free(this);
        return SpeechFailure.permission;
      }
      final target = AttachmentStore.instance.create('m4a');
      await recorder.start(
        const RecordConfig(numChannels: 1, bitRate: 64000),
        path: target.path,
      );
      _file = target.file;
      _startedAt = DateTime.now();
      _clock
        ..reset()
        ..start();
      _amplitude = recorder
          .onAmplitudeChanged(const Duration(milliseconds: 150))
          // dBFS: about -50 in a quiet room, 0 at the loudest.
          .listen((a) => level.value = ((a.current + 50) / 50).clamp(0.0, 1.0));
      unawaited(ScreenAwake.set(true));
      notifyListeners();
      return null;
    } on Exception catch (e) {
      debugPrint('Recording the doctor failed to start: $e');
      Mic.free(this);
      return SpeechFailure.unavailable;
    } finally {
      _starting = false;
    }
  }

  /// Ends the recording; [keep] false throws it away.
  Future<void> stop({bool keep = true}) async {
    final file = _file;
    if (file == null) return;
    _file = null;
    _clock.stop();
    final length = _clock.elapsed;
    await _amplitude?.cancel();
    _amplitude = null;
    level.value = 0;
    Mic.free(this);
    unawaited(ScreenAwake.set(false));
    notifyListeners();
    try {
      await _recorder?.stop();
    } on Exception catch (e) {
      debugPrint('Recording the doctor failed to stop: $e');
      keep = false;
    }
    if (!keep || length < const Duration(seconds: 1)) {
      await AttachmentStore.instance.delete(file);
      return;
    }
    onSaved(
      VisitAttachment(
        id: 'att_doc_${DateTime.now().microsecondsSinceEpoch}_${_n++}',
        kind: AttachmentKind.audio,
        section: VisitSection.doctor,
        file: file,
        createdAt: _startedAt,
        duration: length,
      ),
    );
  }

  @override
  void dispose() {
    final file = _file;
    _file = null;
    _amplitude?.cancel();
    Mic.free(this);
    if (file != null) {
      // Closed mid-recording without saving: leave nothing half-written.
      unawaited(ScreenAwake.set(false));
      final recorder = _recorder;
      (recorder == null ? Future<void>.value() : recorder.stop())
          .catchError((_) => null)
          .whenComplete(() => AttachmentStore.instance.delete(file));
    }
    _recorder?.dispose();
    level.dispose();
    super.dispose();
  }
}

/// "What the doctor said": pick the doctor's language, then either listen
/// (the phone's own speech recognizer writes the words, no downloaded
/// model) or record the doctor's voice to play later. The words being heard
/// show live under the button; each finished sentence is added to the text
/// box, where it can be corrected. Recordings are listed with play and
/// delete.
class DoctorListener extends StatefulWidget {
  const DoctorListener({
    super.key,
    required this.controller,
    required this.recorder,
    required this.recordings,
    required this.onRemoveRecording,
    required this.language,
    required this.languages,
    required this.onLanguage,
  });

  /// Continuous and not live: see [DictationController].
  final DictationController controller;
  final DoctorRecorder recorder;
  final List<VisitAttachment> recordings;
  final ValueChanged<VisitAttachment> onRemoveRecording;
  final AppLanguage language;
  final List<AppLanguage> languages;
  final ValueChanged<AppLanguage> onLanguage;

  @override
  State<DoctorListener> createState() => _DoctorListenerState();
}

class _DoctorListenerState extends State<DoctorListener> {
  final _scroll = ScrollController();
  final _focus = FocusNode();
  Timer? _tick;
  bool _wasBusy = false;

  DictationController get _c => widget.controller;
  DoctorRecorder get _r => widget.recorder;

  @override
  void initState() {
    super.initState();
    _c.addListener(_changed);
    _r.addListener(_changed);
    _c.text.addListener(_followText);
    // Scrolled back into view while listening: the clock runs again.
    _changed();
  }

  @override
  void didUpdateWidget(DoctorListener old) {
    super.didUpdateWidget(old);
    if (old.language != widget.language) {
      _c.switchLanguage(DictationController.localeFor(widget.language.code));
    }
  }

  void _changed() {
    final busy = _c.listening || _r.recording;
    if (busy == _wasBusy) return;
    _wasBusy = busy;
    _tick?.cancel();
    // The clock on the live panels.
    if (busy) {
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  /// Keeps the newest sentence in view while listening, unless the person
  /// is correcting the text.
  void _followText() {
    if (!_c.listening || _focus.hasFocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  Future<void> _toggleRecording() async {
    HapticFeedback.mediumImpact();
    if (_r.recording) return _r.stop();
    final failure = await _r.start();
    if (failure != null && mounted) showVoiceProblem(context, failure);
  }

  Future<void> _remove(VisitAttachment a) async {
    final l = context.l10n;
    final ok = await confirmAction(
      context,
      title: l.removeAttachmentTitle,
      body: l.removeAttachmentBody,
      confirm: l.remove,
    );
    if (ok) widget.onRemoveRecording(a);
  }

  @override
  void dispose() {
    _tick?.cancel();
    _c.removeListener(_changed);
    _r.removeListener(_changed);
    _c.text.removeListener(_followText);
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final language = widget.language;
    // The words about the doctor's speech follow the language picked.
    final said = lookupAppLocalizations(language.locale);
    final time = MaterialLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(l.doctorSaid, icon: Icons.record_voice_over_rounded),
        Text(l.doctorSpeaks, style: t.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final lang in widget.languages)
              _LanguageChip(
                language: lang,
                selected: lang == language,
                onTap: () => widget.onLanguage(lang),
              ),
          ],
        ),
        const SizedBox(height: 14),
        VoiceButton(
          controller: _c,
          label: l.listenToDoctor,
          large: true,
          localeId: DictationController.localeFor(language.code),
          languageName: language.nativeName,
        ),
        const SizedBox(height: 10),
        ListenableBuilder(
          listenable: _r,
          builder: (context, _) =>
              _RecordButton(recording: _r.recording, onTap: _toggleRecording),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            l.recordOrListenHint,
            style: t.bodySmall?.copyWith(color: GurtuColors.textMuted),
          ),
        ),
        ListenableBuilder(
          listenable: Listenable.merge([_c, _r]),
          builder: (context, _) => AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _c.listening
                ? _LivePanel(controller: _c, language: language)
                : _r.recording
                ? _RecordingPanel(recorder: _r)
                : const SizedBox(width: double.infinity),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _c.text,
          focusNode: _focus,
          scrollController: _scroll,
          minLines: 5,
          maxLines: 12,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(fontSize: 17, height: 1.45),
          decoration: InputDecoration(hintText: said.doctorSaidHint),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            said.transcriptHelp,
            style: t.bodySmall?.copyWith(color: GurtuColors.textMuted),
          ),
        ),
        if (widget.recordings.isNotEmpty) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.graphic_eq_rounded,
                size: 20,
                color: GurtuColors.primary,
              ),
              const SizedBox(width: 8),
              Text(l.doctorRecordings, style: t.titleSmall),
            ],
          ),
          const SizedBox(height: 8),
          for (final (i, a) in widget.recordings.indexed) ...[
            VoiceNoteTile(
              key: ValueKey(a.id),
              attachment: a,
              title:
                  '${l.recordingNumber(i + 1)} · '
                  '${time.formatTimeOfDay(TimeOfDay.fromDateTime(a.createdAt))}',
              onRemove: () => _remove(a),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}

/// Outlined "Record the doctor's voice" / red "Stop and save" button.
class _RecordButton extends StatelessWidget {
  const _RecordButton({required this.recording, required this.onTap});

  final bool recording;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fg = recording ? Colors.white : GurtuColors.danger;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: recording
          ? const ListeningDot(size: 22)
          : Icon(Icons.fiber_manual_record_rounded, color: fg, size: 22),
      label: Text(recording ? l.stopAndSave : l.recordDoctor),
      style: OutlinedButton.styleFrom(
        foregroundColor: fg,
        backgroundColor: recording ? GurtuColors.danger : GurtuColors.surface,
        minimumSize: const Size(48, 54),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        side: BorderSide(
          color: GurtuColors.danger.withValues(alpha: recording ? 1 : 0.4),
          width: 1.4,
        ),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: GurtuFonts.sans,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}

/// Shown while recording: how long, and how loud the room is.
class _RecordingPanel extends StatelessWidget {
  const _RecordingPanel({required this.recorder});

  final DoctorRecorder recorder;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: GurtuColors.danger.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        border: Border.all(
          color: GurtuColors.danger.withValues(alpha: 0.25),
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          _LevelBars(level: recorder.level),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.recordingNow,
              style: t.titleSmall?.copyWith(
                color: GurtuColors.danger,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            _clock(recorder.elapsed),
            style: t.titleSmall?.copyWith(
              color: GurtuColors.textSecondary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: language.nativeName,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: selected
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap();
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? GurtuColors.primary : GurtuColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: selected ? GurtuColors.primary : GurtuColors.outline,
                width: 1.4,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  language.nativeName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : GurtuColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown while listening: language, running time, how loud the room is and
/// the words of the sentence being spoken.
class _LivePanel extends StatelessWidget {
  const _LivePanel({required this.controller, required this.language});

  final DictationController controller;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final partial = controller.partial.trim();
    final offline = controller.problem == SpeechFailure.network;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: GurtuColors.danger.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        border: Border.all(
          color: GurtuColors.danger.withValues(alpha: 0.25),
          width: 1.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LevelBars(level: controller.level),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.listeningIn(language.nativeName),
                  style: t.titleSmall?.copyWith(
                    color: GurtuColors.danger,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _clock(controller.elapsed),
                style: t.titleSmall?.copyWith(
                  color: GurtuColors.textSecondary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Semantics(
            liveRegion: true,
            child: Text(
              partial.isEmpty
                  ? lookupAppLocalizations(language.locale).liveCaptionHint
                  : partial,
              style: partial.isEmpty
                  ? t.bodyMedium?.copyWith(
                      color: GurtuColors.textMuted,
                      fontStyle: FontStyle.italic,
                    )
                  : const TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: GurtuColors.textPrimary,
                    ),
            ),
          ),
          if (offline) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 20,
                  color: GurtuColors.amber,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.voiceWaitingInternet,
                    style: t.bodySmall?.copyWith(color: GurtuColors.amber),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

String _clock(Duration d) {
  final m = (d.inMinutes % 60).toString().padLeft(2, '0');
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
}

/// Five bars that rise with the loudness of the room, so it's clear the
/// phone is hearing.
class _LevelBars extends StatelessWidget {
  const _LevelBars({required this.level});

  final ValueListenable<double> level;

  static const _shape = [0.45, 0.8, 1.0, 0.7, 0.4];

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 34,
        height: 24,
        child: ValueListenableBuilder<double>(
          valueListenable: level,
          builder: (context, v, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final f in _shape)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 4,
                  height: 4 + 20 * f * v,
                  decoration: BoxDecoration(
                    color: GurtuColors.danger,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
