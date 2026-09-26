import 'package:flutter/material.dart';

import '../../data/visit_models.dart';
import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../visit_text.dart';

/// "Tell the doctor": exactly what the family said and answered while
/// preparing, word for word, to show or read out at the start of the visit.
///
/// Deliberately not written by the AI: a summary can get a detail wrong,
/// a copy of their own answers can't.
class TellDoctorCard extends StatelessWidget {
  const TellDoctorCard({
    super.key,
    required this.symptoms,
    required this.intake,
    this.said = '',
    this.note = '',
  });

  final List<Symptom> symptoms;
  final List<IntakeAnswer> intake;
  final String said;
  final String note;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    Widget line(String label, String value) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.bodySmall),
          Text(
            value,
            style: t.titleMedium?.copyWith(
              fontSize: 15,
              color: GurtuColors.textPrimary,
            ),
          ),
        ],
      ),
    );

    return GurtuCard(
      color: GurtuColors.primarySoft,
      borderColor: GurtuColors.primary.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.record_voice_over_rounded,
                size: 20,
                color: GurtuColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(l.prepSummaryTitle, style: t.titleMedium)),
            ],
          ),
          if (symptoms.isNotEmpty)
            line(l.healthProblems, symptoms.map(l.symptomLabel).join(', ')),
          if (said.isNotEmpty) line(l.prepInTheirWords, '“$said”'),
          for (final a in intake) line(a.question, a.answer),
          if (note.isNotEmpty) line(l.askAnythingElse, note),
          const SizedBox(height: 10),
          Text(l.prepSummaryHint, style: t.bodySmall),
        ],
      ),
    );
  }
}
