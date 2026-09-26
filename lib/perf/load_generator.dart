import 'package:flutter/foundation.dart';

import '../app/memory_controller.dart';
import '../mock/mock_care_data.dart';

/// Keeps the embedding model busy (continuous `search_document` embeddings
/// of the mock record) so the live meters show the model's real load.
class LoadGenerator extends ChangeNotifier {
  LoadGenerator(this.c);

  final MemoryController c;

  bool _running = false;
  String? error;
  int embedded = 0;
  DateTime? startedAt;

  bool get running => _running;

  Future<void> start() async {
    if (_running) return;
    _running = true;
    error = null;
    embedded = 0;
    startedAt = DateTime.now();
    notifyListeners();
    try {
      await c.ensureMemory();
      final texts = [for (final m in mockMoments.take(8)) m.embeddingText];
      while (_running) {
        final e = c.embedder;
        if (e == null) break;
        await e.embedDocuments(texts);
        embedded += texts.length;
      }
    } catch (err) {
      error = '$err';
    } finally {
      _running = false;
      notifyListeners();
    }
  }

  void stop() {
    _running = false;
    notifyListeners();
  }
}
