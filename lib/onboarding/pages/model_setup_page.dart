import 'package:flutter/material.dart';

import '../../ai/on_device_ai.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/ai_status.dart';
import '../../widgets/gurtu_widgets.dart';
import '../onboarding_flow.dart';
import '../step_scaffold.dart';

enum _Phase { choose, installing, done }

/// Sets up Gurtu AI: one model, picked for this phone, downloaded once.
///
/// People see what it does for them and a single progress list; the model
/// name, size and chip are under "Technical details". The download belongs
/// to [GurtuAi], so "Continue" moves on while it finishes in the background.
class ModelSetupPage extends StatelessWidget {
  const ModelSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = AiScope.of(context);
    final flow = OnboardingFlow.of(context);
    final l = context.l10n;
    final phase = switch (ai.status) {
      AiStatus.installed => _Phase.done,
      AiStatus.downloading || AiStatus.waitingForWifi => _Phase.installing,
      _ => _Phase.choose,
    };
    final unsupported = ai.status == AiStatus.unsupported;

    return StepScaffold(
      title: switch (phase) {
        _Phase.choose => l.modelTitleChoose,
        _Phase.installing => l.modelTitleDownloading,
        _Phase.done => l.modelTitleDone,
      },
      subtitle: switch (phase) {
        _Phase.choose => l.modelSubtitleChoose,
        _Phase.installing => l.modelSubtitleDownloading,
        _Phase.done => l.modelSubtitleDone,
      },
      onSkip: phase == _Phase.choose && !unsupported ? flow.next : null,
      skipLabel: l.later,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DeviceCard(ai: ai),
          const SizedBox(height: 20),
          if (unsupported)
            InfoBanner(text: l.aiUnsupported, icon: Icons.info_outline_rounded)
          else if (phase == _Phase.choose) ...[
            const _Perks(),
            if (ai.status == AiStatus.failed) ...[
              const SizedBox(height: 14),
              InfoBanner(
                text: aiStatusLine(l, ai),
                icon: Icons.error_outline_rounded,
                color: GurtuColors.danger,
              ),
            ],
            const SizedBox(height: 14),
            _WifiSwitch(ai: ai),
          ] else ...[
            _Steps(ai: ai),
            if (ai.status == AiStatus.waitingForWifi) ...[
              const SizedBox(height: 14),
              InfoBanner(text: l.aiWaitingWifi, icon: Icons.wifi_rounded),
              const SizedBox(height: 10),
              GurtuButton(
                label: l.aiUseMobileData,
                icon: Icons.signal_cellular_alt_rounded,
                style: GurtuButtonStyle.ghost,
                onPressed: () => ai.install(useMobileData: true),
              ),
            ],
          ],
          if (!unsupported && ai.build != null) ...[
            const SizedBox(height: 8),
            const AiTechDetails(),
          ],
        ],
      ),
      bottom: switch (phase) {
        _ when unsupported => GurtuButton(
          label: l.continueLabel,
          icon: Icons.arrow_forward_rounded,
          onPressed: flow.next,
        ),
        _Phase.choose => GurtuButton(
          label: ai.status == AiStatus.checking
              ? l.settingUp
              : ai.status == AiStatus.failed
              ? l.aiRetry
              : l.aiInstall(sizeLabel(ai.sizeMb)),
          icon: Icons.download_rounded,
          onPressed: ai.status == AiStatus.checking ? null : ai.install,
        ),
        _Phase.installing => GurtuButton(
          label: l.aiContinueInBackground,
          icon: Icons.arrow_forward_rounded,
          onPressed: flow.next,
        ),
        _Phase.done => GurtuButton(
          label: l.continueLabel,
          icon: Icons.arrow_forward_rounded,
          onPressed: flow.next,
        ),
      },
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.ai});

  final GurtuAi ai;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        gradient: LinearGradient(
          colors: [
            GurtuColors.amberBright.withValues(alpha: 0.22),
            GurtuColors.primary.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: GurtuColors.orange.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: GurtuColors.iqooGradient,
            ),
            child: const Icon(
              Icons.memory_rounded,
              color: Color(0xFF1E1400),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.poweredByIqoo, style: t.titleMedium),
                const SizedBox(height: 2),
                Text(
                  ai.build == null
                      ? l.deviceCardSub
                      : backendLabel(l, ai.backend),
                  style: t.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// What Gurtu AI does for the family, not how.
class _Perks extends StatelessWidget {
  const _Perks();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final perks = [
      (Icons.lock_rounded, GurtuColors.leaf, l.aiPerkPrivate),
      (Icons.wifi_off_rounded, GurtuColors.info, l.aiPerkOffline),
      (Icons.record_voice_over_rounded, GurtuColors.orange, l.aiPerkQuestions),
    ];
    return GurtuCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          for (final (icon, color, text) in perks)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  IconBadge(icon: icon, color: color, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: t.titleMedium?.copyWith(fontSize: 15),
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

class _WifiSwitch extends StatelessWidget {
  const _WifiSwitch({required this.ai});

  final GurtuAi ai;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return GurtuCard(
      padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
      child: Row(
        children: [
          const Icon(Icons.wifi_rounded, color: GurtuColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.wifiOnly,
              style: t.titleMedium?.copyWith(fontSize: 16),
            ),
          ),
          Switch(value: ai.wifiOnly, onChanged: ai.setWifiOnly),
        ],
      ),
    );
  }
}

/// Check → download → ready, with the bar on the step in progress.
class _Steps extends StatelessWidget {
  const _Steps({required this.ai});

  final GurtuAi ai;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final done = ai.isReady;
    final steps = [
      (l.aiStepCheck, true),
      (l.aiStepDownload, done),
      (l.aiStepReady, done),
    ];
    return GurtuCard(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, (label, complete)) in steps.indexed) ...[
            _StepRow(
              label: label,
              complete: complete,
              active: !complete && i == 1,
            ),
            if (i == 1 && !done) ...[
              Padding(
                padding: const EdgeInsets.only(left: 40, bottom: 6),
                child: AiProgressBar(ai: ai),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.label,
    required this.complete,
    required this.active,
  });

  final String label;
  final bool complete;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: complete
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: GurtuColors.leaf,
                  )
                : active
                ? const Padding(
                    padding: EdgeInsets.all(4),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: GurtuColors.orange,
                    ),
                  )
                : const Icon(
                    Icons.radio_button_unchecked_rounded,
                    color: GurtuColors.textMuted,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: t.titleMedium?.copyWith(
                fontSize: 15,
                color: complete || active
                    ? GurtuColors.textPrimary
                    : GurtuColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
