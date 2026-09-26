// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get continueLabel => 'కొనసాగించండి';

  @override
  String get next => 'తర్వాత';

  @override
  String get skip => 'దాటవేయండి';

  @override
  String get later => 'తర్వాత';

  @override
  String get back => 'వెనుకకు';

  @override
  String get optional => 'ఐచ్ఛికం';

  @override
  String get yes => 'అవును';

  @override
  String get no => 'కాదు';

  @override
  String get notSure => 'తెలియదు';

  @override
  String get tagline => 'గుర్తుంచుకో. చూసుకో. కలిసి.';

  @override
  String get motherName => 'అమ్మ';

  @override
  String get phaseAbout => 'పరిచయం';

  @override
  String get phaseHealth => 'ఆరోగ్యం';

  @override
  String get phasePermissions => 'అనుమతులు';

  @override
  String get phaseAi => 'AI సెటప్';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $totalలో $current';
  }

  @override
  String get languageTitle => 'మీ భాషను ఎంచుకోండి';

  @override
  String get languageSubtitle =>
      'Gurtu ఈ భాషలోనే మాట్లాడుతుంది, వింటుంది, రాస్తుంది.';

  @override
  String get languageMixNote =>
      'డాక్టర్లు తరచుగా మీ భాషలో ఇంగ్లీష్ కలిపి మాట్లాడతారు. Gurtu రెండింటినీ కలిపి అర్థం చేసుకుంటుంది.';

  @override
  String get welcomeTitle => 'మీ కుటుంబ\nసంరక్షణ జ్ఞాపకం';

  @override
  String get welcomeBody =>
      'డాక్టర్ ఏమి చెప్పారు, ఏ మందులు రాశారు, ఇంట్లో ఏమి జరిగింది — అన్నీ కలిసి గుర్తుంచుకోండి.';

  @override
  String get welcomeScript => 'వేర్వేరు పాత్రలు. అదే ప్రేమ.';

  @override
  String get getStarted => 'ప్రారంభించండి';

  @override
  String builtForBrand(String brand) {
    return '$brand కోసం తయారైంది';
  }

  @override
  String get madeInHyderabad => 'హైదరాబాద్‌లో తయారైంది';

  @override
  String get introRecordEyebrow => '1 · రికార్డ్';

  @override
  String get introRecordTitle => 'డాక్టర్ చెప్పింది ఎప్పుడూ మర్చిపోకండి';

  @override
  String get introRecordBody =>
      'అందరి అనుమతితో డాక్టర్, నర్స్ లేదా ఫార్మసిస్ట్ మాటలను రికార్డ్ చేయండి. ముఖ్యమైన విషయాలను Gurtu దాచి ఉంచుతుంది.';

  @override
  String get introPlanEyebrow => '2 · అర్థం చేసుకోండి & పంచుకోండి';

  @override
  String get introPlanTitle => 'మొత్తం కుటుంబానికి ఒకే సంరక్షణ ప్రణాళిక';

  @override
  String get introPlanBody =>
      'ప్రిస్క్రిప్షన్లు, రిపోర్టులను స్కాన్ చేయండి. కుటుంబం పంచుకునే సులభమైన పనులుగా Gurtu మారుస్తుంది.';

  @override
  String get introAskEyebrow => '3 · అడగండి & గుర్తుంచుకోండి';

  @override
  String get introAskTitle => 'ఏదైనా అడగండి, ఆధారం చూడండి';

  @override
  String get introAskBody =>
      'ప్రతి జవాబు ఎక్కడి నుంచి వచ్చిందో చూపిస్తుంది — రికార్డింగ్, ప్రిస్క్రిప్షన్ లేదా ఫోటో.';

  @override
  String get letsSetUp => 'సెటప్ చేద్దాం';

  @override
  String get hospitalMode => 'హాస్పిటల్ మోడ్';

  @override
  String get consentRecording => 'అక్కడ ఉన్న అందరి అనుమతితో రికార్డింగ్';

  @override
  String get doctorConversation => 'డాక్టర్‌తో సంభాషణ';

  @override
  String get nurseInstructions => 'నర్స్ సూచనలు';

  @override
  String get pharmacistAdvice => 'ఫార్మసిస్ట్ సలహా';

  @override
  String get yourCarePlan => 'మీ సంరక్షణ ప్రణాళిక';

  @override
  String get afterBreakfast => 'టిఫిన్ తర్వాత';

  @override
  String get checkBloodPressure => 'BP చూడండి';

  @override
  String get twiceDaily => 'రోజుకు రెండు సార్లు';

  @override
  String get bloodTest => 'రక్త పరీక్ష (CBC)';

  @override
  String get instructionsFound =>
      'మీ రికార్డింగ్‌లు, ప్రిస్క్రిప్షన్‌లో 4 సూచనలు దొరికాయి';

  @override
  String get askQuestion => 'సాయంత్రం మందు గురించి డాక్టర్ ఏమి చెప్పారు?';

  @override
  String get askAnswer =>
      'Amlodipine రాత్రి భోజనం తర్వాత వేసుకోమని డాక్టర్ చెప్పారు.';

  @override
  String get sourceDoctorVisit => 'ఆధారం: డాక్టర్ విజిట్';

  @override
  String get careForTitle => 'Gurtu ఎవరి కోసం సెటప్ చేస్తున్నారు?';

  @override
  String get careForSubtitle =>
      'Gurtu ఒక వ్యక్తి చుట్టూ సంరక్షణ జ్ఞాపకాన్ని నిర్మిస్తుంది. మిగతా కుటుంబాన్ని తర్వాత ఆహ్వానించవచ్చు.';

  @override
  String get careForMyself => 'నా కోసం';

  @override
  String get careForMyselfHint => 'నా సొంత సంరక్షణను గమనించుకోవాలి';

  @override
  String get careForParent => 'నా తల్లిదండ్రులు';

  @override
  String get careForParentHint => 'అమ్మ, నాన్న లేదా ఇంట్లో పెద్దవారు';

  @override
  String get careForPartner => 'నా జీవిత భాగస్వామి';

  @override
  String get careForPartnerHint => 'భర్త, భార్య లేదా భాగస్వామి';

  @override
  String get careForChild => 'నా బిడ్డ';

  @override
  String get careForChildHint => 'కొడుకు లేదా కూతురు';

  @override
  String get careForOther => 'ఇంకెవరైనా';

  @override
  String get careForOtherHint => 'బంధువు, స్నేహితుడు లేదా పొరుగువారు';

  @override
  String get profileTitleSelf => 'మీ గురించి చెప్పండి';

  @override
  String get profileTitleOther => 'వారి గురించి చెప్పండి';

  @override
  String get profileSubtitleSelf =>
      'దీనితో Gurtu మిమ్మల్ని పేరుతో పిలుస్తుంది.';

  @override
  String get profileSubtitleOther => 'ఇంట్లో మీరు వారిని పిలిచే పేరు రాయండి.';

  @override
  String get yourName => 'మీ పేరు';

  @override
  String get whatDoYouCallThem => 'మీరు వారిని ఏమని పిలుస్తారు?';

  @override
  String exampleName(String name) {
    return 'ఉదా. $name';
  }

  @override
  String get sampleSelfName => 'లక్ష్మి';

  @override
  String get sampleYourName => 'ప్రియ';

  @override
  String get yourAge => 'మీ వయస్సు';

  @override
  String get theirAge => 'వారి వయస్సు';

  @override
  String get years => 'సంవత్సరాలు';

  @override
  String get decreaseAge => 'వయస్సు తగ్గించండి';

  @override
  String get increaseAge => 'వయస్సు పెంచండి';

  @override
  String get gender => 'లింగం';

  @override
  String get female => 'స్త్రీ';

  @override
  String get male => 'పురుషుడు';

  @override
  String get genderOther => 'ఇతర';

  @override
  String get andYou => 'మరి మీరు?';

  @override
  String get andYouBody => 'వారి కేర్ సర్కిల్‌లో మీరే మొదటి సభ్యులు.';

  @override
  String get conditionsTitleSelf => 'మీకు వీటిలో ఏదైనా ఆరోగ్య సమస్య ఉందా?';

  @override
  String conditionsTitleOther(String name) {
    return '$nameకి వీటిలో ఏదైనా ఆరోగ్య సమస్య ఉందా?';
  }

  @override
  String get conditionsSubtitle =>
      'వర్తించేవన్నీ ఎంచుకోండి. దీనితో Gurtu సంరక్షణ ప్రణాళికను సిద్ధం చేస్తుంది.';

  @override
  String get condDiabetes => 'షుగర్ (డయాబెటిస్)';

  @override
  String get condHighBp => 'హై BP';

  @override
  String get condHeart => 'గుండె సమస్య';

  @override
  String get condThyroid => 'థైరాయిడ్';

  @override
  String get condCholesterol => 'కొలెస్ట్రాల్';

  @override
  String get condAsthma => 'ఆస్తమా / శ్వాస సమస్య';

  @override
  String get condKidney => 'కిడ్నీ సమస్య';

  @override
  String get condArthritis => 'కీళ్ల నొప్పులు / ఆర్థరైటిస్';

  @override
  String get condStroke => 'గతంలో పక్షవాతం';

  @override
  String get condCancer => 'క్యాన్సర్ చికిత్స';

  @override
  String get noneOfThese => 'వీటిలో ఏదీ లేదు';

  @override
  String get notADoctor =>
      'Gurtu డాక్టర్ కాదు. ఇది ఎప్పుడూ రోగనిర్ధారణ చేయదు — కుటుంబం సంరక్షణను గుర్తుంచుకోవడానికి, నిర్వహించడానికి మాత్రమే సహాయపడుతుంది.';

  @override
  String get medicinesTitleSelf => 'మీరు రోజూ మందులు వేసుకుంటారా?';

  @override
  String medicinesTitleOther(String name) {
    return '$name రోజూ మందులు వేసుకుంటారా?';
  }

  @override
  String get medicinesSubtitle =>
      'మాత్రలు, సిరప్‌లు, ఇన్‌హేలర్లు లేదా ఇన్సులిన్ అన్నీ కలపండి.';

  @override
  String get howMany => 'సుమారు ఎన్ని?';

  @override
  String get sixOrMore => '6 లేదా ఎక్కువ';

  @override
  String get scanLaterTip =>
      'తర్వాత ప్రిస్క్రిప్షన్ లేదా మందుల స్ట్రిప్‌ను స్కాన్ చేస్తే చాలు — టైప్ చేయనక్కర్లేదు.';

  @override
  String get allergiesTitleSelf => 'మీకు ఏదైనా అలర్జీ ఉందా?';

  @override
  String allergiesTitleOther(String name) {
    return '$nameకి ఏదైనా అలర్జీ ఉందా?';
  }

  @override
  String get allergiesSubtitle =>
      'ఇది ఎప్పటికీ మిస్ కాకుండా Gurtu ప్రతి డాక్టర్ బ్రీఫ్‌లో చూపిస్తుంది.';

  @override
  String get allergyNone => 'తెలిసిన అలర్జీలు లేవు';

  @override
  String get allergyPenicillin => 'పెన్సిలిన్';

  @override
  String get allergySulfa => 'సల్ఫా మందులు';

  @override
  String get allergyAspirin => 'ఆస్పిరిన్ / నొప్పి మాత్రలు';

  @override
  String get allergyFood => 'ఆహార అలర్జీ';

  @override
  String get allergyDust => 'దుమ్ము / పుప్పొడి';

  @override
  String get allergyLatex => 'లేటెక్స్';

  @override
  String get mobilityTitleSelf => 'రోజువారీ మీరు ఎలా తిరుగుతారు?';

  @override
  String mobilityTitleOther(String name) {
    return 'రోజువారీ $name ఎలా తిరుగుతారు?';
  }

  @override
  String get mobilitySubtitle =>
      'దీనితో కుటుంబం విజిట్లు, పరీక్షలు, ఇంట్లో సహాయాన్ని ప్లాన్ చేసుకోవచ్చు.';

  @override
  String get mobilityIndependent => 'సొంతంగా నడుస్తారు';

  @override
  String get mobilityIndependentHint => 'రోజువారీ పనులకు సహాయం అక్కర్లేదు';

  @override
  String get mobilitySomeHelp => 'కొంచెం సహాయం కావాలి';

  @override
  String get mobilitySomeHelpHint => 'కర్ర, వాకర్ లేదా ఎవరైనా చేయి పట్టుకోవాలి';

  @override
  String get mobilityFullHelp => 'ఎక్కువగా మంచం లేదా వీల్‌చైర్‌లో';

  @override
  String get mobilityFullHelpHint => 'చాలా పనులకు సహాయం కావాలి';

  @override
  String get hospitalTitleSelf =>
      'గత 30 రోజుల్లో మీరు హాస్పిటల్‌కి లేదా డాక్టర్ దగ్గరికి వెళ్లారా?';

  @override
  String hospitalTitleOther(String name) {
    return 'గత 30 రోజుల్లో $name హాస్పిటల్‌కి లేదా డాక్టర్ దగ్గరికి వెళ్లారా?';
  }

  @override
  String get hospitalSubtitle =>
      'ఇటీవలి విజిట్లతో సాధారణంగా కొత్త సూచనలు వస్తాయి.';

  @override
  String get hospitalTip =>
      'డిశ్చార్జ్ పేపర్లు, ప్రిస్క్రిప్షన్లు దగ్గర ఉంచుకోండి — సెటప్ అయిన వెంటనే స్కాన్ చేయవచ్చు.';

  @override
  String get permissionsTitle => 'మీకు సహాయపడే కొన్ని అనుమతులు';

  @override
  String get permissionsSubtitle =>
      'Gurtu అవసరమైనవే అడుగుతుంది. ఎందుకో ఇక్కడ ఉంది.';

  @override
  String get permMic => 'మైక్రోఫోన్';

  @override
  String get permMicWhy =>
      'డాక్టర్ విజిట్లు, వాయిస్ నోట్లు రికార్డ్ చేయడానికి — మీరు రికార్డ్ నొక్కినప్పుడే.';

  @override
  String get permCamera => 'కెమెరా';

  @override
  String get permCameraWhy =>
      'ప్రిస్క్రిప్షన్లు, మందుల స్ట్రిప్‌లు, BP మెషిన్ రీడింగ్‌లు స్కాన్ చేయడానికి.';

  @override
  String get permNotifications => 'నోటిఫికేషన్లు';

  @override
  String get permNotificationsWhy =>
      'మందుల రిమైండర్లు, కుటుంబం పని పూర్తి చేసినప్పుడు అప్‌డేట్లు.';

  @override
  String get permPhotos => 'ఫోటోలు & ఫైళ్లు';

  @override
  String get permPhotosWhy =>
      'గ్యాలరీలో ఉన్న రిపోర్టులు, ప్రిస్క్రిప్షన్లు జోడించడానికి.';

  @override
  String get permContacts => 'కాంటాక్ట్‌లు';

  @override
  String get permContactsWhy =>
      'కుటుంబ సభ్యులను కేర్ సర్కిల్‌కి త్వరగా ఆహ్వానించడానికి.';

  @override
  String get needed => 'అవసరం';

  @override
  String get allow => 'అనుమతించు';

  @override
  String get allowed => 'అనుమతించబడింది';

  @override
  String get allowAndContinue => 'అనుమతించి కొనసాగించండి';

  @override
  String get privacyNote =>
      'అంతా ఈ ఫోన్‌లోనే ఉంటుంది. రికార్డింగ్ ఎప్పుడూ దానంతట అదే మొదలవదు — ముందు అనుమతి స్క్రీన్ చూపిస్తుంది.';

  @override
  String permissionBlocked(String permission) {
    return '$permission బ్లాక్ అయింది. సెట్టింగ్స్‌లో ఆన్ చేయండి.';
  }

  @override
  String get settings => 'సెట్టింగ్స్';

  @override
  String permissionsMissing(String items) {
    return '$items లేకుండా కొన్ని ఫీచర్లు పని చేయవు. తర్వాత అనుమతించవచ్చు.';
  }

  @override
  String get modelTitleChoose => 'Gurtu ఆన్-డివైస్ AI సెటప్ చేయండి';

  @override
  String get modelTitleDownloading => 'మీ AI సెటప్ అవుతోంది…';

  @override
  String get modelTitleDone => 'మీ AI సిద్ధంగా ఉంది';

  @override
  String get modelSubtitleChoose =>
      'ఈ మోడళ్లు పూర్తిగా మీ iQOOలోనే నడుస్తాయి. కుటుంబ ఆరోగ్య సమాచారం ఫోన్ బయటకు వెళ్లదు — ఇంటర్నెట్ లేకుండా కూడా పని చేస్తుంది.';

  @override
  String get modelSubtitleDownloading =>
      'మీరు ఫోన్ వాడుకుంటూనే ఉండవచ్చు. ఇది ఒక్కసారే జరుగుతుంది.';

  @override
  String get modelSubtitleDone =>
      'అంతా ఈ ఫోన్‌లోనే నడుస్తుంది, ఆఫ్‌లైన్‌లో కూడా.';

  @override
  String get poweredByIqoo => 'మీ iQOO శక్తితో';

  @override
  String get deviceCardSub =>
      'ఆన్-డివైస్ AI · ప్రైవేట్ · ఆఫ్‌లైన్‌లో పనిచేస్తుంది';

  @override
  String get chooseCareModel => 'కేర్ మోడల్ ఎంచుకోండి';

  @override
  String get careModelHint => 'మీ ప్రశ్నలకు జవాబిచ్చే మెదడు ఇదే.';

  @override
  String get alwaysIncluded => 'ఎప్పుడూ ఉంటాయి';

  @override
  String get jobListens => 'వింటుంది';

  @override
  String get jobReads => 'చదువుతుంది';

  @override
  String get jobSees => 'చూస్తుంది';

  @override
  String get jobUnderstands => 'అర్థం చేసుకుంటుంది';

  @override
  String speechModelName(String language) {
    return 'మాట · $language + ఇంగ్లీష్';
  }

  @override
  String get speechModelWhat => 'సంభాషణలను మీ భాషలో అక్షరాలుగా మారుస్తుంది.';

  @override
  String get readerModelName => 'డాక్యుమెంట్ రీడర్ (OCR)';

  @override
  String get readerModelWhat =>
      'ప్రిస్క్రిప్షన్లు, డిశ్చార్జ్ పేపర్లు, ల్యాబ్ రిపోర్టులు చదువుతుంది.';

  @override
  String get visionModelName => 'మందులు & రీడింగ్ గుర్తింపు';

  @override
  String get visionModelWhat =>
      'మందుల స్ట్రిప్‌లు, BP / షుగర్ మెషిన్ అంకెలను గుర్తిస్తుంది.';

  @override
  String careModelName(String model) {
    return 'కేర్ మోడల్ · $model';
  }

  @override
  String get tierLite => 'లైట్';

  @override
  String get tierBalanced => 'బ్యాలెన్స్‌డ్';

  @override
  String get tierPro => 'ప్రో';

  @override
  String get tierLiteNote => 'అత్యంత వేగం. చిన్న, సులభమైన జవాబులు.';

  @override
  String get tierBalancedNote =>
      'మాట, ఫోటోలు, టెక్స్ట్‌ను కలిపి అర్థం చేసుకుంటుంది.';

  @override
  String get tierProNote => 'అత్యంత వివరమైన జవాబులు, డాక్టర్ బ్రీఫ్‌లు.';

  @override
  String get bestForIqoo => 'iQOOకి ఉత్తమం';

  @override
  String get wifiOnly => 'Wi-Fiలో మాత్రమే డౌన్‌లోడ్ చేయండి';

  @override
  String downloadSize(String size) {
    return 'డౌన్‌లోడ్ · $size';
  }

  @override
  String get settingUp => 'సెటప్ అవుతోంది…';

  @override
  String get ready => 'సిద్ధం';

  @override
  String allSetName(String name) {
    return 'అంతా సిద్ధం, $name!';
  }

  @override
  String get allSet => 'అంతా సిద్ధం!';

  @override
  String get readySelf => 'మీ సంరక్షణ జ్ఞాపకం సిద్ధంగా ఉంది.';

  @override
  String readyOther(String name) {
    return '$name సంరక్షణ జ్ఞాపకం సిద్ధంగా ఉంది. ఇప్పుడు కుటుంబాన్ని ఆహ్వానించండి.';
  }

  @override
  String get rowYou => 'మీరు';

  @override
  String get rowCaringFor => 'ఎవరి సంరక్షణ';

  @override
  String get rowHealth => 'ఆరోగ్యం';

  @override
  String get rowAllergies => 'అలర్జీలు';

  @override
  String get rowLanguage => 'భాష';

  @override
  String get rowAi => 'ఆన్-డివైస్ AI';

  @override
  String get notAdded => 'జోడించలేదు';

  @override
  String ageYears(int age) {
    return '$age సంవత్సరాలు';
  }

  @override
  String get careQuote => '“కలిసి చూసుకుంటే సంరక్షణ తేలికవుతుంది.”';

  @override
  String get enterGurtu => 'Gurtu లోకి వెళ్లండి';

  @override
  String get nextUpCareCircle => 'తర్వాత: కేర్ సర్కిల్';

  @override
  String get homeComingSoon => 'హోమ్ స్క్రీన్లు తర్వాతి భాగంలో వస్తాయి.';

  @override
  String get restartOnboarding => 'ఆన్‌బోర్డింగ్ మళ్లీ మొదలుపెట్టండి';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navMemory => 'జ్ఞాపకాలు';

  @override
  String get navCircle => 'సర్కిల్';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String goodMorning(String name) {
    return 'శుభోదయం, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'నమస్కారం, $name';
  }

  @override
  String goodEvening(String name) {
    return 'శుభ సాయంత్రం, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu కి స్వాగతం, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'మీ కుటుంబ ఆరోగ్యం, అందరూ కలిసి గుర్తుంచుకోండి.';

  @override
  String get caringFor => 'సంరక్షణ';

  @override
  String get switchPatientTitle => 'మీరు ఎవరిని చూసుకుంటున్నారు?';

  @override
  String get addAnotherPerson => 'మరొకరిని జోడించండి';

  @override
  String get statusOnTrack => 'సంరక్షణ సరిగ్గా సాగుతోంది';

  @override
  String get statusNeedsAttention => 'ఒక విషయం పట్టించుకోవాలి';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'అత్యవసరం';

  @override
  String get sosHoldTitle =>
      'కేర్ సర్కిల్‌ని అప్రమత్తం చేయడానికి నొక్కి పట్టుకోండి';

  @override
  String get sosHoldBody =>
      'బటన్‌ను 2 సెకన్లు నొక్కి పట్టుకోండి. మీ అత్యవసర కాంటాక్ట్‌లకు అలర్ట్ వెళ్తుంది.';

  @override
  String get sosHoldButton => 'SOS పంపడానికి నొక్కి పట్టుకోండి';

  @override
  String get sosKeepHolding => 'పట్టుకునే ఉండండి…';

  @override
  String get sosPreviewNote =>
      'అత్యవసర అలర్ట్‌లు ఇంకా కనెక్ట్ కాలేదు. ఇది ప్రివ్యూ మాత్రమే — ఎవరికీ అలర్ట్ వెళ్లదు.';

  @override
  String get sosPreviewDone => 'ప్రివ్యూ పూర్తయింది. ఎవరికీ అలర్ట్ వెళ్లలేదు.';

  @override
  String get close => 'మూసివేయండి';

  @override
  String get todayCare => 'ఈరోజు సంరక్షణ';

  @override
  String completedOf(int done, int total) {
    return '$totalలో $done పూర్తి';
  }

  @override
  String get viewTodayCare => 'ఈరోజు సంరక్షణ చూడండి';

  @override
  String get nothingUrgent => 'ప్రస్తుతం అత్యవసరం ఏమీ లేదు.';

  @override
  String get markDone => 'పూర్తయినట్లు గుర్తించండి';

  @override
  String get markNotDone => 'పూర్తి కానట్లు గుర్తించండి';

  @override
  String get openToCircle => 'కేర్ సర్కిల్ అందరికీ';

  @override
  String get captureCare => 'సంరక్షణ నమోదు';

  @override
  String get captureCareSubtitle =>
      'సంరక్షణలో ముఖ్యమైన విషయాన్ని నమోదు చేయండి.';

  @override
  String get whatHappened => 'ఏమి జరిగింది?';

  @override
  String get captureVoice => 'వాయిస్';

  @override
  String get captureVoiceHint => 'సంభాషణ లేదా వాయిస్ నోట్ రికార్డ్ చేయండి';

  @override
  String get captureScan => 'స్కాన్';

  @override
  String get captureScanHint => 'ప్రిస్క్రిప్షన్ లేదా మందుల స్ట్రిప్';

  @override
  String get captureVital => 'రీడింగ్';

  @override
  String get captureVitalHint => 'BP, షుగర్ లేదా జ్వరం';

  @override
  String get captureDocument => 'డాక్యుమెంట్';

  @override
  String get captureDocumentHint => 'డిశ్చార్జ్ పేపర్ లేదా ల్యాబ్ రిపోర్ట్';

  @override
  String get captureNote => 'నోట్';

  @override
  String get captureNoteHint => 'ఏమి జరిగిందో రాయండి';

  @override
  String get comingSoon => 'త్వరలో వస్తుంది';

  @override
  String get noteHint => 'ఉదా. నడిచాక తల తిరిగింది';

  @override
  String get saveNote => 'నోట్ సేవ్ చేయండి';

  @override
  String get noteSaved => 'సంరక్షణ జ్ఞాపకంలో సేవ్ అయింది';

  @override
  String get recentMemory => 'ఇటీవలి జ్ఞాపకాలు';

  @override
  String get viewAll => 'అన్నీ చూడండి';

  @override
  String get emptyMemory => 'మీ సంరక్షణ కథ ఇక్కడ మొదలవుతుంది.';

  @override
  String addedBy(String name) {
    return '$name జోడించారు';
  }

  @override
  String get sourcePlay => 'వినండి';

  @override
  String get sourceView => 'చూడండి';

  @override
  String get sourceOpen => 'తెరవండి';

  @override
  String get sourceTitle => 'ఆధారం';

  @override
  String get sourceRecording => 'డాక్టర్ రికార్డింగ్';

  @override
  String get sourceScan => 'ప్రిస్క్రిప్షన్ స్కాన్';

  @override
  String get sourceVital => 'రీడింగ్';

  @override
  String get sourceDocument => 'డాక్యుమెంట్';

  @override
  String get sourceNote => 'రాసిన నోట్';

  @override
  String get sourceSampleNote =>
      'ఇది నమూనా డేటా, కాబట్టి అసలు ఫైల్ లేదు. నిజమైన రికార్డింగ్‌లు, స్కాన్‌లు ఇక్కడ తెరుచుకుంటాయి.';

  @override
  String get yourCareCircle => 'మీ కేర్ సర్కిల్';

  @override
  String get manageCircle => 'సర్కిల్ నిర్వహించండి';

  @override
  String get emptyCircle => 'కలిసి చూసుకుంటే సంరక్షణ సులభం.';

  @override
  String get addFamilyMember => 'కుటుంబ సభ్యుడిని జోడించండి';

  @override
  String get rolePatient => 'పేషెంట్';

  @override
  String get roleCaregiver => 'సంరక్షకులు';

  @override
  String get roleFamily => 'కుటుంబం';

  @override
  String get roleHelper => 'నమ్మకమైన సహాయకులు';

  @override
  String get askGurtuTitle => 'Gurtu ని అడగండి';

  @override
  String get askGurtuPrompt => 'ఏదైనా గుర్తుంచుకోవడానికి సహాయం కావాలా?';

  @override
  String get askExampleBloodTest => 'రక్త పరీక్ష ఎప్పుడు?';

  @override
  String get askExampleDoctor => 'రేపు డాక్టర్‌ని ఏమి అడగాలి?';

  @override
  String get askGurtuNote =>
      'జవాబులు మీరు సేవ్ చేసిన సంరక్షణ సమాచారం నుంచే వస్తాయి.';

  @override
  String get gettingReady => 'Gurtu సిద్ధమవుతోంది';

  @override
  String get readyYourProfile => 'మీ ప్రొఫైల్';

  @override
  String get readyPatientProfile => 'పేషెంట్ ప్రొఫైల్';

  @override
  String get readyCareCircle => 'కేర్ సర్కిల్';

  @override
  String get readyEmergencyContact => 'అత్యవసర కాంటాక్ట్';

  @override
  String get previewSampleData => 'నమూనా డేటాతో చూడండి';

  @override
  String get sampleDataOn => 'నమూనా సంరక్షణ డేటా చూపిస్తోంది';

  @override
  String get remove => 'తొలగించండి';

  @override
  String get hide => 'దాచండి';

  @override
  String get comingNextPhase => 'ఈ భాగం తర్వాత తయారవుతోంది.';

  @override
  String get fatherName => 'నాన్న';

  @override
  String get sampleTaskMorningMedicine => 'ఉదయం మందు';

  @override
  String get sampleTaskRecordBp => 'BP నమోదు';

  @override
  String get sampleTaskBloodTest => 'రక్త పరీక్ష';

  @override
  String get sampleTaskDoctorVisit => 'డాక్టర్ అపాయింట్‌మెంట్';

  @override
  String get sampleMomentDoctorTalk => 'డాక్టర్‌తో సంభాషణ';

  @override
  String get sampleMomentDoctorTalkDetail => '“టిఫిన్ తర్వాత మందు వేసుకోండి.”';

  @override
  String get sampleMomentPrescription => 'ప్రిస్క్రిప్షన్ స్కాన్ చేశారు';

  @override
  String get sampleMomentPrescriptionDetail => '2 మందులు దొరికాయి';

  @override
  String get sampleMomentBp => 'BP నమోదు చేశారు';

  @override
  String get today => 'ఈరోజు';

  @override
  String get yesterday => 'నిన్న';

  @override
  String get doctorVisit => 'డాక్టర్ విజిట్';

  @override
  String get doctorVisitHint => 'డాక్టర్ చెప్పింది నోట్ చేయండి';

  @override
  String get askDoctor => 'డాక్టర్‌ను అడగాల్సిన ప్రశ్నలు';

  @override
  String get askDoctorHint => 'Gurtu సిద్ధం చేయడంలో సహాయపడుతుంది';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ప్రశ్నలు సిద్ధం',
      one: '1 ప్రశ్న సిద్ధం',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'చివరి విజిట్: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'తదుపరి విజిట్: $date';
  }

  @override
  String get visitsTitle => 'డాక్టర్ విజిట్‌లు';

  @override
  String get visitsSubtitle => 'ప్రతి డాక్టర్ చెప్పింది, అంతా ఒకే చోట.';

  @override
  String get recordVisit => 'విజిట్ రికార్డ్ చేయండి';

  @override
  String get visitsOverview => 'అన్ని విజిట్‌లు ఒక్క చూపులో';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count విజిట్‌లు',
      one: '1 విజిట్',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మంది డాక్టర్లు',
      one: '1 డాక్టర్',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'చివరి విజిట్';

  @override
  String get nextVisit => 'తదుపరి విజిట్';

  @override
  String get notPlanned => 'ఇంకా నిర్ణయించలేదు';

  @override
  String get pastVisits => 'గత విజిట్‌లు';

  @override
  String get noVisitsTitle => 'ఇంకా విజిట్‌లు నమోదు కాలేదు';

  @override
  String get noVisitsBody =>
      'తదుపరి అపాయింట్‌మెంట్‌లో ‘విజిట్ రికార్డ్ చేయండి’ నొక్కండి, డాక్టర్ చెప్పేది Gurtu నోట్ చేస్తుంది.';

  @override
  String get questionsForNextVisit => 'తదుపరి విజిట్ ప్రశ్నలు';

  @override
  String get prepareQuestionsHint =>
      'మీకు ఎలా ఉందో Gurtuకు చెప్పండి. డాక్టర్‌ను ఏమి అడగాలో సూచిస్తుంది.';

  @override
  String get prepareQuestions => 'ప్రశ్నలు సిద్ధం చేయండి';

  @override
  String get viewQuestions => 'ప్రశ్నలు చూడండి';

  @override
  String get doctorFallback => 'డాక్టర్';

  @override
  String get doctorSaid => 'డాక్టర్ ఏం చెప్పారు';

  @override
  String get medicinesSection => 'మందులు';

  @override
  String get testsSection => 'చేయించాల్సిన పరీక్షలు';

  @override
  String get questionsAsked => 'అడిగిన ప్రశ్నలు';

  @override
  String askedOf(int asked, int total) {
    return '$totalలో $asked అడిగారు';
  }

  @override
  String get deleteVisit => 'విజిట్ తొలగించండి';

  @override
  String get deleteVisitConfirm =>
      'ఈ విజిట్ తొలగించాలా? దీన్ని తిరిగి పొందలేరు.';

  @override
  String get cancel => 'రద్దు';

  @override
  String get delete => 'తొలగించు';

  @override
  String get doctorName => 'డాక్టర్ పేరు';

  @override
  String get doctorNameHint => 'ఉదా. డా. మీనా రావు';

  @override
  String get visitReason => 'విజిట్ కారణం';

  @override
  String get visitReasonHint => 'ఉదా. షుగర్ చెకప్';

  @override
  String get visitDate => 'విజిట్ తేదీ';

  @override
  String get listenToDoctor => 'డాక్టర్ మాటలు వినండి';

  @override
  String get stopListening => 'వినడం ఆపండి';

  @override
  String get speak => 'మాట్లాడండి';

  @override
  String get recordingConsent =>
      'మీరు Gurtuతో సంభాషణ నోట్ చేస్తున్నారని డాక్టర్‌కు చెప్పండి.';

  @override
  String get doctorSaidHint => 'డాక్టర్ చెప్పేది మాట్లాడండి లేదా టైప్ చేయండి';

  @override
  String get medicinesHint => 'ఉదా. మెట్‌ఫార్మిన్ 500 mg టిఫిన్ తర్వాత';

  @override
  String get testsHint => 'ఉదా. HbA1c రక్త పరీక్ష';

  @override
  String get addNextVisit => 'తదుపరి విజిట్ తేదీ జోడించండి';

  @override
  String get yourQuestions => 'మీ ప్రశ్నలు';

  @override
  String get tickWhenAsked =>
      'డాక్టర్ సమాధానం చెప్పాక ప్రతిదానికీ టిక్ పెట్టండి.';

  @override
  String get saveVisit => 'విజిట్ సేవ్ చేయండి';

  @override
  String get visitSaved => 'విజిట్ సేవ్ అయింది';

  @override
  String get leaveVisitTitle => 'సేవ్ చేయకుండా వెళ్లాలా?';

  @override
  String get leaveVisitBody => 'ఈ విజిట్‌కు మీరు నోట్ చేసినది పోతుంది.';

  @override
  String get discard => 'వదిలేయండి';

  @override
  String get keepEditing => 'రాయడం కొనసాగించండి';

  @override
  String get voiceUnavailable =>
      'ప్రస్తుతం వాయిస్ ఇన్‌పుట్ అందుబాటులో లేదు. మీరు టైప్ చేయవచ్చు.';

  @override
  String get prepTitle => 'డాక్టర్ కోసం సిద్ధం';

  @override
  String get prepIntro =>
      'డాక్టర్ దగ్గరకు వెళ్లడానికి సిద్ధమవుదాం. ఏ ఆరోగ్య సమస్యల గురించి మాట్లాడాలి?';

  @override
  String get prepPickOrSay =>
      'కింద సమస్యలు ఎంచుకోండి, లేదా మీ మాటల్లో చెప్పండి.';

  @override
  String get prepDescribeHint => 'ఉదా. మూడు రోజులుగా తలనొప్పి, నీరసం';

  @override
  String prepHeard(String symptoms) {
    return 'నేను విన్నది: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — ఎప్పటి నుంచి?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — ఎంత తీవ్రంగా ఉంది?';
  }

  @override
  String get askNewMedicine => 'ఇటీవల ఏదైనా మందు మొదలుపెట్టారా లేదా మార్చారా?';

  @override
  String get askAnythingElse => 'డాక్టర్‌కు ఇంకేమైనా చెప్పాలా?';

  @override
  String get urgentWarning =>
      'తీవ్రమైన ఛాతీ నొప్పి లేదా ఆయాసం అత్యవసర పరిస్థితి కావచ్చు. అపాయింట్‌మెంట్ కోసం ఆగకండి — వెంటనే వైద్య సహాయం తీసుకోండి.';

  @override
  String get prepThinking => 'మీ ప్రశ్నలు సిద్ధమవుతున్నాయి…';

  @override
  String get prepResultIntro =>
      'డాక్టర్‌ను ఇవి అడగండి. అవసరం లేనివి తీసేయండి, లేదా మీ ప్రశ్న జోడించండి.';

  @override
  String get prepNotDoctor =>
      'Gurtu డాక్టర్ కాదు. ఈ ప్రశ్నలు డాక్టర్‌తో మాట్లాడటానికి సహాయపడతాయి.';

  @override
  String get addOwnQuestion => 'మీ సొంత ప్రశ్న జోడించండి';

  @override
  String get add => 'జోడించు';

  @override
  String get saveQuestions => 'విజిట్ కోసం సేవ్ చేయండి';

  @override
  String get questionsSaved => 'ప్రశ్నలు విజిట్ కోసం సేవ్ అయ్యాయి';

  @override
  String get startAgain => 'మళ్లీ మొదలుపెట్టండి';

  @override
  String get startVisit => 'విజిట్ ప్రారంభించండి';

  @override
  String get deleteQuestions => 'ఈ ప్రశ్నలు తొలగించండి';

  @override
  String get removeQuestion => 'ప్రశ్న తీసేయండి';

  @override
  String get done => 'అయింది';

  @override
  String get healthProblems => 'ఆరోగ్య సమస్యలు';

  @override
  String preparedOn(String date) {
    return '$dateన సిద్ధం చేశారు';
  }

  @override
  String get symFever => 'జ్వరం';

  @override
  String get symHeadache => 'తలనొప్పి';

  @override
  String get symBodyPain => 'ఒళ్లు లేదా కీళ్ల నొప్పులు';

  @override
  String get symChestPain => 'ఛాతీ నొప్పి';

  @override
  String get symBreathless => 'ఆయాసం';

  @override
  String get symCough => 'దగ్గు';

  @override
  String get symDizziness => 'కళ్లు తిరగడం';

  @override
  String get symTiredness => 'నీరసం';

  @override
  String get symStomach => 'కడుపు సమస్య';

  @override
  String get symPoorSleep => 'నిద్ర పట్టకపోవడం';

  @override
  String get symPoorAppetite => 'ఆకలి తగ్గడం';

  @override
  String get symLowMood => 'బాధ లేదా ఆందోళన';

  @override
  String get kwFever => 'జ్వరం,జొరం,వేడి,చలి';

  @override
  String get kwHeadache => 'తలనొప్పి,తల నొప్పి';

  @override
  String get kwBodyPain =>
      'ఒళ్లు నొప్పులు,కీళ్ల నొప్పులు,మోకాలు,నడుము నొప్పి,కాళ్ల నొప్పులు';

  @override
  String get kwChestPain => 'ఛాతీ,గుండె నొప్పి,ఛాతి';

  @override
  String get kwBreathless => 'ఆయాసం,ఊపిరి,శ్వాస';

  @override
  String get kwCough => 'దగ్గు,కఫం,జలుబు';

  @override
  String get kwDizziness => 'కళ్లు తిరగడం,తల తిరగడం,కళ్ళు తిరుగుతున్నాయి,స్పృహ';

  @override
  String get kwTiredness => 'నీరసం,అలసట,బలహీనం';

  @override
  String get kwStomach =>
      'కడుపు,అసిడిటీ,గ్యాస్,వాంతి,విరేచనాలు,మలబద్ధకం,వికారం';

  @override
  String get kwPoorSleep => 'నిద్ర,నిద్రలేమి';

  @override
  String get kwPoorAppetite => 'ఆకలి,తినడం లేదు';

  @override
  String get kwLowMood => 'బాధ,ఆందోళన,భయం,టెన్షన్,ఒత్తిడి,దిగులు';

  @override
  String get sinceToday => 'ఈరోజు నుంచి';

  @override
  String get sinceFewDays => 'కొన్ని రోజులుగా';

  @override
  String get sinceWeek => 'దాదాపు వారం రోజులుగా';

  @override
  String get sinceMonth => 'నెల లేదా అంతకంటే ఎక్కువ';

  @override
  String get sevMild => 'తక్కువగా';

  @override
  String get sevModerate => 'మధ్యస్థంగా';

  @override
  String get sevSevere => 'తీవ్రంగా';

  @override
  String qCause(String symptom) {
    return '$symptomకి కారణం ఏమై ఉండవచ్చు?';
  }

  @override
  String qTests(String symptom) {
    return '$symptomకి ఏవైనా పరీక్షలు అవసరమా?';
  }

  @override
  String qWarningSigns(String symptom) {
    return '$symptomతో ఏ లక్షణాలు కనిపిస్తే వెంటనే రావాలి?';
  }

  @override
  String qHomeCare(String symptom) {
    return '$symptom తగ్గడానికి ఇంట్లో ఏం చేయవచ్చు?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return '$symptomకి $conditionsతో సంబంధం ఉండవచ్చా?';
  }

  @override
  String get qSideEffect => 'కొత్త లేదా మార్చిన మందు వల్ల ఇది జరుగుతుందా?';

  @override
  String get qMedicinesStillRight =>
      'ఇప్పుడు వాడుతున్న మందులు సరైనవేనా, ఏవైనా మార్చాలా?';

  @override
  String get qNextCheckup => 'తదుపరి చెకప్‌కు ఎప్పుడు రావాలి?';

  @override
  String qTellDoctor(String text) {
    return 'డాక్టర్‌కు చెప్పండి: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'డయాబెటిస్ రివ్యూ';

  @override
  String get sampleVisitDiabetesNotes =>
      'షుగర్ మునుపటి కంటే బాగా కంట్రోల్‌లో ఉంది. అవే మందులు కొనసాగించండి. రోజూ 30 నిమిషాలు నడవండి, తీపి తగ్గించండి.';

  @override
  String get sampleVisitDiabetesMeds =>
      'మెట్‌ఫార్మిన్ 500 mg టిఫిన్ మరియు రాత్రి భోజనం తర్వాత';

  @override
  String get sampleVisitDiabetesTests =>
      'తదుపరి విజిట్ ముందు HbA1c రక్త పరీక్ష';

  @override
  String get sampleVisitKneeReason => 'మోకాలి నొప్పి';

  @override
  String get sampleVisitKneeNotes =>
      'కుడి మోకాలిలో కొంచెం ఆర్థరైటిస్. సాయంత్రం వేడి కాపడం పెట్టండి, ఎక్కువ మెట్లు ఎక్కకండి.';

  @override
  String get sampleVisitKneeMeds => 'నొప్పి తగ్గించే జెల్ రోజుకు రెండుసార్లు';

  @override
  String get scanVerify => 'మందు స్కాన్ చేసి సరిచూడండి';

  @override
  String get scanVerifyHint => 'ఇదే మాత్ర ఇప్పుడు వేసుకోవాలా?';

  @override
  String scanVerifySubtitle(String name) {
    return 'స్ట్రిప్ లేదా డబ్బా స్కాన్ చేయండి. Gurtu దాన్ని $name మందుల జాబితాతో సరిచూస్తుంది.';
  }

  @override
  String get scanWithCamera => 'మందును స్కాన్ చేయండి';

  @override
  String get orTypeName => 'లేదా స్ట్రిప్‌పై ఉన్న పేరు టైప్ చేయండి';

  @override
  String get typeNameHint => 'ఉదా. Glycomet 500';

  @override
  String get checkMedicine => 'సరిచూడు';

  @override
  String get checkAnother => 'మరో మందు సరిచూడండి';

  @override
  String get readingStrip => 'స్ట్రిప్ చదువుతోంది…';

  @override
  String get cameraUnavailable =>
      'కెమెరా స్కాన్ ఫోన్ యాప్‌లో పనిచేస్తుంది. ఇప్పుడు పేరు టైప్ చేయండి.';

  @override
  String get scanFailed =>
      'ఫోటో చదవలేకపోయాం. మళ్లీ ప్రయత్నించండి, లేదా పేరు టైప్ చేయండి.';

  @override
  String readFromStrip(String text) {
    return 'స్ట్రిప్‌పై చదివింది: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'Gurtu మీరు సేవ్ చేసిన మందులతో మాత్రమే సరిచూస్తుంది. ఎప్పుడూ మందులు సూచించదు.';

  @override
  String get verdictTakeNow => 'అవును — ఇదే సరైన మందు, ఇప్పుడు వేసుకోవచ్చు.';

  @override
  String get verdictNotNow => 'మందు సరైనదే, కానీ ఇప్పుడు వేసుకునే సమయం కాదు.';

  @override
  String get verdictAlreadyTaken =>
      'ఈ డోస్ ఇప్పటికే వేసుకున్నారు. మళ్లీ వేసుకోకండి.';

  @override
  String get verdictNoTimes => 'మందు సరైనదే, కానీ దీని సమయం సేవ్ కాలేదు.';

  @override
  String get verdictWrongStrength =>
      'ఆగండి — మోతాదు (mg) ప్రిస్క్రిప్షన్‌కు భిన్నంగా ఉంది.';

  @override
  String verdictNotOnList(String name) {
    return 'ఆగండి — ఈ మందు $name జాబితాలో లేదు.';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'ఆగండి — ఈ మందు $other జాబితాలోది, $nameది కాదు.';
  }

  @override
  String get verdictUnreadable =>
      'మందు పేరు చదవలేకపోయాం. మంచి వెలుతురులో మళ్లీ ప్రయత్నించండి, లేదా టైప్ చేయండి.';

  @override
  String get verdictCheckFirst =>
      'డాక్టర్ లేదా ఫార్మసిస్ట్‌ను అడగకుండా వేసుకోకండి.';

  @override
  String get rowOnList => 'మందుల జాబితాలో ఉంది';

  @override
  String rowStrengthMatches(String strength) {
    return 'మోతాదు సరిపోయింది: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'స్ట్రిప్‌పై $found, ప్రిస్క్రిప్షన్‌లో $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'ఇప్పుడు వేసుకోవాలి: $slot డోస్';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot డోస్ $timeకి వేసుకున్నారు';
  }

  @override
  String rowNextDose(String slot) {
    return 'తదుపరి డోస్: $slot';
  }

  @override
  String get rowSetTimes => 'మందుల జాబితాలో ఎప్పుడు వేసుకోవాలో జోడించండి';

  @override
  String get markTaken => 'వేసుకున్నట్లు నమోదు చేయండి';

  @override
  String get markedTaken => 'డోస్ నమోదైంది';

  @override
  String get undo => 'రద్దు చేయి';

  @override
  String get medicineList => 'మందుల జాబితా';

  @override
  String get medicineListSubtitle =>
      'ప్రిస్క్రిప్షన్లలోని ప్రతి మందు, ఎప్పుడు వేసుకోవాలో సహా.';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మందులు',
      one: '1 మందు',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'మందు జోడించండి';

  @override
  String get editMedicine => 'మందు మార్చండి';

  @override
  String get addFromPrescription => 'ప్రిస్క్రిప్షన్ ఫోటో నుంచి జోడించండి';

  @override
  String get noMedicinesTitle => 'ఇంకా మందులు జోడించలేదు';

  @override
  String get noMedicinesBody =>
      'ప్రిస్క్రిప్షన్‌లోని ప్రతి మందును ఒకసారి జోడించండి. తర్వాత ఏ స్ట్రిప్ అయినా స్కాన్ చేసి సరైనదో కాదో చూడండి.';

  @override
  String addMedicinesFirst(String name) {
    return 'ముందుగా $name మందులు జోడించండి, అప్పుడు Gurtu వాటితో సరిచూడగలదు.';
  }

  @override
  String get medicineName => 'మందు పేరు';

  @override
  String get medicineNameHint => 'ఉదా. Metformin';

  @override
  String get alsoCalled => 'స్ట్రిప్‌పై ఉన్న ఇంకో పేరు';

  @override
  String get alsoCalledHint => 'ఉదా. Glycomet';

  @override
  String get strength => 'మోతాదు';

  @override
  String get strengthHint => 'ఉదా. 500 mg';

  @override
  String get whenToTake => 'ఎప్పుడు వేసుకోవాలి';

  @override
  String get doseMorning => 'ఉదయం';

  @override
  String get doseAfternoon => 'మధ్యాహ్నం';

  @override
  String get doseEvening => 'సాయంత్రం';

  @override
  String get doseNight => 'రాత్రి';

  @override
  String get foodAfter => 'భోజనం తర్వాత';

  @override
  String get foodBefore => 'భోజనానికి ముందు';

  @override
  String get foodAny => 'భోజనంతో లేదా లేకుండా';

  @override
  String get saveMedicine => 'మందు సేవ్ చేయండి';

  @override
  String get medicineSaved => 'మందు సేవ్ అయింది';

  @override
  String get deleteMedicine => 'మందు తొలగించండి';

  @override
  String get deleteMedicineConfirm => 'ఈ మందును జాబితా నుంచి తీసేయాలా?';

  @override
  String get scanToFill => 'స్ట్రిప్ స్కాన్ చేసి నింపండి';

  @override
  String get timesNotSet => 'సమయం సెట్ చేయలేదు';

  @override
  String get takenToday => 'ఈరోజు వేసుకున్నవి';

  @override
  String get prescriptionTitle => 'ప్రిస్క్రిప్షన్ నుంచి జోడించండి';

  @override
  String get prescriptionHint =>
      'ప్రింట్ చేసిన ప్రిస్క్రిప్షన్ స్పష్టమైన ఫోటో తీయండి. Gurtu మందులు కనుగొంటుంది; ఏవి జోడించాలో మీరు ఎంచుకోండి.';

  @override
  String get takePhoto => 'ఫోటో తీయండి';

  @override
  String get chooseFromGallery => 'గ్యాలరీ నుంచి ఎంచుకోండి';

  @override
  String get medicinesFound => 'కనుగొన్న మందులు';

  @override
  String get tickToAdd =>
      'జోడించాల్సిన వాటికి టిక్ పెట్టండి. ప్రతి పేరు, సమయం ప్రిస్క్రిప్షన్‌తో సరిచూడండి.';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మందులు జోడించండి',
      one: '1 మందు జోడించండి',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'మందులు కనబడలేదు. స్పష్టమైన ఫోటో తీయండి, లేదా చేతితో జోడించండి.';

  @override
  String get handwrittenNote =>
      'చేతిరాత ప్రిస్క్రిప్షన్లు సరిగ్గా చదవబడకపోవచ్చు. ప్రతి పేరు సరిచూడండి.';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మందులు జోడించబడ్డాయి',
      one: '1 మందు జోడించబడింది',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'స్ట్రిప్‌పై $strength ఉందో చూసుకోండి';
  }
}
