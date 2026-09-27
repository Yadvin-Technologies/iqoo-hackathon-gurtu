import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/care_models.dart';
import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../medicines/prescription_import_page.dart';
import '../../widgets/gurtu_page.dart';
import '../../widgets/gurtu_widgets.dart';
import '../care_text.dart';

/// The main daily action. What can be captured (a prescription scan, a note)
/// lives inside the sheet rather than as dashboard tiles, keeping Home short.
class CaptureCareButton extends StatelessWidget {
  const CaptureCareButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      button: true,
      label: '${l.captureCare}. ${l.captureCareSubtitle}',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(GurtuSpace.radius),
          onTap: () {
            HapticFeedback.lightImpact();
            showCaptureSheet(context);
          },
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: GurtuColors.primaryGradient,
              borderRadius: BorderRadius.circular(GurtuSpace.radius),
              boxShadow: [
                BoxShadow(
                  color: GurtuColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.captureCare,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.captureCareSubtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showCaptureSheet(BuildContext context) =>
    showGurtuSheet(context, (_) => _CaptureSheet(host: context));

class _CaptureSheet extends StatelessWidget {
  const _CaptureSheet({required this.host});

  /// The page that opened this sheet; follow-up sheets open from it, since
  /// this sheet's own context is gone once it closes.
  final BuildContext host;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = [
      (MomentType.scan, l.captureScanHint, true),
      (MomentType.note, l.captureNoteHint, true),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetGrabber(),
            const SizedBox(height: 16),
            Text(l.whatHappened, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            for (final (type, hint, ready) in options) ...[
              _CaptureOption(
                type: type,
                hint: hint,
                ready: ready,
                onTap: () {
                  Navigator.pop(context);
                  if (type == MomentType.note) {
                    showNoteSheet(host);
                  } else {
                    // Reads the medicines off a prescription photo, on the
                    // phone, and adds the ones ticked to the list.
                    pushPage(host, const PrescriptionImportPage());
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _CaptureOption extends StatelessWidget {
  const _CaptureOption({
    required this.type,
    required this.hint,
    required this.ready,
    required this.onTap,
  });

  final MomentType type;
  final String hint;
  final bool ready;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return Opacity(
      opacity: ready ? 1 : 0.6,
      child: GurtuCard(
        onTap: ready ? onTap : null,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            IconBadge(icon: momentIcon(type), color: momentColor(type)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(l.momentTypeLabel(type), style: t.titleMedium),
                      if (!ready)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: GurtuColors.surfaceHigh,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(l.comingSoon, style: t.bodySmall),
                        ),
                    ],
                  ),
                  Text(hint, style: t.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showNoteSheet(BuildContext context) =>
    showGurtuSheet(context, (_) => const _NoteSheet());

class _NoteSheet extends StatefulWidget {
  const _NoteSheet();

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _save() {
    final repo = CareScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    repo.addNote(_text.text);
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text(l.noteSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      // Keep the field above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetGrabber(),
              const SizedBox(height: 16),
              Text(
                l.captureNote,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _text,
                autofocus: true,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                  fontSize: 17,
                  color: GurtuColors.textPrimary,
                ),
                decoration: InputDecoration(hintText: l.noteHint),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              GurtuButton(
                label: l.saveNote,
                icon: Icons.check_rounded,
                onPressed: _text.text.trim().isEmpty ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
