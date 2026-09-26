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

  @override
  String get doctorVisit => 'ഡോക്ടർ സന്ദർശനം';

  @override
  String get doctorVisitHint => 'ഡോക്ടർ പറയുന്നത് കുറിച്ചുവെക്കുക';

  @override
  String get askDoctor => 'ഡോക്ടറോട് ചോദിക്കേണ്ടവ';

  @override
  String get askDoctorHint => 'തയ്യാറെടുക്കാൻ Gurtu സഹായിക്കും';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ചോദ്യങ്ങൾ തയ്യാർ',
      one: '1 ചോദ്യം തയ്യാർ',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'അവസാന സന്ദർശനം: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'അടുത്ത സന്ദർശനം: $date';
  }

  @override
  String get visitsTitle => 'ഡോക്ടർ സന്ദർശനങ്ങൾ';

  @override
  String get visitsSubtitle => 'ഓരോ ഡോക്ടറും പറഞ്ഞത്, എല്ലാം ഒരിടത്ത്.';

  @override
  String get recordVisit => 'സന്ദർശനം രേഖപ്പെടുത്തുക';

  @override
  String get visitsOverview => 'എല്ലാ സന്ദർശനങ്ങളും ഒറ്റനോട്ടത്തിൽ';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count സന്ദർശനങ്ങൾ',
      one: '1 സന്ദർശനം',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ഡോക്ടർമാർ',
      one: '1 ഡോക്ടർ',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'അവസാന സന്ദർശനം';

  @override
  String get nextVisit => 'അടുത്ത സന്ദർശനം';

  @override
  String get notPlanned => 'ഇതുവരെ തീരുമാനിച്ചിട്ടില്ല';

  @override
  String get pastVisits => 'മുൻ സന്ദർശനങ്ങൾ';

  @override
  String get noVisitsTitle => 'ഇതുവരെ സന്ദർശനങ്ങളൊന്നും രേഖപ്പെടുത്തിയിട്ടില്ല';

  @override
  String get noVisitsBody =>
      'അടുത്ത അപ്പോയിന്റ്മെന്റിൽ ‘സന്ദർശനം രേഖപ്പെടുത്തുക’ അമർത്തുക, ഡോക്ടർ പറയുന്നത് Gurtu കുറിച്ചുവെക്കും.';

  @override
  String get questionsForNextVisit => 'അടുത്ത സന്ദർശനത്തിനുള്ള ചോദ്യങ്ങൾ';

  @override
  String get prepareQuestionsHint =>
      'നിങ്ങൾക്ക് എങ്ങനെയുണ്ടെന്ന് Gurtu-വിനോട് പറയൂ. ഡോക്ടറോട് എന്ത് ചോദിക്കണമെന്ന് നിർദ്ദേശിക്കും.';

  @override
  String get prepareQuestions => 'ചോദ്യങ്ങൾ തയ്യാറാക്കുക';

  @override
  String get viewQuestions => 'ചോദ്യങ്ങൾ കാണുക';

  @override
  String get doctorFallback => 'ഡോക്ടർ';

  @override
  String get doctorSaid => 'ഡോക്ടർ പറഞ്ഞത്';

  @override
  String get medicinesSection => 'മരുന്നുകൾ';

  @override
  String get testsSection => 'ചെയ്യേണ്ട പരിശോധനകൾ';

  @override
  String get questionsAsked => 'ചോദിച്ച ചോദ്യങ്ങൾ';

  @override
  String askedOf(int asked, int total) {
    return '$total-ൽ $asked ചോദിച്ചു';
  }

  @override
  String get deleteVisit => 'സന്ദർശനം ഇല്ലാതാക്കുക';

  @override
  String get deleteVisitConfirm =>
      'ഈ സന്ദർശനം ഇല്ലാതാക്കണോ? ഇത് തിരികെ കിട്ടില്ല.';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get doctorName => 'ഡോക്ടറുടെ പേര്';

  @override
  String get doctorNameHint => 'ഉദാ. ഡോ. മീന റാവു';

  @override
  String get visitReason => 'സന്ദർശനത്തിന്റെ കാരണം';

  @override
  String get visitReasonHint => 'ഉദാ. ഷുഗർ പരിശോധന';

  @override
  String get visitDate => 'സന്ദർശന തീയതി';

  @override
  String get listenToDoctor => 'ഡോക്ടർ പറയുന്നത് കേൾക്കുക';

  @override
  String get stopListening => 'കേൾക്കുന്നത് നിർത്തുക';

  @override
  String get speak => 'സംസാരിക്കുക';

  @override
  String get recordingConsent =>
      'Gurtu ഉപയോഗിച്ച് സംഭാഷണം കുറിക്കുന്നുണ്ടെന്ന് ഡോക്ടറെ അറിയിക്കുക.';

  @override
  String get doctorSaidHint =>
      'ഡോക്ടർ പറയുന്നത് സംസാരിക്കുക അല്ലെങ്കിൽ ടൈപ്പ് ചെയ്യുക';

  @override
  String get medicinesHint => 'ഉദാ. മെറ്റ്ഫോർമിൻ 500 mg പ്രാതലിന് ശേഷം';

  @override
  String get testsHint => 'ഉദാ. HbA1c രക്തപരിശോധന';

  @override
  String get addNextVisit => 'അടുത്ത സന്ദർശന തീയതി ചേർക്കുക';

  @override
  String get yourQuestions => 'നിങ്ങളുടെ ചോദ്യങ്ങൾ';

  @override
  String get tickWhenAsked => 'ഡോക്ടർ മറുപടി പറഞ്ഞാൽ ഓരോന്നും ടിക്ക് ചെയ്യുക.';

  @override
  String get saveVisit => 'സന്ദർശനം സേവ് ചെയ്യുക';

  @override
  String get visitSaved => 'സന്ദർശനം സേവ് ചെയ്തു';

  @override
  String get leaveVisitTitle => 'സേവ് ചെയ്യാതെ പോകണോ?';

  @override
  String get leaveVisitBody => 'ഈ സന്ദർശനത്തിനായി കുറിച്ചത് നഷ്ടപ്പെടും.';

  @override
  String get discard => 'ഉപേക്ഷിക്കുക';

  @override
  String get keepEditing => 'എഴുത്ത് തുടരുക';

  @override
  String get voiceUnavailable =>
      'ഇപ്പോൾ വോയ്സ് ഇൻപുട്ട് ലഭ്യമല്ല. നിങ്ങൾക്ക് ടൈപ്പ് ചെയ്യാം.';

  @override
  String get prepTitle => 'ഡോക്ടറെ കാണാൻ തയ്യാറെടുക്കാം';

  @override
  String get prepIntro =>
      'ഡോക്ടറെ കാണാൻ തയ്യാറെടുക്കാം. ഏതൊക്കെ ആരോഗ്യപ്രശ്നങ്ങളെക്കുറിച്ച് സംസാരിക്കണം?';

  @override
  String get prepPickOrSay =>
      'താഴെ പ്രശ്നങ്ങൾ തിരഞ്ഞെടുക്കുക, അല്ലെങ്കിൽ സ്വന്തം വാക്കുകളിൽ പറയുക.';

  @override
  String get prepDescribeHint => 'ഉദാ. മൂന്ന് ദിവസമായി തലവേദന, ക്ഷീണം';

  @override
  String prepHeard(String symptoms) {
    return 'ഞാൻ കേട്ടത്: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — എപ്പോൾ മുതൽ?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — എത്ര കഠിനമാണ്?';
  }

  @override
  String get askNewMedicine =>
      'അടുത്തിടെ ഏതെങ്കിലും മരുന്ന് തുടങ്ങുകയോ മാറ്റുകയോ ചെയ്തോ?';

  @override
  String get askAnythingElse => 'ഡോക്ടറോട് മറ്റെന്തെങ്കിലും പറയാനുണ്ടോ?';

  @override
  String get urgentWarning =>
      'കഠിനമായ നെഞ്ചുവേദനയോ ശ്വാസംമുട്ടലോ അടിയന്തരാവസ്ഥയാകാം. അപ്പോയിന്റ്മെന്റിനായി കാത്തിരിക്കരുത് — ഉടൻ വൈദ്യസഹായം തേടുക.';

  @override
  String get prepThinking => 'നിങ്ങളുടെ ചോദ്യങ്ങൾ തയ്യാറാക്കുന്നു…';

  @override
  String get prepResultIntro =>
      'ഡോക്ടറോട് ഇവ ചോദിക്കുക. ആവശ്യമില്ലാത്തവ നീക്കുക, അല്ലെങ്കിൽ നിങ്ങളുടെ ചോദ്യം ചേർക്കുക.';

  @override
  String get prepNotDoctor =>
      'Gurtu ഡോക്ടറല്ല. ഈ ചോദ്യങ്ങൾ ഡോക്ടറോട് സംസാരിക്കാൻ സഹായിക്കും.';

  @override
  String get addOwnQuestion => 'സ്വന്തം ചോദ്യം ചേർക്കുക';

  @override
  String get add => 'ചേർക്കുക';

  @override
  String get saveQuestions => 'സന്ദർശനത്തിനായി സേവ് ചെയ്യുക';

  @override
  String get questionsSaved => 'ചോദ്യങ്ങൾ സന്ദർശനത്തിനായി സേവ് ചെയ്തു';

  @override
  String get startAgain => 'വീണ്ടും തുടങ്ങുക';

  @override
  String get startVisit => 'സന്ദർശനം തുടങ്ങുക';

  @override
  String get deleteQuestions => 'ഈ ചോദ്യങ്ങൾ ഇല്ലാതാക്കുക';

  @override
  String get removeQuestion => 'ചോദ്യം നീക്കുക';

  @override
  String get done => 'കഴിഞ്ഞു';

  @override
  String get healthProblems => 'ആരോഗ്യപ്രശ്നങ്ങൾ';

  @override
  String preparedOn(String date) {
    return '$date-ന് തയ്യാറാക്കിയത്';
  }

  @override
  String get symFever => 'പനി';

  @override
  String get symHeadache => 'തലവേദന';

  @override
  String get symBodyPain => 'ശരീരവേദന അല്ലെങ്കിൽ സന്ധിവേദന';

  @override
  String get symChestPain => 'നെഞ്ചുവേദന';

  @override
  String get symBreathless => 'ശ്വാസംമുട്ടൽ';

  @override
  String get symCough => 'ചുമ';

  @override
  String get symDizziness => 'തലകറക്കം';

  @override
  String get symTiredness => 'ക്ഷീണം';

  @override
  String get symStomach => 'വയറിന്റെ പ്രശ്നം';

  @override
  String get symPoorSleep => 'ഉറക്കക്കുറവ്';

  @override
  String get symPoorAppetite => 'വിശപ്പില്ലായ്മ';

  @override
  String get symLowMood => 'വിഷമം അല്ലെങ്കിൽ ഉത്കണ്ഠ';

  @override
  String get kwFever => 'പനി,ജ്വരം,കുളിര്';

  @override
  String get kwHeadache => 'തലവേദന,തല വേദന';

  @override
  String get kwBodyPain =>
      'ശരീരവേദന,ദേഹവേദന,സന്ധിവേദന,മുട്ടുവേദന,മുട്ട്,നടുവേദന,കാൽവേദന';

  @override
  String get kwChestPain => 'നെഞ്ചുവേദന,നെഞ്ച്,നെഞ്ചിൽ';

  @override
  String get kwBreathless => 'ശ്വാസം,ശ്വാസംമുട്ട്,കിതപ്പ്';

  @override
  String get kwCough => 'ചുമ,കഫം,ജലദോഷം';

  @override
  String get kwDizziness => 'തലകറക്കം,തല കറങ്ങുന്നു,ബോധക്കേട്';

  @override
  String get kwTiredness => 'ക്ഷീണം,തളർച്ച,ബലക്കുറവ്';

  @override
  String get kwStomach =>
      'വയറ്,വയറിൽ,അസിഡിറ്റി,ഗ്യാസ്,ഛർദ്ദി,വയറിളക്കം,മലബന്ധം,ഓക്കാനം';

  @override
  String get kwPoorSleep => 'ഉറക്കം,ഉറക്കമില്ല';

  @override
  String get kwPoorAppetite => 'വിശപ്പ്,കഴിക്കാൻ തോന്നുന്നില്ല';

  @override
  String get kwLowMood => 'വിഷമം,ഉത്കണ്ഠ,പേടി,ടെൻഷൻ,സമ്മർദ്ദം,സങ്കടം';

  @override
  String get sinceToday => 'ഇന്ന് മുതൽ';

  @override
  String get sinceFewDays => 'കുറച്ച് ദിവസമായി';

  @override
  String get sinceWeek => 'ഏകദേശം ഒരാഴ്ചയായി';

  @override
  String get sinceMonth => 'ഒരു മാസമോ അതിലധികമോ';

  @override
  String get sevMild => 'നേരിയത്';

  @override
  String get sevModerate => 'മിതമായത്';

  @override
  String get sevSevere => 'കഠിനം';

  @override
  String qCause(String symptom) {
    return '$symptom ഉണ്ടാകാൻ കാരണം എന്തായിരിക്കാം?';
  }

  @override
  String qTests(String symptom) {
    return '$symptom-ന് എന്തെങ്കിലും പരിശോധന വേണോ?';
  }

  @override
  String qWarningSigns(String symptom) {
    return '$symptom-നൊപ്പം ഏതൊക്കെ ലക്ഷണങ്ങൾ കണ്ടാൽ ഉടൻ തിരികെ വരണം?';
  }

  @override
  String qHomeCare(String symptom) {
    return '$symptom കുറയ്ക്കാൻ വീട്ടിൽ എന്ത് ചെയ്യാം?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return '$symptom-ന് $conditions-മായി ബന്ധമുണ്ടാകുമോ?';
  }

  @override
  String get qSideEffect => 'പുതിയതോ മാറ്റിയതോ ആയ മരുന്ന് കാരണമാണോ ഇത്?';

  @override
  String get qMedicinesStillRight =>
      'ഇപ്പോഴത്തെ മരുന്നുകൾ ശരിയാണോ, അതോ എന്തെങ്കിലും മാറ്റണോ?';

  @override
  String get qNextCheckup => 'അടുത്ത പരിശോധനയ്ക്ക് എപ്പോൾ വരണം?';

  @override
  String qTellDoctor(String text) {
    return 'ഡോക്ടറോട് പറയുക: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'പ്രമേഹ പുനഃപരിശോധന';

  @override
  String get sampleVisitDiabetesNotes =>
      'ഷുഗർ മുമ്പത്തേക്കാൾ നന്നായി നിയന്ത്രണത്തിലാണ്. അതേ മരുന്നുകൾ തുടരുക. ദിവസവും 30 മിനിറ്റ് നടക്കുക, മധുരം കുറയ്ക്കുക.';

  @override
  String get sampleVisitDiabetesMeds =>
      'മെറ്റ്ഫോർമിൻ 500 mg പ്രാതലിനും അത്താഴത്തിനും ശേഷം';

  @override
  String get sampleVisitDiabetesTests =>
      'അടുത്ത സന്ദർശനത്തിന് മുമ്പ് HbA1c രക്തപരിശോധന';

  @override
  String get sampleVisitKneeReason => 'മുട്ടുവേദന';

  @override
  String get sampleVisitKneeNotes =>
      'വലത് മുട്ടിൽ നേരിയ സന്ധിവാതം. വൈകുന്നേരം ചൂടുപിടിക്കുക, അധികം പടികൾ കയറുന്നത് ഒഴിവാക്കുക.';

  @override
  String get sampleVisitKneeMeds => 'വേദനസംഹാരി ജെൽ ദിവസം രണ്ടുതവണ';

  @override
  String get scanVerify => 'മരുന്ന് സ്കാൻ ചെയ്ത് ഉറപ്പാക്കുക';

  @override
  String get scanVerifyHint => 'ഈ ഗുളികയാണോ ഇപ്പോൾ കഴിക്കേണ്ടത്?';

  @override
  String scanVerifySubtitle(String name) {
    return 'സ്ട്രിപ്പോ പെട്ടിയോ സ്കാൻ ചെയ്യുക. Gurtu അത് $name-ന്റെ മരുന്ന് പട്ടികയുമായി ഒത്തുനോക്കും.';
  }

  @override
  String get scanWithCamera => 'മരുന്ന് സ്കാൻ ചെയ്യുക';

  @override
  String get orTypeName => 'അല്ലെങ്കിൽ സ്ട്രിപ്പിലെ പേര് ടൈപ്പ് ചെയ്യുക';

  @override
  String get typeNameHint => 'ഉദാ. Glycomet 500';

  @override
  String get checkMedicine => 'പരിശോധിക്കുക';

  @override
  String get checkAnother => 'മറ്റൊരു മരുന്ന് പരിശോധിക്കുക';

  @override
  String get readingStrip => 'സ്ട്രിപ്പ് വായിക്കുന്നു…';

  @override
  String get cameraUnavailable =>
      'ക്യാമറ സ്കാൻ ഫോൺ ആപ്പിൽ പ്രവർത്തിക്കും. ഇപ്പോൾ പേര് ടൈപ്പ് ചെയ്യുക.';

  @override
  String get scanFailed =>
      'ഫോട്ടോ വായിക്കാനായില്ല. വീണ്ടും ശ്രമിക്കുക, അല്ലെങ്കിൽ പേര് ടൈപ്പ് ചെയ്യുക.';

  @override
  String readFromStrip(String text) {
    return 'സ്ട്രിപ്പിൽ വായിച്ചത്: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'നിങ്ങൾ സേവ് ചെയ്ത മരുന്നുകളുമായി മാത്രമേ Gurtu ഒത്തുനോക്കൂ. അത് ഒരിക്കലും മരുന്ന് നിർദ്ദേശിക്കില്ല.';

  @override
  String get verdictTakeNow => 'അതെ — ഇതാണ് ശരിയായ മരുന്ന്, ഇപ്പോൾ കഴിക്കാം.';

  @override
  String get verdictNotNow =>
      'മരുന്ന് ശരിയാണ്, പക്ഷേ ഇപ്പോൾ കഴിക്കേണ്ട സമയമല്ല.';

  @override
  String get verdictAlreadyTaken =>
      'ഈ ഡോസ് ഇതിനകം കഴിച്ചു. വീണ്ടും കഴിക്കരുത്.';

  @override
  String get verdictNoTimes =>
      'മരുന്ന് ശരിയാണ്, പക്ഷേ ഇതിന്റെ സമയം സേവ് ചെയ്തിട്ടില്ല.';

  @override
  String get verdictWrongStrength =>
      'നിർത്തുക — അളവ് (mg) കുറിപ്പടിയിൽ നിന്ന് വ്യത്യസ്തമാണ്.';

  @override
  String verdictNotOnList(String name) {
    return 'നിർത്തുക — ഈ മരുന്ന് $name-ന്റെ പട്ടികയിലില്ല.';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'നിർത്തുക — ഈ മരുന്ന് $other-ന്റെ പട്ടികയിലേതാണ്, $name-ന്റേതല്ല.';
  }

  @override
  String get verdictUnreadable =>
      'മരുന്നിന്റെ പേര് വായിക്കാനായില്ല. നല്ല വെളിച്ചത്തിൽ വീണ്ടും ശ്രമിക്കുക, അല്ലെങ്കിൽ ടൈപ്പ് ചെയ്യുക.';

  @override
  String get verdictCheckFirst =>
      'ഡോക്ടറോടോ ഫാർമസിസ്റ്റിനോടോ ചോദിക്കാതെ കഴിക്കരുത്.';

  @override
  String get rowOnList => 'മരുന്ന് പട്ടികയിലുണ്ട്';

  @override
  String rowStrengthMatches(String strength) {
    return 'അളവ് ഒക്കുന്നു: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'സ്ട്രിപ്പിൽ $found, കുറിപ്പടിയിൽ $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'ഇപ്പോൾ കഴിക്കേണ്ടത്: $slot ഡോസ്';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot ഡോസ് $time-ന് കഴിച്ചു';
  }

  @override
  String rowNextDose(String slot) {
    return 'അടുത്ത ഡോസ്: $slot';
  }

  @override
  String get rowSetTimes => 'മരുന്ന് പട്ടികയിൽ എപ്പോൾ കഴിക്കണമെന്ന് ചേർക്കുക';

  @override
  String get markTaken => 'കഴിച്ചതായി രേഖപ്പെടുത്തുക';

  @override
  String get markedTaken => 'ഡോസ് രേഖപ്പെടുത്തി';

  @override
  String get undo => 'പഴയപടിയാക്കുക';

  @override
  String get medicineList => 'മരുന്ന് പട്ടിക';

  @override
  String get medicineListSubtitle =>
      'കുറിപ്പടികളിലെ ഓരോ മരുന്നും, എപ്പോൾ കഴിക്കണമെന്നതും.';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മരുന്നുകൾ',
      one: '1 മരുന്ന്',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'മരുന്ന് ചേർക്കുക';

  @override
  String get editMedicine => 'മരുന്ന് തിരുത്തുക';

  @override
  String get addFromPrescription => 'കുറിപ്പടി ഫോട്ടോയിൽ നിന്ന് ചേർക്കുക';

  @override
  String get noMedicinesTitle => 'ഇതുവരെ മരുന്നുകൾ ചേർത്തിട്ടില്ല';

  @override
  String get noMedicinesBody =>
      'കുറിപ്പടിയിലെ ഓരോ മരുന്നും ഒരിക്കൽ ചേർക്കുക. പിന്നെ ഏത് സ്ട്രിപ്പും സ്കാൻ ചെയ്ത് ശരിയാണോ എന്ന് നോക്കാം.';

  @override
  String addMedicinesFirst(String name) {
    return 'ആദ്യം $name-ന്റെ മരുന്നുകൾ ചേർക്കുക, അപ്പോൾ Gurtu-വിന് അവയുമായി ഒത്തുനോക്കാം.';
  }

  @override
  String get medicineName => 'മരുന്നിന്റെ പേര്';

  @override
  String get medicineNameHint => 'ഉദാ. Metformin';

  @override
  String get alsoCalled => 'സ്ട്രിപ്പിലെ മറ്റൊരു പേര്';

  @override
  String get alsoCalledHint => 'ഉദാ. Glycomet';

  @override
  String get strength => 'അളവ്';

  @override
  String get strengthHint => 'ഉദാ. 500 mg';

  @override
  String get whenToTake => 'എപ്പോൾ കഴിക്കണം';

  @override
  String get doseMorning => 'രാവിലെ';

  @override
  String get doseAfternoon => 'ഉച്ചയ്ക്ക്';

  @override
  String get doseEvening => 'വൈകുന്നേരം';

  @override
  String get doseNight => 'രാത്രി';

  @override
  String get foodAfter => 'ഭക്ഷണത്തിന് ശേഷം';

  @override
  String get foodBefore => 'ഭക്ഷണത്തിന് മുമ്പ്';

  @override
  String get foodAny => 'ഭക്ഷണത്തോടൊപ്പമോ അല്ലാതെയോ';

  @override
  String get saveMedicine => 'മരുന്ന് സേവ് ചെയ്യുക';

  @override
  String get medicineSaved => 'മരുന്ന് സേവ് ചെയ്തു';

  @override
  String get deleteMedicine => 'മരുന്ന് ഇല്ലാതാക്കുക';

  @override
  String get deleteMedicineConfirm => 'ഈ മരുന്ന് പട്ടികയിൽ നിന്ന് നീക്കണോ?';

  @override
  String get scanToFill => 'സ്ട്രിപ്പ് സ്കാൻ ചെയ്ത് പൂരിപ്പിക്കുക';

  @override
  String get timesNotSet => 'സമയം നിശ്ചയിച്ചിട്ടില്ല';

  @override
  String get takenToday => 'ഇന്ന് കഴിച്ചവ';

  @override
  String get prescriptionTitle => 'കുറിപ്പടിയിൽ നിന്ന് ചേർക്കുക';

  @override
  String get prescriptionHint =>
      'അച്ചടിച്ച കുറിപ്പടിയുടെ വ്യക്തമായ ഫോട്ടോ എടുക്കുക. Gurtu മരുന്നുകൾ കണ്ടെത്തും; ഏതൊക്കെ ചേർക്കണമെന്ന് നിങ്ങൾ തിരഞ്ഞെടുക്കുക.';

  @override
  String get takePhoto => 'ഫോട്ടോ എടുക്കുക';

  @override
  String get chooseFromGallery => 'ഗാലറിയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get medicinesFound => 'കണ്ടെത്തിയ മരുന്നുകൾ';

  @override
  String get tickToAdd =>
      'ചേർക്കേണ്ടവ ടിക്ക് ചെയ്യുക. ഓരോ പേരും സമയവും കുറിപ്പടിയുമായി ഒത്തുനോക്കുക.';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മരുന്നുകൾ ചേർക്കുക',
      one: '1 മരുന്ന് ചേർക്കുക',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'മരുന്നുകളൊന്നും കണ്ടെത്തിയില്ല. വ്യക്തമായ ഫോട്ടോ എടുക്കുക, അല്ലെങ്കിൽ കൈകൊണ്ട് ചേർക്കുക.';

  @override
  String get handwrittenNote =>
      'കൈയെഴുത്ത് കുറിപ്പടികൾ ശരിയായി വായിക്കാനായേക്കില്ല. ഓരോ പേരും പരിശോധിക്കുക.';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മരുന്നുകൾ ചേർത്തു',
      one: '1 മരുന്ന് ചേർത്തു',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'സ്ട്രിപ്പിൽ $strength എന്നുണ്ടോ എന്ന് നോക്കുക';
  }
}
