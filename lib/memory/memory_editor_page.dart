import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../ai/medicine_check.dart';
import '../ai/on_device_ai.dart';
import '../data/attachment_store.dart';
import '../data/care_models.dart';
import '../data/care_repository.dart';
import '../l10n/language.dart';
import '../reminders/medicine_plan.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import '../widgets/voice_input.dart';
import 'memory_detail_page.dart';

/// Takes a photo of a page, or picks one. Behind an interface so tests run
/// without a camera.
abstract class DocumentCamera {
  static DocumentCamera instance = DeviceDocumentCamera();

  bool get available;

  /// The photo's path, or null when cancelled.
  Future<String?> pick({required bool fromGallery});
}

class DeviceDocumentCamera implements DocumentCamera {
  final _picker = ImagePicker();

  @override
  bool get available =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<String?> pick({required bool fromGallery}) async {
    final photo = await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      maxWidth: 2200,
      imageQuality: 88,
    );
    return photo?.path;
  }
}

bool isImageFile(String name) {
  final lower = name.toLowerCase();
  return lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.png') ||
      lower.endsWith('.webp') ||
      lower.endsWith('.heic');
}

/// Saves a report, prescription, bill or any page to the person's care
/// memory: photographed (Scan), shared from another app, or typed. The
/// printed text is read on the phone, so it can be searched and Ask Gurtu
/// can answer from it. Also edits a saved one ([editing]).
class MemoryEditorPage extends StatefulWidget {
  const MemoryEditorPage({
    super.key,
    this.editing,
    this.scan = false,
    this.sharedPaths = const [],
    this.sharedText = '',
  });

  final CareMoment? editing;

  /// Opens the camera straight away.
  final bool scan;

  /// Files shared to Gurtu from another app (copied in on open).
  final List<String> sharedPaths;
  final String sharedText;

  @override
  State<MemoryEditorPage> createState() => _MemoryEditorPageState();
}

class _MemoryEditorPageState extends State<MemoryEditorPage> {
  late final _title = TextEditingController(text: widget.editing?.title ?? '');
  late final _text = TextEditingController(
    text: widget.editing?.detail ?? widget.sharedText.trim(),
  );
  late final List<String> _files = [...?widget.editing?.files];

  /// Files added on this screen: deleted again if it is left unsaved.
  final _added = <String>{};
  int _reading = 0;
  bool _saved = false;
  bool _titleTyped = false;

  @override
  void initState() {
    super.initState();
    _titleTyped = _title.text.isNotEmpty;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final p in widget.sharedPaths) {
        await _addFile(p);
      }
      if (widget.scan) await _pick(fromGallery: false);
      _suggestTitle();
    });
  }

  @override
  void dispose() {
    if (!_saved) {
      for (final f in _added) {
        AttachmentStore.instance.delete(f);
      }
    }
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  Future<void> _pick({required bool fromGallery}) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    try {
      final path = await DocumentCamera.instance.pick(fromGallery: fromGallery);
      if (path != null) await _addFile(path);
    } on Object catch (e) {
      debugPrint('Taking the photo failed: $e');
      messenger.showSnackBar(SnackBar(content: Text(l.scanFailed)));
    }
  }

  /// Keeps the file with the memory and, for a photo, reads its text.
  Future<void> _addFile(String path) async {
    final store = AttachmentStore.instance;
    if (!store.available) return;
    setState(() => _reading++);
    try {
      final file = await store.keep(path);
      if (!mounted) {
        await store.delete(file);
        return;
      }
      setState(() {
        _files.add(file);
        _added.add(file);
      });
      if (isImageFile(file)) {
        final printed = (await PhotoTextReader.instance.read(
          store.pathOf(file),
        )).trim();
        if (printed.isNotEmpty && mounted) {
          final before = _text.text.trim();
          _text.text = before.isEmpty ? printed : '$before\n\n$printed';
        }
      } else if (!_titleTyped && _title.text.isEmpty) {
        // A shared PDF: its own name is the best title there is.
        _title.text = _niceName(path);
      }
      HapticFeedback.lightImpact();
    } on Object catch (e) {
      debugPrint('Keeping the file failed: $e');
    } finally {
      if (mounted) setState(() => _reading--);
    }
    _suggestTitle();
  }

  static String _niceName(String path) {
    final name = path.split(RegExp(r'[\\/]')).last;
    final dot = name.lastIndexOf('.');
    return (dot > 0 ? name.substring(0, dot) : name)
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .trim();
  }

  /// A short title from the text: Gurtu AI's when it is installed, the
  /// first line otherwise. Never over one the family typed.
  void _suggestTitle() {
    if (!mounted || _titleTyped || _title.text.isNotEmpty) return;
    final text = _text.text.trim();
    if (text.isEmpty) return;
    final first = text
        .split('\n')
        .map((s) => s.trim())
        .firstWhere((s) => s.length >= 3, orElse: () => '');
    _title.text = first.length > 60 ? '${first.substring(0, 57)}…' : first;
    final ai = AiScope.read(context);
    if (!ai.isReady) return;
    ai
        .generate(
          system:
              'Give a short title (at most 6 words) for this medical '
              'document, in the language it is written in. Reply with the '
              'title only.',
          prompt: text.length > 1500 ? text.substring(0, 1500) : text,
          maxOutputTokens: 24,
          timeout: const Duration(seconds: 30),
        )
        .then((t) {
          final title = t.trim().replaceAll(RegExp('^["\'*#]+|["\'*]+\$'), '');
          if (mounted &&
              !_titleTyped &&
              title.isNotEmpty &&
              title.length < 80) {
            _title.text = title;
          }
        }, onError: (Object _) {});
  }

  void _removeFile(String file) {
    setState(() => _files.remove(file));
    if (_added.remove(file)) AttachmentStore.instance.delete(file);
  }

  bool get _canSave =>
      _reading == 0 &&
      (_files.isNotEmpty ||
          _text.text.trim().isNotEmpty ||
          _title.text.trim().isNotEmpty);

  void _save() {
    final repo = CareScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    final navigator = Navigator.of(context);
    final text = _text.text.trim();
    final editing = widget.editing;
    CareMoment? added;
    if (editing != null) {
      repo.updateMoment(
        editing.copyWith(
          title: _title.text.trim(),
          detail: text,
          files: _files,
        ),
      );
    } else {
      added = repo.addMoment(
        type: _files.isEmpty
            ? MomentType.note
            : widget.scan
            ? MomentType.scan
            : MomentType.document,
        title: _title.text,
        detail: text,
        files: _files,
      );
    }
    _saved = true;
    HapticFeedback.mediumImpact();
    // A prescription: straight to it, where its medicines can be added to
    // the list with one tap.
    if (added != null && medicinesIn(text).isNotEmpty) {
      navigator.pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => MemoryDetailPage(momentId: added!.id),
        ),
      );
    } else {
      navigator.pop();
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.noteSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final camera = DocumentCamera.instance.available;
    return GurtuPage(
      title: widget.editing == null ? l.saveToMemory : l.editMemory,
      subtitle: widget.editing == null ? l.saveToMemoryHint : null,
      bottom: GurtuButton(
        label: l.saveToMemory,
        icon: Icons.check_rounded,
        onPressed: _canSave ? _save : null,
      ),
      children: [
        if (_files.isNotEmpty) ...[
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _files.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) => _FileThumb(
                file: _files[i],
                onRemove: () => _removeFile(_files[i]),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (_reading > 0) ...[
          Row(
            children: [
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: GurtuColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(l.readingDocument, style: t.bodyMedium)),
            ],
          ),
          const SizedBox(height: 14),
        ],
        if (camera) ...[
          GurtuButton(
            label: _files.isEmpty ? l.takePhoto : l.addPage,
            style: GurtuButtonStyle.ghost,
            icon: Icons.photo_camera_rounded,
            onPressed: _reading > 0 ? null : () => _pick(fromGallery: false),
          ),
          const SizedBox(height: 10),
          GurtuButton(
            label: l.chooseFromGallery,
            style: GurtuButtonStyle.ghost,
            icon: Icons.photo_library_rounded,
            onPressed: _reading > 0 ? null : () => _pick(fromGallery: true),
          ),
          const SizedBox(height: 20),
        ],
        FieldLabel(l.memoryTitleLabel, icon: Icons.title_rounded),
        TextField(
          controller: _title,
          maxLength: 80,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: l.memoryTitleHint,
            counterText: '',
          ),
          onChanged: (v) => setState(() => _titleTyped = v.isNotEmpty),
        ),
        const SizedBox(height: 16),
        FieldLabel(l.memoryTextLabel, icon: Icons.notes_rounded),
        DictationField(
          controller: _text,
          hint: l.memoryTextHint,
          minLines: 4,
          maxLines: 14,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        InfoBanner(text: l.memoryPrivate),
      ],
    );
  }
}

/// A photo (or a document's name) kept with a memory.
class _FileThumb extends StatelessWidget {
  const _FileThumb({required this.file, required this.onRemove});

  final String file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = AttachmentStore.instance;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
          child: Container(
            width: 104,
            height: 132,
            color: GurtuColors.surfaceHigh,
            child: isImageFile(file) && store.available
                ? Image.file(
                    File(store.pathOf(file)),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.image_rounded,
                      color: GurtuColors.textMuted,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 36,
                          color: GurtuColors.danger,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          file.split('.').last.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: IconButton.filledTonal(
            visualDensity: VisualDensity.compact,
            tooltip: l.remove,
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, size: 18),
          ),
        ),
      ],
    );
  }
}
