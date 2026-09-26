import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart' show CancelToken;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../memory/memory.dart';
import '../mock/mock_care_data.dart';

enum ModelStatus { notDownloaded, downloading, downloaded, loading, ready, failed }

/// App-wide state for the memory layer: model install (through
/// flutter_gemma), the loaded Nomic embedder, and the on-disk care memory.
/// Shared by every tab.
class MemoryController extends ChangeNotifier {
  MemoryController._(this.dbPath, this.benchDir, bool installed)
    : status = installed ? ModelStatus.downloaded : ModelStatus.notDownloaded;

  static Future<MemoryController> create() async {
    final support = await getApplicationSupportDirectory();
    final ext = Platform.isAndroid ? await getExternalStorageDirectory() : null;
    return MemoryController._(
      p.join(support.path, 'care_memory.db'),
      // App-specific external dir, so reports can be pulled with adb.
      p.join((ext ?? support).path, 'bench'),
      await NomicModel.isInstalled(),
    );
  }

  final String dbPath;
  final String benchDir;
  final config = const MemoryConfig();

  ModelStatus status;
  int progress = 0;
  String? error;
  NomicModelPaths? paths;
  NomicEmbedder? embedder;
  CareMemory? memory;

  /// Hardware the embedder runs on; change with [useAccelerator].
  NomicAccelerator accelerator = NomicAccelerator.cpu;

  /// Lowest cosine vs Arm's reference for the loaded embedder (null until
  /// checked); ≥ 0.99 means its vectors are trustworthy.
  double? referenceCosine;

  CancelToken? _cancel;
  Future<CareMemory>? _opening;

  bool get isInstalled =>
      status != ModelStatus.notDownloaded && status != ModelStatus.downloading;

  void _set(VoidCallback f) {
    f();
    notifyListeners();
  }

  /// Downloads model + tokenizer with flutter_gemma's installer.
  Future<void> download() async {
    if (status == ModelStatus.downloading) return;
    final cancel = _cancel = CancelToken();
    _set(() {
      status = ModelStatus.downloading;
      progress = 0;
      error = null;
    });
    try {
      final installed = await NomicModel.install(
        cancelToken: cancel,
        onProgress: (pc) {
          if (pc != progress) _set(() => progress = pc);
        },
      );
      _set(() {
        paths = installed;
        status = ModelStatus.downloaded;
      });
    } catch (e) {
      final installed = await NomicModel.isInstalled();
      _set(() {
        status = installed ? ModelStatus.downloaded : ModelStatus.notDownloaded;
        error = cancel.isCancelled ? null : 'Download failed: $e';
      });
    } finally {
      _cancel = null;
    }
  }

  void cancelDownload() => _cancel?.cancel();

  Future<void> deleteModel() async {
    await _closeAll();
    await NomicModel.uninstall();
    _set(() {
      paths = null;
      status = ModelStatus.notDownloaded;
      progress = 0;
    });
  }

  /// Loads the embedder (once) and opens the care memory on disk.
  Future<CareMemory> ensureMemory() => _opening ??= _open().whenComplete(() => _opening = null);

  Future<CareMemory> _open() async {
    final existing = memory;
    if (existing != null) return existing;
    if (!isInstalled) throw StateError('Download the Nomic model first');
    _set(() {
      status = ModelStatus.loading;
      error = null;
    });
    try {
      // Resolves paths of the installed files; downloads nothing if present.
      final pth = paths ??= await NomicModel.install();
      final e = embedder ??= await NomicEmbedder.load(pth, accelerator: accelerator);
      final m = await CareMemory.open(dbPath: dbPath, embedder: e, config: config);
      _set(() {
        memory = m;
        status = ModelStatus.ready;
      });
      return m;
    } catch (e) {
      _set(() {
        status = ModelStatus.failed;
        error = 'Could not load model on ${accelerator.name.toUpperCase()}: $e';
      });
      rethrow;
    }
  }

  /// Reloads the embedder on [a]. The stored memory stays valid: it is the
  /// same model, so the same embedding space.
  Future<void> useAccelerator(NomicAccelerator a) async {
    if (a == accelerator && embedder != null) return;
    await _closeAll();
    _set(() {
      accelerator = a;
      referenceCosine = null;
    });
    await ensureMemory();
  }

  /// Compares the loaded embedder with Arm's published vectors.
  Future<double> verify() async {
    await ensureMemory();
    final c = await embedder!.referenceCosine(await NomicModel.fetchReference());
    _set(() => referenceCosine = c);
    return c;
  }

  /// Embeds and stores every mock moment. Returns elapsed time.
  Future<Duration> storeMockData() async {
    final m = await ensureMemory();
    final sw = Stopwatch()..start();
    await m.addMoments(mockMoments);
    sw.stop();
    notifyListeners();
    return sw.elapsed;
  }

  /// Call after writing to [memory] directly, so views refresh.
  void memoryChanged() => notifyListeners();

  Future<void> clearMemory() async {
    memory?.store.clear();
    notifyListeners();
  }

  /// Ids of moments currently in the store.
  Set<String> storedIds() => memory?.store.moments().map((m) => m.id).toSet() ?? const {};

  Future<void> _closeAll() async {
    memory?.close();
    memory = null;
    await embedder?.close();
    embedder = null;
  }

  @override
  void dispose() {
    _closeAll();
    super.dispose();
  }
}
