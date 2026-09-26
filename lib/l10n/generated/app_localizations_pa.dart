// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get continueLabel => 'ਅੱਗੇ ਵਧੋ';

  @override
  String get next => 'ਅੱਗੇ';

  @override
  String get skip => 'ਛੱਡੋ';

  @override
  String get later => 'ਬਾਅਦ ਵਿੱਚ';

  @override
  String get back => 'ਪਿੱਛੇ';

  @override
  String get optional => 'ਵਿਕਲਪਿਕ';

  @override
  String get yes => 'ਹਾਂ';

  @override
  String get no => 'ਨਹੀਂ';

  @override
  String get notSure => 'ਪਤਾ ਨਹੀਂ';

  @override
  String get tagline => 'ਯਾਦ ਰੱਖੋ। ਦੇਖਭਾਲ ਕਰੋ। ਮਿਲ ਕੇ।';

  @override
  String get motherName => 'ਬੀਬੀ';

  @override
  String get phaseAbout => 'ਜਾਣ-ਪਛਾਣ';

  @override
  String get phaseHealth => 'ਸਿਹਤ';

  @override
  String get phasePermissions => 'ਇਜਾਜ਼ਤਾਂ';

  @override
  String get phaseAi => 'AI ਸੈੱਟਅੱਪ';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $total ਵਿੱਚੋਂ $current';
  }

  @override
  String get languageTitle => 'ਆਪਣੀ ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get languageSubtitle =>
      'Gurtu ਇਸੇ ਭਾਸ਼ਾ ਵਿੱਚ ਬੋਲੇਗਾ, ਸੁਣੇਗਾ ਅਤੇ ਲਿਖੇਗਾ।';

  @override
  String get languageMixNote =>
      'ਡਾਕਟਰ ਅਕਸਰ ਤੁਹਾਡੀ ਭਾਸ਼ਾ ਵਿੱਚ ਅੰਗਰੇਜ਼ੀ ਮਿਲਾ ਕੇ ਬੋਲਦੇ ਹਨ। Gurtu ਦੋਵਾਂ ਨੂੰ ਇਕੱਠੇ ਸਮਝਦਾ ਹੈ।';

  @override
  String get welcomeTitle => 'ਤੁਹਾਡੇ ਪਰਿਵਾਰ ਦੀ\nਦੇਖਭਾਲ ਦੀ ਯਾਦ';

  @override
  String get welcomeBody =>
      'ਡਾਕਟਰ ਨੇ ਕੀ ਕਿਹਾ, ਕਿਹੜੀ ਦਵਾਈ ਲਿਖੀ ਅਤੇ ਘਰ ਵਿੱਚ ਕੀ ਹੋਇਆ — ਸਭ ਮਿਲ ਕੇ ਯਾਦ ਰੱਖੋ।';

  @override
  String get welcomeScript => 'ਵੱਖ-ਵੱਖ ਭੂਮਿਕਾਵਾਂ। ਇੱਕੋ ਪਿਆਰ।';

  @override
  String get getStarted => 'ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String builtForBrand(String brand) {
    return '$brand ਲਈ ਬਣਾਇਆ';
  }

  @override
  String get madeInHyderabad => 'ਹੈਦਰਾਬਾਦ ਵਿੱਚ ਬਣਿਆ';

  @override
  String get introRecordEyebrow => '1 · ਰਿਕਾਰਡ ਕਰੋ';

  @override
  String get introRecordTitle => 'ਡਾਕਟਰ ਦੀ ਗੱਲ ਕਦੇ ਨਾ ਭੁੱਲੋ';

  @override
  String get introRecordBody =>
      'ਸਭ ਦੀ ਸਹਿਮਤੀ ਨਾਲ ਡਾਕਟਰ, ਨਰਸ ਜਾਂ ਫਾਰਮਾਸਿਸਟ ਦੀ ਗੱਲ ਰਿਕਾਰਡ ਕਰੋ। ਜ਼ਰੂਰੀ ਗੱਲਾਂ Gurtu ਸਾਂਭ ਕੇ ਰੱਖਦਾ ਹੈ।';

  @override
  String get introPlanEyebrow => '2 · ਸਮਝੋ ਅਤੇ ਸਾਂਝਾ ਕਰੋ';

  @override
  String get introPlanTitle => 'ਪੂਰੇ ਪਰਿਵਾਰ ਲਈ ਇੱਕ ਦੇਖਭਾਲ ਯੋਜਨਾ';

  @override
  String get introPlanBody =>
      'ਪਰਚੀਆਂ ਅਤੇ ਰਿਪੋਰਟਾਂ ਸਕੈਨ ਕਰੋ। Gurtu ਉਨ੍ਹਾਂ ਨੂੰ ਆਸਾਨ ਕੰਮਾਂ ਵਿੱਚ ਬਦਲਦਾ ਹੈ ਜੋ ਪਰਿਵਾਰ ਵੰਡ ਸਕਦਾ ਹੈ।';

  @override
  String get introAskEyebrow => '3 · ਪੁੱਛੋ ਅਤੇ ਯਾਦ ਰੱਖੋ';

  @override
  String get introAskTitle => 'ਕੁਝ ਵੀ ਪੁੱਛੋ, ਸਬੂਤ ਦੇਖੋ';

  @override
  String get introAskBody =>
      'ਹਰ ਜਵਾਬ ਦੱਸਦਾ ਹੈ ਕਿ ਇਹ ਕਿੱਥੋਂ ਆਇਆ — ਰਿਕਾਰਡਿੰਗ, ਪਰਚੀ ਜਾਂ ਫ਼ੋਟੋ।';

  @override
  String get letsSetUp => 'ਸੈੱਟਅੱਪ ਕਰੀਏ';

  @override
  String get hospitalMode => 'ਹਸਪਤਾਲ ਮੋਡ';

  @override
  String get consentRecording => 'ਮੌਜੂਦ ਸਭ ਦੀ ਸਹਿਮਤੀ ਨਾਲ ਰਿਕਾਰਡਿੰਗ';

  @override
  String get doctorConversation => 'ਡਾਕਟਰ ਨਾਲ ਗੱਲਬਾਤ';

  @override
  String get nurseInstructions => 'ਨਰਸ ਦੀਆਂ ਹਿਦਾਇਤਾਂ';

  @override
  String get pharmacistAdvice => 'ਫਾਰਮਾਸਿਸਟ ਦੀ ਸਲਾਹ';

  @override
  String get yourCarePlan => 'ਤੁਹਾਡੀ ਦੇਖਭਾਲ ਯੋਜਨਾ';

  @override
  String get afterBreakfast => 'ਨਾਸ਼ਤੇ ਤੋਂ ਬਾਅਦ';

  @override
  String get checkBloodPressure => 'BP ਚੈੱਕ ਕਰੋ';

  @override
  String get twiceDaily => 'ਦਿਨ ਵਿੱਚ ਦੋ ਵਾਰ';

  @override
  String get bloodTest => 'ਖ਼ੂਨ ਦੀ ਜਾਂਚ (CBC)';

  @override
  String get instructionsFound =>
      'ਤੁਹਾਡੀ ਰਿਕਾਰਡਿੰਗ ਅਤੇ ਪਰਚੀ ਵਿੱਚ 4 ਹਿਦਾਇਤਾਂ ਮਿਲੀਆਂ';

  @override
  String get askQuestion => 'ਸ਼ਾਮ ਦੀ ਦਵਾਈ ਬਾਰੇ ਡਾਕਟਰ ਨੇ ਕੀ ਕਿਹਾ ਸੀ?';

  @override
  String get askAnswer =>
      'ਡਾਕਟਰ ਨੇ Amlodipine ਰਾਤ ਦੇ ਖਾਣੇ ਤੋਂ ਬਾਅਦ ਲੈਣ ਲਈ ਕਿਹਾ।';

  @override
  String get sourceDoctorVisit => 'ਸਰੋਤ: ਡਾਕਟਰ ਦੀ ਮੁਲਾਕਾਤ';

  @override
  String get careForTitle => 'ਤੁਸੀਂ Gurtu ਕਿਸ ਲਈ ਸੈੱਟ ਕਰ ਰਹੇ ਹੋ?';

  @override
  String get careForSubtitle =>
      'Gurtu ਇੱਕ ਵਿਅਕਤੀ ਦੇ ਆਲੇ-ਦੁਆਲੇ ਦੇਖਭਾਲ ਦੀ ਯਾਦ ਬਣਾਉਂਦਾ ਹੈ। ਬਾਕੀ ਪਰਿਵਾਰ ਨੂੰ ਬਾਅਦ ਵਿੱਚ ਸੱਦਾ ਦੇ ਸਕਦੇ ਹੋ।';

  @override
  String get careForMyself => 'ਆਪਣੇ ਲਈ';

  @override
  String get careForMyselfHint =>
      'ਮੈਂ ਆਪਣੀ ਦੇਖਭਾਲ ਦਾ ਧਿਆਨ ਰੱਖਣਾ ਚਾਹੁੰਦਾ/ਚਾਹੁੰਦੀ ਹਾਂ';

  @override
  String get careForParent => 'ਮੇਰੇ ਮਾਪੇ';

  @override
  String get careForParentHint => 'ਮਾਂ, ਪਿਤਾ ਜੀ ਜਾਂ ਪਰਿਵਾਰ ਦੇ ਕੋਈ ਬਜ਼ੁਰਗ';

  @override
  String get careForPartner => 'ਮੇਰਾ ਜੀਵਨ ਸਾਥੀ';

  @override
  String get careForPartnerHint => 'ਪਤੀ, ਪਤਨੀ ਜਾਂ ਸਾਥੀ';

  @override
  String get careForChild => 'ਮੇਰਾ ਬੱਚਾ';

  @override
  String get careForChildHint => 'ਪੁੱਤਰ ਜਾਂ ਧੀ';

  @override
  String get careForOther => 'ਕੋਈ ਹੋਰ';

  @override
  String get careForOtherHint => 'ਰਿਸ਼ਤੇਦਾਰ, ਦੋਸਤ ਜਾਂ ਗੁਆਂਢੀ';

  @override
  String get profileTitleSelf => 'ਆਪਣੇ ਬਾਰੇ ਦੱਸੋ';

  @override
  String get profileTitleOther => 'ਉਨ੍ਹਾਂ ਬਾਰੇ ਦੱਸੋ';

  @override
  String get profileSubtitleSelf => 'ਇਸ ਨਾਲ Gurtu ਤੁਹਾਨੂੰ ਨਾਮ ਨਾਲ ਬੁਲਾਏਗਾ।';

  @override
  String get profileSubtitleOther =>
      'ਘਰ ਵਿੱਚ ਜਿਸ ਨਾਮ ਨਾਲ ਬੁਲਾਉਂਦੇ ਹੋ, ਉਹੀ ਲਿਖੋ।';

  @override
  String get yourName => 'ਤੁਹਾਡਾ ਨਾਮ';

  @override
  String get whatDoYouCallThem => 'ਤੁਸੀਂ ਉਨ੍ਹਾਂ ਨੂੰ ਕੀ ਕਹਿ ਕੇ ਬੁਲਾਉਂਦੇ ਹੋ?';

  @override
  String exampleName(String name) {
    return 'ਜਿਵੇਂ $name';
  }

  @override
  String get sampleSelfName => 'ਹਰਪ੍ਰੀਤ';

  @override
  String get sampleYourName => 'ਪ੍ਰਿਆ';

  @override
  String get yourAge => 'ਤੁਹਾਡੀ ਉਮਰ';

  @override
  String get theirAge => 'ਉਨ੍ਹਾਂ ਦੀ ਉਮਰ';

  @override
  String get years => 'ਸਾਲ';

  @override
  String get decreaseAge => 'ਉਮਰ ਘਟਾਓ';

  @override
  String get increaseAge => 'ਉਮਰ ਵਧਾਓ';

  @override
  String get gender => 'ਲਿੰਗ';

  @override
  String get female => 'ਔਰਤ';

  @override
  String get male => 'ਮਰਦ';

  @override
  String get genderOther => 'ਹੋਰ';

  @override
  String get andYou => 'ਅਤੇ ਤੁਸੀਂ?';

  @override
  String get andYouBody => 'ਤੁਸੀਂ ਉਨ੍ਹਾਂ ਦੇ ਕੇਅਰ ਸਰਕਲ ਦੇ ਪਹਿਲੇ ਮੈਂਬਰ ਹੋਵੋਗੇ।';

  @override
  String get conditionsTitleSelf => 'ਕੀ ਤੁਹਾਨੂੰ ਇਨ੍ਹਾਂ ਵਿੱਚੋਂ ਕੋਈ ਬੀਮਾਰੀ ਹੈ?';

  @override
  String conditionsTitleOther(String name) {
    return 'ਕੀ $name ਨੂੰ ਇਨ੍ਹਾਂ ਵਿੱਚੋਂ ਕੋਈ ਬੀਮਾਰੀ ਹੈ?';
  }

  @override
  String get conditionsSubtitle =>
      'ਜੋ ਵੀ ਲਾਗੂ ਹੋਣ, ਸਭ ਚੁਣੋ। ਇਸ ਨਾਲ Gurtu ਦੇਖਭਾਲ ਯੋਜਨਾ ਬਣਾਉਂਦਾ ਹੈ।';

  @override
  String get condDiabetes => 'ਸ਼ੂਗਰ (ਡਾਇਬਟੀਜ਼)';

  @override
  String get condHighBp => 'ਹਾਈ BP';

  @override
  String get condHeart => 'ਦਿਲ ਦੀ ਬੀਮਾਰੀ';

  @override
  String get condThyroid => 'ਥਾਇਰਾਇਡ';

  @override
  String get condCholesterol => 'ਕੋਲੈਸਟ੍ਰੋਲ';

  @override
  String get condAsthma => 'ਦਮਾ / ਸਾਹ ਦੀ ਤਕਲੀਫ਼';

  @override
  String get condKidney => 'ਗੁਰਦੇ ਦੀ ਬੀਮਾਰੀ';

  @override
  String get condArthritis => 'ਜੋੜਾਂ ਦਾ ਦਰਦ / ਗਠੀਆ';

  @override
  String get condStroke => 'ਪਹਿਲਾਂ ਅਧਰੰਗ ਹੋਇਆ ਸੀ';

  @override
  String get condCancer => 'ਕੈਂਸਰ ਦਾ ਇਲਾਜ';

  @override
  String get noneOfThese => 'ਇਨ੍ਹਾਂ ਵਿੱਚੋਂ ਕੋਈ ਨਹੀਂ';

  @override
  String get notADoctor =>
      'Gurtu ਡਾਕਟਰ ਨਹੀਂ ਹੈ। ਇਹ ਕਦੇ ਬੀਮਾਰੀ ਨਹੀਂ ਦੱਸਦਾ — ਸਿਰਫ਼ ਪਰਿਵਾਰ ਨੂੰ ਦੇਖਭਾਲ ਯਾਦ ਰੱਖਣ ਅਤੇ ਸੰਭਾਲਣ ਵਿੱਚ ਮਦਦ ਕਰਦਾ ਹੈ।';

  @override
  String get medicinesTitleSelf => 'ਕੀ ਤੁਸੀਂ ਰੋਜ਼ ਦਵਾਈ ਲੈਂਦੇ ਹੋ?';

  @override
  String medicinesTitleOther(String name) {
    return 'ਕੀ $name ਰੋਜ਼ ਦਵਾਈ ਲੈਂਦੇ ਹਨ?';
  }

  @override
  String get medicinesSubtitle => 'ਗੋਲੀਆਂ, ਸਿਰਪ, ਇਨਹੇਲਰ ਜਾਂ ਇਨਸੁਲਿਨ — ਸਭ ਗਿਣੋ।';

  @override
  String get howMany => 'ਲਗਭਗ ਕਿੰਨੀਆਂ?';

  @override
  String get sixOrMore => '6 ਜਾਂ ਵੱਧ';

  @override
  String get scanLaterTip =>
      'ਬਾਅਦ ਵਿੱਚ ਬੱਸ ਪਰਚੀ ਜਾਂ ਦਵਾਈ ਦੀ ਪੱਤੀ ਸਕੈਨ ਕਰੋ — ਟਾਈਪ ਕਰਨ ਦੀ ਲੋੜ ਨਹੀਂ।';

  @override
  String get allergiesTitleSelf => 'ਕੀ ਤੁਹਾਨੂੰ ਕਿਸੇ ਚੀਜ਼ ਤੋਂ ਐਲਰਜੀ ਹੈ?';

  @override
  String allergiesTitleOther(String name) {
    return 'ਕੀ $name ਨੂੰ ਕਿਸੇ ਚੀਜ਼ ਤੋਂ ਐਲਰਜੀ ਹੈ?';
  }

  @override
  String get allergiesSubtitle =>
      'ਇਹ ਕਦੇ ਨਾ ਛੁੱਟੇ, ਇਸ ਲਈ Gurtu ਇਸਨੂੰ ਹਰ ਡਾਕਟਰ ਬ੍ਰੀਫ਼ ਵਿੱਚ ਦਿਖਾਏਗਾ।';

  @override
  String get allergyNone => 'ਕੋਈ ਜਾਣੀ-ਪਛਾਣੀ ਐਲਰਜੀ ਨਹੀਂ';

  @override
  String get allergyPenicillin => 'ਪੈਨਿਸਿਲਿਨ';

  @override
  String get allergySulfa => 'ਸਲਫ਼ਾ ਦਵਾਈਆਂ';

  @override
  String get allergyAspirin => 'ਐਸਪਰੀਨ / ਦਰਦ ਦੀ ਦਵਾਈ';

  @override
  String get allergyFood => 'ਖਾਣੇ ਤੋਂ ਐਲਰਜੀ';

  @override
  String get allergyDust => 'ਧੂੜ / ਪਰਾਗ';

  @override
  String get allergyLatex => 'ਲੈਟੇਕਸ';

  @override
  String get mobilityTitleSelf => 'ਤੁਸੀਂ ਰੋਜ਼ ਕਿਵੇਂ ਤੁਰਦੇ-ਫਿਰਦੇ ਹੋ?';

  @override
  String mobilityTitleOther(String name) {
    return '$name ਰੋਜ਼ ਕਿਵੇਂ ਤੁਰਦੇ-ਫਿਰਦੇ ਹਨ?';
  }

  @override
  String get mobilitySubtitle =>
      'ਇਸ ਨਾਲ ਪਰਿਵਾਰ ਮੁਲਾਕਾਤਾਂ, ਜਾਂਚਾਂ ਅਤੇ ਘਰ ਵਿੱਚ ਮਦਦ ਦੀ ਯੋਜਨਾ ਬਣਾ ਸਕਦਾ ਹੈ।';

  @override
  String get mobilityIndependent => 'ਆਪ ਤੁਰ ਲੈਂਦੇ ਹਨ';

  @override
  String get mobilityIndependentHint => 'ਰੋਜ਼ ਦੇ ਕੰਮਾਂ ਵਿੱਚ ਮਦਦ ਦੀ ਲੋੜ ਨਹੀਂ';

  @override
  String get mobilitySomeHelp => 'ਥੋੜ੍ਹੀ ਮਦਦ ਚਾਹੀਦੀ ਹੈ';

  @override
  String get mobilitySomeHelpHint => 'ਸੋਟੀ, ਵਾਕਰ ਜਾਂ ਫੜਨ ਲਈ ਕਿਸੇ ਦਾ ਹੱਥ';

  @override
  String get mobilityFullHelp => 'ਜ਼ਿਆਦਾਤਰ ਮੰਜੇ ਜਾਂ ਵ੍ਹੀਲਚੇਅਰ \'ਤੇ';

  @override
  String get mobilityFullHelpHint => 'ਜ਼ਿਆਦਾਤਰ ਕੰਮਾਂ ਵਿੱਚ ਮਦਦ ਚਾਹੀਦੀ ਹੈ';

  @override
  String get hospitalTitleSelf =>
      'ਕੀ ਪਿਛਲੇ 30 ਦਿਨਾਂ ਵਿੱਚ ਤੁਸੀਂ ਹਸਪਤਾਲ ਜਾਂ ਡਾਕਟਰ ਕੋਲ ਗਏ ਹੋ?';

  @override
  String hospitalTitleOther(String name) {
    return 'ਕੀ ਪਿਛਲੇ 30 ਦਿਨਾਂ ਵਿੱਚ $name ਹਸਪਤਾਲ ਜਾਂ ਡਾਕਟਰ ਕੋਲ ਗਏ ਹਨ?';
  }

  @override
  String get hospitalSubtitle =>
      'ਹਾਲੀਆ ਮੁਲਾਕਾਤਾਂ ਨਾਲ ਅਕਸਰ ਨਵੀਆਂ ਹਿਦਾਇਤਾਂ ਆਉਂਦੀਆਂ ਹਨ।';

  @override
  String get hospitalTip =>
      'ਛੁੱਟੀ ਦੇ ਕਾਗਜ਼ ਅਤੇ ਪਰਚੀਆਂ ਕੋਲ ਰੱਖੋ — ਸੈੱਟਅੱਪ ਤੋਂ ਤੁਰੰਤ ਬਾਅਦ ਸਕੈਨ ਕਰ ਸਕਦੇ ਹੋ।';

  @override
  String get permissionsTitle => 'ਤੁਹਾਡੀ ਮਦਦ ਲਈ ਕੁਝ ਇਜਾਜ਼ਤਾਂ';

  @override
  String get permissionsSubtitle =>
      'Gurtu ਸਿਰਫ਼ ਲੋੜੀਂਦੀਆਂ ਚੀਜ਼ਾਂ ਮੰਗਦਾ ਹੈ। ਕਿਉਂ, ਇਹ ਇੱਥੇ ਹੈ।';

  @override
  String get permMic => 'ਮਾਈਕ੍ਰੋਫ਼ੋਨ';

  @override
  String get permMicWhy =>
      'ਡਾਕਟਰ ਦੀਆਂ ਮੁਲਾਕਾਤਾਂ ਅਤੇ ਵੌਇਸ ਨੋਟ ਰਿਕਾਰਡ ਕਰਨ ਲਈ — ਸਿਰਫ਼ ਜਦੋਂ ਤੁਸੀਂ ਰਿਕਾਰਡ ਦਬਾਓ।';

  @override
  String get permCamera => 'ਕੈਮਰਾ';

  @override
  String get permCameraWhy =>
      'ਪਰਚੀਆਂ, ਦਵਾਈ ਦੀਆਂ ਪੱਤੀਆਂ ਅਤੇ BP ਮਸ਼ੀਨ ਦੀ ਰੀਡਿੰਗ ਸਕੈਨ ਕਰਨ ਲਈ।';

  @override
  String get permNotifications => 'ਸੂਚਨਾਵਾਂ';

  @override
  String get permNotificationsWhy =>
      'ਦਵਾਈ ਦੀ ਯਾਦ ਅਤੇ ਪਰਿਵਾਰ ਵੱਲੋਂ ਕੰਮ ਪੂਰਾ ਹੋਣ ਦੀ ਜਾਣਕਾਰੀ।';

  @override
  String get permPhotos => 'ਫ਼ੋਟੋਆਂ ਅਤੇ ਫ਼ਾਈਲਾਂ';

  @override
  String get permPhotosWhy =>
      'ਗੈਲਰੀ ਵਿੱਚ ਪਹਿਲਾਂ ਤੋਂ ਪਈਆਂ ਰਿਪੋਰਟਾਂ ਅਤੇ ਪਰਚੀਆਂ ਜੋੜੋ।';

  @override
  String get permContacts => 'ਸੰਪਰਕ';

  @override
  String get permContactsWhy =>
      'ਪਰਿਵਾਰ ਦੇ ਮੈਂਬਰਾਂ ਨੂੰ ਕੇਅਰ ਸਰਕਲ ਵਿੱਚ ਜਲਦੀ ਸੱਦੋ।';

  @override
  String get needed => 'ਲੋੜੀਂਦਾ';

  @override
  String get allow => 'ਇਜਾਜ਼ਤ ਦਿਓ';

  @override
  String get allowed => 'ਇਜਾਜ਼ਤ ਮਿਲੀ';

  @override
  String get allowAndContinue => 'ਇਜਾਜ਼ਤ ਦਿਓ ਅਤੇ ਅੱਗੇ ਵਧੋ';

  @override
  String get privacyNote =>
      'ਸਭ ਕੁਝ ਇਸੇ ਫ਼ੋਨ ਵਿੱਚ ਰਹਿੰਦਾ ਹੈ। ਰਿਕਾਰਡਿੰਗ ਆਪਣੇ-ਆਪ ਕਦੇ ਸ਼ੁਰੂ ਨਹੀਂ ਹੁੰਦੀ — ਪਹਿਲਾਂ ਹਮੇਸ਼ਾ ਸਹਿਮਤੀ ਸਕ੍ਰੀਨ ਦਿਖਦੀ ਹੈ।';

  @override
  String permissionBlocked(String permission) {
    return '$permission ਬੰਦ ਹੈ। ਇਸਨੂੰ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਚਾਲੂ ਕਰੋ।';
  }

  @override
  String get settings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String permissionsMissing(String items) {
    return '$items ਤੋਂ ਬਿਨਾਂ ਕੁਝ ਸਹੂਲਤਾਂ ਕੰਮ ਨਹੀਂ ਕਰਨਗੀਆਂ। ਤੁਸੀਂ ਬਾਅਦ ਵਿੱਚ ਇਜਾਜ਼ਤ ਦੇ ਸਕਦੇ ਹੋ।';
  }

  @override
  String get modelTitleChoose => 'Gurtu ਦਾ ਆਨ-ਡਿਵਾਈਸ AI ਸੈੱਟ ਕਰੋ';

  @override
  String get modelTitleDownloading => 'ਤੁਹਾਡਾ AI ਸੈੱਟ ਹੋ ਰਿਹਾ ਹੈ…';

  @override
  String get modelTitleDone => 'ਤੁਹਾਡਾ AI ਤਿਆਰ ਹੈ';

  @override
  String get modelSubtitleChoose =>
      'ਇਹ ਮਾਡਲ ਪੂਰੀ ਤਰ੍ਹਾਂ ਤੁਹਾਡੇ iQOO \'ਤੇ ਚੱਲਦੇ ਹਨ। ਪਰਿਵਾਰ ਦੀ ਸਿਹਤ ਦੀ ਜਾਣਕਾਰੀ ਫ਼ੋਨ ਤੋਂ ਬਾਹਰ ਨਹੀਂ ਜਾਂਦੀ — ਅਤੇ ਇੰਟਰਨੈੱਟ ਤੋਂ ਬਿਨਾਂ ਵੀ ਕੰਮ ਕਰਦਾ ਹੈ।';

  @override
  String get modelSubtitleDownloading =>
      'ਤੁਸੀਂ ਫ਼ੋਨ ਵਰਤਦੇ ਰਹਿ ਸਕਦੇ ਹੋ। ਇਹ ਸਿਰਫ਼ ਇੱਕ ਵਾਰ ਹੁੰਦਾ ਹੈ।';

  @override
  String get modelSubtitleDone => 'ਸਭ ਕੁਝ ਇਸੇ ਫ਼ੋਨ \'ਤੇ ਚੱਲਦਾ ਹੈ, ਆਫ਼ਲਾਈਨ ਵੀ।';

  @override
  String get poweredByIqoo => 'ਤੁਹਾਡੇ iQOO ਨਾਲ ਚੱਲਦਾ';

  @override
  String get deviceCardSub => 'ਆਨ-ਡਿਵਾਈਸ AI · ਨਿੱਜੀ · ਆਫ਼ਲਾਈਨ ਚੱਲਦਾ ਹੈ';

  @override
  String get chooseCareModel => 'ਕੇਅਰ ਮਾਡਲ ਚੁਣੋ';

  @override
  String get careModelHint => 'ਸਵਾਲਾਂ ਦੇ ਜਵਾਬ ਦੇਣ ਵਾਲਾ ਦਿਮਾਗ਼ ਇਹੀ ਹੈ।';

  @override
  String get alwaysIncluded => 'ਹਮੇਸ਼ਾ ਸ਼ਾਮਲ';

  @override
  String get jobListens => 'ਸੁਣਦਾ ਹੈ';

  @override
  String get jobReads => 'ਪੜ੍ਹਦਾ ਹੈ';

  @override
  String get jobSees => 'ਦੇਖਦਾ ਹੈ';

  @override
  String get jobUnderstands => 'ਸਮਝਦਾ ਹੈ';

  @override
  String speechModelName(String language) {
    return 'ਆਵਾਜ਼ · $language + ਅੰਗਰੇਜ਼ੀ';
  }

  @override
  String get speechModelWhat =>
      'ਗੱਲਬਾਤ ਨੂੰ ਤੁਹਾਡੀ ਭਾਸ਼ਾ ਵਿੱਚ ਲਿਖਤ ਵਿੱਚ ਬਦਲਦਾ ਹੈ।';

  @override
  String get readerModelName => 'ਦਸਤਾਵੇਜ਼ ਰੀਡਰ (OCR)';

  @override
  String get readerModelWhat =>
      'ਪਰਚੀਆਂ, ਛੁੱਟੀ ਦੇ ਕਾਗਜ਼ ਅਤੇ ਲੈਬ ਰਿਪੋਰਟਾਂ ਪੜ੍ਹਦਾ ਹੈ।';

  @override
  String get visionModelName => 'ਦਵਾਈ ਅਤੇ ਰੀਡਿੰਗ ਪਛਾਣ';

  @override
  String get visionModelWhat =>
      'ਦਵਾਈ ਦੀਆਂ ਪੱਤੀਆਂ ਅਤੇ BP / ਸ਼ੂਗਰ ਮਸ਼ੀਨ ਦੇ ਅੰਕ ਪਛਾਣਦਾ ਹੈ।';

  @override
  String careModelName(String model) {
    return 'ਕੇਅਰ ਮਾਡਲ · $model';
  }

  @override
  String get tierLite => 'ਲਾਈਟ';

  @override
  String get tierBalanced => 'ਸੰਤੁਲਿਤ';

  @override
  String get tierPro => 'ਪ੍ਰੋ';

  @override
  String get tierLiteNote => 'ਸਭ ਤੋਂ ਤੇਜ਼। ਛੋਟੇ, ਸੌਖੇ ਜਵਾਬ।';

  @override
  String get tierBalancedNote => 'ਆਵਾਜ਼, ਫ਼ੋਟੋ ਅਤੇ ਲਿਖਤ ਨੂੰ ਇਕੱਠੇ ਸਮਝਦਾ ਹੈ।';

  @override
  String get tierProNote => 'ਸਭ ਤੋਂ ਵਿਸਥਾਰਤ ਜਵਾਬ ਅਤੇ ਡਾਕਟਰ ਬ੍ਰੀਫ਼।';

  @override
  String get bestForIqoo => 'iQOO ਲਈ ਸਭ ਤੋਂ ਵਧੀਆ';

  @override
  String get wifiOnly => 'ਸਿਰਫ਼ Wi-Fi \'ਤੇ ਡਾਊਨਲੋਡ ਕਰੋ';

  @override
  String downloadSize(String size) {
    return 'ਡਾਊਨਲੋਡ · $size';
  }

  @override
  String get settingUp => 'ਸੈੱਟ ਹੋ ਰਿਹਾ ਹੈ…';

  @override
  String get ready => 'ਤਿਆਰ';

  @override
  String allSetName(String name) {
    return 'ਸਭ ਤਿਆਰ ਹੈ, $name!';
  }

  @override
  String get allSet => 'ਸਭ ਤਿਆਰ ਹੈ!';

  @override
  String get readySelf => 'ਤੁਹਾਡੀ ਦੇਖਭਾਲ ਦੀ ਯਾਦ ਤਿਆਰ ਹੈ।';

  @override
  String readyOther(String name) {
    return '$name ਦੀ ਦੇਖਭਾਲ ਦੀ ਯਾਦ ਤਿਆਰ ਹੈ। ਹੁਣ ਪਰਿਵਾਰ ਨੂੰ ਸੱਦੋ।';
  }

  @override
  String get rowYou => 'ਤੁਸੀਂ';

  @override
  String get rowCaringFor => 'ਕਿਸਦੀ ਦੇਖਭਾਲ';

  @override
  String get rowHealth => 'ਸਿਹਤ';

  @override
  String get rowAllergies => 'ਐਲਰਜੀ';

  @override
  String get rowLanguage => 'ਭਾਸ਼ਾ';

  @override
  String get rowAi => 'ਆਨ-ਡਿਵਾਈਸ AI';

  @override
  String get notAdded => 'ਨਹੀਂ ਜੋੜਿਆ';

  @override
  String ageYears(int age) {
    return '$age ਸਾਲ';
  }

  @override
  String get careQuote => '“ਮਿਲ ਕੇ ਕਰੀਏ ਤਾਂ ਦੇਖਭਾਲ ਹਲਕੀ ਲੱਗਦੀ ਹੈ।”';

  @override
  String get enterGurtu => 'Gurtu ਖੋਲ੍ਹੋ';

  @override
  String get nextUpCareCircle => 'ਅੱਗੇ: ਕੇਅਰ ਸਰਕਲ';

  @override
  String get homeComingSoon => 'ਹੋਮ ਸਕ੍ਰੀਨਾਂ ਅਗਲੇ ਹਿੱਸੇ ਵਿੱਚ ਆ ਰਹੀਆਂ ਹਨ।';

  @override
  String get restartOnboarding => 'ਆਨਬੋਰਡਿੰਗ ਮੁੜ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get navHome => 'ਹੋਮ';

  @override
  String get navMemory => 'ਯਾਦਾਂ';

  @override
  String get navCircle => 'ਸਰਕਲ';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'ਪ੍ਰੋਫ਼ਾਈਲ';

  @override
  String goodMorning(String name) {
    return 'ਸ਼ੁਭ ਸਵੇਰ, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ, $name';
  }

  @override
  String goodEvening(String name) {
    return 'ਸ਼ੁਭ ਸ਼ਾਮ, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu ਵਿੱਚ ਜੀ ਆਇਆਂ ਨੂੰ, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'ਤੁਹਾਡੇ ਪਰਿਵਾਰ ਦੀ ਸਿਹਤ, ਸਭ ਮਿਲ ਕੇ ਯਾਦ ਰੱਖੋ।';

  @override
  String get caringFor => 'ਦੇਖਭਾਲ';

  @override
  String get switchPatientTitle => 'ਤੁਸੀਂ ਕਿਸ ਦੀ ਦੇਖਭਾਲ ਕਰ ਰਹੇ ਹੋ?';

  @override
  String get addAnotherPerson => 'ਕਿਸੇ ਹੋਰ ਨੂੰ ਜੋੜੋ';

  @override
  String get statusOnTrack => 'ਦੇਖਭਾਲ ਠੀਕ ਚੱਲ ਰਹੀ ਹੈ';

  @override
  String get statusNeedsAttention => 'ਇੱਕ ਗੱਲ ਵੱਲ ਧਿਆਨ ਦੇਣਾ ਹੈ';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'ਐਮਰਜੈਂਸੀ';

  @override
  String get sosHoldTitle => 'ਕੇਅਰ ਸਰਕਲ ਨੂੰ ਚੇਤਾਵਨੀ ਦੇਣ ਲਈ ਦਬਾ ਕੇ ਰੱਖੋ';

  @override
  String get sosHoldBody =>
      'ਬਟਨ ਨੂੰ 2 ਸਕਿੰਟ ਦਬਾ ਕੇ ਰੱਖੋ। ਤੁਹਾਡੇ ਐਮਰਜੈਂਸੀ ਸੰਪਰਕਾਂ ਨੂੰ ਚੇਤਾਵਨੀ ਜਾਵੇਗੀ।';

  @override
  String get sosHoldButton => 'SOS ਭੇਜਣ ਲਈ ਦਬਾ ਕੇ ਰੱਖੋ';

  @override
  String get sosKeepHolding => 'ਦਬਾ ਕੇ ਰੱਖੋ…';

  @override
  String get sosPreviewNote =>
      'ਐਮਰਜੈਂਸੀ ਚੇਤਾਵਨੀਆਂ ਹਾਲੇ ਜੁੜੀਆਂ ਨਹੀਂ ਹਨ। ਇਹ ਸਿਰਫ਼ ਝਲਕ ਹੈ — ਕਿਸੇ ਨੂੰ ਚੇਤਾਵਨੀ ਨਹੀਂ ਜਾਵੇਗੀ।';

  @override
  String get sosPreviewDone => 'ਝਲਕ ਪੂਰੀ ਹੋਈ। ਕਿਸੇ ਨੂੰ ਚੇਤਾਵਨੀ ਨਹੀਂ ਗਈ।';

  @override
  String get close => 'ਬੰਦ ਕਰੋ';

  @override
  String get todayCare => 'ਅੱਜ ਦੀ ਦੇਖਭਾਲ';

  @override
  String completedOf(int done, int total) {
    return '$total ਵਿੱਚੋਂ $done ਪੂਰੇ';
  }

  @override
  String get viewTodayCare => 'ਅੱਜ ਦੀ ਦੇਖਭਾਲ ਦੇਖੋ';

  @override
  String get nothingUrgent => 'ਹੁਣ ਕੁਝ ਵੀ ਜ਼ਰੂਰੀ ਨਹੀਂ।';

  @override
  String get markDone => 'ਪੂਰਾ ਹੋਇਆ ਨਿਸ਼ਾਨ ਲਾਓ';

  @override
  String get markNotDone => 'ਅਧੂਰਾ ਨਿਸ਼ਾਨ ਲਾਓ';

  @override
  String get openToCircle => 'ਕੇਅਰ ਸਰਕਲ ਲਈ ਖੁੱਲ੍ਹਾ';

  @override
  String get captureCare => 'ਦੇਖਭਾਲ ਦਰਜ ਕਰੋ';

  @override
  String get captureCareSubtitle => 'ਦੇਖਭਾਲ ਨਾਲ ਜੁੜੀ ਕੋਈ ਜ਼ਰੂਰੀ ਗੱਲ ਦਰਜ ਕਰੋ।';

  @override
  String get whatHappened => 'ਕੀ ਹੋਇਆ?';

  @override
  String get captureVoice => 'ਆਵਾਜ਼';

  @override
  String get captureVoiceHint => 'ਗੱਲਬਾਤ ਜਾਂ ਵੌਇਸ ਨੋਟ ਰਿਕਾਰਡ ਕਰੋ';

  @override
  String get captureScan => 'ਸਕੈਨ';

  @override
  String get captureScanHint => 'ਪਰਚੀ ਜਾਂ ਦਵਾਈ ਦੀ ਪੱਤੀ';

  @override
  String get captureVital => 'ਰੀਡਿੰਗ';

  @override
  String get captureVitalHint => 'BP, ਸ਼ੂਗਰ ਜਾਂ ਤਾਪਮਾਨ';

  @override
  String get captureDocument => 'ਦਸਤਾਵੇਜ਼';

  @override
  String get captureDocumentHint => 'ਛੁੱਟੀ ਦਾ ਕਾਗਜ਼ ਜਾਂ ਲੈਬ ਰਿਪੋਰਟ';

  @override
  String get captureNote => 'ਨੋਟ';

  @override
  String get captureNoteHint => 'ਜੋ ਹੋਇਆ ਉਹ ਲਿਖੋ';

  @override
  String get comingSoon => 'ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get noteHint => 'ਜਿਵੇਂ ਤੁਰਨ ਤੋਂ ਬਾਅਦ ਚੱਕਰ ਆਇਆ';

  @override
  String get saveNote => 'ਨੋਟ ਸੰਭਾਲੋ';

  @override
  String get noteSaved => 'ਦੇਖਭਾਲ ਦੀ ਯਾਦ ਵਿੱਚ ਸੰਭਾਲਿਆ';

  @override
  String get recentMemory => 'ਹਾਲੀਆ ਯਾਦਾਂ';

  @override
  String get viewAll => 'ਸਭ ਦੇਖੋ';

  @override
  String get emptyMemory => 'ਤੁਹਾਡੀ ਦੇਖਭਾਲ ਦੀ ਕਹਾਣੀ ਇੱਥੋਂ ਸ਼ੁਰੂ ਹੁੰਦੀ ਹੈ।';

  @override
  String addedBy(String name) {
    return '$name ਨੇ ਜੋੜਿਆ';
  }

  @override
  String get sourcePlay => 'ਸੁਣੋ';

  @override
  String get sourceView => 'ਦੇਖੋ';

  @override
  String get sourceOpen => 'ਖੋਲ੍ਹੋ';

  @override
  String get sourceTitle => 'ਸਰੋਤ';

  @override
  String get sourceRecording => 'ਡਾਕਟਰ ਦੀ ਰਿਕਾਰਡਿੰਗ';

  @override
  String get sourceScan => 'ਪਰਚੀ ਸਕੈਨ';

  @override
  String get sourceVital => 'ਰੀਡਿੰਗ';

  @override
  String get sourceDocument => 'ਦਸਤਾਵੇਜ਼';

  @override
  String get sourceNote => 'ਲਿਖਿਆ ਨੋਟ';

  @override
  String get sourceSampleNote =>
      'ਇਹ ਨਮੂਨਾ ਡਾਟਾ ਹੈ, ਇਸ ਲਈ ਅਸਲ ਫ਼ਾਈਲ ਨਹੀਂ ਹੈ। ਅਸਲ ਰਿਕਾਰਡਿੰਗਾਂ ਅਤੇ ਸਕੈਨ ਇੱਥੇ ਖੁੱਲ੍ਹਣਗੇ।';

  @override
  String get yourCareCircle => 'ਤੁਹਾਡਾ ਕੇਅਰ ਸਰਕਲ';

  @override
  String get manageCircle => 'ਸਰਕਲ ਸੰਭਾਲੋ';

  @override
  String get emptyCircle => 'ਮਿਲ ਕੇ ਦੇਖਭਾਲ ਆਸਾਨ ਹੁੰਦੀ ਹੈ।';

  @override
  String get addFamilyMember => 'ਪਰਿਵਾਰਕ ਮੈਂਬਰ ਜੋੜੋ';

  @override
  String get rolePatient => 'ਮਰੀਜ਼';

  @override
  String get roleCaregiver => 'ਦੇਖਭਾਲ ਕਰਨ ਵਾਲੇ';

  @override
  String get roleFamily => 'ਪਰਿਵਾਰ';

  @override
  String get roleHelper => 'ਭਰੋਸੇਮੰਦ ਸਹਾਇਕ';

  @override
  String get askGurtuTitle => 'Gurtu ਨੂੰ ਪੁੱਛੋ';

  @override
  String get askGurtuPrompt => 'ਕੁਝ ਯਾਦ ਰੱਖਣ ਵਿੱਚ ਮਦਦ ਚਾਹੀਦੀ ਹੈ?';

  @override
  String get askExampleBloodTest => 'ਖ਼ੂਨ ਦੀ ਜਾਂਚ ਕਦੋਂ ਹੈ?';

  @override
  String get askExampleDoctor => 'ਕੱਲ੍ਹ ਡਾਕਟਰ ਨੂੰ ਕੀ ਪੁੱਛਾਂ?';

  @override
  String get askGurtuNote =>
      'ਜਵਾਬ ਤੁਹਾਡੀ ਸੰਭਾਲੀ ਦੇਖਭਾਲ ਜਾਣਕਾਰੀ ਤੋਂ ਹੀ ਆਉਂਦੇ ਹਨ।';

  @override
  String get gettingReady => 'Gurtu ਤਿਆਰ ਹੋ ਰਿਹਾ ਹੈ';

  @override
  String get readyYourProfile => 'ਤੁਹਾਡੀ ਪ੍ਰੋਫ਼ਾਈਲ';

  @override
  String get readyPatientProfile => 'ਮਰੀਜ਼ ਦੀ ਪ੍ਰੋਫ਼ਾਈਲ';

  @override
  String get readyCareCircle => 'ਕੇਅਰ ਸਰਕਲ';

  @override
  String get readyEmergencyContact => 'ਐਮਰਜੈਂਸੀ ਸੰਪਰਕ';

  @override
  String get previewSampleData => 'ਨਮੂਨਾ ਡਾਟਾ ਨਾਲ ਦੇਖੋ';

  @override
  String get sampleDataOn => 'ਨਮੂਨਾ ਦੇਖਭਾਲ ਡਾਟਾ ਦਿਖ ਰਿਹਾ ਹੈ';

  @override
  String get remove => 'ਹਟਾਓ';

  @override
  String get hide => 'ਲੁਕਾਓ';

  @override
  String get comingNextPhase => 'ਇਹ ਹਿੱਸਾ ਅੱਗੇ ਬਣ ਰਿਹਾ ਹੈ।';

  @override
  String get fatherName => 'ਪਿਤਾ ਜੀ';

  @override
  String get sampleTaskMorningMedicine => 'ਸਵੇਰ ਦੀ ਦਵਾਈ';

  @override
  String get sampleTaskRecordBp => 'BP ਦਰਜ ਕਰੋ';

  @override
  String get sampleTaskBloodTest => 'ਖ਼ੂਨ ਦੀ ਜਾਂਚ';

  @override
  String get sampleTaskDoctorVisit => 'ਡਾਕਟਰ ਨਾਲ ਮੁਲਾਕਾਤ';

  @override
  String get sampleMomentDoctorTalk => 'ਡਾਕਟਰ ਨਾਲ ਗੱਲਬਾਤ';

  @override
  String get sampleMomentDoctorTalkDetail => '“ਨਾਸ਼ਤੇ ਤੋਂ ਬਾਅਦ ਦਵਾਈ ਲਓ।”';

  @override
  String get sampleMomentPrescription => 'ਪਰਚੀ ਸਕੈਨ ਕੀਤੀ';

  @override
  String get sampleMomentPrescriptionDetail => '2 ਦਵਾਈਆਂ ਮਿਲੀਆਂ';

  @override
  String get sampleMomentBp => 'BP ਦਰਜ ਕੀਤਾ';

  @override
  String get today => 'ਅੱਜ';

  @override
  String get yesterday => 'ਕੱਲ੍ਹ';
}
