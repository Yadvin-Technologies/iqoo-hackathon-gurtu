import 'package:flutter/material.dart';

import '../data/care_repository.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import 'prep_chat_page.dart';
import 'visit_recorder_page.dart';
import 'visit_text.dart';
import 'widgets/question_list.dart';
import 'widgets/tell_doctor_card.dart';

/// Saved questions for the next appointment. Open it at the doctor's and
/// tick each one off, or start recording the visit from here.
class PrepQuestionsPage extends StatefulWidget {
  const PrepQuestionsPage({super.key, required this.prepId});

  final String prepId;

  @override
  State<PrepQuestionsPage> createState() => _PrepQuestionsPageState();
}

class _PrepQuestionsPageState extends State<PrepQuestionsPage> {
  VisitPrep? _shown;

  void _replaceWith(Widget page) =>
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    // Keeps the last version on screen while the page closes after a delete.
    final prep = _shown = repo.prepById(widget.prepId) ?? _shown;
    if (prep == null) return const SizedBox.shrink();

    return GurtuPage(
      title: l.askDoctor,
      subtitle: l.preparedOn(dateLabel(context, prep.createdAt)),
      bottom: prep.isUsed
          ? null
          : GurtuButton(
              label: l.startVisit,
              icon: Icons.mic_rounded,
              onPressed: () => _replaceWith(VisitRecorderPage(prepId: prep.id)),
            ),
      children: [
        if (prep.symptoms.isNotEmpty) ...[
          FieldLabel(l.healthProblems, icon: Icons.healing_rounded),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final s in prep.symptoms) _SymptomPill(answer: s)],
          ),
          const SizedBox(height: 24),
        ],
        if (prep.intake.isNotEmpty) ...[
          TellDoctorCard(
            symptoms: [for (final a in prep.symptoms) a.symptom],
            said: prep.description,
            intake: prep.intake,
            note: prep.extraNote,
          ),
          const SizedBox(height: 24),
        ],
        FieldLabel(l.yourQuestions, icon: Icons.help_outline_rounded),
        Text(l.tickWhenAsked, style: t.bodyMedium),
        const SizedBox(height: 10),
        QuestionList(
          questions: prep.questions,
          onToggle: (q) {
            q.asked = !q.asked;
            repo.updatePrep(prep);
          },
          onRemove: (q) {
            prep.questions.remove(q);
            repo.updatePrep(prep);
          },
        ),
        const SizedBox(height: 16),
        AddQuestionField(
          onAdd: (q) {
            prep.questions.add(q);
            repo.updatePrep(prep);
          },
        ),
        const SizedBox(height: 16),
        InfoBanner(text: l.prepNotDoctor, icon: Icons.verified_user_rounded),
        const SizedBox(height: 24),
        GurtuButton(
          label: l.startAgain,
          style: GurtuButtonStyle.ghost,
          icon: Icons.refresh_rounded,
          onPressed: () => _replaceWith(const PrepChatPage()),
        ),
        const SizedBox(height: 12),
        GurtuButton(
          label: l.deleteQuestions,
          style: GurtuButtonStyle.ghost,
          icon: Icons.delete_outline_rounded,
          onPressed: () async {
            final ok = await confirmAction(
              context,
              title: l.deleteQuestions,
              confirm: l.delete,
            );
            if (!ok || !context.mounted) return;
            Navigator.pop(context);
            repo.deletePrep(prep);
          },
        ),
      ],
    );
  }
}

/// "Fever · A few days · Moderate".
class _SymptomPill extends StatelessWidget {
  const _SymptomPill({required this.answer});

  final SymptomAnswer answer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final urgent = answer.isUrgent;
    final color = urgent ? GurtuColors.danger : GurtuColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(answer.symptom.icon, size: 18, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              [
                l.symptomLabel(answer.symptom),
                if (answer.since != null) l.sinceLabel(answer.since!),
                if (answer.severity != null) l.severityLabel(answer.severity!),
              ].join(' · '),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GurtuColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
