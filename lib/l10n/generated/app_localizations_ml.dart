// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get continueLabel => 'തുടരുക';

  @override
  String get next => 'അടുത്തത്';

  @override
  String get skip => 'ഒഴിവാക്കുക';

  @override
  String get later => 'പിന്നീട്';

  @override
  String get back => 'പിന്നോട്ട്';

  @override
  String get optional => 'ഐച്ഛികം';

  @override
  String get yes => 'അതെ';

  @override
  String get no => 'ഇല്ല';

  @override
  String get notSure => 'ഉറപ്പില്ല';

  @override
  String get tagline => 'ഓർക്കുക. പരിചരിക്കുക. ഒരുമിച്ച്.';

  @override
  String get motherName => 'അമ്മ';

  @override
  String get phaseAbout => 'പരിചയം';

  @override
  String get phaseHealth => 'ആരോഗ്യം';

  @override
  String get phasePermissions => 'അനുമതികൾ';

  @override
  String get phaseAi => 'AI സജ്ജീകരണം';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $total-ൽ $current';
  }

  @override
  String get languageTitle => 'നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get languageSubtitle =>
      'Gurtu ഈ ഭാഷയിൽ സംസാരിക്കും, കേൾക്കും, എഴുതും.';

  @override
  String get languageMixNote =>
      'ഡോക്ടർമാർ പലപ്പോഴും നിങ്ങളുടെ ഭാഷയിൽ ഇംഗ്ലീഷ് കലർത്തി സംസാരിക്കും. Gurtu രണ്ടും ഒരുമിച്ച് മനസ്സിലാക്കും.';

  @override
  String get welcomeTitle => 'നിങ്ങളുടെ കുടുംബത്തിന്റെ\nപരിചരണ ഓർമ്മ';

  @override
  String get welcomeBody =>
      'ഡോക്ടർ എന്ത് പറഞ്ഞു, ഏത് മരുന്ന് എഴുതി, വീട്ടിൽ എന്ത് സംഭവിച്ചു — എല്ലാം ഒരുമിച്ച് ഓർത്തുവയ്ക്കാം.';

  @override
  String get welcomeScript => 'പല റോളുകൾ. ഒരേ സ്നേഹം.';

  @override
  String get getStarted => 'തുടങ്ങാം';

  @override
  String builtForBrand(String brand) {
    return '$brand-നായി നിർമ്മിച്ചത്';
  }

  @override
  String get madeInHyderabad => 'ഹൈദരാബാദിൽ നിർമ്മിച്ചത്';

  @override
  String get introRecordEyebrow => '1 · റെക്കോർഡ്';

  @override
  String get introRecordTitle => 'ഡോക്ടർ പറഞ്ഞത് ഒരിക്കലും മറക്കരുത്';

  @override
  String get introRecordBody =>
      'എല്ലാവരുടെയും സമ്മതത്തോടെ ഡോക്ടർ, നഴ്സ് അല്ലെങ്കിൽ ഫാർമസിസ്റ്റിന്റെ വാക്കുകൾ റെക്കോർഡ് ചെയ്യുക. പ്രധാനപ്പെട്ടവ Gurtu സൂക്ഷിക്കും.';

  @override
  String get introPlanEyebrow => '2 · മനസ്സിലാക്കുക & പങ്കിടുക';

  @override
  String get introPlanTitle => 'മുഴുവൻ കുടുംബത്തിനും ഒരു പരിചരണ പദ്ധതി';

  @override
  String get introPlanBody =>
      'കുറിപ്പടികളും റിപ്പോർട്ടുകളും സ്കാൻ ചെയ്യുക. കുടുംബത്തിന് പങ്കിടാവുന്ന ലളിതമായ ജോലികളാക്കി Gurtu മാറ്റും.';

  @override
  String get introAskEyebrow => '3 · ചോദിക്കുക & ഓർക്കുക';

  @override
  String get introAskTitle => 'എന്തും ചോദിക്കൂ, തെളിവ് കാണൂ';

  @override
  String get introAskBody =>
      'ഓരോ ഉത്തരവും എവിടെ നിന്ന് വന്നുവെന്ന് കാണിക്കും — റെക്കോർഡിംഗ്, കുറിപ്പടി അല്ലെങ്കിൽ ഫോട്ടോ.';

  @override
  String get letsSetUp => 'സജ്ജമാക്കാം';

  @override
  String get hospitalMode => 'ഹോസ്പിറ്റൽ മോഡ്';

  @override
  String get consentRecording =>
      'അവിടെയുള്ള എല്ലാവരുടെയും സമ്മതത്തോടെ റെക്കോർഡിംഗ്';

  @override
  String get doctorConversation => 'ഡോക്ടറുമായുള്ള സംഭാഷണം';

  @override
  String get nurseInstructions => 'നഴ്സിന്റെ നിർദ്ദേശങ്ങൾ';

  @override
  String get pharmacistAdvice => 'ഫാർമസിസ്റ്റിന്റെ ഉപദേശം';

  @override
  String get yourCarePlan => 'നിങ്ങളുടെ പരിചരണ പദ്ധതി';

  @override
  String get afterBreakfast => 'പ്രാതലിന് ശേഷം';

  @override
  String get checkBloodPressure => 'BP പരിശോധിക്കുക';

  @override
  String get twiceDaily => 'ദിവസം രണ്ടുതവണ';

  @override
  String get bloodTest => 'രക്തപരിശോധന (CBC)';

  @override
  String get instructionsFound =>
      'നിങ്ങളുടെ റെക്കോർഡിംഗുകളിലും കുറിപ്പടിയിലും 4 നിർദ്ദേശങ്ങൾ കണ്ടെത്തി';

  @override
  String get askQuestion =>
      'വൈകുന്നേരത്തെ മരുന്നിനെക്കുറിച്ച് ഡോക്ടർ എന്ത് പറഞ്ഞു?';

  @override
  String get askAnswer =>
      'Amlodipine അത്താഴത്തിന് ശേഷം കഴിക്കാൻ ഡോക്ടർ പറഞ്ഞു.';

  @override
  String get sourceDoctorVisit => 'ഉറവിടം: ഡോക്ടർ സന്ദർശനം';

  @override
  String get careForTitle => 'ആർക്കുവേണ്ടിയാണ് Gurtu സജ്ജമാക്കുന്നത്?';

  @override
  String get careForSubtitle =>
      'ഒരാളെ ചുറ്റിപ്പറ്റി Gurtu പരിചരണ ഓർമ്മ ഉണ്ടാക്കുന്നു. ബാക്കി കുടുംബത്തെ പിന്നീട് ക്ഷണിക്കാം.';

  @override
  String get careForMyself => 'എനിക്കുവേണ്ടി';

  @override
  String get careForMyselfHint => 'എന്റെ സ്വന്തം പരിചരണം ശ്രദ്ധിക്കാൻ';

  @override
  String get careForParent => 'എന്റെ മാതാപിതാക്കൾ';

  @override
  String get careForParentHint => 'അമ്മ, അച്ഛൻ അല്ലെങ്കിൽ വീട്ടിലെ മുതിർന്നവർ';

  @override
  String get careForPartner => 'എന്റെ ജീവിതപങ്കാളി';

  @override
  String get careForPartnerHint => 'ഭർത്താവ്, ഭാര്യ അല്ലെങ്കിൽ പങ്കാളി';

  @override
  String get careForChild => 'എന്റെ കുട്ടി';

  @override
  String get careForChildHint => 'മകൻ അല്ലെങ്കിൽ മകൾ';

  @override
  String get careForOther => 'മറ്റാരെങ്കിലും';

  @override
  String get careForOtherHint => 'ബന്ധു, സുഹൃത്ത് അല്ലെങ്കിൽ അയൽക്കാരൻ';

  @override
  String get profileTitleSelf => 'നിങ്ങളെക്കുറിച്ച് പറയൂ';

  @override
  String get profileTitleOther => 'അവരെക്കുറിച്ച് പറയൂ';

  @override
  String get profileSubtitleSelf =>
      'ഇതുവഴി Gurtu നിങ്ങളെ പേര് ചൊല്ലി വിളിക്കും.';

  @override
  String get profileSubtitleOther =>
      'വീട്ടിൽ നിങ്ങൾ അവരെ വിളിക്കുന്ന പേര് എഴുതുക.';

  @override
  String get yourName => 'നിങ്ങളുടെ പേര്';

  @override
  String get whatDoYouCallThem => 'നിങ്ങൾ അവരെ എന്താണ് വിളിക്കുന്നത്?';

  @override
  String exampleName(String name) {
    return 'ഉദാ. $name';
  }

  @override
  String get sampleSelfName => 'ലക്ഷ്മി';

  @override
  String get sampleYourName => 'പ്രിയ';

  @override
  String get yourAge => 'നിങ്ങളുടെ പ്രായം';

  @override
  String get theirAge => 'അവരുടെ പ്രായം';

  @override
  String get years => 'വയസ്സ്';

  @override
  String get decreaseAge => 'പ്രായം കുറയ്ക്കുക';

  @override
  String get increaseAge => 'പ്രായം കൂട്ടുക';

  @override
  String get gender => 'ലിംഗം';

  @override
  String get female => 'സ്ത്രീ';

  @override
  String get male => 'പുരുഷൻ';

  @override
  String get genderOther => 'മറ്റുള്ളവ';

  @override
  String get andYou => 'നിങ്ങളോ?';

  @override
  String get andYouBody => 'അവരുടെ കെയർ സർക്കിളിലെ ആദ്യ അംഗം നിങ്ങളായിരിക്കും.';

  @override
  String get conditionsTitleSelf =>
      'നിങ്ങൾക്ക് ഇവയിൽ ഏതെങ്കിലും ആരോഗ്യപ്രശ്നം ഉണ്ടോ?';

  @override
  String conditionsTitleOther(String name) {
    return '$name-ന് ഇവയിൽ ഏതെങ്കിലും ആരോഗ്യപ്രശ്നം ഉണ്ടോ?';
  }

  @override
  String get conditionsSubtitle =>
      'ബാധകമായതെല്ലാം തിരഞ്ഞെടുക്കുക. പരിചരണ പദ്ധതി ക്രമീകരിക്കാൻ ഇത് സഹായിക്കും.';

  @override
  String get condDiabetes => 'ഷുഗർ (പ്രമേഹം)';

  @override
  String get condHighBp => 'ഹൈ BP';

  @override
  String get condHeart => 'ഹൃദ്രോഗം';

  @override
  String get condThyroid => 'തൈറോയ്ഡ്';

  @override
  String get condCholesterol => 'കൊളസ്ട്രോൾ';

  @override
  String get condAsthma => 'ആസ്ത്മ / ശ്വാസതടസ്സം';

  @override
  String get condKidney => 'വൃക്കരോഗം';

  @override
  String get condArthritis => 'സന്ധിവേദന / ആർത്രൈറ്റിസ്';

  @override
  String get condStroke => 'മുമ്പ് പക്ഷാഘാതം';

  @override
  String get condCancer => 'കാൻസർ ചികിത്സ';

  @override
  String get noneOfThese => 'ഇവയൊന്നുമില്ല';

  @override
  String get notADoctor =>
      'Gurtu ഒരു ഡോക്ടറല്ല. ഇത് ഒരിക്കലും രോഗനിർണ്ണയം നടത്തുന്നില്ല — കുടുംബത്തെ പരിചരണം ഓർക്കാനും ക്രമീകരിക്കാനും മാത്രം സഹായിക്കുന്നു.';

  @override
  String get medicinesTitleSelf => 'നിങ്ങൾ ദിവസവും മരുന്ന് കഴിക്കാറുണ്ടോ?';

  @override
  String medicinesTitleOther(String name) {
    return '$name ദിവസവും മരുന്ന് കഴിക്കാറുണ്ടോ?';
  }

  @override
  String get medicinesSubtitle =>
      'ഗുളികകൾ, സിറപ്പ്, ഇൻഹേലർ അല്ലെങ്കിൽ ഇൻസുലിൻ എല്ലാം ഉൾപ്പെടുത്തുക.';

  @override
  String get howMany => 'ഏകദേശം എത്ര?';

  @override
  String get sixOrMore => '6 അല്ലെങ്കിൽ കൂടുതൽ';

  @override
  String get scanLaterTip =>
      'പിന്നീട് കുറിപ്പടിയോ ഗുളിക സ്ട്രിപ്പോ സ്കാൻ ചെയ്താൽ മതി — ടൈപ്പ് ചെയ്യേണ്ട.';

  @override
  String get allergiesTitleSelf => 'നിങ്ങൾക്ക് എന്തിനോടെങ്കിലും അലർജിയുണ്ടോ?';

  @override
  String allergiesTitleOther(String name) {
    return '$name-ന് എന്തിനോടെങ്കിലും അലർജിയുണ്ടോ?';
  }

  @override
  String get allergiesSubtitle =>
      'ഇത് ഒരിക്കലും വിട്ടുപോകാതിരിക്കാൻ Gurtu എല്ലാ ഡോക്ടർ ബ്രീഫിലും കാണിക്കും.';

  @override
  String get allergyNone => 'അറിയപ്പെടുന്ന അലർജിയില്ല';

  @override
  String get allergyPenicillin => 'പെൻസിലിൻ';

  @override
  String get allergySulfa => 'സൾഫ മരുന്നുകൾ';

  @override
  String get allergyAspirin => 'ആസ്പിരിൻ / വേദനസംഹാരികൾ';

  @override
  String get allergyFood => 'ഭക്ഷണ അലർജി';

  @override
  String get allergyDust => 'പൊടി / പൂമ്പൊടി';

  @override
  String get allergyLatex => 'ലാറ്റക്സ്';

  @override
  String get mobilityTitleSelf => 'ദിവസവും നിങ്ങൾ എങ്ങനെയാണ് സഞ്ചരിക്കുന്നത്?';

  @override
  String mobilityTitleOther(String name) {
    return 'ദിവസവും $name എങ്ങനെയാണ് സഞ്ചരിക്കുന്നത്?';
  }

  @override
  String get mobilitySubtitle =>
      'സന്ദർശനങ്ങൾ, പരിശോധനകൾ, വീട്ടിലെ സഹായം എന്നിവ ആസൂത്രണം ചെയ്യാൻ കുടുംബത്തെ ഇത് സഹായിക്കും.';

  @override
  String get mobilityIndependent => 'സ്വയം നടക്കും';

  @override
  String get mobilityIndependentHint => 'ദിവസേന സഹായം ആവശ്യമില്ല';

  @override
  String get mobilitySomeHelp => 'കുറച്ച് സഹായം വേണം';

  @override
  String get mobilitySomeHelpHint => 'വടി, വാക്കർ അല്ലെങ്കിൽ പിടിക്കാൻ ഒരു കൈ';

  @override
  String get mobilityFullHelp => 'കൂടുതലും കിടക്കയിലോ വീൽചെയറിലോ';

  @override
  String get mobilityFullHelpHint => 'മിക്ക കാര്യങ്ങൾക്കും സഹായം വേണം';

  @override
  String get hospitalTitleSelf =>
      'കഴിഞ്ഞ 30 ദിവസത്തിനുള്ളിൽ നിങ്ങൾ ആശുപത്രിയിലോ ഡോക്ടറുടെ അടുത്തോ പോയിട്ടുണ്ടോ?';

  @override
  String hospitalTitleOther(String name) {
    return 'കഴിഞ്ഞ 30 ദിവസത്തിനുള്ളിൽ $name ആശുപത്രിയിലോ ഡോക്ടറുടെ അടുത്തോ പോയിട്ടുണ്ടോ?';
  }

  @override
  String get hospitalSubtitle =>
      'അടുത്തിടെയുള്ള സന്ദർശനങ്ങൾക്കൊപ്പം സാധാരണയായി പുതിയ നിർദ്ദേശങ്ങൾ ഉണ്ടാകും.';

  @override
  String get hospitalTip =>
      'ഡിസ്ചാർജ് പേപ്പറുകളും കുറിപ്പടികളും കയ്യിൽ വയ്ക്കുക — സജ്ജീകരണം കഴിഞ്ഞാലുടൻ സ്കാൻ ചെയ്യാം.';

  @override
  String get permissionsTitle => 'നിങ്ങളെ സഹായിക്കാൻ ചില അനുമതികൾ';

  @override
  String get permissionsSubtitle =>
      'Gurtu ആവശ്യമുള്ളത് മാത്രം ചോദിക്കുന്നു. എന്തുകൊണ്ടെന്ന് ഇവിടെയുണ്ട്.';

  @override
  String get permMic => 'മൈക്രോഫോൺ';

  @override
  String get permMicWhy =>
      'ഡോക്ടർ സന്ദർശനങ്ങളും വോയ്സ് നോട്ടുകളും റെക്കോർഡ് ചെയ്യാൻ — നിങ്ങൾ റെക്കോർഡ് അമർത്തുമ്പോൾ മാത്രം.';

  @override
  String get permCamera => 'ക്യാമറ';

  @override
  String get permCameraWhy =>
      'കുറിപ്പടികൾ, ഗുളിക സ്ട്രിപ്പുകൾ, BP മെഷീൻ റീഡിംഗുകൾ സ്കാൻ ചെയ്യാൻ.';

  @override
  String get permNotifications => 'അറിയിപ്പുകൾ';

  @override
  String get permNotificationsWhy =>
      'മരുന്ന് ഓർമ്മപ്പെടുത്തലുകളും കുടുംബം ജോലി പൂർത്തിയാക്കുമ്പോഴുള്ള വിവരങ്ങളും.';

  @override
  String get permPhotos => 'ഫോട്ടോകൾ & ഫയലുകൾ';

  @override
  String get permPhotosWhy =>
      'ഗാലറിയിലുള്ള റിപ്പോർട്ടുകളും കുറിപ്പടികളും ചേർക്കാൻ.';

  @override
  String get permContacts => 'കോൺടാക്റ്റുകൾ';

  @override
  String get permContactsWhy =>
      'കുടുംബാംഗങ്ങളെ കെയർ സർക്കിളിലേക്ക് വേഗത്തിൽ ക്ഷണിക്കാൻ.';

  @override
  String get needed => 'ആവശ്യം';

  @override
  String get allow => 'അനുവദിക്കുക';

  @override
  String get allowed => 'അനുവദിച്ചു';

  @override
  String get allowAndContinue => 'അനുവദിച്ച് തുടരുക';

  @override
  String get privacyNote =>
      'എല്ലാം ഈ ഫോണിൽ തന്നെ നിൽക്കും. റെക്കോർഡിംഗ് സ്വയം തുടങ്ങില്ല — ആദ്യം സമ്മത സ്ക്രീൻ കാണിക്കും.';

  @override
  String permissionBlocked(String permission) {
    return '$permission തടഞ്ഞിരിക്കുന്നു. ക്രമീകരണങ്ങളിൽ ഓണാക്കുക.';
  }

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String permissionsMissing(String items) {
    return '$items ഇല്ലാതെ ചില സവിശേഷതകൾ പ്രവർത്തിക്കില്ല. പിന്നീട് അനുവദിക്കാം.';
  }

  @override
  String get modelTitleChoose => 'Gurtu-വിന്റെ ഓൺ-ഡിവൈസ് AI സജ്ജമാക്കുക';

  @override
  String get modelTitleDownloading => 'നിങ്ങളുടെ AI സജ്ജമാകുന്നു…';

  @override
  String get modelTitleDone => 'നിങ്ങളുടെ AI തയ്യാർ';

  @override
  String get modelSubtitleChoose =>
      'ഈ മോഡലുകൾ പൂർണ്ണമായും നിങ്ങളുടെ iQOO-ൽ പ്രവർത്തിക്കുന്നു. കുടുംബത്തിന്റെ ആരോഗ്യവിവരങ്ങൾ ഫോണിന് പുറത്തുപോകില്ല — ഇന്റർനെറ്റ് ഇല്ലാതെയും പ്രവർത്തിക്കും.';

  @override
  String get modelSubtitleDownloading =>
      'നിങ്ങൾക്ക് ഫോൺ ഉപയോഗിച്ചുകൊണ്ടിരിക്കാം. ഇത് ഒരിക്കൽ മാത്രം.';

  @override
  String get modelSubtitleDone =>
      'എല്ലാം ഈ ഫോണിൽ തന്നെ പ്രവർത്തിക്കുന്നു, ഓഫ്‌ലൈനിലും.';

  @override
  String get poweredByIqoo => 'നിങ്ങളുടെ iQOO-യുടെ ശക്തിയിൽ';

  @override
  String get deviceCardSub =>
      'ഓൺ-ഡിവൈസ് AI · സ്വകാര്യം · ഓഫ്‌ലൈനിൽ പ്രവർത്തിക്കും';

  @override
  String get chooseCareModel => 'കെയർ മോഡൽ തിരഞ്ഞെടുക്കുക';

  @override
  String get careModelHint => 'ചോദ്യങ്ങൾക്ക് ഉത്തരം നൽകുന്ന തലച്ചോർ ഇതാണ്.';

  @override
  String get alwaysIncluded => 'എപ്പോഴും ഉൾപ്പെടുന്നു';

  @override
  String get jobListens => 'കേൾക്കുന്നു';

  @override
  String get jobReads => 'വായിക്കുന്നു';

  @override
  String get jobSees => 'കാണുന്നു';

  @override
  String get jobUnderstands => 'മനസ്സിലാക്കുന്നു';

  @override
  String speechModelName(String language) {
    return 'സംസാരം · $language + ഇംഗ്ലീഷ്';
  }

  @override
  String get speechModelWhat =>
      'സംഭാഷണങ്ങളെ നിങ്ങളുടെ ഭാഷയിൽ എഴുത്താക്കി മാറ്റുന്നു.';

  @override
  String get readerModelName => 'ഡോക്യുമെന്റ് റീഡർ (OCR)';

  @override
  String get readerModelWhat =>
      'കുറിപ്പടികൾ, ഡിസ്ചാർജ് പേപ്പറുകൾ, ലാബ് റിപ്പോർട്ടുകൾ വായിക്കുന്നു.';

  @override
  String get visionModelName => 'മരുന്ന് & റീഡിംഗ് തിരിച്ചറിയൽ';

  @override
  String get visionModelWhat =>
      'ഗുളിക സ്ട്രിപ്പുകളും BP / ഷുഗർ മെഷീനിലെ അക്കങ്ങളും തിരിച്ചറിയുന്നു.';

  @override
  String careModelName(String model) {
    return 'കെയർ മോഡൽ · $model';
  }

  @override
  String get tierLite => 'ലൈറ്റ്';

  @override
  String get tierBalanced => 'സന്തുലിതം';

  @override
  String get tierPro => 'പ്രോ';

  @override
  String get tierLiteNote => 'ഏറ്റവും വേഗം. ചെറുതും ലളിതവുമായ ഉത്തരങ്ങൾ.';

  @override
  String get tierBalancedNote =>
      'ശബ്ദം, ഫോട്ടോ, ടെക്സ്റ്റ് എന്നിവ ഒരുമിച്ച് മനസ്സിലാക്കുന്നു.';

  @override
  String get tierProNote => 'ഏറ്റവും വിശദമായ ഉത്തരങ്ങളും ഡോക്ടർ ബ്രീഫുകളും.';

  @override
  String get bestForIqoo => 'iQOO-യ്ക്ക് മികച്ചത്';

  @override
  String get wifiOnly => 'Wi-Fi-ൽ മാത്രം ഡൗൺലോഡ് ചെയ്യുക';

  @override
  String downloadSize(String size) {
    return 'ഡൗൺലോഡ് · $size';
  }

  @override
  String get settingUp => 'സജ്ജമാകുന്നു…';

  @override
  String get ready => 'തയ്യാർ';

  @override
  String allSetName(String name) {
    return 'എല്ലാം തയ്യാർ, $name!';
  }

  @override
  String get allSet => 'എല്ലാം തയ്യാർ!';

  @override
  String get readySelf => 'നിങ്ങളുടെ പരിചരണ ഓർമ്മ തയ്യാറാണ്.';

  @override
  String readyOther(String name) {
    return '$name-ന്റെ പരിചരണ ഓർമ്മ തയ്യാറാണ്. ഇനി കുടുംബത്തെ ക്ഷണിക്കൂ.';
  }

  @override
  String get rowYou => 'നിങ്ങൾ';

  @override
  String get rowCaringFor => 'ആരുടെ പരിചരണം';

  @override
  String get rowHealth => 'ആരോഗ്യം';

  @override
  String get rowAllergies => 'അലർജികൾ';

  @override
  String get rowLanguage => 'ഭാഷ';

  @override
  String get rowAi => 'ഓൺ-ഡിവൈസ് AI';

  @override
  String get notAdded => 'ചേർത്തിട്ടില്ല';

  @override
  String ageYears(int age) {
    return '$age വയസ്സ്';
  }

  @override
  String get careQuote => '“ഒരുമിച്ചാകുമ്പോൾ പരിചരണം ലഘുവാകും.”';

  @override
  String get enterGurtu => 'Gurtu തുറക്കുക';

  @override
  String get nextUpCareCircle => 'അടുത്തത്: കെയർ സർക്കിൾ';

  @override
  String get homeComingSoon => 'ഹോം സ്ക്രീനുകൾ അടുത്ത ഭാഗത്തിൽ വരും.';

  @override
  String get restartOnboarding => 'ഓൺബോർഡിംഗ് വീണ്ടും തുടങ്ങുക';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navMemory => 'ഓർമ്മകൾ';

  @override
  String get navCircle => 'സർക്കിൾ';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'പ്രൊഫൈൽ';

  @override
  String goodMorning(String name) {
    return 'സുപ്രഭാതം, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'ശുഭ ഉച്ച, $name';
  }

  @override
  String goodEvening(String name) {
    return 'ശുഭ സായാഹ്നം, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu-ലേക്ക് സ്വാഗതം, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'നിങ്ങളുടെ കുടുംബത്തിന്റെ ആരോഗ്യം, എല്ലാവരും ഒരുമിച്ച് ഓർക്കാം.';

  @override
  String get caringFor => 'പരിചരണം';

  @override
  String get switchPatientTitle => 'നിങ്ങൾ ആരെയാണ് പരിചരിക്കുന്നത്?';

  @override
  String get addAnotherPerson => 'മറ്റൊരാളെ ചേർക്കുക';

  @override
  String get statusOnTrack => 'പരിചരണം ശരിയായി നടക്കുന്നു';

  @override
  String get statusNeedsAttention => 'ഒരു കാര്യം ശ്രദ്ധിക്കണം';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'അടിയന്തരം';

  @override
  String get sosHoldTitle => 'കെയർ സർക്കിളിനെ അറിയിക്കാൻ അമർത്തിപ്പിടിക്കുക';

  @override
  String get sosHoldBody =>
      'ബട്ടൺ 2 സെക്കൻഡ് അമർത്തിപ്പിടിക്കുക. നിങ്ങളുടെ അടിയന്തര കോൺടാക്റ്റുകൾക്ക് അലേർട്ട് പോകും.';

  @override
  String get sosHoldButton => 'SOS അയയ്ക്കാൻ അമർത്തിപ്പിടിക്കുക';

  @override
  String get sosKeepHolding => 'പിടിച്ചുകൊണ്ടിരിക്കൂ…';

  @override
  String get sosPreviewNote =>
      'അടിയന്തര അലേർട്ടുകൾ ഇതുവരെ ബന്ധിപ്പിച്ചിട്ടില്ല. ഇത് ഒരു പ്രിവ്യൂ മാത്രം — ആർക്കും അലേർട്ട് പോകില്ല.';

  @override
  String get sosPreviewDone => 'പ്രിവ്യൂ കഴിഞ്ഞു. ആർക്കും അലേർട്ട് പോയില്ല.';

  @override
  String get close => 'അടയ്ക്കുക';

  @override
  String get todayCare => 'ഇന്നത്തെ പരിചരണം';

  @override
  String completedOf(int done, int total) {
    return '$total-ൽ $done പൂർത്തിയായി';
  }

  @override
  String get viewTodayCare => 'ഇന്നത്തെ പരിചരണം കാണുക';

  @override
  String get nothingUrgent => 'ഇപ്പോൾ അടിയന്തരമായി ഒന്നുമില്ല.';

  @override
  String get markDone => 'പൂർത്തിയായി എന്ന് അടയാളപ്പെടുത്തുക';

  @override
  String get markNotDone => 'പൂർത്തിയായില്ല എന്ന് അടയാളപ്പെടുത്തുക';

  @override
  String get openToCircle => 'കെയർ സർക്കിളിന് തുറന്നത്';

  @override
  String get captureCare => 'പരിചരണം രേഖപ്പെടുത്തുക';

  @override
  String get captureCareSubtitle =>
      'പരിചരണത്തിലെ പ്രധാനപ്പെട്ട ഒരു കാര്യം രേഖപ്പെടുത്തുക.';

  @override
  String get whatHappened => 'എന്താണ് സംഭവിച്ചത്?';

  @override
  String get captureVoice => 'ശബ്ദം';

  @override
  String get captureVoiceHint => 'സംഭാഷണമോ വോയ്സ് നോട്ടോ റെക്കോർഡ് ചെയ്യുക';

  @override
  String get captureScan => 'സ്കാൻ';

  @override
  String get captureScanHint => 'കുറിപ്പടി അല്ലെങ്കിൽ ഗുളിക സ്ട്രിപ്പ്';

  @override
  String get captureVital => 'റീഡിംഗ്';

  @override
  String get captureVitalHint => 'BP, ഷുഗർ അല്ലെങ്കിൽ താപനില';

  @override
  String get captureDocument => 'ഡോക്യുമെന്റ്';

  @override
  String get captureDocumentHint =>
      'ഡിസ്ചാർജ് പേപ്പർ അല്ലെങ്കിൽ ലാബ് റിപ്പോർട്ട്';

  @override
  String get captureNote => 'കുറിപ്പ്';

  @override
  String get captureNoteHint => 'സംഭവിച്ചത് എഴുതുക';

  @override
  String get comingSoon => 'ഉടൻ വരുന്നു';

  @override
  String get noteHint => 'ഉദാ. നടന്ന ശേഷം തലകറങ്ങി';

  @override
  String get saveNote => 'കുറിപ്പ് സേവ് ചെയ്യുക';

  @override
  String get noteSaved => 'പരിചരണ ഓർമ്മയിൽ സേവ് ചെയ്തു';

  @override
  String get recentMemory => 'സമീപകാല ഓർമ്മകൾ';

  @override
  String get viewAll => 'എല്ലാം കാണുക';

  @override
  String get emptyMemory => 'നിങ്ങളുടെ പരിചരണ കഥ ഇവിടെ തുടങ്ങുന്നു.';

  @override
  String addedBy(String name) {
    return '$name ചേർത്തത്';
  }

  @override
  String get sourcePlay => 'കേൾക്കുക';

  @override
  String get sourceView => 'കാണുക';

  @override
  String get sourceOpen => 'തുറക്കുക';

  @override
  String get sourceTitle => 'ഉറവിടം';

  @override
  String get sourceRecording => 'ഡോക്ടർ റെക്കോർഡിംഗ്';

  @override
  String get sourceScan => 'കുറിപ്പടി സ്കാൻ';

  @override
  String get sourceVital => 'റീഡിംഗ്';

  @override
  String get sourceDocument => 'ഡോക്യുമെന്റ്';

  @override
  String get sourceNote => 'എഴുതിയ കുറിപ്പ്';

  @override
  String get sourceSampleNote =>
      'ഇത് സാമ്പിൾ ഡാറ്റയാണ്, അതിനാൽ യഥാർത്ഥ ഫയൽ ഇല്ല. യഥാർത്ഥ റെക്കോർഡിംഗുകളും സ്കാനുകളും ഇവിടെ തുറക്കും.';

  @override
  String get yourCareCircle => 'നിങ്ങളുടെ കെയർ സർക്കിൾ';

  @override
  String get manageCircle => 'സർക്കിൾ നിയന്ത്രിക്കുക';

  @override
  String get emptyCircle => 'ഒരുമിച്ചാകുമ്പോൾ പരിചരണം എളുപ്പമാണ്.';

  @override
  String get addFamilyMember => 'കുടുംബാംഗത്തെ ചേർക്കുക';

  @override
  String get rolePatient => 'രോഗി';

  @override
  String get roleCaregiver => 'പരിചാരകർ';

  @override
  String get roleFamily => 'കുടുംബം';

  @override
  String get roleHelper => 'വിശ്വസ്ത സഹായി';

  @override
  String get askGurtuTitle => 'Gurtu-വിനോട് ചോദിക്കൂ';

  @override
  String get askGurtuPrompt => 'എന്തെങ്കിലും ഓർക്കാൻ സഹായം വേണോ?';

  @override
  String get askExampleBloodTest => 'രക്തപരിശോധന എപ്പോഴാണ്?';

  @override
  String get askExampleDoctor => 'നാളെ ഡോക്ടറോട് എന്ത് ചോദിക്കണം?';

  @override
  String get askGurtuNote =>
      'ഉത്തരങ്ങൾ നിങ്ങൾ സേവ് ചെയ്ത പരിചരണ വിവരങ്ങളിൽ നിന്നാണ്.';

  @override
  String get gettingReady => 'Gurtu തയ്യാറാകുന്നു';

  @override
  String get readyYourProfile => 'നിങ്ങളുടെ പ്രൊഫൈൽ';

  @override
  String get readyPatientProfile => 'രോഗിയുടെ പ്രൊഫൈൽ';

  @override
  String get readyCareCircle => 'കെയർ സർക്കിൾ';

  @override
  String get readyEmergencyContact => 'അടിയന്തര കോൺടാക്റ്റ്';

  @override
  String get previewSampleData => 'സാമ്പിൾ ഡാറ്റയോടെ കാണുക';

  @override
  String get sampleDataOn => 'സാമ്പിൾ പരിചരണ ഡാറ്റ കാണിക്കുന്നു';

  @override
  String get remove => 'നീക്കം ചെയ്യുക';

  @override
  String get hide => 'മറയ്ക്കുക';

  @override
  String get comingNextPhase => 'ഈ ഭാഗം അടുത്തതായി നിർമ്മിക്കുന്നു.';

  @override
  String get fatherName => 'അച്ഛൻ';

  @override
  String get sampleTaskMorningMedicine => 'രാവിലത്തെ മരുന്ന്';

  @override
  String get sampleTaskRecordBp => 'BP രേഖപ്പെടുത്തുക';

  @override
  String get sampleTaskBloodTest => 'രക്തപരിശോധന';

  @override
  String get sampleTaskDoctorVisit => 'ഡോക്ടർ അപ്പോയിന്റ്മെന്റ്';

  @override
  String get sampleMomentDoctorTalk => 'ഡോക്ടറുമായുള്ള സംഭാഷണം';

  @override
  String get sampleMomentDoctorTalkDetail =>
      '“പ്രാതലിന് ശേഷം മരുന്ന് കഴിക്കുക.”';

  @override
  String get sampleMomentPrescription => 'കുറിപ്പടി സ്കാൻ ചെയ്തു';

  @override
  String get sampleMomentPrescriptionDetail => '2 മരുന്നുകൾ കണ്ടെത്തി';

  @override
  String get sampleMomentBp => 'BP രേഖപ്പെടുത്തി';

  @override
  String get today => 'ഇന്ന്';

  @override
  String get yesterday => 'ഇന്നലെ';
}
