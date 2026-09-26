import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

import 'device_monitor.dart';

/// A model that can be put under test: Gemma 4 LiteRT-LM builds (no HF token needed).
class GemmaModelSpec {
  const GemmaModelSpec._({required this.id, required this.sizeGb});

  /// Short variant id, e.g. `E2B`.
  final String id;
  final double sizeGb;

  String get name => 'Gemma 4 $id-it';
  String get fileName => 'gemma-4-$id-it.litertlm';
  String get url => 'https://huggingface.co/litert-community/gemma-4-$id-it-litert-lm/resolve/main/$fileName';

  static const e2b = GemmaModelSpec._(id: 'E2B', sizeGb: 2.59);
  static const e4b = GemmaModelSpec._(id: 'E4B', sizeGb: 3.66);
  static const all = [e2b, e4b];

  /// Context window (prompt + thinking + answer share it).
  static const contextTokens = 4096;
}

enum ModelPhase { checking, notInstalled, downloading, installed, loading, ready, error }

extension BackendLabel on PreferredBackend {
  String get label => switch (this) {
        PreferredBackend.cpu => 'CPU',
        PreferredBackend.gpu => 'GPU',
        PreferredBackend.npu => 'NPU',
      };
}

/// One finished benchmark run.
class BenchResult {
  BenchResult({
    required this.index,
    required this.model,
    required this.prompt,
    required this.thinking,
    required this.requestedBackend,
    required this.activeBackend,
    required this.speculative,
    required this.thinkingText,
    required this.answer,
    required this.firstTokenMs,
    required this.firstAnswerTokenMs,
    required this.totalMs,
    required this.metrics,
    required this.usage,
    required this.stopped,
    this.error,
  });

  final int index;
  final GemmaModelSpec model;
  final String prompt;
  final bool thinking;
  final PreferredBackend requestedBackend;
  final PreferredBackend? activeBackend;
  final bool speculative;
  final String thinkingText;
  final String answer;
  final int? firstTokenMs;
  final int? firstAnswerTokenMs;
  final int totalMs;
  final SessionMetrics? metrics;
  final UsageWindow usage;
  final bool stopped;
  final String? error;

  int? get outputTokens => (metrics?.outputTokens ?? 0) > 0 ? metrics!.outputTokens : null;
  int? get inputTokens => (metrics?.inputTokens ?? 0) > 0 ? metrics!.inputTokens : null;

  /// Time spent in the thinking phase, i.e. until the first answer token.
  int? get thinkingMs => thinking && firstTokenMs != null && firstAnswerTokenMs != null
      ? firstAnswerTokenMs! - firstTokenMs!
      : null;

  /// Decode speed. Prefer the engine's own figure; else derive it.
  double? get decodeTokPerSec {
    final engine = metrics?.tokensPerSecond;
    if (engine != null && engine > 0) return engine;
    final out = outputTokens, first = firstTokenMs;
    if (out == null || first == null || totalMs <= first) return null;
    return out / ((totalMs - first) / 1000);
  }

  /// Prefill speed = prompt tokens / time to first token.
  double? get prefillTokPerSec {
    final inTok = inputTokens;
    final ttft = metrics?.timeToFirstTokenMs ?? firstTokenMs?.toDouble();
    if (inTok == null || ttft == null || ttft <= 0) return null;
    return inTok / (ttft / 1000);
  }
}

/// Live state of the generation in progress.
class LiveRun {
  LiveRun({required this.thinking});
  final bool thinking;
  final thinkingText = StringBuffer();
  final answer = StringBuffer();
  final stopwatch = Stopwatch()..start();
  int? firstTokenMs;
  int? firstAnswerTokenMs;
  int chunks = 0;

  bool get inThinkingPhase => thinking && firstAnswerTokenMs == null;
}

/// Owns the flutter_gemma model lifecycle: install → load on a backend →
/// generate with / without thinking while recording timings and device usage.
class GemmaService extends ChangeNotifier {
  GemmaService(this.monitor) {
    monitor.addListener(_onSample);
  }

  final DeviceMonitor monitor;

  GemmaModelSpec model = GemmaModelSpec.e4b;

  /// Models whose file is on the device, refreshed by [checkInstalled].
  final Set<GemmaModelSpec> installedModels = {};

  ModelPhase phase = ModelPhase.checking;
  int downloadPercent = 0;
  String? error;
  CancelToken? _downloadCancel;

  InferenceModel? _model;
  PreferredBackend requestedBackend = PreferredBackend.gpu;
  PreferredBackend? activeBackend;
  bool speculativeDecoding = false;
  int? loadMs;

  LiveRun? live;
  UsageWindow? _liveUsage;
  InferenceChat? _chat;
  bool _stopRequested = false;
  final List<BenchResult> results = [];

  bool get isGenerating => live != null;
  bool get fellBack => activeBackend != null && activeBackend != requestedBackend;

  /// Switching is only safe while nothing is downloading, loading or generating.
  bool get canSwitchModel =>
      !isGenerating && phase != ModelPhase.downloading && phase != ModelPhase.loading && phase != ModelPhase.checking;

  /// Unloads the current model and makes [spec] the one under test.
  Future<void> selectModel(GemmaModelSpec spec) async {
    if (spec == model || !canSwitchModel) return;
    await unload();
    model = spec;
    loadMs = null;
    await checkInstalled();
  }

  Future<void> checkInstalled() async {
    phase = ModelPhase.checking;
    notifyListeners();
    try {
      for (final spec in GemmaModelSpec.all) {
        if (await FlutterGemma.isModelInstalled(spec.fileName)) {
          installedModels.add(spec);
        } else {
          installedModels.remove(spec);
        }
      }
      final installed = installedModels.contains(model);
      if (installed) {
        // Re-running install on an existing file is a no-op download, but it
        // makes this file the active model for getActiveModel().
        await _installBuilder().install();
      }
      phase = installed ? ModelPhase.installed : ModelPhase.notInstalled;
    } catch (e) {
      _fail(e);
      return;
    }
    notifyListeners();
  }

  InferenceInstallationBuilder _installBuilder() => FlutterGemma.installModel(
        modelType: ModelType.gemma4,
        fileType: ModelFileType.litertlm,
      // foreground: without it Android kills the worker at 9 minutes, and
      // HuggingFace URLs can't resume, so a multi-GB file restarts from 0% forever.
      ).fromNetwork(model.url, foreground: true);

  Future<void> download() async {
    phase = ModelPhase.downloading;
    downloadPercent = 0;
    error = null;
    _downloadCancel = CancelToken();
    notifyListeners();
    try {
      await _installBuilder()
          .withCancelToken(_downloadCancel!)
          .withProgress((p) {
            downloadPercent = p;
            notifyListeners();
          })
          .install();
      installedModels.add(model);
      phase = ModelPhase.installed;
    } catch (e) {
      if (CancelToken.isCancel(e)) {
        phase = ModelPhase.notInstalled;
      } else {
        _fail(e);
        return;
      }
    } finally {
      _downloadCancel = null;
    }
    notifyListeners();
  }

  void setSpeculativeDecoding(bool value) {
    speculativeDecoding = value;
    notifyListeners();
  }

  void cancelDownload() => _downloadCancel?.cancel('Cancelled by user');

  Future<void> deleteModel() async {
    await unload();
    try {
      await FlutterGemma.uninstallModel(model.fileName);
    } catch (_) {}
    installedModels.remove(model);
    phase = ModelPhase.notInstalled;
    notifyListeners();
  }

  /// Loads (or reloads) the model on [backend]. The engine silently falls
  /// back NPU → GPU → CPU, so [activeBackend] is what actually runs.
  Future<void> load(PreferredBackend backend) async {
    requestedBackend = backend;
    await unload();
    phase = ModelPhase.loading;
    error = null;
    notifyListeners();
    final sw = Stopwatch()..start();
    try {
      _model = await FlutterGemma.getActiveModel(
        maxTokens: GemmaModelSpec.contextTokens,
        preferredBackend: backend,
        enableSpeculativeDecoding: speculativeDecoding,
      );
      loadMs = sw.elapsedMilliseconds;
      activeBackend = _model!.activeBackend;
      phase = ModelPhase.ready;
    } catch (e) {
      _fail(e);
      return;
    }
    notifyListeners();
  }

  Future<void> unload() async {
    await _chat?.close().catchError((_) {});
    _chat = null;
    final m = _model;
    _model = null;
    activeBackend = null;
    if (m != null) {
      await m.close().catchError((_) {});
      phase = ModelPhase.installed;
      notifyListeners();
    }
  }

  Future<BenchResult?> run({
    required String prompt,
    required bool thinking,
    required int maxOutputTokens,
  }) async {
    final loaded = _model;
    if (loaded == null || isGenerating) return null;

    _stopRequested = false;
    final run = live = LiveRun(thinking: thinking);
    final usage = _liveUsage = UsageWindow(rails: monitor.rails);
    notifyListeners();

    String? err;
    SessionMetrics? metrics;
    try {
      // Fresh chat per run so every measurement starts from an empty context.
      final chat = _chat = await loaded.createChat(
        modelType: ModelType.gemma4,
        isThinking: thinking,
        temperature: 0.7,
        topK: 40,
        randomSeed: 42,
        maxOutputTokens: maxOutputTokens,
      );
      run.stopwatch.reset();
      await chat.addQueryChunk(Message(text: prompt, isUser: true));
      await for (final r in chat.generateChatResponseAsync()) {
        final t = run.stopwatch.elapsedMilliseconds;
        switch (r) {
          case ThinkingResponse(:final content):
            run.firstTokenMs ??= t;
            run.thinkingText.write(content);
          case TextResponse(:final token):
            run.firstTokenMs ??= t;
            if (token.isNotEmpty) run.firstAnswerTokenMs ??= t;
            run.answer.write(token);
          case FunctionCallResponse() || ParallelFunctionCallResponse():
            break;
        }
        run.chunks++;
        notifyListeners();
        if (_stopRequested) break;
      }
      try {
        metrics = chat.session.getSessionMetrics();
      } catch (_) {}
    } catch (e) {
      err = e.toString();
    } finally {
      run.stopwatch.stop();
      usage.finish();
      await _chat?.close().catchError((_) {});
      _chat = null;
    }

    final result = BenchResult(
      index: results.length + 1,
      model: model,
      prompt: prompt,
      thinking: thinking,
      requestedBackend: requestedBackend,
      activeBackend: activeBackend,
      speculative: speculativeDecoding,
      thinkingText: run.thinkingText.toString().trim(),
      answer: run.answer.toString().trim(),
      firstTokenMs: run.firstTokenMs,
      firstAnswerTokenMs: run.firstAnswerTokenMs,
      totalMs: run.stopwatch.elapsedMilliseconds,
      metrics: metrics,
      usage: usage,
      stopped: _stopRequested,
      error: err,
    );
    results.insert(0, result);
    live = null;
    _liveUsage = null;
    notifyListeners();
    return result;
  }

  Future<void> stop() async {
    _stopRequested = true;
    await _chat?.stopGeneration().catchError((_) {});
  }

  void clearResults() {
    results.clear();
    notifyListeners();
  }

  void _onSample() {
    final s = monitor.latest;
    if (s != null) _liveUsage?.add(s);
  }

  void _fail(Object e) {
    error = e.toString();
    phase = ModelPhase.error;
    debugPrint('GemmaService error: $e');
    notifyListeners();
  }

  @override
  void dispose() {
    monitor.removeListener(_onSample);
    unload();
    super.dispose();
  }
}
