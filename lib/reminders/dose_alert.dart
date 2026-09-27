import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../cloud/push_service.dart';
import '../data/medicine_models.dart';

/// A medicine reminder push (or the family's "missed dose" alert), as the
/// server sends it (see `doseData` in the backend's reminders.js).
class DoseAlert {
  const DoseAlert({
    required this.doseId,
    required this.circleId,
    required this.medicine,
    this.missed = false,
    this.followUp = false,
    this.title = '',
    this.body = '',
    this.food = FoodTiming.any,
    this.note = '',
    this.slot,
    this.time = '',
    this.patient = '',
    this.imageUrl,
    this.audioUrl,
  });

  final String doseId;
  final String circleId;

  /// "Metformin 500 mg".
  final String medicine;

  /// The family's red alert: nobody marked it as taken.
  final bool missed;

  /// Sent again because nobody answered the first one.
  final bool followUp;

  /// The notification's own words, already in this phone's language.
  final String title;
  final String body;

  final FoodTiming food;
  final String note;
  final DoseTime? slot;

  /// "08:00", in the family's time zone.
  final String time;

  /// The person cared for.
  final String patient;
  final String? imageUrl;

  /// The doctor's voice note about this medicine.
  final String? audioUrl;

  /// Null for any other push.
  static DoseAlert? from(PushMessage m) {
    final d = m.data;
    if (d == null) return null;
    final type = d['type'];
    final doseId = '${d['doseId'] ?? ''}';
    if ((type != 'reminder' && type != 'missed_dose') || doseId.isEmpty) {
      return null;
    }
    String text(String key) => '${d[key] ?? ''}'.trim();
    String? url(String key) {
      final u = text(key);
      return u.startsWith('http') ? u : null;
    }

    return DoseAlert(
      doseId: doseId,
      circleId: text('circleId'),
      medicine: text('medicine'),
      missed: type == 'missed_dose',
      followUp: text('followUp') == '1',
      title: m.title,
      body: m.body,
      food: FoodTiming.values.asNameMap()[text('food')] ?? FoodTiming.any,
      note: text('note'),
      slot: DoseTime.values.asNameMap()[text('slot')],
      time: text('time'),
      patient: text('patient'),
      imageUrl: url('imageUrl'),
      audioUrl: url('audioUrl'),
    );
  }
}

/// Reads a reminder aloud and plays the doctor's voice note. Behind an
/// interface so tests run without the phone's speech engine.
abstract class ReminderVoice {
  static ReminderVoice instance = DeviceReminderVoice();

  /// Speaks [text] in [languageCode] (`hi`, `te`...); done when finished.
  Future<void> speak(String text, {required String languageCode});

  /// Plays a voice note; done when it ends.
  Future<void> play(String url);

  Future<void> stop();
}

class DeviceReminderVoice implements ReminderVoice {
  FlutterTts? _tts;
  AudioPlayer? _player;

  @override
  Future<void> speak(String text, {required String languageCode}) async {
    if (kIsWeb || text.trim().isEmpty) return;
    try {
      final tts = _tts ??= FlutterTts();
      await tts.awaitSpeakCompletion(true);
      final locale = '$languageCode-IN';
      // Phones without that voice read it in English rather than not at all.
      final available = await tts.isLanguageAvailable(locale);
      await tts.setLanguage(available == true ? locale : 'en-IN');
      // A little slower than usual, for older ears.
      await tts.setSpeechRate(0.42);
      await tts.speak(text);
    } on Object catch (e) {
      debugPrint('Reading the reminder aloud failed: $e');
    }
  }

  /// Finishes when the voice note ends or is stopped.
  Completer<void>? _playing;

  @override
  Future<void> play(String url) async {
    try {
      final player = _player ??= AudioPlayer();
      final done = _playing = Completer<void>();
      final sub = player.onPlayerComplete.listen((_) {
        if (!done.isCompleted) done.complete();
      });
      await player.play(UrlSource(url));
      await done.future.timeout(const Duration(minutes: 3), onTimeout: () {});
      await sub.cancel();
    } on Object catch (e) {
      debugPrint('Playing the doctor\'s voice note failed: $e');
    }
  }

  @override
  Future<void> stop() async {
    final playing = _playing;
    if (playing != null && !playing.isCompleted) playing.complete();
    try {
      await _tts?.stop();
      await _player?.stop();
    } on Object catch (e) {
      debugPrint('Stopping the reminder voice failed: $e');
    }
  }
}
