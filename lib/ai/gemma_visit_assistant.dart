import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../data/care_models.dart';
import '../data/visit_models.dart';
import '../l10n/language.dart';
import '../onboarding/onboarding_state.dart';
import '../visits/visit_text.dart';
import 'on_device_ai.dart';
import 'visit_assistant.dart';
import 'visit_knowledge.dart';

/// "Prepare for the doctor" on the on-device model.
///
/// The model writes both conversations for this patient: the follow-ups it
/// asks the family, from exactly what they said, and the questions to ask
/// the doctor, from everything it learned. The reviewed bank in
/// `visit_knowledge.dart` is its source of ideas, and the safety net code
/// keeps no matter what the model writes: the danger-sign check for every
/// symptom (with its urgent answers), one question per topic, "which warning
/// signs mean hospital", no doses, and the right voice for a caregiver.
///
/// Whenever the model is missing, slow or its answer doesn't pass the checks,
/// the bank is used without it (English) or [LocalVisitAssistant] (other
/// languages), so the feature always works.
class GemmaVisitAssistant extends VisitAssistant {
  const GemmaVisitAssistant(
    this.ai, {
    this.fallback = const LocalVisitAssistant(),
  });

  final GurtuAi ai;
  final LocalVisitAssistant fallback;

  /// Follow-ups the model writes itself, besides the danger checks.
  static const _maxOwnFollowUps = 4;
  static const _maxFollowUps = 5;
  static const _pickAsks = 8;
  static const _minAsks = 5;
  static const _maxAsks = 10;

  @override
  Set<Symptom> detectSymptoms(
    String text,
    Map<Symptom, List<String>> keywords,
  ) => fallback.detectSymptoms(text, keywords);

  // --- Step 1: follow-ups while preparing -------------------------------------

  @override
  Future<IntakePlan?> planIntake({
    required PatientProfile patient,
    required Set<Symptom> picked,
    required String description,
    required Map<Symptom, List<String>> keywords,
    required AppLanguage language,
  }) async {
    if (!ai.isReady) return null;
    final symptoms = {...picked, ...detectSymptoms(description, keywords)};
    var medicineChanged = false;
    if (description.trim().length >= 3) {
      final heard = await _understand(description);
      symptoms.addAll(heard.symptoms);
      medicineChanged = heard.medicineChanged;
    }
    final pool = [
      for (final q in generalIntake)
        // Already told: no need to ask about a medicine change.
        if (!(medicineChanged && q.id == 'g_medicine')) q,
      for (final s in Symptom.values)
        if (symptoms.contains(s)) ...?symptomIntake[s],
    ];
    // Every danger check for these problems is always asked: its answers
    // carry the urgency that tells the family to get help now.
    final danger = [
      for (final q in pool)
        if (q.danger) q.id,
    ];
    final english = language == AppLanguage.english;

    var written = <FollowUp>[];
    try {
      final reply = await ai.generate(
        system: _intakeSystem(language, patient),
        prompt: [
          _about(patient),
          '',
          if (description.isNotEmpty) 'What they said: """$description"""',
          if (symptoms.isNotEmpty) 'Problems: ${_labels(symptoms)}',
          if (medicineChanged)
            'A medicine was started, stopped or changed recently: yes',
          '',
          if (danger.isNotEmpty) ...[
            'Safety checks (include every one, with its id and its options '
                'in the same order):',
            for (final q in pool)
              if (q.danger) _bankLine(q),
            '',
          ],
          'Questions doctors often find useful (ideas only; reuse one by its '
              'id, reworded for this patient, only if it fits):',
          for (final q in pool)
            if (!q.danger) _bankLine(q),
        ].join('\n'),
        maxOutputTokens: english ? 500 : 1000,
        timeout: const Duration(seconds: 75),
      );
      written = _writtenFollowUps(_json(reply)?['followUps'], pool, language);
    } on Object catch (e) {
      debugPrint('Gurtu AI intake: $e');
    }

    final own = written.where((f) => !danger.contains(f.id)).toList();
    if (own.isEmpty) {
      debugPrint('Gurtu AI intake: nothing usable, using the built-in ones');
      // Bank questions would be in English: other languages use the app's
      // own translated questions instead.
      if (!english) return null;
      final must = [
        if (!_mentionsTime(description)) 'g_onset',
        ...danger,
        'g_tried',
      ];
      return IntakePlan(
        symptoms: symptoms,
        medicineChanged: medicineChanged,
        followUps: [
          for (final q in _pickFollowUps(const [], pool, must, symptoms))
            FollowUp(id: q.id, question: q.text, options: q.options),
        ],
      );
    }

    // The model's order, its own questions kept short, every danger check.
    final room = (_maxFollowUps - danger.length).clamp(2, _maxOwnFollowUps);
    var kept = 0;
    final followUps = [
      for (final f in written)
        if (danger.contains(f.id) || kept++ < room) f,
    ];
    final missing = [
      for (final q in pool)
        if (q.danger && !followUps.any((f) => f.id == q.id)) q,
    ];
    if (missing.isNotEmpty) {
      final translated = english
          ? const <String, FollowUp>{}
          : await _translate(missing, language);
      // Right after the first question: asked early, without opening the
      // conversation with them. Untranslated, a danger check is still asked.
      followUps.insertAll(1, [
        for (final q in missing)
          translated[q.id] ??
              FollowUp(id: q.id, question: q.text, options: q.options),
      ]);
    }
    return IntakePlan(
      symptoms: symptoms,
      medicineChanged: medicineChanged,
      followUps: followUps,
    );
  }

  static String _bankLine(IntakeQuestion q) =>
      '- ${q.id}: ${q.text} Options: '
      '${q.options.map((o) => o.text).join(' | ')}';

  /// The follow-ups as the model wrote them, in its order. A bank question
  /// it reused keeps the bank's options one for one, so a tap still maps to
  /// the bank's answer and its urgency; one of its own gets an `ai_` id.
  static List<FollowUp> _writtenFollowUps(
    Object? raw,
    List<IntakeQuestion> pool,
    AppLanguage language,
  ) {
    final english = language == AppLanguage.english;
    final byId = {for (final q in pool) q.id: q};
    final out = <FollowUp>[];
    final seen = <String>{};
    for (final item in raw is List ? raw : const []) {
      if (item is! Map) continue;
      final bank = byId['${item['id']}'.trim()];
      if (bank != null && out.any((f) => f.id == bank.id)) continue;
      final text = english
          ? _clean(item['question'], max: 160)
          : _translation(item['question'], max: 200);
      final options = _options(item['options'], english);
      final usable =
          text.length >= 8 &&
          options.every((o) => o.isNotEmpty) &&
          _inLanguage('$text ${options.join(' ')}', language);

      if (bank != null) {
        final same =
            usable &&
            options.length == bank.options.length &&
            // A reworded danger check must still ask about the same signs.
            (!english || !bank.danger || _keepsMeaning(text, bank.text));
        if (same) {
          out.add(
            FollowUp(
              id: bank.id,
              question: text,
              options: [
                for (final (i, o) in bank.options.indexed)
                  AnswerOption(options[i], o.urgency),
              ],
            ),
          );
        } else if (english) {
          out.add(
            FollowUp(id: bank.id, question: bank.text, options: bank.options),
          );
        }
        // Other languages: left out, to be translated again if it must be
        // asked.
        continue;
      }

      if (!usable ||
          options.length < 2 ||
          options.length > 5 ||
          options.toSet().length != options.length ||
          !seen.add(_key(text))) {
        continue;
      }
      out.add(
        FollowUp(
          id: 'ai_${out.length}',
          question: text,
          options: [for (final o in options) AnswerOption(o)],
        ),
      );
    }
    return out;
  }

  /// Answer options, sometimes written as one "a | b | c" string. An option
  /// that doesn't pass the checks stays in the list as ''.
  static List<String> _options(Object? raw, bool english) => [
    for (final o in raw is String ? raw.split('|') : raw as List? ?? const [])
      english
          ? _clean(o is String ? o.trim() : o, max: 50)
          : _translation(o is String ? o.trim() : o, max: 50),
  ];

  /// Keeps most of the words that carry [original]'s meaning.
  static bool _keepsMeaning(String text, String original) {
    final kept = _keyWords(original);
    final lost = kept.difference(_words(text).toSet());
    return lost.length <= kept.length * 0.3;
  }

  /// Mostly in [language]'s script: Latin for English, anything else for the
  /// Indian languages.
  static bool _inLanguage(String text, AppLanguage language) {
    final letters = RegExp(r'\p{L}', unicode: true).allMatches(text).length;
    if (letters == 0) return false;
    final latin = RegExp('[A-Za-z]').allMatches(text).length;
    return language == AppLanguage.english
        ? latin * 2 >= letters
        : latin * 2 < letters;
  }

  /// For spotting the same question twice.
  static String _key(String text) => text.toLowerCase().replaceAll(
    RegExp(r'[^\p{L}\p{N}]', unicode: true),
    '',
  );

  /// Translates bank follow-ups the first pass left out, so the chat never
  /// switches language. Whatever still fails stays in English.
  Future<Map<String, FollowUp>> _translate(
    List<IntakeQuestion> questions,
    AppLanguage language,
  ) async {
    try {
      final reply = await ai.generate(
        system:
            'Translate each question and all of its options into '
            '${language.englishName}, in simple everyday words. Keep the same '
            'ids, and the same number and order of options. Do not add the '
            'English in brackets.\n'
            'Reply with only this JSON and nothing else:\n'
            '{"followUps": [{"id": "...", "question": "...", "options": ["..."]}]}',
        prompt: [
          for (final q in questions)
            '- ${q.id}: ${q.text} Options: '
                '${q.options.map((o) => o.text).join(' | ')}',
        ].join('\n'),
        maxOutputTokens: 500,
        timeout: const Duration(seconds: 40),
      );
      return _translatedFollowUps(_json(reply)?['followUps'], questions);
    } on Object catch (e) {
      debugPrint('Gurtu AI translate: $e');
      return {};
    }
  }

  static final _time = RegExp(
    r'\d|\b(today|yesterday|since|ago|hours?|'
    r'days?|weeks?|months?|years?|kal|aaj|din|dino|hafte|hafta|mahine|saal)\b|'
    r'आज|कल|दिन|हफ्त|महीन|साल',
    caseSensitive: false,
  );

  static bool _mentionsTime(String description) => _time.hasMatch(description);

  /// Symptom ids from the family's own words, in any language, and whether
  /// they said a medicine changed.
  Future<({Set<Symptom> symptoms, bool medicineChanged})> _understand(
    String description,
  ) async {
    try {
      final reply = await ai.generate(
        system: _symptomSystem,
        prompt: '${_symptomList()}\n\nWhat they said:\n"""$description"""',
        maxOutputTokens: 100,
        timeout: const Duration(seconds: 40),
      );
      final j = _json(reply);
      final names = Symptom.values.asNameMap();
      return (
        symptoms: {
          for (final id in j?['symptoms'] as List? ?? const [])
            ?names['$id'.trim()],
        },
        medicineChanged: j?['medicineChanged'] == true,
      );
    } on Object catch (e) {
      debugPrint('Gurtu AI symptoms: $e');
      return (symptoms: <Symptom>{}, medicineChanged: false);
    }
  }

  /// The model's choice, in its order, with every danger check added and
  /// the list kept short. Without a usable choice: a sensible default order.
  static List<IntakeQuestion> _pickFollowUps(
    List<String> ids,
    List<IntakeQuestion> pool,
    List<String> must,
    Set<Symptom> symptoms,
  ) {
    final byId = {for (final q in pool) q.id: q};
    var order = [
      for (final id in {...ids})
        if (byId.containsKey(id)) id,
    ];
    if (order.isEmpty) {
      order = [
        'g_onset',
        ...must,
        for (final s in Symptom.values)
          if (symptoms.contains(s))
            ?symptomIntake[s]!.where((q) => !q.danger).firstOrNull?.id,
        'g_tried',
      ];
    }
    // Danger checks go right after the first question, so they are asked
    // early without opening the conversation with them.
    final missing = must.where((id) => !order.contains(id)).toList();
    order.insertAll(order.isEmpty ? 0 : 1, missing);
    // Room for at least one question chosen for this problem.
    final room = _maxFollowUps > must.length ? _maxFollowUps : must.length + 1;
    final kept = <String>[];
    for (final id in order) {
      if (kept.length < room || must.contains(id)) kept.add(id);
    }
    // Over the limit only because of danger checks: drop other questions.
    while (kept.length > room) {
      final i = kept.lastIndexWhere((id) => !must.contains(id));
      if (i < 0) break;
      kept.removeAt(i);
    }
    return [
      for (final id in {...kept}) byId[id]!,
    ];
  }

  /// Translations that keep the bank's options one for one. Anything else is
  /// left out, to be translated again or shown in the bank's own words.
  static Map<String, FollowUp> _translatedFollowUps(
    Object? raw,
    List<IntakeQuestion> pool,
  ) {
    final byId = {for (final q in pool) q.id: q};
    final out = <String, FollowUp>{};
    for (final item in raw is List ? raw : const []) {
      if (item is! Map) continue;
      final q = byId['${item['id']}'.trim()];
      if (q == null || out.containsKey(q.id)) continue;
      final text = _translation(item['question'], max: 200);
      final rawOptions = item['options'];
      final options = [
        // Sometimes written as one "a | b | c" string.
        for (final o
            in rawOptions is String
                ? rawOptions.split('|')
                : rawOptions as List? ?? const [])
          _translation(o is String ? o.trim() : o, max: 50),
      ];
      if (text.isEmpty ||
          options.length != q.options.length ||
          options.any((o) => o.isEmpty)) {
        continue;
      }
      out[q.id] = FollowUp(
        id: q.id,
        question: text,
        options: [
          for (final (i, o) in q.options.indexed)
            AnswerOption(options[i], o.urgency),
        ],
      );
    }
    return out;
  }

  // --- Step 2: questions for the doctor ---------------------------------------

  @override
  Future<PrepSuggestion> suggestQuestions({
    required PatientProfile patient,
    required PrepAnswers answers,
    required AppLanguage language,
  }) async {
    final english = language == AppLanguage.english;
    final pool = _askPool(patient, answers);
    final must = _mustAsks(patient, answers);
    final facts = '${_about(patient)}\n\n${_visit(answers)}';
    final withoutAi = english
        ? PrepSuggestion(questions: _toQuestions(_defaultAsks(pool, must)))
        : PrepSuggestion(questions: fallback.questionsFor(patient, answers));
    if (!ai.isReady) return withoutAi;

    try {
      final reply = await ai.generate(
        system: _askSystem(language, patient, _contexts(patient, answers)),
        prompt: [
          facts,
          '',
          'Example questions (ideas only; write your own for this patient):',
          for (final a in pool) '- ${a.topic.name}: ${a.text}',
        ].join('\n'),
        maxOutputTokens: english ? 700 : 1400,
        timeout: const Duration(seconds: 120),
      );
      final written = _writtenAsks(
        _json(reply)?['questions'],
        patient,
        language,
      );
      if (written.length < _minAsks) {
        debugPrint(
          'Gurtu AI questions: only ${written.length} usable, using the '
          'built-in ones',
        );
        return withoutAi;
      }
      return PrepSuggestion(
        questions: _completeWritten(written, answers, english),
        byAi: true,
      );
    } on Object catch (e) {
      debugPrint('Gurtu AI questions: $e');
      return withoutAi;
    }
  }

  /// The questions as the model wrote them, in its order, minus any that
  /// don't pass the checks.
  static List<DoctorQuestion> _writtenAsks(
    Object? raw,
    PatientProfile patient,
    AppLanguage language,
  ) {
    final english = language == AppLanguage.english;
    final relation = patient.isSelf ? null : _relation(patient) ?? 'patient';
    final topics = {
      for (final t in QuestionTopic.values) t.name.toLowerCase(): t,
    };
    final stamp = DateTime.now().microsecondsSinceEpoch;
    final seen = <String>{};
    final out = <DoctorQuestion>[];
    for (final item in raw is List ? raw : const []) {
      if (item is! Map) continue;
      final text = english
          ? _clean(item['question'], max: 200)
          : _translation(item['question'], max: 300);
      if (text.length < 12 || !_inLanguage(text, language)) continue;
      // A caregiver's question must not speak as the patient.
      if (english && relation != null && _speaksAsPatient(text, relation)) {
        debugPrint('Gurtu AI question dropped (wrong voice): $text');
        continue;
      }
      if (!seen.add(_key(text))) continue;
      final topic =
          topics['${item['topic']}'.toLowerCase().replaceAll(
            RegExp('[^a-z]'),
            '',
          )] ??
          QuestionTopic.understand;
      out.add(
        DoctorQuestion(
          id: 'dq_${stamp}_ai${out.length}',
          kind: QuestionKind.ai,
          text: text,
          topic: topic,
        ),
      );
      if (out.length == _maxAsks) break;
    }
    return out;
  }

  static final _warning = RegExp(
    r'warning|danger|hospital|emergency|straight away|right away|immediately'
    r'|urgent',
    caseSensitive: false,
  );

  /// The model's questions with every topic covered and the warning signs
  /// always asked, in consultation order.
  static List<DoctorQuestion> _completeWritten(
    List<DoctorQuestion> written,
    PrepAnswers answers,
    bool english,
  ) {
    final questions = [...written];
    final byId = {
      for (final a in [...generalAsks, ...contextAsks.values]) a.id: a,
    };
    // Worst first, for the app's own translated templates.
    final symptoms = [...answers.symptoms]
      ..sort((a, b) => (b.severity?.index ?? 0) - (a.severity?.index ?? 0));
    final symptom = symptoms.firstOrNull?.symptom;
    final stamp = DateTime.now().microsecondsSinceEpoch;

    DoctorQuestion? extra(QuestionTopic topic) {
      if (english) {
        return _toQuestions([byId[essentialAsks[topic]]!]).single;
      }
      // Other languages: the app's own translated question, when there is a
      // problem to name.
      if (symptom == null && topic != QuestionTopic.treatment) return null;
      return DoctorQuestion(
        id: 'dq_${stamp}_${topic.name}',
        kind: switch (topic) {
          QuestionTopic.understand => QuestionKind.cause,
          QuestionTopic.tests => QuestionKind.tests,
          QuestionTopic.treatment => QuestionKind.medicinesStillRight,
          QuestionTopic.home => QuestionKind.homeCare,
          QuestionTopic.followUp => QuestionKind.warningSigns,
        },
        symptom: symptom,
        topic: topic,
      );
    }

    for (final t in QuestionTopic.values) {
      if (questions.any((q) => q.topic == t)) continue;
      if (extra(t) case final q?) questions.add(q);
    }
    if (english && !questions.any((q) => _warning.hasMatch(q.text))) {
      questions.add(extra(QuestionTopic.followUp)!);
    }
    // Too many: drop the model's last of a topic that has others.
    while (questions.length > _maxAsks) {
      final i = questions.lastIndexWhere(
        (q) =>
            written.contains(q) &&
            questions.where((x) => x.topic == q.topic).length > 1,
      );
      if (i < 0) break;
      questions.removeAt(i);
    }
    return [
      for (final t in QuestionTopic.values)
        ...questions.where((q) => q.topic == t),
    ];
  }

  /// Every question that could fit: what the answers point to first, then
  /// the symptoms, the long-term conditions, and the general ones.
  static List<DoctorAsk> _askPool(PatientProfile p, PrepAnswers a) {
    final symptoms = {for (final s in a.symptoms) s.symptom};
    final contexts = _contexts(p, a);
    final conditions = HealthCondition.values.asNameMap();
    final pool = [
      for (final c in contexts) contextAsks[c]!,
      for (final s in Symptom.values)
        if (symptoms.contains(s)) ...?symptomAsks[s],
      for (final c in p.conditions) ...?conditionAsks[conditions[c]],
      ...generalAsks,
    ];
    return [
      for (final (i, ask) in pool.indexed)
        if (pool.indexWhere((x) => x.id == ask.id) == i) ask,
    ];
  }

  static List<String> _contexts(PatientProfile p, PrepAnswers a) {
    int? choice(String id) =>
        a.intake.where((x) => x.id == id).firstOrNull?.choice;
    final symptoms = {for (final s in a.symptoms) s.symptom};
    return [
      if (a.newMedicine == true || choice('g_medicine') == 0) 'new_medicine',
      if (choice('g_tried') == 2) 'nothing_helped',
      if (!p.isSelf) 'caregiver',
      if (p.mobility == Mobility.someHelp.name ||
          p.mobility == Mobility.fullHelp.name ||
          symptoms.contains(Symptom.dizziness) && (p.age ?? 0) >= 60)
        'mobility',
      if (p.recentHospitalVisit == YesNoUnsure.yes.name) 'hospital',
      if (symptoms.contains(Symptom.fever) || symptoms.contains(Symptom.cough))
        'contagious',
    ];
  }

  /// The core question of every topic, plus what the answers make
  /// essential. Marked [must] so the model tailors and translates them too.
  static Set<String> _mustAsks(PatientProfile p, PrepAnswers a) {
    final contexts = _contexts(p, a);
    final symptoms = {for (final s in a.symptoms) s.symptom};
    return {
      ...essentialAsks.values,
      if (contexts.contains('new_medicine')) 'm_recent',
      if (contexts.contains('nothing_helped')) 'm_nothing',
      // The key question of the first two problems.
      ...Symptom.values
          .where(symptoms.contains)
          .take(2)
          .map((s) => symptomAsks[s]?.first.id)
          .nonNulls,
    };
  }

  /// The model's choice plus what must be there: the essential questions,
  /// and one question for every topic. In consultation order.
  static List<String> _completeAsks(
    List<String> chosen,
    List<DoctorAsk> pool,
    Set<String> must,
  ) {
    final byId = {for (final a in pool) a.id: a};
    final ids = [...chosen];
    for (final id in must) {
      if (!ids.contains(id)) ids.add(id);
    }
    for (final MapEntry(key: topic, value: id) in essentialAsks.entries) {
      if (!ids.any((x) => byId[x]!.topic == topic)) ids.add(id);
    }
    while (ids.length > _maxAsks) {
      final i = ids.lastIndexWhere(
        (id) =>
            !must.contains(id) &&
            ids.where((x) => byId[x]!.topic == byId[id]!.topic).length > 1,
      );
      if (i < 0) break;
      ids.removeAt(i);
    }
    return [
      for (final t in QuestionTopic.values)
        ...ids.where((id) => byId[id]!.topic == t),
    ];
  }

  /// Without the model: the most relevant few, every topic covered.
  static List<DoctorAsk> _defaultAsks(List<DoctorAsk> pool, Set<String> must) {
    final byId = {for (final a in pool) a.id: a};
    final specific = [
      for (final a in pool)
        if (!generalAsks.contains(a)) a.id,
    ];
    final ids = _completeAsks(specific.take(_pickAsks - 2).toList(), pool, {
      ...must,
      ...essentialAsks.values,
    });
    return [for (final id in ids) byId[id]!];
  }

  static List<DoctorQuestion> _toQuestions(
    List<DoctorAsk> asks, {
    Map<String, String> texts = const {},
  }) {
    final stamp = DateTime.now().microsecondsSinceEpoch;
    return [
      for (final a in asks)
        DoctorQuestion(
          id: 'dq_${stamp}_${a.id}',
          kind: QuestionKind.ai,
          text: texts[a.id] ?? a.text,
          topic: a.topic,
        ),
    ];
  }

  // --- Prompts ---------------------------------------------------------------

  static const _symptomSystem = '''
You read what a patient or their family said and pick which symptoms from a fixed list they clearly mention.
The text may be in English, any Indian language, or a mix.
Only pick a symptom if it is clearly stated. Never guess or infer. Swelling is not pain.
Also say whether they clearly said a medicine was started, stopped or changed recently.
Reply with only this JSON and nothing else: {"symptoms": ["id", "id"], "medicineChanged": false}
Use "symptoms": [] if none match.''';

  static String _intakeSystem(AppLanguage language, PatientProfile p) {
    final english = language == AppLanguage.english;
    return '''
You help a family get ready for a doctor's appointment. Like a caring doctor, ask them a few short follow-up questions to understand this particular problem better before the visit.

Rules:
- Write up to $_maxOwnFollowUps questions of your own about exactly what they described: where it is, how it feels, when it comes, what makes it better or worse, what else comes with it. Use their own details and the patient's age and long-term conditions.
- Never ask what they already told you. If they did not say when it started, or whether anything has helped so far, ask that.
- Include every safety check listed, with its id and its options in the same number and order. You may reword a safety check to fit this patient, but keep its meaning exactly.
- ${_intakeVoice(p)}
- Each question: one idea, short, everyday words. Give it 2 to 4 short answers to tap that cover the likely replies.
- Only ask. Never give advice, a diagnosis, a medicine or a dose.
- Write every question and answer in ${language.englishName}${english ? '' : ', in simple everyday words, without adding the English in brackets'}.

Reply with only this JSON and nothing else:
{"followUps": [{"id": "new", "question": "...", "options": ["...", "..."]}]}
Use "id": "new" for your own questions, and the listed id for a safety check or an idea you reuse.''';
  }

  /// How the chat speaks to the person using the app.
  static String _intakeVoice(PatientProfile p) {
    if (p.isSelf) {
      return 'You are talking to the patient: say "you" and "your", for '
          'example "Where exactly is your headache?".';
    }
    final who = _relation(p);
    if (who == null) {
      return 'You are talking to a family member about the patient: say '
          '"the patient", never "you" for the patient.';
    }
    final she = p.gender == Gender.female.name ? 'she' : 'he';
    return 'You are talking to a family member about their $who: say "your '
        '$who" or "$she", never "you" for the patient, for example "Where '
        'exactly is your $who\'s headache?".';
  }

  static String _askSystem(
    AppLanguage language,
    PatientProfile p,
    List<String> contexts,
  ) {
    final english = language == AppLanguage.english;
    return '''
You help a family get the most out of a doctor's appointment. Using the facts below, write the questions this family should ask the doctor, so they leave understanding the problem and exactly what to do.

Rules:
- Write $_pickAsks questions, the most important first.
- Make every question about this patient. Name the actual problem and use their details: how long it has been, how bad it is, their answers, their age, long-term conditions and regular medicines. For example, not "What is causing this?" but "What could be causing my mother's dizziness when she stands up?".
- Cover all five topics: understand (what it is and why), tests, treatment (medicines and other treatment), home (care, food and activity at home), followUp (warning signs and the next visit).
- Always include one question asking which warning signs mean going to the hospital straight away.
${[if (p.conditions.isNotEmpty) '- Ask how the problem could be linked to their long-term conditions.\n', for (final c in contexts) '- Be sure to ask, in your own words for this patient: "${contextAsks[c]!.text}"\n'].join()}- Each question: short, simple, one idea, everyday words. Never repeat a question.
- Only ask questions. Never answer them, never say what the problem is, and never name a medicine or a dose that is not in the facts.
- ${_voice(p)}
- Write each question in ${language.englishName}${english ? '' : ', in simple everyday words, without adding the English in brackets'}.

The example questions show the kind of questions doctors find useful. Use them as ideas only.

Reply with only this JSON and nothing else:
{"questions": [{"topic": "understand", "question": "..."}]}''';
  }

  static String _symptomList() {
    const hints = {
      Symptom.fever: 'fever, high temperature, chills',
      Symptom.headache: 'headache, head pain',
      Symptom.bodyPain:
          'body ache; joint, back, knee or muscle pain (not swelling)',
      Symptom.chestPain: 'chest pain, tightness or pressure in the chest',
      Symptom.breathless: 'short of breath, difficulty breathing',
      Symptom.cough: 'cough',
      Symptom.dizziness: 'dizziness, giddiness, feeling faint',
      Symptom.tiredness: 'tiredness, weakness, no energy',
      Symptom.stomach: 'stomach pain, vomiting, nausea, loose motions, acidity, constipation',
      Symptom.poorSleep: 'trouble sleeping',
      Symptom.poorAppetite: 'not hungry, not eating well',
      Symptom.lowMood:
          'sadness, feeling low, worry, anxiety, stress, tension, hopeless',
    };
    return 'Symptom ids (id: meaning):\n'
        '${[for (final MapEntry(:key, :value) in hints.entries) '- ${key.name}: $value'].join('\n')}';
  }

  static String _labels(Iterable<Symptom> symptoms) {
    final en = lookupAppLocalizations(const Locale('en'));
    return symptoms.map(en.symptomLabel).join(', ');
  }

  /// The patient's relation to the person asking, e.g. "mother".
  static String? _relation(PatientProfile p) {
    if (p.isSelf) return null;
    final female = p.gender == Gender.female.name;
    return switch (CareFor.values.asNameMap()[p.careFor]) {
      CareFor.parent => female ? 'mother' : 'father',
      CareFor.partner => female ? 'wife' : 'husband',
      CareFor.child => female ? 'daughter' : 'son',
      _ => null,
    };
  }

  static String _voice(PatientProfile p) {
    if (p.isSelf) {
      return 'The patient is asking for themself: use "I" and "my", '
          'for example "What do you think is causing my headache?".';
    }
    final who = _relation(p) ?? 'patient';
    final whose = who == 'patient' ? 'the patient' : 'my $who';
    return 'A family member is asking about their $who, not about '
        'themself. Never use "I", "me" or "my" for the patient: say '
        '"$whose" and "we", as the family member would say it, for example '
        '"What do you think is causing $whose\'s headache?" and "What can '
        'we do at home?".';
  }

  /// What is known about the patient, in plain English (the model's
  /// strongest language); answers come back in the app language.
  static String _about(PatientProfile p) {
    final en = lookupAppLocalizations(const Locale('en'));
    String? label<T extends Enum>(
      List<T> values,
      String? name,
      String Function(T) of,
    ) => switch (values.asNameMap()[name]) {
      final T v => of(v),
      null => null,
    };

    final conditions = [
      for (final c in p.conditions)
        ?label(HealthCondition.values, c, (v) => v.label(en)),
    ];
    final allergies = [
      for (final c in p.allergies)
        ?label(Allergy.values, c, (v) => v.label(en)),
    ];
    final mobility = label(Mobility.values, p.mobility, (v) => v.label(en));
    final medicines = label(
      MedicineCount.values,
      p.medicineCount,
      (v) => v.label(en),
    );
    final who = _relation(p);
    final about = [
      if (p.age != null) '${p.age} years old',
      ?p.gender,
      if (who != null) 'the asker\'s $who',
    ];

    return [
      if (about.isNotEmpty) 'Patient: ${about.join(', ')}',
      if (conditions.isNotEmpty)
        'Long-term conditions: ${conditions.join(', ')}',
      if (allergies.isNotEmpty) 'Allergies: ${allergies.join(', ')}',
      if (medicines != null) 'Regular medicines: $medicines',
      if (mobility != null) 'Mobility: $mobility',
      if (p.recentHospitalVisit == YesNoUnsure.yes.name)
        'Was in hospital recently: yes',
    ].join('\n');
  }

  /// What was said while preparing; bank answers in their English form.
  static String _visit(PrepAnswers a) {
    final en = lookupAppLocalizations(const Locale('en'));
    final bank = {
      for (final q in [
        ...generalIntake,
        ...symptomIntake.values.expand((x) => x),
      ])
        q.id: q,
    };
    String answer(IntakeAnswer x) {
      final q = bank[x.id];
      final i = x.choice;
      return q != null && i != null && i < q.options.length
          ? q.options[i].text
          : x.answer;
    }

    return [
      if (a.symptoms.isNotEmpty) ...[
        'Problems:',
        for (final s in a.symptoms)
          '- ${en.symptomLabel(s.symptom)}'
              '${s.since == null ? '' : ', since: ${en.sinceLabel(s.since!).toLowerCase()}'}'
              '${s.severity == null ? '' : ', severity: ${en.severityLabel(s.severity!).toLowerCase()}'}',
      ],
      if (a.description.isNotEmpty)
        'In their own words: """${a.description}"""',
      if (a.intake.isNotEmpty) 'Their answers:',
      for (final x in a.intake)
        '- ${bank[x.id]?.text ?? x.question} → ${answer(x)}',
      if (a.newMedicine == true) 'Started or changed a medicine recently: yes',
      if (a.extraNote.isNotEmpty)
        'Also wants the doctor to know: """${a.extraNote}"""',
    ].join('\n');
  }

  // --- Checking the answer ----------------------------------------------------

  /// The first JSON object in [reply], tolerating code fences and chatter.
  static Map<String, dynamic>? _json(String reply) {
    final start = reply.indexOf('{');
    final end = reply.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    try {
      final v = jsonDecode(reply.substring(start, end + 1));
      return v is Map<String, dynamic> ? v : null;
    } on FormatException {
      return null;
    }
  }

  /// A dose or amount has no place in anything Gurtu writes here.
  static final _dose = RegExp(
    r'\d+(\.\d+)?\s*(mg|mcg|µg|ml|iu|units?|tablets?|capsules?|puffs?)\b',
    caseSensitive: false,
  );
  static final _bullet = RegExp(r'^\s*(\d+[.)]|[-*•])\s*');
  static final _bracketedLatin = RegExp(r'\s*\([^()]*[A-Za-z][^()]*\)');

  /// A translation without the English the model sometimes adds in brackets.
  static String _translation(Object? raw, {required int max}) => _clean(
    raw is String ? raw.replaceAll(_bracketedLatin, '') : raw,
    max: max,
  );

  /// Trimmed and tidied, or '' when it's empty, too long or mentions a dose.
  static String _clean(Object? raw, {required int max}) {
    if (raw is! String) return '';
    final s = raw
        .replaceFirst(_bullet, '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^["“]|["”]$'), '')
        .trim();
    return s.length > max || _dose.hasMatch(s) ? '' : s;
  }

  /// "I", "me", or "my" not followed by the patient's relation.
  static bool _speaksAsPatient(String text, String relation) =>
      RegExp(r"\b(I|me)\b").hasMatch(text) ||
      RegExp(
        r"\bmy\b(?!\s+" + RegExp.escape(relation) + r")",
        caseSensitive: false,
      ).hasMatch(text);

  /// The words that carry a question's meaning.
  static Set<String> _keyWords(String text) {
    final glue = _words(_glueWords).toSet();
    return _words(text).where((w) => !glue.contains(w)).toSet();
  }

  /// Lower-case words of 3+ letters, loosely stemmed ("headaches" →
  /// "headache").
  static Iterable<String> _words(String s) =>
      RegExp(r"[a-z]+")
          .allMatches(s.toLowerCase())
          .map((m) => m[0]!)
          .where((w) => w.length > 2)
          .map(_stem);

  static String _stem(String w) {
    for (final end in ['ing', 'ed', 'es', 's']) {
      if (w.length > end.length + 3 && w.endsWith(end)) {
        return w.substring(0, w.length - end.length);
      }
    }
    return w;
  }

  static const _glueWords =
      'the and for with this that these those what which when where why how '
      'can could should would will does did has have had been being are was '
      'were not any all about from into over after before since still also '
      'my our your his her their them they she him you we me i us '
      'mother father wife husband son daughter patient family '
      'is it be do so as or if of to in on at by an a '
      'now yet just very more most much many some such than then there here '
      'get got getting keep make feel feeling felt happen happening lasted '
      'last lasting long days day week weeks month months year years ago '
      'done need needed come back another next visit schedule';
}
