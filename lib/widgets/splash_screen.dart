import 'package:flutter/material.dart';

import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import 'gurtu_widgets.dart';

/// Shown while Gurtu opens: the wordmark and leaf ease in over the brand
/// background (the same one Android's own launch screen uses, so the hand-over
/// is seamless), with the tagline and a soft progress line under it.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  late final _logo = CurvedAnimation(
    parent: _c,
    curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
  );
  late final _fade = CurvedAnimation(
    parent: _c,
    curve: const Interval(0, 0.45, curve: Curves.easeOut),
  );
  late final _tagline = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.45, 1, curve: Curves.easeOut),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: GurtuColors.background,
      body: GlowBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 5),
              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: Tween(begin: 0.82, end: 1.0).animate(_logo),
                  // Shrinks rather than overflows with very large text.
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GurtuLogo(size: 76),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FadeTransition(
                opacity: _tagline,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(_tagline),
                  child: Text(
                    l.tagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: GurtuColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 4),
              FadeTransition(
                opacity: _tagline,
                child: SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: GurtuColors.primarySoft,
                      valueColor: AlwaysStoppedAnimation(GurtuColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
