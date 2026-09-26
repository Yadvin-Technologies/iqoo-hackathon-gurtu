import 'package:flutter/material.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../onboarding_flow.dart';

class _Slide {
  const _Slide(this.eyebrow, this.title, this.body, this.preview);
  final String eyebrow;
  final String title;
  final String body;
  final Widget preview;
}

/// Three quick slides explaining what Gurtu does, before any questions.
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _controller = PageController();
  int _page = 0;

  static const _slideCount = 3;

  List<_Slide> _slides(AppLocalizations l) => [
    _Slide(
      l.introRecordEyebrow,
      l.introRecordTitle,
      l.introRecordBody,
      const _RecordPreview(),
    ),
    _Slide(
      l.introPlanEyebrow,
      l.introPlanTitle,
      l.introPlanBody,
      const _PlanPreview(),
    ),
    _Slide(
      l.introAskEyebrow,
      l.introAskTitle,
      l.introAskBody,
      const _AskPreview(),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = OnboardingFlow.of(context);
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final slides = _slides(l);
    final last = _page == _slideCount - 1;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: flow.back,
                  tooltip: l.back,
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: GurtuColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: flow.next,
                  child: Text(
                    l.skip,
                    style: const TextStyle(
                      color: GurtuColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slideCount,
              onPageChanged: (p) => setState(() => _page = p),
              itemBuilder: (context, i) {
                final s = slides[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GurtuSpace.gutter,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Center(child: s.preview)),
                      Eyebrow(s.eyebrow),
                      const SizedBox(height: 10),
                      Text(s.title, style: t.headlineMedium),
                      const SizedBox(height: 10),
                      Text(s.body, style: t.bodyLarge),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              GurtuSpace.gutter,
              24,
              GurtuSpace.gutter,
              16,
            ),
            child: Column(
              children: [
                Row(
                  children: List.generate(_slideCount, (i) {
                    final active = i == _page;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 6),
                      width: active ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: active ? GurtuColors.iqooGradient : null,
                        color: active ? null : GurtuColors.outline,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                GurtuButton(
                  label: last ? l.letsSetUp : l.next,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: last
                      ? flow.next
                      : () => _controller.nextPage(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutCubic,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Phone-card frame for the mini previews.
class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: GurtuColors.surface,
          borderRadius: BorderRadius.circular(GurtuSpace.radiusLg),
          border: Border.all(color: GurtuColors.outline),
          boxShadow: [
            BoxShadow(
              color: GurtuColors.primary.withValues(alpha: 0.18),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _RecordPreview extends StatelessWidget {
  const _RecordPreview();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    return _PreviewCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l.hospitalMode, style: t.titleMedium)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: GurtuColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: GurtuColors.danger),
                    SizedBox(width: 6),
                    Text(
                      'REC 12:30',
                      style: TextStyle(
                        color: GurtuColors.danger,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(34, (i) {
                final h = 8 + ((i * 37) % 11) * 3.6;
                return Container(
                  width: 3.5,
                  height: h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color.lerp(
                      GurtuColors.primary,
                      GurtuColors.orange,
                      i / 34,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          InfoBanner(
            text: l.consentRecording,
            icon: Icons.verified_user_rounded,
          ),
          const SizedBox(height: 12),
          for (final s in [
            l.doctorConversation,
            l.nurseInstructions,
            l.pharmacistAdvice,
          ])
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_box_rounded,
                    color: GurtuColors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s, style: t.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PlanPreview extends StatelessWidget {
  const _PlanPreview();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    Widget row(IconData i, Color c, String title, String sub, Color who) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            IconBadge(icon: i, color: c, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.titleMedium?.copyWith(fontSize: 15)),
                  Text(sub, style: t.bodySmall),
                ],
              ),
            ),
            InitialsAvatar(
              label: '',
              color: who,
              icon: Icons.person_rounded,
              size: 30,
            ),
          ],
        ),
      );
    }

    return _PreviewCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.yourCarePlan, style: t.titleMedium),
          const SizedBox(height: 10),
          row(
            Icons.medication_rounded,
            GurtuColors.leaf,
            'Amlodipine 5mg',
            '${l.afterBreakfast} · 8:00 AM',
            const Color(0xFF3FA7D6),
          ),
          row(
            Icons.monitor_heart_rounded,
            GurtuColors.info,
            l.checkBloodPressure,
            l.twiceDaily,
            GurtuColors.primary,
          ),
          row(
            Icons.bloodtype_rounded,
            GurtuColors.orange,
            l.bloodTest,
            '14 Oct · 8:00 AM',
            const Color(0xFFE07A5F),
          ),
          const SizedBox(height: 8),
          InfoBanner(
            text: l.instructionsFound,
            icon: Icons.auto_awesome_rounded,
            color: GurtuColors.amber,
          ),
        ],
      ),
    );
  }
}

class _AskPreview extends StatelessWidget {
  const _AskPreview();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    return _PreviewCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: GurtuColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              l.askQuestion,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: GurtuColors.surfaceHigh,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // One sentence per language: word order differs, so no
                // separately bolded fragment.
                Text(
                  l.askAnswer,
                  style: t.bodyMedium?.copyWith(
                    color: GurtuColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill_rounded,
                      color: GurtuColors.orange,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.sourceDoctorVisit,
                            style: t.titleMedium?.copyWith(fontSize: 14),
                          ),
                          Text(
                            '13 Oct · 11:42 AM · at 00:12',
                            style: t.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
