// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get continueLabel => 'Continue';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get later => 'Later';

  @override
  String get back => 'Back';

  @override
  String get optional => 'Optional';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get notSure => 'Not sure';

  @override
  String get tagline => 'Remember. Care. Together.';

  @override
  String get motherName => 'Amma';

  @override
  String get phaseAbout => 'About';

  @override
  String get phaseHealth => 'Health';

  @override
  String get phasePermissions => 'Permissions';

  @override
  String get phaseAi => 'AI setup';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $current of $total';
  }

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageSubtitle =>
      'Gurtu will speak, listen and write in this language.';

  @override
  String get languageMixNote =>
      'Doctors often mix English with your language. Gurtu understands both together.';

  @override
  String get welcomeTitle => 'Your family\'s\nmemory of care';

  @override
  String get welcomeBody =>
      'What the doctor said, what was prescribed and what happened at home — remembered together.';

  @override
  String get welcomeScript => 'Different roles. Same love.';

  @override
  String get getStarted => 'Get started';

  @override
  String builtForBrand(String brand) {
    return 'Built for $brand';
  }

  @override
  String get madeInHyderabad => 'Made in Hyderabad';

  @override
  String get introRecordEyebrow => '1 · Record';

  @override
  String get introRecordTitle => 'Never forget what the doctor said';

  @override
  String get introRecordBody =>
      'With everyone\'s consent, record the doctor, nurse or pharmacist. Gurtu keeps the important parts.';

  @override
  String get introPlanEyebrow => '2 · Understand & share';

  @override
  String get introPlanTitle => 'One care plan for the whole family';

  @override
  String get introPlanBody =>
      'Scan prescriptions and reports. Gurtu turns them into simple tasks the family can share.';

  @override
  String get introAskEyebrow => '3 · Ask & remember';

  @override
  String get introAskTitle => 'Ask anything, see the proof';

  @override
  String get introAskBody =>
      'Every answer shows where it came from — the recording, the prescription or the photo.';

  @override
  String get letsSetUp => 'Let\'s set up';

  @override
  String get hospitalMode => 'Hospital Mode';

  @override
  String get consentRecording => 'Recording with consent of everyone present';

  @override
  String get doctorConversation => 'Doctor\'s conversation';

  @override
  String get nurseInstructions => 'Nurse instructions';

  @override
  String get pharmacistAdvice => 'Pharmacist advice';

  @override
  String get yourCarePlan => 'Your Care Plan';

  @override
  String get afterBreakfast => 'After breakfast';

  @override
  String get checkBloodPressure => 'Check blood pressure';

  @override
  String get twiceDaily => 'Twice daily';

  @override
  String get bloodTest => 'Blood test (CBC)';

  @override
  String get instructionsFound =>
      '4 instructions found in your recordings and prescription';

  @override
  String get askQuestion =>
      'What did the doctor say about the evening medicine?';

  @override
  String get askAnswer => 'The doctor said to take Amlodipine after dinner.';

  @override
  String get sourceDoctorVisit => 'Source: Doctor visit';

  @override
  String get careForTitle => 'Who are you setting up Gurtu for?';

  @override
  String get careForSubtitle =>
      'Gurtu builds one care memory around one person. You can invite the rest of the family later.';

  @override
  String get careForMyself => 'Myself';

  @override
  String get careForMyselfHint => 'I want to keep track of my own care';

  @override
  String get careForParent => 'My parent';

  @override
  String get careForParentHint => 'Mother, father or an elder in the family';

  @override
  String get careForPartner => 'My partner';

  @override
  String get careForPartnerHint => 'Husband, wife or partner';

  @override
  String get careForChild => 'My child';

  @override
  String get careForChildHint => 'Son or daughter';

  @override
  String get careForOther => 'Someone else';

  @override
  String get careForOtherHint => 'Relative, friend or neighbour';

  @override
  String get profileTitleSelf => 'Tell us about you';

  @override
  String get profileTitleOther => 'Tell us about them';

  @override
  String get profileSubtitleSelf => 'This helps Gurtu talk to you by name.';

  @override
  String get profileSubtitleOther => 'Use the name you call them at home.';

  @override
  String get yourName => 'Your name';

  @override
  String get whatDoYouCallThem => 'What do you call them?';

  @override
  String exampleName(String name) {
    return 'e.g. $name';
  }

  @override
  String get sampleSelfName => 'Lakshmi';

  @override
  String get sampleYourName => 'Priya';

  @override
  String get yourAge => 'Your age';

  @override
  String get theirAge => 'Their age';

  @override
  String get years => 'years';

  @override
  String get decreaseAge => 'Decrease age';

  @override
  String get increaseAge => 'Increase age';

  @override
  String get gender => 'Gender';

  @override
  String get female => 'Female';

  @override
  String get male => 'Male';

  @override
  String get genderOther => 'Other';

  @override
  String get andYou => 'And you?';

  @override
  String get andYouBody => 'You\'ll be the first member of their Care Circle.';

  @override
  String get conditionsTitleSelf =>
      'Do you have any of these health conditions?';

  @override
  String conditionsTitleOther(String name) {
    return 'Does $name have any of these health conditions?';
  }

  @override
  String get conditionsSubtitle =>
      'Tap all that apply. This helps Gurtu organise the care plan.';

  @override
  String get condDiabetes => 'Sugar (Diabetes)';

  @override
  String get condHighBp => 'High BP';

  @override
  String get condHeart => 'Heart problem';

  @override
  String get condThyroid => 'Thyroid';

  @override
  String get condCholesterol => 'Cholesterol';

  @override
  String get condAsthma => 'Asthma / breathing';

  @override
  String get condKidney => 'Kidney problem';

  @override
  String get condArthritis => 'Joint pain / arthritis';

  @override
  String get condStroke => 'Past stroke';

  @override
  String get condCancer => 'Cancer care';

  @override
  String get noneOfThese => 'None of these';

  @override
  String get notADoctor =>
      'Gurtu is not a doctor. It never diagnoses — it only helps your family remember and organise care.';

  @override
  String get medicinesTitleSelf => 'Do you take medicines every day?';

  @override
  String medicinesTitleOther(String name) {
    return 'Does $name take medicines every day?';
  }

  @override
  String get medicinesSubtitle =>
      'Include tablets, syrups, inhalers or insulin.';

  @override
  String get howMany => 'About how many?';

  @override
  String get sixOrMore => '6 or more';

  @override
  String get scanLaterTip =>
      'Later, just scan the prescription or medicine strip — no typing needed.';

  @override
  String get allergiesTitleSelf => 'Are you allergic to anything?';

  @override
  String allergiesTitleOther(String name) {
    return 'Is $name allergic to anything?';
  }

  @override
  String get allergiesSubtitle =>
      'Gurtu will show this on every Doctor Brief so it is never missed.';

  @override
  String get allergyNone => 'No known allergies';

  @override
  String get allergyPenicillin => 'Penicillin';

  @override
  String get allergySulfa => 'Sulfa drugs';

  @override
  String get allergyAspirin => 'Aspirin / painkillers';

  @override
  String get allergyFood => 'Food allergy';

  @override
  String get allergyDust => 'Dust / pollen';

  @override
  String get allergyLatex => 'Latex';

  @override
  String get mobilityTitleSelf => 'How do you get around day to day?';

  @override
  String mobilityTitleOther(String name) {
    return 'How does $name get around day to day?';
  }

  @override
  String get mobilitySubtitle =>
      'This helps the family plan visits, tests and help at home.';

  @override
  String get mobilityIndependent => 'Walks on their own';

  @override
  String get mobilityIndependentHint => 'No help needed day to day';

  @override
  String get mobilitySomeHelp => 'Needs some help';

  @override
  String get mobilitySomeHelpHint => 'Stick, walker or a hand to hold';

  @override
  String get mobilityFullHelp => 'Mostly in bed or wheelchair';

  @override
  String get mobilityFullHelpHint => 'Needs help for most things';

  @override
  String get hospitalTitleSelf =>
      'Have you been to a hospital or doctor in the last 30 days?';

  @override
  String hospitalTitleOther(String name) {
    return 'Has $name been to a hospital or doctor in the last 30 days?';
  }

  @override
  String get hospitalSubtitle =>
      'Recent visits usually come with new instructions to track.';

  @override
  String get hospitalTip =>
      'Keep the discharge papers and prescriptions handy — you can scan them right after setup.';

  @override
  String get permissionsTitle => 'A few permissions to help you';

  @override
  String get permissionsSubtitle =>
      'Gurtu only asks for what it needs. Here is exactly why.';

  @override
  String get permMic => 'Microphone';

  @override
  String get permMicWhy =>
      'Record doctor visits and voice notes — only when you tap record.';

  @override
  String get permCamera => 'Camera';

  @override
  String get permCameraWhy =>
      'Scan prescriptions, medicine strips and BP machine readings.';

  @override
  String get permNotifications => 'Notifications';

  @override
  String get permNotificationsWhy =>
      'Medicine reminders and updates when family completes a task.';

  @override
  String get permPhotos => 'Photos & files';

  @override
  String get permPhotosWhy =>
      'Add reports and prescriptions already saved in your gallery.';

  @override
  String get permContacts => 'Contacts';

  @override
  String get permContactsWhy =>
      'Quickly invite family members to the Care Circle.';

  @override
  String get needed => 'Needed';

  @override
  String get allow => 'Allow';

  @override
  String get allowed => 'Allowed';

  @override
  String get allowAndContinue => 'Allow & continue';

  @override
  String get privacyNote =>
      'Everything stays on this phone. Recording never starts on its own — it always shows a consent screen first.';

  @override
  String permissionBlocked(String permission) {
    return '$permission is blocked. Turn it on in Settings.';
  }

  @override
  String get settings => 'Settings';

  @override
  String permissionsMissing(String items) {
    return 'Without $items, some features won\'t work. You can allow it later.';
  }

  @override
  String get modelTitleChoose => 'Set up Gurtu\'s on-device AI';

  @override
  String get modelTitleDownloading => 'Setting up your AI…';

  @override
  String get modelTitleDone => 'Your AI is ready';

  @override
  String get modelSubtitleChoose =>
      'These models run fully on your iQOO. Your family\'s health data never leaves the phone — and it works without internet.';

  @override
  String get modelSubtitleDownloading =>
      'You can keep using your phone. This happens only once.';

  @override
  String get modelSubtitleDone =>
      'Everything runs on this phone, even offline.';

  @override
  String get poweredByIqoo => 'Powered by your iQOO';

  @override
  String get deviceCardSub => 'On-device AI · Private · Works offline';

  @override
  String get chooseCareModel => 'Choose the care model';

  @override
  String get careModelHint => 'This is the brain that answers questions.';

  @override
  String get alwaysIncluded => 'Always included';

  @override
  String get jobListens => 'Listens';

  @override
  String get jobReads => 'Reads';

  @override
  String get jobSees => 'Sees';

  @override
  String get jobUnderstands => 'Understands';

  @override
  String speechModelName(String language) {
    return 'Speech · $language + English';
  }

  @override
  String get speechModelWhat =>
      'Turns conversations into text in your language.';

  @override
  String get readerModelName => 'Document reader (OCR)';

  @override
  String get readerModelWhat =>
      'Reads prescriptions, discharge papers and lab reports.';

  @override
  String get visionModelName => 'Medicine & vitals vision';

  @override
  String get visionModelWhat =>
      'Recognises medicine strips and BP / sugar machine numbers.';

  @override
  String careModelName(String model) {
    return 'Care model · $model';
  }

  @override
  String get tierLite => 'Lite';

  @override
  String get tierBalanced => 'Balanced';

  @override
  String get tierPro => 'Pro';

  @override
  String get tierLiteNote => 'Fastest. Short, simple answers.';

  @override
  String get tierBalancedNote => 'Understands voice, photos and text together.';

  @override
  String get tierProNote => 'Most detailed answers and Doctor Briefs.';

  @override
  String get bestForIqoo => 'Best for iQOO';

  @override
  String get wifiOnly => 'Download on Wi-Fi only';

  @override
  String downloadSize(String size) {
    return 'Download · $size';
  }

  @override
  String get settingUp => 'Setting up…';

  @override
  String get ready => 'Ready';

  @override
  String allSetName(String name) {
    return 'All set, $name!';
  }

  @override
  String get allSet => 'You\'re all set!';

  @override
  String get readySelf => 'Your care memory is ready.';

  @override
  String readyOther(String name) {
    return '$name\'s care memory is ready. Next, invite the family.';
  }

  @override
  String get rowYou => 'You';

  @override
  String get rowCaringFor => 'Caring for';

  @override
  String get rowHealth => 'Health';

  @override
  String get rowAllergies => 'Allergies';

  @override
  String get rowLanguage => 'Language';

  @override
  String get rowAi => 'On-device AI';

  @override
  String get notAdded => 'Not added';

  @override
  String ageYears(int age) {
    return '$age years';
  }

  @override
  String get careQuote => '“Care is lighter when we do it together.”';

  @override
  String get enterGurtu => 'Enter Gurtu';

  @override
  String get nextUpCareCircle => 'Next up: Care Circle';

  @override
  String get homeComingSoon =>
      'The home screens are coming in the next section.';

  @override
  String get restartOnboarding => 'Restart onboarding';

  @override
  String get navHome => 'Home';

  @override
  String get navMemory => 'Memory';

  @override
  String get navCircle => 'Circle';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'Profile';

  @override
  String goodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String goodEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Welcome to Gurtu, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'Your family\'s healthcare, remembered together.';

  @override
  String get caringFor => 'Caring for';

  @override
  String get switchPatientTitle => 'Who are you caring for?';

  @override
  String get addAnotherPerson => 'Add another person';

  @override
  String get statusOnTrack => 'Care is on track';

  @override
  String get statusNeedsAttention => 'Something needs attention';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'Emergency';

  @override
  String get sosHoldTitle => 'Hold to alert your Care Circle';

  @override
  String get sosHoldBody =>
      'Press and hold the button for 2 seconds. Your emergency contacts will be alerted.';

  @override
  String get sosHoldButton => 'Hold to send SOS';

  @override
  String get sosKeepHolding => 'Keep holding…';

  @override
  String get sosPreviewNote =>
      'Emergency alerts are not connected yet. This is a preview — no one will be alerted.';

  @override
  String get sosPreviewDone => 'Preview finished. No one was alerted.';

  @override
  String get close => 'Close';

  @override
  String get todayCare => 'Today\'s care';

  @override
  String completedOf(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get viewTodayCare => 'View today\'s care';

  @override
  String get nothingUrgent => 'Nothing urgent right now.';

  @override
  String get markDone => 'Mark as done';

  @override
  String get markNotDone => 'Mark as not done';

  @override
  String get openToCircle => 'Open to Care Circle';

  @override
  String get captureCare => 'Capture Care';

  @override
  String get captureCareSubtitle =>
      'Record something important for the care journey.';

  @override
  String get whatHappened => 'What happened?';

  @override
  String get captureVoice => 'Voice';

  @override
  String get captureVoiceHint => 'Record a conversation or voice note';

  @override
  String get captureScan => 'Scan';

  @override
  String get captureScanHint => 'Prescription or medicine strip';

  @override
  String get captureVital => 'Vital';

  @override
  String get captureVitalHint => 'BP, sugar or temperature';

  @override
  String get captureDocument => 'Document';

  @override
  String get captureDocumentHint => 'Discharge paper or lab report';

  @override
  String get captureNote => 'Note';

  @override
  String get captureNoteHint => 'Write what happened';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get noteHint => 'e.g. Felt dizzy after walking';

  @override
  String get saveNote => 'Save note';

  @override
  String get noteSaved => 'Saved to care memory';

  @override
  String get recentMemory => 'Recent memory';

  @override
  String get viewAll => 'View all';

  @override
  String get emptyMemory => 'Your care story starts here.';

  @override
  String addedBy(String name) {
    return 'by $name';
  }

  @override
  String get sourcePlay => 'Play';

  @override
  String get sourceView => 'View';

  @override
  String get sourceOpen => 'Open';

  @override
  String get sourceTitle => 'Source';

  @override
  String get sourceRecording => 'Doctor recording';

  @override
  String get sourceScan => 'Prescription scan';

  @override
  String get sourceVital => 'Vital reading';

  @override
  String get sourceDocument => 'Document';

  @override
  String get sourceNote => 'Written note';

  @override
  String get sourceSampleNote =>
      'This is sample data, so there is no original file. Real recordings and scans will open here.';

  @override
  String get yourCareCircle => 'Your Care Circle';

  @override
  String get manageCircle => 'Manage circle';

  @override
  String get emptyCircle => 'Care is easier together.';

  @override
  String get addFamilyMember => 'Add family member';

  @override
  String get rolePatient => 'Patient';

  @override
  String get roleCaregiver => 'Caregiver';

  @override
  String get roleFamily => 'Family';

  @override
  String get roleHelper => 'Trusted helper';

  @override
  String get askGurtuTitle => 'Ask Gurtu';

  @override
  String get askGurtuPrompt => 'Need help remembering something?';

  @override
  String get askExampleBloodTest => 'When is the blood test?';

  @override
  String get askExampleDoctor => 'What should I ask the doctor tomorrow?';

  @override
  String get askGurtuNote => 'Answers come from your saved care information.';

  @override
  String get gettingReady => 'Getting Gurtu ready';

  @override
  String get readyYourProfile => 'Your profile';

  @override
  String get readyPatientProfile => 'Patient profile';

  @override
  String get readyCareCircle => 'Care Circle';

  @override
  String get readyEmergencyContact => 'Emergency contact';

  @override
  String get previewSampleData => 'Preview with sample data';

  @override
  String get sampleDataOn => 'Showing sample care data';

  @override
  String get remove => 'Remove';

  @override
  String get hide => 'Hide';

  @override
  String get comingNextPhase => 'This section is being built next.';

  @override
  String get fatherName => 'Nanna';

  @override
  String get sampleTaskMorningMedicine => 'Morning medicine';

  @override
  String get sampleTaskRecordBp => 'Record BP';

  @override
  String get sampleTaskBloodTest => 'Blood test';

  @override
  String get sampleTaskDoctorVisit => 'Doctor appointment';

  @override
  String get sampleMomentDoctorTalk => 'Doctor conversation';

  @override
  String get sampleMomentDoctorTalkDetail =>
      '“Take the medicine after breakfast.”';

  @override
  String get sampleMomentPrescription => 'Prescription scanned';

  @override
  String get sampleMomentPrescriptionDetail => '2 medicines found';

  @override
  String get sampleMomentBp => 'BP recorded';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get doctorVisit => 'Doctor visit';

  @override
  String get doctorVisitHint => 'Note what the doctor says';

  @override
  String get askDoctor => 'Questions for the doctor';

  @override
  String get askDoctorHint => 'Gurtu helps you prepare';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions ready',
      one: '1 question ready',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'Last visit: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'Next visit: $date';
  }

  @override
  String get visitsTitle => 'Doctor visits';

  @override
  String get visitsSubtitle => 'What every doctor said, kept in one place.';

  @override
  String get recordVisit => 'Record a visit';

  @override
  String get visitsOverview => 'All visits at a glance';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count visits',
      one: '1 visit',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doctors',
      one: '1 doctor',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'Last visit';

  @override
  String get nextVisit => 'Next visit';

  @override
  String get notPlanned => 'Not planned yet';

  @override
  String get pastVisits => 'Past visits';

  @override
  String get noVisitsTitle => 'No visits recorded yet';

  @override
  String get noVisitsBody =>
      'At the next appointment, tap Record a visit and Gurtu will note what the doctor says.';

  @override
  String get questionsForNextVisit => 'Questions for the next visit';

  @override
  String get prepareQuestionsHint =>
      'Tell Gurtu how you feel. It will suggest what to ask the doctor.';

  @override
  String get prepareQuestions => 'Prepare questions';

  @override
  String get viewQuestions => 'View questions';

  @override
  String get doctorFallback => 'Doctor';

  @override
  String get doctorSaid => 'What the doctor said';

  @override
  String get medicinesSection => 'Medicines';

  @override
  String get testsSection => 'Tests to do';

  @override
  String get questionsAsked => 'Questions asked';

  @override
  String askedOf(int asked, int total) {
    return '$asked of $total asked';
  }

  @override
  String get deleteVisit => 'Delete visit';

  @override
  String get deleteVisitConfirm => 'Delete this visit? This cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get doctorName => 'Doctor\'s name';

  @override
  String get doctorNameHint => 'e.g. Dr. Meena Rao';

  @override
  String get visitReason => 'Reason for the visit';

  @override
  String get visitReasonHint => 'e.g. Sugar check-up';

  @override
  String get visitDate => 'Date of visit';

  @override
  String get listenToDoctor => 'Listen to the doctor';

  @override
  String get stopListening => 'Stop listening';

  @override
  String get speak => 'Speak';

  @override
  String get recordingConsent =>
      'Let the doctor know you are noting the conversation with Gurtu.';

  @override
  String get doctorSaidHint => 'Speak or type what the doctor says';

  @override
  String get medicinesHint => 'e.g. Metformin 500 mg after breakfast';

  @override
  String get testsHint => 'e.g. HbA1c blood test';

  @override
  String get addNextVisit => 'Add next visit date';

  @override
  String get yourQuestions => 'Your questions';

  @override
  String get tickWhenAsked => 'Tick each one once the doctor has answered.';

  @override
  String get saveVisit => 'Save visit';

  @override
  String get visitSaved => 'Visit saved';

  @override
  String get leaveVisitTitle => 'Leave without saving?';

  @override
  String get leaveVisitBody => 'What you noted for this visit will be lost.';

  @override
  String get discard => 'Discard';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String get voiceUnavailable =>
      'Voice input isn\'t available right now. You can type instead.';

  @override
  String get prepTitle => 'Prepare for the doctor';

  @override
  String get prepIntro =>
      'Let\'s get ready for the doctor. What health problems should we talk about?';

  @override
  String get prepPickOrSay =>
      'Tap the problems below, or say it in your own words.';

  @override
  String get prepDescribeHint =>
      'e.g. Headache for three days and feeling tired';

  @override
  String prepHeard(String symptoms) {
    return 'I heard: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — since when?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — how bad is it?';
  }

  @override
  String get askNewMedicine => 'Was any medicine started or changed recently?';

  @override
  String get askAnythingElse => 'Anything else the doctor should know?';

  @override
  String get urgentWarning =>
      'Severe chest pain or breathlessness can be an emergency. Don\'t wait for the appointment — get medical help now.';

  @override
  String get prepThinking => 'Preparing your questions…';

  @override
  String get prepResultIntro =>
      'Here is what to ask the doctor. Remove any you don\'t need, or add your own.';

  @override
  String get prepNotDoctor =>
      'Gurtu is not a doctor. These questions help you talk to one.';

  @override
  String get addOwnQuestion => 'Add your own question';

  @override
  String get add => 'Add';

  @override
  String get saveQuestions => 'Save for the visit';

  @override
  String get questionsSaved => 'Questions saved for the visit';

  @override
  String get startAgain => 'Start again';

  @override
  String get startVisit => 'Start the visit';

  @override
  String get deleteQuestions => 'Delete these questions';

  @override
  String get removeQuestion => 'Remove question';

  @override
  String get done => 'Done';

  @override
  String get healthProblems => 'Health problems';

  @override
  String preparedOn(String date) {
    return 'Prepared $date';
  }

  @override
  String get symFever => 'Fever';

  @override
  String get symHeadache => 'Headache';

  @override
  String get symBodyPain => 'Body or joint pain';

  @override
  String get symChestPain => 'Chest pain';

  @override
  String get symBreathless => 'Breathlessness';

  @override
  String get symCough => 'Cough';

  @override
  String get symDizziness => 'Dizziness';

  @override
  String get symTiredness => 'Tiredness';

  @override
  String get symStomach => 'Stomach trouble';

  @override
  String get symPoorSleep => 'Poor sleep';

  @override
  String get symPoorAppetite => 'Low appetite';

  @override
  String get symLowMood => 'Low mood or worry';

  @override
  String get kwFever => 'fever,temperature,feverish,chills';

  @override
  String get kwHeadache => 'headache,head ache,head pain,migraine';

  @override
  String get kwBodyPain => 'body pain,joint pain,knee,back pain,leg pain,aches';

  @override
  String get kwChestPain => 'chest pain,chest,heart pain';

  @override
  String get kwBreathless => 'breathless,short of breath,breathing,breath';

  @override
  String get kwCough => 'cough,cold,phlegm';

  @override
  String get kwDizziness => 'dizzy,dizziness,giddy,faint';

  @override
  String get kwTiredness => 'tired,weak,weakness,fatigue';

  @override
  String get kwStomach =>
      'stomach,acidity,gas,vomit,loose motion,diarrhoea,constipation,nausea';

  @override
  String get kwPoorSleep => 'sleep,insomnia';

  @override
  String get kwPoorAppetite => 'appetite,not eating,no hunger';

  @override
  String get kwLowMood =>
      'sad,worried,anxious,anxiety,depressed,stress,tension,feeling low,feel low,hopeless';

  @override
  String get sinceToday => 'Since today';

  @override
  String get sinceFewDays => 'A few days';

  @override
  String get sinceWeek => 'About a week';

  @override
  String get sinceMonth => 'A month or more';

  @override
  String get sevMild => 'Mild';

  @override
  String get sevModerate => 'Moderate';

  @override
  String get sevSevere => 'Severe';

  @override
  String qCause(String symptom) {
    return 'What could be causing the $symptom?';
  }

  @override
  String qTests(String symptom) {
    return 'Does the $symptom need any tests?';
  }

  @override
  String qWarningSigns(String symptom) {
    return 'Which signs with the $symptom mean we should come back straight away?';
  }

  @override
  String qHomeCare(String symptom) {
    return 'What can we do at home to ease the $symptom?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return 'Could the $symptom be linked to $conditions?';
  }

  @override
  String get qSideEffect =>
      'Could a new or changed medicine be causing any of this?';

  @override
  String get qMedicinesStillRight =>
      'Are the current medicines still right, or should any change?';

  @override
  String get qNextCheckup => 'When should we come back for a check-up?';

  @override
  String qTellDoctor(String text) {
    return 'Tell the doctor: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'Diabetes review';

  @override
  String get sampleVisitDiabetesNotes =>
      'Sugar is better controlled. Continue the same medicines. Walk for 30 minutes every day and cut down on sweets.';

  @override
  String get sampleVisitDiabetesMeds =>
      'Metformin 500 mg after breakfast and dinner';

  @override
  String get sampleVisitDiabetesTests =>
      'HbA1c blood test before the next visit';

  @override
  String get sampleVisitKneeReason => 'Knee pain';

  @override
  String get sampleVisitKneeNotes =>
      'Mild arthritis in the right knee. Use a warm compress in the evening and avoid too many stairs.';

  @override
  String get sampleVisitKneeMeds => 'Pain relief gel twice a day';

  @override
  String get scanVerify => 'Scan & verify medicine';

  @override
  String get scanVerifyHint => 'Is this the right tablet, right now?';

  @override
  String scanVerifySubtitle(String name) {
    return 'Scan the strip or box. Gurtu checks it against $name\'s medicine list.';
  }

  @override
  String get scanWithCamera => 'Scan the medicine';

  @override
  String get orTypeName => 'Or type the name printed on the strip';

  @override
  String get typeNameHint => 'e.g. Glycomet 500';

  @override
  String get checkMedicine => 'Check';

  @override
  String get checkAnother => 'Check another medicine';

  @override
  String get readingStrip => 'Reading the strip…';

  @override
  String get cameraUnavailable =>
      'Camera scanning works in the phone app. Type the name instead.';

  @override
  String get scanFailed =>
      'Couldn\'t read the photo. Try again, or type the name.';

  @override
  String readFromStrip(String text) {
    return 'Read from the strip: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'Gurtu only checks against the medicines you saved. It never suggests medicines.';

  @override
  String get verdictTakeNow => 'Yes — this is the right medicine to take now.';

  @override
  String get verdictNotNow => 'Right medicine, but it\'s not due now.';

  @override
  String get verdictAlreadyTaken => 'Already taken. Don\'t take it again now.';

  @override
  String get verdictNoTimes => 'Right medicine, but no time is saved for it.';

  @override
  String get verdictWrongStrength =>
      'Stop — the strength is different from the prescription.';

  @override
  String verdictNotOnList(String name) {
    return 'Stop — this medicine is not on $name\'s list.';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'Stop — this medicine is on $other\'s list, not $name\'s.';
  }

  @override
  String get verdictUnreadable =>
      'Couldn\'t read a medicine name. Try again in good light, or type it.';

  @override
  String get verdictCheckFirst =>
      'Don\'t take it until you check with the doctor or pharmacist.';

  @override
  String get rowOnList => 'On the medicine list';

  @override
  String rowStrengthMatches(String strength) {
    return 'Strength matches: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'Strip says $found, prescription says $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'Due now: $slot dose';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot dose taken at $time';
  }

  @override
  String rowNextDose(String slot) {
    return 'Next dose: $slot';
  }

  @override
  String get rowSetTimes => 'Add when to take it on the medicine list';

  @override
  String get markTaken => 'Mark as taken';

  @override
  String get markedTaken => 'Marked as taken';

  @override
  String get undo => 'Undo';

  @override
  String get medicineList => 'Medicine list';

  @override
  String get medicineListSubtitle =>
      'Every medicine from the prescriptions, with when to take it.';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count medicines',
      one: '1 medicine',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'Add medicine';

  @override
  String get editMedicine => 'Edit medicine';

  @override
  String get addFromPrescription => 'Add from a prescription photo';

  @override
  String get noMedicinesTitle => 'No medicines added yet';

  @override
  String get noMedicinesBody =>
      'Add each medicine from the prescription once. Then scan any strip to check it\'s the right one.';

  @override
  String addMedicinesFirst(String name) {
    return 'Add $name\'s medicines first, so Gurtu has something to check against.';
  }

  @override
  String get medicineName => 'Medicine name';

  @override
  String get medicineNameHint => 'e.g. Metformin';

  @override
  String get alsoCalled => 'Other name on the strip';

  @override
  String get alsoCalledHint => 'e.g. Glycomet';

  @override
  String get strength => 'Strength';

  @override
  String get strengthHint => 'e.g. 500 mg';

  @override
  String get whenToTake => 'When to take it';

  @override
  String get doseMorning => 'Morning';

  @override
  String get doseAfternoon => 'Afternoon';

  @override
  String get doseEvening => 'Evening';

  @override
  String get doseNight => 'Night';

  @override
  String get foodAfter => 'After food';

  @override
  String get foodBefore => 'Before food';

  @override
  String get foodAny => 'With or without food';

  @override
  String get saveMedicine => 'Save medicine';

  @override
  String get medicineSaved => 'Medicine saved';

  @override
  String get deleteMedicine => 'Delete medicine';

  @override
  String get deleteMedicineConfirm => 'Remove this medicine from the list?';

  @override
  String get scanToFill => 'Scan the strip to fill this in';

  @override
  String get timesNotSet => 'Times not set';

  @override
  String get takenToday => 'Taken today';

  @override
  String get prescriptionTitle => 'Add from a prescription';

  @override
  String get prescriptionHint =>
      'Take a clear photo of a printed prescription. Gurtu finds the medicines; you choose which to add.';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get medicinesFound => 'Medicines found';

  @override
  String get tickToAdd =>
      'Tick the ones to add. Check each name and time against the prescription.';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count medicines',
      one: 'Add 1 medicine',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'No medicines found. Try a clearer photo, or add them by hand.';

  @override
  String get handwrittenNote =>
      'Handwritten prescriptions may not read well. Check every name.';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count medicines added',
      one: '1 medicine added',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'Check the strip says $strength';
  }

  @override
  String get aiPerkPrivate => 'Private: what you say stays on this phone';

  @override
  String get aiPerkOffline => 'Works without internet once set up';

  @override
  String get aiPerkQuestions => 'Writes doctor questions for your situation';

  @override
  String get aiRunsOnNpu => 'Runs on your phone\'s AI chip (NPU)';

  @override
  String get aiRunsOnGpu => 'Runs on your phone\'s graphics chip (GPU)';

  @override
  String get aiRunsOnCpu => 'Runs on your phone\'s processor';

  @override
  String get aiStepCheck => 'Checking your phone';

  @override
  String get aiStepDownload => 'Downloading Gurtu AI';

  @override
  String get aiStepReady => 'Ready to help';

  @override
  String aiInstall(String size) {
    return 'Set up Gurtu AI · $size';
  }

  @override
  String get aiContinueInBackground => 'Continue, finish in background';

  @override
  String aiProgress(String done, String total) {
    return '$done of $total';
  }

  @override
  String get aiWaitingWifi =>
      'Waiting for Wi-Fi. The download starts as soon as you connect.';

  @override
  String get aiUseMobileData => 'Use mobile data now';

  @override
  String get aiFailedNetwork =>
      'The download stopped. Check your internet and try again.';

  @override
  String aiFailedSpace(String size) {
    return 'Not enough space on the phone. Free up $size and try again.';
  }

  @override
  String get aiRetry => 'Try again';

  @override
  String get aiUnsupported =>
      'This phone can\'t run Gurtu AI. Gurtu still helps using its built-in guidance.';

  @override
  String get aiDetails => 'Technical details';

  @override
  String get aiDetailModel => 'Model';

  @override
  String get aiDetailSize => 'Size';

  @override
  String get aiDetailChip => 'Runs on';

  @override
  String get aiDetailPhone => 'Phone';

  @override
  String get aiStatusReady => 'Ready · runs on this phone';

  @override
  String get aiStatusOff => 'Not set up. Gurtu uses its built-in guidance.';

  @override
  String aiStatusDownloading(int percent) {
    return 'Setting up · $percent%';
  }

  @override
  String get aiStatusChecking => 'Checking…';

  @override
  String get aiRemoveTitle => 'Remove Gurtu AI from this phone?';

  @override
  String aiRemoveBody(String size) {
    return 'This frees $size. You can set it up again any time.';
  }

  @override
  String get aiSetUpForPrep =>
      'Set up Gurtu AI to get questions written for your situation.';

  @override
  String get prepUnderstanding => 'Understanding what you said…';

  @override
  String get prepByAi =>
      'Written by Gurtu AI on this phone. Check anything unclear with your doctor.';

  @override
  String get prepByRules => 'From Gurtu\'s built-in guidance.';

  @override
  String get prepSummaryTitle => 'Tell the doctor';

  @override
  String get prepSummaryHint =>
      'Show or read this to the doctor at the start of the visit.';

  @override
  String get prepReplyHint => 'Or type or say your answer';

  @override
  String get prepResultIntroAi =>
      'Ask these during the visit, so you both leave knowing what the problem is and what to do. Remove any you don\'t need, or add your own.';

  @override
  String get topicUnderstand => 'Understand the problem';

  @override
  String get topicTests => 'Tests';

  @override
  String get topicTreatment => 'Treatment and medicines';

  @override
  String get topicHome => 'Care at home';

  @override
  String get topicFollowUp => 'Warning signs and next visit';

  @override
  String get topicOwn => 'Your own questions';

  @override
  String get urgentAnswer =>
      'This can be serious. Don\'t wait for the appointment — get medical help now, or call 108 for an ambulance.';

  @override
  String get urgentSelfHarm =>
      'You don\'t have to face this alone. Please talk to someone now: call Tele-MANAS on 14416 (free, any time), or go to the nearest hospital.';

  @override
  String get prepInTheirWords => 'In your words';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get recordVoiceNote => 'Record voice note';

  @override
  String get voiceNote => 'Voice note';

  @override
  String get recordingNow => 'Recording…';

  @override
  String get stopAndSave => 'Stop and save';

  @override
  String get removeAttachmentTitle => 'Remove this?';

  @override
  String get removeAttachmentBody => 'It will be deleted from this phone.';

  @override
  String get attachFailed => 'Couldn\'t add that. Please try again.';

  @override
  String get attachHintMedicines =>
      'Add a photo of the prescription, or record what the doctor said about the medicines.';

  @override
  String get attachHintTests =>
      'Add a photo of the test slip or report, or record what the doctor said.';

  @override
  String get attachHintNextVisit =>
      'Add a photo of the appointment card, or record what the doctor said about the next visit.';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get viewPhoto => 'View photo';

  @override
  String get doctorSpeaks => 'Doctor speaks in';

  @override
  String listeningIn(String language) {
    return 'Listening · $language';
  }

  @override
  String get liveCaptionHint => 'Listening… the doctor\'s words appear here.';

  @override
  String get transcriptHelp =>
      'Each sentence is added here as it is heard. You can correct any word.';

  @override
  String voiceLanguageMissing(String language) {
    return 'Voice typing in $language isn\'t set up on this phone. Choose another language, or add it in the phone\'s voice typing settings.';
  }

  @override
  String get voiceNeedsInternet =>
      'Voice typing needs the internet. You can type instead.';

  @override
  String get voiceWaitingInternet =>
      'No internet. Still trying — nothing heard so far is lost.';

  @override
  String medicineNumber(int number) {
    return 'Medicine $number';
  }

  @override
  String get addAnotherMedicine => 'Add another medicine';

  @override
  String get medicinesVisitHint =>
      'Add each medicine the doctor gives. Take a photo of the strip or prescription, record what the doctor said about it, or type it.';

  @override
  String get removeMedicineBody =>
      'Its photos and voice notes will be deleted from this phone too.';

  @override
  String get questionRemoved => 'Question removed';

  @override
  String get recordDoctor => 'Record the doctor\'s voice';

  @override
  String get doctorRecordings => 'Recordings';

  @override
  String recordingNumber(int number) {
    return 'Recording $number';
  }

  @override
  String get recordOrListenHint =>
      'Listen writes the doctor\'s words as text. Record keeps their voice to play later. The phone\'s microphone does one at a time.';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'In 1 day',
    );
    return '$_temp0';
  }

  @override
  String withDoctor(String doctor) {
    return 'With $doctor';
  }

  @override
  String recordingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recordings',
      one: '1 recording',
    );
    return '$_temp0';
  }

  @override
  String photosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get noNextVisitHint =>
      'When the doctor gives a date to come back, add it while recording the visit. It will show here.';

  @override
  String circleSubtitle(String name) {
    return 'Everyone caring for $name, together.';
  }

  @override
  String get familyCode => 'Family code';

  @override
  String familyCodeHint(String name) {
    return 'Share this code. Family and helpers type it into Gurtu to join $name\'s circle.';
  }

  @override
  String get copyCode => 'Copy code';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get newCode => 'Make a new code';

  @override
  String get newCodeTitle => 'Make a new code?';

  @override
  String get newCodeBody =>
      'The old code will stop working. People already in the circle stay in.';

  @override
  String get circleMembers => 'People in the circle';

  @override
  String get circleOwner => 'Started the circle';

  @override
  String get getsReminders => 'Gets reminders';

  @override
  String get noNotifications => 'Notifications off';

  @override
  String get notOnApp => 'Not on the app';

  @override
  String get sendTestNotification => 'Send a test notification';

  @override
  String testSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sent to $count phones',
      one: 'Sent to 1 phone',
      zero: 'No phones could be reached yet',
    );
    return '$_temp0';
  }

  @override
  String get testTitle => 'Test from Gurtu';

  @override
  String testBody(String name) {
    return 'Notifications are working for $name\'s care circle.';
  }

  @override
  String get settingUpCode => 'Setting up your family code…';

  @override
  String get offlineTitle => 'Couldn\'t reach the Gurtu server';

  @override
  String get offlineBody =>
      'Everything is saved on this phone. The family code will appear once you\'re online.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get haveFamilyCode => 'I have a family code';

  @override
  String get joinTitle => 'Join a care circle';

  @override
  String get joinSubtitle =>
      'Enter the 6-digit code someone in your family shared with you.';

  @override
  String get howHelping => 'How are you helping?';

  @override
  String get joinButton => 'Join the circle';

  @override
  String get invalidCode =>
      'That code doesn\'t match any family. Check the digits and try again.';

  @override
  String get tooManyTries =>
      'Too many tries. Please wait a few minutes and try again.';

  @override
  String get connectionFailed =>
      'Couldn\'t connect. Check the internet and try again.';

  @override
  String get somethingWrong => 'Something went wrong. Please try again.';

  @override
  String joinedCircle(String name) {
    return 'You joined $name\'s care circle';
  }

  @override
  String get peopleYouCareFor => 'People you care for';

  @override
  String get addPersonTitle => 'Add someone to care for';

  @override
  String get setUpNew => 'Set up for someone new';

  @override
  String get setUpNewHint =>
      'Answer a few questions about them. They get their own family code.';

  @override
  String get joinWithCode => 'Join with a family code';

  @override
  String get joinWithCodeHint =>
      'Someone in the family already set Gurtu up for them.';

  @override
  String get yourCare => 'Your care';

  @override
  String get lookingAfterYou => 'Looking after you';

  @override
  String lookingAfterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people look after you',
      one: '1 person looks after you',
      zero: 'No one yet',
    );
    return '$_temp0';
  }

  @override
  String get inviteFamily => 'Invite your family';

  @override
  String get inviteFamilyHint =>
      'Share your family code. They\'ll see your care and get your reminders.';

  @override
  String get askForHelp => 'Ask family for help';

  @override
  String get askForHelpTitle => 'Send a message to your family?';

  @override
  String get askForHelpBody =>
      'Everyone in your care circle gets a notification to call or check on you.';

  @override
  String get send => 'Send';

  @override
  String helpSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sent to $count people',
      one: 'Sent to 1 person',
      zero: 'No one could be reached yet',
    );
    return '$_temp0';
  }

  @override
  String get circleSubtitleSelf => 'The people who look after you.';

  @override
  String get iAmPatient => 'I\'m the one being cared for';

  @override
  String get patientTaken =>
      'Someone has already joined as the person being cared for. Choose another role.';

  @override
  String get medRemindersTitle => 'Medicine reminders';

  @override
  String medRemindersIntro(String name) {
    return 'Gurtu read the doctor\'s notes for $name. Check each time, then turn the reminders on.';
  }

  @override
  String get readingMedicines => 'Reading the medicines…';

  @override
  String get readByAi => 'Read by Gurtu AI';

  @override
  String get readByRules => 'Read from your notes';

  @override
  String get pickTimes => 'Choose when to take it';

  @override
  String get everyDay => 'Every day';

  @override
  String forDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'For $count days',
      one: 'For 1 day',
    );
    return '$_temp0';
  }

  @override
  String get howLong => 'How long';

  @override
  String get turnOnReminders => 'Turn on reminders';

  @override
  String remindersSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders are on',
      one: '1 reminder is on',
    );
    return '$_temp0';
  }

  @override
  String remindersGoToPatient(String name) {
    return 'Reminders go to $name\'s phone. If one isn\'t marked as taken, Gurtu reminds again twice, then alerts the family.';
  }

  @override
  String remindersGoToFamily(String name) {
    return '$name doesn\'t use Gurtu, so reminders go to the family\'s phones. If one isn\'t marked as taken, Gurtu reminds again twice, then alerts everyone.';
  }

  @override
  String get remindersPending =>
      'Saved on this phone. Reminders switch on as soon as it\'s online.';

  @override
  String get setUpReminders => 'Set up reminders';

  @override
  String get changeReminders => 'Change reminders';

  @override
  String get takenIt => 'I\'ve taken it';

  @override
  String get skipDose => 'Skip this time';

  @override
  String dueAt(String time) {
    return 'Due at $time';
  }

  @override
  String get readAloud => 'Read aloud';

  @override
  String get missedDoseEyebrow => 'MISSED DOSE';

  @override
  String get markTakenForThem => 'Mark as taken';

  @override
  String get illCheck => 'I\'ll check on them';

  @override
  String get doseTakenThanks => 'Marked as taken. Well done!';

  @override
  String get noReminderForThis => 'No reminder';

  @override
  String get reminderEyebrow => 'MEDICINE REMINDER';

  @override
  String get autoReminders => 'Automatic medicine reminders';

  @override
  String get autoRemindersHint =>
      'Gurtu AI reads each medicine the doctor gives and turns on its reminders by itself. You can still check or change them on the visit.';

  @override
  String autoRemindersDone(String medicines) {
    return 'Reminders are on for $medicines';
  }

  @override
  String get visitSavedAuto =>
      'Visit saved. Gurtu is setting up the medicine reminders.';

  @override
  String get testReminder => 'Send a test reminder now';

  @override
  String get testReminderHint =>
      'A real reminder goes straight away to the phone that gets reminders. If no one marks it, it comes again after 1 and 2 minutes, then the family gets the missed-dose alert.';

  @override
  String get testMedicine => 'Test medicine';

  @override
  String get testBadge => 'TEST';

  @override
  String get skipConfirmTitle => 'Skip this dose?';

  @override
  String get skipConfirmBody =>
      'Gurtu won\'t remind again for this dose, and the family will be told.';

  @override
  String get addPage => 'Add another page';

  @override
  String get addToMemory => 'Add to memory';

  @override
  String get askExampleMedicines => 'Which medicines are taken at night?';

  @override
  String get askExampleReport => 'What did the last test report say?';

  @override
  String get askFailed =>
      'Gurtu AI couldn\'t answer just now. Here is what I found in the memory:';

  @override
  String get askFoundInMemory =>
      'Gurtu AI isn\'t on this phone yet, so here is what I found in the memory:';

  @override
  String get askHint => 'Ask about medicines, reports, visits…';

  @override
  String get askNewChat => 'New chat';

  @override
  String get askNothingFound =>
      'I couldn\'t find anything about that in the memory yet. Try other words, or save the report or note first.';

  @override
  String get askSources => 'From memory';

  @override
  String get cantOpenFile => 'No app on this phone can open this file.';

  @override
  String get captureDocHint => 'Report, prescription or any document';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get conditionsLabel => 'Health conditions';

  @override
  String get dailyMedicinesLabel => 'Takes medicines every day';

  @override
  String get deleteMemoryTitle => 'Delete this from memory?';

  @override
  String get editDetails => 'Edit details';

  @override
  String get editMemory => 'Edit';

  @override
  String get gettingAroundLabel => 'Getting around';

  @override
  String get memoryAll => 'All';

  @override
  String get memoryDocuments => 'Reports & scans';

  @override
  String get memoryEmptyBody =>
      'Scan a report or prescription, write a note, or share a file to Gurtu from any app.';

  @override
  String get memoryNotes => 'Notes';

  @override
  String get memoryPrivate =>
      'Saved only on this phone. Gurtu reads it to answer your questions.';

  @override
  String get memorySearchHint => 'Search, e.g. sugar report';

  @override
  String get memoryTextHint =>
      'Gurtu reads the printed text. You can correct it or add more.';

  @override
  String get memoryTextLabel => 'What it says';

  @override
  String get memoryTitleHint => 'e.g. Blood test report';

  @override
  String get memoryTitleLabel => 'Title';

  @override
  String get readingDocument => 'Reading the document…';

  @override
  String get recentHospitalLabel => 'Hospital or doctor in the last 30 days';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saveToMemory => 'Save to memory';

  @override
  String get saveToMemoryHint =>
      'Photograph each page. Gurtu reads it on this phone so you can find it later and ask about it.';

  @override
  String get smartSearchDownload => 'Download';

  @override
  String get smartSearchTitle => 'Smarter search';

  @override
  String aboutPerson(String name) {
    return 'About $name';
  }

  @override
  String addMedicinesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count medicines to the list',
      one: 'Add 1 medicine to the list',
    );
    return '$_temp0';
  }

  @override
  String askThinking(String name) {
    return 'Looking through $name\'s memory…';
  }

  @override
  String memoryNoResults(String query) {
    return 'Nothing found for “$query”.';
  }

  @override
  String memorySubtitle(String name) {
    return 'Everything saved about $name: notes, reports, visits and medicines.';
  }

  @override
  String smartSearchBody(int size) {
    return 'Download a small AI model ($size MB) so Gurtu finds things by meaning, not only exact words. It stays on this phone.';
  }

  @override
  String smartSearchProgress(int percent) {
    return 'Downloading… $percent%';
  }

  @override
  String get addDocument => 'Add a PDF or document';

  @override
  String get aiSummary => 'Summary by Gurtu AI';

  @override
  String get summarising => 'Gurtu AI is reading it…';

  @override
  String get documentNoText =>
      'Saved. Gurtu couldn\'t read the words in this file, so type what matters below.';

  @override
  String get captureFileHint => 'PDF, Word or text file';
}
