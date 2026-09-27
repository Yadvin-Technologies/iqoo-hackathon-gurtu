import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../cloud/cloud_models.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../../widgets/gurtu_page.dart';
import '../onboarding_flow.dart';
import 'join_circle_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GurtuSpace.gutter),
        child: Column(
          children: [
            const SizedBox(height: 28),
            const GurtuLogo(size: 64, showTagline: true),
            const Expanded(child: Center(child: CareCircleOrbit())),
            Text(
              l.welcomeTitle,
              textAlign: TextAlign.center,
              style: t.displaySmall?.copyWith(fontSize: 30),
            ),
            const SizedBox(height: 12),
            Text(
              l.welcomeBody,
              textAlign: TextAlign.center,
              style: t.bodyLarge,
            ),
            const SizedBox(height: 14),
            Text(
              l.welcomeScript,
              textAlign: TextAlign.center,
              style: GurtuFonts.handwritten(context, color: GurtuColors.amber),
            ),
            const SizedBox(height: 22),
            GurtuButton(
              label: l.getStarted,
              icon: Icons.arrow_forward_rounded,
              onPressed: OnboardingFlow.of(context).next,
            ),
            const SizedBox(height: 6),
            // Someone in the family already set Gurtu up: join them.
            TextButton.icon(
              onPressed: () async {
                final flow = OnboardingFlow.of(context);
                final joined = await pushPage<(CircleInfo, String)>(
                  context,
                  const JoinCirclePage(),
                );
                if (joined != null) flow.joined(joined.$1, joined.$2);
              },
              icon: const Icon(Icons.group_add_rounded, size: 20),
              label: Text(l.haveFamilyCode),
              style: TextButton.styleFrom(
                foregroundColor: GurtuColors.primary,
                minimumSize: const Size(48, 48),
                textStyle: const TextStyle(
                  fontFamily: GurtuFonts.sans,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const _BuiltForIqoo(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _BuiltForIqoo extends StatelessWidget {
  const _BuiltForIqoo();

  static const _marker = '\u0000';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const muted = TextStyle(color: GurtuColors.textMuted, fontSize: 13);
    // Word order differs by language ("Built for iQOO" / "iQOO కోసం..."), so
    // the translation positions the brand and we split around it.
    final parts = l.builtForBrand(_marker).split(_marker);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (parts.first.isNotEmpty) Text(parts.first, style: muted),
        ShaderMask(
          shaderCallback: GurtuColors.iqooGradient.createShader,
          child: const Text(
            'iQOO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        if (parts.length > 1 && parts.last.isNotEmpty)
          Text(parts.last, style: muted),
        Text('  ·  ${l.madeInHyderabad}', style: muted),
      ],
    );
  }
}

/// Family members gently orbiting the person being cared for.
class CareCircleOrbit extends StatefulWidget {
  const CareCircleOrbit({super.key, this.size = 300});

  final double size;

  @override
  State<CareCircleOrbit> createState() => _CareCircleOrbitState();
}

class _CareCircleOrbitState extends State<CareCircleOrbit>
    with SingleTickerProviderStateMixin {
  late final _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  )..repeat();

  static const _members = [
    // Icons rather than initials so the picture works in every language.
    ('', GurtuColors.primary, Icons.person_rounded),
    ('', Color(0xFF3FA7D6), Icons.face_rounded),
    ('', Color(0xFFE07A5F), Icons.face_3_rounded),
    ('', Color(0xFF2BB39A), Icons.face_6_rounded),
    ('', GurtuColors.orange, Icons.medical_services_rounded),
  ];

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = math.min(widget.size, MediaQuery.sizeOf(context).height * 0.34);
    return ExcludeSemantics(
      child: SizedBox(
        width: s,
        height: s,
        child: AnimatedBuilder(
          animation: _spin,
          builder: (context, _) {
            final a = _spin.value * 2 * math.pi;
            final r = s * 0.40;
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(size: Size(s, s), painter: _OrbitPainter()),
                for (var i = 0; i < _members.length; i++)
                  Transform.translate(
                    offset: Offset(
                      r * math.cos(a + i * 2 * math.pi / _members.length),
                      r * math.sin(a + i * 2 * math.pi / _members.length),
                    ),
                    child: InitialsAvatar(
                      label: _members[i].$1,
                      color: _members[i].$2,
                      icon: _members[i].$3,
                      size: s * 0.17,
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InitialsAvatar(
                      label: '',
                      color: const Color(0xFFB9855A),
                      size: s * 0.30,
                      icon: Icons.elderly_woman_rounded,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: GurtuColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            size: 14,
                            color: GurtuColors.danger,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.motherName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: GurtuColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          GurtuColors.primary.withValues(alpha: 0.35),
          GurtuColors.primary.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: c, radius: size.width * 0.3));
    canvas.drawCircle(c, size.width * 0.3, glow);

    for (final (f, alpha) in [(0.40, 0.35), (0.26, 0.18)]) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = GurtuColors.textMuted.withValues(alpha: alpha);
      final r = size.width * f;
      const dashes = 60;
      for (var i = 0; i < dashes; i++) {
        final start = i * 2 * math.pi / dashes;
        canvas.drawArc(
          Rect.fromCircle(center: c, radius: r),
          start,
          math.pi / dashes,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
