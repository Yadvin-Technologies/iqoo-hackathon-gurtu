import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';

/// Compact emergency entry point. Deliberately small and calm: a tap only
/// opens the hold-to-send sheet, so SOS can never fire by accident.
class SosButton extends StatelessWidget {
  const SosButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      button: true,
      label: '${l.sosLabel}, ${l.sosHint}',
      excludeSemantics: true,
      child: Material(
        color: GurtuColors.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: GurtuColors.danger.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => showSosSheet(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Not Icons.sos: that glyph already reads "SOS".
                  const Icon(
                    Icons.emergency_rounded,
                    color: GurtuColors.danger,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l.sosLabel,
                    style: const TextStyle(
                      color: GurtuColors.danger,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showSosSheet(BuildContext context) =>
    showGurtuSheet(context, (_) => const _SosSheet());

class _SosSheet extends StatefulWidget {
  const _SosSheet();

  @override
  State<_SosSheet> createState() => _SosSheetState();
}

class _SosSheetState extends State<_SosSheet>
    with SingleTickerProviderStateMixin {
  /// Press and hold for 2 seconds; letting go early rewinds.
  late final _hold = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..addStatusListener(_onStatus);
  bool _finished = false;

  void _onStatus(AnimationStatus s) {
    if (s == AnimationStatus.completed) {
      HapticFeedback.heavyImpact();
      // TODO(phase 6): call EmergencyService.triggerSOS() here. Until that
      // exists nothing is sent, and the sheet says so.
      setState(() => _finished = true);
    }
  }

  void _down() {
    if (_finished) return;
    HapticFeedback.mediumImpact();
    _hold.forward();
  }

  void _up() {
    if (_finished) return;
    _hold.reverse();
  }

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetGrabber(),
            const SizedBox(height: 16),
            Text(
              l.sosHoldTitle,
              textAlign: TextAlign.center,
              style: t.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l.sosHoldBody,
              textAlign: TextAlign.center,
              style: t.bodyMedium,
            ),
            const SizedBox(height: 28),
            Semantics(
              button: true,
              label: l.sosHoldButton,
              onLongPress: _finished ? null : () => _hold.forward(),
              child: Listener(
                onPointerDown: (_) => _down(),
                onPointerUp: (_) => _up(),
                onPointerCancel: (_) => _up(),
                child: AnimatedBuilder(
                  animation: _hold,
                  builder: (context, _) =>
                      _HoldCircle(progress: _hold.value, finished: _finished),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _hold,
              builder: (context, _) => Text(
                _finished
                    ? l.sosPreviewDone
                    : _hold.value > 0
                    ? l.sosKeepHolding
                    : l.sosHoldButton,
                textAlign: TextAlign.center,
                style: t.titleMedium?.copyWith(
                  color: _finished ? GurtuColors.leaf : GurtuColors.danger,
                ),
              ),
            ),
            const SizedBox(height: 20),
            InfoBanner(
              text: l.sosPreviewNote,
              icon: Icons.info_rounded,
              color: GurtuColors.info,
            ),
            const SizedBox(height: 16),
            GurtuButton(
              label: l.close,
              style: GurtuButtonStyle.ghost,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoldCircle extends StatelessWidget {
  const _HoldCircle({required this.progress, required this.finished});

  final double progress;
  final bool finished;

  @override
  Widget build(BuildContext context) {
    // Grows slightly while held, so the press feels acknowledged.
    final scale = 1 + progress * 0.08;
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: 168,
        height: 168,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: finished ? 1 : progress,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
                backgroundColor: GurtuColors.danger.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(
                  finished ? GurtuColors.leaf : GurtuColors.danger,
                ),
              ),
            ),
            Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: finished ? GurtuColors.leaf : GurtuColors.danger,
                boxShadow: [
                  BoxShadow(
                    color: (finished ? GurtuColors.leaf : GurtuColors.danger)
                        .withValues(alpha: 0.25 + progress * 0.25),
                    blurRadius: 24 + progress * 24,
                  ),
                ],
              ),
              child: Icon(
                finished ? Icons.check_rounded : Icons.sos_rounded,
                color: Colors.white,
                size: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
