import 'package:flutter/material.dart';

import '../data/care_repository.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import 'care_text.dart';
import 'widgets/ai_help_card.dart';
import 'widgets/care_circle_preview.dart';
import 'widgets/doctor_shortcuts.dart';
import 'widgets/getting_ready_card.dart';
import 'widgets/medicine_check_tile.dart';
import 'widgets/patient_header.dart';
import 'widgets/quick_capture.dart';
import 'widgets/recent_memory.dart';
import 'widgets/sos_button.dart';
import 'widgets/today_care_card.dart';

/// Home, top to bottom: who · today · capture · doctor & medicines · recent ·
/// circle · ask.
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

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          GurtuSpace.gutter,
          12,
          GurtuSpace.gutter,
          32,
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstTime
                          ? l.welcomeName(repo.userName)
                          : l.greeting(repo.userName),
                      style: t.headlineMedium?.copyWith(fontSize: 24),
                    ),
                    if (firstTime) ...[
                      const SizedBox(height: 4),
                      Text(l.welcomeHomeSubtitle, style: t.bodyMedium),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const SosButton(),
            ],
          ),
          if (repo.hasSampleData) ...[
            const SizedBox(height: 12),
            _SampleBanner(onRemove: repo.removeSampleData),
          ],
          const SizedBox(height: 16),
          const PatientHeader(),
          const SizedBox(height: 16),
          const TodayCareCard(),
          const SizedBox(height: 16),
          const CaptureCareButton(),
          const SizedBox(height: 12),
          const DoctorShortcuts(),
          const SizedBox(height: 12),
          const MedicineCheckTile(),
          // Below Capture Care so the main action stays above the fold.
          if (!repo.setupCardDismissed) ...[
            const SizedBox(height: 16),
            const GettingReadyCard(),
          ],
          const SizedBox(height: 28),
          RecentMemory(onViewAll: onOpenMemory),
          const SizedBox(height: 28),
          CareCirclePreview(onManage: onOpenCircle),
          const SizedBox(height: 28),
          AiHelpCard(onAsk: onAsk),
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
