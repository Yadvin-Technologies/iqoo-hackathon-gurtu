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

  @override
  String get doctorVisit => 'ડૉક્ટર મુલાકાત';

  @override
  String get doctorVisitHint => 'ડૉક્ટર શું કહે છે તે નોંધો';

  @override
  String get askDoctor => 'ડૉક્ટરને પૂછવાના પ્રશ્નો';

  @override
  String get askDoctorHint => 'Gurtu તૈયારીમાં મદદ કરશે';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પ્રશ્નો તૈયાર',
      one: '1 પ્રશ્ન તૈયાર',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'છેલ્લી મુલાકાત: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'આગલી મુલાકાત: $date';
  }

  @override
  String get visitsTitle => 'ડૉક્ટર મુલાકાતો';

  @override
  String get visitsSubtitle => 'દરેક ડૉક્ટરે જે કહ્યું, બધું એક જગ્યાએ.';

  @override
  String get recordVisit => 'મુલાકાત નોંધો';

  @override
  String get visitsOverview => 'બધી મુલાકાતો એક નજરે';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count મુલાકાતો',
      one: '1 મુલાકાત',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ડૉક્ટરો',
      one: '1 ડૉક્ટર',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'છેલ્લી મુલાકાત';

  @override
  String get nextVisit => 'આગલી મુલાકાત';

  @override
  String get notPlanned => 'હજુ નક્કી નથી';

  @override
  String get pastVisits => 'અગાઉની મુલાકાતો';

  @override
  String get noVisitsTitle => 'હજુ કોઈ મુલાકાત નોંધાઈ નથી';

  @override
  String get noVisitsBody =>
      'આગલી એપોઇન્ટમેન્ટમાં ‘મુલાકાત નોંધો’ દબાવો, ડૉક્ટર જે કહેશે તે Gurtu નોંધશે.';

  @override
  String get questionsForNextVisit => 'આગલી મુલાકાતના પ્રશ્નો';

  @override
  String get prepareQuestionsHint =>
      'તમને કેવું લાગે છે તે Gurtu ને કહો. તે ડૉક્ટરને શું પૂછવું તે સૂચવશે.';

  @override
  String get prepareQuestions => 'પ્રશ્નો તૈયાર કરો';

  @override
  String get viewQuestions => 'પ્રશ્નો જુઓ';

  @override
  String get doctorFallback => 'ડૉક્ટર';

  @override
  String get doctorSaid => 'ડૉક્ટરે શું કહ્યું';

  @override
  String get medicinesSection => 'દવાઓ';

  @override
  String get testsSection => 'કરાવવાના ટેસ્ટ';

  @override
  String get questionsAsked => 'પૂછેલા પ્રશ્નો';

  @override
  String askedOf(int asked, int total) {
    return '$total માંથી $asked પૂછ્યા';
  }

  @override
  String get deleteVisit => 'મુલાકાત કાઢી નાખો';

  @override
  String get deleteVisitConfirm => 'આ મુલાકાત કાઢી નાખવી છે? તે પાછી નહીં મળે.';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get doctorName => 'ડૉક્ટરનું નામ';

  @override
  String get doctorNameHint => 'દા.ત. ડૉ. મીના રાવ';

  @override
  String get visitReason => 'મુલાકાતનું કારણ';

  @override
  String get visitReasonHint => 'દા.ત. સુગર ચેક-અપ';

  @override
  String get visitDate => 'મુલાકાતની તારીખ';

  @override
  String get listenToDoctor => 'ડૉક્ટરની વાત સાંભળો';

  @override
  String get stopListening => 'સાંભળવાનું બંધ કરો';

  @override
  String get speak => 'બોલો';

  @override
  String get recordingConsent =>
      'ડૉક્ટરને જણાવો કે તમે Gurtu થી વાતચીત નોંધી રહ્યા છો.';

  @override
  String get doctorSaidHint => 'ડૉક્ટર જે કહે તે બોલો અથવા ટાઇપ કરો';

  @override
  String get medicinesHint => 'દા.ત. મેટફોર્મિન 500 mg નાસ્તા પછી';

  @override
  String get testsHint => 'દા.ત. HbA1c લોહીની તપાસ';

  @override
  String get addNextVisit => 'આગલી મુલાકાતની તારીખ ઉમેરો';

  @override
  String get yourQuestions => 'તમારા પ્રશ્નો';

  @override
  String get tickWhenAsked => 'ડૉક્ટર જવાબ આપે પછી દરેક પર ટિક કરો.';

  @override
  String get saveVisit => 'મુલાકાત સેવ કરો';

  @override
  String get visitSaved => 'મુલાકાત સેવ થઈ';

  @override
  String get leaveVisitTitle => 'સેવ કર્યા વગર જવું છે?';

  @override
  String get leaveVisitBody => 'આ મુલાકાત માટે તમે નોંધેલું બધું જતું રહેશે.';

  @override
  String get discard => 'રદ કરો';

  @override
  String get keepEditing => 'લખવાનું ચાલુ રાખો';

  @override
  String get voiceUnavailable =>
      'હમણાં અવાજથી લખવાનું ઉપલબ્ધ નથી. તમે ટાઇપ કરી શકો છો.';

  @override
  String get prepTitle => 'ડૉક્ટર માટે તૈયારી';

  @override
  String get prepIntro =>
      'ચાલો ડૉક્ટર પાસે જવાની તૈયારી કરીએ. કઈ તકલીફો વિશે વાત કરવી છે?';

  @override
  String get prepPickOrSay => 'નીચે તકલીફો પસંદ કરો, અથવા તમારા શબ્દોમાં કહો.';

  @override
  String get prepDescribeHint => 'દા.ત. ત્રણ દિવસથી માથાનો દુખાવો અને થાક';

  @override
  String prepHeard(String symptoms) {
    return 'મેં સાંભળ્યું: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — ક્યારથી?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — કેટલું વધારે છે?';
  }

  @override
  String get askNewMedicine => 'તાજેતરમાં કોઈ દવા શરૂ કરી કે બદલી છે?';

  @override
  String get askAnythingElse => 'ડૉક્ટરને બીજું કંઈ કહેવું છે?';

  @override
  String get urgentWarning =>
      'છાતીમાં તીવ્ર દુખાવો કે શ્વાસ ચઢવો ઇમરજન્સી હોઈ શકે છે. એપોઇન્ટમેન્ટની રાહ ન જુઓ — હમણાં જ તબીબી મદદ લો.';

  @override
  String get prepThinking => 'તમારા પ્રશ્નો તૈયાર થઈ રહ્યા છે…';

  @override
  String get prepResultIntro =>
      'ડૉક્ટરને આ પૂછો. જરૂર ન હોય તે દૂર કરો, અથવા તમારો પ્રશ્ન ઉમેરો.';

  @override
  String get prepNotDoctor =>
      'Gurtu ડૉક્ટર નથી. આ પ્રશ્નો ડૉક્ટર સાથે વાત કરવામાં મદદ કરે છે.';

  @override
  String get addOwnQuestion => 'તમારો પોતાનો પ્રશ્ન ઉમેરો';

  @override
  String get add => 'ઉમેરો';

  @override
  String get saveQuestions => 'મુલાકાત માટે સેવ કરો';

  @override
  String get questionsSaved => 'પ્રશ્નો મુલાકાત માટે સેવ થયા';

  @override
  String get startAgain => 'ફરી શરૂ કરો';

  @override
  String get startVisit => 'મુલાકાત શરૂ કરો';

  @override
  String get deleteQuestions => 'આ પ્રશ્નો કાઢી નાખો';

  @override
  String get removeQuestion => 'પ્રશ્ન દૂર કરો';

  @override
  String get done => 'થઈ ગયું';

  @override
  String get healthProblems => 'તકલીફો';

  @override
  String preparedOn(String date) {
    return '$date ના રોજ તૈયાર કર્યું';
  }

  @override
  String get symFever => 'તાવ';

  @override
  String get symHeadache => 'માથાનો દુખાવો';

  @override
  String get symBodyPain => 'શરીર કે સાંધાનો દુખાવો';

  @override
  String get symChestPain => 'છાતીમાં દુખાવો';

  @override
  String get symBreathless => 'શ્વાસ ચઢવો';

  @override
  String get symCough => 'ઉધરસ';

  @override
  String get symDizziness => 'ચક્કર';

  @override
  String get symTiredness => 'થાક';

  @override
  String get symStomach => 'પેટની તકલીફ';

  @override
  String get symPoorSleep => 'ઊંઘ ન આવવી';

  @override
  String get symPoorAppetite => 'ભૂખ ઓછી';

  @override
  String get symLowMood => 'ઉદાસી કે ચિંતા';

  @override
  String get kwFever => 'તાવ,ઠંડી,શરીર ગરમ';

  @override
  String get kwHeadache => 'માથાનો દુખાવો,માથું દુખે,માથું દુખે છે';

  @override
  String get kwBodyPain =>
      'શરીરનો દુખાવો,સાંધાનો દુખાવો,ઘૂંટણ,કમરનો દુખાવો,પગનો દુખાવો';

  @override
  String get kwChestPain => 'છાતીમાં,છાતી';

  @override
  String get kwBreathless => 'શ્વાસ,હાંફ';

  @override
  String get kwCough => 'ઉધરસ,કફ,શરદી';

  @override
  String get kwDizziness => 'ચક્કર,બેભાન';

  @override
  String get kwTiredness => 'થાક,નબળાઈ,થાકેલ';

  @override
  String get kwStomach => 'પેટ,એસિડિટી,ગેસ,ઊલટી,ઝાડા,કબજિયાત,ઉબકા';

  @override
  String get kwPoorSleep => 'ઊંઘ,અનિદ્રા';

  @override
  String get kwPoorAppetite => 'ભૂખ,ખાવાનું મન નથી';

  @override
  String get kwLowMood => 'ઉદાસ,ચિંતા,ડર,તણાવ,ટેન્શન';

  @override
  String get sinceToday => 'આજથી';

  @override
  String get sinceFewDays => 'થોડા દિવસથી';

  @override
  String get sinceWeek => 'લગભગ એક અઠવાડિયાથી';

  @override
  String get sinceMonth => 'એક મહિનો કે વધુ';

  @override
  String get sevMild => 'હળવું';

  @override
  String get sevModerate => 'મધ્યમ';

  @override
  String get sevSevere => 'તીવ્ર';

  @override
  String qCause(String symptom) {
    return '$symptom થવાનું કારણ શું હોઈ શકે?';
  }

  @override
  String qTests(String symptom) {
    return '$symptom માટે કોઈ ટેસ્ટ કરાવવાની જરૂર છે?';
  }

  @override
  String qWarningSigns(String symptom) {
    return '$symptom સાથે કયા લક્ષણો દેખાય તો તરત પાછા આવવું?';
  }

  @override
  String qHomeCare(String symptom) {
    return '$symptom ઓછું કરવા ઘરે શું કરી શકાય?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return 'શું $symptom નો $conditions સાથે સંબંધ હોઈ શકે?';
  }

  @override
  String get qSideEffect => 'શું નવી કે બદલેલી દવાને કારણે આ થઈ રહ્યું છે?';

  @override
  String get qMedicinesStillRight => 'હાલની દવાઓ બરાબર છે, કે કંઈ બદલવું જોઈએ?';

  @override
  String get qNextCheckup => 'આગલા ચેક-અપ માટે ક્યારે આવવું?';

  @override
  String qTellDoctor(String text) {
    return 'ડૉક્ટરને કહો: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'ડાયાબિટીસ સમીક્ષા';

  @override
  String get sampleVisitDiabetesNotes =>
      'સુગર પહેલાં કરતાં વધુ સારી રીતે કાબૂમાં છે. એ જ દવાઓ ચાલુ રાખો. રોજ 30 મિનિટ ચાલો અને ગળ્યું ઓછું કરો.';

  @override
  String get sampleVisitDiabetesMeds =>
      'મેટફોર્મિન 500 mg નાસ્તા અને રાતના જમણ પછી';

  @override
  String get sampleVisitDiabetesTests =>
      'આગલી મુલાકાત પહેલાં HbA1c લોહીની તપાસ';

  @override
  String get sampleVisitKneeReason => 'ઘૂંટણનો દુખાવો';

  @override
  String get sampleVisitKneeNotes =>
      'જમણા ઘૂંટણમાં હળવો સંધિવા. સાંજે ગરમ શેક કરો અને વધુ દાદરા ચઢવાનું ટાળો.';

  @override
  String get sampleVisitKneeMeds => 'દુખાવાની જેલ દિવસમાં બે વાર';

  @override
  String get scanVerify => 'દવા સ્કેન કરીને ચકાસો';

  @override
  String get scanVerifyHint => 'શું આ જ ગોળી હમણાં લેવાની છે?';

  @override
  String scanVerifySubtitle(String name) {
    return 'પત્તું કે ડબ્બો સ્કેન કરો. Gurtu તેને $name ની દવા યાદી સાથે મેળવશે.';
  }

  @override
  String get scanWithCamera => 'દવા સ્કેન કરો';

  @override
  String get orTypeName => 'અથવા પત્તા પર લખેલું નામ ટાઇપ કરો';

  @override
  String get typeNameHint => 'દા.ત. Glycomet 500';

  @override
  String get checkMedicine => 'ચકાસો';

  @override
  String get checkAnother => 'બીજી દવા ચકાસો';

  @override
  String get readingStrip => 'પત્તું વંચાઈ રહ્યું છે…';

  @override
  String get cameraUnavailable =>
      'કેમેરા સ્કેન ફોન એપમાં ચાલે છે. હમણાં નામ ટાઇપ કરો.';

  @override
  String get scanFailed =>
      'ફોટો વાંચી શકાયો નહીં. ફરી પ્રયાસ કરો, અથવા નામ ટાઇપ કરો.';

  @override
  String readFromStrip(String text) {
    return 'પત્તા પર વાંચ્યું: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'Gurtu માત્ર તમે સેવ કરેલી દવાઓ સાથે મેળવે છે. તે ક્યારેય દવા સૂચવતું નથી.';

  @override
  String get verdictTakeNow => 'હા — આ જ સાચી દવા છે, હમણાં લઈ શકાય.';

  @override
  String get verdictNotNow => 'દવા સાચી છે, પણ હમણાં લેવાનો સમય નથી.';

  @override
  String get verdictAlreadyTaken => 'આ ડોઝ પહેલેથી લેવાઈ ગયો છે. ફરી ન લો.';

  @override
  String get verdictNoTimes => 'દવા સાચી છે, પણ તેનો સમય સેવ નથી.';

  @override
  String get verdictWrongStrength =>
      'રોકાઓ — માત્રા (mg) પ્રિસ્ક્રિપ્શનથી અલગ છે.';

  @override
  String verdictNotOnList(String name) {
    return 'રોકાઓ — આ દવા $name ની યાદીમાં નથી.';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'રોકાઓ — આ દવા $other ની યાદીની છે, $name ની નહીં.';
  }

  @override
  String get verdictUnreadable =>
      'દવાનું નામ વાંચી શકાયું નહીં. સારા પ્રકાશમાં ફરી પ્રયાસ કરો, અથવા ટાઇપ કરો.';

  @override
  String get verdictCheckFirst => 'ડૉક્ટર કે ફાર્માસિસ્ટને પૂછ્યા વગર ન લો.';

  @override
  String get rowOnList => 'દવા યાદીમાં છે';

  @override
  String rowStrengthMatches(String strength) {
    return 'માત્રા મળે છે: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'પત્તા પર $found, પ્રિસ્ક્રિપ્શનમાં $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'હમણાં લેવાની: $slot નો ડોઝ';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot નો ડોઝ $time વાગ્યે લીધો';
  }

  @override
  String rowNextDose(String slot) {
    return 'આગલો ડોઝ: $slot';
  }

  @override
  String get rowSetTimes => 'દવા યાદીમાં ક્યારે લેવી તે ઉમેરો';

  @override
  String get markTaken => 'લીધી તરીકે નોંધો';

  @override
  String get markedTaken => 'ડોઝ નોંધાયો';

  @override
  String get undo => 'પાછું લો';

  @override
  String get medicineList => 'દવા યાદી';

  @override
  String get medicineListSubtitle =>
      'પ્રિસ્ક્રિપ્શનની દરેક દવા, ક્યારે લેવી તે સાથે.';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દવાઓ',
      one: '1 દવા',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'દવા ઉમેરો';

  @override
  String get editMedicine => 'દવા બદલો';

  @override
  String get addFromPrescription => 'પ્રિસ્ક્રિપ્શનના ફોટામાંથી ઉમેરો';

  @override
  String get noMedicinesTitle => 'હજુ કોઈ દવા ઉમેરી નથી';

  @override
  String get noMedicinesBody =>
      'પ્રિસ્ક્રિપ્શનની દરેક દવા એકવાર ઉમેરો. પછી કોઈપણ પત્તું સ્કેન કરીને તે સાચું છે કે નહીં તે જુઓ.';

  @override
  String addMedicinesFirst(String name) {
    return 'પહેલાં $name ની દવાઓ ઉમેરો, જેથી Gurtu તેની સાથે મેળવી શકે.';
  }

  @override
  String get medicineName => 'દવાનું નામ';

  @override
  String get medicineNameHint => 'દા.ત. Metformin';

  @override
  String get alsoCalled => 'પત્તા પરનું બીજું નામ';

  @override
  String get alsoCalledHint => 'દા.ત. Glycomet';

  @override
  String get strength => 'માત્રા';

  @override
  String get strengthHint => 'દા.ત. 500 mg';

  @override
  String get whenToTake => 'ક્યારે લેવી';

  @override
  String get doseMorning => 'સવાર';

  @override
  String get doseAfternoon => 'બપોર';

  @override
  String get doseEvening => 'સાંજ';

  @override
  String get doseNight => 'રાત';

  @override
  String get foodAfter => 'જમ્યા પછી';

  @override
  String get foodBefore => 'જમ્યા પહેલાં';

  @override
  String get foodAny => 'જમવા સાથે કે વગર';

  @override
  String get saveMedicine => 'દવા સેવ કરો';

  @override
  String get medicineSaved => 'દવા સેવ થઈ';

  @override
  String get deleteMedicine => 'દવા કાઢી નાખો';

  @override
  String get deleteMedicineConfirm => 'આ દવા યાદીમાંથી કાઢવી છે?';

  @override
  String get scanToFill => 'પત્તું સ્કેન કરીને ભરો';

  @override
  String get timesNotSet => 'સમય નક્કી નથી';

  @override
  String get takenToday => 'આજે લીધેલી';

  @override
  String get prescriptionTitle => 'પ્રિસ્ક્રિપ્શનમાંથી ઉમેરો';

  @override
  String get prescriptionHint =>
      'છાપેલા પ્રિસ્ક્રિપ્શનનો સ્પષ્ટ ફોટો લો. Gurtu દવાઓ શોધશે; કઈ ઉમેરવી તે તમે પસંદ કરો.';

  @override
  String get takePhoto => 'ફોટો લો';

  @override
  String get chooseFromGallery => 'ગેલેરીમાંથી પસંદ કરો';

  @override
  String get medicinesFound => 'મળેલી દવાઓ';

  @override
  String get tickToAdd =>
      'ઉમેરવાની હોય તેના પર ટિક કરો. દરેક નામ અને સમય પ્રિસ્ક્રિપ્શન સાથે મેળવી જુઓ.';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દવાઓ ઉમેરો',
      one: '1 દવા ઉમેરો',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'કોઈ દવા મળી નહીં. સ્પષ્ટ ફોટો લો, અથવા હાથે ઉમેરો.';

  @override
  String get handwrittenNote =>
      'હાથે લખેલા પ્રિસ્ક્રિપ્શન બરાબર વંચાય નહીં. દરેક નામ ચકાસો.';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દવાઓ ઉમેરાઈ',
      one: '1 દવા ઉમેરાઈ',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'પત્તા પર $strength લખ્યું છે કે નહીં તે જુઓ';
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
  String get addPhoto => 'ફોટો ઉમેરો';

  @override
  String get recordVoiceNote => 'વૉઇસ નોંધ રેકોર્ડ કરો';

  @override
  String get voiceNote => 'વૉઇસ નોંધ';

  @override
  String get recordingNow => 'રેકોર્ડ થઈ રહ્યું છે…';

  @override
  String get stopAndSave => 'રોકો અને સાચવો';

  @override
  String get removeAttachmentTitle => 'આ દૂર કરવું છે?';

  @override
  String get removeAttachmentBody => 'તે આ ફોનમાંથી કાઢી નાખવામાં આવશે.';

  @override
  String get attachFailed => 'આ ઉમેરી શકાયું નહીં. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get attachHintMedicines =>
      'પ્રિસ્ક્રિપ્શનનો ફોટો ઉમેરો, અથવા દવાઓ વિશે ડૉક્ટરે જે કહ્યું તે રેકોર્ડ કરો.';

  @override
  String get attachHintTests =>
      'તપાસની ચિઠ્ઠી અથવા રિપોર્ટનો ફોટો ઉમેરો, અથવા ડૉક્ટરે જે કહ્યું તે રેકોર્ડ કરો.';

  @override
  String get attachHintNextVisit =>
      'એપોઇન્ટમેન્ટ કાર્ડનો ફોટો ઉમેરો, અથવા આગામી મુલાકાત વિશે ડૉક્ટરે જે કહ્યું તે રેકોર્ડ કરો.';

  @override
  String get play => 'ચલાવો';

  @override
  String get pause => 'થોભો';

  @override
  String get viewPhoto => 'ફોટો જુઓ';

  @override
  String get doctorSpeaks => 'ડૉક્ટર જે ભાષામાં બોલે છે';

  @override
  String listeningIn(String language) {
    return 'સાંભળી રહ્યા છીએ · $language';
  }

  @override
  String get liveCaptionHint => 'સાંભળી રહ્યા છીએ… ડૉક્ટરની વાત અહીં દેખાશે.';

  @override
  String get transcriptHelp =>
      'દરેક વાક્ય સાંભળતાં જ અહીં ઉમેરાય છે. તમે કોઈપણ શબ્દ સુધારી શકો છો.';

  @override
  String voiceLanguageMissing(String language) {
    return 'આ ફોન પર $language વૉઇસ ટાઇપિંગ સેટ નથી. બીજી ભાષા પસંદ કરો, અથવા ફોનના વૉઇસ ટાઇપિંગ સેટિંગ્સમાં તે ઉમેરો.';
  }

  @override
  String get voiceNeedsInternet =>
      'વૉઇસ ટાઇપિંગ માટે ઇન્ટરનેટ જોઈએ. તમે ટાઇપ પણ કરી શકો છો.';

  @override
  String get voiceWaitingInternet =>
      'ઇન્ટરનેટ નથી. પ્રયાસ ચાલુ છે — અત્યાર સુધી સાંભળેલું ગુમાશે નહીં.';

  @override
  String medicineNumber(int number) {
    return 'દવા $number';
  }

  @override
  String get addAnotherMedicine => 'બીજી દવા ઉમેરો';

  @override
  String get medicinesVisitHint =>
      'ડૉક્ટરે આપેલી દરેક દવા ઉમેરો. પટ્ટી કે પ્રિસ્ક્રિપ્શનનો ફોટો લો, ડૉક્ટરે તેના વિશે જે કહ્યું તે રેકોર્ડ કરો, અથવા ટાઇપ કરો.';

  @override
  String get removeMedicineBody =>
      'તેના ફોટા અને વૉઇસ નોટ્સ પણ આ ફોનમાંથી કાઢી નખાશે.';

  @override
  String get questionRemoved => 'પ્રશ્ન દૂર કર્યો';

  @override
  String get recordDoctor => 'ડૉક્ટરનો અવાજ રેકોર્ડ કરો';

  @override
  String get doctorRecordings => 'રેકોર્ડિંગ્સ';

  @override
  String recordingNumber(int number) {
    return 'રેકોર્ડિંગ $number';
  }

  @override
  String get recordOrListenHint =>
      'સાંભળો દબાવવાથી ડૉક્ટરની વાત લખાય છે. રેકોર્ડ દબાવવાથી તેમનો અવાજ પછી સાંભળવા રહે છે. ફોનનું માઇક એક સમયે એક જ કામ કરે છે.';

  @override
  String get tomorrow => 'આવતીકાલે';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દિવસમાં',
      one: '1 દિવસમાં',
    );
    return '$_temp0';
  }

  @override
  String withDoctor(String doctor) {
    return '$doctor સાથે';
  }

  @override
  String recordingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count રેકોર્ડિંગ્સ',
      one: '1 રેકોર્ડિંગ',
    );
    return '$_temp0';
  }

  @override
  String photosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફોટા',
      one: '1 ફોટો',
    );
    return '$_temp0';
  }

  @override
  String get noNextVisitHint =>
      'ડૉક્ટર ફરી આવવાની તારીખ આપે, તો મુલાકાત રેકોર્ડ કરતી વખતે તે ઉમેરો. તે અહીં દેખાશે.';

  @override
  String circleSubtitle(String name) {
    return '$nameની સંભાળ રાખનારા બધા, સાથે.';
  }

  @override
  String get familyCode => 'પરિવાર કોડ';

  @override
  String familyCodeHint(String name) {
    return 'આ કોડ મોકલો. પરિવાર અને મદદગારો તેને Gurtuમાં લખીને $nameના વર્તુળમાં જોડાઈ શકે છે.';
  }

  @override
  String get copyCode => 'કોડ કૉપિ કરો';

  @override
  String get codeCopied => 'કોડ કૉપિ થયો';

  @override
  String get newCode => 'નવો કોડ બનાવો';

  @override
  String get newCodeTitle => 'નવો કોડ બનાવવો છે?';

  @override
  String get newCodeBody =>
      'જૂનો કોડ કામ નહીં કરે. વર્તુળમાં પહેલેથી છે તે રહેશે.';

  @override
  String get circleMembers => 'વર્તુળના લોકો';

  @override
  String get circleOwner => 'વર્તુળ શરૂ કર્યું';

  @override
  String get getsReminders => 'રિમાઇન્ડર મળે છે';

  @override
  String get noNotifications => 'સૂચનાઓ બંધ';

  @override
  String get notOnApp => 'ઍપ પર નથી';

  @override
  String get sendTestNotification => 'ટેસ્ટ સૂચના મોકલો';

  @override
  String testSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફોન પર મોકલ્યું',
      one: '1 ફોન પર મોકલ્યું',
      zero: 'હજી કોઈ ફોન સુધી પહોંચ્યું નથી',
    );
    return '$_temp0';
  }

  @override
  String get testTitle => 'Gurtu તરફથી ટેસ્ટ';

  @override
  String testBody(String name) {
    return '$nameના સંભાળ વર્તુળ માટે સૂચનાઓ ચાલુ છે.';
  }

  @override
  String get settingUpCode => 'તમારો પરિવાર કોડ તૈયાર થઈ રહ્યો છે…';

  @override
  String get offlineTitle => 'Gurtu સર્વર સુધી પહોંચી ન શકાયું';

  @override
  String get offlineBody =>
      'બધું આ ફોનમાં સુરક્ષિત છે. ઇન્ટરનેટ મળતાં જ પરિવાર કોડ દેખાશે.';

  @override
  String get tryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get haveFamilyCode => 'મારી પાસે પરિવાર કોડ છે';

  @override
  String get joinTitle => 'સંભાળ વર્તુળમાં જોડાઓ';

  @override
  String get joinSubtitle => 'તમારા પરિવારમાંથી કોઈએ મોકલેલો 6 અંકનો કોડ લખો.';

  @override
  String get howHelping => 'તમે કેવી રીતે મદદ કરો છો?';

  @override
  String get joinButton => 'વર્તુળમાં જોડાઓ';

  @override
  String get invalidCode =>
      'આ કોડ કોઈ પરિવાર સાથે મેળ ખાતો નથી. અંક તપાસીને ફરી પ્રયાસ કરો.';

  @override
  String get tooManyTries =>
      'ઘણા પ્રયાસ થયા. થોડી મિનિટ રાહ જોઈ ફરી પ્રયાસ કરો.';

  @override
  String get connectionFailed =>
      'કનેક્ટ ન થયું. ઇન્ટરનેટ તપાસીને ફરી પ્રયાસ કરો.';

  @override
  String get somethingWrong => 'કંઈક ખોટું થયું. કૃપા કરી ફરી પ્રયાસ કરો.';

  @override
  String joinedCircle(String name) {
    return 'તમે $nameના સંભાળ વર્તુળમાં જોડાયા';
  }

  @override
  String get peopleYouCareFor => 'જેમની તમે સંભાળ રાખો છો';

  @override
  String get addPersonTitle => 'સંભાળ માટે કોઈને ઉમેરો';

  @override
  String get setUpNew => 'નવી વ્યક્તિ માટે સેટ કરો';

  @override
  String get setUpNewHint =>
      'તેમના વિશે થોડા પ્રશ્નોના જવાબ આપો. તેમને પોતાનો પરિવાર કોડ મળશે.';

  @override
  String get joinWithCode => 'પરિવાર કોડથી જોડાઓ';

  @override
  String get joinWithCodeHint =>
      'પરિવારમાં કોઈએ તેમના માટે પહેલેથી Gurtu સેટ કર્યું છે.';

  @override
  String get yourCare => 'તમારી સંભાળ';

  @override
  String get lookingAfterYou => 'તમારું ધ્યાન રાખનારા';

  @override
  String lookingAfterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count લોકો તમારું ધ્યાન રાખે છે',
      one: '1 વ્યક્તિ તમારું ધ્યાન રાખે છે',
      zero: 'હજી કોઈ નથી',
    );
    return '$_temp0';
  }

  @override
  String get inviteFamily => 'તમારા પરિવારને આમંત્રણ આપો';

  @override
  String get inviteFamilyHint =>
      'તમારો પરિવાર કોડ મોકલો. તેઓ તમારી સંભાળ જોઈ શકશે અને તમારા રિમાઇન્ડર મેળવશે.';

  @override
  String get askForHelp => 'પરિવાર પાસે મદદ માંગો';

  @override
  String get askForHelpTitle => 'પરિવારને સંદેશ મોકલવો છે?';

  @override
  String get askForHelpBody =>
      'તમારા સંભાળ વર્તુળમાં દરેકને તમને ફોન કરવા કે મળવા આવવાની સૂચના મળશે.';

  @override
  String get send => 'મોકલો';

  @override
  String helpSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count લોકોને મોકલ્યું',
      one: '1 વ્યક્તિને મોકલ્યું',
      zero: 'હજી કોઈ સુધી પહોંચ્યું નથી',
    );
    return '$_temp0';
  }

  @override
  String get circleSubtitleSelf => 'તમારું ધ્યાન રાખનારા લોકો.';

  @override
  String get iAmPatient => 'જેમની સંભાળ લેવાય છે તે હું છું';

  @override
  String get patientTaken =>
      'સંભાળ લેવાતી વ્યક્તિ તરીકે કોઈ પહેલેથી જોડાયું છે. બીજી ભૂમિકા પસંદ કરો.';

  @override
  String get medRemindersTitle => 'દવાના રિમાઇન્ડર';

  @override
  String medRemindersIntro(String name) {
    return 'Gurtuએ $name માટે ડૉક્ટરની વાત વાંચી. દરેક સમય તપાસો, પછી રિમાઇન્ડર ચાલુ કરો.';
  }

  @override
  String get readingMedicines => 'દવાઓ વાંચી રહ્યા છીએ…';

  @override
  String get readByAi => 'Gurtu AIએ વાંચ્યું';

  @override
  String get readByRules => 'તમારી નોંધોમાંથી વાંચ્યું';

  @override
  String get pickTimes => 'ક્યારે લેવી તે પસંદ કરો';

  @override
  String get everyDay => 'દરરોજ';

  @override
  String forDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દિવસ માટે',
      one: '1 દિવસ માટે',
    );
    return '$_temp0';
  }

  @override
  String get howLong => 'કેટલા દિવસ';

  @override
  String get turnOnReminders => 'રિમાઇન્ડર ચાલુ કરો';

  @override
  String remindersSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count રિમાઇન્ડર ચાલુ છે',
      one: '1 રિમાઇન્ડર ચાલુ છે',
    );
    return '$_temp0';
  }

  @override
  String remindersGoToPatient(String name) {
    return 'રિમાઇન્ડર $nameના ફોન પર જશે. લીધાનું નોંધાય નહીં, તો Gurtu બે વાર ફરી યાદ અપાવશે, પછી પરિવારને જણાવશે.';
  }

  @override
  String remindersGoToFamily(String name) {
    return '$name Gurtu વાપરતા નથી, તેથી રિમાઇન્ડર પરિવારના ફોન પર જશે. લીધાનું નોંધાય નહીં, તો Gurtu બે વાર ફરી યાદ અપાવશે, પછી બધાને જણાવશે.';
  }

  @override
  String get remindersPending =>
      'આ ફોન પર સાચવ્યું. ઇન્ટરનેટ મળતાં જ રિમાઇન્ડર ચાલુ થશે.';

  @override
  String get setUpReminders => 'રિમાઇન્ડર સેટ કરો';

  @override
  String get changeReminders => 'રિમાઇન્ડર બદલો';

  @override
  String get takenIt => 'મેં લઈ લીધી';

  @override
  String get skipDose => 'આ વખતે છોડો';

  @override
  String dueAt(String time) {
    return '$time વાગ્યે લેવાની';
  }

  @override
  String get readAloud => 'વાંચીને સંભળાવો';

  @override
  String get missedDoseEyebrow => 'ચૂકી ગયેલો ડોઝ';

  @override
  String get markTakenForThem => 'લીધી તરીકે નોંધો';

  @override
  String get illCheck => 'હું ધ્યાન રાખીશ';

  @override
  String get doseTakenThanks => 'લીધી તરીકે નોંધાયું. સરસ!';

  @override
  String get noReminderForThis => 'રિમાઇન્ડર નથી';

  @override
  String get reminderEyebrow => 'દવાનું રિમાઇન્ડર';

  @override
  String get autoReminders => 'આપમેળે દવાના રિમાઇન્ડર';

  @override
  String get autoRemindersHint =>
      'ડૉક્ટરે આપેલી દરેક દવા Gurtu AI સમજે છે અને તેના રિમાઇન્ડર જાતે ચાલુ કરે છે. મુલાકાતમાં તમે તેને જોઈ કે બદલી શકો છો.';

  @override
  String autoRemindersDone(String medicines) {
    return '$medicines માટે રિમાઇન્ડર ચાલુ છે';
  }

  @override
  String get visitSavedAuto =>
      'મુલાકાત સેવ થઈ. Gurtu દવાના રિમાઇન્ડર ગોઠવી રહ્યું છે.';

  @override
  String get testReminder => 'હમણાં ટેસ્ટ રિમાઇન્ડર મોકલો';

  @override
  String get testReminderHint =>
      'રિમાઇન્ડર મળતા ફોન પર સાચો રિમાઇન્ડર તરત જાય છે. કોઈ નિશાન ન કરે તો 1 અને 2 મિનિટ પછી ફરી આવે છે, પછી પરિવારને ચૂકી ગયેલા ડોઝની ચેતવણી મળે છે.';

  @override
  String get testMedicine => 'ટેસ્ટ દવા';

  @override
  String get testBadge => 'ટેસ્ટ';

  @override
  String get skipConfirmTitle => 'આ ડોઝ છોડી દેવો છે?';

  @override
  String get skipConfirmBody =>
      'આ ડોઝ માટે Gurtu ફરી યાદ નહીં કરાવે, અને પરિવારને જણાવાશે.';
}
