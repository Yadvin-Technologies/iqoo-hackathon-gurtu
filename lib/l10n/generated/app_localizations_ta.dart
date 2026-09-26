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

  @override
  String get doctorVisit => 'மருத்துவர் சந்திப்பு';

  @override
  String get doctorVisitHint => 'மருத்துவர் சொல்வதைக் குறித்துக்கொள்ளுங்கள்';

  @override
  String get askDoctor => 'மருத்துவரிடம் கேட்க வேண்டியவை';

  @override
  String get askDoctorHint => 'Gurtu தயாராக உதவும்';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count கேள்விகள் தயார்',
      one: '1 கேள்வி தயார்',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'கடைசி சந்திப்பு: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'அடுத்த சந்திப்பு: $date';
  }

  @override
  String get visitsTitle => 'மருத்துவர் சந்திப்புகள்';

  @override
  String get visitsSubtitle => 'ஒவ்வொரு மருத்துவரும் சொன்னது, ஒரே இடத்தில்.';

  @override
  String get recordVisit => 'சந்திப்பைப் பதிவு செய்';

  @override
  String get visitsOverview => 'எல்லா சந்திப்புகளும் ஒரே பார்வையில்';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count சந்திப்புகள்',
      one: '1 சந்திப்பு',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மருத்துவர்கள்',
      one: '1 மருத்துவர்',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'கடைசி சந்திப்பு';

  @override
  String get nextVisit => 'அடுத்த சந்திப்பு';

  @override
  String get notPlanned => 'இன்னும் முடிவாகவில்லை';

  @override
  String get pastVisits => 'முந்தைய சந்திப்புகள்';

  @override
  String get noVisitsTitle => 'இன்னும் சந்திப்பு எதுவும் பதிவாகவில்லை';

  @override
  String get noVisitsBody =>
      'அடுத்த சந்திப்பில் ‘சந்திப்பைப் பதிவு செய்’ என்பதைத் தட்டுங்கள், மருத்துவர் சொல்வதை Gurtu குறித்துக்கொள்ளும்.';

  @override
  String get questionsForNextVisit => 'அடுத்த சந்திப்புக்கான கேள்விகள்';

  @override
  String get prepareQuestionsHint =>
      'உங்கள் உடல்நிலையை Gurtu-விடம் சொல்லுங்கள். மருத்துவரிடம் என்ன கேட்பது என்று பரிந்துரைக்கும்.';

  @override
  String get prepareQuestions => 'கேள்விகளைத் தயார் செய்';

  @override
  String get viewQuestions => 'கேள்விகளைப் பார்';

  @override
  String get doctorFallback => 'மருத்துவர்';

  @override
  String get doctorSaid => 'மருத்துவர் சொன்னது';

  @override
  String get medicinesSection => 'மருந்துகள்';

  @override
  String get testsSection => 'செய்ய வேண்டிய பரிசோதனைகள்';

  @override
  String get questionsAsked => 'கேட்ட கேள்விகள்';

  @override
  String askedOf(int asked, int total) {
    return '$total-இல் $asked கேட்கப்பட்டது';
  }

  @override
  String get deleteVisit => 'சந்திப்பை நீக்கு';

  @override
  String get deleteVisitConfirm =>
      'இந்தச் சந்திப்பை நீக்கவா? மீண்டும் பெற முடியாது.';

  @override
  String get cancel => 'ரத்து';

  @override
  String get delete => 'நீக்கு';

  @override
  String get doctorName => 'மருத்துவரின் பெயர்';

  @override
  String get doctorNameHint => 'எ.கா. டாக்டர் மீனா ராவ்';

  @override
  String get visitReason => 'சந்திப்பின் காரணம்';

  @override
  String get visitReasonHint => 'எ.கா. சர்க்கரை பரிசோதனை';

  @override
  String get visitDate => 'சந்திப்பு தேதி';

  @override
  String get listenToDoctor => 'மருத்துவர் சொல்வதைக் கேள்';

  @override
  String get stopListening => 'கேட்பதை நிறுத்து';

  @override
  String get speak => 'பேசுங்கள்';

  @override
  String get recordingConsent =>
      'Gurtu மூலம் உரையாடலைக் குறித்துக்கொள்கிறீர்கள் என்று மருத்துவரிடம் சொல்லுங்கள்.';

  @override
  String get doctorSaidHint =>
      'மருத்துவர் சொல்வதைப் பேசுங்கள் அல்லது தட்டச்சு செய்யுங்கள்';

  @override
  String get medicinesHint => 'எ.கா. மெட்ஃபார்மின் 500 mg காலை உணவுக்குப் பின்';

  @override
  String get testsHint => 'எ.கா. HbA1c இரத்தப் பரிசோதனை';

  @override
  String get addNextVisit => 'அடுத்த சந்திப்பு தேதியைச் சேர்';

  @override
  String get yourQuestions => 'உங்கள் கேள்விகள்';

  @override
  String get tickWhenAsked =>
      'மருத்துவர் பதில் சொன்னதும் ஒவ்வொன்றையும் டிக் செய்யுங்கள்.';

  @override
  String get saveVisit => 'சந்திப்பைச் சேமி';

  @override
  String get visitSaved => 'சந்திப்பு சேமிக்கப்பட்டது';

  @override
  String get leaveVisitTitle => 'சேமிக்காமல் வெளியேறவா?';

  @override
  String get leaveVisitBody =>
      'இந்தச் சந்திப்புக்கு நீங்கள் குறித்தவை அழிந்துவிடும்.';

  @override
  String get discard => 'நிராகரி';

  @override
  String get keepEditing => 'தொடர்ந்து எழுது';

  @override
  String get voiceUnavailable =>
      'இப்போது குரல் உள்ளீடு கிடைக்கவில்லை. நீங்கள் தட்டச்சு செய்யலாம்.';

  @override
  String get prepTitle => 'மருத்துவருக்குத் தயாராகுங்கள்';

  @override
  String get prepIntro =>
      'மருத்துவரைச் சந்திக்கத் தயாராவோம். எந்த உடல்நலப் பிரச்சினைகள் பற்றிப் பேச வேண்டும்?';

  @override
  String get prepPickOrSay =>
      'கீழே பிரச்சினைகளைத் தேர்வு செய்யுங்கள், அல்லது உங்கள் வார்த்தைகளில் சொல்லுங்கள்.';

  @override
  String get prepDescribeHint => 'எ.கா. மூன்று நாளாகத் தலைவலி, சோர்வு';

  @override
  String prepHeard(String symptoms) {
    return 'நான் கேட்டது: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — எப்போதிலிருந்து?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — எவ்வளவு கடுமையாக உள்ளது?';
  }

  @override
  String get askNewMedicine =>
      'சமீபத்தில் ஏதேனும் மருந்து தொடங்கப்பட்டதா அல்லது மாற்றப்பட்டதா?';

  @override
  String get askAnythingElse => 'மருத்துவரிடம் வேறு ஏதாவது சொல்ல வேண்டுமா?';

  @override
  String get urgentWarning =>
      'கடுமையான நெஞ்சு வலி அல்லது மூச்சுத் திணறல் அவசர நிலையாக இருக்கலாம். சந்திப்புக்காகக் காத்திருக்க வேண்டாம் — உடனே மருத்துவ உதவி பெறுங்கள்.';

  @override
  String get prepThinking => 'உங்கள் கேள்விகள் தயாராகின்றன…';

  @override
  String get prepResultIntro =>
      'மருத்துவரிடம் இவற்றைக் கேளுங்கள். தேவையில்லாதவற்றை நீக்குங்கள், அல்லது உங்கள் கேள்வியைச் சேருங்கள்.';

  @override
  String get prepNotDoctor =>
      'Gurtu மருத்துவர் அல்ல. இந்தக் கேள்விகள் மருத்துவரிடம் பேச உதவும்.';

  @override
  String get addOwnQuestion => 'உங்கள் சொந்தக் கேள்வியைச் சேர்';

  @override
  String get add => 'சேர்';

  @override
  String get saveQuestions => 'சந்திப்புக்காகச் சேமி';

  @override
  String get questionsSaved => 'கேள்விகள் சந்திப்புக்காகச் சேமிக்கப்பட்டன';

  @override
  String get startAgain => 'மீண்டும் தொடங்கு';

  @override
  String get startVisit => 'சந்திப்பைத் தொடங்கு';

  @override
  String get deleteQuestions => 'இந்தக் கேள்விகளை நீக்கு';

  @override
  String get removeQuestion => 'கேள்வியை நீக்கு';

  @override
  String get done => 'முடிந்தது';

  @override
  String get healthProblems => 'உடல்நலப் பிரச்சினைகள்';

  @override
  String preparedOn(String date) {
    return '$date அன்று தயாரிக்கப்பட்டது';
  }

  @override
  String get symFever => 'காய்ச்சல்';

  @override
  String get symHeadache => 'தலைவலி';

  @override
  String get symBodyPain => 'உடல் அல்லது மூட்டு வலி';

  @override
  String get symChestPain => 'நெஞ்சு வலி';

  @override
  String get symBreathless => 'மூச்சுத் திணறல்';

  @override
  String get symCough => 'இருமல்';

  @override
  String get symDizziness => 'தலைச்சுற்றல்';

  @override
  String get symTiredness => 'சோர்வு';

  @override
  String get symStomach => 'வயிற்றுப் பிரச்சினை';

  @override
  String get symPoorSleep => 'தூக்கமின்மை';

  @override
  String get symPoorAppetite => 'பசியின்மை';

  @override
  String get symLowMood => 'மனச்சோர்வு அல்லது கவலை';

  @override
  String get kwFever => 'காய்ச்சல்,ஜுரம்,சுரம்,குளிர்';

  @override
  String get kwHeadache => 'தலைவலி,தலை வலி';

  @override
  String get kwBodyPain => 'உடல் வலி,மூட்டு வலி,முழங்கால்,முதுகு வலி,கால் வலி';

  @override
  String get kwChestPain => 'நெஞ்சு வலி,நெஞ்சு,மார்பு வலி';

  @override
  String get kwBreathless => 'மூச்சு,மூச்சுத் திணறல்,இளைப்பு';

  @override
  String get kwCough => 'இருமல்,சளி,கபம்';

  @override
  String get kwDizziness => 'தலைச்சுற்றல்,மயக்கம்,கிறுகிறுப்பு';

  @override
  String get kwTiredness => 'சோர்வு,களைப்பு,பலவீனம்';

  @override
  String get kwStomach =>
      'வயிறு,வயிற்று,அசிடிட்டி,வாயு,வாந்தி,வயிற்றுப்போக்கு,மலச்சிக்கல்,குமட்டல்';

  @override
  String get kwPoorSleep => 'தூக்கம்,தூக்கமின்மை';

  @override
  String get kwPoorAppetite => 'பசி,சாப்பிட முடியவில்லை';

  @override
  String get kwLowMood => 'கவலை,பயம்,மன அழுத்தம்,டென்ஷன்,சோகம்';

  @override
  String get sinceToday => 'இன்றிலிருந்து';

  @override
  String get sinceFewDays => 'சில நாட்களாக';

  @override
  String get sinceWeek => 'சுமார் ஒரு வாரமாக';

  @override
  String get sinceMonth => 'ஒரு மாதம் அல்லது அதற்கு மேல்';

  @override
  String get sevMild => 'லேசாக';

  @override
  String get sevModerate => 'மிதமாக';

  @override
  String get sevSevere => 'கடுமையாக';

  @override
  String qCause(String symptom) {
    return '$symptom ஏற்படக் காரணம் என்னவாக இருக்கலாம்?';
  }

  @override
  String qTests(String symptom) {
    return '$symptom-க்கு ஏதேனும் பரிசோதனை தேவையா?';
  }

  @override
  String qWarningSigns(String symptom) {
    return '$symptom உடன் எந்த அறிகுறிகள் தெரிந்தால் உடனே திரும்ப வர வேண்டும்?';
  }

  @override
  String qHomeCare(String symptom) {
    return '$symptom குறைய வீட்டில் என்ன செய்யலாம்?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return '$symptom-க்கும் $conditions-க்கும் தொடர்பு இருக்குமா?';
  }

  @override
  String get qSideEffect => 'புதிய அல்லது மாற்றிய மருந்தால் இது ஏற்படுகிறதா?';

  @override
  String get qMedicinesStillRight =>
      'இப்போதைய மருந்துகள் சரியானவையா, அல்லது ஏதாவது மாற்ற வேண்டுமா?';

  @override
  String get qNextCheckup => 'அடுத்த பரிசோதனைக்கு எப்போது வர வேண்டும்?';

  @override
  String qTellDoctor(String text) {
    return 'மருத்துவரிடம் சொல்லுங்கள்: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'சர்க்கரை நோய் மதிப்பாய்வு';

  @override
  String get sampleVisitDiabetesNotes =>
      'சர்க்கரை முன்பை விட நன்றாகக் கட்டுப்பாட்டில் உள்ளது. அதே மருந்துகளைத் தொடருங்கள். தினமும் 30 நிமிடம் நடந்து, இனிப்பைக் குறையுங்கள்.';

  @override
  String get sampleVisitDiabetesMeds =>
      'மெட்ஃபார்மின் 500 mg காலை மற்றும் இரவு உணவுக்குப் பின்';

  @override
  String get sampleVisitDiabetesTests =>
      'அடுத்த சந்திப்புக்கு முன் HbA1c இரத்தப் பரிசோதனை';

  @override
  String get sampleVisitKneeReason => 'முழங்கால் வலி';

  @override
  String get sampleVisitKneeNotes =>
      'வலது முழங்காலில் லேசான மூட்டுவாதம். மாலையில் சூடான ஒத்தடம் கொடுங்கள், அதிகப் படிகள் ஏறுவதைத் தவிருங்கள்.';

  @override
  String get sampleVisitKneeMeds => 'வலி நிவாரண ஜெல் தினமும் இருமுறை';

  @override
  String get scanVerify => 'மருந்தை ஸ்கேன் செய்து சரிபார்';

  @override
  String get scanVerifyHint =>
      'இந்த மாத்திரையைத்தான் இப்போது சாப்பிட வேண்டுமா?';

  @override
  String scanVerifySubtitle(String name) {
    return 'அட்டை அல்லது பெட்டியை ஸ்கேன் செய்யுங்கள். Gurtu அதை $name-இன் மருந்துப் பட்டியலுடன் சரிபார்க்கும்.';
  }

  @override
  String get scanWithCamera => 'மருந்தை ஸ்கேன் செய்';

  @override
  String get orTypeName => 'அல்லது அட்டையில் உள்ள பெயரைத் தட்டச்சு செய்யுங்கள்';

  @override
  String get typeNameHint => 'எ.கா. Glycomet 500';

  @override
  String get checkMedicine => 'சரிபார்';

  @override
  String get checkAnother => 'வேறு மருந்தைச் சரிபார்';

  @override
  String get readingStrip => 'அட்டையைப் படிக்கிறது…';

  @override
  String get cameraUnavailable =>
      'கேமரா ஸ்கேன் போன் செயலியில் வேலை செய்யும். இப்போது பெயரைத் தட்டச்சு செய்யுங்கள்.';

  @override
  String get scanFailed =>
      'புகைப்படத்தைப் படிக்க முடியவில்லை. மீண்டும் முயலுங்கள், அல்லது பெயரைத் தட்டச்சு செய்யுங்கள்.';

  @override
  String readFromStrip(String text) {
    return 'அட்டையில் படித்தது: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'நீங்கள் சேமித்த மருந்துகளுடன் மட்டுமே Gurtu சரிபார்க்கும். அது ஒருபோதும் மருந்து பரிந்துரைக்காது.';

  @override
  String get verdictTakeNow =>
      'ஆம் — இதுதான் சரியான மருந்து, இப்போது சாப்பிடலாம்.';

  @override
  String get verdictNotNow =>
      'மருந்து சரிதான், ஆனால் இப்போது சாப்பிடும் நேரம் இல்லை.';

  @override
  String get verdictAlreadyTaken =>
      'இந்த டோஸ் ஏற்கனவே சாப்பிட்டாகிவிட்டது. மீண்டும் சாப்பிட வேண்டாம்.';

  @override
  String get verdictNoTimes =>
      'மருந்து சரிதான், ஆனால் அதன் நேரம் சேமிக்கப்படவில்லை.';

  @override
  String get verdictWrongStrength =>
      'நில்லுங்கள் — அளவு (mg) மருந்துச்சீட்டிலிருந்து வேறுபடுகிறது.';

  @override
  String verdictNotOnList(String name) {
    return 'நில்லுங்கள் — இந்த மருந்து $name-இன் பட்டியலில் இல்லை.';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'நில்லுங்கள் — இந்த மருந்து $other-இன் பட்டியலில் உள்ளது, $name-இன் பட்டியலில் இல்லை.';
  }

  @override
  String get verdictUnreadable =>
      'மருந்தின் பெயரைப் படிக்க முடியவில்லை. நல்ல வெளிச்சத்தில் மீண்டும் முயலுங்கள், அல்லது தட்டச்சு செய்யுங்கள்.';

  @override
  String get verdictCheckFirst =>
      'மருத்துவர் அல்லது மருந்தாளரிடம் கேட்காமல் சாப்பிட வேண்டாம்.';

  @override
  String get rowOnList => 'மருந்துப் பட்டியலில் உள்ளது';

  @override
  String rowStrengthMatches(String strength) {
    return 'அளவு பொருந்துகிறது: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'அட்டையில் $found, மருந்துச்சீட்டில் $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'இப்போது சாப்பிட வேண்டியது: $slot டோஸ்';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot டோஸ் $time-க்குச் சாப்பிடப்பட்டது';
  }

  @override
  String rowNextDose(String slot) {
    return 'அடுத்த டோஸ்: $slot';
  }

  @override
  String get rowSetTimes =>
      'மருந்துப் பட்டியலில் எப்போது சாப்பிட வேண்டும் என்பதைச் சேருங்கள்';

  @override
  String get markTaken => 'சாப்பிட்டதாகப் பதிவு செய்';

  @override
  String get markedTaken => 'டோஸ் பதிவானது';

  @override
  String get undo => 'செயல்தவிர்';

  @override
  String get medicineList => 'மருந்துப் பட்டியல்';

  @override
  String get medicineListSubtitle =>
      'மருந்துச்சீட்டுகளில் உள்ள ஒவ்வொரு மருந்தும், எப்போது சாப்பிட வேண்டும் என்பதுடன்.';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மருந்துகள்',
      one: '1 மருந்து',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'மருந்தைச் சேர்';

  @override
  String get editMedicine => 'மருந்தைத் திருத்து';

  @override
  String get addFromPrescription => 'மருந்துச்சீட்டு புகைப்படத்திலிருந்து சேர்';

  @override
  String get noMedicinesTitle => 'இன்னும் மருந்துகள் சேர்க்கப்படவில்லை';

  @override
  String get noMedicinesBody =>
      'மருந்துச்சீட்டில் உள்ள ஒவ்வொரு மருந்தையும் ஒருமுறை சேருங்கள். பிறகு எந்த அட்டையையும் ஸ்கேன் செய்து சரியானதா என்று பாருங்கள்.';

  @override
  String addMedicinesFirst(String name) {
    return 'முதலில் $name-இன் மருந்துகளைச் சேருங்கள், அப்போது Gurtu அவற்றுடன் சரிபார்க்க முடியும்.';
  }

  @override
  String get medicineName => 'மருந்தின் பெயர்';

  @override
  String get medicineNameHint => 'எ.கா. Metformin';

  @override
  String get alsoCalled => 'அட்டையில் உள்ள மற்றொரு பெயர்';

  @override
  String get alsoCalledHint => 'எ.கா. Glycomet';

  @override
  String get strength => 'அளவு';

  @override
  String get strengthHint => 'எ.கா. 500 mg';

  @override
  String get whenToTake => 'எப்போது சாப்பிட வேண்டும்';

  @override
  String get doseMorning => 'காலை';

  @override
  String get doseAfternoon => 'மதியம்';

  @override
  String get doseEvening => 'மாலை';

  @override
  String get doseNight => 'இரவு';

  @override
  String get foodAfter => 'உணவுக்குப் பின்';

  @override
  String get foodBefore => 'உணவுக்கு முன்';

  @override
  String get foodAny => 'உணவுடனோ இல்லாமலோ';

  @override
  String get saveMedicine => 'மருந்தைச் சேமி';

  @override
  String get medicineSaved => 'மருந்து சேமிக்கப்பட்டது';

  @override
  String get deleteMedicine => 'மருந்தை நீக்கு';

  @override
  String get deleteMedicineConfirm =>
      'இந்த மருந்தைப் பட்டியலிலிருந்து நீக்கவா?';

  @override
  String get scanToFill => 'அட்டையை ஸ்கேன் செய்து நிரப்பு';

  @override
  String get timesNotSet => 'நேரம் அமைக்கப்படவில்லை';

  @override
  String get takenToday => 'இன்று சாப்பிட்டவை';

  @override
  String get prescriptionTitle => 'மருந்துச்சீட்டிலிருந்து சேர்';

  @override
  String get prescriptionHint =>
      'அச்சிடப்பட்ட மருந்துச்சீட்டின் தெளிவான புகைப்படம் எடுங்கள். Gurtu மருந்துகளைக் கண்டறியும்; எவற்றைச் சேர்ப்பது என்று நீங்கள் தேர்வு செய்யுங்கள்.';

  @override
  String get takePhoto => 'புகைப்படம் எடு';

  @override
  String get chooseFromGallery => 'கேலரியிலிருந்து தேர்வு செய்';

  @override
  String get medicinesFound => 'கண்டறிந்த மருந்துகள்';

  @override
  String get tickToAdd =>
      'சேர்க்க வேண்டியவற்றை டிக் செய்யுங்கள். ஒவ்வொரு பெயரையும் நேரத்தையும் மருந்துச்சீட்டுடன் சரிபாருங்கள்.';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மருந்துகளைச் சேர்',
      one: '1 மருந்தைச் சேர்',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'மருந்துகள் எதுவும் கிடைக்கவில்லை. தெளிவான புகைப்படம் எடுங்கள், அல்லது கையால் சேருங்கள்.';

  @override
  String get handwrittenNote =>
      'கையால் எழுதிய மருந்துச்சீட்டுகள் சரியாகப் படிக்கப்படாமல் போகலாம். ஒவ்வொரு பெயரையும் சரிபாருங்கள்.';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மருந்துகள் சேர்க்கப்பட்டன',
      one: '1 மருந்து சேர்க்கப்பட்டது',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'அட்டையில் $strength என்று உள்ளதா பாருங்கள்';
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
  String get addPhoto => 'புகைப்படம் சேர்க்கவும்';

  @override
  String get recordVoiceNote => 'குரல் குறிப்பைப் பதிவுசெய்யவும்';

  @override
  String get voiceNote => 'குரல் குறிப்பு';

  @override
  String get recordingNow => 'பதிவாகிறது…';

  @override
  String get stopAndSave => 'நிறுத்திச் சேமிக்கவும்';

  @override
  String get removeAttachmentTitle => 'இதை நீக்கவா?';

  @override
  String get removeAttachmentBody => 'இது இந்த ஃபோனிலிருந்து அழிக்கப்படும்.';

  @override
  String get attachFailed =>
      'இதைச் சேர்க்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get attachHintMedicines =>
      'மருந்துச் சீட்டின் புகைப்படத்தைச் சேர்க்கவும், அல்லது மருந்துகள் பற்றி மருத்துவர் சொன்னதைப் பதிவுசெய்யவும்.';

  @override
  String get attachHintTests =>
      'பரிசோதனைச் சீட்டு அல்லது அறிக்கையின் புகைப்படத்தைச் சேர்க்கவும், அல்லது மருத்துவர் சொன்னதைப் பதிவுசெய்யவும்.';

  @override
  String get attachHintNextVisit =>
      'சந்திப்பு அட்டையின் புகைப்படத்தைச் சேர்க்கவும், அல்லது அடுத்த வருகை பற்றி மருத்துவர் சொன்னதைப் பதிவுசெய்யவும்.';

  @override
  String get play => 'இயக்கு';

  @override
  String get pause => 'இடைநிறுத்து';

  @override
  String get viewPhoto => 'புகைப்படத்தைப் பார்க்கவும்';
}
