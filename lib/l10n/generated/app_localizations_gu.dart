// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get continueLabel => 'આગળ વધો';

  @override
  String get next => 'આગળ';

  @override
  String get skip => 'છોડો';

  @override
  String get later => 'પછી';

  @override
  String get back => 'પાછળ';

  @override
  String get optional => 'વૈકલ્પિક';

  @override
  String get yes => 'હા';

  @override
  String get no => 'ના';

  @override
  String get notSure => 'ખબર નથી';

  @override
  String get tagline => 'યાદ રાખો. કાળજી લો. સાથે મળીને.';

  @override
  String get motherName => 'બા';

  @override
  String get phaseAbout => 'પરિચય';

  @override
  String get phaseHealth => 'આરોગ્ય';

  @override
  String get phasePermissions => 'પરવાનગીઓ';

  @override
  String get phaseAi => 'AI સેટઅપ';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $totalમાંથી $current';
  }

  @override
  String get languageTitle => 'તમારી ભાષા પસંદ કરો';

  @override
  String get languageSubtitle => 'Gurtu આ જ ભાષામાં બોલશે, સાંભળશે અને લખશે.';

  @override
  String get languageMixNote =>
      'ડૉક્ટર ઘણીવાર તમારી ભાષામાં અંગ્રેજી ભેળવીને બોલે છે. Gurtu બંને સાથે સમજે છે.';

  @override
  String get welcomeTitle => 'તમારા પરિવારની\nકાળજીની યાદ';

  @override
  String get welcomeBody =>
      'ડૉક્ટરે શું કહ્યું, કઈ દવા લખી અને ઘરે શું થયું — બધું સાથે મળીને યાદ રાખો.';

  @override
  String get welcomeScript => 'અલગ ભૂમિકાઓ. એક જ પ્રેમ.';

  @override
  String get getStarted => 'શરૂ કરો';

  @override
  String builtForBrand(String brand) {
    return '$brand માટે બનાવેલ';
  }

  @override
  String get madeInHyderabad => 'હૈદરાબાદમાં બનેલ';

  @override
  String get introRecordEyebrow => '1 · રેકોર્ડ કરો';

  @override
  String get introRecordTitle => 'ડૉક્ટરે કહેલું ક્યારેય ન ભૂલો';

  @override
  String get introRecordBody =>
      'બધાની સંમતિથી ડૉક્ટર, નર્સ અથવા ફાર્માસિસ્ટની વાત રેકોર્ડ કરો. મહત્વની વાતો Gurtu સાચવી રાખે છે.';

  @override
  String get introPlanEyebrow => '2 · સમજો અને વહેંચો';

  @override
  String get introPlanTitle => 'આખા પરિવાર માટે એક કાળજી યોજના';

  @override
  String get introPlanBody =>
      'પ્રિસ્ક્રિપ્શન અને રિપોર્ટ સ્કેન કરો. Gurtu તેને પરિવાર વહેંચી શકે એવા સરળ કામોમાં ફેરવે છે.';

  @override
  String get introAskEyebrow => '3 · પૂછો અને યાદ રાખો';

  @override
  String get introAskTitle => 'કંઈ પણ પૂછો, પુરાવો જુઓ';

  @override
  String get introAskBody =>
      'દરેક જવાબ બતાવે છે કે તે ક્યાંથી આવ્યો — રેકોર્ડિંગ, પ્રિસ્ક્રિપ્શન કે ફોટો.';

  @override
  String get letsSetUp => 'સેટઅપ કરીએ';

  @override
  String get hospitalMode => 'હૉસ્પિટલ મોડ';

  @override
  String get consentRecording => 'હાજર બધાની સંમતિથી રેકોર્ડિંગ';

  @override
  String get doctorConversation => 'ડૉક્ટર સાથે વાતચીત';

  @override
  String get nurseInstructions => 'નર્સની સૂચનાઓ';

  @override
  String get pharmacistAdvice => 'ફાર્માસિસ્ટની સલાહ';

  @override
  String get yourCarePlan => 'તમારી કાળજી યોજના';

  @override
  String get afterBreakfast => 'નાસ્તા પછી';

  @override
  String get checkBloodPressure => 'BP તપાસો';

  @override
  String get twiceDaily => 'દિવસમાં બે વાર';

  @override
  String get bloodTest => 'લોહીની તપાસ (CBC)';

  @override
  String get instructionsFound =>
      'તમારા રેકોર્ડિંગ અને પ્રિસ્ક્રિપ્શનમાં 4 સૂચનાઓ મળી';

  @override
  String get askQuestion => 'સાંજની દવા વિશે ડૉક્ટરે શું કહ્યું હતું?';

  @override
  String get askAnswer => 'ડૉક્ટરે Amlodipine રાતના જમ્યા પછી લેવાનું કહ્યું.';

  @override
  String get sourceDoctorVisit => 'સ્ત્રોત: ડૉક્ટરની મુલાકાત';

  @override
  String get careForTitle => 'તમે Gurtu કોના માટે સેટ કરી રહ્યા છો?';

  @override
  String get careForSubtitle =>
      'Gurtu એક વ્યક્તિની આસપાસ કાળજીની યાદ બનાવે છે. બાકીના પરિવારને પછી આમંત્રણ આપી શકો છો.';

  @override
  String get careForMyself => 'મારા માટે';

  @override
  String get careForMyselfHint => 'મારી પોતાની કાળજીનું ધ્યાન રાખવું છે';

  @override
  String get careForParent => 'મારા માતા-પિતા';

  @override
  String get careForParentHint => 'બા, બાપુજી અથવા ઘરના કોઈ વડીલ';

  @override
  String get careForPartner => 'મારા જીવનસાથી';

  @override
  String get careForPartnerHint => 'પતિ, પત્ની અથવા સાથી';

  @override
  String get careForChild => 'મારું બાળક';

  @override
  String get careForChildHint => 'દીકરો અથવા દીકરી';

  @override
  String get careForOther => 'બીજું કોઈ';

  @override
  String get careForOtherHint => 'સગાં, મિત્ર અથવા પડોશી';

  @override
  String get profileTitleSelf => 'તમારા વિશે જણાવો';

  @override
  String get profileTitleOther => 'તેમના વિશે જણાવો';

  @override
  String get profileSubtitleSelf => 'આનાથી Gurtu તમને નામથી બોલાવશે.';

  @override
  String get profileSubtitleOther => 'ઘરે તમે તેમને જે નામે બોલાવો છો તે લખો.';

  @override
  String get yourName => 'તમારું નામ';

  @override
  String get whatDoYouCallThem => 'તમે તેમને શું કહીને બોલાવો છો?';

  @override
  String exampleName(String name) {
    return 'દા.ત. $name';
  }

  @override
  String get sampleSelfName => 'હેમા';

  @override
  String get sampleYourName => 'પ્રિયા';

  @override
  String get yourAge => 'તમારી ઉંમર';

  @override
  String get theirAge => 'તેમની ઉંમર';

  @override
  String get years => 'વર્ષ';

  @override
  String get decreaseAge => 'ઉંમર ઘટાડો';

  @override
  String get increaseAge => 'ઉંમર વધારો';

  @override
  String get gender => 'લિંગ';

  @override
  String get female => 'સ્ત્રી';

  @override
  String get male => 'પુરુષ';

  @override
  String get genderOther => 'અન્ય';

  @override
  String get andYou => 'અને તમે?';

  @override
  String get andYouBody => 'તેમના કેર સર્કલના પહેલા સભ્ય તમે હશો.';

  @override
  String get conditionsTitleSelf => 'શું તમને આમાંથી કોઈ બીમારી છે?';

  @override
  String conditionsTitleOther(String name) {
    return 'શું $nameને આમાંથી કોઈ બીમારી છે?';
  }

  @override
  String get conditionsSubtitle =>
      'લાગુ પડતા બધા પસંદ કરો. આનાથી Gurtu કાળજી યોજના ગોઠવે છે.';

  @override
  String get condDiabetes => 'સુગર (ડાયાબિટીસ)';

  @override
  String get condHighBp => 'હાઈ BP';

  @override
  String get condHeart => 'હૃદયની તકલીફ';

  @override
  String get condThyroid => 'થાઇરોઇડ';

  @override
  String get condCholesterol => 'કોલેસ્ટ્રોલ';

  @override
  String get condAsthma => 'દમ / શ્વાસની તકલીફ';

  @override
  String get condKidney => 'કિડનીની તકલીફ';

  @override
  String get condArthritis => 'સાંધાનો દુખાવો / આર્થરાઇટિસ';

  @override
  String get condStroke => 'પહેલાં લકવો થયો હતો';

  @override
  String get condCancer => 'કેન્સરની સારવાર';

  @override
  String get noneOfThese => 'આમાંથી કંઈ નહીં';

  @override
  String get notADoctor =>
      'Gurtu ડૉક્ટર નથી. તે ક્યારેય નિદાન કરતું નથી — ફક્ત પરિવારને કાળજી યાદ રાખવા અને ગોઠવવામાં મદદ કરે છે.';

  @override
  String get medicinesTitleSelf => 'શું તમે રોજ દવા લો છો?';

  @override
  String medicinesTitleOther(String name) {
    return 'શું $name રોજ દવા લે છે?';
  }

  @override
  String get medicinesSubtitle =>
      'ગોળીઓ, સિરપ, ઇન્હેલર કે ઇન્સ્યુલિન — બધું ગણો.';

  @override
  String get howMany => 'આશરે કેટલી?';

  @override
  String get sixOrMore => '6 કે વધુ';

  @override
  String get scanLaterTip =>
      'પછી ફક્ત પ્રિસ્ક્રિપ્શન કે દવાની પટ્ટી સ્કેન કરો — ટાઇપ કરવાની જરૂર નથી.';

  @override
  String get allergiesTitleSelf => 'શું તમને કશાની એલર્જી છે?';

  @override
  String allergiesTitleOther(String name) {
    return 'શું $nameને કશાની એલર્જી છે?';
  }

  @override
  String get allergiesSubtitle =>
      'આ ક્યારેય ચૂકાય નહીં તે માટે Gurtu તેને દરેક ડૉક્ટર બ્રીફમાં બતાવશે.';

  @override
  String get allergyNone => 'કોઈ જાણીતી એલર્જી નથી';

  @override
  String get allergyPenicillin => 'પેનિસિલિન';

  @override
  String get allergySulfa => 'સલ્ફા દવાઓ';

  @override
  String get allergyAspirin => 'એસ્પિરિન / દુખાવાની દવા';

  @override
  String get allergyFood => 'ખોરાકની એલર્જી';

  @override
  String get allergyDust => 'ધૂળ / પરાગ';

  @override
  String get allergyLatex => 'લેટેક્સ';

  @override
  String get mobilityTitleSelf => 'રોજ તમે કેવી રીતે હરોફરો છો?';

  @override
  String mobilityTitleOther(String name) {
    return 'રોજ $name કેવી રીતે હરેફરે છે?';
  }

  @override
  String get mobilitySubtitle =>
      'આનાથી પરિવાર મુલાકાતો, તપાસ અને ઘરે મદદનું આયોજન કરી શકે છે.';

  @override
  String get mobilityIndependent => 'જાતે ચાલે છે';

  @override
  String get mobilityIndependentHint => 'રોજના કામમાં મદદની જરૂર નથી';

  @override
  String get mobilitySomeHelp => 'થોડી મદદ જોઈએ';

  @override
  String get mobilitySomeHelpHint => 'લાકડી, વૉકર કે પકડવા માટે હાથ';

  @override
  String get mobilityFullHelp => 'મોટા ભાગે પથારી કે વ્હીલચેરમાં';

  @override
  String get mobilityFullHelpHint => 'મોટા ભાગના કામમાં મદદ જોઈએ';

  @override
  String get hospitalTitleSelf =>
      'છેલ્લા 30 દિવસમાં તમે હૉસ્પિટલ કે ડૉક્ટર પાસે ગયા હતા?';

  @override
  String hospitalTitleOther(String name) {
    return 'છેલ્લા 30 દિવસમાં $name હૉસ્પિટલ કે ડૉક્ટર પાસે ગયા હતા?';
  }

  @override
  String get hospitalSubtitle =>
      'તાજેતરની મુલાકાતો સાથે સામાન્ય રીતે નવી સૂચનાઓ આવે છે.';

  @override
  String get hospitalTip =>
      'ડિસ્ચાર્જના કાગળો અને પ્રિસ્ક્રિપ્શન પાસે રાખો — સેટઅપ પછી તરત સ્કેન કરી શકશો.';

  @override
  String get permissionsTitle => 'તમારી મદદ માટે થોડી પરવાનગીઓ';

  @override
  String get permissionsSubtitle =>
      'Gurtu ફક્ત જરૂરી વસ્તુઓ જ માંગે છે. શા માટે, તે અહીં છે.';

  @override
  String get permMic => 'માઇક્રોફોન';

  @override
  String get permMicWhy =>
      'ડૉક્ટરની મુલાકાત અને વૉઇસ નોટ રેકોર્ડ કરવા — ફક્ત તમે રેકોર્ડ દબાવો ત્યારે.';

  @override
  String get permCamera => 'કૅમેરા';

  @override
  String get permCameraWhy =>
      'પ્રિસ્ક્રિપ્શન, દવાની પટ્ટી અને BP મશીનનું રીડિંગ સ્કેન કરવા.';

  @override
  String get permNotifications => 'સૂચનાઓ';

  @override
  String get permNotificationsWhy =>
      'દવાની યાદ અને પરિવાર કામ પૂરું કરે ત્યારે જાણકારી.';

  @override
  String get permPhotos => 'ફોટા અને ફાઇલો';

  @override
  String get permPhotosWhy =>
      'ગૅલરીમાં રાખેલા રિપોર્ટ અને પ્રિસ્ક્રિપ્શન ઉમેરવા.';

  @override
  String get permContacts => 'સંપર્કો';

  @override
  String get permContactsWhy => 'પરિવારના સભ્યોને ઝડપથી કેર સર્કલમાં બોલાવવા.';

  @override
  String get needed => 'જરૂરી';

  @override
  String get allow => 'મંજૂરી આપો';

  @override
  String get allowed => 'મંજૂરી મળી';

  @override
  String get allowAndContinue => 'મંજૂરી આપો અને આગળ વધો';

  @override
  String get privacyNote =>
      'બધું આ જ ફોનમાં રહે છે. રેકોર્ડિંગ આપમેળે ક્યારેય શરૂ થતું નથી — પહેલાં હંમેશા સંમતિ સ્ક્રીન દેખાય છે.';

  @override
  String permissionBlocked(String permission) {
    return '$permission બંધ છે. સેટિંગ્સમાં ચાલુ કરો.';
  }

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String permissionsMissing(String items) {
    return '$items વિના કેટલીક સુવિધાઓ કામ નહીં કરે. પછી મંજૂરી આપી શકો છો.';
  }

  @override
  String get modelTitleChoose => 'Gurtu નું ઑન-ડિવાઇસ AI સેટ કરો';

  @override
  String get modelTitleDownloading => 'તમારું AI સેટ થઈ રહ્યું છે…';

  @override
  String get modelTitleDone => 'તમારું AI તૈયાર છે';

  @override
  String get modelSubtitleChoose =>
      'આ મૉડલ સંપૂર્ણપણે તમારા iQOO પર ચાલે છે. પરિવારની આરોગ્ય માહિતી ફોનની બહાર જતી નથી — અને ઇન્ટરનેટ વિના પણ કામ કરે છે.';

  @override
  String get modelSubtitleDownloading =>
      'તમે ફોન વાપરતા રહી શકો છો. આ ફક્ત એક જ વાર થાય છે.';

  @override
  String get modelSubtitleDone => 'બધું આ જ ફોન પર ચાલે છે, ઑફલાઇન પણ.';

  @override
  String get poweredByIqoo => 'તમારા iQOO દ્વારા સંચાલિત';

  @override
  String get deviceCardSub => 'ઑન-ડિવાઇસ AI · ખાનગી · ઑફલાઇન ચાલે છે';

  @override
  String get chooseCareModel => 'કેર મૉડલ પસંદ કરો';

  @override
  String get careModelHint => 'પ્રશ્નોના જવાબ આપતું મગજ આ જ છે.';

  @override
  String get alwaysIncluded => 'હંમેશા સામેલ';

  @override
  String get jobListens => 'સાંભળે છે';

  @override
  String get jobReads => 'વાંચે છે';

  @override
  String get jobSees => 'જુએ છે';

  @override
  String get jobUnderstands => 'સમજે છે';

  @override
  String speechModelName(String language) {
    return 'અવાજ · $language + અંગ્રેજી';
  }

  @override
  String get speechModelWhat => 'વાતચીતને તમારી ભાષામાં લખાણમાં ફેરવે છે.';

  @override
  String get readerModelName => 'દસ્તાવેજ રીડર (OCR)';

  @override
  String get readerModelWhat =>
      'પ્રિસ્ક્રિપ્શન, ડિસ્ચાર્જના કાગળો અને લૅબ રિપોર્ટ વાંચે છે.';

  @override
  String get visionModelName => 'દવા અને રીડિંગ ઓળખ';

  @override
  String get visionModelWhat =>
      'દવાની પટ્ટી અને BP / સુગર મશીનના આંકડા ઓળખે છે.';

  @override
  String careModelName(String model) {
    return 'કેર મૉડલ · $model';
  }

  @override
  String get tierLite => 'લાઇટ';

  @override
  String get tierBalanced => 'સંતુલિત';

  @override
  String get tierPro => 'પ્રો';

  @override
  String get tierLiteNote => 'સૌથી ઝડપી. ટૂંકા, સરળ જવાબો.';

  @override
  String get tierBalancedNote => 'અવાજ, ફોટા અને લખાણ સાથે સમજે છે.';

  @override
  String get tierProNote => 'સૌથી વિગતવાર જવાબો અને ડૉક્ટર બ્રીફ.';

  @override
  String get bestForIqoo => 'iQOO માટે શ્રેષ્ઠ';

  @override
  String get wifiOnly => 'ફક્ત Wi-Fi પર ડાઉનલોડ કરો';

  @override
  String downloadSize(String size) {
    return 'ડાઉનલોડ · $size';
  }

  @override
  String get settingUp => 'સેટ થઈ રહ્યું છે…';

  @override
  String get ready => 'તૈયાર';

  @override
  String allSetName(String name) {
    return 'બધું તૈયાર, $name!';
  }

  @override
  String get allSet => 'બધું તૈયાર!';

  @override
  String get readySelf => 'તમારી કાળજીની યાદ તૈયાર છે.';

  @override
  String readyOther(String name) {
    return '$nameની કાળજીની યાદ તૈયાર છે. હવે પરિવારને બોલાવો.';
  }

  @override
  String get rowYou => 'તમે';

  @override
  String get rowCaringFor => 'કોની કાળજી';

  @override
  String get rowHealth => 'આરોગ્ય';

  @override
  String get rowAllergies => 'એલર્જી';

  @override
  String get rowLanguage => 'ભાષા';

  @override
  String get rowAi => 'ઑન-ડિવાઇસ AI';

  @override
  String get notAdded => 'ઉમેર્યું નથી';

  @override
  String ageYears(int age) {
    return '$age વર્ષ';
  }

  @override
  String get careQuote => '“સાથે મળીને કરીએ તો કાળજી હળવી લાગે.”';

  @override
  String get enterGurtu => 'Gurtu ખોલો';

  @override
  String get nextUpCareCircle => 'હવે પછી: કેર સર્કલ';

  @override
  String get homeComingSoon => 'હોમ સ્ક્રીન આગળના ભાગમાં આવી રહી છે.';

  @override
  String get restartOnboarding => 'ઑનબોર્ડિંગ ફરી શરૂ કરો';

  @override
  String get navHome => 'હોમ';

  @override
  String get navMemory => 'યાદો';

  @override
  String get navCircle => 'સર્કલ';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String goodMorning(String name) {
    return 'સુપ્રભાત, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'નમસ્તે, $name';
  }

  @override
  String goodEvening(String name) {
    return 'શુભ સાંજ, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu માં સ્વાગત છે, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'તમારા પરિવારનું આરોગ્ય, સૌ સાથે મળીને યાદ રાખો.';

  @override
  String get caringFor => 'કાળજી';

  @override
  String get switchPatientTitle => 'તમે કોની કાળજી લો છો?';

  @override
  String get addAnotherPerson => 'બીજી વ્યક્તિ ઉમેરો';

  @override
  String get statusOnTrack => 'કાળજી બરાબર ચાલે છે';

  @override
  String get statusNeedsAttention => 'એક બાબત પર ધ્યાન આપવાનું છે';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'કટોકટી';

  @override
  String get sosHoldTitle => 'કેર સર્કલને ચેતવવા દબાવી રાખો';

  @override
  String get sosHoldBody =>
      'બટન 2 સેકન્ડ દબાવી રાખો. તમારા કટોકટી સંપર્કોને ચેતવણી જશે.';

  @override
  String get sosHoldButton => 'SOS મોકલવા દબાવી રાખો';

  @override
  String get sosKeepHolding => 'દબાવી રાખો…';

  @override
  String get sosPreviewNote =>
      'કટોકટી ચેતવણીઓ હજી જોડાઈ નથી. આ ફક્ત ઝલક છે — કોઈને ચેતવણી નહીં જાય.';

  @override
  String get sosPreviewDone => 'ઝલક પૂરી થઈ. કોઈને ચેતવણી ગઈ નથી.';

  @override
  String get close => 'બંધ કરો';

  @override
  String get todayCare => 'આજની કાળજી';

  @override
  String completedOf(int done, int total) {
    return '$totalમાંથી $done પૂરાં';
  }

  @override
  String get viewTodayCare => 'આજની કાળજી જુઓ';

  @override
  String get nothingUrgent => 'અત્યારે કંઈ તાત્કાલિક નથી.';

  @override
  String get markDone => 'પૂરું થયું તરીકે ચિહ્નિત કરો';

  @override
  String get markNotDone => 'અધૂરું તરીકે ચિહ્નિત કરો';

  @override
  String get openToCircle => 'કેર સર્કલ માટે ખુલ્લું';

  @override
  String get captureCare => 'કાળજી નોંધો';

  @override
  String get captureCareSubtitle => 'કાળજીની કોઈ મહત્વની વાત નોંધો.';

  @override
  String get whatHappened => 'શું થયું?';

  @override
  String get captureVoice => 'અવાજ';

  @override
  String get captureVoiceHint => 'વાતચીત કે વૉઇસ નોટ રેકોર્ડ કરો';

  @override
  String get captureScan => 'સ્કેન';

  @override
  String get captureScanHint => 'પ્રિસ્ક્રિપ્શન કે દવાની પટ્ટી';

  @override
  String get captureVital => 'રીડિંગ';

  @override
  String get captureVitalHint => 'BP, સુગર કે તાવ';

  @override
  String get captureDocument => 'દસ્તાવેજ';

  @override
  String get captureDocumentHint => 'ડિસ્ચાર્જ પેપર કે લૅબ રિપોર્ટ';

  @override
  String get captureNote => 'નોંધ';

  @override
  String get captureNoteHint => 'શું થયું તે લખો';

  @override
  String get comingSoon => 'જલ્દી આવે છે';

  @override
  String get noteHint => 'દા.ત. ચાલ્યા પછી ચક્કર આવ્યા';

  @override
  String get saveNote => 'નોંધ સાચવો';

  @override
  String get noteSaved => 'કાળજીની યાદમાં સાચવ્યું';

  @override
  String get recentMemory => 'તાજેતરની યાદો';

  @override
  String get viewAll => 'બધું જુઓ';

  @override
  String get emptyMemory => 'તમારી કાળજીની વાર્તા અહીંથી શરૂ થાય છે.';

  @override
  String addedBy(String name) {
    return '$nameએ ઉમેર્યું';
  }

  @override
  String get sourcePlay => 'સાંભળો';

  @override
  String get sourceView => 'જુઓ';

  @override
  String get sourceOpen => 'ખોલો';

  @override
  String get sourceTitle => 'સ્ત્રોત';

  @override
  String get sourceRecording => 'ડૉક્ટરનું રેકોર્ડિંગ';

  @override
  String get sourceScan => 'પ્રિસ્ક્રિપ્શન સ્કેન';

  @override
  String get sourceVital => 'રીડિંગ';

  @override
  String get sourceDocument => 'દસ્તાવેજ';

  @override
  String get sourceNote => 'લખેલી નોંધ';

  @override
  String get sourceSampleNote =>
      'આ નમૂના ડેટા છે, એટલે મૂળ ફાઇલ નથી. સાચાં રેકોર્ડિંગ અને સ્કેન અહીં ખુલશે.';

  @override
  String get yourCareCircle => 'તમારું કેર સર્કલ';

  @override
  String get manageCircle => 'સર્કલ સંભાળો';

  @override
  String get emptyCircle => 'સાથે મળીને કાળજી સરળ બને છે.';

  @override
  String get addFamilyMember => 'પરિવારના સભ્ય ઉમેરો';

  @override
  String get rolePatient => 'દર્દી';

  @override
  String get roleCaregiver => 'સંભાળ રાખનાર';

  @override
  String get roleFamily => 'પરિવાર';

  @override
  String get roleHelper => 'વિશ્વાસુ સહાયક';

  @override
  String get askGurtuTitle => 'Gurtu ને પૂછો';

  @override
  String get askGurtuPrompt => 'કંઈક યાદ રાખવામાં મદદ જોઈએ?';

  @override
  String get askExampleBloodTest => 'લોહીની તપાસ ક્યારે છે?';

  @override
  String get askExampleDoctor => 'કાલે ડૉક્ટરને શું પૂછું?';

  @override
  String get askGurtuNote => 'જવાબ તમે સાચવેલી કાળજીની માહિતીમાંથી જ આવે છે.';

  @override
  String get gettingReady => 'Gurtu તૈયાર થઈ રહ્યું છે';

  @override
  String get readyYourProfile => 'તમારી પ્રોફાઇલ';

  @override
  String get readyPatientProfile => 'દર્દીની પ્રોફાઇલ';

  @override
  String get readyCareCircle => 'કેર સર્કલ';

  @override
  String get readyEmergencyContact => 'કટોકટી સંપર્ક';

  @override
  String get previewSampleData => 'નમૂના ડેટા સાથે જુઓ';

  @override
  String get sampleDataOn => 'નમૂના કાળજી ડેટા બતાવે છે';

  @override
  String get remove => 'કાઢો';

  @override
  String get hide => 'છુપાવો';

  @override
  String get comingNextPhase => 'આ ભાગ હવે પછી બની રહ્યો છે.';

  @override
  String get fatherName => 'બાપુજી';

  @override
  String get sampleTaskMorningMedicine => 'સવારની દવા';

  @override
  String get sampleTaskRecordBp => 'BP નોંધો';

  @override
  String get sampleTaskBloodTest => 'લોહીની તપાસ';

  @override
  String get sampleTaskDoctorVisit => 'ડૉક્ટરની મુલાકાત';

  @override
  String get sampleMomentDoctorTalk => 'ડૉક્ટર સાથે વાતચીત';

  @override
  String get sampleMomentDoctorTalkDetail => '“નાસ્તા પછી દવા લો.”';

  @override
  String get sampleMomentPrescription => 'પ્રિસ્ક્રિપ્શન સ્કેન થયું';

  @override
  String get sampleMomentPrescriptionDetail => '2 દવાઓ મળી';

  @override
  String get sampleMomentBp => 'BP નોંધાયું';

  @override
  String get today => 'આજે';

  @override
  String get yesterday => 'ગઈકાલે';
}
