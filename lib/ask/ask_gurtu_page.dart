import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ai/on_device_ai.dart';
import '../ai/visit_assistant.dart';
import '../data/care_models.dart';
import '../data/care_repository.dart';
import '../data/medicine_models.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../medicines/medicine_text.dart';
import '../memory/knowledge.dart';
import '../memory/memory_page.dart';
import '../theme/gurtu_theme.dart';
import '../visits/visit_text.dart';
import '../widgets/ai_status.dart';
import '../widgets/voice_input.dart';

class _Turn {
  const _Turn(
    this.text, {
    this.fromUser = false,
    this.sources = const [],
    this.urgent = false,
  });

  final String text;
  final bool fromUser;
  final List<KnowledgeDoc> sources;
  final bool urgent;
}

/// Ask Gurtu: questions about the person's care, answered by Gurtu AI (Gemma,
/// on the phone) from what is saved in their memory — reports, notes,
/// visits, medicines — with the sources one tap away. Without Gurtu AI it
/// shows what the memory search found.
class AskGurtuPage extends StatefulWidget {
  const AskGurtuPage({super.key, this.question, this.onQuestionTaken});

  /// Asked from Home: sent as soon as the tab opens.
  final String? question;
  final VoidCallback? onQuestionTaken;

  @override
  State<AskGurtuPage> createState() => _AskGurtuPageState();

  static String systemPrompt(PatientProfile p, AppLanguage language) =>
      'You are Gurtu, a warm and practical care assistant on the phone of '
      'an Indian family looking after ${p.name}. You are given what the '
      'family saved about ${p.name}: their profile, medicines, their full '
      'history of doctor visits, notes and reports.\n'
      'How to answer:\n'
      '- Use the saved information whenever it helps, and mention the '
      'specific details (medicine names and times, dates, test values, what '
      'the doctor said).\n'
      '- Use the visit history: say which visit something is from, and '
      'point out what changed between visits (medicines started or '
      'stopped, advice, test results, how often they go).\n'
      '- If the question asks for a specific fact (a date, a value, what a '
      'report or the doctor said) that is not in the saved information, say '
      'plainly that it is not saved yet and what to save. Never make up '
      'facts.\n'
      '- For practical questions (what to ask the doctor, how to prepare for '
      'a visit, how to manage medicines, what to watch for), give useful, '
      'specific suggestions based on ${p.name}\'s conditions, medicines and '
      'recent notes. Well-known general care advice is fine.\n'
      '- Never diagnose. Never tell anyone to start, stop or change a '
      'medicine or its dose: say to check with the doctor.\n'
      '- If something sounds urgent (chest pain, breathlessness, fainting, '
      'signs of stroke, heavy bleeding), say to get medical help now or call '
      '108.\n'
      'Reply in ${language.englishName}, warmly and simply: 2 to 5 short '
      'sentences, or up to 5 short numbered points. Plain text only: no '
      'markdown, no asterisks, no headings.';

  /// Everything Gurtu AI is told for one question: a short overview of the
  /// person (always), the saved items that match, and the chat so far.
  static String buildPrompt({
    required String question,
    required PatientProfile patient,
    required CareRepository repo,
    required List<KnowledgeDoc> related,
    List<(String, String)> history = const [],
    DateTime? now,
  }) {
    final en = lookupAppLocalizations(const Locale('en'));
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    String day(DateTime d) {
      const names = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      final date = DateUtils.dateOnly(d);
      final diff = date.difference(today).inDays;
      final when = switch (diff) {
        0 => ' (today)',
        1 => ' (tomorrow)',
        -1 => ' (yesterday)',
        _ => '',
      };
      return '${names[date.weekday - 1]} ${date.year}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}$when';
    }

    String cut(String text, int max) {
      final t = text.trim().replaceAll(RegExp(r'\n{2,}'), '\n');
      return t.length <= max ? t : '${t.substring(0, max)}…';
    }

    final id = patient.id;
    final out = StringBuffer()
      ..writeln('Today is ${day(today)}.')
      ..writeln()
      ..writeln('ABOUT ${patient.name.toUpperCase()}');
    final profile = profileKnowledge(patient, en, userName: repo.userName);
    out
      ..writeln(profile.text)
      ..writeln();

    final medicines = [
      for (final m in repo.medicines)
        if (m.patientId == id)
          '- ${m.label}: '
              '${m.times.isEmpty ? 'times not set' : m.times.map(en.doseLabel).join(', ')}'
              '${m.food == FoodTiming.any ? '' : ', ${en.foodLabel(m.food).toLowerCase()}'}',
    ];
    out
      ..writeln('MEDICINES ON THEIR LIST')
      ..writeln(medicines.isEmpty ? '(none saved)' : medicines.join('\n'))
      ..writeln();

    final visits = [
      for (final v in repo.visits)
        if (v.patientId == id) v,
    ]..sort((a, b) => b.date.compareTo(a.date));
    final upcoming = [
      for (final v in visits)
        if (v.nextVisit case final next? when !next.isBefore(today)) next,
    ]..sort();
    // Every visit, newest first: the latest ones (and any the question is
    // about) in full, older ones in a line each, within a budget that leaves
    // the model room to answer.
    out.writeln('DOCTOR VISIT HISTORY (${visits.length} saved, newest first)');
    if (upcoming.isNotEmpty) out.writeln('Next visit: ${day(upcoming.first)}');
    if (visits.isEmpty) out.writeln('(none saved)');
    final inFull = {
      for (final v in visits.take(3)) v.id,
      for (final d in related) ?d.visitId,
    };
    // The ones in full are always kept; one-line visits fill what's left,
    // newest first. Shown in date order either way.
    // Keyed by the visit itself: ids made in the same instant can repeat.
    final entries = Map<DoctorVisit, String>.identity();
    for (final v in visits) {
      if (inFull.contains(v.id)) {
        entries[v] = _visitInFull(v, repo, en, day, cut);
      }
    }
    var budget = 3200 - entries.values.fold(0, (sum, e) => sum + e.length);
    for (final v in visits) {
      if (entries.containsKey(v)) continue;
      final entry = _visitInBrief(v, en, day, cut);
      if (entry.length > budget) break;
      entries[v] = entry;
      budget -= entry.length;
    }
    for (final v in visits) {
      if (entries[v] case final entry?) out.writeln(entry);
    }
    final left = visits.length - entries.length;
    if (left > 0) out.writeln('(and $left older visits)');
    out.writeln();

    // Questions saved for the doctor and not asked yet.
    final open = [
      for (final prep in repo.preps)
        if (prep.patientId == id && !prep.isUsed)
          for (final q in prep.questions)
            if (!q.asked) en.questionText(q),
    ];
    if (open.isNotEmpty) {
      out
        ..writeln('QUESTIONS ALREADY SAVED FOR THE DOCTOR')
        ..writeln([for (final q in open.take(6)) '- $q'].join('\n'))
        ..writeln();
    }

    final shown = {for (final d in related) d.momentId};
    final recent = [
      for (final m in repo.moments)
        if (m.patientId == id && !m.isSample && !shown.contains(m.id)) m,
    ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    if (recent.isNotEmpty) {
      out.writeln('RECENT NOTES');
      for (final m in recent.take(4)) {
        final title = m.title.isEmpty ? '' : '${m.title}: ';
        final gist = m.summary.trim().isNotEmpty ? m.summary : m.detail;
        out.writeln('- ${day(m.timestamp)}: $title${cut(gist, 160)}');
      }
      out.writeln();
    }

    // Visits are in the history above already.
    final items = [
      for (final d in related)
        if (d.visitId == null) d,
    ];
    if (items.isNotEmpty) {
      out.writeln('SAVED ITEMS THAT MATCH THE QUESTION');
      for (final (i, d) in items.indexed) {
        out.writeln(
          '[${i + 1}] ${d.title} (${day(d.date)})\n${cut(d.text, 500)}',
        );
      }
      out.writeln();
    }

    if (history.isNotEmpty) {
      out.writeln('EARLIER IN THIS CHAT');
      for (final (q, a) in history) {
        out
          ..writeln('Family: ${cut(q, 200)}')
          ..writeln('Gurtu: ${cut(a, 300)}');
      }
      out.writeln();
    }
    out.write('QUESTION FROM THE FAMILY: $question');
    return out.toString();
  }

  /// One visit with everything saved about it.
  static String _visitInFull(
    DoctorVisit v,
    CareRepository repo,
    AppLocalizations en,
    String Function(DateTime) day,
    String Function(String, int) cut,
  ) {
    final reason = en.reasonOf(v);
    final medicines = [
      for (final m in v.medicines)
        if (m.note.trim().isNotEmpty) cut(m.note, 120),
    ];
    final asked = [
      for (final prep in repo.preps)
        if (prep.visitId == v.id)
          for (final q in prep.questions)
            if (q.asked) en.questionText(q),
    ];
    final recordings = v.attachments
        .where((a) => a.kind == AttachmentKind.audio)
        .length;
    final photos = v.attachments
        .where((a) => a.kind == AttachmentKind.photo)
        .length;
    return [
      '- ${day(v.date)}, ${en.doctorLabel(v)}'
          '${reason.isEmpty ? '' : ', for $reason'}',
      if (en.notesOf(v).trim().isNotEmpty)
        '  Doctor said: ${cut(en.notesOf(v), 450)}',
      if (medicines.isNotEmpty)
        '  Medicines given: ${medicines.join('; ')}'
      else if (en.medicinesOf(v).trim().isNotEmpty)
        '  Medicines given: ${cut(en.medicinesOf(v), 250)}',
      if (en.testsOf(v).trim().isNotEmpty)
        '  Tests: ${cut(en.testsOf(v), 200)}',
      if (v.nextVisit case final next?) '  Asked to come back: ${day(next)}',
      if (asked.isNotEmpty)
        '  Questions asked at this visit: ${cut(asked.join('; '), 300)}',
      if (recordings + photos > 0)
        '  Kept with it: $recordings voice recording(s), $photos photo(s)',
    ].join('\n');
  }

  /// An older visit, in one line.
  static String _visitInBrief(
    DoctorVisit v,
    AppLocalizations en,
    String Function(DateTime) day,
    String Function(String, int) cut,
  ) {
    final reason = en.reasonOf(v);
    final said = [
      en.notesOf(v),
      en.medicinesOf(v),
    ].where((s) => s.trim().isNotEmpty).join(' | ');
    return '- ${day(v.date)}, ${en.doctorLabel(v)}'
        '${reason.isEmpty ? '' : ', for $reason'}'
        '${said.isEmpty ? '' : ': ${cut(said, 140)}'}';
  }

  /// The model's reply as plain text: no markdown marks or headings.
  static String cleanAnswer(String answer) {
    final lines = [
      for (var line in answer.trim().split('\n'))
        if ((line = line
                .replaceAll('**', '')
                .replaceAll('__', '')
                .replaceFirst(RegExp(r'^\s*#+\s*'), '')
                .replaceFirst(RegExp(r'^\s*[*•-]\s+'), '• ')
                .trimRight())
            case final l)
          l,
    ];
    return lines.join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
  }
}

class _AskGurtuPageState extends State<AskGurtuPage> {
  final _text = TextEditingController();
  final _scroll = ScrollController();
  final _turns = <_Turn>[];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _takeQuestion();
  }

  @override
  void didUpdateWidget(AskGurtuPage old) {
    super.didUpdateWidget(old);
    if (widget.question != old.question) _takeQuestion();
  }

  void _takeQuestion() {
    final q = widget.question;
    if (q == null || q.trim().isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onQuestionTaken?.call();
      if (mounted) _ask(q);
    });
  }

  @override
  void dispose() {
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _add(_Turn t) {
    setState(() => _turns.add(t));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _ask(String question) async {
    final q = question.trim();
    if (q.isEmpty || _busy) return;
    final l = context.l10n;
    final repo = CareScope.of(context);
    final knowledge = KnowledgeScope.read(context)..l = l;
    final ai = AiScope.read(context);
    final language = LanguageScope.of(context).value;
    final patient = repo.selectedPatient;
    _text.clear();
    HapticFeedback.selectionClick();
    _add(_Turn(q, fromUser: true));
    setState(() => _busy = true);

    // Warning signs come first, whatever the memory says.
    final urgent = const LocalVisitAssistant()
        .detectSymptoms(q, l.symptomKeywords)
        .any((s) => s.isRedFlag);
    if (urgent) _add(_Turn(l.urgentAnswer, urgent: true));

    final hits = await knowledge.search(q, patient?.id, limit: 10);
    // Shown under the answer: the saved items that really match.
    final sources = [
      for (final h in hits)
        if (h.score >= 0.25) h.doc,
    ].take(5).toList();
    // Given to Gurtu AI: a little more, as it may help.
    final related = [
      for (final h in hits)
        if (h.score >= 0.15 &&
            h.doc.kind != KnowledgeKind.profile &&
            h.doc.kind != KnowledgeKind.medicine)
          h.doc,
    ].take(5).toList();
    // The last exchanges, so a follow-up ("and the evening one?") makes
    // sense.
    final history = _history(exclude: q);
    if (!mounted) return;

    if (ai.isReady && patient != null) {
      try {
        final answer = await ai.generate(
          system: AskGurtuPage.systemPrompt(patient, language),
          prompt: AskGurtuPage.buildPrompt(
            question: q,
            patient: patient,
            repo: repo,
            related: related,
            history: history,
          ),
          maxOutputTokens: 450,
          timeout: const Duration(seconds: 90),
        );
        if (!mounted) return;
        final text = AskGurtuPage.cleanAnswer(answer);
        _add(_Turn(text.isEmpty ? l.askFailed : text, sources: sources));
      } on Object catch (e) {
        debugPrint('Ask Gurtu failed: $e');
        if (!mounted) return;
        _add(
          _Turn(
            sources.isEmpty ? l.askNothingFound : l.askFailed,
            sources: sources,
          ),
        );
      }
    } else {
      _add(
        _Turn(
          sources.isEmpty ? l.askNothingFound : l.askFoundInMemory,
          sources: sources,
        ),
      );
    }
    if (mounted) setState(() => _busy = false);
  }

  /// Earlier questions and answers in this chat (newest last), without
  /// the one being asked now.
  List<(String, String)> _history({required String exclude}) {
    final pairs = <(String, String)>[];
    for (var i = 0; i + 1 < _turns.length; i++) {
      final a = _turns[i];
      final b = _turns[i + 1];
      if (a.fromUser && !b.fromUser && !b.urgent) pairs.add((a.text, b.text));
    }
    return pairs.length <= 2 ? pairs : pairs.sublist(pairs.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final ai = AiScope.of(context);
    final name = CareScope.of(context).selectedPatient?.name ?? '';
    final examples = [
      l.askExampleBloodTest,
      l.askExampleMedicines,
      l.askExampleReport,
      l.askExampleDoctor,
    ];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(GurtuSpace.gutter, 16, 8, 0),
            child: Row(
              children: [
                Expanded(child: Text(l.askGurtuTitle, style: t.headlineMedium)),
                if (_turns.isNotEmpty)
                  IconButton(
                    tooltip: l.askNewChat,
                    onPressed: _busy ? null : () => setState(_turns.clear),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(
                GurtuSpace.gutter,
                8,
                GurtuSpace.gutter,
                16,
              ),
              children: [
                Text(l.askGurtuNote, style: t.bodyLarge),
                const SizedBox(height: 16),
                if (_turns.isEmpty) ...[
                  if (!ai.isReady && ai.status != AiStatus.unsupported) ...[
                    const AiStatusCard(showRemove: false),
                    const SizedBox(height: 16),
                  ],
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final e in examples)
                        ActionChip(
                          avatar: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18,
                            color: GurtuColors.primary,
                          ),
                          label: Text(e),
                          onPressed: () => _ask(e),
                        ),
                    ],
                  ),
                ],
                for (final turn in _turns) _Bubble(turn: turn),
                if (_busy)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: GurtuColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(l.askThinking(name), style: t.bodyMedium),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(GurtuSpace.gutter, 8, 12, 8),
            decoration: const BoxDecoration(
              color: GurtuColors.surface,
              border: Border(top: BorderSide(color: GurtuColors.outline)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: DictationField(
                    controller: _text,
                    hint: l.askHint,
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: IconButton.filled(
                    tooltip: l.send,
                    style: IconButton.styleFrom(
                      backgroundColor: GurtuColors.primary,
                    ),
                    onPressed: _busy || _text.text.trim().isEmpty
                        ? null
                        : () => _ask(_text.text),
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
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

class _Bubble extends StatelessWidget {
  const _Bubble({required this.turn});

  final _Turn turn;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final user = turn.fromUser;
    final color = user
        ? null
        : turn.urgent
        ? GurtuColors.danger.withValues(alpha: 0.08)
        : GurtuColors.surface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: user
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.85,
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: user ? GurtuColors.primaryGradient : null,
                color: color,
                border: user
                    ? null
                    : Border.all(
                        color: turn.urgent
                            ? GurtuColors.danger
                            : GurtuColors.outline,
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(user ? 18 : 4),
                  bottomRight: Radius.circular(user ? 4 : 18),
                ),
              ),
              child: SelectableText(
                turn.text,
                style: user
                    ? const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )
                    : t.bodyLarge,
              ),
            ),
          ),
          if (turn.sources.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(l.askSources, style: t.labelSmall),
            const SizedBox(height: 6),
            for (final d in turn.sources)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: KnowledgeTile(
                  doc: d,
                  onTap: () => openKnowledge(context, d),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
