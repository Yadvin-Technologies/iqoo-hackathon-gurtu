import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/visit_models.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../../widgets/voice_input.dart';
import '../visit_text.dart';

/// Questions to take to the doctor. With [onToggle] each one can be ticked
/// off at the visit; with [onRemove] unwanted ones can be dropped. Questions
/// written by Gurtu AI carry a topic and are shown under topic headings.
class QuestionList extends StatelessWidget {
  const QuestionList({
    super.key,
    required this.questions,
    this.onToggle,
    this.onRemove,
  });

  final List<DoctorQuestion> questions;
  final ValueChanged<DoctorQuestion>? onToggle;
  final ValueChanged<DoctorQuestion>? onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return GurtuCard(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: [
          for (final (i, q) in questions.indexed) ...[
            if (_heading(i) case final heading?)
              _TopicHeading(heading, first: i == 0)
            else if (i > 0)
              const Divider(height: 1, indent: 56, color: GurtuColors.outline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  if (onToggle != null)
                    Semantics(
                      checked: q.asked,
                      child: Checkbox(
                        value: q.asked,
                        activeColor: GurtuColors.leaf,
                        onChanged: (_) {
                          HapticFeedback.selectionClick();
                          onToggle!(q);
                        },
                      ),
                    )
                  else
                    SizedBox(
                      width: 48,
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: t.titleMedium?.copyWith(
                            color: GurtuColors.amber,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        l.questionText(q),
                        style: t.bodyLarge?.copyWith(
                          color: q.asked
                              ? GurtuColors.textMuted
                              : GurtuColors.textPrimary,
                          decoration: q.asked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ),
                  if (onRemove != null)
                    IconButton(
                      tooltip: l.removeQuestion,
                      onPressed: () => onRemove!(q),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: GurtuColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

extension on QuestionList {
  /// The heading to show above question [i], when a new topic starts.
  String? _heading(int i) {
    if (!questions.any((q) => q.topic != null)) return null;
    final topic = questions[i].topic;
    if (i > 0 && questions[i - 1].topic == topic) return null;
    return topic?.name ?? '';
  }
}

class _TopicHeading extends StatelessWidget {
  const _TopicHeading(this.topic, {required this.first});

  /// A [QuestionTopic] name, or '' for questions the family added.
  final String topic;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, icon) = switch (QuestionTopic.values.asNameMap()[topic]) {
      QuestionTopic.understand => (l.topicUnderstand, Icons.lightbulb_rounded),
      QuestionTopic.tests => (l.topicTests, Icons.biotech_rounded),
      QuestionTopic.treatment => (l.topicTreatment, Icons.medication_rounded),
      QuestionTopic.home => (l.topicHome, Icons.home_rounded),
      QuestionTopic.followUp => (l.topicFollowUp, Icons.event_rounded),
      null => (l.topicOwn, Icons.edit_rounded),
    };
    return Padding(
      padding: EdgeInsets.fromLTRB(14, first ? 10 : 18, 14, 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: GurtuColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: GurtuColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Add your own question": type or speak it, then Add.
class AddQuestionField extends StatefulWidget {
  const AddQuestionField({super.key, required this.onAdd});

  final ValueChanged<DoctorQuestion> onAdd;

  @override
  State<AddQuestionField> createState() => _AddQuestionFieldState();
}

class _AddQuestionFieldState extends State<AddQuestionField> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _add() {
    final text = _text.text.trim();
    if (text.isEmpty) return;
    widget.onAdd(
      DoctorQuestion(
        id: 'dq_own_${DateTime.now().microsecondsSinceEpoch}',
        kind: QuestionKind.custom,
        text: text,
      ),
    );
    _text.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DictationField(
          controller: _text,
          hint: l.addOwnQuestion,
          minLines: 1,
          maxLines: 4,
          onChanged: (_) => setState(() {}),
        ),
        if (_text.text.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          GurtuButton(
            label: l.add,
            icon: Icons.add_rounded,
            style: GurtuButtonStyle.ghost,
            onPressed: _add,
          ),
        ],
      ],
    );
  }
}
