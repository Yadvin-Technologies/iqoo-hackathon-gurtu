import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ai/model_catalog.dart';
import '../ai/on_device_ai.dart';

enum SmartSearchStatus {
  /// This phone can't run it (no on-device AI): word search only.
  unavailable,

  /// Not downloaded yet.
  off,
  downloading,
  ready,
  failed,
}

/// Turns text into meaning vectors on the phone, so Memory search and Ask
/// Gurtu find "sugar test" when the report says "HbA1c". Gecko-110M (about
/// 114 MB, runs in ~0.1 s per note), downloaded once; nothing leaves the
/// phone.
///
/// It needs the same on-device engine as Gurtu AI, so it follows it: it is
/// unavailable where Gurtu AI is, and downloads by itself (on Wi-Fi) once
/// Gurtu AI is installed.
class SmartSearch extends ChangeNotifier {
  SmartSearch(this._prefs, this._ai) {
    _ai.addListener(_aiChanged);
    _aiChanged();
  }

  static const modelUrl =
      'https://huggingface.co/litert-community/Gecko-110m-en/resolve/main/'
      'Gecko_256_quant.tflite';
  static const tokenizerUrl =
      'https://huggingface.co/litert-community/Gecko-110m-en/resolve/main/'
      'sentencepiece.model';
  static const sizeMb = 114;
  static const _installedKey = 'smart_search_installed';

  final SharedPreferences _prefs;
  final GurtuAi _ai;

  SmartSearchStatus status = SmartSearchStatus.unavailable;

  /// 0–1 while downloading.
  double progress = 0;

  EmbeddingModel? _model;
  Future<void>? _installing;
  bool _disposed = false;

  bool get isReady => status == SmartSearchStatus.ready;
  bool get _installed => _prefs.getBool(_installedKey) ?? false;

  void _aiChanged() {
    if (_disposed) return;
    switch (_ai.status) {
      case AiStatus.checking:
        return;
      case AiStatus.unsupported:
        _set(SmartSearchStatus.unavailable);
        return;
      default:
        break;
    }
    if (status != SmartSearchStatus.unavailable) {
      // Gurtu AI just finished installing: follow it, on Wi-Fi.
      if (_ai.isReady && status == SmartSearchStatus.off && !_installed) {
        unawaited(_autoInstall());
      }
      return;
    }
    _set(SmartSearchStatus.off);
    if (_installed) {
      unawaited(install());
    } else if (_ai.isReady) {
      unawaited(_autoInstall());
    }
  }

  Future<void> _autoInstall() async {
    if (await DeviceProfile.isUnmetered()) await install();
  }

  /// Downloads (once) and loads the model. Safe to call again.
  Future<void> install() =>
      _installing ??= _install().whenComplete(() => _installing = null);

  Future<void> _install() async {
    if (status == SmartSearchStatus.unavailable ||
        status == SmartSearchStatus.ready) {
      return;
    }
    if (!_installed) {
      progress = 0;
      _set(SmartSearchStatus.downloading);
    }
    try {
      // Registers the files as the active embedder; nothing is downloaded
      // when they are already on the phone.
      await FlutterGemma.installEmbedder()
          .modelFromNetwork(modelUrl)
          .tokenizerFromNetwork(tokenizerUrl)
          .withModelProgress((p) {
            progress = p / 100;
            if (!_disposed) notifyListeners();
          })
          .install();
      _model = await FlutterGemma.getActiveEmbedder(
        preferredBackend: PreferredBackend.cpu,
      );
      _prefs.setBool(_installedKey, true);
      _set(SmartSearchStatus.ready);
    } on Object catch (e) {
      debugPrint('Smart search unavailable: $e');
      _set(SmartSearchStatus.failed);
    }
  }

  /// The meaning of [text], or null when the model isn't ready (or fails):
  /// search then relies on words alone.
  Future<List<double>?> embed(String text, {required bool query}) async {
    final model = _model;
    if (model == null || text.trim().isEmpty) return null;
    try {
      return await model.generateEmbedding(
        text,
        taskType: query ? TaskType.retrievalQuery : TaskType.retrievalDocument,
      );
    } on Object catch (e) {
      debugPrint('Embedding failed: $e');
      return null;
    }
  }

  void _set(SmartSearchStatus s) {
    status = s;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _ai.removeListener(_aiChanged);
    _model?.close();
    super.dispose();
  }
}
