import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ai/gemma_visit_assistant.dart';
import '../ai/on_device_ai.dart';
import '../ai/visit_assistant.dart';
import '../ai/visit_knowledge.dart';
import '../data/care_repository.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../onboarding/onboarding_state.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/ai_status.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';
import '../widgets/voice_input.dart';
import 'prep_questions_page.dart';
import 'visit_text.dart';
import 'widgets/question_list.dart';
import 'widgets/tell_doctor_card.dart';

enum _Stage {
  symptoms,
  understanding,

  /// Gurtu AI's own follow-up questions.
  followUp,

  // The fixed questions, used when Gurtu AI isn't available.
  since,
  severity,
  medicine,
  extra,
  thinking,
  result,
}

/// A chat line. Text is built from l10n on every frame so the conversation
/// follows a language change.
class _Msg {
  const _Msg(this.text, {this.fromAi = true, this.urgent = false});

  final String Function(AppLocalizations l) text;
  final bool fromAi;
  final bool urgent;
}

/// "Questions for the doctor": the family describes the problem (tap, type
/// or speak), Gurtu asks a few follow-ups, then suggests what to ask the
/// doctor so they leave understanding the problem and the plan.
///
/// With Gurtu AI installed the on-device model writes both the follow-ups
/// and the questions for this patient; otherwise fixed follow-ups and
/// built-in rules do.
class PrepChatPage extends StatefulWidget {
  const PrepChatPage({super.key, this.assistant});

  /// Defaults to [GemmaVisitAssistant] on the app's [GurtuAi].
  final VisitAssistant? assistant;

  @override
  State<PrepChatPage> createState() => _PrepChatPageState();
}

class _PrepChatPageState extends State<PrepChatPage> {
  final _scroll = ScrollController();
  final _describe = TextEditingController();
  final _extra = TextEditingController();
  final _reply = TextEditingController();

  final _msgs = <_Msg>[];
  var _stage = _Stage.symptoms;
  final _picked = <Symptom>{};
  var _answers = <SymptomAnswer>[];
  var _current = 0;
  bool? _newMedicine;
  var _questions = <DoctorQuestion>[];
  var _byAi = false;
  var _followUps = <FollowUp>[];
  var _intake = <IntakeAnswer>[];

  /// Bumped by "Start again" so a slow AI answer for the old conversation
  /// is dropped.
  var _run = 0;

  late final VisitAssistant _assistant =
      widget.assistant ?? GemmaVisitAssistant(AiScope.read(context));

  SymptomAnswer get _now => _answers[_current];

  @override
  void initState() {
    super.initState();
    _start();
    // Load the model while the person is still answering, so the questions
    // at the end come quickly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AiScope.read(context).warmUp();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _describe.dispose();
    _extra.dispose();
    _reply.dispose();
    super.dispose();
  }

  void _start() {
    _msgs
      ..clear()
      ..add(_Msg((l) => l.prepIntro));
    _stage = _Stage.symptoms;
    _picked.clear();
    _answers = [];
    _current = 0;
    _newMedicine = null;
    _questions = [];
    _byAi = false;
    _followUps = [];
    _intake = [];
    _run++;
    _describe.clear();
    _extra.clear();
    _reply.clear();
  }

  void _say(
    String Function(AppLocalizations l) text, {
    bool ai = true,
    bool urgent = false,
  }) => _msgs.add(_Msg(text, fromAi: ai, urgent: urgent));

  /// Moves on and brings the newest question into view.
  void _go(_Stage stage) {
    setState(() => _stage = stage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _submitSymptoms() async {
    FocusScope.of(context).unfocus();
    final l = context.l10n;
    final description = _describe.text.trim();
    final keywords = l.symptomKeywords;
    var heard = _assistant.detectSymptoms(description, keywords);
    final patient = CareScope.of(context).selectedPatient;
    IntakePlan? plan;
    if (patient != null && AiScope.read(context).isReady) {
      final run = _run;
      _go(_Stage.understanding);
      plan = await _assistant.planIntake(
        patient: patient,
        picked: {..._picked},
        description: description,
        keywords: keywords,
        language: LanguageScope.of(context).value,
      );
      if (!mounted || run != _run) return;
      if (plan != null) heard = plan.symptoms;
    }
    final newlyHeard = [
      for (final s in Symptom.values)
        if (heard.contains(s) && !_picked.contains(s)) s,
    ];
    _picked.addAll(heard);
    final picked = [
      for (final s in Symptom.values)
        if (_picked.contains(s)) s,
    ];

    _say(
      (l) => [
        if (description.isNotEmpty) '“$description”',
        if (picked.isNotEmpty) picked.map(l.symptomLabel).join(', '),
      ].join('\n'),
      ai: false,
    );
    if (newlyHeard.isNotEmpty) {
      _say((l) => l.prepHeard(newlyHeard.map(l.symptomLabel).join(', ')));
    }
    _answers = [for (final s in picked) SymptomAnswer(s)];
    _current = 0;
    if (plan != null) {
      if (plan.medicineChanged) _newMedicine = true;
      _followUps = plan.followUps;
      _askFollowUp();
    } else {
      _answers.isEmpty ? _askMedicine() : _askSince();
    }
  }

  void _askFollowUp() {
    final question = _followUps[_current].question;
    _say((_) => question);
    _reply.clear();
    _go(_Stage.followUp);
  }

  /// [choice] is a tapped option; null takes what was typed or spoken.
  void _answerFollowUp([int? choice]) {
    FocusScope.of(context).unfocus();
    final followUp = _followUps[_current];
    final option = choice == null ? null : followUp.options[choice];
    final text = (option?.text ?? _reply.text).trim();
    if (text.isNotEmpty) {
      _intake.add(
        IntakeAnswer(
          question: followUp.question,
          answer: text,
          id: followUp.id,
          choice: choice,
        ),
      );
      _say((_) => text, ai: false);
    }
    switch (option?.urgency) {
      case Urgency.emergency:
        _say((l) => l.urgentAnswer, urgent: true);
      case Urgency.selfHarm:
        _say((l) => l.urgentSelfHarm, urgent: true);
      case Urgency.none || null:
        break;
    }
    _current++;
    if (_current < _followUps.length) return _askFollowUp();
    _say((l) => l.askAnythingElse);
    _go(_Stage.extra);
  }

  void _askSince() {
    final s = _now.symptom;
    _say((l) => l.askSince(l.symptomLabel(s)));
    _go(_Stage.since);
  }

  void _answerSince(SymptomSince v) {
    _now.since = v;
    _say((l) => l.sinceLabel(v), ai: false);
    final s = _now.symptom;
    _say((l) => l.askSeverity(l.symptomLabel(s)));
    _go(_Stage.severity);
  }

  void _answerSeverity(Severity v) {
    _now.severity = v;
    _say((l) => l.severityLabel(v), ai: false);
    if (_now.isUrgent) _say((l) => l.urgentWarning, urgent: true);
    _current++;
    _current < _answers.length ? _askSince() : _askMedicine();
  }

  void _askMedicine() {
    _say((l) => l.askNewMedicine);
    _go(_Stage.medicine);
  }

  void _answerMedicine(YesNoUnsure v) {
    _newMedicine = switch (v) {
      YesNoUnsure.yes => true,
      YesNoUnsure.no => false,
      YesNoUnsure.unsure => null,
    };
    _say((l) => v.label(l), ai: false);
    _say((l) => l.askAnythingElse);
    _go(_Stage.extra);
  }

  Future<void> _finish() async {
    FocusScope.of(context).unfocus();
    final extra = _extra.text.trim();
    if (extra.isNotEmpty) _say((_) => extra, ai: false);
    _go(_Stage.thinking);

    final patient = CareScope.of(context).selectedPatient;
    if (patient == null) return;
    final run = _run;
    final suggestion = await _assistant.suggestQuestions(
      patient: patient,
      answers: PrepAnswers(
        symptoms: _answers,
        description: _describe.text.trim(),
        newMedicine: _newMedicine,
        extraNote: extra,
        intake: _intake,
      ),
      language: LanguageScope.of(context).value,
    );
    if (!mounted || run != _run) return;
    _questions = suggestion.questions;
    _byAi = suggestion.byAi;
    _say((l) => _byAi ? l.prepResultIntroAi : l.prepResultIntro);
    _go(_Stage.result);
  }

  void _save() {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final prep = repo.savePrep(
      (id, patientId) => VisitPrep(
        id: id,
        patientId: patientId,
        createdAt: DateTime.now(),
        symptoms: _answers,
        description: _describe.text.trim(),
        newMedicine: _newMedicine,
        extraNote: _extra.text.trim(),
        intake: _intake,
        questions: _questions,
      ),
    );
    if (prep == null) return;
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PrepQuestionsPage(prepId: prep.id)),
    );
    messenger.showSnackBar(SnackBar(content: Text(l.questionsSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return GurtuPage(
      title: l.prepTitle,
      controller: _scroll,
      actions: [
        if (_stage != _Stage.symptoms)
          TextButton.icon(
            onPressed: () => setState(_start),
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: Text(l.startAgain),
            style: TextButton.styleFrom(
              foregroundColor: GurtuColors.primary,
              minimumSize: const Size(48, 48),
            ),
          ),
      ],
      bottom: switch (_stage) {
        _Stage.symptoms => GurtuButton(
          label: l.continueLabel,
          icon: Icons.arrow_forward_rounded,
          onPressed: _picked.isEmpty && _describe.text.trim().isEmpty
              ? null
              : _submitSymptoms,
        ),
        _Stage.followUp => GurtuButton(
          label: _reply.text.trim().isEmpty ? l.skip : l.continueLabel,
          icon: Icons.arrow_forward_rounded,
          onPressed: _answerFollowUp,
        ),
        _Stage.extra => GurtuButton(
          label: _extra.text.trim().isEmpty ? l.skip : l.done,
          icon: Icons.auto_awesome_rounded,
          onPressed: _finish,
        ),
        _Stage.result => GurtuButton(
          label: l.saveQuestions,
          icon: Icons.check_rounded,
          onPressed: _questions.isEmpty ? null : _save,
        ),
        _ => null,
      },
      children: [
        for (final m in _msgs) ...[
          _Bubble(message: m),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 6),
        _composer(l),
      ],
    );
  }

  Widget _composer(AppLocalizations l) {
    final t = Theme.of(context).textTheme;
    return switch (_stage) {
      _Stage.symptoms => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.prepPickOrSay, style: t.bodyMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in Symptom.values)
                GurtuChip(
                  label: l.symptomLabel(s),
                  icon: s.icon,
                  selected: _picked.contains(s),
                  onTap: () => setState(
                    () => _picked.contains(s)
                        ? _picked.remove(s)
                        : _picked.add(s),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          DictationField(
            controller: _describe,
            hint: l.prepDescribeHint,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      _Stage.followUp => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Options(
            options: [
              for (final (i, o) in _followUps[_current].options.indexed)
                (o.text, () => _answerFollowUp(i)),
            ],
          ),
          DictationField(
            controller: _reply,
            hint: l.prepReplyHint,
            minLines: 1,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      _Stage.since => _Options(
        options: [
          for (final v in SymptomSince.values)
            (l.sinceLabel(v), () => _answerSince(v)),
        ],
      ),
      _Stage.severity => _Options(
        options: [
          for (final v in Severity.values)
            (l.severityLabel(v), () => _answerSeverity(v)),
        ],
      ),
      _Stage.medicine => _Options(
        options: [
          for (final v in YesNoUnsure.values)
            (v.label(l), () => _answerMedicine(v)),
        ],
      ),
      _Stage.extra => DictationField(
        controller: _extra,
        hint: l.noteHint,
        onChanged: (_) => setState(() {}),
      ),
      _Stage.understanding => _Typing(text: l.prepUnderstanding),
      _Stage.thinking => _Typing(text: l.prepThinking),
      _Stage.result => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_intake.isNotEmpty) ...[
            TellDoctorCard(
              symptoms: [for (final a in _answers) a.symptom],
              said: _describe.text.trim(),
              intake: _intake,
              note: _extra.text.trim(),
            ),
            const SizedBox(height: 16),
          ],
          _SourceNote(byAi: _byAi),
          const SizedBox(height: 10),
          QuestionList(
            questions: _questions,
            onRemove: (q) => setState(() => _questions.remove(q)),
          ),
          const SizedBox(height: 16),
          AddQuestionField(onAdd: (q) => setState(() => _questions.add(q))),
          const SizedBox(height: 16),
          InfoBanner(text: l.prepNotDoctor, icon: Icons.verified_user_rounded),
          if (!_byAi && _offerAi) ...[
            const SizedBox(height: 16),
            Text(l.aiSetUpForPrep, style: t.bodyMedium),
            const SizedBox(height: 10),
            const AiStatusCard(showRemove: false),
          ],
        ],
      ),
    };
  }

  /// Worth suggesting Gurtu AI: this phone can run it and it isn't ready yet.
  bool get _offerAi {
    final status = AiScope.of(context).status;
    return status != AiStatus.unsupported && status != AiStatus.installed;
  }
}

/// Where the questions came from, so nobody mistakes them for a doctor's.
class _SourceNote extends StatelessWidget {
  const _SourceNote({required this.byAi});

  final bool byAi;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          byAi ? Icons.auto_awesome_rounded : Icons.menu_book_rounded,
          size: 16,
          color: byAi ? GurtuColors.amber : GurtuColors.textMuted,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            byAi ? l.prepByAi : l.prepByRules,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final _Msg message;

  @override
  Widget build(BuildContext context) {
    final text = message.text(context.l10n);
    if (!message.fromAi) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.8,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
    final urgent = message.urgent;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: urgent ? null : GurtuColors.primaryGradient,
            color: urgent ? GurtuColors.danger : null,
          ),
          child: Icon(
            urgent ? Icons.warning_rounded : Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: urgent
                  ? GurtuColors.danger.withValues(alpha: 0.08)
                  : GurtuColors.surface,
              border: Border.all(
                color: urgent
                    ? GurtuColors.danger.withValues(alpha: 0.4)
                    : GurtuColors.outline,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: urgent ? GurtuColors.danger : GurtuColors.textPrimary,
                fontSize: 16,
                height: 1.35,
                fontWeight: urgent ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One-tap answers, stacked full width so long translations fit.
class _Options extends StatelessWidget {
  const _Options({required this.options});

  final List<(String, VoidCallback)> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (label, onTap) in options) ...[
          GurtuButton(
            label: label,
            style: GurtuButtonStyle.ghost,
            onPressed: onTap,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _Typing extends StatelessWidget {
  const _Typing({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: GurtuColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
