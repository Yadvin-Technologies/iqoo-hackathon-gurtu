import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Where visit photos and voice notes live: a private folder in the app's
/// own storage on this phone. They never appear in the gallery and never
/// leave the device. Records keep only the file name (`VisitAttachment.file`).
///
/// Behind an interface so tests (and the web preview, which has no file
/// system) can replace it.
abstract class AttachmentStore {
  /// Replaced in tests.
  static AttachmentStore instance = DeviceAttachmentStore();

  /// False where files can't be kept (web).
  bool get available;

  /// Finds the folder. Call once at start-up, before [pathOf].
  Future<void> init();

  /// Full path of a kept file.
  String pathOf(String file);

  /// Copies a photo just taken or picked into the folder; returns its name.
  Future<String> keep(String sourcePath);

  /// A name and full path for a new file the caller writes itself, such as
  /// a recording.
  ({String file, String path}) create(String extension);

  Future<void> delete(String file);

  /// Removes every file not in [inUse]: left behind by a visit that was
  /// never saved, or by the app closing mid-way.
  Future<void> prune(Set<String> inUse);
}

class DeviceAttachmentStore implements AttachmentStore {
  Directory? _dir;
  var _n = 0;

  @override
  bool get available => !kIsWeb && _dir != null;

  @override
  Future<void> init() async {
    if (kIsWeb) return;
    try {
      final docs = await getApplicationDocumentsDirectory();
      _dir = await Directory('${docs.path}/visit_files')
          .create(recursive: true);
    } on Exception catch (e) {
      debugPrint('Attachment folder unavailable: $e');
    }
  }

  @override
  String pathOf(String file) => '${_dir!.path}/$file';

  String _name(String extension) =>
      'a_${DateTime.now().microsecondsSinceEpoch}_${_n++}.$extension';

  @override
  Future<String> keep(String sourcePath) async {
    final dot = sourcePath.lastIndexOf('.');
    final ext = dot < 0 ? 'jpg' : sourcePath.substring(dot + 1).toLowerCase();
    final file = _name(ext);
    await File(sourcePath).copy(pathOf(file));
    return file;
  }

  @override
  ({String file, String path}) create(String extension) {
    final file = _name(extension);
    return (file: file, path: pathOf(file));
  }

  @override
  Future<void> delete(String file) async {
    if (_dir == null) return;
    try {
      await File(pathOf(file)).delete();
    } on FileSystemException {
      // Already gone.
    }
  }

  @override
  Future<void> prune(Set<String> inUse) async {
    final dir = _dir;
    if (dir == null) return;
    try {
      await for (final f in dir.list()) {
        final name = f.uri.pathSegments.last;
        if (f is File && !inUse.contains(name)) await f.delete();
      }
    } on FileSystemException catch (e) {
      debugPrint('Attachment clean-up: $e');
    }
  }
}
