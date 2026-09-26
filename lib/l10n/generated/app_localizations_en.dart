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
}
