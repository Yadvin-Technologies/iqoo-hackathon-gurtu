import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/care_models.dart';
import '../../data/care_repository.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../care_text.dart';

/// Today's tasks at a glance: progress plus the next few items. Only the
/// first four show on Home; the rest open in a sheet.
class TodayCareCard extends StatelessWidget {
  const TodayCareCard({super.key});

  static const _maxOnHome = 4;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final tasks = repo.todaysTasks();
    final done = tasks.where((x) => x.isDone).length;

    return GurtuCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(l.todayCare, style: t.titleLarge),
              if (tasks.isNotEmpty)
                Text(
                  l.completedOf(done, tasks.length),
                  style: t.titleMedium?.copyWith(
                    color: GurtuColors.leaf,
                    fontSize: 15,
                  ),
                ),
            ],
          ),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                children: [
                  const IconBadge(
                    icon: Icons.wb_sunny_rounded,
                    color: GurtuColors.leaf,
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.nothingUrgent, style: t.bodyLarge)),
                ],
              ),
            )
          else ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: done / tasks.length,
                minHeight: 6,
                backgroundColor: GurtuColors.surfaceHigh,
                valueColor: const AlwaysStoppedAnimation(GurtuColors.leaf),
              ),
            ),
            const SizedBox(height: 6),
            for (final task in tasks.take(_maxOnHome)) TaskRow(task: task),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () =>
                    showGurtuSheet(context, (_) => const _AllToday()),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                iconAlignment: IconAlignment.end,
                style: TextButton.styleFrom(
                  foregroundColor: GurtuColors.primary,
                  minimumSize: const Size(48, 48),
                  textStyle: const TextStyle(
                    fontFamily: GurtuFonts.sans,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                label: Text(l.viewTodayCare),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One task: a large tick target, the title, and when / who.
class TaskRow extends StatelessWidget {
  const TaskRow({super.key, required this.task});

  final CareTask task;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final assignee = repo.memberById(task.assignedTo);
    final who = assignee == null
        ? l.openToCircle
        : assignee.isYou
        ? l.rowYou
        : assignee.name;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Semantics(
            button: true,
            checked: task.isDone,
            label: task.isDone ? l.markNotDone : l.markDone,
            excludeSemantics: true,
            child: InkResponse(
              radius: 26,
              onTap: () {
                HapticFeedback.selectionClick();
                repo.toggleTask(task);
              },
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.isDone
                          ? GurtuColors.leaf
                          : Colors.transparent,
                      border: Border.all(
                        color: task.isDone
                            ? GurtuColors.leaf
                            : GurtuColors.textMuted,
                        width: 2,
                      ),
                    ),
                    child: task.isDone
                        ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.taskTitle(task),
                  style: t.titleMedium?.copyWith(
                    color: task.isDone
                        ? GurtuColors.textMuted
                        : GurtuColors.textPrimary,
                  ),
                ),
                Text(
                  '${timeLabel(context, task.dueDate)} · $who',
                  style: t.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllToday extends StatelessWidget {
  const _AllToday();

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetGrabber(),
          const SizedBox(height: 16),
          Text(l.todayCare, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final task in repo.todaysTasks()) TaskRow(task: task),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
