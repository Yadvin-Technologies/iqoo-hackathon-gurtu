// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get continueLabel => 'ಮುಂದುವರಿಸಿ';

  @override
  String get next => 'ಮುಂದೆ';

  @override
  String get skip => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get later => 'ನಂತರ';

  @override
  String get back => 'ಹಿಂದೆ';

  @override
  String get optional => 'ಐಚ್ಛಿಕ';

  @override
  String get yes => 'ಹೌದು';

  @override
  String get no => 'ಇಲ್ಲ';

  @override
  String get notSure => 'ಗೊತ್ತಿಲ್ಲ';

  @override
  String get tagline => 'ನೆನಪಿಡಿ. ಆರೈಕೆ ಮಾಡಿ. ಒಟ್ಟಾಗಿ.';

  @override
  String get motherName => 'ಅಮ್ಮ';

  @override
  String get phaseAbout => 'ಪರಿಚಯ';

  @override
  String get phaseHealth => 'ಆರೋಗ್ಯ';

  @override
  String get phasePermissions => 'ಅನುಮತಿಗಳು';

  @override
  String get phaseAi => 'AI ಸೆಟಪ್';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $totalರಲ್ಲಿ $current';
  }

  @override
  String get languageTitle => 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆರಿಸಿ';

  @override
  String get languageSubtitle =>
      'Gurtu ಈ ಭಾಷೆಯಲ್ಲೇ ಮಾತನಾಡುತ್ತದೆ, ಕೇಳುತ್ತದೆ ಮತ್ತು ಬರೆಯುತ್ತದೆ.';

  @override
  String get languageMixNote =>
      'ವೈದ್ಯರು ಹೆಚ್ಚಾಗಿ ನಿಮ್ಮ ಭಾಷೆಯೊಂದಿಗೆ ಇಂಗ್ಲಿಷ್ ಬೆರೆಸಿ ಮಾತನಾಡುತ್ತಾರೆ. Gurtu ಎರಡನ್ನೂ ಒಟ್ಟಿಗೆ ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತದೆ.';

  @override
  String get welcomeTitle => 'ನಿಮ್ಮ ಕುಟುಂಬದ\nಆರೈಕೆಯ ನೆನಪು';

  @override
  String get welcomeBody =>
      'ವೈದ್ಯರು ಏನು ಹೇಳಿದರು, ಯಾವ ಔಷಧಿ ಬರೆದರು, ಮನೆಯಲ್ಲಿ ಏನಾಯಿತು — ಎಲ್ಲವನ್ನೂ ಒಟ್ಟಾಗಿ ನೆನಪಿಡಿ.';

  @override
  String get welcomeScript => 'ಬೇರೆ ಬೇರೆ ಪಾತ್ರಗಳು. ಅದೇ ಪ್ರೀತಿ.';

  @override
  String get getStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String builtForBrand(String brand) {
    return '$brandಗಾಗಿ ತಯಾರಿಸಲಾಗಿದೆ';
  }

  @override
  String get madeInHyderabad => 'ಹೈದರಾಬಾದ್‌ನಲ್ಲಿ ತಯಾರಾಗಿದೆ';

  @override
  String get introRecordEyebrow => '1 · ರೆಕಾರ್ಡ್';

  @override
  String get introRecordTitle => 'ವೈದ್ಯರು ಹೇಳಿದ್ದನ್ನು ಎಂದಿಗೂ ಮರೆಯಬೇಡಿ';

  @override
  String get introRecordBody =>
      'ಎಲ್ಲರ ಒಪ್ಪಿಗೆಯೊಂದಿಗೆ ವೈದ್ಯರು, ನರ್ಸ್ ಅಥವಾ ಫಾರ್ಮಸಿಸ್ಟ್ ಮಾತನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಿ. ಮುಖ್ಯ ವಿಷಯಗಳನ್ನು Gurtu ಕಾಪಾಡುತ್ತದೆ.';

  @override
  String get introPlanEyebrow => '2 · ಅರ್ಥಮಾಡಿ & ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String get introPlanTitle => 'ಇಡೀ ಕುಟುಂಬಕ್ಕೆ ಒಂದೇ ಆರೈಕೆ ಯೋಜನೆ';

  @override
  String get introPlanBody =>
      'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್ ಮತ್ತು ರಿಪೋರ್ಟ್‌ಗಳನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ. ಕುಟುಂಬ ಹಂಚಿಕೊಳ್ಳಬಹುದಾದ ಸರಳ ಕೆಲಸಗಳಾಗಿ Gurtu ಬದಲಾಯಿಸುತ್ತದೆ.';

  @override
  String get introAskEyebrow => '3 · ಕೇಳಿ & ನೆನಪಿಡಿ';

  @override
  String get introAskTitle => 'ಏನು ಬೇಕಾದರೂ ಕೇಳಿ, ಪುರಾವೆ ನೋಡಿ';

  @override
  String get introAskBody =>
      'ಪ್ರತಿ ಉತ್ತರವೂ ಅದು ಎಲ್ಲಿಂದ ಬಂತು ಎಂದು ತೋರಿಸುತ್ತದೆ — ರೆಕಾರ್ಡಿಂಗ್, ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್ ಅಥವಾ ಫೋಟೋ.';

  @override
  String get letsSetUp => 'ಸೆಟಪ್ ಮಾಡೋಣ';

  @override
  String get hospitalMode => 'ಆಸ್ಪತ್ರೆ ಮೋಡ್';

  @override
  String get consentRecording => 'ಅಲ್ಲಿರುವ ಎಲ್ಲರ ಒಪ್ಪಿಗೆಯೊಂದಿಗೆ ರೆಕಾರ್ಡಿಂಗ್';

  @override
  String get doctorConversation => 'ವೈದ್ಯರೊಂದಿಗೆ ಮಾತುಕತೆ';

  @override
  String get nurseInstructions => 'ನರ್ಸ್ ಸೂಚನೆಗಳು';

  @override
  String get pharmacistAdvice => 'ಫಾರ್ಮಸಿಸ್ಟ್ ಸಲಹೆ';

  @override
  String get yourCarePlan => 'ನಿಮ್ಮ ಆರೈಕೆ ಯೋಜನೆ';

  @override
  String get afterBreakfast => 'ಉಪಾಹಾರದ ನಂತರ';

  @override
  String get checkBloodPressure => 'BP ಪರಿಶೀಲಿಸಿ';

  @override
  String get twiceDaily => 'ದಿನಕ್ಕೆ ಎರಡು ಬಾರಿ';

  @override
  String get bloodTest => 'ರಕ್ತ ಪರೀಕ್ಷೆ (CBC)';

  @override
  String get instructionsFound =>
      'ನಿಮ್ಮ ರೆಕಾರ್ಡಿಂಗ್ ಮತ್ತು ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ನಲ್ಲಿ 4 ಸೂಚನೆಗಳು ಸಿಕ್ಕಿವೆ';

  @override
  String get askQuestion => 'ಸಂಜೆಯ ಔಷಧಿ ಬಗ್ಗೆ ವೈದ್ಯರು ಏನು ಹೇಳಿದರು?';

  @override
  String get askAnswer =>
      'Amlodipine ಅನ್ನು ರಾತ್ರಿ ಊಟದ ನಂತರ ತೆಗೆದುಕೊಳ್ಳಲು ವೈದ್ಯರು ಹೇಳಿದರು.';

  @override
  String get sourceDoctorVisit => 'ಮೂಲ: ವೈದ್ಯರ ಭೇಟಿ';

  @override
  String get careForTitle => 'Gurtu ಅನ್ನು ಯಾರಿಗಾಗಿ ಸೆಟಪ್ ಮಾಡುತ್ತಿದ್ದೀರಿ?';

  @override
  String get careForSubtitle =>
      'Gurtu ಒಬ್ಬ ವ್ಯಕ್ತಿಯ ಸುತ್ತ ಆರೈಕೆಯ ನೆನಪನ್ನು ನಿರ್ಮಿಸುತ್ತದೆ. ಉಳಿದ ಕುಟುಂಬವನ್ನು ನಂತರ ಆಹ್ವಾನಿಸಬಹುದು.';

  @override
  String get careForMyself => 'ನನಗಾಗಿ';

  @override
  String get careForMyselfHint => 'ನನ್ನ ಸ್ವಂತ ಆರೈಕೆಯನ್ನು ಗಮನಿಸಲು';

  @override
  String get careForParent => 'ನನ್ನ ತಂದೆ-ತಾಯಿ';

  @override
  String get careForParentHint => 'ಅಮ್ಮ, ಅಪ್ಪ ಅಥವಾ ಮನೆಯ ಹಿರಿಯರು';

  @override
  String get careForPartner => 'ನನ್ನ ಬಾಳಸಂಗಾತಿ';

  @override
  String get careForPartnerHint => 'ಗಂಡ, ಹೆಂಡತಿ ಅಥವಾ ಸಂಗಾತಿ';

  @override
  String get careForChild => 'ನನ್ನ ಮಗು';

  @override
  String get careForChildHint => 'ಮಗ ಅಥವಾ ಮಗಳು';

  @override
  String get careForOther => 'ಬೇರೆ ಯಾರಾದರೂ';

  @override
  String get careForOtherHint => 'ಸಂಬಂಧಿ, ಸ್ನೇಹಿತ ಅಥವಾ ನೆರೆಹೊರೆಯವರು';

  @override
  String get profileTitleSelf => 'ನಿಮ್ಮ ಬಗ್ಗೆ ಹೇಳಿ';

  @override
  String get profileTitleOther => 'ಅವರ ಬಗ್ಗೆ ಹೇಳಿ';

  @override
  String get profileSubtitleSelf =>
      'ಇದರಿಂದ Gurtu ನಿಮ್ಮನ್ನು ಹೆಸರಿನಿಂದ ಕರೆಯುತ್ತದೆ.';

  @override
  String get profileSubtitleOther =>
      'ಮನೆಯಲ್ಲಿ ನೀವು ಅವರನ್ನು ಕರೆಯುವ ಹೆಸರನ್ನು ಬರೆಯಿರಿ.';

  @override
  String get yourName => 'ನಿಮ್ಮ ಹೆಸರು';

  @override
  String get whatDoYouCallThem => 'ನೀವು ಅವರನ್ನು ಏನೆಂದು ಕರೆಯುತ್ತೀರಿ?';

  @override
  String exampleName(String name) {
    return 'ಉದಾ. $name';
  }

  @override
  String get sampleSelfName => 'ಲಕ್ಷ್ಮಿ';

  @override
  String get sampleYourName => 'ಪ್ರಿಯಾ';

  @override
  String get yourAge => 'ನಿಮ್ಮ ವಯಸ್ಸು';

  @override
  String get theirAge => 'ಅವರ ವಯಸ್ಸು';

  @override
  String get years => 'ವರ್ಷ';

  @override
  String get decreaseAge => 'ವಯಸ್ಸು ಕಡಿಮೆ ಮಾಡಿ';

  @override
  String get increaseAge => 'ವಯಸ್ಸು ಹೆಚ್ಚಿಸಿ';

  @override
  String get gender => 'ಲಿಂಗ';

  @override
  String get female => 'ಮಹಿಳೆ';

  @override
  String get male => 'ಪುರುಷ';

  @override
  String get genderOther => 'ಇತರೆ';

  @override
  String get andYou => 'ಮತ್ತು ನೀವು?';

  @override
  String get andYouBody => 'ಅವರ ಕೇರ್ ಸರ್ಕಲ್‌ನ ಮೊದಲ ಸದಸ್ಯರು ನೀವೇ.';

  @override
  String get conditionsTitleSelf =>
      'ನಿಮಗೆ ಇವುಗಳಲ್ಲಿ ಯಾವುದಾದರೂ ಆರೋಗ್ಯ ಸಮಸ್ಯೆ ಇದೆಯೇ?';

  @override
  String conditionsTitleOther(String name) {
    return '$name ಅವರಿಗೆ ಇವುಗಳಲ್ಲಿ ಯಾವುದಾದರೂ ಆರೋಗ್ಯ ಸಮಸ್ಯೆ ಇದೆಯೇ?';
  }

  @override
  String get conditionsSubtitle =>
      'ಅನ್ವಯಿಸುವ ಎಲ್ಲವನ್ನೂ ಆರಿಸಿ. ಇದು ಆರೈಕೆ ಯೋಜನೆಯನ್ನು ಸಿದ್ಧಪಡಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.';

  @override
  String get condDiabetes => 'ಸಕ್ಕರೆ (ಮಧುಮೇಹ)';

  @override
  String get condHighBp => 'ಹೈ BP';

  @override
  String get condHeart => 'ಹೃದಯ ಸಮಸ್ಯೆ';

  @override
  String get condThyroid => 'ಥೈರಾಯ್ಡ್';

  @override
  String get condCholesterol => 'ಕೊಲೆಸ್ಟ್ರಾಲ್';

  @override
  String get condAsthma => 'ಅಸ್ತಮಾ / ಉಸಿರಾಟದ ತೊಂದರೆ';

  @override
  String get condKidney => 'ಕಿಡ್ನಿ ಸಮಸ್ಯೆ';

  @override
  String get condArthritis => 'ಕೀಲು ನೋವು / ಸಂಧಿವಾತ';

  @override
  String get condStroke => 'ಹಿಂದೆ ಪಾರ್ಶ್ವವಾಯು';

  @override
  String get condCancer => 'ಕ್ಯಾನ್ಸರ್ ಚಿಕಿತ್ಸೆ';

  @override
  String get noneOfThese => 'ಇವುಗಳಲ್ಲಿ ಯಾವುದೂ ಇಲ್ಲ';

  @override
  String get notADoctor =>
      'Gurtu ವೈದ್ಯರಲ್ಲ. ಇದು ಎಂದಿಗೂ ರೋಗನಿರ್ಣಯ ಮಾಡುವುದಿಲ್ಲ — ಕುಟುಂಬಕ್ಕೆ ಆರೈಕೆಯನ್ನು ನೆನಪಿಡಲು ಮತ್ತು ನಿರ್ವಹಿಸಲು ಮಾತ್ರ ಸಹಾಯ ಮಾಡುತ್ತದೆ.';

  @override
  String get medicinesTitleSelf => 'ನೀವು ಪ್ರತಿದಿನ ಔಷಧಿ ತೆಗೆದುಕೊಳ್ಳುತ್ತೀರಾ?';

  @override
  String medicinesTitleOther(String name) {
    return '$name ಪ್ರತಿದಿನ ಔಷಧಿ ತೆಗೆದುಕೊಳ್ಳುತ್ತಾರಾ?';
  }

  @override
  String get medicinesSubtitle =>
      'ಮಾತ್ರೆಗಳು, ಸಿರಪ್, ಇನ್‌ಹೇಲರ್ ಅಥವಾ ಇನ್ಸುಲಿನ್ ಎಲ್ಲವನ್ನೂ ಸೇರಿಸಿ.';

  @override
  String get howMany => 'ಸುಮಾರು ಎಷ್ಟು?';

  @override
  String get sixOrMore => '6 ಅಥವಾ ಹೆಚ್ಚು';

  @override
  String get scanLaterTip =>
      'ನಂತರ ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್ ಅಥವಾ ಮಾತ್ರೆ ಪಟ್ಟಿಯನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಿದರೆ ಸಾಕು — ಟೈಪ್ ಮಾಡಬೇಕಿಲ್ಲ.';

  @override
  String get allergiesTitleSelf => 'ನಿಮಗೆ ಯಾವುದಾದರೂ ಅಲರ್ಜಿ ಇದೆಯೇ?';

  @override
  String allergiesTitleOther(String name) {
    return '$name ಅವರಿಗೆ ಯಾವುದಾದರೂ ಅಲರ್ಜಿ ಇದೆಯೇ?';
  }

  @override
  String get allergiesSubtitle =>
      'ಇದು ತಪ್ಪಿಹೋಗದಂತೆ Gurtu ಪ್ರತಿ ಡಾಕ್ಟರ್ ಬ್ರೀಫ್‌ನಲ್ಲಿ ತೋರಿಸುತ್ತದೆ.';

  @override
  String get allergyNone => 'ತಿಳಿದಿರುವ ಅಲರ್ಜಿ ಇಲ್ಲ';

  @override
  String get allergyPenicillin => 'ಪೆನ್ಸಿಲಿನ್';

  @override
  String get allergySulfa => 'ಸಲ್ಫಾ ಔಷಧಿಗಳು';

  @override
  String get allergyAspirin => 'ಆಸ್ಪಿರಿನ್ / ನೋವು ನಿವಾರಕಗಳು';

  @override
  String get allergyFood => 'ಆಹಾರ ಅಲರ್ಜಿ';

  @override
  String get allergyDust => 'ಧೂಳು / ಪರಾಗ';

  @override
  String get allergyLatex => 'ಲ್ಯಾಟೆಕ್ಸ್';

  @override
  String get mobilityTitleSelf => 'ದಿನನಿತ್ಯ ನೀವು ಹೇಗೆ ಓಡಾಡುತ್ತೀರಿ?';

  @override
  String mobilityTitleOther(String name) {
    return 'ದಿನನಿತ್ಯ $name ಹೇಗೆ ಓಡಾಡುತ್ತಾರೆ?';
  }

  @override
  String get mobilitySubtitle =>
      'ಇದರಿಂದ ಕುಟುಂಬ ಭೇಟಿ, ಪರೀಕ್ಷೆ ಮತ್ತು ಮನೆಯ ಸಹಾಯವನ್ನು ಯೋಜಿಸಬಹುದು.';

  @override
  String get mobilityIndependent => 'ತಾವೇ ನಡೆಯುತ್ತಾರೆ';

  @override
  String get mobilityIndependentHint => 'ದಿನನಿತ್ಯ ಸಹಾಯ ಬೇಕಿಲ್ಲ';

  @override
  String get mobilitySomeHelp => 'ಸ್ವಲ್ಪ ಸಹಾಯ ಬೇಕು';

  @override
  String get mobilitySomeHelpHint => 'ಕೋಲು, ವಾಕರ್ ಅಥವಾ ಹಿಡಿಯಲು ಒಂದು ಕೈ';

  @override
  String get mobilityFullHelp => 'ಹೆಚ್ಚಾಗಿ ಹಾಸಿಗೆ ಅಥವಾ ವೀಲ್‌ಚೇರ್‌ನಲ್ಲಿ';

  @override
  String get mobilityFullHelpHint => 'ಹೆಚ್ಚಿನ ಕೆಲಸಗಳಿಗೆ ಸಹಾಯ ಬೇಕು';

  @override
  String get hospitalTitleSelf =>
      'ಕಳೆದ 30 ದಿನಗಳಲ್ಲಿ ನೀವು ಆಸ್ಪತ್ರೆ ಅಥವಾ ವೈದ್ಯರ ಬಳಿ ಹೋಗಿದ್ದೀರಾ?';

  @override
  String hospitalTitleOther(String name) {
    return 'ಕಳೆದ 30 ದಿನಗಳಲ್ಲಿ $name ಆಸ್ಪತ್ರೆ ಅಥವಾ ವೈದ್ಯರ ಬಳಿ ಹೋಗಿದ್ದಾರಾ?';
  }

  @override
  String get hospitalSubtitle =>
      'ಇತ್ತೀಚಿನ ಭೇಟಿಗಳೊಂದಿಗೆ ಸಾಮಾನ್ಯವಾಗಿ ಹೊಸ ಸೂಚನೆಗಳು ಬರುತ್ತವೆ.';

  @override
  String get hospitalTip =>
      'ಡಿಸ್ಚಾರ್ಜ್ ಪೇಪರ್ ಮತ್ತು ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ಗಳನ್ನು ಹತ್ತಿರ ಇಡಿ — ಸೆಟಪ್ ಆದ ತಕ್ಷಣ ಸ್ಕ್ಯಾನ್ ಮಾಡಬಹುದು.';

  @override
  String get permissionsTitle => 'ನಿಮಗೆ ಸಹಾಯ ಮಾಡಲು ಕೆಲವು ಅನುಮತಿಗಳು';

  @override
  String get permissionsSubtitle =>
      'Gurtu ಅಗತ್ಯವಿರುವುದನ್ನು ಮಾತ್ರ ಕೇಳುತ್ತದೆ. ಏಕೆ ಎಂಬುದು ಇಲ್ಲಿದೆ.';

  @override
  String get permMic => 'ಮೈಕ್ರೊಫೋನ್';

  @override
  String get permMicWhy =>
      'ವೈದ್ಯರ ಭೇಟಿ ಮತ್ತು ಧ್ವನಿ ಟಿಪ್ಪಣಿಗಳನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಲು — ನೀವು ರೆಕಾರ್ಡ್ ಒತ್ತಿದಾಗ ಮಾತ್ರ.';

  @override
  String get permCamera => 'ಕ್ಯಾಮೆರಾ';

  @override
  String get permCameraWhy =>
      'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್, ಮಾತ್ರೆ ಪಟ್ಟಿ ಮತ್ತು BP ಯಂತ್ರದ ರೀಡಿಂಗ್ ಸ್ಕ್ಯಾನ್ ಮಾಡಲು.';

  @override
  String get permNotifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get permNotificationsWhy =>
      'ಔಷಧಿ ಜ್ಞಾಪನೆಗಳು ಮತ್ತು ಕುಟುಂಬ ಕೆಲಸ ಮುಗಿಸಿದಾಗ ಮಾಹಿತಿ.';

  @override
  String get permPhotos => 'ಫೋಟೋಗಳು & ಫೈಲ್‌ಗಳು';

  @override
  String get permPhotosWhy =>
      'ಗ್ಯಾಲರಿಯಲ್ಲಿರುವ ರಿಪೋರ್ಟ್ ಮತ್ತು ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್ ಸೇರಿಸಲು.';

  @override
  String get permContacts => 'ಸಂಪರ್ಕಗಳು';

  @override
  String get permContactsWhy =>
      'ಕುಟುಂಬ ಸದಸ್ಯರನ್ನು ಕೇರ್ ಸರ್ಕಲ್‌ಗೆ ಬೇಗ ಆಹ್ವಾನಿಸಲು.';

  @override
  String get needed => 'ಅಗತ್ಯ';

  @override
  String get allow => 'ಅನುಮತಿಸಿ';

  @override
  String get allowed => 'ಅನುಮತಿಸಲಾಗಿದೆ';

  @override
  String get allowAndContinue => 'ಅನುಮತಿಸಿ ಮುಂದುವರಿಸಿ';

  @override
  String get privacyNote =>
      'ಎಲ್ಲವೂ ಈ ಫೋನ್‌ನಲ್ಲೇ ಇರುತ್ತದೆ. ರೆಕಾರ್ಡಿಂಗ್ ತಾನಾಗಿ ಶುರುವಾಗುವುದಿಲ್ಲ — ಮೊದಲು ಒಪ್ಪಿಗೆ ಪರದೆ ತೋರಿಸುತ್ತದೆ.';

  @override
  String permissionBlocked(String permission) {
    return '$permission ನಿರ್ಬಂಧಿಸಲಾಗಿದೆ. ಸೆಟ್ಟಿಂಗ್ಸ್‌ನಲ್ಲಿ ಆನ್ ಮಾಡಿ.';
  }

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್ಸ್';

  @override
  String permissionsMissing(String items) {
    return '$items ಇಲ್ಲದೆ ಕೆಲವು ವೈಶಿಷ್ಟ್ಯಗಳು ಕೆಲಸ ಮಾಡುವುದಿಲ್ಲ. ನಂತರ ಅನುಮತಿಸಬಹುದು.';
  }

  @override
  String get modelTitleChoose => 'Gurtu ಆನ್-ಡಿವೈಸ್ AI ಸೆಟಪ್ ಮಾಡಿ';

  @override
  String get modelTitleDownloading => 'ನಿಮ್ಮ AI ಸೆಟಪ್ ಆಗುತ್ತಿದೆ…';

  @override
  String get modelTitleDone => 'ನಿಮ್ಮ AI ಸಿದ್ಧವಾಗಿದೆ';

  @override
  String get modelSubtitleChoose =>
      'ಈ ಮಾಡೆಲ್‌ಗಳು ಸಂಪೂರ್ಣವಾಗಿ ನಿಮ್ಮ iQOO ನಲ್ಲೇ ಚಲಿಸುತ್ತವೆ. ಕುಟುಂಬದ ಆರೋಗ್ಯ ಮಾಹಿತಿ ಫೋನ್‌ನಿಂದ ಹೊರಹೋಗುವುದಿಲ್ಲ — ಇಂಟರ್ನೆಟ್ ಇಲ್ಲದೆಯೂ ಕೆಲಸ ಮಾಡುತ್ತದೆ.';

  @override
  String get modelSubtitleDownloading =>
      'ನೀವು ಫೋನ್ ಬಳಸುತ್ತಲೇ ಇರಬಹುದು. ಇದು ಒಮ್ಮೆ ಮಾತ್ರ.';

  @override
  String get modelSubtitleDone =>
      'ಎಲ್ಲವೂ ಈ ಫೋನ್‌ನಲ್ಲೇ ಚಲಿಸುತ್ತದೆ, ಆಫ್‌ಲೈನ್‌ನಲ್ಲೂ.';

  @override
  String get poweredByIqoo => 'ನಿಮ್ಮ iQOO ಶಕ್ತಿಯಿಂದ';

  @override
  String get deviceCardSub =>
      'ಆನ್-ಡಿವೈಸ್ AI · ಖಾಸಗಿ · ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ';

  @override
  String get chooseCareModel => 'ಕೇರ್ ಮಾಡೆಲ್ ಆರಿಸಿ';

  @override
  String get careModelHint => 'ಪ್ರಶ್ನೆಗಳಿಗೆ ಉತ್ತರಿಸುವ ಮೆದುಳು ಇದೇ.';

  @override
  String get alwaysIncluded => 'ಯಾವಾಗಲೂ ಸೇರಿರುತ್ತದೆ';

  @override
  String get jobListens => 'ಕೇಳುತ್ತದೆ';

  @override
  String get jobReads => 'ಓದುತ್ತದೆ';

  @override
  String get jobSees => 'ನೋಡುತ್ತದೆ';

  @override
  String get jobUnderstands => 'ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತದೆ';

  @override
  String speechModelName(String language) {
    return 'ಧ್ವನಿ · $language + ಇಂಗ್ಲಿಷ್';
  }

  @override
  String get speechModelWhat =>
      'ಮಾತುಕತೆಯನ್ನು ನಿಮ್ಮ ಭಾಷೆಯಲ್ಲಿ ಬರಹಕ್ಕೆ ಬದಲಾಯಿಸುತ್ತದೆ.';

  @override
  String get readerModelName => 'ದಾಖಲೆ ಓದುಗ (OCR)';

  @override
  String get readerModelWhat =>
      'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್, ಡಿಸ್ಚಾರ್ಜ್ ಪೇಪರ್ ಮತ್ತು ಲ್ಯಾಬ್ ರಿಪೋರ್ಟ್ ಓದುತ್ತದೆ.';

  @override
  String get visionModelName => 'ಔಷಧಿ & ರೀಡಿಂಗ್ ಗುರುತಿಸುವಿಕೆ';

  @override
  String get visionModelWhat =>
      'ಮಾತ್ರೆ ಪಟ್ಟಿ ಮತ್ತು BP / ಸಕ್ಕರೆ ಯಂತ್ರದ ಸಂಖ್ಯೆಗಳನ್ನು ಗುರುತಿಸುತ್ತದೆ.';

  @override
  String careModelName(String model) {
    return 'ಕೇರ್ ಮಾಡೆಲ್ · $model';
  }

  @override
  String get tierLite => 'ಲೈಟ್';

  @override
  String get tierBalanced => 'ಸಮತೋಲಿತ';

  @override
  String get tierPro => 'ಪ್ರೊ';

  @override
  String get tierLiteNote => 'ಅತಿ ವೇಗ. ಚಿಕ್ಕ, ಸರಳ ಉತ್ತರಗಳು.';

  @override
  String get tierBalancedNote =>
      'ಧ್ವನಿ, ಫೋಟೋ ಮತ್ತು ಪಠ್ಯವನ್ನು ಒಟ್ಟಿಗೆ ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತದೆ.';

  @override
  String get tierProNote => 'ಅತ್ಯಂತ ವಿವರವಾದ ಉತ್ತರಗಳು ಮತ್ತು ಡಾಕ್ಟರ್ ಬ್ರೀಫ್.';

  @override
  String get bestForIqoo => 'iQOO ಗೆ ಉತ್ತಮ';

  @override
  String get wifiOnly => 'Wi-Fi ನಲ್ಲಿ ಮಾತ್ರ ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String downloadSize(String size) {
    return 'ಡೌನ್‌ಲೋಡ್ · $size';
  }

  @override
  String get settingUp => 'ಸೆಟಪ್ ಆಗುತ್ತಿದೆ…';

  @override
  String get ready => 'ಸಿದ್ಧ';

  @override
  String allSetName(String name) {
    return 'ಎಲ್ಲಾ ಸಿದ್ಧ, $name!';
  }

  @override
  String get allSet => 'ಎಲ್ಲಾ ಸಿದ್ಧ!';

  @override
  String get readySelf => 'ನಿಮ್ಮ ಆರೈಕೆಯ ನೆನಪು ಸಿದ್ಧವಾಗಿದೆ.';

  @override
  String readyOther(String name) {
    return '$name ಅವರ ಆರೈಕೆಯ ನೆನಪು ಸಿದ್ಧವಾಗಿದೆ. ಈಗ ಕುಟುಂಬವನ್ನು ಆಹ್ವಾನಿಸಿ.';
  }

  @override
  String get rowYou => 'ನೀವು';

  @override
  String get rowCaringFor => 'ಯಾರ ಆರೈಕೆ';

  @override
  String get rowHealth => 'ಆರೋಗ್ಯ';

  @override
  String get rowAllergies => 'ಅಲರ್ಜಿಗಳು';

  @override
  String get rowLanguage => 'ಭಾಷೆ';

  @override
  String get rowAi => 'ಆನ್-ಡಿವೈಸ್ AI';

  @override
  String get notAdded => 'ಸೇರಿಸಿಲ್ಲ';

  @override
  String ageYears(int age) {
    return '$age ವರ್ಷ';
  }

  @override
  String get careQuote => '“ಒಟ್ಟಾಗಿ ಮಾಡಿದರೆ ಆರೈಕೆ ಹಗುರವಾಗುತ್ತದೆ.”';

  @override
  String get enterGurtu => 'Gurtu ಒಳಗೆ ಹೋಗಿ';

  @override
  String get nextUpCareCircle => 'ಮುಂದೆ: ಕೇರ್ ಸರ್ಕಲ್';

  @override
  String get homeComingSoon => 'ಹೋಮ್ ಪರದೆಗಳು ಮುಂದಿನ ಭಾಗದಲ್ಲಿ ಬರುತ್ತವೆ.';

  @override
  String get restartOnboarding => 'ಆನ್‌ಬೋರ್ಡಿಂಗ್ ಮತ್ತೆ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get navHome => 'ಮುಖಪುಟ';

  @override
  String get navMemory => 'ನೆನಪುಗಳು';

  @override
  String get navCircle => 'ವೃತ್ತ';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String goodMorning(String name) {
    return 'ಶುಭೋದಯ, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'ಶುಭ ಮಧ್ಯಾಹ್ನ, $name';
  }

  @override
  String goodEvening(String name) {
    return 'ಶುಭ ಸಂಜೆ, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu ಗೆ ಸ್ವಾಗತ, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'ನಿಮ್ಮ ಕುಟುಂಬದ ಆರೋಗ್ಯ, ಎಲ್ಲರೂ ಒಟ್ಟಾಗಿ ನೆನಪಿಡಿ.';

  @override
  String get caringFor => 'ಆರೈಕೆ';

  @override
  String get switchPatientTitle => 'ನೀವು ಯಾರನ್ನು ಆರೈಕೆ ಮಾಡುತ್ತಿದ್ದೀರಿ?';

  @override
  String get addAnotherPerson => 'ಇನ್ನೊಬ್ಬರನ್ನು ಸೇರಿಸಿ';

  @override
  String get statusOnTrack => 'ಆರೈಕೆ ಸರಿಯಾಗಿ ನಡೆಯುತ್ತಿದೆ';

  @override
  String get statusNeedsAttention => 'ಒಂದು ವಿಷಯಕ್ಕೆ ಗಮನ ಬೇಕು';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'ತುರ್ತು';

  @override
  String get sosHoldTitle => 'ಕೇರ್ ಸರ್ಕಲ್‌ಗೆ ಎಚ್ಚರಿಕೆ ನೀಡಲು ಒತ್ತಿ ಹಿಡಿಯಿರಿ';

  @override
  String get sosHoldBody =>
      'ಬಟನ್ ಅನ್ನು 2 ಸೆಕೆಂಡ್ ಒತ್ತಿ ಹಿಡಿಯಿರಿ. ನಿಮ್ಮ ತುರ್ತು ಸಂಪರ್ಕಗಳಿಗೆ ಎಚ್ಚರಿಕೆ ಹೋಗುತ್ತದೆ.';

  @override
  String get sosHoldButton => 'SOS ಕಳುಹಿಸಲು ಒತ್ತಿ ಹಿಡಿಯಿರಿ';

  @override
  String get sosKeepHolding => 'ಹಿಡಿದುಕೊಂಡೇ ಇರಿ…';

  @override
  String get sosPreviewNote =>
      'ತುರ್ತು ಎಚ್ಚರಿಕೆಗಳು ಇನ್ನೂ ಸಂಪರ್ಕಗೊಂಡಿಲ್ಲ. ಇದು ಮುನ್ನೋಟ ಮಾತ್ರ — ಯಾರಿಗೂ ಎಚ್ಚರಿಕೆ ಹೋಗುವುದಿಲ್ಲ.';

  @override
  String get sosPreviewDone => 'ಮುನ್ನೋಟ ಮುಗಿಯಿತು. ಯಾರಿಗೂ ಎಚ್ಚರಿಕೆ ಹೋಗಿಲ್ಲ.';

  @override
  String get close => 'ಮುಚ್ಚಿ';

  @override
  String get todayCare => 'ಇಂದಿನ ಆರೈಕೆ';

  @override
  String completedOf(int done, int total) {
    return '$totalರಲ್ಲಿ $done ಮುಗಿದಿದೆ';
  }

  @override
  String get viewTodayCare => 'ಇಂದಿನ ಆರೈಕೆ ನೋಡಿ';

  @override
  String get nothingUrgent => 'ಈಗ ತುರ್ತಾಗಿ ಏನೂ ಇಲ್ಲ.';

  @override
  String get markDone => 'ಮುಗಿದಿದೆ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get markNotDone => 'ಮುಗಿದಿಲ್ಲ ಎಂದು ಗುರುತಿಸಿ';

  @override
  String get openToCircle => 'ಕೇರ್ ಸರ್ಕಲ್‌ಗೆ ತೆರೆದಿದೆ';

  @override
  String get captureCare => 'ಆರೈಕೆ ದಾಖಲಿಸಿ';

  @override
  String get captureCareSubtitle => 'ಆರೈಕೆಯ ಮುಖ್ಯ ವಿಷಯವನ್ನು ದಾಖಲಿಸಿ.';

  @override
  String get whatHappened => 'ಏನಾಯಿತು?';

  @override
  String get captureVoice => 'ಧ್ವನಿ';

  @override
  String get captureVoiceHint => 'ಮಾತುಕತೆ ಅಥವಾ ಧ್ವನಿ ಟಿಪ್ಪಣಿ ರೆಕಾರ್ಡ್ ಮಾಡಿ';

  @override
  String get captureScan => 'ಸ್ಕ್ಯಾನ್';

  @override
  String get captureScanHint => 'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್ ಅಥವಾ ಮಾತ್ರೆ ಪಟ್ಟಿ';

  @override
  String get captureVital => 'ರೀಡಿಂಗ್';

  @override
  String get captureVitalHint => 'BP, ಸಕ್ಕರೆ ಅಥವಾ ತಾಪಮಾನ';

  @override
  String get captureDocument => 'ದಾಖಲೆ';

  @override
  String get captureDocumentHint => 'ಡಿಸ್ಚಾರ್ಜ್ ಪೇಪರ್ ಅಥವಾ ಲ್ಯಾಬ್ ರಿಪೋರ್ಟ್';

  @override
  String get captureNote => 'ಟಿಪ್ಪಣಿ';

  @override
  String get captureNoteHint => 'ಏನಾಯಿತು ಎಂದು ಬರೆಯಿರಿ';

  @override
  String get comingSoon => 'ಶೀಘ್ರದಲ್ಲೇ';

  @override
  String get noteHint => 'ಉದಾ. ನಡೆದ ನಂತರ ತಲೆ ಸುತ್ತಿತು';

  @override
  String get saveNote => 'ಟಿಪ್ಪಣಿ ಉಳಿಸಿ';

  @override
  String get noteSaved => 'ಆರೈಕೆ ನೆನಪಿನಲ್ಲಿ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get recentMemory => 'ಇತ್ತೀಚಿನ ನೆನಪುಗಳು';

  @override
  String get viewAll => 'ಎಲ್ಲಾ ನೋಡಿ';

  @override
  String get emptyMemory => 'ನಿಮ್ಮ ಆರೈಕೆಯ ಕಥೆ ಇಲ್ಲಿಂದ ಶುರು.';

  @override
  String addedBy(String name) {
    return '$name ಸೇರಿಸಿದ್ದು';
  }

  @override
  String get sourcePlay => 'ಕೇಳಿ';

  @override
  String get sourceView => 'ನೋಡಿ';

  @override
  String get sourceOpen => 'ತೆರೆಯಿರಿ';

  @override
  String get sourceTitle => 'ಮೂಲ';

  @override
  String get sourceRecording => 'ವೈದ್ಯರ ರೆಕಾರ್ಡಿಂಗ್';

  @override
  String get sourceScan => 'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್ ಸ್ಕ್ಯಾನ್';

  @override
  String get sourceVital => 'ರೀಡಿಂಗ್';

  @override
  String get sourceDocument => 'ದಾಖಲೆ';

  @override
  String get sourceNote => 'ಬರೆದ ಟಿಪ್ಪಣಿ';

  @override
  String get sourceSampleNote =>
      'ಇದು ಮಾದರಿ ಡೇಟಾ, ಹಾಗಾಗಿ ಮೂಲ ಫೈಲ್ ಇಲ್ಲ. ನಿಜವಾದ ರೆಕಾರ್ಡಿಂಗ್ ಮತ್ತು ಸ್ಕ್ಯಾನ್‌ಗಳು ಇಲ್ಲಿ ತೆರೆಯುತ್ತವೆ.';

  @override
  String get yourCareCircle => 'ನಿಮ್ಮ ಕೇರ್ ಸರ್ಕಲ್';

  @override
  String get manageCircle => 'ಸರ್ಕಲ್ ನಿರ್ವಹಿಸಿ';

  @override
  String get emptyCircle => 'ಒಟ್ಟಾಗಿ ಮಾಡಿದರೆ ಆರೈಕೆ ಸುಲಭ.';

  @override
  String get addFamilyMember => 'ಕುಟುಂಬ ಸದಸ್ಯರನ್ನು ಸೇರಿಸಿ';

  @override
  String get rolePatient => 'ರೋಗಿ';

  @override
  String get roleCaregiver => 'ಆರೈಕೆದಾರರು';

  @override
  String get roleFamily => 'ಕುಟುಂಬ';

  @override
  String get roleHelper => 'ನಂಬಿಕಸ್ತ ಸಹಾಯಕರು';

  @override
  String get askGurtuTitle => 'Gurtu ಅನ್ನು ಕೇಳಿ';

  @override
  String get askGurtuPrompt => 'ಏನನ್ನಾದರೂ ನೆನಪಿಸಿಕೊಳ್ಳಲು ಸಹಾಯ ಬೇಕೇ?';

  @override
  String get askExampleBloodTest => 'ರಕ್ತ ಪರೀಕ್ಷೆ ಯಾವಾಗ?';

  @override
  String get askExampleDoctor => 'ನಾಳೆ ವೈದ್ಯರನ್ನು ಏನು ಕೇಳಬೇಕು?';

  @override
  String get askGurtuNote =>
      'ಉತ್ತರಗಳು ನೀವು ಉಳಿಸಿದ ಆರೈಕೆ ಮಾಹಿತಿಯಿಂದಲೇ ಬರುತ್ತವೆ.';

  @override
  String get gettingReady => 'Gurtu ಸಿದ್ಧವಾಗುತ್ತಿದೆ';

  @override
  String get readyYourProfile => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್';

  @override
  String get readyPatientProfile => 'ರೋಗಿಯ ಪ್ರೊಫೈಲ್';

  @override
  String get readyCareCircle => 'ಕೇರ್ ಸರ್ಕಲ್';

  @override
  String get readyEmergencyContact => 'ತುರ್ತು ಸಂಪರ್ಕ';

  @override
  String get previewSampleData => 'ಮಾದರಿ ಡೇಟಾದೊಂದಿಗೆ ನೋಡಿ';

  @override
  String get sampleDataOn => 'ಮಾದರಿ ಆರೈಕೆ ಡೇಟಾ ತೋರಿಸಲಾಗುತ್ತಿದೆ';

  @override
  String get remove => 'ತೆಗೆದುಹಾಕಿ';

  @override
  String get hide => 'ಮರೆಮಾಡಿ';

  @override
  String get comingNextPhase => 'ಈ ಭಾಗವನ್ನು ಮುಂದೆ ತಯಾರಿಸಲಾಗುತ್ತಿದೆ.';

  @override
  String get fatherName => 'ಅಪ್ಪ';

  @override
  String get sampleTaskMorningMedicine => 'ಬೆಳಗಿನ ಔಷಧಿ';

  @override
  String get sampleTaskRecordBp => 'BP ದಾಖಲಿಸಿ';

  @override
  String get sampleTaskBloodTest => 'ರಕ್ತ ಪರೀಕ್ಷೆ';

  @override
  String get sampleTaskDoctorVisit => 'ವೈದ್ಯರ ಭೇಟಿ';

  @override
  String get sampleMomentDoctorTalk => 'ವೈದ್ಯರೊಂದಿಗೆ ಮಾತುಕತೆ';

  @override
  String get sampleMomentDoctorTalkDetail =>
      '“ಉಪಾಹಾರದ ನಂತರ ಔಷಧಿ ತೆಗೆದುಕೊಳ್ಳಿ.”';

  @override
  String get sampleMomentPrescription => 'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್ ಸ್ಕ್ಯಾನ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get sampleMomentPrescriptionDetail => '2 ಔಷಧಿಗಳು ಸಿಕ್ಕಿವೆ';

  @override
  String get sampleMomentBp => 'BP ದಾಖಲಿಸಲಾಗಿದೆ';

  @override
  String get today => 'ಇಂದು';

  @override
  String get yesterday => 'ನಿನ್ನೆ';
}
