import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/care_repository.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_widgets.dart';
import 'care_text.dart';
import 'widgets/ai_help_card.dart';
import 'widgets/care_circle_preview.dart';
import 'widgets/doctor_shortcuts.dart';
import 'widgets/looking_after_you.dart';
import 'widgets/people_strip.dart';
import 'widgets/patient_header.dart';
import 'widgets/quick_capture.dart';
import 'widgets/recent_memory.dart';
import 'widgets/sos_button.dart';
import 'widgets/today_care_card.dart';

/// Home, top to bottom: logo & SOS · greeting · who (with live numbers) ·
/// today · capture · doctor · recent · circle · ask. Pull down to refresh.
/// Detail lives in the other tabs; Home only answers "what now?".
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onOpenMemory,
    required this.onOpenCircle,
    required this.onAsk,
  });

  final VoidCallback onOpenMemory;
  final VoidCallback onOpenCircle;
  final ValueChanged<String?> onAsk;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final firstTime = repo.recentMoments.isEmpty && repo.todaysTasks().isEmpty;
    // Home is about you when the selected person is you, and about them
    // when you're looking after someone (one phone can do both).
    final self = repo.selectedPatient?.isSelf ?? false;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const _TopBar(),
          Expanded(
            child: RefreshIndicator(
              color: GurtuColors.primary,
              backgroundColor: GurtuColors.surface,
              onRefresh: () async {
                HapticFeedback.lightImpact();
                await repo.reload();
              },
              child: ListView(
                // Pull to refresh works even when everything fits.
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  GurtuSpace.gutter,
                  4,
                  GurtuSpace.gutter,
                  32,
                ),
                children: [
                  Text(
                    firstTime
                        ? l.welcomeName(repo.userName)
                        : l.greeting(repo.userName),
                    style: t.headlineMedium?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(l.welcomeHomeSubtitle, style: t.bodyMedium),
                  if (repo.hasSampleData) ...[
                    const SizedBox(height: 12),
                    _SampleBanner(onRemove: repo.removeSampleData),
                  ],
                  if (PeopleStrip.shownFor(repo)) ...[
                    const SizedBox(height: 18),
                    const PeopleStrip(),
                  ],
                  const SizedBox(height: 18),
                  const PatientHeader(),
                  // Your own care: who looks after you, and a way to ask.
                  if (self) ...[
                    const SizedBox(height: 16),
                    LookingAfterYou(onOpenCircle: onOpenCircle),
                  ],
                  const SizedBox(height: 16),
                  const TodayCareCard(),
                  const SizedBox(height: 16),
                  const CaptureCareButton(),
                  const SizedBox(height: 12),
                  const DoctorShortcuts(),
                  const SizedBox(height: 28),
                  RecentMemory(onViewAll: onOpenMemory),
                  const SizedBox(height: 28),
                  // Caring for someone else: the family helping with them.
                  if (!self) ...[
                    CareCirclePreview(onManage: onOpenCircle),
                    const SizedBox(height: 28),
                  ],
                  AiHelpCard(onAsk: onAsk),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The Gurtu wordmark, as on the splash screen, with SOS always in reach.
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(GurtuSpace.gutter, 6, 14, 8),
      child: Row(
        children: [
          const GurtuLogo(size: 38),
          const Spacer(),
          if (sosEnabled) const SosButton(),
        ],
      ),
    );
  }
}

/// Makes it obvious the content is demo data, with a one-tap way out.
class _SampleBanner extends StatelessWidget {
  const _SampleBanner({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
      decoration: BoxDecoration(
        color: GurtuColors.amberBright.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.science_rounded, size: 18, color: GurtuColors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l.sampleDataOn,
              style: const TextStyle(
                color: GurtuColors.amber,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: onRemove,
            style: TextButton.styleFrom(
              foregroundColor: GurtuColors.amber,
              minimumSize: const Size(48, 44),
              textStyle: const TextStyle(
                fontFamily: GurtuFonts.sans,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            child: Text(l.remove),
          ),
        ],
      ),
    );
  }
}
