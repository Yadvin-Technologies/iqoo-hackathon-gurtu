// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get continueLabel => 'தொடரவும்';

  @override
  String get next => 'அடுத்து';

  @override
  String get skip => 'தவிர்';

  @override
  String get later => 'பின்னர்';

  @override
  String get back => 'பின்செல்';

  @override
  String get optional => 'விருப்பம்';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get notSure => 'தெரியவில்லை';

  @override
  String get tagline => 'நினைவில் கொள். கவனி. ஒன்றாக.';

  @override
  String get motherName => 'அம்மா';

  @override
  String get phaseAbout => 'அறிமுகம்';

  @override
  String get phaseHealth => 'உடல்நலம்';

  @override
  String get phasePermissions => 'அனுமதிகள்';

  @override
  String get phaseAi => 'AI அமைப்பு';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $total-இல் $current';
  }

  @override
  String get languageTitle => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get languageSubtitle =>
      'Gurtu இந்த மொழியில் பேசும், கேட்கும், எழுதும்.';

  @override
  String get languageMixNote =>
      'மருத்துவர்கள் அடிக்கடி உங்கள் மொழியுடன் ஆங்கிலம் கலந்து பேசுவார்கள். Gurtu இரண்டையும் சேர்த்துப் புரிந்துகொள்ளும்.';

  @override
  String get welcomeTitle => 'உங்கள் குடும்பத்தின்\nபராமரிப்பு நினைவு';

  @override
  String get welcomeBody =>
      'மருத்துவர் என்ன சொன்னார், என்ன மருந்து எழுதினார், வீட்டில் என்ன நடந்தது — எல்லாவற்றையும் ஒன்றாக நினைவில் வையுங்கள்.';

  @override
  String get welcomeScript => 'வெவ்வேறு பங்குகள். அதே அன்பு.';

  @override
  String get getStarted => 'தொடங்குங்கள்';

  @override
  String builtForBrand(String brand) {
    return '$brand-க்காக உருவாக்கப்பட்டது';
  }

  @override
  String get madeInHyderabad => 'ஹைதராபாத்தில் உருவானது';

  @override
  String get introRecordEyebrow => '1 · பதிவு';

  @override
  String get introRecordTitle => 'மருத்துவர் சொன்னதை ஒருபோதும் மறக்காதீர்கள்';

  @override
  String get introRecordBody =>
      'அனைவரின் சம்மதத்துடன் மருத்துவர், செவிலியர் அல்லது மருந்தாளரின் பேச்சைப் பதிவு செய்யுங்கள். முக்கியமானவற்றை Gurtu பாதுகாக்கும்.';

  @override
  String get introPlanEyebrow => '2 · புரிந்து பகிருங்கள்';

  @override
  String get introPlanTitle =>
      'முழுக் குடும்பத்துக்கும் ஒரே பராமரிப்புத் திட்டம்';

  @override
  String get introPlanBody =>
      'மருந்துச் சீட்டுகளையும் அறிக்கைகளையும் ஸ்கேன் செய்யுங்கள். குடும்பம் பகிரக்கூடிய எளிய பணிகளாக Gurtu மாற்றும்.';

  @override
  String get introAskEyebrow => '3 · கேளுங்கள், நினைவில் வையுங்கள்';

  @override
  String get introAskTitle => 'எதையும் கேளுங்கள், ஆதாரத்தைப் பாருங்கள்';

  @override
  String get introAskBody =>
      'ஒவ்வொரு பதிலும் எங்கிருந்து வந்தது என்று காட்டும் — பதிவு, மருந்துச் சீட்டு அல்லது புகைப்படம்.';

  @override
  String get letsSetUp => 'அமைப்போம்';

  @override
  String get hospitalMode => 'மருத்துவமனை பயன்முறை';

  @override
  String get consentRecording => 'அங்குள்ள அனைவரின் சம்மதத்துடன் பதிவு';

  @override
  String get doctorConversation => 'மருத்துவருடன் உரையாடல்';

  @override
  String get nurseInstructions => 'செவிலியர் அறிவுரைகள்';

  @override
  String get pharmacistAdvice => 'மருந்தாளர் ஆலோசனை';

  @override
  String get yourCarePlan => 'உங்கள் பராமரிப்புத் திட்டம்';

  @override
  String get afterBreakfast => 'காலை உணவுக்குப் பின்';

  @override
  String get checkBloodPressure => 'BP பார்க்கவும்';

  @override
  String get twiceDaily => 'தினமும் இருமுறை';

  @override
  String get bloodTest => 'இரத்தப் பரிசோதனை (CBC)';

  @override
  String get instructionsFound =>
      'உங்கள் பதிவுகளிலும் மருந்துச் சீட்டிலும் 4 அறிவுரைகள் கிடைத்தன';

  @override
  String get askQuestion => 'மாலை மருந்து பற்றி மருத்துவர் என்ன சொன்னார்?';

  @override
  String get askAnswer =>
      'Amlodipine-ஐ இரவு உணவுக்குப் பின் எடுக்கச் சொன்னார் மருத்துவர்.';

  @override
  String get sourceDoctorVisit => 'ஆதாரம்: மருத்துவர் சந்திப்பு';

  @override
  String get careForTitle => 'Gurtu-வை யாருக்காக அமைக்கிறீர்கள்?';

  @override
  String get careForSubtitle =>
      'Gurtu ஒருவரைச் சுற்றி பராமரிப்பு நினைவை உருவாக்கும். மற்ற குடும்பத்தினரைப் பின்னர் அழைக்கலாம்.';

  @override
  String get careForMyself => 'எனக்காக';

  @override
  String get careForMyselfHint => 'என் சொந்தப் பராமரிப்பைக் கவனிக்க';

  @override
  String get careForParent => 'என் பெற்றோர்';

  @override
  String get careForParentHint => 'அம்மா, அப்பா அல்லது குடும்பப் பெரியவர்';

  @override
  String get careForPartner => 'என் வாழ்க்கைத் துணை';

  @override
  String get careForPartnerHint => 'கணவர், மனைவி அல்லது துணை';

  @override
  String get careForChild => 'என் குழந்தை';

  @override
  String get careForChildHint => 'மகன் அல்லது மகள்';

  @override
  String get careForOther => 'வேறு ஒருவர்';

  @override
  String get careForOtherHint => 'உறவினர், நண்பர் அல்லது அண்டை வீட்டார்';

  @override
  String get profileTitleSelf => 'உங்களைப் பற்றிச் சொல்லுங்கள்';

  @override
  String get profileTitleOther => 'அவரைப் பற்றிச் சொல்லுங்கள்';

  @override
  String get profileSubtitleSelf =>
      'இதனால் Gurtu உங்களைப் பெயர் சொல்லி அழைக்கும்.';

  @override
  String get profileSubtitleOther =>
      'வீட்டில் நீங்கள் அவரை அழைக்கும் பெயரை எழுதுங்கள்.';

  @override
  String get yourName => 'உங்கள் பெயர்';

  @override
  String get whatDoYouCallThem => 'நீங்கள் அவரை எப்படி அழைப்பீர்கள்?';

  @override
  String exampleName(String name) {
    return 'எ.கா. $name';
  }

  @override
  String get sampleSelfName => 'லட்சுமி';

  @override
  String get sampleYourName => 'பிரியா';

  @override
  String get yourAge => 'உங்கள் வயது';

  @override
  String get theirAge => 'அவரது வயது';

  @override
  String get years => 'வயது';

  @override
  String get decreaseAge => 'வயதைக் குறை';

  @override
  String get increaseAge => 'வயதைக் கூட்டு';

  @override
  String get gender => 'பாலினம்';

  @override
  String get female => 'பெண்';

  @override
  String get male => 'ஆண்';

  @override
  String get genderOther => 'மற்றவை';

  @override
  String get andYou => 'நீங்கள்?';

  @override
  String get andYouBody =>
      'அவரது பராமரிப்பு வட்டத்தின் முதல் உறுப்பினர் நீங்கள்தான்.';

  @override
  String get conditionsTitleSelf =>
      'இவற்றில் ஏதேனும் உடல்நலப் பிரச்சினை உங்களுக்கு உள்ளதா?';

  @override
  String conditionsTitleOther(String name) {
    return 'இவற்றில் ஏதேனும் உடல்நலப் பிரச்சினை $name-க்கு உள்ளதா?';
  }

  @override
  String get conditionsSubtitle =>
      'பொருந்துபவை அனைத்தையும் தேர்ந்தெடுக்கவும். இது பராமரிப்புத் திட்டத்தை ஒழுங்குபடுத்த உதவும்.';

  @override
  String get condDiabetes => 'சர்க்கரை (நீரிழிவு)';

  @override
  String get condHighBp => 'உயர் BP';

  @override
  String get condHeart => 'இதயப் பிரச்சினை';

  @override
  String get condThyroid => 'தைராய்டு';

  @override
  String get condCholesterol => 'கொலஸ்ட்ரால்';

  @override
  String get condAsthma => 'ஆஸ்துமா / மூச்சுத் திணறல்';

  @override
  String get condKidney => 'சிறுநீரகப் பிரச்சினை';

  @override
  String get condArthritis => 'மூட்டு வலி / கீல்வாதம்';

  @override
  String get condStroke => 'முன்பு பக்கவாதம்';

  @override
  String get condCancer => 'புற்றுநோய் சிகிச்சை';

  @override
  String get noneOfThese => 'இவற்றில் எதுவும் இல்லை';

  @override
  String get notADoctor =>
      'Gurtu மருத்துவர் அல்ல. இது ஒருபோதும் நோயறிதல் செய்யாது — குடும்பம் பராமரிப்பை நினைவில் வைக்கவும் ஒழுங்குபடுத்தவும் மட்டுமே உதவும்.';

  @override
  String get medicinesTitleSelf => 'நீங்கள் தினமும் மருந்து எடுக்கிறீர்களா?';

  @override
  String medicinesTitleOther(String name) {
    return '$name தினமும் மருந்து எடுக்கிறாரா?';
  }

  @override
  String get medicinesSubtitle =>
      'மாத்திரைகள், சிரப், இன்ஹேலர் அல்லது இன்சுலின் அனைத்தும் சேர்த்து.';

  @override
  String get howMany => 'சுமார் எத்தனை?';

  @override
  String get sixOrMore => '6 அல்லது அதிகம்';

  @override
  String get scanLaterTip =>
      'பின்னர் மருந்துச் சீட்டு அல்லது மாத்திரை அட்டையை ஸ்கேன் செய்தால் போதும் — தட்டச்சு தேவையில்லை.';

  @override
  String get allergiesTitleSelf => 'உங்களுக்கு ஏதேனும் ஒவ்வாமை உள்ளதா?';

  @override
  String allergiesTitleOther(String name) {
    return '$name-க்கு ஏதேனும் ஒவ்வாமை உள்ளதா?';
  }

  @override
  String get allergiesSubtitle =>
      'இது தவறாமல் இருக்க Gurtu ஒவ்வொரு மருத்துவர் சுருக்கத்திலும் காட்டும்.';

  @override
  String get allergyNone => 'தெரிந்த ஒவ்வாமை இல்லை';

  @override
  String get allergyPenicillin => 'பெனிசிலின்';

  @override
  String get allergySulfa => 'சல்ஃபா மருந்துகள்';

  @override
  String get allergyAspirin => 'ஆஸ்பிரின் / வலி நிவாரணிகள்';

  @override
  String get allergyFood => 'உணவு ஒவ்வாமை';

  @override
  String get allergyDust => 'தூசி / மகரந்தம்';

  @override
  String get allergyLatex => 'லேடெக்ஸ்';

  @override
  String get mobilityTitleSelf => 'தினமும் நீங்கள் எப்படி நடமாடுகிறீர்கள்?';

  @override
  String mobilityTitleOther(String name) {
    return 'தினமும் $name எப்படி நடமாடுகிறார்?';
  }

  @override
  String get mobilitySubtitle =>
      'இது குடும்பம் வருகைகள், பரிசோதனைகள், வீட்டு உதவியைத் திட்டமிட உதவும்.';

  @override
  String get mobilityIndependent => 'தானே நடப்பார்';

  @override
  String get mobilityIndependentHint => 'அன்றாடம் உதவி தேவையில்லை';

  @override
  String get mobilitySomeHelp => 'கொஞ்சம் உதவி தேவை';

  @override
  String get mobilitySomeHelpHint =>
      'கைத்தடி, வாக்கர் அல்லது பிடித்துக்கொள்ள ஒரு கை';

  @override
  String get mobilityFullHelp =>
      'பெரும்பாலும் படுக்கை அல்லது சக்கர நாற்காலியில்';

  @override
  String get mobilityFullHelpHint => 'பெரும்பாலான செயல்களுக்கு உதவி தேவை';

  @override
  String get hospitalTitleSelf =>
      'கடந்த 30 நாட்களில் நீங்கள் மருத்துவமனை அல்லது மருத்துவரிடம் சென்றீர்களா?';

  @override
  String hospitalTitleOther(String name) {
    return 'கடந்த 30 நாட்களில் $name மருத்துவமனை அல்லது மருத்துவரிடம் சென்றாரா?';
  }

  @override
  String get hospitalSubtitle =>
      'சமீபத்திய வருகைகளுடன் பொதுவாகப் புதிய அறிவுரைகள் வரும்.';

  @override
  String get hospitalTip =>
      'டிஸ்சார்ஜ் ஆவணங்களையும் மருந்துச் சீட்டுகளையும் கையில் வையுங்கள் — அமைப்பு முடிந்ததும் ஸ்கேன் செய்யலாம்.';

  @override
  String get permissionsTitle => 'உங்களுக்கு உதவ சில அனுமதிகள்';

  @override
  String get permissionsSubtitle =>
      'Gurtu தேவையானதை மட்டுமே கேட்கும். ஏன் என்பது இங்கே.';

  @override
  String get permMic => 'மைக்ரோஃபோன்';

  @override
  String get permMicWhy =>
      'மருத்துவர் சந்திப்புகளையும் குரல் குறிப்புகளையும் பதிவு செய்ய — நீங்கள் பதிவைத் தட்டும்போது மட்டும்.';

  @override
  String get permCamera => 'கேமரா';

  @override
  String get permCameraWhy =>
      'மருந்துச் சீட்டுகள், மாத்திரை அட்டைகள், BP இயந்திர அளவீடுகளை ஸ்கேன் செய்ய.';

  @override
  String get permNotifications => 'அறிவிப்புகள்';

  @override
  String get permNotificationsWhy =>
      'மருந்து நினைவூட்டல்கள், குடும்பம் பணி முடித்த தகவல்கள்.';

  @override
  String get permPhotos => 'புகைப்படங்கள் & கோப்புகள்';

  @override
  String get permPhotosWhy =>
      'கேலரியில் உள்ள அறிக்கைகள், மருந்துச் சீட்டுகளைச் சேர்க்க.';

  @override
  String get permContacts => 'தொடர்புகள்';

  @override
  String get permContactsWhy =>
      'குடும்பத்தினரைப் பராமரிப்பு வட்டத்துக்கு விரைவாக அழைக்க.';

  @override
  String get needed => 'தேவை';

  @override
  String get allow => 'அனுமதி';

  @override
  String get allowed => 'அனுமதிக்கப்பட்டது';

  @override
  String get allowAndContinue => 'அனுமதித்துத் தொடரவும்';

  @override
  String get privacyNote =>
      'எல்லாம் இந்த ஃபோனிலேயே இருக்கும். பதிவு தானாகத் தொடங்காது — முதலில் சம்மதத் திரை காட்டப்படும்.';

  @override
  String permissionBlocked(String permission) {
    return '$permission தடுக்கப்பட்டுள்ளது. அமைப்புகளில் இயக்கவும்.';
  }

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String permissionsMissing(String items) {
    return '$items இல்லாமல் சில அம்சங்கள் இயங்காது. பின்னர் அனுமதிக்கலாம்.';
  }

  @override
  String get modelTitleChoose => 'Gurtu-வின் சாதன AI-ஐ அமைக்கவும்';

  @override
  String get modelTitleDownloading => 'உங்கள் AI அமைக்கப்படுகிறது…';

  @override
  String get modelTitleDone => 'உங்கள் AI தயார்';

  @override
  String get modelSubtitleChoose =>
      'இந்த மாடல்கள் முழுவதும் உங்கள் iQOO-விலேயே இயங்கும். குடும்ப உடல்நலத் தகவல் ஃபோனை விட்டு வெளியே போகாது — இணையம் இல்லாமலும் இயங்கும்.';

  @override
  String get modelSubtitleDownloading =>
      'நீங்கள் ஃபோனைப் பயன்படுத்திக்கொண்டே இருக்கலாம். இது ஒருமுறை மட்டுமே.';

  @override
  String get modelSubtitleDone =>
      'எல்லாம் இந்த ஃபோனிலேயே இயங்கும், ஆஃப்லைனிலும்.';

  @override
  String get poweredByIqoo => 'உங்கள் iQOO-வின் சக்தியில்';

  @override
  String get deviceCardSub => 'சாதன AI · தனிப்பட்டது · ஆஃப்லைனில் இயங்கும்';

  @override
  String get chooseCareModel => 'பராமரிப்பு மாடலைத் தேர்ந்தெடுக்கவும்';

  @override
  String get careModelHint => 'கேள்விகளுக்குப் பதில் சொல்லும் மூளை இதுதான்.';

  @override
  String get alwaysIncluded => 'எப்போதும் சேர்க்கப்படும்';

  @override
  String get jobListens => 'கேட்கும்';

  @override
  String get jobReads => 'படிக்கும்';

  @override
  String get jobSees => 'பார்க்கும்';

  @override
  String get jobUnderstands => 'புரிந்துகொள்ளும்';

  @override
  String speechModelName(String language) {
    return 'பேச்சு · $language + ஆங்கிலம்';
  }

  @override
  String get speechModelWhat =>
      'உரையாடல்களை உங்கள் மொழியில் எழுத்தாக மாற்றும்.';

  @override
  String get readerModelName => 'ஆவண வாசிப்பான் (OCR)';

  @override
  String get readerModelWhat =>
      'மருந்துச் சீட்டுகள், டிஸ்சார்ஜ் ஆவணங்கள், ஆய்வக அறிக்கைகளைப் படிக்கும்.';

  @override
  String get visionModelName => 'மருந்து & அளவீடு அடையாளம்';

  @override
  String get visionModelWhat =>
      'மாத்திரை அட்டைகள், BP / சர்க்கரை இயந்திர எண்களை அடையாளம் காணும்.';

  @override
  String careModelName(String model) {
    return 'பராமரிப்பு மாடல் · $model';
  }

  @override
  String get tierLite => 'லைட்';

  @override
  String get tierBalanced => 'சமநிலை';

  @override
  String get tierPro => 'ப்ரோ';

  @override
  String get tierLiteNote => 'மிக வேகம். சுருக்கமான, எளிய பதில்கள்.';

  @override
  String get tierBalancedNote =>
      'குரல், புகைப்படம், உரையை ஒன்றாகப் புரிந்துகொள்ளும்.';

  @override
  String get tierProNote => 'மிக விரிவான பதில்கள், மருத்துவர் சுருக்கங்கள்.';

  @override
  String get bestForIqoo => 'iQOO-க்குச் சிறந்தது';

  @override
  String get wifiOnly => 'Wi-Fi-இல் மட்டும் பதிவிறக்கு';

  @override
  String downloadSize(String size) {
    return 'பதிவிறக்கு · $size';
  }

  @override
  String get settingUp => 'அமைக்கப்படுகிறது…';

  @override
  String get ready => 'தயார்';

  @override
  String allSetName(String name) {
    return 'எல்லாம் தயார், $name!';
  }

  @override
  String get allSet => 'எல்லாம் தயார்!';

  @override
  String get readySelf => 'உங்கள் பராமரிப்பு நினைவு தயார்.';

  @override
  String readyOther(String name) {
    return '$name-இன் பராமரிப்பு நினைவு தயார். அடுத்து, குடும்பத்தை அழையுங்கள்.';
  }

  @override
  String get rowYou => 'நீங்கள்';

  @override
  String get rowCaringFor => 'யாருக்காக';

  @override
  String get rowHealth => 'உடல்நலம்';

  @override
  String get rowAllergies => 'ஒவ்வாமைகள்';

  @override
  String get rowLanguage => 'மொழி';

  @override
  String get rowAi => 'சாதன AI';

  @override
  String get notAdded => 'சேர்க்கவில்லை';

  @override
  String ageYears(int age) {
    return '$age வயது';
  }

  @override
  String get careQuote => '“ஒன்றாகச் செய்தால் பராமரிப்பு எளிதாகும்.”';

  @override
  String get enterGurtu => 'Gurtu-க்குள் செல்';

  @override
  String get nextUpCareCircle => 'அடுத்து: பராமரிப்பு வட்டம்';

  @override
  String get homeComingSoon => 'முகப்புத் திரைகள் அடுத்த பகுதியில் வரும்.';

  @override
  String get restartOnboarding => 'அறிமுகத்தை மீண்டும் தொடங்கு';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navMemory => 'நினைவுகள்';

  @override
  String get navCircle => 'வட்டம்';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String goodMorning(String name) {
    return 'காலை வணக்கம், $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'மதிய வணக்கம், $name';
  }

  @override
  String goodEvening(String name) {
    return 'மாலை வணக்கம், $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu-க்கு வரவேற்கிறோம், $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'உங்கள் குடும்ப ஆரோக்கியம், அனைவரும் சேர்ந்து நினைவில்.';

  @override
  String get caringFor => 'பராமரிப்பு';

  @override
  String get switchPatientTitle => 'யாரைப் பராமரிக்கிறீர்கள்?';

  @override
  String get addAnotherPerson => 'இன்னொருவரைச் சேர்';

  @override
  String get statusOnTrack => 'பராமரிப்பு சரியாக நடக்கிறது';

  @override
  String get statusNeedsAttention => 'ஒன்றைக் கவனிக்க வேண்டும்';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'அவசரம்';

  @override
  String get sosHoldTitle =>
      'பராமரிப்பு வட்டத்தை எச்சரிக்க அழுத்திப் பிடிக்கவும்';

  @override
  String get sosHoldBody =>
      'பொத்தானை 2 வினாடிகள் அழுத்திப் பிடிக்கவும். உங்கள் அவசரத் தொடர்புகளுக்கு எச்சரிக்கை செல்லும்.';

  @override
  String get sosHoldButton => 'SOS அனுப்ப அழுத்திப் பிடிக்கவும்';

  @override
  String get sosKeepHolding => 'பிடித்துக்கொண்டே இருங்கள்…';

  @override
  String get sosPreviewNote =>
      'அவசர எச்சரிக்கைகள் இன்னும் இணைக்கப்படவில்லை. இது முன்னோட்டம் மட்டுமே — யாருக்கும் எச்சரிக்கை செல்லாது.';

  @override
  String get sosPreviewDone =>
      'முன்னோட்டம் முடிந்தது. யாருக்கும் எச்சரிக்கை செல்லவில்லை.';

  @override
  String get close => 'மூடு';

  @override
  String get todayCare => 'இன்றைய பராமரிப்பு';

  @override
  String completedOf(int done, int total) {
    return '$total-இல் $done முடிந்தது';
  }

  @override
  String get viewTodayCare => 'இன்றைய பராமரிப்பைப் பார்';

  @override
  String get nothingUrgent => 'இப்போது அவசரமாக எதுவும் இல்லை.';

  @override
  String get markDone => 'முடிந்ததாகக் குறி';

  @override
  String get markNotDone => 'முடியவில்லை எனக் குறி';

  @override
  String get openToCircle => 'பராமரிப்பு வட்டத்துக்குத் திறந்தது';

  @override
  String get captureCare => 'பராமரிப்பைப் பதிவு செய்';

  @override
  String get captureCareSubtitle =>
      'பராமரிப்பில் முக்கியமான ஒன்றைப் பதிவு செய்யுங்கள்.';

  @override
  String get whatHappened => 'என்ன நடந்தது?';

  @override
  String get captureVoice => 'குரல்';

  @override
  String get captureVoiceHint => 'உரையாடல் அல்லது குரல் குறிப்பைப் பதிவு செய்';

  @override
  String get captureScan => 'ஸ்கேன்';

  @override
  String get captureScanHint => 'மருந்துச் சீட்டு அல்லது மாத்திரை அட்டை';

  @override
  String get captureVital => 'அளவீடு';

  @override
  String get captureVitalHint => 'BP, சர்க்கரை அல்லது வெப்பநிலை';

  @override
  String get captureDocument => 'ஆவணம்';

  @override
  String get captureDocumentHint => 'டிஸ்சார்ஜ் ஆவணம் அல்லது ஆய்வக அறிக்கை';

  @override
  String get captureNote => 'குறிப்பு';

  @override
  String get captureNoteHint => 'என்ன நடந்தது என்று எழுதுங்கள்';

  @override
  String get comingSoon => 'விரைவில் வரும்';

  @override
  String get noteHint => 'எ.கா. நடந்த பிறகு தலைசுற்றியது';

  @override
  String get saveNote => 'குறிப்பைச் சேமி';

  @override
  String get noteSaved => 'பராமரிப்பு நினைவில் சேமிக்கப்பட்டது';

  @override
  String get recentMemory => 'சமீபத்திய நினைவுகள்';

  @override
  String get viewAll => 'அனைத்தும் பார்';

  @override
  String get emptyMemory => 'உங்கள் பராமரிப்புக் கதை இங்கே தொடங்குகிறது.';

  @override
  String addedBy(String name) {
    return '$name சேர்த்தது';
  }

  @override
  String get sourcePlay => 'கேள்';

  @override
  String get sourceView => 'பார்';

  @override
  String get sourceOpen => 'திற';

  @override
  String get sourceTitle => 'ஆதாரம்';

  @override
  String get sourceRecording => 'மருத்துவர் பதிவு';

  @override
  String get sourceScan => 'மருந்துச் சீட்டு ஸ்கேன்';

  @override
  String get sourceVital => 'அளவீடு';

  @override
  String get sourceDocument => 'ஆவணம்';

  @override
  String get sourceNote => 'எழுதிய குறிப்பு';

  @override
  String get sourceSampleNote =>
      'இது மாதிரித் தரவு, எனவே அசல் கோப்பு இல்லை. உண்மையான பதிவுகளும் ஸ்கேன்களும் இங்கே திறக்கும்.';

  @override
  String get yourCareCircle => 'உங்கள் பராமரிப்பு வட்டம்';

  @override
  String get manageCircle => 'வட்டத்தை நிர்வகி';

  @override
  String get emptyCircle => 'சேர்ந்து செய்தால் பராமரிப்பு எளிது.';

  @override
  String get addFamilyMember => 'குடும்ப உறுப்பினரைச் சேர்';

  @override
  String get rolePatient => 'நோயாளி';

  @override
  String get roleCaregiver => 'பராமரிப்பாளர்';

  @override
  String get roleFamily => 'குடும்பம்';

  @override
  String get roleHelper => 'நம்பகமான உதவியாளர்';

  @override
  String get askGurtuTitle => 'Gurtu-விடம் கேளுங்கள்';

  @override
  String get askGurtuPrompt => 'எதையாவது நினைவுகூர உதவி வேண்டுமா?';

  @override
  String get askExampleBloodTest => 'இரத்தப் பரிசோதனை எப்போது?';

  @override
  String get askExampleDoctor => 'நாளை மருத்துவரிடம் என்ன கேட்க வேண்டும்?';

  @override
  String get askGurtuNote =>
      'பதில்கள் நீங்கள் சேமித்த பராமரிப்புத் தகவலிலிருந்து வருகின்றன.';

  @override
  String get gettingReady => 'Gurtu தயாராகிறது';

  @override
  String get readyYourProfile => 'உங்கள் சுயவிவரம்';

  @override
  String get readyPatientProfile => 'நோயாளி சுயவிவரம்';

  @override
  String get readyCareCircle => 'பராமரிப்பு வட்டம்';

  @override
  String get readyEmergencyContact => 'அவசரத் தொடர்பு';

  @override
  String get previewSampleData => 'மாதிரித் தரவுடன் பார்';

  @override
  String get sampleDataOn => 'மாதிரிப் பராமரிப்புத் தரவு காட்டப்படுகிறது';

  @override
  String get remove => 'நீக்கு';

  @override
  String get hide => 'மறை';

  @override
  String get comingNextPhase => 'இந்தப் பகுதி அடுத்து உருவாக்கப்படுகிறது.';

  @override
  String get fatherName => 'அப்பா';

  @override
  String get sampleTaskMorningMedicine => 'காலை மருந்து';

  @override
  String get sampleTaskRecordBp => 'BP பதிவு';

  @override
  String get sampleTaskBloodTest => 'இரத்தப் பரிசோதனை';

  @override
  String get sampleTaskDoctorVisit => 'மருத்துவர் சந்திப்பு';

  @override
  String get sampleMomentDoctorTalk => 'மருத்துவருடன் உரையாடல்';

  @override
  String get sampleMomentDoctorTalkDetail =>
      '“காலை உணவுக்குப் பின் மருந்தை எடுங்கள்.”';

  @override
  String get sampleMomentPrescription =>
      'மருந்துச் சீட்டு ஸ்கேன் செய்யப்பட்டது';

  @override
  String get sampleMomentPrescriptionDetail => '2 மருந்துகள் கண்டறியப்பட்டன';

  @override
  String get sampleMomentBp => 'BP பதிவு செய்யப்பட்டது';

  @override
  String get today => 'இன்று';

  @override
  String get yesterday => 'நேற்று';
}
