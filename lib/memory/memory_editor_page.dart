import 'dart:async';
import 'dart:convert';
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
import 'document_reader.dart';
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

/// How Gurtu AI reads a saved document.
String documentSummarySystem(AppLanguage language) =>
    'You read a medical document an Indian family saved: a test report, '
    'prescription, discharge summary, bill or letter. Its text was read '
    'from a photo or file and may have small reading mistakes.\n'
    'Reply with only this JSON and nothing else:\n'
    '{"title": "...", "summary": "..."}\n'
    '- title: what the document is, at most 6 words, e.g. "Blood sugar '
    'report, March 2026".\n'
    '- summary: 2 to 4 short sentences on what matters in it: the key '
    'results with their values and whether the document marks them high '
    'or low, diagnoses and medicines exactly as written, advice, dates '
    'and next steps.\n'
    '- Use only what is written. Never add your own interpretation, '
    'diagnosis or advice, and never invent a value.\n'
    '- Write both in ${language.englishName}, simply, without markdown.';

/// The title and summary in Gurtu AI's reply, or null when unusable.
({String title, String summary})? parseDocumentSummary(String reply) {
  final start = reply.indexOf('{');
  final end = reply.lastIndexOf('}');
  if (start < 0 || end <= start) return null;
  try {
    final j = jsonDecode(reply.substring(start, end + 1));
    if (j is! Map) return null;
    String clean(Object? v, int max) {
      final t = (v is String ? v : '')
          .replaceAll(RegExp(r'[*#_`]+'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      return t.length > max ? '${t.substring(0, max - 1)}…' : t;
    }

    final summary = clean(j['summary'], 700);
    if (summary.length < 10) return null;
    return (title: clean(j['title'], 70), summary: summary);
  } on FormatException {
    return null;
  }
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
    this.pickDocument = false,
    this.sharedPaths = const [],
    this.sharedText = '',
  });

  final CareMoment? editing;

  /// Opens the camera straight away.
  final bool scan;

  /// Opens the phone's file picker straight away (PDF, Word, text).
  final bool pickDocument;

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

  /// Gurtu AI's summary of what the document says (streams in).
  late String _summary = widget.editing?.summary ?? '';
  bool _summarising = false;

  /// The text last summarised, so the same words aren't read twice.
  String? _summarisedText;
  int _summaryRun = 0;

  @override
  void initState() {
    super.initState();
    _titleTyped = _title.text.isNotEmpty;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final p in widget.sharedPaths) {
        await _addFile(p);
      }
      if (widget.scan) await _pick(fromGallery: false);
      if (widget.pickDocument) await _pickDocuments();
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

  Future<void> _pickDocuments() async {
    for (final path in await DocumentReader.instance.pick()) {
      if (!mounted) return;
      await _addFile(path);
    }
  }

  /// Keeps the file with the memory and reads the words in it: a photo's
  /// printed text, a PDF page by page, a Word or text file.
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
      final kind = documentKind(file);
      if (kind != DocumentKind.image && !_titleTyped && _title.text.isEmpty) {
        // A document's own name is a good first title.
        _title.text = _niceName(path);
      }
      final printed = kind == DocumentKind.image
          ? (await PhotoTextReader.instance.read(store.pathOf(file))).trim()
          : await DocumentReader.instance.read(store.pathOf(file));
      if (!mounted) return;
      if (printed.isNotEmpty) {
        final before = _text.text.trim();
        _text.text = before.isEmpty ? printed : '$before\n\n$printed';
      } else if (kind != DocumentKind.image) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(context.l10n.documentNoText)));
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

  /// A short title from the text (the first line), then Gurtu AI's own
  /// title and a summary of what matters, written as it reads. Never over a
  /// title the family typed.
  void _suggestTitle() {
    if (!mounted || _reading > 0) return;
    final text = _text.text.trim();
    if (text.isEmpty) return;
    if (!_titleTyped && _title.text.isEmpty) {
      final first = text
          .split('\n')
          .map((s) => s.trim())
          .firstWhere((s) => s.length >= 3, orElse: () => '');
      _title.text = first.length > 60 ? '${first.substring(0, 57)}…' : first;
    }
    _summarise(text);
  }

  static final _summaryField = RegExp(r'"summary"\s*:\s*"((?:[^"\\]|\\.)*)');

  Future<void> _summarise(String text) async {
    final ai = AiScope.read(context);
    if (!ai.isReady || text == _summarisedText) return;
    _summarisedText = text;
    final run = ++_summaryRun;
    final language = LanguageScope.of(context).value;
    setState(() {
      _summarising = true;
      _summary = '';
    });
    try {
      final reply = await ai.generate(
        system: documentSummarySystem(language),
        prompt: text.length > 3000 ? '${text.substring(0, 3000)}…' : text,
        maxOutputTokens: 320,
        timeout: const Duration(seconds: 90),
        onPartial: (partial) {
          final m = _summaryField.firstMatch(partial);
          if (m == null || !mounted || run != _summaryRun) return;
          setState(() => _summary = _unescape(m[1]!));
        },
      );
      if (!mounted || run != _summaryRun) return;
      final parsed = parseDocumentSummary(reply);
      setState(() {
        if (parsed != null) {
          _summary = parsed.summary;
          if (!_titleTyped && parsed.title.isNotEmpty) {
            _title.text = parsed.title;
          }
        }
      });
    } on Object catch (e) {
      debugPrint('Gurtu AI summary: $e');
    } finally {
      if (mounted && run == _summaryRun) setState(() => _summarising = false);
    }
  }

  static String _unescape(String s) => s
      .replaceAll(r'\n', ' ')
      .replaceAll(r'\"', '"')
      .replaceAll(RegExp(r'\\$'), '')
      .trim();

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
          summary: _summary.trim(),
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
        summary: _summarising ? '' : _summary,
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
        if (_summarising || _summary.isNotEmpty) ...[
          _SummaryCard(
            summary: _summary,
            writing: _summarising,
            onRemove: () => setState(() {
              _summaryRun++;
              _summarising = false;
              _summary = '';
            }),
          ),
          const SizedBox(height: 16),
        ],
        if (DocumentReader.instance.available) ...[
          GurtuButton(
            label: l.addDocument,
            style: GurtuButtonStyle.ghost,
            icon: Icons.upload_file_rounded,
            onPressed: _reading > 0 ? null : _pickDocuments,
          ),
          const SizedBox(height: 10),
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

/// What Gurtu AI understood from the document, as it writes it.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.summary,
    required this.writing,
    required this.onRemove,
  });

  final String summary;
  final bool writing;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return GurtuCard(
      color: GurtuColors.primarySoft,
      borderColor: GurtuColors.primarySoft,
      padding: const EdgeInsets.fromLTRB(16, 12, 6, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: GurtuColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(l.aiSummary, style: t.titleSmall)),
              if (writing)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: GurtuColors.primary,
                    ),
                  ),
                )
              else
                IconButton(
                  tooltip: l.remove,
                  visualDensity: VisualDensity.compact,
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              summary.isEmpty
                  ? l.summarising
                  : (writing ? '$summary ▍' : summary),
              style: t.bodyLarge?.copyWith(
                color: summary.isEmpty
                    ? GurtuColors.textMuted
                    : GurtuColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
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
