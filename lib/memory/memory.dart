/// Gurtu care memory: on-device nomic-embed-text-v1 (LiteRT via
/// flutter_gemma_litertlm) + compact SQLite vector/keyword store.
library;

export 'care_memory.dart';
export 'chunker.dart' show Chunk, Chunker;
export 'embedding/hashing_embedder.dart';
export 'embedding/nomic_embedder.dart';
export 'models.dart';
export 'store/memory_store.dart'
    show MemoryStore, SearchFilter, StoreStats, StoredChunk, StoredMoment;
export 'store/vector_codec.dart';
