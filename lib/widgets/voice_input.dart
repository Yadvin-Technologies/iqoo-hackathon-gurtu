import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';

/// Why voice input stopped, or is struggling.
enum SpeechFailure {
  /// The microphone permission was refused.
  permission,

  /// The phone's recognizer doesn't have the chosen language.
  language,

  /// The recognizer needs the internet and there is none. In continuous
  /// mode this passes: the controller keeps trying.
  network,

  /// No recognizer on this phone, or it failed to start.
  unavailable,
}

/// The microphone does one thing at a time: speech to text, recording the
/// doctor, or a voice note. Claiming it stops whatever had it before.
class Mic {
  Mic._();

  static Object? _owner;
  static Future<void> Function()? _release;

  static Future<void> claim(
    Object owner,
    Future<void> Function() release,
  ) async {
    if (_owner != null && !identical(_owner, owner)) {
      final previous = _release;
      _owner = null;
      _release = null;
      await previous?.call();
    }
    _owner = owner;
    _release = release;
  }

  static void free(Object owner) {
    if (!identical(_owner, owner)) return;
    _owner = null;
    _release = null;
  }
}

/// Speech-to-text behind an interface so tests (and a future on-device
/// Whisper model) can replace the platform recognizer.
abstract class SpeechService {
  /// Replaced in tests.
  static SpeechService instance = DeviceSpeechService();

  /// Starts one listening session. [onWords] gets the words heard so far in
  /// this session; [onStopped] fires once when the session ends by itself,
  /// after [onFailed] if it ended because of a problem. [onLevel] gets the
  /// loudness, 0 to 1. Returns false when listening could not start (after
  /// calling [onFailed]).
  Future<bool> start({
    required String localeId,
    required void Function(String words, bool isFinal) onWords,
    required VoidCallback onStopped,
    ValueChanged<SpeechFailure>? onFailed,
    ValueChanged<double>? onLevel,
  });

  /// Ends the current session. Its callbacks are not called any more.
  Future<void> stop();
}

/// The phone's own recognizer (Google on Android), which understands
/// English, Hindi, Telugu and the other Indian languages Gurtu offers. No
/// model is downloaded: the platform does the work. Asks for the microphone
/// permission on first use.
class DeviceSpeechService implements SpeechService {
  final _stt = SpeechToText();
  bool _ready = false;
  _Session? _current;
  List<String>? _localeIds;

  /// The phone's own id for the language of [wanted] (`hi_IN`, `te-IN`…), so
  /// the recognizer really listens in that language.
  Future<String> _resolve(String wanted) async {
    try {
      // Some phones never answer this; don't hold up listening for it.
      _localeIds ??= [
        for (final l in await _stt.locales().timeout(
          const Duration(seconds: 2),
        ))
          l.localeId,
      ];
    } on Exception {
      _localeIds = const [];
    }
    final ids = _localeIds!;
    String norm(String id) => id.replaceAll('-', '_').toLowerCase();
    final w = norm(wanted);
    final lang = w.split('_').first;
    return ids.where((id) => norm(id) == w).firstOrNull ??
        ids.where((id) => norm(id) == '${lang}_in').firstOrNull ??
        ids.where((id) => norm(id).split('_').first == lang).firstOrNull ??
        wanted;
  }

  @override
  Future<bool> start({
    required String localeId,
    required void Function(String words, bool isFinal) onWords,
    required VoidCallback onStopped,
    ValueChanged<SpeechFailure>? onFailed,
    ValueChanged<double>? onLevel,
  }) async {
    _current?.close();
    final session = _current = _Session(onStopped, onFailed);
    try {
      if (!_ready) {
        _ready = await _stt.initialize(
          onStatus: (s) => _current?.status(s),
          onError: (e) => _current?.error(e.errorMsg),
        );
      }
      if (!_ready) {
        final allowed = await _stt.hasPermission;
        return session.refuse(
          allowed ? SpeechFailure.unavailable : SpeechFailure.permission,
        );
      }
      final locale = await _resolve(localeId);
      if (!session.open) return false;
      await _stt.listen(
        onResult: (r) {
          if (session.open) onWords(r.recognizedWords, r.finalResult);
        },
        onSoundLevelChange: onLevel == null
            ? null
            // Android reports roughly -2 (quiet) to 10 (loud) dB.
            : (db) {
                if (session.open) onLevel(((db + 2) / 12).clamp(0.0, 1.0));
              },
        listenOptions: SpeechListenOptions(
          localeId: locale,
          listenMode: ListenMode.dictation,
          partialResults: true,
          // Errors end the session and the caller decides whether to go on.
          // Cancelling here would also cancel the session started next.
          cancelOnError: false,
          autoPunctuation: true,
          listenFor: const Duration(minutes: 2),
        ),
      );
      // The recognizer was still busy: end this try so the caller retries.
      if (!_stt.isListening) {
        Timer(const Duration(milliseconds: 400), () {
          if (session.open && !_stt.isListening) session.finish();
        });
      }
      return true;
    } on Exception catch (e) {
      debugPrint('Voice input failed to start: $e');
      return session.refuse(SpeechFailure.unavailable);
    }
  }

  @override
  Future<void> stop() async {
    _current?.close();
    _current = null;
    try {
      await _stt.stop();
    } on Exception {
      // Already stopped.
    }
  }
}

/// One listening session: turns the recognizer's status and error events
/// into a single "stopped" call.
class _Session {
  _Session(this._onStopped, this._onFailed);

  final VoidCallback _onStopped;
  final ValueChanged<SpeechFailure>? _onFailed;
  Timer? _fallback;
  bool open = true;

  void status(String s) {
    if (s == SpeechToText.doneStatus) {
      // Android reports the error that ended a session just after "done";
      // wait for it, so a missing language isn't retried forever.
      _fallback?.cancel();
      _fallback = Timer(const Duration(milliseconds: 200), finish);
    } else if (s == SpeechToText.notListeningStatus) {
      // "done" waits for the final words; if they never come, go on anyway.
      _fallback ??= Timer(const Duration(milliseconds: 1500), finish);
    }
  }

  void error(String message) {
    final failure = switch (message) {
      'error_permission' => SpeechFailure.permission,
      'error_language_not_supported' ||
      'error_language_unavailable' => SpeechFailure.language,
      'error_network' ||
      'error_network_timeout' ||
      'error_server' ||
      'error_server_disconnected' => SpeechFailure.network,
      // Silence, nothing understood, or a busy recognizer: just end.
      _ => null,
    };
    if (failure != null && open) _onFailed?.call(failure);
    _fallback ??= Timer(const Duration(milliseconds: 800), finish);
  }

  void finish() {
    if (!open) return;
    close();
    _onStopped();
  }

  bool refuse(SpeechFailure failure) {
    if (open) _onFailed?.call(failure);
    close();
    return false;
  }

  void close() {
    open = false;
    _fallback?.cancel();
  }
}

/// Keeps the screen on while the doctor is being listened to: a phone that
/// locks itself mid-visit stops hearing.
class ScreenAwake {
  ScreenAwake._();

  static const _channel = MethodChannel('gurtu/device');

  static Future<void> set(bool on) async {
    try {
      await _channel.invokeMethod<void>('keepScreenOn', on);
    } on MissingPluginException {
      // Tests, and platforms without the channel.
    } on PlatformException catch (e) {
      debugPrint('Keep screen on failed: $e');
    }
  }
}

/// Types what is heard into [text].
///
/// With [live] the words appear in the field as they are heard. Without it,
/// the field gets each finished sentence on its own line, and the words
/// still being heard are in [partial]; typing in the field while listening
/// is then always safe.
///
/// In [continuous] mode it keeps listening through pauses (the recognizer
/// stops on every silence) and through a dropped internet connection until
/// [stop] is called, which is what a doctor's appointment needs.
class DictationController extends ChangeNotifier {
  DictationController(this.text, {this.continuous = false, this.live = true});

  final TextEditingController text;
  final bool continuous;
  final bool live;

  bool _listening = false;
  bool get listening => _listening;

  /// Words heard in the sentence still being spoken.
  String get partial => _listening ? _heard : '';

  /// Loudness of what the microphone hears, 0 to 1.
  final level = ValueNotifier<double>(0);

  /// Set while voice input is struggling but still trying.
  SpeechFailure? get problem => _problem;
  SpeechFailure? _problem;

  /// How long this listening has gone on.
  Duration get elapsed => _clock.elapsed;
  final _clock = Stopwatch();

  /// The recognizer language, like `te_IN`.
  String get localeId => _localeId;
  String _localeId = 'en_IN';

  String _base = '';
  String _heard = '';

  /// The field's text as last written here, to notice typing in between.
  String _written = '';
  int _session = 0;
  int _retries = 0;
  Timer? _restart;
  ValueChanged<SpeechFailure>? _onFailure;

  /// The recognizer locale for a language code.
  static String localeFor(String languageCode) => '${languageCode}_IN';

  /// Returns false when voice input could not start. [onFailure] hears why,
  /// then and whenever listening stops because of a problem.
  Future<bool> start(
    Locale locale, {
    String? localeId,
    ValueChanged<SpeechFailure>? onFailure,
  }) async {
    if (_listening) return true;
    await Mic.claim(this, stop);
    _localeId = localeId ?? localeFor(locale.languageCode);
    _onFailure = onFailure;
    _base = text.text.trim();
    _written = text.text;
    _problem = null;
    _retries = 0;
    _listening = true;
    _clock
      ..reset()
      ..start();
    if (continuous) unawaited(ScreenAwake.set(true));
    notifyListeners();
    return _listen();
  }

  Future<void> stop() async {
    if (!_listening) return;
    _commit();
    _end();
    await SpeechService.instance.stop();
  }

  Future<void> toggle(
    Locale locale, {
    String? localeId,
    ValueChanged<SpeechFailure>? onFailure,
  }) async {
    if (_listening) return stop();
    await start(locale, localeId: localeId, onFailure: onFailure);
  }

  /// Listens in another language from now on; what was heard is kept.
  Future<void> switchLanguage(String localeId) async {
    if (localeId == _localeId) return;
    _localeId = localeId;
    if (!_listening) return;
    _commit();
    _session++;
    _problem = null;
    _retries = 0;
    notifyListeners();
    await SpeechService.instance.stop();
    if (_listening) _scheduleRestart();
  }

  Future<bool> _listen() async {
    final session = ++_session;
    _heard = '';
    SpeechFailure? failure;
    final ok = await SpeechService.instance.start(
      localeId: _localeId,
      onWords: (words, isFinal) {
        if (!_listening || session != _session) return;
        _heard = words;
        if (words.trim().isNotEmpty) {
          _problem = null;
          _retries = 0;
        }
        if (live) _write();
        if (isFinal) _commit();
        notifyListeners();
      },
      onLevel: (v) {
        if (session == _session) level.value = v;
      },
      onFailed: (f) => failure = f,
      onStopped: () {
        if (session != _session) return;
        _commit();
        level.value = 0;
        if (!_listening) return;
        final f = failure;
        if (f == SpeechFailure.permission || f == SpeechFailure.language) {
          _fail(f!);
        } else if (continuous) {
          // Silence ended the session, or the internet dropped: go on.
          _problem = f;
          notifyListeners();
          _scheduleRestart();
        } else {
          _end();
          if (f != null) _onFailure?.call(f);
        }
      },
    );
    if (!ok && session == _session && _listening) {
      _fail(failure ?? SpeechFailure.unavailable);
    }
    return ok;
  }

  void _scheduleRestart() {
    _restart?.cancel();
    // A short gap lets the recognizer shut down first; longer ones while the
    // internet is gone, so it isn't hammered.
    final wait = _problem == SpeechFailure.network
        ? Duration(seconds: 2 << _retries.clamp(0, 2))
        : const Duration(milliseconds: 300);
    _retries++;
    _restart = Timer(wait, () {
      if (_listening) unawaited(_listen());
    });
  }

  void _fail(SpeechFailure failure) {
    _end();
    _onFailure?.call(failure);
  }

  void _end() {
    Mic.free(this);
    _restart?.cancel();
    _session++;
    _listening = false;
    _heard = '';
    _problem = null;
    level.value = 0;
    _clock.stop();
    if (continuous) unawaited(ScreenAwake.set(false));
    notifyListeners();
  }

  void _write() {
    // Typed in while listening: keep what was typed.
    if (text.text != _written) _base = text.text.trim();
    _set([_base, _heard].where((s) => s.trim().isNotEmpty).join(' '));
  }

  void _commit() {
    final heard = _heard.trim();
    if (heard.isEmpty) {
      _heard = '';
      return;
    }
    if (live) {
      _write();
      _base = text.text.trim();
    } else {
      final before = text.text.trimRight();
      _set(before.isEmpty ? heard : '$before\n$heard');
    }
    _heard = '';
  }

  void _set(String value) {
    _written = value;
    text.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  @override
  void dispose() {
    Mic.free(this);
    _restart?.cancel();
    if (_listening) {
      _listening = false;
      _session++;
      if (continuous) unawaited(ScreenAwake.set(false));
      unawaited(SpeechService.instance.stop());
    }
    level.dispose();
    super.dispose();
  }
}

/// Tells the person why voice input stopped. [languageName] is the language
/// that was being listened for.
void showVoiceProblem(
  BuildContext context,
  SpeechFailure failure, {
  String? languageName,
}) {
  if (!context.mounted) return;
  final l = context.l10n;
  final text = switch (failure) {
    SpeechFailure.permission => l.permissionBlocked(l.permMic),
    SpeechFailure.language => l.voiceLanguageMissing(
      languageName ?? LanguageScope.of(context).value.nativeName,
    ),
    SpeechFailure.network => l.voiceNeedsInternet,
    SpeechFailure.unavailable => l.voiceUnavailable,
  };
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 6),
        persist: false,
        action: failure == SpeechFailure.permission
            ? SnackBarAction(label: l.settings, onPressed: openAppSettings)
            : null,
      ),
    );
}

void showVoiceUnavailable(BuildContext context) =>
    showVoiceProblem(context, SpeechFailure.unavailable);

/// Pill "Speak" / "Stop" button for a [DictationController].
class VoiceButton extends StatelessWidget {
  const VoiceButton({
    super.key,
    required this.controller,
    this.label,
    this.large = false,
    this.localeId,
    this.languageName,
  });

  final DictationController controller;

  /// Defaults to "Speak".
  final String? label;

  /// The big amber "Listen to the doctor" version.
  final bool large;

  /// Recognizer language; defaults to the app language.
  final String? localeId;

  /// Native name of [localeId]'s language, for messages.
  final String? languageName;

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
                    localeId: localeId,
                    onFailure: (f) => showVoiceProblem(
                      context,
                      f,
                      languageName: languageName,
                    ),
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
                          ? ListeningDot(size: large ? 26 : 20)
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

/// Breathing stop dot shown while listening.
class ListeningDot extends StatefulWidget {
  const ListeningDot({super.key, required this.size});

  final double size;

  @override
  State<ListeningDot> createState() => _ListeningDotState();
}

class _ListeningDotState extends State<ListeningDot>
    with SingleTickerProviderStateMixin {
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
    this.localeId,
    this.languageName,
  });

  final TextEditingController controller;
  final String? hint;
  final int minLines;
  final int maxLines;
  final bool continuous;
  final ValueChanged<String>? onChanged;
  final String? speakLabel;

  /// Recognizer language; defaults to the app language.
  final String? localeId;
  final String? languageName;

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

  @override
  void didUpdateWidget(DictationField old) {
    super.didUpdateWidget(old);
    // The language was changed while speaking: follow it.
    final id = widget.localeId;
    if (id != null && id != old.localeId && _dictation.listening) {
      _dictation.switchLanguage(id);
    }
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
          child: VoiceButton(
            controller: _dictation,
            label: widget.speakLabel,
            localeId: widget.localeId,
            languageName: widget.languageName,
          ),
        ),
      ],
    );
  }
}
