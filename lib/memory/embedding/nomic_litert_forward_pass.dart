// LiteRT forward pass for Arm's nomic-embed-text-v1 INT8 export
// (huggingface.co/Arm/nomic-embed-text-v1-int8-litert).
//
// That graph takes two int64 inputs, input_ids and attention_mask, both
// [1, 128], and returns the pooled, L2-normalized [1, 768] sentence
// embedding. flutter_gemma_litertlm's own embedding forward pass feeds a
// single int32 input (EmbeddingGemma's contract) and refuses multi-input
// graphs, so this pass drives the same LiteRT C API — through
// flutter_gemma_litertlm's bindings and native library — with both inputs.
// Tokenization (WordPiece, [CLS] prefix+text [SEP]) and the background
// isolate stay flutter_gemma's.

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter_gemma/flutter_gemma.dart'
    show EmbeddingForwardPass, EmbeddingOutputContract, ForwardResult;
import 'package:flutter_gemma_litertlm/litert_bindings.dart';

// litert/c/litert_model_types.h: LiteRtElementType mirrors TfLiteType.
const int _kLiteRtElementTypeInt64 = 4;

/// Hardware the LiteRT graph is compiled for.
enum NomicAccelerator {
  /// XNNPACK with KleidiAI int8 kernels.
  cpu,

  /// LiteRT GPU accelerator (OpenCL on Adreno), CPU fallback for ops the GPU
  /// cannot run (e.g. the int64 token lookup). Experimental for this graph.
  gpu,
}

/// Packs accelerator + path into the one string `ForwardPassDescriptor`
/// carries into the worker isolate.
String encodeNomicSpec(String modelPath, NomicAccelerator a) => '${a.name}|$modelPath';

/// Top-level factory for `ForwardPassDescriptor.factory` (must survive
/// `Isolate.spawn`).
EmbeddingForwardPass createNomicLiteRtForwardPass(String spec) {
  final bar = spec.indexOf('|');
  return NomicLiteRtForwardPass(
    spec.substring(bar + 1),
    accelerator: NomicAccelerator.values.byName(spec.substring(0, bar)),
  );
}

class NomicLiteRtForwardPass implements EmbeddingForwardPass {
  NomicLiteRtForwardPass(this.modelPath, {this.accelerator = NomicAccelerator.cpu});

  final String modelPath;
  final NomicAccelerator accelerator;

  LiteRtBindings? _b;
  LiteRtEnvironment? _env;
  LiteRtModel? _model;
  LiteRtOptions? _options;
  LiteRtCompiledModel? _compiled;
  int? _seqLen;
  int? _dim;

  /// Signature input index of input_ids and attention_mask.
  int _idsIndex = 0;
  int _maskIndex = 1;

  /// Signature input names as found in the model, for diagnostics.
  List<String> inputNames = const [];

  bool _disposed = false;

  @override
  int get outputDimension => _dim ?? (throw StateError('load() has not completed'));

  @override
  int? get inputSequenceLength => _seqLen;

  @override
  EmbeddingOutputContract? get outputContract => EmbeddingOutputContract.pooledFinal;

  @override
  Future<void> load() async {
    final b = _b = LiteRtBindings.open();
    try {
      final envPtr = calloc<LiteRtEnvironment>();
      try {
        b.createEnvironment(0, nullptr, envPtr).check('LiteRtCreateEnvironment');
        _env = envPtr.value;
      } finally {
        calloc.free(envPtr);
      }

      final pathC = modelPath.toNativeUtf8();
      final modelPtr = calloc<LiteRtModel>();
      try {
        b.createModelFromFile(_env!, pathC, modelPtr).check('LiteRtCreateModelFromFile($modelPath)');
        _model = modelPtr.value;
      } finally {
        calloc.free(pathC);
        calloc.free(modelPtr);
      }

      _resolveInputOrder(b);

      final optsPtr = calloc<LiteRtOptions>();
      try {
        b.createOptions(optsPtr).check('LiteRtCreateOptions');
        _options = optsPtr.value;
      } finally {
        calloc.free(optsPtr);
      }
      b
          .setOptionsHardwareAccelerators(_options!, switch (accelerator) {
            NomicAccelerator.cpu => kLiteRtHwAcceleratorCpu,
            NomicAccelerator.gpu => kLiteRtHwAcceleratorGpu | kLiteRtHwAcceleratorCpu,
          })
          .check('LiteRtSetOptionsHardwareAccelerators');

      final compiledPtr = calloc<LiteRtCompiledModel>();
      try {
        b
            .createCompiledModel(_env!, _model!, _options!, compiledPtr)
            .check('LiteRtCreateCompiledModel(${accelerator.name})');
        _compiled = compiledPtr.value;
      } finally {
        calloc.free(compiledPtr);
      }

      final inLayout = LiteRtLayoutView.calloc();
      try {
        b
            .getInputTensorLayout(_compiled!, 0, _idsIndex, inLayout.pointer)
            .check('LiteRtGetCompiledModelInputTensorLayout');
        _seqLen = inLayout.dimension(inLayout.rank - 1);
      } finally {
        inLayout.free();
      }
      final outLayout = LiteRtLayoutView.calloc();
      try {
        b
            .getOutputTensorLayouts(_compiled!, 0, 1, outLayout.pointer, false)
            .check('LiteRtGetCompiledModelOutputTensorLayouts');
        _dim = outLayout.dimension(outLayout.rank - 1);
      } finally {
        outLayout.free();
      }
    } catch (_) {
      await close();
      rethrow;
    }
  }

  /// Maps the two signature inputs by name; defaults to (ids, mask), the
  /// order of Arm's config.yaml and example.py.
  void _resolveInputOrder(LiteRtBindings b) {
    final sigPtr = calloc<LiteRtSignature>();
    final countPtr = calloc<Size>();
    final namePtr = calloc<Pointer<Utf8>>();
    try {
      b.getModelSignature(_model!, 0, sigPtr).check('LiteRtGetModelSignature');
      b.getNumSignatureInputs(sigPtr.value, countPtr).check('LiteRtGetNumSignatureInputs');
      final n = countPtr.value;
      if (n != 2) {
        throw StateError(
          'Expected the Arm nomic-embed-text-v1 LiteRT graph with 2 inputs '
          '(input_ids, attention_mask); "$modelPath" has $n.',
        );
      }
      final names = <String>[];
      for (var i = 0; i < n; i++) {
        final ok = b.getSignatureInputName(sigPtr.value, i, namePtr) == 0 && namePtr.value != nullptr;
        names.add(ok ? namePtr.value.toDartString() : '#$i');
      }
      inputNames = names;
      final mask = names.indexWhere((s) => s.toLowerCase().contains('mask'));
      if (mask != -1) {
        _maskIndex = mask;
        _idsIndex = 1 - mask;
      }
    } finally {
      calloc.free(sigPtr);
      calloc.free(countPtr);
      calloc.free(namePtr);
    }
  }

  @override
  Future<ForwardResult> run({
    required List<int> tokenIds,
    List<int>? attentionMask,
    List<int>? tokenTypeIds,
  }) async {
    if (_disposed || _compiled == null) throw StateError('forward pass is not loaded');
    return ForwardResult(values: _forward(tokenIds), shape: [1, _dim!]);
  }

  List<double> _forward(List<int> tokens) {
    final b = _b!;
    final seq = _seqLen!;
    final dim = _dim!;

    // [CLS] … [SEP] from the tokenizer. Over-long input keeps [CLS], the
    // first seq-2 word pieces and the closing [SEP].
    final ids = tokens.length <= seq
        ? tokens
        : [...tokens.sublist(0, seq - 1), tokens.last];
    final used = ids.length;

    AlignedAlloc? idsAlloc, maskAlloc;
    final outType = LiteRtRankedTensorTypeView.calloc()
      ..elementType = kLiteRtElementTypeFloat32
      ..rank = 2
      ..setDimension(0, 1)
      ..setDimension(1, dim);
    final outAlloc = allocAligned(dim * 4);
    final inBufs = calloc<LiteRtTensorBuffer>(2);
    final outBuf = calloc<LiteRtTensorBuffer>();
    final inCreated = [false, false];
    var outCreated = false;
    final types = <LiteRtRankedTensorTypeView>[];
    try {
      idsAlloc = allocAligned(seq * 8);
      maskAlloc = allocAligned(seq * 8);
      final idsHost = idsAlloc.aligned.cast<Int64>();
      final maskHost = maskAlloc.aligned.cast<Int64>();
      for (var i = 0; i < seq; i++) {
        idsHost[i] = i < used ? ids[i] : 0; // [PAD] = 0
        maskHost[i] = i < used ? 1 : 0;
      }

      for (final (slot, alloc) in [(_idsIndex, idsAlloc), (_maskIndex, maskAlloc)]) {
        final type = LiteRtRankedTensorTypeView.calloc()
          ..elementType = _kLiteRtElementTypeInt64
          ..rank = 2
          ..setDimension(0, 1)
          ..setDimension(1, seq);
        types.add(type);
        b
            .createTensorBufferFromHostMemory(type.pointer, alloc.aligned.cast(), seq * 8, nullptr, inBufs + slot)
            .check('CreateTensorBufferFromHostMemory(input $slot)');
        inCreated[slot] = true;
      }
      b
          .createTensorBufferFromHostMemory(outType.pointer, outAlloc.aligned.cast(), dim * 4, nullptr, outBuf)
          .check('CreateTensorBufferFromHostMemory(output)');
      outCreated = true;

      b.runCompiledModel(_compiled!, 0, 2, inBufs, 1, outBuf).check('LiteRtRunCompiledModel');

      final locked = calloc<Pointer<Void>>();
      try {
        b.lockTensorBuffer(outBuf.value, locked, kLiteRtTensorBufferLockModeRead).check('LiteRtLockTensorBuffer');
        final out = locked.value.cast<Float>();
        final result = List<double>.generate(dim, (i) => out[i]);
        b.unlockTensorBuffer(outBuf.value);
        return result;
      } finally {
        calloc.free(locked);
      }
    } finally {
      for (var i = 0; i < 2; i++) {
        if (inCreated[i]) b.destroyTensorBuffer((inBufs + i).value);
      }
      if (outCreated) b.destroyTensorBuffer(outBuf.value);
      calloc.free(inBufs);
      calloc.free(outBuf);
      if (idsAlloc != null) calloc.free(idsAlloc.raw);
      if (maskAlloc != null) calloc.free(maskAlloc.raw);
      calloc.free(outAlloc.raw);
      for (final t in types) {
        t.free();
      }
      outType.free();
    }
  }

  @override
  Future<void> close() async {
    if (_disposed) return;
    _disposed = true;
    final b = _b;
    if (b == null) return;
    if (_compiled != null) b.destroyCompiledModel(_compiled!);
    if (_options != null) b.destroyOptions(_options!);
    if (_model != null) b.destroyModel(_model!);
    if (_env != null) b.destroyEnvironment(_env!);
  }
}
