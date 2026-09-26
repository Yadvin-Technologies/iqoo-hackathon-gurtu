// Mock care record used until capture (voice, camera, OCR) and Gemma 4 are
// wired in. Shaped exactly like real data: every item is a CareMoment, and
// non-English moments carry the English `translation` Gemma 4 will produce
// at capture time.

import '../memory/models.dart';

class MockPatient {
  const MockPatient({
    required this.id,
    required this.name,
    required this.age,
    required this.conditions,
    required this.hospital,
    required this.doctor,
  });

  final String id;
  final String name;
  final int age;
  final List<String> conditions;
  final String hospital;
  final String doctor;
}

class MockCircleMember {
  const MockCircleMember(this.name, this.role, this.relation);

  final String name;
  final String role;
  final String relation;
}

const mockPatient = MockPatient(
  id: 'amma',
  name: 'Lakshmi (Amma)',
  age: 62,
  conditions: ['Type 2 diabetes', 'Hypertension'],
  hospital: 'Yashoda Hospital, Somajiguda',
  doctor: 'Dr. Srinivas Rao',
);

const mockCircle = [
  MockCircleMember('Lakshmi', 'Patient', 'Amma'),
  MockCircleMember('Ravi', 'Caregiver', 'Son'),
  MockCircleMember('Priya', 'Caregiver', 'Daughter-in-law'),
  MockCircleMember('Kiran', 'Family member', 'Grandson'),
  MockCircleMember('Sunitha', 'Trusted helper', 'Home help'),
];

final DateTime _d0 = DateTime(2026, 9, 18, 10);
DateTime _day(int d, [int h = 9, int m = 0]) =>
    _d0.add(Duration(days: d, hours: h - 10, minutes: m));

const _p = 'amma';

/// Seven days after discharge, across English, Telugu, Hindi and
/// Latin-script Tenglish/Hinglish. Includes the pitch's conflict case: the
/// prescription says Telma *before* breakfast, the recorded doctor says
/// *after*.
final List<CareMoment> mockMoments = [
  CareMoment(
    id: 'e11',
    patientId: _p,
    sourceType: SourceType.dischargeSummary,
    createdAt: _day(0, 10),
    sourceUri: 'docs/discharge_2026-09-18.pdf',
    language: 'en',
    text:
        'Admitted with uncontrolled hypertension. Discharged on 18 Sep in '
        'stable condition. Advice: low salt diet, walk 30 minutes daily, avoid '
        'pickles and papad.',
  ),
  CareMoment(
    id: 'e1',
    patientId: _p,
    sourceType: SourceType.doctorAudio,
    createdAt: _day(0, 11),
    sourceUri: 'audio/consult_2026-09-18.m4a',
    author: 'Ravi',
    language: 'en',
    verified: true,
    segments: const [
      TranscriptSegment(
        'Continue Metformin 500 milligrams twice a day, one after breakfast '
        'and one after dinner.',
        startMs: 62000,
        endMs: 69000,
      ),
      TranscriptSegment(
        'Stop the Glycomet GP you were taking earlier.',
        startMs: 69000,
        endMs: 72500,
      ),
      TranscriptSegment(
        'Come back after two weeks with fasting sugar and HbA1c reports.',
        startMs: 95000,
        endMs: 100000,
      ),
    ],
  ),
  CareMoment(
    id: 'e15',
    patientId: _p,
    sourceType: SourceType.doctorAudio,
    createdAt: _day(0, 11, 5),
    sourceUri: 'audio/consult_2026-09-18.m4a',
    author: 'Ravi',
    language: 'en',
    segments: const [
      TranscriptSegment(
        'Telma 40 for the BP, you can take it after breakfast with some food.',
        startMs: 131000,
        endMs: 137000,
      ),
    ],
  ),
  CareMoment(
    id: 't1',
    patientId: _p,
    sourceType: SourceType.doctorAudio,
    createdAt: _day(0, 11, 8),
    sourceUri: 'audio/consult_2026-09-18.m4a',
    language: 'te',
    translation:
        'Take the Metformin tablet after the evening meal. Take Atorva at '
        'night before going to sleep.',
    segments: const [
      TranscriptSegment(
        'సాయంత్రం భోజనం తర్వాత మెట్‌ఫార్మిన్ మాత్ర వేసుకోవాలి. రాత్రి పడుకునే '
        'ముందు అటోర్వా వేసుకోండి.',
        startMs: 150000,
        endMs: 158000,
      ),
    ],
  ),
  CareMoment(
    id: 'h3',
    patientId: _p,
    sourceType: SourceType.doctorAudio,
    createdAt: _day(0, 11, 12),
    sourceUri: 'audio/consult_2026-09-18.m4a',
    language: 'hi',
    text: 'अगर शुगर 70 से कम हो जाए तो तुरंत ग्लूकोज़ या चीनी का पानी दें।',
    translation:
        'If the sugar drops below 70, immediately give glucose or sugar water.',
  ),
  CareMoment(
    id: 'e2',
    patientId: _p,
    sourceType: SourceType.prescription,
    createdAt: _day(0, 11, 20),
    sourceUri: 'scans/rx_2026-09-18.jpg',
    author: 'Priya',
    language: 'en',
    verified: true,
    text:
        'Rx: Tab Metformin 500mg 1-0-1 after food. Tab Telma 40 (Telmisartan) '
        '1-0-0 before breakfast. Tab Ecosprin 75 0-1-0 after lunch. Tab Atorva '
        '10 0-0-1 at bedtime. Review after 14 days.',
  ),
  CareMoment(
    id: 'e8',
    patientId: _p,
    sourceType: SourceType.nurseAudio,
    createdAt: _day(0, 12),
    sourceUri: 'audio/nurse_2026-09-18.m4a',
    author: 'Priya',
    language: 'en',
    text:
        'Check her feet daily for any cuts or swelling since she is diabetic. '
        'Use the moisturiser but not between the toes.',
  ),
  CareMoment(
    id: 't4',
    patientId: _p,
    sourceType: SourceType.nurseAudio,
    createdAt: _day(0, 12, 10),
    sourceUri: 'audio/nurse_2026-09-18.m4a',
    language: 'te',
    text: 'ఉప్పు తక్కువగా తినాలి, ఊరగాయలు మరియు అప్పడాలు మానేయాలి.',
    translation: 'Eat less salt, and stop eating pickles and papads.',
  ),
  CareMoment(
    id: 'm3',
    patientId: _p,
    sourceType: SourceType.nurseAudio,
    createdAt: _day(0, 12, 20),
    language: 'hi-Latn',
    text: 'Insulin abhi nahi hai, sirf tablets. Sugar hafte mein do baar check karo.',
    translation: 'No insulin for now, only tablets. Check sugar twice a week.',
  ),
  CareMoment(
    id: 'e3',
    patientId: _p,
    sourceType: SourceType.pharmacistAudio,
    createdAt: _day(0, 13),
    sourceUri: 'audio/pharmacy_2026-09-18.m4a',
    author: 'Ravi',
    language: 'en',
    text:
        'The Pan 40 tablet is for acidity, take it on an empty stomach 30 '
        'minutes before breakfast. Do not take it with milk.',
  ),
  CareMoment(
    id: 'h1',
    patientId: _p,
    sourceType: SourceType.pharmacistAudio,
    createdAt: _day(0, 13, 5),
    sourceUri: 'audio/pharmacy_2026-09-18.m4a',
    language: 'hi',
    text: 'मेटफॉर्मिन खाना खाने के बाद ही लें, खाली पेट लेने से पेट खराब हो सकता है।',
    translation:
        'Take Metformin only after eating food; taking it on an empty stomach '
        'can upset the stomach.',
  ),
  CareMoment(
    id: 'e12',
    patientId: _p,
    sourceType: SourceType.medicinePackage,
    createdAt: _day(0, 14),
    sourceUri: 'scans/ecosprin_pack.jpg',
    language: 'en',
    text:
        'Ecosprin 75: aspirin 75 mg gastro-resistant tablets. Batch EC2291. '
        'Expiry 03/2028.',
  ),
  CareMoment(
    id: 'm1',
    patientId: _p,
    sourceType: SourceType.familyVoice,
    createdAt: _day(1, 8),
    sourceUri: 'audio/voice_ravi_0919.m4a',
    author: 'Ravi',
    language: 'te-Latn',
    text:
        'Doctor garu cheppinattu Telma tablet morning tiffin mundu veyyali, '
        'tiffin tarvata kaadu.',
    translation:
        'As the doctor said, the Telma tablet should be taken before morning '
        'breakfast, not after breakfast.',
  ),
  CareMoment(
    id: 'e10',
    patientId: _p,
    sourceType: SourceType.note,
    createdAt: _day(1, 21, 15),
    author: 'Priya',
    language: 'en',
    text: 'Evening medicine given at 9:15 PM: Atorva 10 and Metformin.',
  ),
  CareMoment(
    id: 'e5',
    patientId: _p,
    sourceType: SourceType.vitalReading,
    createdAt: _day(2, 7),
    author: 'Priya',
    language: 'en',
    text: 'Fasting blood sugar 168 mg/dL on the glucometer.',
  ),
  CareMoment(
    id: 'e6',
    patientId: _p,
    sourceType: SourceType.familyVoice,
    createdAt: _day(2, 19),
    sourceUri: 'audio/voice_ravi_0920.m4a',
    author: 'Ravi',
    language: 'en',
    text:
        'Amma felt dizzy after her evening walk, sat down for ten minutes and '
        'it passed.',
  ),
  CareMoment(
    id: 'e4',
    patientId: _p,
    sourceType: SourceType.vitalReading,
    createdAt: _day(3, 7, 40),
    sourceUri: 'vitals/bp_2026-09-21.jpg',
    author: 'Priya',
    language: 'en',
    text: 'BP 152/94, pulse 88. Taken at 7:40 AM before medicines.',
  ),
  CareMoment(
    id: 't3',
    patientId: _p,
    sourceType: SourceType.note,
    createdAt: _day(3, 14),
    author: 'Sunitha',
    language: 'te',
    text: 'అమ్మ ఈ రోజు మధ్యాహ్నం భోజనం తర్వాత ఎకోస్ప్రిన్ వేసుకుంది.',
    translation: 'Amma took Ecosprin today after lunch.',
  ),
  CareMoment(
    id: 'm2',
    patientId: _p,
    sourceType: SourceType.familyVoice,
    createdAt: _day(3, 20),
    author: 'Priya',
    language: 'te-Latn',
    text: 'Amma ki BP tablet evening kuda ivvala? Doctor ni adagali.',
    translation:
        'Should Amma be given the BP tablet in the evening too? We need to ask '
        'the doctor.',
  ),
  CareMoment(
    id: 't2',
    patientId: _p,
    sourceType: SourceType.familyVoice,
    createdAt: _day(4, 8),
    sourceUri: 'audio/voice_kiran_0922.m4a',
    author: 'Kiran',
    language: 'te',
    text: 'అమ్మమ్మకి ఈరోజు ఉదయం తల తిరిగింది, బీపీ చూస్తే 160/100 వచ్చింది.',
    translation:
        'Grandma felt dizzy this morning; when we checked her BP it was '
        '160/100.',
  ),
  CareMoment(
    id: 'e13',
    patientId: _p,
    sourceType: SourceType.note,
    createdAt: _day(4, 17),
    author: 'Kiran',
    language: 'en',
    text:
        'Physio said to do ankle exercises 10 times, three sets a day, for the '
        'knee pain.',
  ),
  CareMoment(
    id: 'e7',
    patientId: _p,
    sourceType: SourceType.task,
    createdAt: _day(4, 18),
    author: 'Ravi',
    language: 'en',
    text:
        'Blood test tomorrow at 9 AM at Vijaya Diagnostics, Ameerpet. Fasting '
        'required, no food after 10 PM.',
  ),
  CareMoment(
    id: 't6',
    patientId: _p,
    sourceType: SourceType.task,
    createdAt: _day(4, 18, 5),
    author: 'Kiran',
    language: 'te',
    text: 'రేపు ఉదయం 9 గంటలకు రక్త పరీక్ష, రాత్రి 10 తర్వాత ఏమీ తినకూడదు.',
    translation:
        'Blood test tomorrow at 9 in the morning; do not eat anything after '
        '10 at night.',
  ),
  CareMoment(
    id: 'e9',
    patientId: _p,
    sourceType: SourceType.labReport,
    createdAt: _day(5, 16),
    sourceUri: 'docs/lab_2026-09-23.pdf',
    author: 'Ravi',
    language: 'en',
    text:
        'HbA1c 8.2%. Serum creatinine 0.9 mg/dL. LDL cholesterol 132 mg/dL.',
  ),
  CareMoment(
    id: 'm4',
    patientId: _p,
    sourceType: SourceType.note,
    createdAt: _day(5, 7),
    author: 'Sunitha',
    language: 'hi-Latn',
    text: 'Kal raat Mummy ko khansi thi, garam paani diya.',
    translation: 'Mummy had a cough last night; we gave her warm water.',
  ),
  CareMoment(
    id: 't5',
    patientId: _p,
    sourceType: SourceType.familyVoice,
    createdAt: _day(5, 19),
    sourceUri: 'audio/voice_priya_0923.m4a',
    author: 'Priya',
    language: 'te',
    text: 'కాళ్ళ వాపు కొంచెం ఎక్కువగా ఉంది, సాయంత్రానికి చీలమండలు ఉబ్బుతున్నాయి.',
    translation:
        'The leg swelling is a little more; her ankles are swelling by the '
        'evening.',
  ),
  CareMoment(
    id: 'e14',
    patientId: _p,
    sourceType: SourceType.task,
    createdAt: _day(5, 20),
    author: 'Ravi',
    language: 'en',
    text:
        'Follow-up with Dr. Srinivas Rao on 3 October at 11 AM, Yashoda '
        'Hospital Somajiguda. Carry all reports.',
  ),
  CareMoment(
    id: 'h4',
    patientId: _p,
    sourceType: SourceType.note,
    createdAt: _day(6, 8),
    author: 'Sunitha',
    language: 'hi',
    text: 'रात को नींद ठीक से नहीं आई, दो बार पेशाब के लिए उठीं।',
    translation:
        'She did not sleep well at night; she woke up twice to urinate.',
  ),
  CareMoment(
    id: 'h2',
    patientId: _p,
    sourceType: SourceType.familyVoice,
    createdAt: _day(6, 10),
    sourceUri: 'audio/voice_sunitha_0924.m4a',
    author: 'Sunitha',
    language: 'hi',
    text: 'माताजी ने आज सुबह की दवा नहीं ली, उन्होंने कहा कि जी मिचला रहा है।',
    translation:
        'Mataji did not take her morning medicine today; she said she was '
        'feeling nauseous.',
  ),
];
