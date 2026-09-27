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

  @override
  String get doctorVisit => 'ವೈದ್ಯರ ಭೇಟಿ';

  @override
  String get doctorVisitHint => 'ವೈದ್ಯರು ಹೇಳಿದ್ದನ್ನು ಬರೆದಿಡಿ';

  @override
  String get askDoctor => 'ವೈದ್ಯರಿಗೆ ಕೇಳಬೇಕಾದ ಪ್ರಶ್ನೆಗಳು';

  @override
  String get askDoctorHint => 'Gurtu ತಯಾರಾಗಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಪ್ರಶ್ನೆಗಳು ಸಿದ್ಧ',
      one: '1 ಪ್ರಶ್ನೆ ಸಿದ್ಧ',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'ಕೊನೆಯ ಭೇಟಿ: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'ಮುಂದಿನ ಭೇಟಿ: $date';
  }

  @override
  String get visitsTitle => 'ವೈದ್ಯರ ಭೇಟಿಗಳು';

  @override
  String get visitsSubtitle => 'ಪ್ರತಿ ವೈದ್ಯರು ಹೇಳಿದ್ದು, ಎಲ್ಲವೂ ಒಂದೇ ಕಡೆ.';

  @override
  String get recordVisit => 'ಭೇಟಿಯನ್ನು ದಾಖಲಿಸಿ';

  @override
  String get visitsOverview => 'ಎಲ್ಲಾ ಭೇಟಿಗಳು ಒಂದೇ ನೋಟದಲ್ಲಿ';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಭೇಟಿಗಳು',
      one: '1 ಭೇಟಿ',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ವೈದ್ಯರು',
      one: '1 ವೈದ್ಯರು',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'ಕೊನೆಯ ಭೇಟಿ';

  @override
  String get nextVisit => 'ಮುಂದಿನ ಭೇಟಿ';

  @override
  String get notPlanned => 'ಇನ್ನೂ ನಿಗದಿಯಾಗಿಲ್ಲ';

  @override
  String get pastVisits => 'ಹಿಂದಿನ ಭೇಟಿಗಳು';

  @override
  String get noVisitsTitle => 'ಇನ್ನೂ ಯಾವುದೇ ಭೇಟಿ ದಾಖಲಾಗಿಲ್ಲ';

  @override
  String get noVisitsBody =>
      'ಮುಂದಿನ ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್‌ನಲ್ಲಿ ‘ಭೇಟಿಯನ್ನು ದಾಖಲಿಸಿ’ ಒತ್ತಿ, ವೈದ್ಯರು ಹೇಳುವುದನ್ನು Gurtu ಬರೆದಿಡುತ್ತದೆ.';

  @override
  String get questionsForNextVisit => 'ಮುಂದಿನ ಭೇಟಿಯ ಪ್ರಶ್ನೆಗಳು';

  @override
  String get prepareQuestionsHint =>
      'ನಿಮಗೆ ಹೇಗಿದೆ ಎಂದು Gurtuಗೆ ತಿಳಿಸಿ. ವೈದ್ಯರಿಗೆ ಏನು ಕೇಳಬೇಕೆಂದು ಸೂಚಿಸುತ್ತದೆ.';

  @override
  String get prepareQuestions => 'ಪ್ರಶ್ನೆಗಳನ್ನು ಸಿದ್ಧಪಡಿಸಿ';

  @override
  String get viewQuestions => 'ಪ್ರಶ್ನೆಗಳನ್ನು ನೋಡಿ';

  @override
  String get doctorFallback => 'ವೈದ್ಯರು';

  @override
  String get doctorSaid => 'ವೈದ್ಯರು ಏನು ಹೇಳಿದರು';

  @override
  String get medicinesSection => 'ಔಷಧಿಗಳು';

  @override
  String get testsSection => 'ಮಾಡಿಸಬೇಕಾದ ಪರೀಕ್ಷೆಗಳು';

  @override
  String get questionsAsked => 'ಕೇಳಿದ ಪ್ರಶ್ನೆಗಳು';

  @override
  String askedOf(int asked, int total) {
    return '$totalರಲ್ಲಿ $asked ಕೇಳಲಾಗಿದೆ';
  }

  @override
  String get deleteVisit => 'ಭೇಟಿಯನ್ನು ಅಳಿಸಿ';

  @override
  String get deleteVisitConfirm =>
      'ಈ ಭೇಟಿಯನ್ನು ಅಳಿಸಬೇಕೆ? ಇದನ್ನು ಮರಳಿ ಪಡೆಯಲು ಸಾಧ್ಯವಿಲ್ಲ.';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get delete => 'ಅಳಿಸಿ';

  @override
  String get doctorName => 'ವೈದ್ಯರ ಹೆಸರು';

  @override
  String get doctorNameHint => 'ಉದಾ. ಡಾ. ಮೀನಾ ರಾವ್';

  @override
  String get visitReason => 'ಭೇಟಿಯ ಕಾರಣ';

  @override
  String get visitReasonHint => 'ಉದಾ. ಶುಗರ್ ತಪಾಸಣೆ';

  @override
  String get visitDate => 'ಭೇಟಿಯ ದಿನಾಂಕ';

  @override
  String get listenToDoctor => 'ವೈದ್ಯರ ಮಾತು ಕೇಳಿ';

  @override
  String get stopListening => 'ಕೇಳುವುದನ್ನು ನಿಲ್ಲಿಸಿ';

  @override
  String get speak => 'ಮಾತನಾಡಿ';

  @override
  String get recordingConsent =>
      'ನೀವು Gurtu ಮೂಲಕ ಸಂಭಾಷಣೆ ಬರೆದಿಡುತ್ತಿದ್ದೀರಿ ಎಂದು ವೈದ್ಯರಿಗೆ ತಿಳಿಸಿ.';

  @override
  String get doctorSaidHint => 'ವೈದ್ಯರು ಹೇಳುವುದನ್ನು ಮಾತನಾಡಿ ಅಥವಾ ಟೈಪ್ ಮಾಡಿ';

  @override
  String get medicinesHint => 'ಉದಾ. ಮೆಟ್‌ಫಾರ್ಮಿನ್ 500 mg ತಿಂಡಿಯ ನಂತರ';

  @override
  String get testsHint => 'ಉದಾ. HbA1c ರಕ್ತ ಪರೀಕ್ಷೆ';

  @override
  String get addNextVisit => 'ಮುಂದಿನ ಭೇಟಿಯ ದಿನಾಂಕ ಸೇರಿಸಿ';

  @override
  String get yourQuestions => 'ನಿಮ್ಮ ಪ್ರಶ್ನೆಗಳು';

  @override
  String get tickWhenAsked => 'ವೈದ್ಯರು ಉತ್ತರಿಸಿದ ನಂತರ ಪ್ರತಿಯೊಂದಕ್ಕೂ ಟಿಕ್ ಮಾಡಿ.';

  @override
  String get saveVisit => 'ಭೇಟಿಯನ್ನು ಉಳಿಸಿ';

  @override
  String get visitSaved => 'ಭೇಟಿ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get leaveVisitTitle => 'ಉಳಿಸದೆ ಹೊರಡಬೇಕೆ?';

  @override
  String get leaveVisitBody => 'ಈ ಭೇಟಿಗೆ ನೀವು ಬರೆದದ್ದು ಕಳೆದುಹೋಗುತ್ತದೆ.';

  @override
  String get discard => 'ತ್ಯಜಿಸಿ';

  @override
  String get keepEditing => 'ಬರೆಯುವುದನ್ನು ಮುಂದುವರಿಸಿ';

  @override
  String get voiceUnavailable =>
      'ಈಗ ಧ್ವನಿ ಇನ್‌ಪುಟ್ ಲಭ್ಯವಿಲ್ಲ. ನೀವು ಟೈಪ್ ಮಾಡಬಹುದು.';

  @override
  String get prepTitle => 'ವೈದ್ಯರ ಭೇಟಿಗೆ ತಯಾರಿ';

  @override
  String get prepIntro =>
      'ವೈದ್ಯರನ್ನು ಭೇಟಿಯಾಗಲು ತಯಾರಾಗೋಣ. ಯಾವ ಆರೋಗ್ಯ ಸಮಸ್ಯೆಗಳ ಬಗ್ಗೆ ಮಾತನಾಡಬೇಕು?';

  @override
  String get prepPickOrSay =>
      'ಕೆಳಗೆ ಸಮಸ್ಯೆಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ, ಅಥವಾ ನಿಮ್ಮ ಮಾತಿನಲ್ಲಿ ಹೇಳಿ.';

  @override
  String get prepDescribeHint => 'ಉದಾ. ಮೂರು ದಿನದಿಂದ ತಲೆನೋವು, ಸುಸ್ತು';

  @override
  String prepHeard(String symptoms) {
    return 'ನಾನು ಕೇಳಿದ್ದು: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — ಯಾವಾಗಿನಿಂದ?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — ಎಷ್ಟು ತೀವ್ರವಾಗಿದೆ?';
  }

  @override
  String get askNewMedicine =>
      'ಇತ್ತೀಚೆಗೆ ಯಾವುದಾದರೂ ಔಷಧಿ ಶುರುಮಾಡಿದ್ದೀರಾ ಅಥವಾ ಬದಲಿಸಿದ್ದೀರಾ?';

  @override
  String get askAnythingElse => 'ವೈದ್ಯರಿಗೆ ಇನ್ನೇನಾದರೂ ತಿಳಿಸಬೇಕೆ?';

  @override
  String get urgentWarning =>
      'ತೀವ್ರ ಎದೆನೋವು ಅಥವಾ ಉಸಿರಾಟದ ತೊಂದರೆ ತುರ್ತು ಸ್ಥಿತಿಯಾಗಿರಬಹುದು. ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್‌ಗಾಗಿ ಕಾಯಬೇಡಿ — ಈಗಲೇ ವೈದ್ಯಕೀಯ ಸಹಾಯ ಪಡೆಯಿರಿ.';

  @override
  String get prepThinking => 'ನಿಮ್ಮ ಪ್ರಶ್ನೆಗಳು ಸಿದ್ಧವಾಗುತ್ತಿವೆ…';

  @override
  String get prepResultIntro =>
      'ವೈದ್ಯರಿಗೆ ಇವುಗಳನ್ನು ಕೇಳಿ. ಬೇಡದವನ್ನು ತೆಗೆದುಹಾಕಿ, ಅಥವಾ ನಿಮ್ಮ ಪ್ರಶ್ನೆ ಸೇರಿಸಿ.';

  @override
  String get prepNotDoctor =>
      'Gurtu ವೈದ್ಯರಲ್ಲ. ಈ ಪ್ರಶ್ನೆಗಳು ವೈದ್ಯರೊಂದಿಗೆ ಮಾತನಾಡಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ.';

  @override
  String get addOwnQuestion => 'ನಿಮ್ಮ ಸ್ವಂತ ಪ್ರಶ್ನೆ ಸೇರಿಸಿ';

  @override
  String get add => 'ಸೇರಿಸಿ';

  @override
  String get saveQuestions => 'ಭೇಟಿಗಾಗಿ ಉಳಿಸಿ';

  @override
  String get questionsSaved => 'ಪ್ರಶ್ನೆಗಳನ್ನು ಭೇಟಿಗಾಗಿ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get startAgain => 'ಮತ್ತೆ ಶುರುಮಾಡಿ';

  @override
  String get startVisit => 'ಭೇಟಿ ಶುರುಮಾಡಿ';

  @override
  String get deleteQuestions => 'ಈ ಪ್ರಶ್ನೆಗಳನ್ನು ಅಳಿಸಿ';

  @override
  String get removeQuestion => 'ಪ್ರಶ್ನೆ ತೆಗೆದುಹಾಕಿ';

  @override
  String get done => 'ಆಯಿತು';

  @override
  String get healthProblems => 'ಆರೋಗ್ಯ ಸಮಸ್ಯೆಗಳು';

  @override
  String preparedOn(String date) {
    return '$date ರಂದು ಸಿದ್ಧಪಡಿಸಲಾಗಿದೆ';
  }

  @override
  String get symFever => 'ಜ್ವರ';

  @override
  String get symHeadache => 'ತಲೆನೋವು';

  @override
  String get symBodyPain => 'ಮೈ ಅಥವಾ ಕೀಲು ನೋವು';

  @override
  String get symChestPain => 'ಎದೆನೋವು';

  @override
  String get symBreathless => 'ಉಸಿರಾಟದ ತೊಂದರೆ';

  @override
  String get symCough => 'ಕೆಮ್ಮು';

  @override
  String get symDizziness => 'ತಲೆಸುತ್ತು';

  @override
  String get symTiredness => 'ಸುಸ್ತು';

  @override
  String get symStomach => 'ಹೊಟ್ಟೆಯ ತೊಂದರೆ';

  @override
  String get symPoorSleep => 'ನಿದ್ರೆ ಬರದಿರುವುದು';

  @override
  String get symPoorAppetite => 'ಹಸಿವು ಕಡಿಮೆ';

  @override
  String get symLowMood => 'ಬೇಸರ ಅಥವಾ ಆತಂಕ';

  @override
  String get kwFever => 'ಜ್ವರ,ಚಳಿ,ಮೈ ಬಿಸಿ';

  @override
  String get kwHeadache => 'ತಲೆನೋವು,ತಲೆ ನೋವು';

  @override
  String get kwBodyPain => 'ಮೈ ನೋವು,ಕೀಲು ನೋವು,ಮಂಡಿ,ಸೊಂಟ ನೋವು,ಕಾಲು ನೋವು';

  @override
  String get kwChestPain => 'ಎದೆನೋವು,ಎದೆ,ಹೃದಯ ನೋವು';

  @override
  String get kwBreathless => 'ಉಸಿರು,ಉಸಿರಾಟ,ದಮ್ಮು';

  @override
  String get kwCough => 'ಕೆಮ್ಮು,ಕಫ,ನೆಗಡಿ,ಶೀತ';

  @override
  String get kwDizziness => 'ತಲೆಸುತ್ತು,ತಲೆ ಸುತ್ತು,ಮೂರ್ಛೆ';

  @override
  String get kwTiredness => 'ಸುಸ್ತು,ಆಯಾಸ,ದೌರ್ಬಲ್ಯ,ನಿಶ್ಶಕ್ತಿ';

  @override
  String get kwStomach => 'ಹೊಟ್ಟೆ,ಅಸಿಡಿಟಿ,ಗ್ಯಾಸ್,ವಾಂತಿ,ಭೇದಿ,ಮಲಬದ್ಧತೆ,ವಾಕರಿಕೆ';

  @override
  String get kwPoorSleep => 'ನಿದ್ರೆ,ನಿದ್ದೆ,ನಿದ್ರಾಹೀನತೆ';

  @override
  String get kwPoorAppetite => 'ಹಸಿವು,ಊಟ ಸೇರುತ್ತಿಲ್ಲ';

  @override
  String get kwLowMood => 'ಬೇಸರ,ಆತಂಕ,ಚಿಂತೆ,ಭಯ,ಒತ್ತಡ,ಟೆನ್ಷನ್';

  @override
  String get sinceToday => 'ಇಂದಿನಿಂದ';

  @override
  String get sinceFewDays => 'ಕೆಲವು ದಿನಗಳಿಂದ';

  @override
  String get sinceWeek => 'ಸುಮಾರು ಒಂದು ವಾರದಿಂದ';

  @override
  String get sinceMonth => 'ಒಂದು ತಿಂಗಳು ಅಥವಾ ಹೆಚ್ಚು';

  @override
  String get sevMild => 'ಸ್ವಲ್ಪ';

  @override
  String get sevModerate => 'ಮಧ್ಯಮ';

  @override
  String get sevSevere => 'ತೀವ್ರ';

  @override
  String qCause(String symptom) {
    return '$symptomಗೆ ಕಾರಣ ಏನಿರಬಹುದು?';
  }

  @override
  String qTests(String symptom) {
    return '$symptomಗೆ ಯಾವುದಾದರೂ ಪರೀಕ್ಷೆ ಬೇಕೆ?';
  }

  @override
  String qWarningSigns(String symptom) {
    return '$symptom ಜೊತೆ ಯಾವ ಲಕ್ಷಣಗಳು ಕಂಡರೆ ತಕ್ಷಣ ಬರಬೇಕು?';
  }

  @override
  String qHomeCare(String symptom) {
    return '$symptom ಕಡಿಮೆಯಾಗಲು ಮನೆಯಲ್ಲಿ ಏನು ಮಾಡಬಹುದು?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return '$symptomಗೂ $conditionsಗೂ ಸಂಬಂಧ ಇರಬಹುದೆ?';
  }

  @override
  String get qSideEffect => 'ಹೊಸ ಅಥವಾ ಬದಲಿಸಿದ ಔಷಧಿಯಿಂದ ಇದು ಆಗುತ್ತಿರಬಹುದೆ?';

  @override
  String get qMedicinesStillRight =>
      'ಈಗಿನ ಔಷಧಿಗಳು ಸರಿಯಾಗಿವೆಯೆ, ಅಥವಾ ಏನಾದರೂ ಬದಲಿಸಬೇಕೆ?';

  @override
  String get qNextCheckup => 'ಮುಂದಿನ ತಪಾಸಣೆಗೆ ಯಾವಾಗ ಬರಬೇಕು?';

  @override
  String qTellDoctor(String text) {
    return 'ವೈದ್ಯರಿಗೆ ತಿಳಿಸಿ: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'ಮಧುಮೇಹ ಪರಿಶೀಲನೆ';

  @override
  String get sampleVisitDiabetesNotes =>
      'ಶುಗರ್ ಮೊದಲಿಗಿಂತ ಚೆನ್ನಾಗಿ ನಿಯಂತ್ರಣದಲ್ಲಿದೆ. ಅದೇ ಔಷಧಿಗಳನ್ನು ಮುಂದುವರಿಸಿ. ಪ್ರತಿದಿನ 30 ನಿಮಿಷ ನಡೆಯಿರಿ, ಸಿಹಿ ಕಡಿಮೆ ಮಾಡಿ.';

  @override
  String get sampleVisitDiabetesMeds =>
      'ಮೆಟ್‌ಫಾರ್ಮಿನ್ 500 mg ತಿಂಡಿ ಮತ್ತು ರಾತ್ರಿ ಊಟದ ನಂತರ';

  @override
  String get sampleVisitDiabetesTests =>
      'ಮುಂದಿನ ಭೇಟಿಗೆ ಮೊದಲು HbA1c ರಕ್ತ ಪರೀಕ್ಷೆ';

  @override
  String get sampleVisitKneeReason => 'ಮಂಡಿ ನೋವು';

  @override
  String get sampleVisitKneeNotes =>
      'ಬಲ ಮಂಡಿಯಲ್ಲಿ ಸ್ವಲ್ಪ ಸಂಧಿವಾತ. ಸಂಜೆ ಬಿಸಿ ಶಾಖ ಕೊಡಿ, ಹೆಚ್ಚು ಮೆಟ್ಟಿಲು ಹತ್ತಬೇಡಿ.';

  @override
  String get sampleVisitKneeMeds => 'ನೋವು ನಿವಾರಕ ಜೆಲ್ ದಿನಕ್ಕೆ ಎರಡು ಬಾರಿ';

  @override
  String get scanVerify => 'ಔಷಧಿ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ ಪರಿಶೀಲಿಸಿ';

  @override
  String get scanVerifyHint => 'ಇದೇ ಮಾತ್ರೆಯನ್ನು ಈಗ ತೆಗೆದುಕೊಳ್ಳಬೇಕೆ?';

  @override
  String scanVerifySubtitle(String name) {
    return 'ಸ್ಟ್ರಿಪ್ ಅಥವಾ ಡಬ್ಬಿ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ. Gurtu ಅದನ್ನು $name ಅವರ ಔಷಧಿ ಪಟ್ಟಿಯೊಂದಿಗೆ ಹೋಲಿಸುತ್ತದೆ.';
  }

  @override
  String get scanWithCamera => 'ಔಷಧಿ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get orTypeName => 'ಅಥವಾ ಸ್ಟ್ರಿಪ್ ಮೇಲಿನ ಹೆಸರು ಟೈಪ್ ಮಾಡಿ';

  @override
  String get typeNameHint => 'ಉದಾ. Glycomet 500';

  @override
  String get checkMedicine => 'ಪರಿಶೀಲಿಸಿ';

  @override
  String get checkAnother => 'ಇನ್ನೊಂದು ಔಷಧಿ ಪರಿಶೀಲಿಸಿ';

  @override
  String get readingStrip => 'ಸ್ಟ್ರಿಪ್ ಓದುತ್ತಿದೆ…';

  @override
  String get cameraUnavailable =>
      'ಕ್ಯಾಮೆರಾ ಸ್ಕ್ಯಾನ್ ಫೋನ್ ಆ್ಯಪ್‌ನಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ. ಈಗ ಹೆಸರು ಟೈಪ್ ಮಾಡಿ.';

  @override
  String get scanFailed =>
      'ಫೋಟೋ ಓದಲಾಗಲಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ, ಅಥವಾ ಹೆಸರು ಟೈಪ್ ಮಾಡಿ.';

  @override
  String readFromStrip(String text) {
    return 'ಸ್ಟ್ರಿಪ್‌ನಲ್ಲಿ ಓದಿದ್ದು: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'Gurtu ನೀವು ಉಳಿಸಿದ ಔಷಧಿಗಳೊಂದಿಗೆ ಮಾತ್ರ ಹೋಲಿಸುತ್ತದೆ. ಅದು ಎಂದಿಗೂ ಔಷಧಿ ಸೂಚಿಸುವುದಿಲ್ಲ.';

  @override
  String get verdictTakeNow => 'ಹೌದು — ಇದೇ ಸರಿಯಾದ ಔಷಧಿ, ಈಗ ತೆಗೆದುಕೊಳ್ಳಬಹುದು.';

  @override
  String get verdictNotNow => 'ಔಷಧಿ ಸರಿಯಾಗಿದೆ, ಆದರೆ ಈಗ ತೆಗೆದುಕೊಳ್ಳುವ ಸಮಯವಲ್ಲ.';

  @override
  String get verdictAlreadyTaken =>
      'ಈ ಡೋಸ್ ಈಗಾಗಲೇ ತೆಗೆದುಕೊಳ್ಳಲಾಗಿದೆ. ಮತ್ತೆ ತೆಗೆದುಕೊಳ್ಳಬೇಡಿ.';

  @override
  String get verdictNoTimes => 'ಔಷಧಿ ಸರಿಯಾಗಿದೆ, ಆದರೆ ಇದರ ಸಮಯ ಉಳಿಸಿಲ್ಲ.';

  @override
  String get verdictWrongStrength =>
      'ನಿಲ್ಲಿ — ಪ್ರಮಾಣ (mg) ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ಗಿಂತ ಬೇರೆ ಇದೆ.';

  @override
  String verdictNotOnList(String name) {
    return 'ನಿಲ್ಲಿ — ಈ ಔಷಧಿ $name ಅವರ ಪಟ್ಟಿಯಲ್ಲಿ ಇಲ್ಲ.';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'ನಿಲ್ಲಿ — ಈ ಔಷಧಿ $other ಅವರ ಪಟ್ಟಿಯದು, $name ಅವರದಲ್ಲ.';
  }

  @override
  String get verdictUnreadable =>
      'ಔಷಧಿಯ ಹೆಸರು ಓದಲಾಗಲಿಲ್ಲ. ಉತ್ತಮ ಬೆಳಕಿನಲ್ಲಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ, ಅಥವಾ ಟೈಪ್ ಮಾಡಿ.';

  @override
  String get verdictCheckFirst =>
      'ವೈದ್ಯರು ಅಥವಾ ಫಾರ್ಮಸಿಸ್ಟ್ ಅವರನ್ನು ಕೇಳದೆ ತೆಗೆದುಕೊಳ್ಳಬೇಡಿ.';

  @override
  String get rowOnList => 'ಔಷಧಿ ಪಟ್ಟಿಯಲ್ಲಿದೆ';

  @override
  String rowStrengthMatches(String strength) {
    return 'ಪ್ರಮಾಣ ಹೊಂದುತ್ತದೆ: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'ಸ್ಟ್ರಿಪ್‌ನಲ್ಲಿ $found, ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ನಲ್ಲಿ $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'ಈಗ ತೆಗೆದುಕೊಳ್ಳಬೇಕು: $slot ಡೋಸ್';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot ಡೋಸ್ $timeಕ್ಕೆ ತೆಗೆದುಕೊಳ್ಳಲಾಗಿದೆ';
  }

  @override
  String rowNextDose(String slot) {
    return 'ಮುಂದಿನ ಡೋಸ್: $slot';
  }

  @override
  String get rowSetTimes => 'ಔಷಧಿ ಪಟ್ಟಿಯಲ್ಲಿ ಯಾವಾಗ ತೆಗೆದುಕೊಳ್ಳಬೇಕೆಂದು ಸೇರಿಸಿ';

  @override
  String get markTaken => 'ತೆಗೆದುಕೊಂಡಿದೆ ಎಂದು ದಾಖಲಿಸಿ';

  @override
  String get markedTaken => 'ಡೋಸ್ ದಾಖಲಾಗಿದೆ';

  @override
  String get undo => 'ರದ್ದುಮಾಡಿ';

  @override
  String get medicineList => 'ಔಷಧಿ ಪಟ್ಟಿ';

  @override
  String get medicineListSubtitle =>
      'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ಗಳ ಪ್ರತಿ ಔಷಧಿ, ಯಾವಾಗ ತೆಗೆದುಕೊಳ್ಳಬೇಕು ಎಂಬುದರೊಂದಿಗೆ.';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಔಷಧಿಗಳು',
      one: '1 ಔಷಧಿ',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'ಔಷಧಿ ಸೇರಿಸಿ';

  @override
  String get editMedicine => 'ಔಷಧಿ ಬದಲಿಸಿ';

  @override
  String get addFromPrescription => 'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್ ಫೋಟೋದಿಂದ ಸೇರಿಸಿ';

  @override
  String get noMedicinesTitle => 'ಇನ್ನೂ ಯಾವುದೇ ಔಷಧಿ ಸೇರಿಸಿಲ್ಲ';

  @override
  String get noMedicinesBody =>
      'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ನ ಪ್ರತಿ ಔಷಧಿಯನ್ನು ಒಮ್ಮೆ ಸೇರಿಸಿ. ನಂತರ ಯಾವುದೇ ಸ್ಟ್ರಿಪ್ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ ಸರಿಯೇ ಎಂದು ನೋಡಿ.';

  @override
  String addMedicinesFirst(String name) {
    return 'ಮೊದಲು $name ಅವರ ಔಷಧಿಗಳನ್ನು ಸೇರಿಸಿ, ಆಗ Gurtu ಅವುಗಳೊಂದಿಗೆ ಹೋಲಿಸಬಹುದು.';
  }

  @override
  String get medicineName => 'ಔಷಧಿಯ ಹೆಸರು';

  @override
  String get medicineNameHint => 'ಉದಾ. Metformin';

  @override
  String get alsoCalled => 'ಸ್ಟ್ರಿಪ್ ಮೇಲಿನ ಇನ್ನೊಂದು ಹೆಸರು';

  @override
  String get alsoCalledHint => 'ಉದಾ. Glycomet';

  @override
  String get strength => 'ಪ್ರಮಾಣ';

  @override
  String get strengthHint => 'ಉದಾ. 500 mg';

  @override
  String get whenToTake => 'ಯಾವಾಗ ತೆಗೆದುಕೊಳ್ಳಬೇಕು';

  @override
  String get doseMorning => 'ಬೆಳಿಗ್ಗೆ';

  @override
  String get doseAfternoon => 'ಮಧ್ಯಾಹ್ನ';

  @override
  String get doseEvening => 'ಸಂಜೆ';

  @override
  String get doseNight => 'ರಾತ್ರಿ';

  @override
  String get foodAfter => 'ಊಟದ ನಂತರ';

  @override
  String get foodBefore => 'ಊಟದ ಮೊದಲು';

  @override
  String get foodAny => 'ಊಟದೊಂದಿಗೆ ಅಥವಾ ಇಲ್ಲದೆ';

  @override
  String get saveMedicine => 'ಔಷಧಿ ಉಳಿಸಿ';

  @override
  String get medicineSaved => 'ಔಷಧಿ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get deleteMedicine => 'ಔಷಧಿ ಅಳಿಸಿ';

  @override
  String get deleteMedicineConfirm => 'ಈ ಔಷಧಿಯನ್ನು ಪಟ್ಟಿಯಿಂದ ತೆಗೆಯಬೇಕೆ?';

  @override
  String get scanToFill => 'ಸ್ಟ್ರಿಪ್ ಸ್ಕ್ಯಾನ್ ಮಾಡಿ ತುಂಬಿಸಿ';

  @override
  String get timesNotSet => 'ಸಮಯ ನಿಗದಿಪಡಿಸಿಲ್ಲ';

  @override
  String get takenToday => 'ಇಂದು ತೆಗೆದುಕೊಂಡವು';

  @override
  String get prescriptionTitle => 'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ನಿಂದ ಸೇರಿಸಿ';

  @override
  String get prescriptionHint =>
      'ಮುದ್ರಿತ ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ನ ಸ್ಪಷ್ಟ ಫೋಟೋ ತೆಗೆಯಿರಿ. Gurtu ಔಷಧಿಗಳನ್ನು ಹುಡುಕುತ್ತದೆ; ಯಾವುದನ್ನು ಸೇರಿಸಬೇಕೆಂದು ನೀವು ಆರಿಸಿ.';

  @override
  String get takePhoto => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get chooseFromGallery => 'ಗ್ಯಾಲರಿಯಿಂದ ಆರಿಸಿ';

  @override
  String get medicinesFound => 'ಸಿಕ್ಕ ಔಷಧಿಗಳು';

  @override
  String get tickToAdd =>
      'ಸೇರಿಸಬೇಕಾದವುಗಳಿಗೆ ಟಿಕ್ ಮಾಡಿ. ಪ್ರತಿ ಹೆಸರು ಮತ್ತು ಸಮಯವನ್ನು ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ನೊಂದಿಗೆ ಹೋಲಿಸಿ.';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಔಷಧಿಗಳನ್ನು ಸೇರಿಸಿ',
      one: '1 ಔಷಧಿ ಸೇರಿಸಿ',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'ಯಾವುದೇ ಔಷಧಿ ಸಿಗಲಿಲ್ಲ. ಸ್ಪಷ್ಟ ಫೋಟೋ ತೆಗೆಯಿರಿ, ಅಥವಾ ಕೈಯಾರೆ ಸೇರಿಸಿ.';

  @override
  String get handwrittenNote =>
      'ಕೈಬರಹದ ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ಗಳು ಸರಿಯಾಗಿ ಓದಲಾಗದಿರಬಹುದು. ಪ್ರತಿ ಹೆಸರು ಪರಿಶೀಲಿಸಿ.';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಔಷಧಿಗಳನ್ನು ಸೇರಿಸಲಾಗಿದೆ',
      one: '1 ಔಷಧಿ ಸೇರಿಸಲಾಗಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'ಸ್ಟ್ರಿಪ್ ಮೇಲೆ $strength ಇದೆಯೇ ನೋಡಿ';
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
  String get addPhoto => 'ಫೋಟೋ ಸೇರಿಸಿ';

  @override
  String get recordVoiceNote => 'ಧ್ವನಿ ಟಿಪ್ಪಣಿ ರೆಕಾರ್ಡ್ ಮಾಡಿ';

  @override
  String get voiceNote => 'ಧ್ವನಿ ಟಿಪ್ಪಣಿ';

  @override
  String get recordingNow => 'ರೆಕಾರ್ಡ್ ಆಗುತ್ತಿದೆ…';

  @override
  String get stopAndSave => 'ನಿಲ್ಲಿಸಿ ಉಳಿಸಿ';

  @override
  String get removeAttachmentTitle => 'ಇದನ್ನು ತೆಗೆದುಹಾಕಬೇಕೆ?';

  @override
  String get removeAttachmentBody => 'ಇದು ಈ ಫೋನ್‌ನಿಂದ ಅಳಿಸಲ್ಪಡುತ್ತದೆ.';

  @override
  String get attachFailed => 'ಇದನ್ನು ಸೇರಿಸಲಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get attachHintMedicines =>
      'ಪ್ರಿಸ್ಕ್ರಿಪ್ಷನ್‌ನ ಫೋಟೋ ಸೇರಿಸಿ, ಅಥವಾ ಔಷಧಿಗಳ ಬಗ್ಗೆ ವೈದ್ಯರು ಹೇಳಿದ್ದನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಿ.';

  @override
  String get attachHintTests =>
      'ಪರೀಕ್ಷೆಯ ಚೀಟಿ ಅಥವಾ ವರದಿಯ ಫೋಟೋ ಸೇರಿಸಿ, ಅಥವಾ ವೈದ್ಯರು ಹೇಳಿದ್ದನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಿ.';

  @override
  String get attachHintNextVisit =>
      'ಅಪಾಯಿಂಟ್‌ಮೆಂಟ್ ಕಾರ್ಡ್‌ನ ಫೋಟೋ ಸೇರಿಸಿ, ಅಥವಾ ಮುಂದಿನ ಭೇಟಿಯ ಬಗ್ಗೆ ವೈದ್ಯರು ಹೇಳಿದ್ದನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಿ.';

  @override
  String get play => 'ಪ್ಲೇ ಮಾಡಿ';

  @override
  String get pause => 'ವಿರಾಮ';

  @override
  String get viewPhoto => 'ಫೋಟೋ ನೋಡಿ';

  @override
  String get doctorSpeaks => 'ವೈದ್ಯರು ಮಾತನಾಡುವ ಭಾಷೆ';

  @override
  String listeningIn(String language) {
    return 'ಕೇಳುತ್ತಿದ್ದೇವೆ · $language';
  }

  @override
  String get liveCaptionHint =>
      'ಕೇಳುತ್ತಿದ್ದೇವೆ… ವೈದ್ಯರ ಮಾತು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get transcriptHelp =>
      'ಪ್ರತಿ ವಾಕ್ಯ ಕೇಳಿದ ತಕ್ಷಣ ಇಲ್ಲಿ ಸೇರುತ್ತದೆ. ಯಾವುದೇ ಪದವನ್ನು ನೀವು ಸರಿಪಡಿಸಬಹುದು.';

  @override
  String voiceLanguageMissing(String language) {
    return 'ಈ ಫೋನ್‌ನಲ್ಲಿ $language ಧ್ವನಿ ಟೈಪಿಂಗ್ ಸಿದ್ಧವಾಗಿಲ್ಲ. ಬೇರೆ ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ, ಅಥವಾ ಫೋನ್‌ನ ಧ್ವನಿ ಟೈಪಿಂಗ್ ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಇದನ್ನು ಸೇರಿಸಿ.';
  }

  @override
  String get voiceNeedsInternet =>
      'ಧ್ವನಿ ಟೈಪಿಂಗ್‌ಗೆ ಇಂಟರ್ನೆಟ್ ಬೇಕು. ನೀವು ಟೈಪ್ ಕೂಡ ಮಾಡಬಹುದು.';

  @override
  String get voiceWaitingInternet =>
      'ಇಂಟರ್ನೆಟ್ ಇಲ್ಲ. ಪ್ರಯತ್ನ ಮುಂದುವರಿದಿದೆ — ಇಲ್ಲಿಯವರೆಗೆ ಕೇಳಿದ್ದು ಕಳೆದುಹೋಗುವುದಿಲ್ಲ.';

  @override
  String medicineNumber(int number) {
    return 'ಔಷಧಿ $number';
  }

  @override
  String get addAnotherMedicine => 'ಇನ್ನೊಂದು ಔಷಧಿ ಸೇರಿಸಿ';

  @override
  String get medicinesVisitHint =>
      'ವೈದ್ಯರು ಕೊಡುವ ಪ್ರತಿ ಔಷಧಿಯನ್ನು ಸೇರಿಸಿ. ಸ್ಟ್ರಿಪ್ ಅಥವಾ ಚೀಟಿಯ ಫೋಟೋ ತೆಗೆಯಿರಿ, ಅದರ ಬಗ್ಗೆ ವೈದ್ಯರು ಹೇಳಿದ್ದನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಿ, ಅಥವಾ ಟೈಪ್ ಮಾಡಿ.';

  @override
  String get removeMedicineBody =>
      'ಇದರ ಫೋಟೋಗಳು ಮತ್ತು ಧ್ವನಿ ಟಿಪ್ಪಣಿಗಳೂ ಈ ಫೋನ್‌ನಿಂದ ಅಳಿಸಲ್ಪಡುತ್ತವೆ.';

  @override
  String get questionRemoved => 'ಪ್ರಶ್ನೆ ತೆಗೆದುಹಾಕಲಾಗಿದೆ';

  @override
  String get recordDoctor => 'ವೈದ್ಯರ ಧ್ವನಿ ರೆಕಾರ್ಡ್ ಮಾಡಿ';

  @override
  String get doctorRecordings => 'ರೆಕಾರ್ಡಿಂಗ್‌ಗಳು';

  @override
  String recordingNumber(int number) {
    return 'ರೆಕಾರ್ಡಿಂಗ್ $number';
  }

  @override
  String get recordOrListenHint =>
      'ಕೇಳಿ ಒತ್ತಿದರೆ ವೈದ್ಯರ ಮಾತು ಅಕ್ಷರವಾಗುತ್ತದೆ. ರೆಕಾರ್ಡ್ ಒತ್ತಿದರೆ ಅವರ ಧ್ವನಿ ನಂತರ ಕೇಳಲು ಉಳಿಯುತ್ತದೆ. ಫೋನ್ ಮೈಕ್ ಒಮ್ಮೆಗೆ ಒಂದೇ ಕೆಲಸ ಮಾಡುತ್ತದೆ.';

  @override
  String get tomorrow => 'ನಾಳೆ';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ದಿನಗಳಲ್ಲಿ',
      one: '1 ದಿನದಲ್ಲಿ',
    );
    return '$_temp0';
  }

  @override
  String withDoctor(String doctor) {
    return '$doctor ಅವರೊಂದಿಗೆ';
  }

  @override
  String recordingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ರೆಕಾರ್ಡಿಂಗ್‌ಗಳು',
      one: '1 ರೆಕಾರ್ಡಿಂಗ್',
    );
    return '$_temp0';
  }

  @override
  String photosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಫೋಟೋಗಳು',
      one: '1 ಫೋಟೋ',
    );
    return '$_temp0';
  }

  @override
  String get noNextVisitHint =>
      'ವೈದ್ಯರು ಮತ್ತೆ ಬರಲು ದಿನಾಂಕ ಹೇಳಿದರೆ, ಭೇಟಿಯನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡುವಾಗ ಅದನ್ನು ಸೇರಿಸಿ. ಅದು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String circleSubtitle(String name) {
    return '$name ಅವರನ್ನು ನೋಡಿಕೊಳ್ಳುವ ಎಲ್ಲರೂ, ಒಟ್ಟಿಗೆ.';
  }

  @override
  String get familyCode => 'ಕುಟುಂಬ ಕೋಡ್';

  @override
  String familyCodeHint(String name) {
    return 'ಈ ಕೋಡ್ ಹಂಚಿಕೊಳ್ಳಿ. ಕುಟುಂಬದವರು ಮತ್ತು ಸಹಾಯಕರು ಇದನ್ನು Gurtu ನಲ್ಲಿ ಟೈಪ್ ಮಾಡಿ $name ಅವರ ವಲಯಕ್ಕೆ ಸೇರಬಹುದು.';
  }

  @override
  String get copyCode => 'ಕೋಡ್ ನಕಲಿಸಿ';

  @override
  String get codeCopied => 'ಕೋಡ್ ನಕಲಾಗಿದೆ';

  @override
  String get newCode => 'ಹೊಸ ಕೋಡ್ ಮಾಡಿ';

  @override
  String get newCodeTitle => 'ಹೊಸ ಕೋಡ್ ಮಾಡಬೇಕೆ?';

  @override
  String get newCodeBody =>
      'ಹಳೆಯ ಕೋಡ್ ಕೆಲಸ ಮಾಡುವುದಿಲ್ಲ. ಈಗಾಗಲೇ ವಲಯದಲ್ಲಿರುವವರು ಉಳಿಯುತ್ತಾರೆ.';

  @override
  String get circleMembers => 'ವಲಯದಲ್ಲಿರುವವರು';

  @override
  String get circleOwner => 'ವಲಯ ಆರಂಭಿಸಿದವರು';

  @override
  String get getsReminders => 'ಜ್ಞಾಪನೆಗಳು ಬರುತ್ತವೆ';

  @override
  String get noNotifications => 'ಅಧಿಸೂಚನೆಗಳು ಆಫ್';

  @override
  String get notOnApp => 'ಆ್ಯಪ್‌ನಲ್ಲಿ ಇಲ್ಲ';

  @override
  String get sendTestNotification => 'ಪರೀಕ್ಷಾ ಅಧಿಸೂಚನೆ ಕಳುಹಿಸಿ';

  @override
  String testSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಫೋನ್‌ಗಳಿಗೆ ಕಳುಹಿಸಲಾಗಿದೆ',
      one: '1 ಫೋನ್‌ಗೆ ಕಳುಹಿಸಲಾಗಿದೆ',
      zero: 'ಇನ್ನೂ ಯಾವ ಫೋನನ್ನೂ ತಲುಪಿಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get testTitle => 'Gurtu ಪರೀಕ್ಷೆ';

  @override
  String testBody(String name) {
    return '$name ಅವರ ಆರೈಕೆ ವಲಯಕ್ಕೆ ಅಧಿಸೂಚನೆಗಳು ಕೆಲಸ ಮಾಡುತ್ತಿವೆ.';
  }

  @override
  String get settingUpCode => 'ನಿಮ್ಮ ಕುಟುಂಬ ಕೋಡ್ ಸಿದ್ಧವಾಗುತ್ತಿದೆ…';

  @override
  String get offlineTitle => 'Gurtu ಸರ್ವರ್ ತಲುಪಲಾಗಲಿಲ್ಲ';

  @override
  String get offlineBody =>
      'ಎಲ್ಲವೂ ಈ ಫೋನ್‌ನಲ್ಲಿ ಸುರಕ್ಷಿತವಾಗಿದೆ. ಇಂಟರ್ನೆಟ್ ಸಿಕ್ಕ ತಕ್ಷಣ ಕುಟುಂಬ ಕೋಡ್ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get haveFamilyCode => 'ನನ್ನ ಬಳಿ ಕುಟುಂಬ ಕೋಡ್ ಇದೆ';

  @override
  String get joinTitle => 'ಆರೈಕೆ ವಲಯಕ್ಕೆ ಸೇರಿ';

  @override
  String get joinSubtitle => 'ನಿಮ್ಮ ಕುಟುಂಬದವರು ಹಂಚಿಕೊಂಡ 6 ಅಂಕಿಯ ಕೋಡ್ ನಮೂದಿಸಿ.';

  @override
  String get howHelping => 'ನೀವು ಹೇಗೆ ಸಹಾಯ ಮಾಡುತ್ತಿದ್ದೀರಿ?';

  @override
  String get joinButton => 'ವಲಯಕ್ಕೆ ಸೇರಿ';

  @override
  String get invalidCode =>
      'ಈ ಕೋಡ್ ಯಾವ ಕುಟುಂಬಕ್ಕೂ ಹೊಂದುತ್ತಿಲ್ಲ. ಅಂಕಿಗಳನ್ನು ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get tooManyTries =>
      'ತುಂಬಾ ಬಾರಿ ಪ್ರಯತ್ನಿಸಿದಿರಿ. ಕೆಲವು ನಿಮಿಷ ಕಾದು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get connectionFailed =>
      'ಸಂಪರ್ಕವಾಗಲಿಲ್ಲ. ಇಂಟರ್ನೆಟ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get somethingWrong => 'ಏನೋ ತಪ್ಪಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String joinedCircle(String name) {
    return 'ನೀವು $name ಅವರ ಆರೈಕೆ ವಲಯಕ್ಕೆ ಸೇರಿದ್ದೀರಿ';
  }

  @override
  String get peopleYouCareFor => 'ನೀವು ನೋಡಿಕೊಳ್ಳುವವರು';

  @override
  String get addPersonTitle => 'ನೋಡಿಕೊಳ್ಳಲು ಒಬ್ಬರನ್ನು ಸೇರಿಸಿ';

  @override
  String get setUpNew => 'ಹೊಸಬರಿಗಾಗಿ ಸಿದ್ಧಪಡಿಸಿ';

  @override
  String get setUpNewHint =>
      'ಅವರ ಬಗ್ಗೆ ಕೆಲವು ಪ್ರಶ್ನೆಗಳಿಗೆ ಉತ್ತರಿಸಿ. ಅವರಿಗೆ ಸ್ವಂತ ಕುಟುಂಬ ಕೋಡ್ ಸಿಗುತ್ತದೆ.';

  @override
  String get joinWithCode => 'ಕುಟುಂಬ ಕೋಡ್‌ನೊಂದಿಗೆ ಸೇರಿ';

  @override
  String get joinWithCodeHint =>
      'ಕುಟುಂಬದಲ್ಲಿ ಯಾರೋ ಈಗಾಗಲೇ ಅವರಿಗಾಗಿ Gurtu ಸಿದ್ಧಪಡಿಸಿದ್ದಾರೆ.';

  @override
  String get yourCare => 'ನಿಮ್ಮ ಆರೈಕೆ';

  @override
  String get lookingAfterYou => 'ನಿಮ್ಮನ್ನು ನೋಡಿಕೊಳ್ಳುವವರು';

  @override
  String lookingAfterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಜನ ನಿಮ್ಮನ್ನು ನೋಡಿಕೊಳ್ಳುತ್ತಾರೆ',
      one: '1 ವ್ಯಕ್ತಿ ನಿಮ್ಮನ್ನು ನೋಡಿಕೊಳ್ಳುತ್ತಾರೆ',
      zero: 'ಇನ್ನೂ ಯಾರೂ ಇಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get inviteFamily => 'ನಿಮ್ಮ ಕುಟುಂಬವನ್ನು ಆಹ್ವಾನಿಸಿ';

  @override
  String get inviteFamilyHint =>
      'ನಿಮ್ಮ ಕುಟುಂಬ ಕೋಡ್ ಹಂಚಿಕೊಳ್ಳಿ. ಅವರು ನಿಮ್ಮ ಆರೈಕೆ ನೋಡುತ್ತಾರೆ, ನಿಮ್ಮ ಜ್ಞಾಪನೆಗಳನ್ನು ಪಡೆಯುತ್ತಾರೆ.';

  @override
  String get askForHelp => 'ಕುಟುಂಬದಿಂದ ಸಹಾಯ ಕೇಳಿ';

  @override
  String get askForHelpTitle => 'ನಿಮ್ಮ ಕುಟುಂಬಕ್ಕೆ ಸಂದೇಶ ಕಳುಹಿಸಬೇಕೆ?';

  @override
  String get askForHelpBody =>
      'ನಿಮ್ಮ ಆರೈಕೆ ವಲಯದ ಎಲ್ಲರಿಗೂ ನಿಮಗೆ ಕರೆ ಮಾಡಲು ಅಥವಾ ನೋಡಿ ಬರಲು ಅಧಿಸೂಚನೆ ಬರುತ್ತದೆ.';

  @override
  String get send => 'ಕಳುಹಿಸಿ';

  @override
  String helpSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಜನರಿಗೆ ಕಳುಹಿಸಲಾಗಿದೆ',
      one: '1 ವ್ಯಕ್ತಿಗೆ ಕಳುಹಿಸಲಾಗಿದೆ',
      zero: 'ಇನ್ನೂ ಯಾರನ್ನೂ ತಲುಪಿಲ್ಲ',
    );
    return '$_temp0';
  }

  @override
  String get circleSubtitleSelf => 'ನಿಮ್ಮನ್ನು ನೋಡಿಕೊಳ್ಳುವವರು.';

  @override
  String get iAmPatient => 'ಆರೈಕೆ ಪಡೆಯುವವನು ನಾನೇ';

  @override
  String get patientTaken =>
      'ಆರೈಕೆ ಪಡೆಯುವವರಾಗಿ ಈಗಾಗಲೇ ಒಬ್ಬರು ಸೇರಿದ್ದಾರೆ. ಬೇರೆ ಪಾತ್ರ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get medRemindersTitle => 'ಔಷಧಿ ಜ್ಞಾಪನೆಗಳು';

  @override
  String medRemindersIntro(String name) {
    return 'Gurtu $name ಅವರಿಗಾಗಿ ವೈದ್ಯರ ಮಾತನ್ನು ಓದಿದೆ. ಪ್ರತಿ ಸಮಯ ಪರಿಶೀಲಿಸಿ, ನಂತರ ಜ್ಞಾಪನೆಗಳನ್ನು ಆನ್ ಮಾಡಿ.';
  }

  @override
  String get readingMedicines => 'ಔಷಧಿಗಳನ್ನು ಓದುತ್ತಿದ್ದೇವೆ…';

  @override
  String get readByAi => 'Gurtu AI ಓದಿದೆ';

  @override
  String get readByRules => 'ನಿಮ್ಮ ಟಿಪ್ಪಣಿಗಳಿಂದ ಓದಿದೆ';

  @override
  String get pickTimes => 'ಯಾವಾಗ ತೆಗೆದುಕೊಳ್ಳಬೇಕು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get everyDay => 'ಪ್ರತಿದಿನ';

  @override
  String forDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ದಿನಗಳು',
      one: '1 ದಿನ',
    );
    return '$_temp0';
  }

  @override
  String get howLong => 'ಎಷ್ಟು ದಿನ';

  @override
  String get turnOnReminders => 'ಜ್ಞಾಪನೆಗಳನ್ನು ಆನ್ ಮಾಡಿ';

  @override
  String remindersSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಜ್ಞಾಪನೆಗಳು ಆನ್ ಆಗಿವೆ',
      one: '1 ಜ್ಞಾಪನೆ ಆನ್ ಆಗಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String remindersGoToPatient(String name) {
    return 'ಜ್ಞಾಪನೆಗಳು $name ಅವರ ಫೋನ್‌ಗೆ ಹೋಗುತ್ತವೆ. ತೆಗೆದುಕೊಂಡಂತೆ ಗುರುತಿಸದಿದ್ದರೆ, Gurtu ಇನ್ನೆರಡು ಬಾರಿ ನೆನಪಿಸಿ, ನಂತರ ಕುಟುಂಬಕ್ಕೆ ತಿಳಿಸುತ್ತದೆ.';
  }

  @override
  String remindersGoToFamily(String name) {
    return '$name Gurtu ಬಳಸುವುದಿಲ್ಲ, ಹಾಗಾಗಿ ಜ್ಞಾಪನೆಗಳು ಕುಟುಂಬದ ಫೋನ್‌ಗಳಿಗೆ ಹೋಗುತ್ತವೆ. ತೆಗೆದುಕೊಂಡಂತೆ ಗುರುತಿಸದಿದ್ದರೆ, Gurtu ಇನ್ನೆರಡು ಬಾರಿ ನೆನಪಿಸಿ, ನಂತರ ಎಲ್ಲರಿಗೂ ತಿಳಿಸುತ್ತದೆ.';
  }

  @override
  String get remindersPending =>
      'ಈ ಫೋನ್‌ನಲ್ಲಿ ಉಳಿಸಲಾಗಿದೆ. ಇಂಟರ್ನೆಟ್ ಸಿಕ್ಕ ತಕ್ಷಣ ಜ್ಞಾಪನೆಗಳು ಆನ್ ಆಗುತ್ತವೆ.';

  @override
  String get setUpReminders => 'ಜ್ಞಾಪನೆಗಳನ್ನು ಹೊಂದಿಸಿ';

  @override
  String get changeReminders => 'ಜ್ಞಾಪನೆಗಳನ್ನು ಬದಲಿಸಿ';

  @override
  String get takenIt => 'ನಾನು ತೆಗೆದುಕೊಂಡೆ';

  @override
  String get skipDose => 'ಈ ಬಾರಿ ಬಿಡಿ';

  @override
  String dueAt(String time) {
    return '$timeಕ್ಕೆ ತೆಗೆದುಕೊಳ್ಳಬೇಕು';
  }

  @override
  String get readAloud => 'ಓದಿ ಹೇಳಿ';

  @override
  String get missedDoseEyebrow => 'ತಪ್ಪಿದ ಡೋಸ್';

  @override
  String get markTakenForThem => 'ತೆಗೆದುಕೊಂಡಂತೆ ಗುರುತಿಸಿ';

  @override
  String get illCheck => 'ನಾನು ನೋಡಿಕೊಳ್ಳುತ್ತೇನೆ';

  @override
  String get doseTakenThanks => 'ತೆಗೆದುಕೊಂಡಂತೆ ಗುರುತಿಸಲಾಗಿದೆ. ಒಳ್ಳೆಯದು!';

  @override
  String get noReminderForThis => 'ಜ್ಞಾಪನೆ ಇಲ್ಲ';

  @override
  String get reminderEyebrow => 'ಔಷಧಿ ಜ್ಞಾಪನೆ';
}
