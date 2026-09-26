import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model_catalog.dart';

enum AiStatus {
  /// Reading the device and what is already installed.
  checking,

  /// Not an Android phone with enough memory; features use the offline rules.
  unsupported,
  notInstalled,

  /// Asked to install, holding off until the phone is on Wi-Fi.
  waitingForWifi,
  downloading,
  installed,
  failed,
}

enum AiFailure { noSpace, network }

/// Gurtu's own AI: a Gemma model downloaded once and run entirely on the
/// phone (NPU where a build exists for the chip, otherwise GPU). Nothing the
/// patient says is sent anywhere.
///
/// The download is owned here rather than by a screen, so it keeps going
/// while the person finishes onboarding or uses the app, and resumes on the
/// next launch if the app was closed.
class GurtuAi extends ChangeNotifier with WidgetsBindingObserver {
  GurtuAi(this._prefs) : wifiOnly = _prefs.getBool(_wifiKey) ?? true;

  static const _wantKey = 'ai_install_requested';
  static const _wifiKey = 'ai_wifi_only';

  final SharedPreferences _prefs;

  AiStatus status = AiStatus.checking;
  AiFailure? failure;

  /// 0–1 while downloading.
  double progress = 0;
  bool wifiOnly;
  DeviceProfile device = const DeviceProfile();
  ModelBuild? build;

  /// What the model actually loaded on, once it has been used.
  PreferredBackend? activeBackend;

  InferenceModel? _model;
  CancelToken? _cancel;
  Timer? _wifiRetry;
  Future<void> _queue = Future.value();

  bool get isReady => status == AiStatus.installed;
  bool get isBusyInstalling =>
      status == AiStatus.downloading || status == AiStatus.waitingForWifi;
  bool get _wantsInstall => _prefs.getBool(_wantKey) ?? false;

  /// The accelerator Gurtu will use: known after first load, planned before.
  PreferredBackend? get backend => activeBackend ?? build?.backend;

  int get sizeMb => build?.sizeMb ?? 0;

  Future<void> init() async {
    // The real OS, not defaultTargetPlatform (which tests set to Android).
    if (kIsWeb || !Platform.isAndroid) {
      return _set(AiStatus.unsupported);
    }
    device = await DeviceProfile.read();
    if ((device.sdkInt > 0 && device.sdkInt < 30) ||
        (device.totalRamMb > 0 && device.totalRamMb < minRamMb)) {
      return _set(AiStatus.unsupported);
    }
    build = buildFor(device);
    WidgetsBinding.instance.addObserver(this);
    try {
      await FlutterGemma.initialize(inferenceEngines: [LiteRtLmEngine()]);
      final installed = await FlutterGemma.isModelInstalled(build!.fileName);
      _set(installed ? AiStatus.installed : AiStatus.notInstalled);
    } on Object catch (e) {
      debugPrint('Gurtu AI init failed: $e');
      return _set(AiStatus.unsupported);
    }
    // Picks up a download that was interrupted by closing the app.
    if (status == AiStatus.notInstalled && _wantsInstall) unawaited(install());
  }

  void setWifiOnly(bool value) {
    wifiOnly = value;
    _prefs.setBool(_wifiKey, value);
    notifyListeners();
    if (!value && status == AiStatus.waitingForWifi) install();
  }

  /// Downloads and installs the model. Safe to call again: an installed model
  /// is not downloaded twice.
  Future<void> install({bool useMobileData = false}) async {
    final build = this.build;
    if (build == null ||
        status == AiStatus.downloading ||
        status == AiStatus.installed ||
        status == AiStatus.unsupported ||
        status == AiStatus.checking) {
      return;
    }
    _prefs.setBool(_wantKey, true);
    _wifiRetry?.cancel();

    if (wifiOnly && !useMobileData && !await DeviceProfile.isUnmetered()) {
      _set(AiStatus.waitingForWifi);
      _wifiRetry = Timer(const Duration(seconds: 20), install);
      return;
    }

    device = await DeviceProfile.read();
    if (device.freeStorageMb > 0 && device.freeStorageMb < build.sizeMb + 500) {
      failure = AiFailure.noSpace;
      return _set(AiStatus.failed);
    }

    final cancel = _cancel = CancelToken();
    progress = 0;
    failure = null;
    _set(AiStatus.downloading);
    try {
      await _installer
          .fromNetwork(build.url, foreground: true)
          .withProgress((percent) {
            progress = percent / 100;
            notifyListeners();
          })
          .withCancelToken(cancel)
          .install();
      progress = 1;
      _set(AiStatus.installed);
    } on Object catch (e) {
      if (CancelToken.isCancel(e)) {
        _prefs.setBool(_wantKey, false);
        return _set(AiStatus.notInstalled);
      }
      debugPrint('Gurtu AI download failed: $e');
      failure = AiFailure.network;
      _set(AiStatus.failed);
    } finally {
      if (identical(_cancel, cancel)) _cancel = null;
    }
  }

  void cancelInstall() {
    _wifiRetry?.cancel();
    _prefs.setBool(_wantKey, false);
    if (status == AiStatus.downloading) {
      _cancel?.cancel('Cancelled by user');
    } else if (status == AiStatus.waitingForWifi) {
      _set(AiStatus.notInstalled);
    }
  }

  /// Frees the storage. Features fall back to the offline rules.
  Future<void> remove() async {
    final build = this.build;
    if (build == null) return;
    await _run(() async {
      await _model?.close();
      _model = null;
      activeBackend = null;
      try {
        await FlutterGemma.uninstallModel(build.fileName);
      } on Object catch (e) {
        debugPrint('Gurtu AI uninstall: $e');
      }
    });
    _prefs.setBool(_wantKey, false);
    _set(AiStatus.notInstalled);
  }

  /// Loads the model ahead of time so the first answer is quick.
  void warmUp() {
    if (!isReady || _model != null) return;
    unawaited(_run(_load).then((_) {}, onError: (_) {}));
  }

  /// One prompt, one answer. Calls are queued: the model runs one
  /// conversation at a time. Throws if the model is not installed or the
  /// answer takes longer than [timeout].
  Future<String> generate({
    required String system,
    required String prompt,
    int maxOutputTokens = 512,
    Duration timeout = const Duration(seconds: 60),
  }) {
    if (!isReady) return Future.error(StateError('Gurtu AI is not installed'));
    return _run(() async {
      final model = await _load();
      // Low temperature: these answers should be steady and factual, not
      // creative. The first session's sampler sticks on .litertlm, so every
      // session uses the same settings.
      final session = await model.createSession(
        temperature: 0.2,
        topK: 20,
        topP: 0.9,
        randomSeed: 7,
        systemInstruction: system,
        maxOutputTokens: maxOutputTokens,
      );
      try {
        await session.addQueryChunk(Message(text: prompt, isUser: true));
        return await session.getResponse().timeout(
          timeout,
          onTimeout: () async {
            await session.stopGeneration();
            throw TimeoutException('Gurtu AI took too long', timeout);
          },
        );
      } finally {
        await session.close();
      }
    });
  }

  Future<InferenceModel> _load() async {
    if (_model case final model?) return model;
    final build = this.build!;
    // Registers the downloaded file as the active model; no download happens
    // when it is already on disk.
    await _installer.fromNetwork(build.url).install();
    InferenceModel model;
    try {
      // Room for the question lists plus the answer.
      model = await FlutterGemma.getActiveModel(
        maxTokens: 4096,
        preferredBackend: build.backend,
      );
    } on Object catch (e) {
      // An accelerator that refuses to load shouldn't take the feature down.
      debugPrint('Gurtu AI: ${build.backend.name} load failed ($e), retrying');
      model = await FlutterGemma.getActiveModel(maxTokens: 4096);
    }
    activeBackend = model.activeBackend;
    notifyListeners();
    return _model = model;
  }

  InferenceInstallationBuilder get _installer => FlutterGemma.installModel(
    modelType: ModelType.gemma4,
    fileType: ModelFileType.litertlm,
  );

  Future<T> _run<T>(Future<T> Function() task) {
    final result = _queue.then((_) => task());
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

  void _set(AiStatus s) {
    status = s;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        status == AiStatus.waitingForWifi) {
      install();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _wifiRetry?.cancel();
    _model?.close();
    super.dispose();
  }
}

class AiScope extends InheritedNotifier<GurtuAi> {
  const AiScope({super.key, required GurtuAi ai, required super.child})
    : super(notifier: ai);

  static GurtuAi of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AiScope>()!.notifier!;

  /// For callbacks: reads without rebuilding on every progress tick.
  static GurtuAi read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AiScope>()!.notifier!;
}
