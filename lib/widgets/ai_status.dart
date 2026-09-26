import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart' show PreferredBackend;

import '../ai/model_catalog.dart';
import '../ai/on_device_ai.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import 'gurtu_page.dart';
import 'gurtu_widgets.dart';

String sizeLabel(int mb) =>
    mb >= 1000 ? '${(mb / 1000).toStringAsFixed(1)} GB' : '$mb MB';

String backendLabel(AppLocalizations l, PreferredBackend? backend) =>
    switch (backend) {
      PreferredBackend.npu => l.aiRunsOnNpu,
      PreferredBackend.cpu => l.aiRunsOnCpu,
      PreferredBackend.gpu || null => l.aiRunsOnGpu,
    };

/// One line on how Gurtu AI is doing, in plain words.
String aiStatusLine(AppLocalizations l, GurtuAi ai) => switch (ai.status) {
  AiStatus.checking => l.aiStatusChecking,
  AiStatus.unsupported => l.aiUnsupported,
  AiStatus.notInstalled => l.aiStatusOff,
  AiStatus.waitingForWifi => l.aiWaitingWifi,
  AiStatus.downloading => l.aiStatusDownloading((ai.progress * 100).round()),
  AiStatus.installed => l.aiStatusReady,
  AiStatus.failed =>
    ai.failure == AiFailure.noSpace
        ? l.aiFailedSpace(sizeLabel(ai.sizeMb))
        : l.aiFailedNetwork,
};

/// Download bar with "1.2 GB of 2.6 GB".
class AiProgressBar extends StatelessWidget {
  const AiProgressBar({super.key, required this.ai});

  final GurtuAi ai;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final waiting = ai.status == AiStatus.waitingForWifi;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            // Indeterminate until the first bytes arrive.
            value: waiting || ai.progress == 0 ? null : ai.progress,
            minHeight: 8,
            backgroundColor: GurtuColors.outline,
            valueColor: const AlwaysStoppedAnimation(GurtuColors.orange),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                l.aiProgress(
                  sizeLabel((ai.sizeMb * ai.progress).round()),
                  sizeLabel(ai.sizeMb),
                ),
                style: t.bodySmall,
              ),
            ),
            Text(
              '${(ai.progress * 100).round()}%',
              style: t.bodySmall?.copyWith(
                color: GurtuColors.amber,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Gurtu AI's state with the one action that makes sense right now:
/// set up, cancel, retry or remove.
class AiStatusCard extends StatelessWidget {
  const AiStatusCard({super.key, this.showRemove = true});

  /// Profile offers removal; other screens only ever offer setting it up.
  final bool showRemove;

  @override
  Widget build(BuildContext context) {
    final ai = AiScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final ready = ai.isReady;

    return GurtuCard(
      borderColor: ready
          ? GurtuColors.leaf.withValues(alpha: 0.35)
          : GurtuColors.amberBright.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: GurtuColors.iqooGradient,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF1E1400),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gurtu AI', style: t.titleMedium),
                    Text(aiStatusLine(l, ai), style: t.bodyMedium),
                  ],
                ),
              ),
              if (ready)
                const Icon(Icons.check_circle_rounded, color: GurtuColors.leaf),
            ],
          ),
          if (ai.isBusyInstalling) ...[
            const SizedBox(height: 14),
            AiProgressBar(ai: ai),
          ],
          ..._actions(context, ai, l),
        ],
      ),
    );
  }

  List<Widget> _actions(BuildContext context, GurtuAi ai, AppLocalizations l) {
    Widget button(
      String label,
      IconData icon,
      VoidCallback onPressed, {
      GurtuButtonStyle style = GurtuButtonStyle.ghost,
    }) => Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GurtuButton(
        label: label,
        icon: icon,
        style: style,
        onPressed: onPressed,
      ),
    );

    return switch (ai.status) {
      AiStatus.notInstalled => [
        button(
          l.aiInstall(sizeLabel(ai.sizeMb)),
          Icons.download_rounded,
          ai.install,
          style: GurtuButtonStyle.amber,
        ),
      ],
      AiStatus.failed => [button(l.aiRetry, Icons.refresh_rounded, ai.install)],
      AiStatus.waitingForWifi => [
        button(
          l.aiUseMobileData,
          Icons.signal_cellular_alt_rounded,
          () => ai.install(useMobileData: true),
        ),
        button(l.cancel, Icons.close_rounded, ai.cancelInstall),
      ],
      AiStatus.downloading => [
        button(l.cancel, Icons.close_rounded, ai.cancelInstall),
      ],
      AiStatus.installed when showRemove => [
        button(l.remove, Icons.delete_outline_rounded, () async {
          final ok = await confirmAction(
            context,
            title: l.aiRemoveTitle,
            body: l.aiRemoveBody(sizeLabel(ai.sizeMb)),
            confirm: l.remove,
          );
          if (ok) await ai.remove();
        }),
      ],
      _ => const [],
    };
  }
}

/// Model, size and accelerator, tucked away for the curious.
class AiTechDetails extends StatelessWidget {
  const AiTechDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = AiScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final device = ai.device;
    final rows = [
      (l.aiDetailModel, careModelName),
      (l.aiDetailSize, sizeLabel(ai.sizeMb)),
      (l.aiDetailChip, backendLabel(l, ai.backend)),
      if (device.model.isNotEmpty)
        (
          l.aiDetailPhone,
          [
            device.model,
            if (device.socModel.isNotEmpty) device.socModel,
            if (device.totalRamMb > 0)
              '${(device.totalRamMb / 1024).round()} GB RAM',
          ].join(' · '),
        ),
    ];
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(l.aiDetails, style: t.titleMedium?.copyWith(fontSize: 15)),
        children: [
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 90, child: Text(label, style: t.bodySmall)),
                  Expanded(
                    child: Text(
                      value,
                      style: t.bodyMedium?.copyWith(
                        color: GurtuColors.textPrimary,
                      ),
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
