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

  @override
  String get doctorVisit => 'ਡਾਕਟਰ ਨਾਲ ਮੁਲਾਕਾਤ';

  @override
  String get doctorVisitHint => 'ਡਾਕਟਰ ਦੀਆਂ ਗੱਲਾਂ ਨੋਟ ਕਰੋ';

  @override
  String get askDoctor => 'ਡਾਕਟਰ ਤੋਂ ਪੁੱਛਣ ਵਾਲੇ ਸਵਾਲ';

  @override
  String get askDoctorHint => 'Gurtu ਤਿਆਰੀ ਵਿੱਚ ਮਦਦ ਕਰੇਗਾ';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਸਵਾਲ ਤਿਆਰ',
      one: '1 ਸਵਾਲ ਤਿਆਰ',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'ਪਿਛਲੀ ਮੁਲਾਕਾਤ: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'ਅਗਲੀ ਮੁਲਾਕਾਤ: $date';
  }

  @override
  String get visitsTitle => 'ਡਾਕਟਰ ਮੁਲਾਕਾਤਾਂ';

  @override
  String get visitsSubtitle => 'ਹਰ ਡਾਕਟਰ ਨੇ ਜੋ ਕਿਹਾ, ਸਭ ਇੱਕ ਥਾਂ।';

  @override
  String get recordVisit => 'ਮੁਲਾਕਾਤ ਦਰਜ ਕਰੋ';

  @override
  String get visitsOverview => 'ਸਾਰੀਆਂ ਮੁਲਾਕਾਤਾਂ ਇੱਕ ਨਜ਼ਰ ਵਿੱਚ';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਮੁਲਾਕਾਤਾਂ',
      one: '1 ਮੁਲਾਕਾਤ',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਡਾਕਟਰ',
      one: '1 ਡਾਕਟਰ',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'ਪਿਛਲੀ ਮੁਲਾਕਾਤ';

  @override
  String get nextVisit => 'ਅਗਲੀ ਮੁਲਾਕਾਤ';

  @override
  String get notPlanned => 'ਅਜੇ ਤੈਅ ਨਹੀਂ';

  @override
  String get pastVisits => 'ਪਿਛਲੀਆਂ ਮੁਲਾਕਾਤਾਂ';

  @override
  String get noVisitsTitle => 'ਅਜੇ ਕੋਈ ਮੁਲਾਕਾਤ ਦਰਜ ਨਹੀਂ';

  @override
  String get noVisitsBody =>
      'ਅਗਲੀ ਅਪੌਇੰਟਮੈਂਟ ‘ਤੇ ‘ਮੁਲਾਕਾਤ ਦਰਜ ਕਰੋ’ ਦਬਾਓ, ਡਾਕਟਰ ਜੋ ਕਹੇਗਾ Gurtu ਨੋਟ ਕਰੇਗਾ।';

  @override
  String get questionsForNextVisit => 'ਅਗਲੀ ਮੁਲਾਕਾਤ ਦੇ ਸਵਾਲ';

  @override
  String get prepareQuestionsHint =>
      'Gurtu ਨੂੰ ਦੱਸੋ ਤੁਸੀਂ ਕਿਵੇਂ ਮਹਿਸੂਸ ਕਰ ਰਹੇ ਹੋ। ਉਹ ਦੱਸੇਗਾ ਡਾਕਟਰ ਤੋਂ ਕੀ ਪੁੱਛਣਾ ਹੈ।';

  @override
  String get prepareQuestions => 'ਸਵਾਲ ਤਿਆਰ ਕਰੋ';

  @override
  String get viewQuestions => 'ਸਵਾਲ ਵੇਖੋ';

  @override
  String get doctorFallback => 'ਡਾਕਟਰ';

  @override
  String get doctorSaid => 'ਡਾਕਟਰ ਨੇ ਕੀ ਕਿਹਾ';

  @override
  String get medicinesSection => 'ਦਵਾਈਆਂ';

  @override
  String get testsSection => 'ਕਰਵਾਉਣ ਵਾਲੇ ਟੈਸਟ';

  @override
  String get questionsAsked => 'ਪੁੱਛੇ ਗਏ ਸਵਾਲ';

  @override
  String askedOf(int asked, int total) {
    return '$total ਵਿੱਚੋਂ $asked ਪੁੱਛੇ';
  }

  @override
  String get deleteVisit => 'ਮੁਲਾਕਾਤ ਮਿਟਾਓ';

  @override
  String get deleteVisitConfirm => 'ਇਹ ਮੁਲਾਕਾਤ ਮਿਟਾਉਣੀ ਹੈ? ਇਹ ਵਾਪਸ ਨਹੀਂ ਆਵੇਗੀ।';

  @override
  String get cancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get delete => 'ਮਿਟਾਓ';

  @override
  String get doctorName => 'ਡਾਕਟਰ ਦਾ ਨਾਂ';

  @override
  String get doctorNameHint => 'ਜਿਵੇਂ ਡਾ. ਮੀਨਾ ਰਾਓ';

  @override
  String get visitReason => 'ਮੁਲਾਕਾਤ ਦਾ ਕਾਰਨ';

  @override
  String get visitReasonHint => 'ਜਿਵੇਂ ਸ਼ੂਗਰ ਦੀ ਜਾਂਚ';

  @override
  String get visitDate => 'ਮੁਲਾਕਾਤ ਦੀ ਤਾਰੀਖ';

  @override
  String get listenToDoctor => 'ਡਾਕਟਰ ਦੀ ਗੱਲ ਸੁਣੋ';

  @override
  String get stopListening => 'ਸੁਣਨਾ ਬੰਦ ਕਰੋ';

  @override
  String get speak => 'ਬੋਲੋ';

  @override
  String get recordingConsent =>
      'ਡਾਕਟਰ ਨੂੰ ਦੱਸ ਦਿਓ ਕਿ ਤੁਸੀਂ Gurtu ਨਾਲ ਗੱਲਬਾਤ ਨੋਟ ਕਰ ਰਹੇ ਹੋ।';

  @override
  String get doctorSaidHint => 'ਡਾਕਟਰ ਜੋ ਕਹੇ, ਬੋਲੋ ਜਾਂ ਟਾਈਪ ਕਰੋ';

  @override
  String get medicinesHint => 'ਜਿਵੇਂ ਮੈਟਫਾਰਮਿਨ 500 mg ਨਾਸ਼ਤੇ ਤੋਂ ਬਾਅਦ';

  @override
  String get testsHint => 'ਜਿਵੇਂ HbA1c ਖੂਨ ਦੀ ਜਾਂਚ';

  @override
  String get addNextVisit => 'ਅਗਲੀ ਮੁਲਾਕਾਤ ਦੀ ਤਾਰੀਖ ਜੋੜੋ';

  @override
  String get yourQuestions => 'ਤੁਹਾਡੇ ਸਵਾਲ';

  @override
  String get tickWhenAsked => 'ਡਾਕਟਰ ਦੇ ਜਵਾਬ ਦੇਣ ‘ਤੇ ਹਰ ਇੱਕ ‘ਤੇ ਟਿਕ ਕਰੋ।';

  @override
  String get saveVisit => 'ਮੁਲਾਕਾਤ ਸੇਵ ਕਰੋ';

  @override
  String get visitSaved => 'ਮੁਲਾਕਾਤ ਸੇਵ ਹੋ ਗਈ';

  @override
  String get leaveVisitTitle => 'ਬਿਨਾਂ ਸੇਵ ਕੀਤੇ ਜਾਣਾ ਹੈ?';

  @override
  String get leaveVisitBody => 'ਇਸ ਮੁਲਾਕਾਤ ਲਈ ਨੋਟ ਕੀਤੀਆਂ ਗੱਲਾਂ ਮਿਟ ਜਾਣਗੀਆਂ।';

  @override
  String get discard => 'ਛੱਡ ਦਿਓ';

  @override
  String get keepEditing => 'ਲਿਖਣਾ ਜਾਰੀ ਰੱਖੋ';

  @override
  String get voiceUnavailable =>
      'ਹੁਣ ਆਵਾਜ਼ ਨਾਲ ਲਿਖਣਾ ਉਪਲਬਧ ਨਹੀਂ। ਤੁਸੀਂ ਟਾਈਪ ਕਰ ਸਕਦੇ ਹੋ।';

  @override
  String get prepTitle => 'ਡਾਕਟਰ ਲਈ ਤਿਆਰੀ';

  @override
  String get prepIntro =>
      'ਚਲੋ ਡਾਕਟਰ ਕੋਲ ਜਾਣ ਦੀ ਤਿਆਰੀ ਕਰੀਏ। ਕਿਹੜੀਆਂ ਤਕਲੀਫ਼ਾਂ ਬਾਰੇ ਗੱਲ ਕਰਨੀ ਹੈ?';

  @override
  String get prepPickOrSay => 'ਹੇਠਾਂ ਤਕਲੀਫ਼ਾਂ ਚੁਣੋ, ਜਾਂ ਆਪਣੇ ਸ਼ਬਦਾਂ ਵਿੱਚ ਦੱਸੋ।';

  @override
  String get prepDescribeHint => 'ਜਿਵੇਂ ਤਿੰਨ ਦਿਨ ਤੋਂ ਸਿਰ ਦਰਦ ਅਤੇ ਥਕਾਵਟ';

  @override
  String prepHeard(String symptoms) {
    return 'ਮੈਂ ਸੁਣਿਆ: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — ਕਦੋਂ ਤੋਂ?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — ਕਿੰਨਾ ਜ਼ਿਆਦਾ ਹੈ?';
  }

  @override
  String get askNewMedicine => 'ਕੀ ਹਾਲ ਹੀ ਵਿੱਚ ਕੋਈ ਦਵਾਈ ਸ਼ੁਰੂ ਹੋਈ ਜਾਂ ਬਦਲੀ ਹੈ?';

  @override
  String get askAnythingElse => 'ਡਾਕਟਰ ਨੂੰ ਹੋਰ ਕੁਝ ਦੱਸਣਾ ਹੈ?';

  @override
  String get urgentWarning =>
      'ਛਾਤੀ ਵਿੱਚ ਤੇਜ਼ ਦਰਦ ਜਾਂ ਸਾਹ ਚੜ੍ਹਨਾ ਐਮਰਜੈਂਸੀ ਹੋ ਸਕਦੀ ਹੈ। ਅਪੌਇੰਟਮੈਂਟ ਦੀ ਉਡੀਕ ਨਾ ਕਰੋ — ਹੁਣੇ ਡਾਕਟਰੀ ਮਦਦ ਲਓ।';

  @override
  String get prepThinking => 'ਤੁਹਾਡੇ ਸਵਾਲ ਤਿਆਰ ਹੋ ਰਹੇ ਹਨ…';

  @override
  String get prepResultIntro =>
      'ਡਾਕਟਰ ਤੋਂ ਇਹ ਪੁੱਛੋ। ਜੋ ਲੋੜੀਂਦੇ ਨਹੀਂ ਹਟਾਓ, ਜਾਂ ਆਪਣਾ ਸਵਾਲ ਜੋੜੋ।';

  @override
  String get prepNotDoctor =>
      'Gurtu ਡਾਕਟਰ ਨਹੀਂ ਹੈ। ਇਹ ਸਵਾਲ ਡਾਕਟਰ ਨਾਲ ਗੱਲ ਕਰਨ ਵਿੱਚ ਮਦਦ ਕਰਦੇ ਹਨ।';

  @override
  String get addOwnQuestion => 'ਆਪਣਾ ਸਵਾਲ ਜੋੜੋ';

  @override
  String get add => 'ਜੋੜੋ';

  @override
  String get saveQuestions => 'ਮੁਲਾਕਾਤ ਲਈ ਸੇਵ ਕਰੋ';

  @override
  String get questionsSaved => 'ਸਵਾਲ ਮੁਲਾਕਾਤ ਲਈ ਸੇਵ ਹੋ ਗਏ';

  @override
  String get startAgain => 'ਫਿਰ ਤੋਂ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get startVisit => 'ਮੁਲਾਕਾਤ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get deleteQuestions => 'ਇਹ ਸਵਾਲ ਮਿਟਾਓ';

  @override
  String get removeQuestion => 'ਸਵਾਲ ਹਟਾਓ';

  @override
  String get done => 'ਹੋ ਗਿਆ';

  @override
  String get healthProblems => 'ਤਕਲੀਫ਼ਾਂ';

  @override
  String preparedOn(String date) {
    return '$date ਨੂੰ ਤਿਆਰ ਕੀਤਾ';
  }

  @override
  String get symFever => 'ਬੁਖ਼ਾਰ';

  @override
  String get symHeadache => 'ਸਿਰ ਦਰਦ';

  @override
  String get symBodyPain => 'ਸਰੀਰ ਜਾਂ ਜੋੜਾਂ ਵਿੱਚ ਦਰਦ';

  @override
  String get symChestPain => 'ਛਾਤੀ ਵਿੱਚ ਦਰਦ';

  @override
  String get symBreathless => 'ਸਾਹ ਚੜ੍ਹਨਾ';

  @override
  String get symCough => 'ਖੰਘ';

  @override
  String get symDizziness => 'ਚੱਕਰ';

  @override
  String get symTiredness => 'ਥਕਾਵਟ';

  @override
  String get symStomach => 'ਪੇਟ ਦੀ ਤਕਲੀਫ਼';

  @override
  String get symPoorSleep => 'ਨੀਂਦ ਨਾ ਆਉਣਾ';

  @override
  String get symPoorAppetite => 'ਭੁੱਖ ਘੱਟ';

  @override
  String get symLowMood => 'ਉਦਾਸੀ ਜਾਂ ਚਿੰਤਾ';

  @override
  String get kwFever => 'ਬੁਖ਼ਾਰ,ਬੁਖਾਰ,ਤਾਪ,ਠੰਢ';

  @override
  String get kwHeadache => 'ਸਿਰ ਦਰਦ,ਸਿਰਦਰਦ,ਸਿਰ ਵਿੱਚ ਦਰਦ';

  @override
  String get kwBodyPain =>
      'ਸਰੀਰ ਦਰਦ,ਜੋੜਾਂ ਦਾ ਦਰਦ,ਗੋਡੇ,ਗੋਡਾ,ਕਮਰ ਦਰਦ,ਲੱਤਾਂ ਵਿੱਚ ਦਰਦ';

  @override
  String get kwChestPain => 'ਛਾਤੀ,ਛਾਤੀ ਵਿੱਚ ਦਰਦ';

  @override
  String get kwBreathless => 'ਸਾਹ,ਦਮ';

  @override
  String get kwCough => 'ਖੰਘ,ਬਲਗਮ,ਜ਼ੁਕਾਮ,ਨਜ਼ਲਾ';

  @override
  String get kwDizziness => 'ਚੱਕਰ,ਬੇਹੋਸ਼ੀ';

  @override
  String get kwTiredness => 'ਥਕਾਵਟ,ਕਮਜ਼ੋਰੀ,ਥੱਕ';

  @override
  String get kwStomach => 'ਪੇਟ,ਤੇਜ਼ਾਬ,ਗੈਸ,ਉਲਟੀ,ਦਸਤ,ਕਬਜ਼,ਜੀ ਕੱਚਾ';

  @override
  String get kwPoorSleep => 'ਨੀਂਦ,ਉਨੀਂਦਰਾ';

  @override
  String get kwPoorAppetite => 'ਭੁੱਖ,ਖਾਣਾ ਨਹੀਂ';

  @override
  String get kwLowMood => 'ਉਦਾਸ,ਚਿੰਤਾ,ਡਰ,ਤਣਾਅ,ਟੈਨਸ਼ਨ';

  @override
  String get sinceToday => 'ਅੱਜ ਤੋਂ';

  @override
  String get sinceFewDays => 'ਕੁਝ ਦਿਨਾਂ ਤੋਂ';

  @override
  String get sinceWeek => 'ਲਗਭਗ ਇੱਕ ਹਫ਼ਤੇ ਤੋਂ';

  @override
  String get sinceMonth => 'ਇੱਕ ਮਹੀਨਾ ਜਾਂ ਵੱਧ';

  @override
  String get sevMild => 'ਹਲਕਾ';

  @override
  String get sevModerate => 'ਦਰਮਿਆਨਾ';

  @override
  String get sevSevere => 'ਤੇਜ਼';

  @override
  String qCause(String symptom) {
    return '$symptom ਦਾ ਕਾਰਨ ਕੀ ਹੋ ਸਕਦਾ ਹੈ?';
  }

  @override
  String qTests(String symptom) {
    return 'ਕੀ $symptom ਲਈ ਕੋਈ ਟੈਸਟ ਕਰਵਾਉਣਾ ਚਾਹੀਦਾ ਹੈ?';
  }

  @override
  String qWarningSigns(String symptom) {
    return '$symptom ਨਾਲ ਕਿਹੜੇ ਲੱਛਣ ਦਿਸਣ ਤਾਂ ਤੁਰੰਤ ਵਾਪਸ ਆਉਣਾ ਚਾਹੀਦਾ ਹੈ?';
  }

  @override
  String qHomeCare(String symptom) {
    return '$symptom ਘਟਾਉਣ ਲਈ ਘਰ ਵਿੱਚ ਕੀ ਕਰ ਸਕਦੇ ਹਾਂ?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return 'ਕੀ $symptom ਦਾ ਸੰਬੰਧ $conditions ਨਾਲ ਹੋ ਸਕਦਾ ਹੈ?';
  }

  @override
  String get qSideEffect => 'ਕੀ ਕਿਸੇ ਨਵੀਂ ਜਾਂ ਬਦਲੀ ਦਵਾਈ ਕਾਰਨ ਇਹ ਹੋ ਰਿਹਾ ਹੈ?';

  @override
  String get qMedicinesStillRight =>
      'ਕੀ ਹੁਣ ਦੀਆਂ ਦਵਾਈਆਂ ਠੀਕ ਹਨ, ਜਾਂ ਕੁਝ ਬਦਲਣਾ ਚਾਹੀਦਾ ਹੈ?';

  @override
  String get qNextCheckup => 'ਅਗਲੀ ਜਾਂਚ ਲਈ ਕਦੋਂ ਆਉਣਾ ਚਾਹੀਦਾ ਹੈ?';

  @override
  String qTellDoctor(String text) {
    return 'ਡਾਕਟਰ ਨੂੰ ਦੱਸੋ: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'ਸ਼ੂਗਰ ਦੀ ਸਮੀਖਿਆ';

  @override
  String get sampleVisitDiabetesNotes =>
      'ਸ਼ੂਗਰ ਪਹਿਲਾਂ ਨਾਲੋਂ ਵਧੀਆ ਕੰਟਰੋਲ ਵਿੱਚ ਹੈ। ਉਹੀ ਦਵਾਈਆਂ ਜਾਰੀ ਰੱਖੋ। ਰੋਜ਼ 30 ਮਿੰਟ ਸੈਰ ਕਰੋ ਅਤੇ ਮਿੱਠਾ ਘਟਾਓ।';

  @override
  String get sampleVisitDiabetesMeds =>
      'ਮੈਟਫਾਰਮਿਨ 500 mg ਨਾਸ਼ਤੇ ਅਤੇ ਰਾਤ ਦੇ ਖਾਣੇ ਤੋਂ ਬਾਅਦ';

  @override
  String get sampleVisitDiabetesTests =>
      'ਅਗਲੀ ਮੁਲਾਕਾਤ ਤੋਂ ਪਹਿਲਾਂ HbA1c ਖੂਨ ਦੀ ਜਾਂਚ';

  @override
  String get sampleVisitKneeReason => 'ਗੋਡੇ ਦਾ ਦਰਦ';

  @override
  String get sampleVisitKneeNotes =>
      'ਸੱਜੇ ਗੋਡੇ ਵਿੱਚ ਹਲਕਾ ਗਠੀਆ। ਸ਼ਾਮ ਨੂੰ ਗਰਮ ਸੇਕ ਕਰੋ ਅਤੇ ਜ਼ਿਆਦਾ ਪੌੜੀਆਂ ਚੜ੍ਹਨ ਤੋਂ ਬਚੋ।';

  @override
  String get sampleVisitKneeMeds => 'ਦਰਦ ਦੀ ਜੈੱਲ ਦਿਨ ਵਿੱਚ ਦੋ ਵਾਰ';

  @override
  String get scanVerify => 'ਦਵਾਈ ਸਕੈਨ ਕਰਕੇ ਜਾਂਚੋ';

  @override
  String get scanVerifyHint => 'ਕੀ ਇਹੀ ਗੋਲੀ ਹੁਣ ਲੈਣੀ ਹੈ?';

  @override
  String scanVerifySubtitle(String name) {
    return 'ਪੱਤਾ ਜਾਂ ਡੱਬਾ ਸਕੈਨ ਕਰੋ। Gurtu ਇਸਨੂੰ $name ਦੀ ਦਵਾਈ ਸੂਚੀ ਨਾਲ ਮਿਲਾਏਗਾ।';
  }

  @override
  String get scanWithCamera => 'ਦਵਾਈ ਸਕੈਨ ਕਰੋ';

  @override
  String get orTypeName => 'ਜਾਂ ਪੱਤੇ ‘ਤੇ ਲਿਖਿਆ ਨਾਂ ਟਾਈਪ ਕਰੋ';

  @override
  String get typeNameHint => 'ਜਿਵੇਂ Glycomet 500';

  @override
  String get checkMedicine => 'ਜਾਂਚੋ';

  @override
  String get checkAnother => 'ਹੋਰ ਦਵਾਈ ਜਾਂਚੋ';

  @override
  String get readingStrip => 'ਪੱਤਾ ਪੜ੍ਹਿਆ ਜਾ ਰਿਹਾ ਹੈ…';

  @override
  String get cameraUnavailable =>
      'ਕੈਮਰਾ ਸਕੈਨ ਫ਼ੋਨ ਐਪ ਵਿੱਚ ਚੱਲਦਾ ਹੈ। ਹੁਣ ਨਾਂ ਟਾਈਪ ਕਰੋ।';

  @override
  String get scanFailed =>
      'ਫ਼ੋਟੋ ਪੜ੍ਹੀ ਨਹੀਂ ਜਾ ਸਕੀ। ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੋ, ਜਾਂ ਨਾਂ ਟਾਈਪ ਕਰੋ।';

  @override
  String readFromStrip(String text) {
    return 'ਪੱਤੇ ‘ਤੇ ਪੜ੍ਹਿਆ: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'Gurtu ਸਿਰਫ਼ ਤੁਹਾਡੀਆਂ ਸੇਵ ਕੀਤੀਆਂ ਦਵਾਈਆਂ ਨਾਲ ਮਿਲਾਉਂਦਾ ਹੈ। ਇਹ ਕਦੇ ਕੋਈ ਦਵਾਈ ਨਹੀਂ ਸੁਝਾਉਂਦਾ।';

  @override
  String get verdictTakeNow => 'ਹਾਂ — ਇਹੀ ਸਹੀ ਦਵਾਈ ਹੈ, ਹੁਣ ਲੈ ਸਕਦੇ ਹੋ।';

  @override
  String get verdictNotNow => 'ਦਵਾਈ ਸਹੀ ਹੈ, ਪਰ ਹੁਣ ਲੈਣ ਦਾ ਸਮਾਂ ਨਹੀਂ।';

  @override
  String get verdictAlreadyTaken =>
      'ਇਹ ਖ਼ੁਰਾਕ ਪਹਿਲਾਂ ਹੀ ਲਈ ਜਾ ਚੁੱਕੀ ਹੈ। ਦੁਬਾਰਾ ਨਾ ਲਓ।';

  @override
  String get verdictNoTimes => 'ਦਵਾਈ ਸਹੀ ਹੈ, ਪਰ ਇਸਦਾ ਸਮਾਂ ਸੇਵ ਨਹੀਂ।';

  @override
  String get verdictWrongStrength => 'ਰੁਕੋ — ਮਾਤਰਾ (mg) ਪਰਚੀ ਤੋਂ ਵੱਖਰੀ ਹੈ।';

  @override
  String verdictNotOnList(String name) {
    return 'ਰੁਕੋ — ਇਹ ਦਵਾਈ $name ਦੀ ਸੂਚੀ ਵਿੱਚ ਨਹੀਂ ਹੈ।';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'ਰੁਕੋ — ਇਹ ਦਵਾਈ $other ਦੀ ਸੂਚੀ ਦੀ ਹੈ, $name ਦੀ ਨਹੀਂ।';
  }

  @override
  String get verdictUnreadable =>
      'ਦਵਾਈ ਦਾ ਨਾਂ ਪੜ੍ਹਿਆ ਨਹੀਂ ਜਾ ਸਕਿਆ। ਚੰਗੀ ਰੋਸ਼ਨੀ ਵਿੱਚ ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੋ, ਜਾਂ ਟਾਈਪ ਕਰੋ।';

  @override
  String get verdictCheckFirst => 'ਡਾਕਟਰ ਜਾਂ ਫਾਰਮਾਸਿਸਟ ਨੂੰ ਪੁੱਛੇ ਬਿਨਾਂ ਨਾ ਲਓ।';

  @override
  String get rowOnList => 'ਦਵਾਈ ਸੂਚੀ ਵਿੱਚ ਹੈ';

  @override
  String rowStrengthMatches(String strength) {
    return 'ਮਾਤਰਾ ਮਿਲਦੀ ਹੈ: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'ਪੱਤੇ ‘ਤੇ $found, ਪਰਚੀ ਵਿੱਚ $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'ਹੁਣ ਲੈਣੀ ਹੈ: $slot ਦੀ ਖ਼ੁਰਾਕ';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot ਦੀ ਖ਼ੁਰਾਕ $time ‘ਤੇ ਲਈ';
  }

  @override
  String rowNextDose(String slot) {
    return 'ਅਗਲੀ ਖ਼ੁਰਾਕ: $slot';
  }

  @override
  String get rowSetTimes => 'ਦਵਾਈ ਸੂਚੀ ਵਿੱਚ ਕਦੋਂ ਲੈਣੀ ਹੈ ਜੋੜੋ';

  @override
  String get markTaken => 'ਲੈ ਲਈ, ਦਰਜ ਕਰੋ';

  @override
  String get markedTaken => 'ਖ਼ੁਰਾਕ ਦਰਜ ਹੋ ਗਈ';

  @override
  String get undo => 'ਵਾਪਸ ਲਓ';

  @override
  String get medicineList => 'ਦਵਾਈ ਸੂਚੀ';

  @override
  String get medicineListSubtitle => 'ਪਰਚੀਆਂ ਦੀ ਹਰ ਦਵਾਈ, ਕਦੋਂ ਲੈਣੀ ਹੈ ਸਮੇਤ।';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦਵਾਈਆਂ',
      one: '1 ਦਵਾਈ',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'ਦਵਾਈ ਜੋੜੋ';

  @override
  String get editMedicine => 'ਦਵਾਈ ਬਦਲੋ';

  @override
  String get addFromPrescription => 'ਪਰਚੀ ਦੀ ਫ਼ੋਟੋ ਤੋਂ ਜੋੜੋ';

  @override
  String get noMedicinesTitle => 'ਅਜੇ ਕੋਈ ਦਵਾਈ ਨਹੀਂ ਜੋੜੀ';

  @override
  String get noMedicinesBody =>
      'ਪਰਚੀ ਦੀ ਹਰ ਦਵਾਈ ਇੱਕ ਵਾਰ ਜੋੜੋ। ਫਿਰ ਕੋਈ ਵੀ ਪੱਤਾ ਸਕੈਨ ਕਰਕੇ ਵੇਖੋ ਕਿ ਸਹੀ ਹੈ ਜਾਂ ਨਹੀਂ।';

  @override
  String addMedicinesFirst(String name) {
    return 'ਪਹਿਲਾਂ $name ਦੀਆਂ ਦਵਾਈਆਂ ਜੋੜੋ, ਤਾਂ ਜੋ Gurtu ਉਹਨਾਂ ਨਾਲ ਮਿਲਾ ਸਕੇ।';
  }

  @override
  String get medicineName => 'ਦਵਾਈ ਦਾ ਨਾਂ';

  @override
  String get medicineNameHint => 'ਜਿਵੇਂ Metformin';

  @override
  String get alsoCalled => 'ਪੱਤੇ ‘ਤੇ ਲਿਖਿਆ ਹੋਰ ਨਾਂ';

  @override
  String get alsoCalledHint => 'ਜਿਵੇਂ Glycomet';

  @override
  String get strength => 'ਮਾਤਰਾ';

  @override
  String get strengthHint => 'ਜਿਵੇਂ 500 mg';

  @override
  String get whenToTake => 'ਕਦੋਂ ਲੈਣੀ ਹੈ';

  @override
  String get doseMorning => 'ਸਵੇਰ';

  @override
  String get doseAfternoon => 'ਦੁਪਹਿਰ';

  @override
  String get doseEvening => 'ਸ਼ਾਮ';

  @override
  String get doseNight => 'ਰਾਤ';

  @override
  String get foodAfter => 'ਖਾਣੇ ਤੋਂ ਬਾਅਦ';

  @override
  String get foodBefore => 'ਖਾਣੇ ਤੋਂ ਪਹਿਲਾਂ';

  @override
  String get foodAny => 'ਖਾਣੇ ਨਾਲ ਜਾਂ ਬਿਨਾਂ';

  @override
  String get saveMedicine => 'ਦਵਾਈ ਸੇਵ ਕਰੋ';

  @override
  String get medicineSaved => 'ਦਵਾਈ ਸੇਵ ਹੋ ਗਈ';

  @override
  String get deleteMedicine => 'ਦਵਾਈ ਮਿਟਾਓ';

  @override
  String get deleteMedicineConfirm => 'ਇਹ ਦਵਾਈ ਸੂਚੀ ਵਿੱਚੋਂ ਹਟਾਉਣੀ ਹੈ?';

  @override
  String get scanToFill => 'ਪੱਤਾ ਸਕੈਨ ਕਰਕੇ ਭਰੋ';

  @override
  String get timesNotSet => 'ਸਮਾਂ ਤੈਅ ਨਹੀਂ';

  @override
  String get takenToday => 'ਅੱਜ ਲਈਆਂ';

  @override
  String get prescriptionTitle => 'ਪਰਚੀ ਤੋਂ ਜੋੜੋ';

  @override
  String get prescriptionHint =>
      'ਛਪੀ ਹੋਈ ਪਰਚੀ ਦੀ ਸਾਫ਼ ਫ਼ੋਟੋ ਲਓ। Gurtu ਦਵਾਈਆਂ ਲੱਭੇਗਾ; ਕਿਹੜੀਆਂ ਜੋੜਨੀਆਂ ਹਨ ਤੁਸੀਂ ਚੁਣੋ।';

  @override
  String get takePhoto => 'ਫ਼ੋਟੋ ਲਓ';

  @override
  String get chooseFromGallery => 'ਗੈਲਰੀ ਤੋਂ ਚੁਣੋ';

  @override
  String get medicinesFound => 'ਲੱਭੀਆਂ ਦਵਾਈਆਂ';

  @override
  String get tickToAdd =>
      'ਜੋ ਜੋੜਨੀਆਂ ਹਨ ਉਹਨਾਂ ‘ਤੇ ਟਿਕ ਕਰੋ। ਹਰ ਨਾਂ ਅਤੇ ਸਮਾਂ ਪਰਚੀ ਨਾਲ ਮਿਲਾ ਕੇ ਵੇਖੋ।';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦਵਾਈਆਂ ਜੋੜੋ',
      one: '1 ਦਵਾਈ ਜੋੜੋ',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'ਕੋਈ ਦਵਾਈ ਨਹੀਂ ਲੱਭੀ। ਸਾਫ਼ ਫ਼ੋਟੋ ਲਓ, ਜਾਂ ਹੱਥ ਨਾਲ ਜੋੜੋ।';

  @override
  String get handwrittenNote =>
      'ਹੱਥ ਨਾਲ ਲਿਖੀਆਂ ਪਰਚੀਆਂ ਠੀਕ ਨਹੀਂ ਪੜ੍ਹੀਆਂ ਜਾਂਦੀਆਂ। ਹਰ ਨਾਂ ਜਾਂਚੋ।';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦਵਾਈਆਂ ਜੋੜੀਆਂ ਗਈਆਂ',
      one: '1 ਦਵਾਈ ਜੋੜੀ ਗਈ',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'ਵੇਖ ਲਓ ਕਿ ਪੱਤੇ ‘ਤੇ $strength ਲਿਖਿਆ ਹੈ';
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
  String get addPhoto => 'ਫ਼ੋਟੋ ਜੋੜੋ';

  @override
  String get recordVoiceNote => 'ਆਵਾਜ਼ ਨੋਟ ਰਿਕਾਰਡ ਕਰੋ';

  @override
  String get voiceNote => 'ਆਵਾਜ਼ ਨੋਟ';

  @override
  String get recordingNow => 'ਰਿਕਾਰਡ ਹੋ ਰਿਹਾ ਹੈ…';

  @override
  String get stopAndSave => 'ਰੋਕੋ ਅਤੇ ਸੇਵ ਕਰੋ';

  @override
  String get removeAttachmentTitle => 'ਕੀ ਇਸਨੂੰ ਹਟਾਉਣਾ ਹੈ?';

  @override
  String get removeAttachmentBody => 'ਇਹ ਇਸ ਫ਼ੋਨ ਤੋਂ ਮਿਟ ਜਾਵੇਗਾ।';

  @override
  String get attachFailed =>
      'ਇਹ ਜੋੜਿਆ ਨਹੀਂ ਜਾ ਸਕਿਆ। ਕਿਰਪਾ ਕਰਕੇ ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get attachHintMedicines =>
      'ਪਰਚੀ ਦੀ ਫ਼ੋਟੋ ਜੋੜੋ, ਜਾਂ ਦਵਾਈਆਂ ਬਾਰੇ ਡਾਕਟਰ ਨੇ ਜੋ ਕਿਹਾ ਉਹ ਰਿਕਾਰਡ ਕਰੋ।';

  @override
  String get attachHintTests =>
      'ਟੈਸਟ ਦੀ ਪਰਚੀ ਜਾਂ ਰਿਪੋਰਟ ਦੀ ਫ਼ੋਟੋ ਜੋੜੋ, ਜਾਂ ਡਾਕਟਰ ਨੇ ਜੋ ਕਿਹਾ ਉਹ ਰਿਕਾਰਡ ਕਰੋ।';

  @override
  String get attachHintNextVisit =>
      'ਅਪੌਇੰਟਮੈਂਟ ਕਾਰਡ ਦੀ ਫ਼ੋਟੋ ਜੋੜੋ, ਜਾਂ ਅਗਲੀ ਮੁਲਾਕਾਤ ਬਾਰੇ ਡਾਕਟਰ ਨੇ ਜੋ ਕਿਹਾ ਉਹ ਰਿਕਾਰਡ ਕਰੋ।';

  @override
  String get play => 'ਚਲਾਓ';

  @override
  String get pause => 'ਰੋਕੋ';

  @override
  String get viewPhoto => 'ਫ਼ੋਟੋ ਵੇਖੋ';

  @override
  String get doctorSpeaks => 'ਡਾਕਟਰ ਜਿਸ ਭਾਸ਼ਾ ਵਿੱਚ ਬੋਲਦੇ ਹਨ';

  @override
  String listeningIn(String language) {
    return 'ਸੁਣ ਰਹੇ ਹਾਂ · $language';
  }

  @override
  String get liveCaptionHint => 'ਸੁਣ ਰਹੇ ਹਾਂ… ਡਾਕਟਰ ਦੀਆਂ ਗੱਲਾਂ ਇੱਥੇ ਦਿਖਣਗੀਆਂ।';

  @override
  String get transcriptHelp =>
      'ਹਰ ਵਾਕ ਸੁਣਦੇ ਹੀ ਇੱਥੇ ਜੁੜ ਜਾਂਦਾ ਹੈ। ਤੁਸੀਂ ਕੋਈ ਵੀ ਸ਼ਬਦ ਠੀਕ ਕਰ ਸਕਦੇ ਹੋ।';

  @override
  String voiceLanguageMissing(String language) {
    return 'ਇਸ ਫ਼ੋਨ \'ਤੇ $language ਵੌਇਸ ਟਾਈਪਿੰਗ ਸੈੱਟ ਨਹੀਂ ਹੈ। ਕੋਈ ਹੋਰ ਭਾਸ਼ਾ ਚੁਣੋ, ਜਾਂ ਫ਼ੋਨ ਦੀਆਂ ਵੌਇਸ ਟਾਈਪਿੰਗ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਇਸਨੂੰ ਜੋੜੋ।';
  }

  @override
  String get voiceNeedsInternet =>
      'ਵੌਇਸ ਟਾਈਪਿੰਗ ਲਈ ਇੰਟਰਨੈੱਟ ਚਾਹੀਦਾ ਹੈ। ਤੁਸੀਂ ਟਾਈਪ ਵੀ ਕਰ ਸਕਦੇ ਹੋ।';

  @override
  String get voiceWaitingInternet =>
      'ਇੰਟਰਨੈੱਟ ਨਹੀਂ ਹੈ। ਕੋਸ਼ਿਸ਼ ਜਾਰੀ ਹੈ — ਹੁਣ ਤੱਕ ਸੁਣਿਆ ਗੁਆਚੇਗਾ ਨਹੀਂ।';

  @override
  String medicineNumber(int number) {
    return 'ਦਵਾਈ $number';
  }

  @override
  String get addAnotherMedicine => 'ਇੱਕ ਹੋਰ ਦਵਾਈ ਜੋੜੋ';

  @override
  String get medicinesVisitHint =>
      'ਡਾਕਟਰ ਵੱਲੋਂ ਦਿੱਤੀ ਹਰ ਦਵਾਈ ਜੋੜੋ। ਪੱਤੇ ਜਾਂ ਪਰਚੀ ਦੀ ਫ਼ੋਟੋ ਲਓ, ਡਾਕਟਰ ਨੇ ਉਸ ਬਾਰੇ ਜੋ ਕਿਹਾ ਉਹ ਰਿਕਾਰਡ ਕਰੋ, ਜਾਂ ਟਾਈਪ ਕਰੋ।';

  @override
  String get removeMedicineBody =>
      'ਇਸ ਦੀਆਂ ਫ਼ੋਟੋਆਂ ਅਤੇ ਵੌਇਸ ਨੋਟ ਵੀ ਇਸ ਫ਼ੋਨ ਤੋਂ ਮਿਟ ਜਾਣਗੇ।';

  @override
  String get questionRemoved => 'ਸਵਾਲ ਹਟਾ ਦਿੱਤਾ';

  @override
  String get recordDoctor => 'ਡਾਕਟਰ ਦੀ ਆਵਾਜ਼ ਰਿਕਾਰਡ ਕਰੋ';

  @override
  String get doctorRecordings => 'ਰਿਕਾਰਡਿੰਗਾਂ';

  @override
  String recordingNumber(int number) {
    return 'ਰਿਕਾਰਡਿੰਗ $number';
  }

  @override
  String get recordOrListenHint =>
      'ਸੁਣੋ ਦਬਾਉਣ ਨਾਲ ਡਾਕਟਰ ਦੀਆਂ ਗੱਲਾਂ ਲਿਖੀਆਂ ਜਾਂਦੀਆਂ ਹਨ। ਰਿਕਾਰਡ ਦਬਾਉਣ ਨਾਲ ਉਨ੍ਹਾਂ ਦੀ ਆਵਾਜ਼ ਬਾਅਦ ਵਿੱਚ ਸੁਣਨ ਲਈ ਰਹਿੰਦੀ ਹੈ। ਫ਼ੋਨ ਦਾ ਮਾਈਕ ਇੱਕ ਸਮੇਂ ਇੱਕੋ ਕੰਮ ਕਰਦਾ ਹੈ।';

  @override
  String get tomorrow => 'ਕੱਲ੍ਹ';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦਿਨਾਂ ਵਿੱਚ',
      one: '1 ਦਿਨ ਵਿੱਚ',
    );
    return '$_temp0';
  }

  @override
  String withDoctor(String doctor) {
    return '$doctor ਨਾਲ';
  }

  @override
  String recordingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਰਿਕਾਰਡਿੰਗਾਂ',
      one: '1 ਰਿਕਾਰਡਿੰਗ',
    );
    return '$_temp0';
  }

  @override
  String photosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਫ਼ੋਟੋਆਂ',
      one: '1 ਫ਼ੋਟੋ',
    );
    return '$_temp0';
  }

  @override
  String get noNextVisitHint =>
      'ਜੇ ਡਾਕਟਰ ਦੁਬਾਰਾ ਆਉਣ ਦੀ ਤਾਰੀਖ ਦੇਣ, ਤਾਂ ਮੁਲਾਕਾਤ ਰਿਕਾਰਡ ਕਰਦੇ ਸਮੇਂ ਉਹ ਜੋੜੋ। ਉਹ ਇੱਥੇ ਦਿਖੇਗੀ।';

  @override
  String circleSubtitle(String name) {
    return '$name ਦੀ ਦੇਖਭਾਲ ਕਰਨ ਵਾਲੇ ਸਾਰੇ, ਇਕੱਠੇ।';
  }

  @override
  String get familyCode => 'ਪਰਿਵਾਰ ਕੋਡ';

  @override
  String familyCodeHint(String name) {
    return 'ਇਹ ਕੋਡ ਭੇਜੋ। ਪਰਿਵਾਰ ਅਤੇ ਮਦਦਗਾਰ ਇਸਨੂੰ Gurtu ਵਿੱਚ ਲਿਖ ਕੇ $name ਦੇ ਘੇਰੇ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋ ਸਕਦੇ ਹਨ।';
  }

  @override
  String get copyCode => 'ਕੋਡ ਕਾਪੀ ਕਰੋ';

  @override
  String get codeCopied => 'ਕੋਡ ਕਾਪੀ ਹੋ ਗਿਆ';

  @override
  String get newCode => 'ਨਵਾਂ ਕੋਡ ਬਣਾਓ';

  @override
  String get newCodeTitle => 'ਨਵਾਂ ਕੋਡ ਬਣਾਉਣਾ ਹੈ?';

  @override
  String get newCodeBody =>
      'ਪੁਰਾਣਾ ਕੋਡ ਕੰਮ ਨਹੀਂ ਕਰੇਗਾ। ਜੋ ਪਹਿਲਾਂ ਹੀ ਘੇਰੇ ਵਿੱਚ ਹਨ, ਉਹ ਰਹਿਣਗੇ।';

  @override
  String get circleMembers => 'ਘੇਰੇ ਦੇ ਲੋਕ';

  @override
  String get circleOwner => 'ਘੇਰਾ ਸ਼ੁਰੂ ਕੀਤਾ';

  @override
  String get getsReminders => 'ਰਿਮਾਈਂਡਰ ਮਿਲਦੇ ਹਨ';

  @override
  String get noNotifications => 'ਸੂਚਨਾਵਾਂ ਬੰਦ';

  @override
  String get notOnApp => 'ਐਪ \'ਤੇ ਨਹੀਂ';

  @override
  String get sendTestNotification => 'ਟੈਸਟ ਸੂਚਨਾ ਭੇਜੋ';

  @override
  String testSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਫ਼ੋਨਾਂ \'ਤੇ ਭੇਜੀ',
      one: '1 ਫ਼ੋਨ \'ਤੇ ਭੇਜੀ',
      zero: 'ਹਾਲੇ ਕਿਸੇ ਫ਼ੋਨ ਤੱਕ ਨਹੀਂ ਪਹੁੰਚੀ',
    );
    return '$_temp0';
  }

  @override
  String get testTitle => 'Gurtu ਵੱਲੋਂ ਟੈਸਟ';

  @override
  String testBody(String name) {
    return '$name ਦੇ ਦੇਖਭਾਲ ਘੇਰੇ ਲਈ ਸੂਚਨਾਵਾਂ ਕੰਮ ਕਰ ਰਹੀਆਂ ਹਨ।';
  }

  @override
  String get settingUpCode => 'ਤੁਹਾਡਾ ਪਰਿਵਾਰ ਕੋਡ ਬਣ ਰਿਹਾ ਹੈ…';

  @override
  String get offlineTitle => 'Gurtu ਸਰਵਰ ਤੱਕ ਨਹੀਂ ਪਹੁੰਚ ਸਕੇ';

  @override
  String get offlineBody =>
      'ਸਭ ਕੁਝ ਇਸ ਫ਼ੋਨ \'ਤੇ ਸੁਰੱਖਿਅਤ ਹੈ। ਇੰਟਰਨੈੱਟ ਮਿਲਦੇ ਹੀ ਪਰਿਵਾਰ ਕੋਡ ਦਿਖੇਗਾ।';

  @override
  String get tryAgain => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get haveFamilyCode => 'ਮੇਰੇ ਕੋਲ ਪਰਿਵਾਰ ਕੋਡ ਹੈ';

  @override
  String get joinTitle => 'ਦੇਖਭਾਲ ਘੇਰੇ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get joinSubtitle =>
      'ਤੁਹਾਡੇ ਪਰਿਵਾਰ ਵਿੱਚੋਂ ਕਿਸੇ ਵੱਲੋਂ ਭੇਜਿਆ 6 ਅੰਕਾਂ ਦਾ ਕੋਡ ਲਿਖੋ।';

  @override
  String get howHelping => 'ਤੁਸੀਂ ਕਿਵੇਂ ਮਦਦ ਕਰ ਰਹੇ ਹੋ?';

  @override
  String get joinButton => 'ਘੇਰੇ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get invalidCode =>
      'ਇਹ ਕੋਡ ਕਿਸੇ ਪਰਿਵਾਰ ਨਾਲ ਮੇਲ ਨਹੀਂ ਖਾਂਦਾ। ਅੰਕ ਜਾਂਚ ਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get tooManyTries =>
      'ਬਹੁਤ ਵਾਰ ਕੋਸ਼ਿਸ਼ ਹੋਈ। ਕੁਝ ਮਿੰਟ ਰੁਕ ਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get connectionFailed =>
      'ਕਨੈਕਟ ਨਹੀਂ ਹੋਇਆ। ਇੰਟਰਨੈੱਟ ਜਾਂਚ ਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get somethingWrong => 'ਕੁਝ ਗਲਤ ਹੋ ਗਿਆ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String joinedCircle(String name) {
    return 'ਤੁਸੀਂ $name ਦੇ ਦੇਖਭਾਲ ਘੇਰੇ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋ ਗਏ';
  }

  @override
  String get peopleYouCareFor => 'ਜਿਨ੍ਹਾਂ ਦੀ ਤੁਸੀਂ ਦੇਖਭਾਲ ਕਰਦੇ ਹੋ';

  @override
  String get addPersonTitle => 'ਦੇਖਭਾਲ ਲਈ ਕਿਸੇ ਨੂੰ ਜੋੜੋ';

  @override
  String get setUpNew => 'ਕਿਸੇ ਨਵੇਂ ਲਈ ਸੈੱਟ ਕਰੋ';

  @override
  String get setUpNewHint =>
      'ਉਨ੍ਹਾਂ ਬਾਰੇ ਕੁਝ ਸਵਾਲਾਂ ਦੇ ਜਵਾਬ ਦਿਓ। ਉਨ੍ਹਾਂ ਨੂੰ ਆਪਣਾ ਪਰਿਵਾਰ ਕੋਡ ਮਿਲੇਗਾ।';

  @override
  String get joinWithCode => 'ਪਰਿਵਾਰ ਕੋਡ ਨਾਲ ਜੁੜੋ';

  @override
  String get joinWithCodeHint =>
      'ਪਰਿਵਾਰ ਵਿੱਚ ਕਿਸੇ ਨੇ ਉਨ੍ਹਾਂ ਲਈ ਪਹਿਲਾਂ ਹੀ Gurtu ਸੈੱਟ ਕੀਤਾ ਹੈ।';

  @override
  String get yourCare => 'ਤੁਹਾਡੀ ਦੇਖਭਾਲ';

  @override
  String get lookingAfterYou => 'ਤੁਹਾਡਾ ਧਿਆਨ ਰੱਖਣ ਵਾਲੇ';

  @override
  String lookingAfterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਲੋਕ ਤੁਹਾਡਾ ਧਿਆਨ ਰੱਖਦੇ ਹਨ',
      one: '1 ਵਿਅਕਤੀ ਤੁਹਾਡਾ ਧਿਆਨ ਰੱਖਦਾ ਹੈ',
      zero: 'ਹਾਲੇ ਕੋਈ ਨਹੀਂ',
    );
    return '$_temp0';
  }

  @override
  String get inviteFamily => 'ਆਪਣੇ ਪਰਿਵਾਰ ਨੂੰ ਸੱਦੋ';

  @override
  String get inviteFamilyHint =>
      'ਆਪਣਾ ਪਰਿਵਾਰ ਕੋਡ ਭੇਜੋ। ਉਹ ਤੁਹਾਡੀ ਦੇਖਭਾਲ ਦੇਖ ਸਕਣਗੇ ਅਤੇ ਤੁਹਾਡੇ ਰਿਮਾਈਂਡਰ ਲੈਣਗੇ।';

  @override
  String get askForHelp => 'ਪਰਿਵਾਰ ਤੋਂ ਮਦਦ ਮੰਗੋ';

  @override
  String get askForHelpTitle => 'ਪਰਿਵਾਰ ਨੂੰ ਸੁਨੇਹਾ ਭੇਜਣਾ ਹੈ?';

  @override
  String get askForHelpBody =>
      'ਤੁਹਾਡੇ ਦੇਖਭਾਲ ਘੇਰੇ ਵਿੱਚ ਸਾਰਿਆਂ ਨੂੰ ਤੁਹਾਨੂੰ ਫ਼ੋਨ ਕਰਨ ਜਾਂ ਹਾਲ ਪੁੱਛਣ ਦੀ ਸੂਚਨਾ ਮਿਲੇਗੀ।';

  @override
  String get send => 'ਭੇਜੋ';

  @override
  String helpSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਲੋਕਾਂ ਨੂੰ ਭੇਜਿਆ',
      one: '1 ਵਿਅਕਤੀ ਨੂੰ ਭੇਜਿਆ',
      zero: 'ਹਾਲੇ ਕਿਸੇ ਤੱਕ ਨਹੀਂ ਪਹੁੰਚਿਆ',
    );
    return '$_temp0';
  }

  @override
  String get circleSubtitleSelf => 'ਤੁਹਾਡਾ ਧਿਆਨ ਰੱਖਣ ਵਾਲੇ ਲੋਕ।';

  @override
  String get iAmPatient => 'ਜਿਸ ਦੀ ਦੇਖਭਾਲ ਹੋ ਰਹੀ ਹੈ, ਉਹ ਮੈਂ ਹਾਂ';

  @override
  String get patientTaken =>
      'ਦੇਖਭਾਲ ਲੈਣ ਵਾਲੇ ਵਜੋਂ ਕੋਈ ਪਹਿਲਾਂ ਹੀ ਜੁੜ ਚੁੱਕਾ ਹੈ। ਕੋਈ ਹੋਰ ਭੂਮਿਕਾ ਚੁਣੋ।';

  @override
  String get medRemindersTitle => 'ਦਵਾਈ ਦੇ ਰਿਮਾਈਂਡਰ';

  @override
  String medRemindersIntro(String name) {
    return 'Gurtu ਨੇ $name ਲਈ ਡਾਕਟਰ ਦੀਆਂ ਗੱਲਾਂ ਪੜ੍ਹੀਆਂ। ਹਰ ਸਮਾਂ ਜਾਂਚੋ, ਫਿਰ ਰਿਮਾਈਂਡਰ ਚਾਲੂ ਕਰੋ।';
  }

  @override
  String get readingMedicines => 'ਦਵਾਈਆਂ ਪੜ੍ਹ ਰਹੇ ਹਾਂ…';

  @override
  String get readByAi => 'Gurtu AI ਨੇ ਪੜ੍ਹਿਆ';

  @override
  String get readByRules => 'ਤੁਹਾਡੇ ਨੋਟਾਂ ਤੋਂ ਪੜ੍ਹਿਆ';

  @override
  String get pickTimes => 'ਕਦੋਂ ਲੈਣੀ ਹੈ ਚੁਣੋ';

  @override
  String get everyDay => 'ਹਰ ਰੋਜ਼';

  @override
  String forDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦਿਨਾਂ ਲਈ',
      one: '1 ਦਿਨ ਲਈ',
    );
    return '$_temp0';
  }

  @override
  String get howLong => 'ਕਿੰਨੇ ਦਿਨ';

  @override
  String get turnOnReminders => 'ਰਿਮਾਈਂਡਰ ਚਾਲੂ ਕਰੋ';

  @override
  String remindersSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਰਿਮਾਈਂਡਰ ਚਾਲੂ ਹਨ',
      one: '1 ਰਿਮਾਈਂਡਰ ਚਾਲੂ ਹੈ',
    );
    return '$_temp0';
  }

  @override
  String remindersGoToPatient(String name) {
    return 'ਰਿਮਾਈਂਡਰ $name ਦੇ ਫ਼ੋਨ \'ਤੇ ਜਾਣਗੇ। ਜੇ ਲਈ ਗਈ ਨਾ ਦੱਸੀ ਗਈ, ਤਾਂ Gurtu ਦੋ ਵਾਰ ਹੋਰ ਯਾਦ ਕਰਾਏਗਾ, ਫਿਰ ਪਰਿਵਾਰ ਨੂੰ ਦੱਸੇਗਾ।';
  }

  @override
  String remindersGoToFamily(String name) {
    return '$name Gurtu ਨਹੀਂ ਵਰਤਦੇ, ਇਸ ਲਈ ਰਿਮਾਈਂਡਰ ਪਰਿਵਾਰ ਦੇ ਫ਼ੋਨਾਂ \'ਤੇ ਜਾਣਗੇ। ਜੇ ਲਈ ਗਈ ਨਾ ਦੱਸੀ ਗਈ, ਤਾਂ Gurtu ਦੋ ਵਾਰ ਹੋਰ ਯਾਦ ਕਰਾਏਗਾ, ਫਿਰ ਸਾਰਿਆਂ ਨੂੰ ਦੱਸੇਗਾ।';
  }

  @override
  String get remindersPending =>
      'ਇਸ ਫ਼ੋਨ \'ਤੇ ਸੰਭਾਲਿਆ। ਇੰਟਰਨੈੱਟ ਮਿਲਦੇ ਹੀ ਰਿਮਾਈਂਡਰ ਚਾਲੂ ਹੋ ਜਾਣਗੇ।';

  @override
  String get setUpReminders => 'ਰਿਮਾਈਂਡਰ ਸੈੱਟ ਕਰੋ';

  @override
  String get changeReminders => 'ਰਿਮਾਈਂਡਰ ਬਦਲੋ';

  @override
  String get takenIt => 'ਮੈਂ ਲੈ ਲਈ';

  @override
  String get skipDose => 'ਇਸ ਵਾਰ ਛੱਡੋ';

  @override
  String dueAt(String time) {
    return '$time ਵਜੇ ਲੈਣੀ ਹੈ';
  }

  @override
  String get readAloud => 'ਪੜ੍ਹ ਕੇ ਸੁਣਾਓ';

  @override
  String get missedDoseEyebrow => 'ਖੁੰਝੀ ਖੁਰਾਕ';

  @override
  String get markTakenForThem => 'ਲਈ ਗਈ ਵਜੋਂ ਮਾਰਕ ਕਰੋ';

  @override
  String get illCheck => 'ਮੈਂ ਹਾਲ ਪੁੱਛਦਾ ਹਾਂ';

  @override
  String get doseTakenThanks => 'ਲਈ ਗਈ ਵਜੋਂ ਮਾਰਕ ਹੋ ਗਈ। ਬਹੁਤ ਵਧੀਆ!';

  @override
  String get noReminderForThis => 'ਕੋਈ ਰਿਮਾਈਂਡਰ ਨਹੀਂ';

  @override
  String get reminderEyebrow => 'ਦਵਾਈ ਦਾ ਰਿਮਾਈਂਡਰ';
}
