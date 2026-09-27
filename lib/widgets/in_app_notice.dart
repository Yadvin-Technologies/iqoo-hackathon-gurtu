import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/gurtu_theme.dart';

/// A notification shown inside the app, dropping in from the top like the
/// phone's own: for pushes that arrive while Gurtu is open (Android only
/// shows them itself in the background). It sits above every screen, so it
/// never clashes with a page opening or closing. Tap or swipe it away; it
/// also goes by itself.
class InAppNotice {
  InAppNotice._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  static const showFor = Duration(seconds: 5);

  static void show(
    OverlayState overlay, {
    required String title,
    String body = '',
    IconData icon = Icons.notifications_active_rounded,
  }) {
    hide();
    final entry = OverlayEntry(
      builder: (_) =>
          _NoticeView(title: title, body: body, icon: icon, onClose: hide),
    );
    _entry = entry;
    overlay.insert(entry);
    _timer = Timer(showFor, hide);
  }

  static void hide() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }
}

class _NoticeView extends StatelessWidget {
  const _NoticeView({
    required this.title,
    required this.body,
    required this.icon,
    required this.onClose,
  });

  final String title;
  final String body;
  final IconData icon;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: -1, end: 0),
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            builder: (context, v, child) => FractionalTranslation(
              translation: Offset(0, v),
              child: Opacity(opacity: (1 + v).clamp(0.0, 1.0), child: child),
            ),
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.up,
              onDismissed: (_) => onClose(),
              child: Semantics(
                liveRegion: true,
                child: Material(
                  color: GurtuColors.textPrimary,
                  elevation: 8,
                  shadowColor: Colors.black45,
                  borderRadius: BorderRadius.circular(GurtuSpace.radius),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(GurtuSpace.radius),
                    onTap: onClose,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 16, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: GurtuColors.iqooGradient,
                            ),
                            child: Icon(
                              icon,
                              size: 20,
                              color: const Color(0xFF1E1400),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (body.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    body,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                      fontSize: 14,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
