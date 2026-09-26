import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../onboarding_flow.dart';
import '../onboarding_state.dart';
import '../step_scaffold.dart';

/// One on-device model Gurtu needs, with its text already in the app language.
class AiModel {
  const AiModel({
    required this.id,
    required this.job,
    required this.name,
    required this.what,
    required this.sizeMb,
    required this.icon,
    required this.color,
  });

  final String id;

  /// Plain-language job ("Listens").
  final String job;
  final String name;
  final String what;
  final int sizeMb;
  final IconData icon;
  final Color color;
}

class CareModelTier {
  const CareModelTier({
    required this.tier,
    required this.model,
    required this.sizeMb,
    required this.ram,
  });

  final ModelTier tier;

  /// Technical model name; kept in English on purpose.
  final String model;
  final int sizeMb;
  final String ram;
}

const _tiers = [
  CareModelTier(
    tier: ModelTier.lite,
    model: 'Gemma 3 · 1B',
    sizeMb: 530,
    ram: '4 GB+ RAM',
  ),
  CareModelTier(
    tier: ModelTier.balanced,
    model: 'Gemma 3n · E2B',
    sizeMb: 3100,
    ram: '8 GB+ RAM',
  ),
  CareModelTier(
    tier: ModelTier.pro,
    model: 'Gemma 3n · E4B',
    sizeMb: 4400,
    ram: '12 GB+ RAM',
  ),
];

/// Speech, document reading and vision — always installed. The speech pack
/// follows the language chosen at the start of onboarding.
List<AiModel> _baseModels(AppLocalizations l, AppLanguage language) => [
  AiModel(
    id: 'speech',
    job: l.jobListens,
    // "English + English" reads oddly, so English gets the plain name.
    name: language == AppLanguage.english
        ? 'Speech · English'
        : l.speechModelName(language.nativeName),
    what: l.speechModelWhat,
    sizeMb: 190,
    icon: Icons.graphic_eq_rounded,
    color: GurtuColors.danger,
  ),
  AiModel(
    id: 'reader',
    job: l.jobReads,
    name: l.readerModelName,
    what: l.readerModelWhat,
    sizeMb: 28,
    icon: Icons.document_scanner_rounded,
    color: GurtuColors.info,
  ),
  AiModel(
    id: 'vision',
    job: l.jobSees,
    name: l.visionModelName,
    what: l.visionModelWhat,
    sizeMb: 24,
    icon: Icons.center_focus_strong_rounded,
    color: GurtuColors.leaf,
  ),
];

String _size(int mb) =>
    mb >= 1000 ? '${(mb / 1000).toStringAsFixed(1)} GB' : '$mb MB';

enum _Phase { choose, downloading, done }

class ModelSetupPage extends StatefulWidget {
  const ModelSetupPage({super.key});

  @override
  State<ModelSetupPage> createState() => _ModelSetupPageState();
}

class _ModelSetupPageState extends State<ModelSetupPage> {
  _Phase _phase = _Phase.choose;
  final _progress = <String, double>{};
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<AiModel> _plan(
    OnboardingState d,
    AppLocalizations l,
    AppLanguage language,
  ) {
    final tier = _tiers.firstWhere((t) => t.tier == d.modelTier);
    return [
      ..._baseModels(l, language),
      AiModel(
        id: 'care',
        job: l.jobUnderstands,
        name: l.careModelName(tier.model),
        what: tier.tier.note(l),
        sizeMb: tier.sizeMb,
        icon: Icons.auto_awesome_rounded,
        color: GurtuColors.amber,
      ),
    ];
  }

  /// Simulated download so the flow can be demoed end to end.
  // TODO: replace with real model downloads once model hosting is set up.
  void _start(List<AiModel> plan) {
    setState(() {
      _phase = _Phase.downloading;
      _progress
        ..clear()
        ..addEntries(plan.map((m) => MapEntry(m.id, 0)));
    });
    var i = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      if (!mounted) return t.cancel();
      final m = plan[i];
      // Bigger models take longer, but keep the demo under ~10 seconds.
      final step = 0.9 / (8 + m.sizeMb / 80);
      setState(() {
        _progress[m.id] = (_progress[m.id]! + step).clamp(0, 1);
      });
      if (_progress[m.id]! >= 1) {
        i++;
        if (i == plan.length) {
          t.cancel();
          setState(() => _phase = _Phase.done);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = OnboardingScope.of(context);
    final flow = OnboardingFlow.of(context);
    final l = context.l10n;
    final language = LanguageScope.of(context).value;
    final plan = _plan(d, l, language);
    final total = plan.fold<int>(0, (s, m) => s + m.sizeMb);
    final t = Theme.of(context).textTheme;

    return StepScaffold(
      title: switch (_phase) {
        _Phase.choose => l.modelTitleChoose,
        _Phase.downloading => l.modelTitleDownloading,
        _Phase.done => l.modelTitleDone,
      },
      subtitle: switch (_phase) {
        _Phase.choose => l.modelSubtitleChoose,
        _Phase.downloading => l.modelSubtitleDownloading,
        _Phase.done => l.modelSubtitleDone,
      },
      onSkip: _phase == _Phase.choose ? flow.next : null,
      skipLabel: l.later,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DeviceCard(),
          const SizedBox(height: 24),
          if (_phase == _Phase.choose) ...[
            Text(l.chooseCareModel, style: t.titleLarge),
            const SizedBox(height: 4),
            Text(l.careModelHint, style: t.bodyMedium),
            const SizedBox(height: 14),
            for (final tier in _tiers) ...[
              _TierTile(
                tier: tier,
                selected: d.modelTier == tier.tier,
                recommended: tier.tier == ModelTier.balanced,
                onTap: () => d.update(() => d.modelTier = tier.tier),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 18),
            Text(l.alwaysIncluded, style: t.titleLarge),
            const SizedBox(height: 14),
          ],
          for (final m
              in _phase == _Phase.choose ? _baseModels(l, language) : plan) ...[
            _ModelRow(
              model: m,
              progress: _phase == _Phase.choose ? null : _progress[m.id] ?? 1,
            ),
            const SizedBox(height: 10),
          ],
          if (_phase == _Phase.choose) ...[
            const SizedBox(height: 8),
            GurtuCard(
              padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.wifi_rounded,
                    color: GurtuColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.wifiOnly,
                      style: t.titleMedium?.copyWith(fontSize: 16),
                    ),
                  ),
                  Switch(
                    value: d.wifiOnly,
                    onChanged: (v) => d.update(() => d.wifiOnly = v),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottom: switch (_phase) {
        _Phase.choose => GurtuButton(
          label: l.downloadSize(_size(total)),
          icon: Icons.download_rounded,
          onPressed: () => _start(plan),
        ),
        _Phase.downloading => GurtuButton(label: l.settingUp, onPressed: null),
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
  const _DeviceCard();

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
                Text(l.deviceCardSub, style: t.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TierTile extends StatelessWidget {
  const _TierTile({
    required this.tier,
    required this.selected,
    required this.recommended,
    required this.onTap,
  });

  final CareModelTier tier;
  final bool selected;
  final bool recommended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    return ChoiceTile(
      selected: selected,
      onTap: onTap,
      title: tier.tier.label(l),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                tier.tier.label(l),
                style: t.titleMedium?.copyWith(fontSize: 18),
              ),
              if (recommended)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: GurtuColors.iqooGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l.bestForIqoo,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1400),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(tier.tier.note(l), style: t.bodyMedium),
          const SizedBox(height: 8),
          Text(
            '${tier.model}  ·  ${_size(tier.sizeMb)}  ·  ${tier.ram}',
            style: t.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ModelRow extends StatelessWidget {
  const _ModelRow({required this.model, this.progress});

  final AiModel model;

  /// null = not started (selection view).
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final done = progress != null && progress! >= 1;
    final active = progress != null && progress! > 0 && !done;

    return GurtuCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              IconBadge(icon: model.icon, color: model.color, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(model.job, color: model.color),
                    const SizedBox(height: 2),
                    Text(
                      model.name,
                      style: t.titleMedium?.copyWith(fontSize: 15),
                    ),
                    if (progress == null) ...[
                      const SizedBox(height: 2),
                      Text(model.what, style: t.bodySmall),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (done)
                Icon(
                  Icons.check_circle_rounded,
                  color: GurtuColors.leaf,
                  semanticLabel: context.l10n.ready,
                )
              else
                Text(
                  active
                      ? '${(progress! * 100).round()}%'
                      : _size(model.sizeMb),
                  style: t.bodySmall?.copyWith(
                    color: active ? GurtuColors.amber : GurtuColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: GurtuColors.outline,
                valueColor: AlwaysStoppedAnimation(
                  done ? GurtuColors.leaf : GurtuColors.orange,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
