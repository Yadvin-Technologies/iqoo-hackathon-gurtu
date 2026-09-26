import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';

/// Speech-to-text behind an interface so tests (and a future on-device
/// Whisper model) can replace the platform recognizer.
abstract class SpeechService {
  /// Replaced in tests.
  static SpeechService instance = DeviceSpeechService();

  /// Starts one listening session. [onWords] gets the words heard so far in
  /// this session; [onStopped] fires when the recognizer stops by itself.
  /// Returns false when speech input is unavailable or not permitted.
  Future<bool> start({
    required String localeId,
    required void Function(String words, bool isFinal) onWords,
    required VoidCallback onStopped,
  });

  Future<void> stop();
}

/// The phone's own recognizer (Google on Android), which supports the Indian
/// languages Gurtu offers. Asks for the microphone permission on first use.
class DeviceSpeechService implements SpeechService {
  final _stt = SpeechToText();
  bool _ready = false;
  VoidCallback? _onStopped;

  @override
  Future<bool> start({
    required String localeId,
    required void Function(String words, bool isFinal) onWords,
    required VoidCallback onStopped,
  }) async {
    try {
      if (!_ready) {
        _ready = await _stt.initialize(
          onStatus: (s) {
            if (s == SpeechToText.doneStatus) _onStopped?.call();
          },
          onError: (_) => _onStopped?.call(),
        );
      }
      if (!_ready) return false;
      _onStopped = onStopped;
      await _stt.listen(
        onResult: (r) => onWords(r.recognizedWords, r.finalResult),
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenMode: ListenMode.dictation,
          partialResults: true,
          cancelOnError: true,
          autoPunctuation: true,
          listenFor: const Duration(minutes: 5),
          pauseFor: const Duration(seconds: 8),
        ),
      );
      return true;
    } on Exception {
      // No recognizer on this device / platform.
      return false;
    }
  }

  @override
  Future<void> stop() async {
    _onStopped = null;
    try {
      await _stt.stop();
    } on Exception {
      // Already stopped.
    }
  }
}

/// Types what is heard into [text]. In [continuous] mode it keeps listening
/// through pauses (the recognizer stops on silence) until [stop] is called,
/// which is what a doctor's appointment needs.
class DictationController extends ChangeNotifier {
  DictationController(this.text, {this.continuous = false});

  final TextEditingController text;
  final bool continuous;

  /// Only one field listens at a time; starting another stops this one.
  static DictationController? _active;

  bool _listening = false;
  bool get listening => _listening;

  String _base = '';
  String _heard = '';
  String _localeId = 'en_IN';

  /// Returns false when voice input could not start.
  Future<bool> start(Locale locale) async {
    if (_listening) return true;
    if (_active != null && _active != this) await _active!.stop();
    _active = this;
    _localeId = '${locale.languageCode}_IN';
    _base = text.text.trim();
    _listening = true;
    notifyListeners();
    final ok = await _listen();
    if (!ok) {
      _listening = false;
      notifyListeners();
    }
    return ok;
  }

  Future<void> stop() async {
    if (!_listening) return;
    if (_active == this) _active = null;
    _listening = false;
    _commit();
    notifyListeners();
    await SpeechService.instance.stop();
  }

  Future<void> toggle(Locale locale, {VoidCallback? onUnavailable}) async {
    if (_listening) return stop();
    final ok = await start(locale);
    if (!ok) onUnavailable?.call();
  }

  Future<bool> _listen() {
    _heard = '';
    return SpeechService.instance.start(
      localeId: _localeId,
      onWords: (words, isFinal) {
        if (!_listening) return;
        _heard = words;
        _write();
        if (isFinal) _commit();
      },
      onStopped: () {
        _commit();
        if (_listening && continuous) {
          // Silence ended the session; pick up again.
          unawaited(_listen());
        } else if (_listening) {
          _listening = false;
          notifyListeners();
        }
      },
    );
  }

  void _write() {
    final value = [_base, _heard].where((s) => s.trim().isNotEmpty).join(' ');
    text.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _commit() {
    if (_heard.trim().isEmpty) return;
    _write();
    _base = text.text.trim();
    _heard = '';
  }

  @override
  void dispose() {
    if (_active == this) _active = null;
    if (_listening) {
      _listening = false;
      unawaited(SpeechService.instance.stop());
    }
    super.dispose();
  }
}

void showVoiceUnavailable(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(context.l10n.voiceUnavailable)));
}

/// Pill "Speak" / "Stop" button for a [DictationController].
class VoiceButton extends StatelessWidget {
  const VoiceButton({
    super.key,
    required this.controller,
    this.label,
    this.large = false,
  });

  final DictationController controller;

  /// Defaults to "Speak".
  final String? label;

  /// The big amber "Listen to the doctor" version.
  final bool large;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final on = controller.listening;
        final text = on ? l.stopListening : (label ?? l.speak);
        final fg = on
            ? Colors.white
            : large
            ? const Color(0xFF1E1400)
            : GurtuColors.primary;
        return Semantics(
          button: true,
          label: text,
          excludeSemantics: true,
          // Shadow outside the Material so the ink layer doesn't clip it
          // into a square.
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: large
                  ? [
                      BoxShadow(
                        color: (on ? GurtuColors.danger : GurtuColors.orange)
                            .withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  controller.toggle(
                    Localizations.localeOf(context),
                    onUnavailable: () => showVoiceUnavailable(context),
                  );
                },
                child: Ink(
                  padding: EdgeInsets.symmetric(
                    horizontal: large ? 22 : 16,
                    vertical: large ? 16 : 11,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: on
                        ? GurtuColors.danger
                        : large
                        ? null
                        : GurtuColors.primarySoft,
                    gradient: !on && large ? GurtuColors.iqooGradient : null,
                  ),
                  child: Row(
                    mainAxisSize: large ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      on
                          ? _Pulse(size: large ? 26 : 20)
                          : Icon(
                              Icons.mic_rounded,
                              color: fg,
                              size: large ? 26 : 20,
                            ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: fg,
                            fontWeight: FontWeight.w800,
                            fontSize: large ? 18 : 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Breathing dot shown while listening.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.size});

  final double size;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: Center(
        child: ScaleTransition(
          scale: Tween(begin: 0.55, end: 1.0).animate(_c),
          child: Container(
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.stop_rounded,
              size: widget.size * 0.55,
              color: GurtuColors.danger,
            ),
          ),
        ),
      ),
    );
  }
}

/// A text field people can speak into as well as type: the field, then a
/// Speak button underneath (not beside it, so long labels never squeeze).
class DictationField extends StatefulWidget {
  const DictationField({
    super.key,
    required this.controller,
    this.hint,
    this.minLines = 2,
    this.maxLines = 6,
    this.continuous = false,
    this.onChanged,
    this.speakLabel,
  });

  final TextEditingController controller;
  final String? hint;
  final int minLines;
  final int maxLines;
  final bool continuous;
  final ValueChanged<String>? onChanged;
  final String? speakLabel;

  @override
  State<DictationField> createState() => _DictationFieldState();
}

class _DictationFieldState extends State<DictationField> {
  late final _dictation = DictationController(
    widget.controller,
    continuous: widget.continuous,
  );

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changed);
  }

  void _changed() => widget.onChanged?.call(widget.controller.text);

  @override
  void dispose() {
    widget.controller.removeListener(_changed);
    _dictation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(fontSize: 17, color: GurtuColors.textPrimary),
          decoration: InputDecoration(hintText: widget.hint),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: VoiceButton(controller: _dictation, label: widget.speakLabel),
        ),
      ],
    );
  }
}
