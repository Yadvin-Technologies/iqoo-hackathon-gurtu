import 'package:flutter/services.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

/// What the phone reports about itself (see MainActivity.kt).
class DeviceProfile {
  const DeviceProfile({
    this.socModel = '',
    this.board = '',
    this.model = '',
    this.sdkInt = 0,
    this.totalRamMb = 0,
    this.freeStorageMb = 0,
  });

  /// e.g. "SM8750". Empty before Android 12.
  final String socModel;

  /// Qualcomm platform code name, e.g. "sun", "canoe".
  final String board;
  final String model;
  final int sdkInt;
  final int totalRamMb;
  final int freeStorageMb;

  static const _channel = MethodChannel('gurtu/device');

  static Future<DeviceProfile> read() async {
    try {
      final m = await _channel.invokeMapMethod<String, Object?>('info') ?? {};
      return DeviceProfile(
        socModel: (m['socModel'] as String? ?? '').toUpperCase(),
        board: (m['board'] as String? ?? '').toLowerCase(),
        model: m['model'] as String? ?? '',
        sdkInt: m['sdkInt'] as int? ?? 0,
        totalRamMb: m['totalRamMb'] as int? ?? 0,
        freeStorageMb: m['freeStorageMb'] as int? ?? 0,
      );
    } on Object {
      return const DeviceProfile();
    }
  }

  static Future<bool> isUnmetered() async {
    try {
      return await _channel.invokeMethod<bool>('isUnmetered') ?? false;
    } on Object {
      // If the phone can't tell us, don't block the download.
      return true;
    }
  }
}

/// One downloadable build of Gurtu's care model.
///
/// NPU builds are compiled ahead of time for one chip, so they are matched
/// to the phone by SoC; every other phone gets the portable build on its GPU.
class ModelBuild {
  const ModelBuild({
    required this.fileName,
    required this.sizeMb,
    required this.backend,
    this.socModels = const {},
    this.boards = const {},
  });

  final String fileName;
  final int sizeMb;
  final PreferredBackend backend;

  /// Chips this build is compiled for. Empty = runs anywhere.
  final Set<String> socModels;
  final Set<String> boards;

  bool get isNpu => backend == PreferredBackend.npu;

  /// Pinned to a commit so every install gets the exact same weights.
  String get url => '$_repo/resolve/$_revision/$fileName';

  bool fits(DeviceProfile d) =>
      socModels.contains(d.socModel) || boards.contains(d.board);
}

const _repo =
    'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm';
const _revision = 'b3ca0d2f076785a8f4b2219ddbd2bdb99954eae1';

/// Display name; kept in English on purpose.
const careModelName = 'Gemma 4 · E2B';

/// Chip-specific NPU builds, checked in order. To support another chip's NPU
/// (e.g. the iQOO 15's SM8850), add its compiled `.litertlm` here.
const _npuBuilds = [
  ModelBuild(
    fileName: 'gemma-4-E2B-it_qualcomm_sm8750.litertlm',
    sizeMb: 3017,
    backend: PreferredBackend.npu,
    socModels: {'SM8750'},
    boards: {'sun'},
  ),
];

const _portableBuild = ModelBuild(
  fileName: 'gemma-4-E2B-it.litertlm',
  sizeMb: 2589,
  backend: PreferredBackend.gpu,
);

ModelBuild buildFor(DeviceProfile device) =>
    _npuBuilds.where((b) => b.fits(device)).firstOrNull ?? _portableBuild;

/// Below this the model loads slowly or gets killed for memory.
const minRamMb = 5500;
