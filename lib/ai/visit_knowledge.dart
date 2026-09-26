// The questions Gurtu may ask, and may suggest asking the doctor.
//
// Gurtu AI never writes a medical question from scratch: it picks from these,
// tailors the wording to the patient and translates. Keeping the medical
// content here — reviewed, plain-language, one idea per question — is what
// stops a small on-device model from inventing things.
//
// Wording follows patient-education practice: short, everyday words, one idea
// per question. Questions for the doctor are voice-neutral ("Are any tests
// needed?") so they read right whether the patient or a caregiver asks; the
// model adds "I" or "my mother" when it tailors them.

import '../data/visit_models.dart';
import '../onboarding/onboarding_state.dart';

/// What to do when an answer points to danger.
enum Urgency {
  none,

  /// Get medical help now (108).
  emergency,

  /// Talk to someone now (Tele-MANAS 14416).
  selfHarm,
}

class AnswerOption {
  const AnswerOption(this.text, [this.urgency = Urgency.none]);

  final String text;
  final Urgency urgency;
}

/// A question for the family while preparing.
class IntakeQuestion {
  const IntakeQuestion(this.id, this.text, this.options, {this.danger = false});

  final String id;
  final String text;
  final List<AnswerOption> options;

  /// Checks for warning signs; always asked for its symptom.
  final bool danger;

  /// The answer's text in the bank's language for option [i], or [typed].
  String answerText(int? i, String typed) =>
      i != null && i < options.length ? options[i].text : typed;
}

/// A question for the family to ask the doctor.
class DoctorAsk {
  const DoctorAsk(this.id, this.topic, this.text);

  final String id;
  final QuestionTopic topic;
  final String text;
}

// --- Follow-ups while preparing --------------------------------------------

const _urgent = Urgency.emergency;

const generalIntake = [
  IntakeQuestion('g_onset', 'When did it start?', [
    AnswerOption('Today'),
    AnswerOption('2–3 days ago'),
    AnswerOption('About a week ago'),
    AnswerOption('More than a month ago'),
  ]),
  IntakeQuestion('g_course', 'Is it getting better or worse?', [
    AnswerOption('Getting better'),
    AnswerOption('Staying the same'),
    AnswerOption('Getting worse'),
    AnswerOption('Comes and goes'),
  ]),
  IntakeQuestion('g_impact', 'How much does it affect daily life?', [
    AnswerOption('A little'),
    AnswerOption('Some things are hard'),
    AnswerOption('Can’t do daily tasks'),
  ]),
  IntakeQuestion('g_tried', 'Has anything helped so far?', [
    AnswerOption('Rest helped'),
    AnswerOption('A medicine helped'),
    AnswerOption('Nothing helped'),
    AnswerOption('Haven’t tried anything'),
  ]),
  IntakeQuestion(
    'g_medicine',
    'Was any medicine started, stopped or changed in the last month?',
    [AnswerOption('Yes'), AnswerOption('No'), AnswerOption('Not sure')],
  ),
];

const symptomIntake = <Symptom, List<IntakeQuestion>>{
  Symptom.fever: [
    IntakeQuestion(
      'fe_danger',
      'Is there also a rash, stiff neck, confusion or fits?',
      [AnswerOption('No'), AnswerOption('Yes', _urgent)],
      danger: true,
    ),
    IntakeQuestion('fe_temp', 'How high has the temperature been?', [
      AnswerOption('Not measured'),
      AnswerOption('Below 100°F'),
      AnswerOption('100–102°F'),
      AnswerOption('Above 102°F'),
    ]),
  ],
  Symptom.headache: [
    IntakeQuestion(
      'hd_danger',
      'Did it start suddenly, as the worst headache ever?',
      [
        AnswerOption('No, it came slowly'),
        AnswerOption('Yes, sudden and severe', _urgent),
      ],
      danger: true,
    ),
    IntakeQuestion(
      'hd_signs',
      'Does it come with vomiting, blurred vision, weakness or confusion?',
      [AnswerOption('No'), AnswerOption('Yes', _urgent)],
      danger: true,
    ),
    IntakeQuestion('hd_where', 'Where is the pain?', [
      AnswerOption('Forehead'),
      AnswerOption('One side'),
      AnswerOption('Back of the head'),
      AnswerOption('All over'),
    ]),
  ],
  Symptom.bodyPain: [
    IntakeQuestion('bp_where', 'Where is the pain?', [
      AnswerOption('Joints'),
      AnswerOption('Back'),
      AnswerOption('Muscles'),
      AnswerOption('Legs'),
    ]),
    IntakeQuestion(
      'bp_swelling',
      'Is there swelling, redness or warmth there?',
      [AnswerOption('No'), AnswerOption('Yes')],
    ),
    IntakeQuestion('bp_injury', 'Did it start after a fall or injury?', [
      AnswerOption('No'),
      AnswerOption('Yes'),
    ]),
  ],
  Symptom.chestPain: [
    IntakeQuestion(
      'cp_danger',
      'Does the pain spread to the arm, jaw or back, or come with sweating?',
      [AnswerOption('No'), AnswerOption('Yes', _urgent)],
      danger: true,
    ),
    IntakeQuestion('cp_when', 'When does the pain come?', [
      AnswerOption('At rest'),
      AnswerOption('When walking or working'),
      AnswerOption('After eating'),
      AnswerOption('When breathing deeply'),
    ]),
  ],
  Symptom.breathless: [
    IntakeQuestion('br_danger', 'When does the breathlessness come?', [
      AnswerOption('Only on stairs or fast walking'),
      AnswerOption('Even on walking a little'),
      AnswerOption('Even at rest', _urgent),
      AnswerOption('When lying flat at night'),
    ], danger: true),
    IntakeQuestion('br_swelling', 'Is there swelling in the feet or ankles?', [
      AnswerOption('No'),
      AnswerOption('Yes'),
    ]),
  ],
  Symptom.cough: [
    IntakeQuestion('co_danger', 'Is there phlegm? What does it look like?', [
      AnswerOption('Dry cough'),
      AnswerOption('Clear or white'),
      AnswerOption('Yellow or green'),
      AnswerOption('Blood in it', _urgent),
    ], danger: true),
    IntakeQuestion('co_with', 'Is there fever or chest pain with the cough?', [
      AnswerOption('No'),
      AnswerOption('Fever'),
      AnswerOption('Chest pain'),
      AnswerOption('Both'),
    ]),
  ],
  Symptom.dizziness: [
    IntakeQuestion(
      'dz_danger',
      'Any slurred speech, drooping face, or weakness on one side?',
      [AnswerOption('No'), AnswerOption('Yes', _urgent)],
      danger: true,
    ),
    IntakeQuestion('dz_feel', 'What does the dizziness feel like?', [
      AnswerOption('The room spins'),
      AnswerOption('Feeling faint'),
      AnswerOption('Unsteady walking'),
    ]),
    IntakeQuestion('dz_when', 'When does it happen?', [
      AnswerOption('On standing up'),
      AnswerOption('On turning the head'),
      AnswerOption('At any time'),
    ]),
    IntakeQuestion('dz_falls', 'Have there been any falls or fainting?', [
      AnswerOption('No'),
      AnswerOption('Yes, a fall'),
      AnswerOption('Yes, fainted'),
    ]),
  ],
  Symptom.tiredness: [
    IntakeQuestion(
      'ti_sleep',
      'Is the tiredness there even after a full night’s sleep?',
      [AnswerOption('Yes'), AnswerOption('No')],
    ),
    IntakeQuestion('ti_weight', 'Has the weight changed recently?', [
      AnswerOption('Lost weight'),
      AnswerOption('Gained weight'),
      AnswerOption('No change'),
    ]),
  ],
  Symptom.stomach: [
    IntakeQuestion(
      'st_danger',
      'Any blood in the vomit or stool, or black stool?',
      [AnswerOption('No'), AnswerOption('Yes', _urgent)],
      danger: true,
    ),
    IntakeQuestion('st_main', 'What is the main stomach problem?', [
      AnswerOption('Pain'),
      AnswerOption('Vomiting'),
      AnswerOption('Loose motions'),
      AnswerOption('Burning or acidity'),
    ]),
    IntakeQuestion('st_fluids', 'Are fluids staying down?', [
      AnswerOption('Yes'),
      AnswerOption('No, everything comes out'),
    ]),
  ],
  Symptom.poorSleep: [
    IntakeQuestion('sl_kind', 'What is the sleep problem?', [
      AnswerOption('Hard to fall asleep'),
      AnswerOption('Waking up often'),
      AnswerOption('Waking too early'),
      AnswerOption('Loud snoring or gasping'),
    ]),
    IntakeQuestion('sl_day', 'Is there sleepiness during the day?', [
      AnswerOption('No'),
      AnswerOption('Sometimes'),
      AnswerOption('Often'),
    ]),
  ],
  Symptom.poorAppetite: [
    IntakeQuestion('ap_weight', 'Has there been weight loss?', [
      AnswerOption('No'),
      AnswerOption('A little'),
      AnswerOption('A lot'),
    ]),
    IntakeQuestion('ap_with', 'Is there nausea or trouble swallowing?', [
      AnswerOption('No'),
      AnswerOption('Nausea'),
      AnswerOption('Trouble swallowing'),
    ]),
  ],
  Symptom.lowMood: [
    IntakeQuestion('md_danger', 'Have there been any thoughts of self-harm?', [
      AnswerOption('No'),
      AnswerOption('Yes', Urgency.selfHarm),
    ], danger: true),
    IntakeQuestion('md_often', 'How often is the mood low or worried?', [
      AnswerOption('Some days'),
      AnswerOption('Most days'),
      AnswerOption('Nearly every day'),
    ]),
  ],
};

// --- Questions for the doctor ----------------------------------------------

const _u = QuestionTopic.understand;
const _t = QuestionTopic.tests;
const _m = QuestionTopic.treatment;
const _h = QuestionTopic.home;
const _f = QuestionTopic.followUp;

const generalAsks = [
  DoctorAsk('u_cause', _u, 'What do you think is causing this?'),
  DoctorAsk(
    'u_name',
    _u,
    'Does this problem have a name? Can you explain it in simple words?',
  ),
  DoctorAsk('u_serious', _u, 'How serious is it? Could it get worse?'),
  DoctorAsk('u_time', _u, 'How long will it take to get better?'),
  DoctorAsk('t_need', _t, 'Are any tests needed? What will they tell us?'),
  DoctorAsk(
    't_prepare',
    _t,
    'Is anything needed before the tests, like fasting?',
  ),
  DoctorAsk(
    't_results',
    _t,
    'When will the results come, and who will explain them?',
  ),
  DoctorAsk(
    'm_what',
    _m,
    'What is each new medicine for, and for how many days should it be taken?',
  ),
  DoctorAsk('m_side', _m, 'What side effects could the medicines cause?'),
  DoctorAsk('m_mix', _m, 'Is it safe with the medicines already being taken?'),
  DoctorAsk(
    'm_other',
    _m,
    'Is there anything besides medicine that could help?',
  ),
  DoctorAsk('h_do', _h, 'What can be done at home to help with this?'),
  DoctorAsk('h_food', _h, 'Is any change in food or drink needed for now?'),
  DoctorAsk(
    'h_activity',
    _h,
    'Is it fine to carry on with work and daily activities?',
  ),
  DoctorAsk(
    'f_warning',
    _f,
    'Which warning signs mean going to the hospital straight away?',
  ),
  DoctorAsk(
    'f_back',
    _f,
    'If it does not get better, when should the next visit be?',
  ),
];

/// Asked only when the answers point to them.
const contextAsks = {
  'new_medicine': DoctorAsk(
    'm_recent',
    _m,
    'Could a recently started or changed medicine be causing this?',
  ),
  'nothing_helped': DoctorAsk(
    'm_nothing',
    _m,
    'Nothing tried so far has helped. What else can be done?',
  ),
  'caregiver': DoctorAsk(
    'h_family',
    _h,
    'What should we, as family, do or watch for at home?',
  ),
  'mobility': DoctorAsk(
    'h_falls',
    _h,
    'How can we prevent falls at home while the patient is unwell?',
  ),
  'hospital': DoctorAsk(
    'u_hospital',
    _u,
    'Could this be linked to the recent hospital stay?',
  ),
  'contagious': DoctorAsk(
    'u_spread',
    _u,
    'Can this spread to others at home? How can that be prevented?',
  ),
};

/// For each symptom, its key question first: that one is always included.
/// For each symptom, its key question first: that one is always included.
const symptomAsks = <Symptom, List<DoctorAsk>>{
  Symptom.fever: [
    DoctorAsk('fe_high', _f, 'What temperature is too high and needs a visit?'),
    DoctorAsk(
      'fe_fluids',
      _h,
      'How much fluid and rest is needed during the fever?',
    ),
  ],
  Symptom.headache: [
    DoctorAsk(
      'hd_trigger',
      _h,
      'Is there anything to keep track of, like sleep, screen time or stress?',
    ),
    DoctorAsk(
      'hd_painkiller',
      _m,
      'How often is it safe to take a painkiller for headache?',
    ),
  ],
  Symptom.bodyPain: [
    DoctorAsk(
      'bp_exercise',
      _h,
      'Would exercises or physiotherapy help the pain?',
    ),
    DoctorAsk(
      'bp_avoid',
      _h,
      'Which movements should be avoided until it heals?',
    ),
  ],
  Symptom.chestPain: [
    DoctorAsk(
      'cp_heart',
      _u,
      'Is this chest pain coming from the heart, or from something else?',
    ),
    DoctorAsk('cp_ecg', _t, 'Is an ECG or another heart test needed?'),
  ],
  Symptom.breathless: [
    DoctorAsk(
      'br_cause',
      _u,
      'Is the breathlessness from the heart, the lungs, or something else?',
    ),
    DoctorAsk(
      'br_limit',
      _h,
      'How much walking or climbing stairs is safe for now?',
    ),
  ],
  Symptom.cough: [
    DoctorAsk(
      'co_long',
      _u,
      'How long will the cough last? When would it need another visit?',
    ),
    DoctorAsk('co_test', _t, 'Is a chest X-ray or a phlegm test needed?'),
  ],
  Symptom.dizziness: [
    DoctorAsk(
      'dz_bp',
      _u,
      'Could blood pressure or the medicines be causing the dizziness?',
    ),
    DoctorAsk('dz_safe', _h, 'How can falls be avoided during dizzy spells?'),
  ],
  Symptom.tiredness: [
    DoctorAsk(
      'ti_blood',
      _t,
      'Could a blood test show the reason for the tiredness, like low blood or thyroid?',
    ),
  ],
  Symptom.stomach: [
    DoctorAsk('st_ors', _h, 'How can dehydration be prevented? Is ORS needed?'),
    DoctorAsk('st_food', _h, 'Which foods are best to eat or avoid for now?'),
  ],
  Symptom.poorSleep: [
    DoctorAsk(
      'sl_cause',
      _u,
      'Could the sleep problem be linked to another health problem or a medicine?',
    ),
    DoctorAsk('sl_habits', _h, 'What can be changed at night to sleep better?'),
  ],
  Symptom.poorAppetite: [
    DoctorAsk(
      'ap_cause',
      _u,
      'Could a medicine or another illness be causing the low appetite?',
    ),
    DoctorAsk('ap_food', _h, 'What can help with eating enough?'),
  ],
  Symptom.lowMood: [
    DoctorAsk(
      'md_treat',
      _u,
      'Could this be depression or anxiety? Can it be treated?',
    ),
    DoctorAsk('md_talk', _m, 'Would talking to a counsellor help?'),
  ],
};

const conditionAsks = <HealthCondition, List<DoctorAsk>>{
  HealthCondition.diabetes: [
    DoctorAsk(
      'c_sugar',
      _u,
      'Could the sugar levels be linked to this problem?',
    ),
    DoctorAsk(
      'c_sugar_check',
      _h,
      'Should sugar be checked more often while this is going on?',
    ),
  ],
  HealthCondition.highBp: [
    DoctorAsk('c_bp', _u, 'Could blood pressure be linked to this problem?'),
    DoctorAsk(
      'c_bp_check',
      _h,
      'Should BP be checked at home? Which readings are a worry?',
    ),
  ],
  HealthCondition.heart: [
    DoctorAsk('c_heart', _u, 'Could this be related to the heart condition?'),
  ],
  HealthCondition.thyroid: [
    DoctorAsk(
      'c_thyroid',
      _t,
      'Could the thyroid be linked to this? Should it be tested again?',
    ),
  ],
  HealthCondition.kidney: [
    DoctorAsk('c_kidney', _m, 'Are the new medicines safe for the kidneys?'),
  ],
  HealthCondition.asthma: [
    DoctorAsk(
      'c_asthma',
      _m,
      'Is the asthma affecting this? Is the inhaler plan still right?',
    ),
  ],
  HealthCondition.cholesterol: [
    DoctorAsk(
      'c_cholesterol',
      _u,
      'Could cholesterol be linked to this problem?',
    ),
  ],
  HealthCondition.arthritis: [
    DoctorAsk(
      'c_arthritis',
      _u,
      'Could the arthritis be linked to this problem?',
    ),
  ],
  HealthCondition.stroke: [
    DoctorAsk('c_stroke', _u, 'Could this be related to the past stroke?'),
  ],
  HealthCondition.cancer: [
    DoctorAsk(
      'c_cancer',
      _u,
      'Could this be related to the cancer or its treatment?',
    ),
  ],
};

/// One question per topic that a list must never go without.
const essentialAsks = {
  QuestionTopic.understand: 'u_cause',
  QuestionTopic.tests: 't_need',
  QuestionTopic.treatment: 'm_what',
  QuestionTopic.home: 'h_do',
  QuestionTopic.followUp: 'f_warning',
};
