import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../data/attachment_store.dart';
import '../../data/visit_models.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_page.dart';
import '../../widgets/gurtu_widgets.dart';
import '../../widgets/voice_input.dart';

/// Photos and voice notes for one part of a visit (a medicine, tests, the
/// next visit), with buttons to add more. Files are kept on this phone by
/// [AttachmentStore]; [onAdd] gets each one once it is safely stored, and
/// [onRemove] is called after the person confirms, to delete it.
class AttachmentTray extends StatelessWidget {
  const AttachmentTray({
    super.key,
    required this.section,
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
    this.itemId,
    this.showHint = true,
  });

  final VisitSection section;

  /// The [VisitMedicine] these belong to.
  final String? itemId;

  /// Explains what to add while there is nothing yet.
  final bool showHint;
  final List<VisitAttachment> attachments;
  final ValueChanged<VisitAttachment> onAdd;
  final ValueChanged<VisitAttachment> onRemove;

  static int _n = 0;

  VisitAttachment _attachment(
    AttachmentKind kind,
    String file, [
    Duration? duration,
  ]) => VisitAttachment(
    id: 'att_${DateTime.now().microsecondsSinceEpoch}_${_n++}',
    kind: kind,
    section: section,
    file: file,
    createdAt: DateTime.now(),
    duration: duration,
    itemId: itemId,
  );

  Future<void> _addPhoto(BuildContext context) async {
    final l = context.l10n;
    final fromGallery = await showGurtuSheet<bool>(
      context,
      (context) => _PhotoSourceSheet(l: l),
    );
    if (fromGallery == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final picker = ImagePicker();
    try {
      final photos = fromGallery
          ? await picker.pickMultiImage(maxWidth: 2400, imageQuality: 85)
          : [
              ?await picker.pickImage(
                source: ImageSource.camera,
                maxWidth: 2400,
                imageQuality: 85,
              ),
            ];
      for (final photo in photos) {
        final file = await AttachmentStore.instance.keep(photo.path);
        onAdd(_attachment(AttachmentKind.photo, file));
      }
      if (photos.isNotEmpty) HapticFeedback.lightImpact();
    } on Exception catch (e) {
      debugPrint('Adding a photo failed: $e');
      messenger.showSnackBar(SnackBar(content: Text(l.attachFailed)));
    }
  }

  Future<void> _recordVoice(BuildContext context) async {
    final note = await showModalBottomSheet<({String file, Duration length})>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      // Only the buttons end a recording, so a stray swipe can't lose it.
      isDismissible: false,
      enableDrag: false,
      backgroundColor: GurtuColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const _RecordSheet(),
    );
    if (note == null) return;
    HapticFeedback.lightImpact();
    onAdd(_attachment(AttachmentKind.audio, note.file, note.length));
  }

  Future<void> _remove(BuildContext context, VisitAttachment a) async {
    final l = context.l10n;
    final ok = await confirmAction(
      context,
      title: l.removeAttachmentTitle,
      body: l.removeAttachmentBody,
      confirm: l.remove,
    );
    if (ok) onRemove(a);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final photos = [
      for (final a in attachments)
        if (a.kind == AttachmentKind.photo) a,
    ];
    final notes = [
      for (final a in attachments)
        if (a.kind == AttachmentKind.audio) a,
    ];
    final canAdd = AttachmentStore.instance.available;
    if (!canAdd && attachments.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canAdd && showHint && attachments.isEmpty) ...[
          Text(switch (section) {
            VisitSection.medicines => l.attachHintMedicines,
            VisitSection.tests => l.attachHintTests,
            VisitSection.nextVisit => l.attachHintNextVisit,
            VisitSection.doctor => l.recordOrListenHint,
          }, style: t.bodyMedium?.copyWith(color: GurtuColors.textMuted)),
          const SizedBox(height: 10),
        ],
        if (photos.isNotEmpty) ...[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final p in photos)
                _Thumbnail(
                  attachment: p,
                  onTap: () async {
                    final remove = await pushPage<bool>(
                      context,
                      _PhotoPage(attachment: p),
                    );
                    if (remove == true && context.mounted) {
                      _remove(context, p);
                    }
                  },
                ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        for (final n in notes) ...[
          VoiceNoteTile(attachment: n, onRemove: () => _remove(context, n)),
          const SizedBox(height: 8),
        ],
        if (canAdd)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _AddButton(
                icon: Icons.add_a_photo_rounded,
                label: l.addPhoto,
                onTap: () => _addPhoto(context),
              ),
              _AddButton(
                icon: Icons.mic_rounded,
                label: l.recordVoiceNote,
                onTap: () => _recordVoice(context),
              ),
            ],
          ),
      ],
    );
  }
}

String _clock(Duration d) =>
    '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: GurtuColors.primary,
        backgroundColor: GurtuColors.primarySoft,
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: GurtuFonts.sans,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _PhotoSourceSheet extends StatelessWidget {
  const _PhotoSourceSheet({required this.l});

  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    Widget option(IconData icon, String label, bool fromGallery) => ListTile(
      onTap: () => Navigator.pop(context, fromGallery),
      minTileHeight: 64,
      leading: IconBadge(icon: icon),
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetGrabber(),
          const SizedBox(height: 12),
          option(Icons.photo_camera_rounded, l.takePhoto, false),
          option(Icons.photo_library_rounded, l.chooseFromGallery, true),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.attachment, required this.onTap});

  final VisitAttachment attachment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.viewPhoto,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
          child: Image.file(
            File(AttachmentStore.instance.pathOf(attachment.file)),
            width: 92,
            height: 92,
            fit: BoxFit.cover,
            cacheWidth: 276,
            errorBuilder: (_, _, _) => Container(
              width: 92,
              height: 92,
              color: GurtuColors.surfaceHigh,
              child: const Icon(
                Icons.broken_image_outlined,
                color: GurtuColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A photo full screen, zoomable to read small print. Pops `true` when the
/// person asks to remove it.
class _PhotoPage extends StatelessWidget {
  const _PhotoPage({required this.attachment});

  final VisitAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(l.remove),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: InteractiveViewer(
        maxScale: 6,
        child: Center(
          child: Image.file(
            File(AttachmentStore.instance.pathOf(attachment.file)),
            errorBuilder: (_, _, _) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}

/// Records one voice note into the attachment folder. Pops the file and its
/// length, or nothing when cancelled (the file is then deleted).
class _RecordSheet extends StatefulWidget {
  const _RecordSheet();

  @override
  State<_RecordSheet> createState() => _RecordSheetState();
}

class _RecordSheetState extends State<_RecordSheet> {
  final _recorder = AudioRecorder();
  final _clockWatch = Stopwatch();
  Timer? _tick;
  String? _file;
  bool _denied = false;
  bool _failed = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      await Mic.claim(this, () => _stop(keep: true));
      if (!await _recorder.hasPermission()) {
        if (mounted) setState(() => _denied = true);
        return;
      }
      final target = AttachmentStore.instance.create('m4a');
      await _recorder.start(
        const RecordConfig(numChannels: 1, bitRate: 64000),
        path: target.path,
      );
      _file = target.file;
      _clockWatch.start();
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
      if (mounted) setState(() {});
    } on Exception catch (e) {
      debugPrint('Recording failed to start: $e');
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _stop({required bool keep}) async {
    if (_done) return;
    _done = true;
    Mic.free(this);
    _tick?.cancel();
    _clockWatch.stop();
    final file = _file;
    final length = _clockWatch.elapsed;
    try {
      await _recorder.stop();
    } on Exception catch (e) {
      debugPrint('Recording failed to stop: $e');
      keep = false;
    }
    // Under a second is a mis-tap, not a note.
    if (file != null && (!keep || length < const Duration(seconds: 1))) {
      await AttachmentStore.instance.delete(file);
    }
    if (!mounted) return;
    Navigator.pop(
      context,
      keep && file != null && length >= const Duration(seconds: 1)
          ? (file: file, length: length)
          : null,
    );
  }

  @override
  void dispose() {
    Mic.free(this);
    _tick?.cancel();
    final file = _file;
    final stopped = _recorder.dispose();
    if (!_done && file != null) {
      // Closed some other way: nothing half-written is left behind.
      stopped.whenComplete(() => AttachmentStore.instance.delete(file));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final recording = _file != null && !_done;

    return PopScope(
      canPop: !recording,
      // Back while recording keeps what was said, like "Stop and save".
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _stop(keep: true);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetGrabber(),
            const SizedBox(height: 24),
            if (_denied || _failed) ...[
              Text(
                _denied ? l.permissionBlocked(l.permMic) : l.voiceUnavailable,
                style: t.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_denied)
                GurtuButton(
                  label: l.settings,
                  icon: Icons.settings_rounded,
                  onPressed: () {
                    openAppSettings();
                    Navigator.pop(context);
                  },
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                child: Text(l.close),
              ),
            ] else ...[
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: GurtuColors.danger.withValues(alpha: 0.12),
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: GurtuColors.danger,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l.recordingNow,
                style: t.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                _clock(_clockWatch.elapsed),
                style: t.headlineMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GurtuButton(
                label: l.stopAndSave,
                icon: Icons.stop_rounded,
                onPressed: recording ? () => _stop(keep: true) : null,
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () =>
                    _file == null ? Navigator.pop(context) : _stop(keep: false),
                style: TextButton.styleFrom(
                  foregroundColor: GurtuColors.textSecondary,
                  minimumSize: const Size(48, 48),
                ),
                child: Text(l.cancel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Plays one voice note or recording, with a delete button. Starting one
/// stops any other that is playing.
class VoiceNoteTile extends StatefulWidget {
  const VoiceNoteTile({
    super.key,
    required this.attachment,
    required this.onRemove,
    this.title,
  });

  final VisitAttachment attachment;
  final VoidCallback onRemove;

  /// Defaults to "Voice note".
  final String? title;

  @override
  State<VoiceNoteTile> createState() => _VoiceNoteState();
}

class _VoiceNoteState extends State<VoiceNoteTile> {
  static AudioPlayer? _playing;

  final _player = AudioPlayer();
  final _subs = <StreamSubscription<Object?>>[];
  var _state = PlayerState.stopped;
  var _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _subs
      ..add(
        _player.onPlayerStateChanged.listen((s) {
          if (mounted) setState(() => _state = s);
        }),
      )
      ..add(
        _player.onPositionChanged.listen((p) {
          if (mounted) setState(() => _position = p);
        }),
      )
      ..add(
        _player.onPlayerComplete.listen((_) {
          if (mounted) setState(() => _position = Duration.zero);
        }),
      );
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    if (identical(_playing, _player)) _playing = null;
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    try {
      if (_state == PlayerState.playing) {
        await _player.pause();
        return;
      }
      if (_playing != null && !identical(_playing, _player)) {
        await _playing!.stop();
      }
      _playing = _player;
      if (_state == PlayerState.paused) {
        await _player.resume();
      } else {
        await _player.play(
          DeviceFileSource(
            AttachmentStore.instance.pathOf(widget.attachment.file),
          ),
        );
      }
    } on Exception catch (e) {
      debugPrint('Playing a voice note failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final playing = _state == PlayerState.playing;
    final length = widget.attachment.duration;
    final showPosition = playing || _state == PlayerState.paused;

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 4, 6),
      decoration: BoxDecoration(
        color: GurtuColors.surfaceHigh,
        borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _toggle,
            tooltip: playing ? l.pause : l.play,
            iconSize: 30,
            color: GurtuColors.primary,
            icon: Icon(
              playing
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title ?? l.voiceNote, style: t.titleSmall),
                Text(
                  [
                    if (showPosition) _clock(_position),
                    if (length != null) _clock(length),
                  ].join(' / '),
                  style: t.bodySmall?.copyWith(
                    color: GurtuColors.textMuted,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onRemove,
            tooltip: l.remove,
            color: GurtuColors.textSecondary,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}
