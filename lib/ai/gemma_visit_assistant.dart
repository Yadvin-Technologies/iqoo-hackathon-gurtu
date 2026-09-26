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
/// The model never writes a medical question of its own. Every question
/// comes from the reviewed bank in `visit_knowledge.dart`; the model's job is
/// to understand what the family said, choose the questions that fit this
/// patient, tailor their wording and translate them. It answers with bank
/// ids, so an invented question has nowhere to go, and code then guarantees
/// what must always be there: the danger-sign check for every symptom, one
/// question per topic, and "which warning signs mean hospital".
///
/// Whenever the model is missing, slow or its answer doesn't pass the checks,
/// the same bank is used without it (English) or [LocalVisitAssistant]
/// (other languages), so the feature always works.
class GemmaVisitAssistant extends VisitAssistant {
  const GemmaVisitAssistant(
    this.ai, {
    this.fallback = const LocalVisitAssistant(),
  });

  final GurtuAi ai;
  final LocalVisitAssistant fallback;

  static const _maxFollowUps = 5;
  static const _pickAsks = 8;
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
    // Always asked: when it started (unless they said), every danger check,
    // and what has been tried — the doctor's first questions too.
    final must = [
      if (!_mentionsTime(description)) 'g_onset',
      for (final q in pool)
        if (q.danger) q.id,
      'g_tried',
    ];
    final english = language == AppLanguage.english;

    List<String> ids;
    var shown = <String, FollowUp>{};
    try {
      final reply = await ai.generate(
        system: _intakeSystem(language),
        prompt: [
          _about(patient),
          '',
          if (description.isNotEmpty)
            'What they said: """$description"""'
          else
            'Problems they tapped: ${_labels(symptoms)}',
          if (description.isNotEmpty && symptoms.isNotEmpty)
            'Problems: ${_labels(symptoms)}',
          '',
          'Follow-up questions:',
          for (final q in pool)
            '- ${q.id}: ${q.text}'
                '${english ? '' : ' Options: ${q.options.map((o) => o.text).join(' | ')}'}'
                '${must.contains(q.id) ? ' [must]' : ''}',
        ].join('\n'),
        maxOutputTokens: english ? 120 : 700,
        timeout: const Duration(seconds: 60),
      );
      final j = _json(reply);
      if (english) {
        ids = [for (final id in j?['ids'] as List? ?? const []) '$id'];
      } else {
        shown = _translatedFollowUps(j?['followUps'], pool);
        ids = shown.keys.toList();
      }
    } on Object catch (e) {
      debugPrint('Gurtu AI intake: $e');
      // Untranslated bank questions would be in English: other languages
      // use the app's own translated questions instead.
      if (!english) return null;
      ids = const [];
    }

    final chosen = _pickFollowUps(ids, pool, must, symptoms);
    if (!english) {
      final missing = [
        for (final q in chosen)
          if (!shown.containsKey(q.id)) q,
      ];
      if (missing.isNotEmpty) {
        shown = {...shown, ...await _translate(missing, language)};
      }
    }
    return IntakePlan(
      symptoms: symptoms,
      medicineChanged: medicineChanged,
      followUps: [
        for (final q in chosen)
          if (shown[q.id] case final translated?)
            translated
          // An untranslated question would switch language mid-chat: only
          // the ones that must be asked are shown as they are.
          else if (english || must.contains(q.id))
            FollowUp(id: q.id, question: q.text, options: q.options),
      ],
    );
  }

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
        system: _askSystem(language, patient),
        prompt: [
          facts,
          '',
          'Questions to choose from:',
          for (final a in pool)
            '- ${a.id}: ${a.text}${must.contains(a.id) ? ' [must]' : ''}',
        ].join('\n'),
        maxOutputTokens: english ? 600 : 1000,
        timeout: const Duration(seconds: 90),
      );
      final j = _json(reply);
      final byId = {for (final a in pool) a.id: a};
      final chosen = <String, String>{};
      for (final item in j?['questions'] as List? ?? const []) {
        if (item is! Map) continue;
        final ask = byId['${item['id']}'.trim()];
        if (ask == null || chosen.containsKey(ask.id)) continue;
        chosen[ask.id] = _tailored(
          item['question'],
          ask,
          facts,
          english,
          relation: patient.isSelf ? null : _relation(patient) ?? 'patient',
        );
      }
      if (chosen.length < 4) return withoutAi;
      // A must question the model left out would be untailored, and in
      // English in another language: fine in English, not elsewhere.
      if (!english && !must.every(chosen.containsKey)) return withoutAi;

      final ids = _completeAsks(chosen.keys.toList(), pool, must);
      final questions = _toQuestions([
        for (final id in ids) byId[id]!,
      ], texts: chosen);
      return PrepSuggestion(questions: questions, byAi: true);
    } on Object catch (e) {
      debugPrint('Gurtu AI questions: $e');
      return withoutAi;
    }
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

  static String _intakeSystem(AppLanguage language) {
    final english = language == AppLanguage.english;
    return '''
You help a family get ready for a doctor's appointment. Below is a list of follow-up questions about their health problem. Choose which ones to ask this family.

Rules:
- Choose only from the list, by id. Never write a new question.
- Choose up to $_maxFollowUps, the most useful first.
- Always include every id marked [must].
- Prefer the questions about this particular problem over the general ones.
- Skip any question that what they said already answers. For example, if they said when it started, skip the question about when it started.
${english ? '''
Reply with only this JSON and nothing else:
{"ids": ["id", "id"]}''' : '''- Translate each chosen question and all of its options into ${language.englishName}, in simple everyday words. Keep the same number and order of options. Do not add the English in brackets. Do not add the English in brackets.

Reply with only this JSON and nothing else:
{"followUps": [{"id": "...", "question": "...", "options": ["...", "..."]}]}'''}''';
  }

  static String _askSystem(AppLanguage language, PatientProfile p) {
    final english = language == AppLanguage.english;
    return '''
You help a family get the most out of a doctor's appointment. Below are the facts, and a list of questions they could ask the doctor during the consultation. Choose the $_pickAsks questions that will best help this patient and family understand the problem and what to do.

Rules:
- Choose only from the list, by id. Never write a new question.
- Always include every id marked [must], then add the questions that fit this patient best. Prefer the ones about this particular problem and these conditions (listed first) over general ones. Skip ones that don't fit.
- Tailor each chosen question so it is about this patient: replace vague words like "this" or "it" with the actual problem. For example "What do you think is causing this?" becomes "What do you think is causing my headache?".
- Keep each question short, simple and one idea. Keep its meaning exactly.
- Do not add any medical word, cause, test, medicine or advice that is not already in the question or the facts.
- ${_voice(p)}
- Write each question in ${language.englishName}${english ? '' : ', in simple everyday words, without adding the English in brackets'}.

Reply with only this JSON and nothing else:
{"questions": [{"id": "...", "question": "..."}]}''';
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

  /// The model's tailored wording when it stays true to the bank question;
  /// otherwise the bank question itself. In English it must add no new
  /// words, keep the question's key words, and — when a caregiver asks
  /// ([relation]) — never speak as the patient ("I", "my headache").
  static String _tailored(
    Object? raw,
    DoctorAsk ask,
    String facts,
    bool english, {
    String? relation,
  }) {
    final text = english
        ? _clean(raw, max: ask.text.length + 80)
        : _translation(raw, max: 300);
    if (text.length < 8) return ask.text;
    if (!english) return text;
    String? problem;
    final novel = _novelWords(text, '${ask.text}\n$facts');
    final kept = _keyWords(ask.text);
    final lost = kept.difference(_words(text).toSet());
    if (novel.length > 2) {
      problem = 'new words $novel';
    } else if (lost.length > kept.length * 0.3) {
      problem = 'lost $lost';
    } else if (relation != null && _speaksAsPatient(text, relation)) {
      problem = 'wrong voice';
    }
    if (problem == null) return text;
    debugPrint('Gurtu AI kept bank wording for ${ask.id} ($problem): $text');
    return ask.text;
  }

  /// "I", "me", or "my" not followed by the patient's relation.
  static bool _speaksAsPatient(String text, String relation) =>
      RegExp(r"\b(I|me)\b").hasMatch(text) ||
      RegExp(
        r"\bmy\b(?!\s+" + RegExp.escape(relation) + r")",
        caseSensitive: false,
      ).hasMatch(text);

  /// Words in [text] found in neither [source] nor everyday glue words.
  static Set<String> _novelWords(String text, String source) {
    final known = {..._words(source), ..._words(_glueWords)};
    return _words(text).where((w) => !known.contains(w)).toSet();
  }

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
