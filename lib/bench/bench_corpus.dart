import 'dart:math' as math;

import '../memory/models.dart';

/// A benchmark question over `mockMoments`, with the moments that answer it
/// (empty: nothing does, and retrieval should return no evidence).
///
/// [english] stands in for Gemma 4's translation of a non-English question.
class EvalQuery {
  const EvalQuery(this.id, this.text, this.relevant, {this.english, this.note = ''});

  final String id;
  final String text;
  final String? english;
  final Set<String> relevant;
  final String note;

  bool get answerable => relevant.isNotEmpty;
}

const List<EvalQuery> evalQueries = [
  EvalQuery('q1', 'What did the doctor say about the evening medicine?', {'e1', 't1'}),
  EvalQuery('q2', 'When should Amma take Telma?', {'e2', 'e15', 'm1'}, note: 'conflict'),
  EvalQuery('q3', 'Is there a blood test scheduled?', {'e7', 't6'}),
  EvalQuery('q4', 'What was her latest BP reading?', {'e4', 't2'}),
  EvalQuery('q5', 'Did she feel dizzy?', {'e6', 't2'}),
  EvalQuery('q6', 'What was the HbA1c result?', {'e9'}),
  EvalQuery('q7', 'Which tablet is for acidity?', {'e3'}),
  EvalQuery('q8', 'When is the next doctor appointment?', {'e14'}),
  EvalQuery('q9', 'What food should she avoid?', {'e11', 't4'}),
  EvalQuery('q10', 'What should we do if her sugar goes too low?', {'h3'}),
  EvalQuery(
    'q11',
    'అమ్మ రాత్రి ఏ మాత్ర వేసుకోవాలి?',
    {'t1', 'e2', 'e10', 'e1'},
    english: 'Which tablet should Amma take at night?',
    note: 'te',
  ),
  EvalQuery(
    'q12',
    'కాళ్ళ వాపు గురించి ఏమైనా నమోదు చేశారా?',
    {'t5'},
    english: 'Was anything recorded about leg swelling?',
    note: 'te',
  ),
  EvalQuery(
    'q13',
    'రక్త పరీక్ష ఎప్పుడు?',
    {'e7', 't6'},
    english: 'When is the blood test?',
    note: 'te',
  ),
  EvalQuery(
    'q14',
    'क्या माताजी ने आज सुबह की दवा ली?',
    {'h2'},
    english: 'Did Mataji take her morning medicine today?',
    note: 'hi',
  ),
  EvalQuery(
    'q15',
    'मेटफॉर्मिन कब लेनी है?',
    {'h1', 'e1', 'e2', 't1'},
    english: 'When should Metformin be taken?',
    note: 'hi',
  ),
  EvalQuery(
    'q16',
    'क्या नींद की कोई समस्या है?',
    {'h4'},
    english: 'Is there any problem with sleep?',
    note: 'hi',
  ),
  EvalQuery(
    'q17',
    'Amma ki dizziness eppudu vachindi?',
    {'e6', 't2'},
    english: 'When did Amma get dizziness?',
    note: 'code-mixed',
  ),
  EvalQuery(
    'q18',
    'Ecosprin eppudu veyyali?',
    {'e2', 't3', 'e12'},
    english: 'When should Ecosprin be taken?',
    note: 'code-mixed',
  ),
  EvalQuery('q19', 'Did anyone note a cough?', {'m4'}),
  EvalQuery('q20', 'How often should her sugar be checked?', {'m3'}),
  EvalQuery('q21', 'Any swelling in her ankles?', {'t5'}),
  EvalQuery('q22', 'Did she miss any medicine?', {'h2'}),
  EvalQuery(
    'q23',
    'ఫిజియోథెరపీ వ్యాయామాలు ఏమిటి?',
    {'e13'},
    english: 'What are the physiotherapy exercises?',
    note: 'te',
  ),
  EvalQuery(
    'q24',
    'पैरों की देखभाल कैसे करें?',
    {'e8'},
    english: 'How should we take care of her feet?',
    note: 'hi',
  ),
  // Nothing in memory answers these.
  EvalQuery('u1', 'What did the MRI scan show?', {}),
  EvalQuery('u2', 'Is she allergic to penicillin?', {}),
  EvalQuery(
    'u3',
    'ఆమెకు ఏ కంటి చుక్కలు ఇచ్చారు?',
    {},
    english: 'Which eye drops were given to her?',
  ),
  EvalQuery(
    'u4',
    'क्या उन्हें डायलिसिस की ज़रूरत है?',
    {},
    english: 'Does she need dialysis?',
  ),
  EvalQuery('u5', 'Which vaccine was given last month?', {}),
];

/// Synthetic but realistic moments for load tests: [n] moments spread over
/// [patients] patients and ~a year, cycling languages and source types.
/// Telugu and Hindi moments carry their English rendering, as real ones will.
List<CareMoment> syntheticMoments(int n, {int patients = 4, int seed = 42}) {
  final rnd = math.Random(seed);
  const meds = [
    ('Metformin 500', 'మెట్‌ఫార్మిన్', 'मेटफॉर्मिन'),
    ('Telma 40', 'టెల్మా', 'टेल्मा'),
    ('Ecosprin 75', 'ఎకోస్ప్రిన్', 'इकोस्प्रिन'),
    ('Atorva 10', 'అటోర్వా', 'एटोरवा'),
    ('Pan 40', 'పాన్', 'पैन'),
    ('Dolo 650', 'డోలో', 'डोलो'),
  ];
  const times = [
    ('after breakfast', 'టిఫిన్ తర్వాత', 'नाश्ते के बाद'),
    ('before breakfast', 'టిఫిన్ ముందు', 'नाश्ते से पहले'),
    ('after lunch', 'భోజనం తర్వాత', 'दोपहर के खाने के बाद'),
    ('at bedtime', 'పడుకునే ముందు', 'सोने से पहले'),
  ];
  const symptoms = [
    ('felt dizzy', 'తల తిరిగింది', 'चक्कर आया'),
    ('had a headache', 'తలనొప్పి వచ్చింది', 'सिर दर्द हुआ'),
    ('felt tired', 'నీరసంగా ఉంది', 'थकान महसूस हुई'),
    ('had leg swelling', 'కాళ్ళ వాపు వచ్చింది', 'पैरों में सूजन थी'),
  ];
  final start = DateTime(2025, 10, 1);
  return List.generate(n, (i) {
    final at = start.add(Duration(minutes: rnd.nextInt(525600)));
    final lang = i % 3; // 0 en, 1 te, 2 hi
    final kind = rnd.nextInt(4);
    final med = meds[rnd.nextInt(meds.length)];
    final time = times[rnd.nextInt(times.length)];
    final sym = symptoms[rnd.nextInt(symptoms.length)];
    final sys = 110 + rnd.nextInt(60), dia = 70 + rnd.nextInt(30);
    final sugar = 80 + rnd.nextInt(160);
    final weeks = 1 + rnd.nextInt(4);
    String pick((String, String, String) t) => [t.$1, t.$2, t.$3][lang];
    final (source, english, original) = switch (kind) {
      0 => (
        SourceType.note,
        '${med.$1} given ${time.$1}.',
        ['', '${pick(med)} ${pick(time)} ఇచ్చాము.', '${pick(med)} ${pick(time)} दी गई।'][lang],
      ),
      1 => (
        SourceType.vitalReading,
        'BP $sys/$dia, pulse ${60 + rnd.nextInt(40)}. Sugar $sugar mg/dL.',
        '',
      ),
      2 => (
        SourceType.familyVoice,
        'After the walk she ${sym.$1} for a while.',
        ['', 'నడక తర్వాత కొంతసేపు ${pick(sym)}.', 'टहलने के बाद कुछ देर ${pick(sym)}।'][lang],
      ),
      _ => (
        SourceType.doctorAudio,
        'Continue ${med.$1} ${time.$1}. Review in $weeks weeks.',
        ['', '${pick(med)} ${pick(time)} కొనసాగించండి.', '${pick(med)} ${pick(time)} जारी रखें।'][lang],
      ),
    };
    final translated = original.isNotEmpty;
    return CareMoment(
      id: 'syn$i',
      patientId: 'p${i % patients}',
      sourceType: source,
      createdAt: at,
      text: translated ? original : english,
      translation: translated ? english : null,
      language: translated ? ['en', 'te', 'hi'][lang] : 'en',
    );
  });
}
