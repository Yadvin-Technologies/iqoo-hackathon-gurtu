// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get continueLabel => 'पुढे चला';

  @override
  String get next => 'पुढे';

  @override
  String get skip => 'वगळा';

  @override
  String get later => 'नंतर';

  @override
  String get back => 'मागे';

  @override
  String get optional => 'ऐच्छिक';

  @override
  String get yes => 'होय';

  @override
  String get no => 'नाही';

  @override
  String get notSure => 'माहीत नाही';

  @override
  String get tagline => 'लक्षात ठेवा. काळजी घ्या. सोबत.';

  @override
  String get motherName => 'आई';

  @override
  String get phaseAbout => 'परिचय';

  @override
  String get phaseHealth => 'आरोग्य';

  @override
  String get phasePermissions => 'परवानग्या';

  @override
  String get phaseAi => 'AI सेटअप';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $total पैकी $current';
  }

  @override
  String get languageTitle => 'तुमची भाषा निवडा';

  @override
  String get languageSubtitle => 'Gurtu याच भाषेत बोलेल, ऐकेल आणि लिहील.';

  @override
  String get languageMixNote =>
      'डॉक्टर अनेकदा तुमच्या भाषेत इंग्रजी मिसळून बोलतात. Gurtu दोन्ही एकत्र समजतो.';

  @override
  String get welcomeTitle => 'तुमच्या कुटुंबाची\nकाळजीची आठवण';

  @override
  String get welcomeBody =>
      'डॉक्टर काय म्हणाले, कोणते औषध लिहिले आणि घरी काय घडले — सगळे मिळून लक्षात ठेवा.';

  @override
  String get welcomeScript => 'वेगवेगळ्या भूमिका. एकच प्रेम.';

  @override
  String get getStarted => 'सुरू करा';

  @override
  String builtForBrand(String brand) {
    return '$brand साठी बनवलेले';
  }

  @override
  String get madeInHyderabad => 'हैदराबादमध्ये बनवलेले';

  @override
  String get introRecordEyebrow => '1 · रेकॉर्ड करा';

  @override
  String get introRecordTitle => 'डॉक्टरांनी सांगितलेले कधीही विसरू नका';

  @override
  String get introRecordBody =>
      'सगळ्यांच्या संमतीने डॉक्टर, नर्स किंवा फार्मासिस्टचे बोलणे रेकॉर्ड करा. महत्त्वाच्या गोष्टी Gurtu जपून ठेवतो.';

  @override
  String get introPlanEyebrow => '2 · समजून घ्या आणि वाटून घ्या';

  @override
  String get introPlanTitle => 'संपूर्ण कुटुंबासाठी एक काळजी योजना';

  @override
  String get introPlanBody =>
      'प्रिस्क्रिप्शन आणि रिपोर्ट स्कॅन करा. Gurtu त्यांना कुटुंब वाटून घेऊ शकेल अशा सोप्या कामांमध्ये बदलतो.';

  @override
  String get introAskEyebrow => '3 · विचारा आणि लक्षात ठेवा';

  @override
  String get introAskTitle => 'काहीही विचारा, पुरावा पाहा';

  @override
  String get introAskBody =>
      'प्रत्येक उत्तर कुठून आले ते दाखवते — रेकॉर्डिंग, प्रिस्क्रिप्शन किंवा फोटो.';

  @override
  String get letsSetUp => 'सेटअप करूया';

  @override
  String get hospitalMode => 'हॉस्पिटल मोड';

  @override
  String get consentRecording => 'उपस्थित सर्वांच्या संमतीने रेकॉर्डिंग';

  @override
  String get doctorConversation => 'डॉक्टरांशी संवाद';

  @override
  String get nurseInstructions => 'नर्सच्या सूचना';

  @override
  String get pharmacistAdvice => 'फार्मासिस्टचा सल्ला';

  @override
  String get yourCarePlan => 'तुमची काळजी योजना';

  @override
  String get afterBreakfast => 'नाश्त्यानंतर';

  @override
  String get checkBloodPressure => 'BP तपासा';

  @override
  String get twiceDaily => 'दिवसातून दोनदा';

  @override
  String get bloodTest => 'रक्त तपासणी (CBC)';

  @override
  String get instructionsFound =>
      'तुमच्या रेकॉर्डिंग आणि प्रिस्क्रिप्शनमध्ये 4 सूचना सापडल्या';

  @override
  String get askQuestion => 'संध्याकाळच्या औषधाबद्दल डॉक्टर काय म्हणाले?';

  @override
  String get askAnswer =>
      'Amlodipine रात्रीच्या जेवणानंतर घ्यायला डॉक्टरांनी सांगितले.';

  @override
  String get sourceDoctorVisit => 'स्रोत: डॉक्टर भेट';

  @override
  String get careForTitle => 'तुम्ही Gurtu कोणासाठी सेट करत आहात?';

  @override
  String get careForSubtitle =>
      'Gurtu एका व्यक्तीभोवती काळजीची आठवण तयार करतो. बाकीच्या कुटुंबाला नंतर बोलावता येईल.';

  @override
  String get careForMyself => 'माझ्यासाठी';

  @override
  String get careForMyselfHint =>
      'मला माझ्या स्वतःच्या काळजीकडे लक्ष ठेवायचे आहे';

  @override
  String get careForParent => 'माझे आई-वडील';

  @override
  String get careForParentHint => 'आई, बाबा किंवा घरातील वडीलधारी व्यक्ती';

  @override
  String get careForPartner => 'माझा जोडीदार';

  @override
  String get careForPartnerHint => 'पती, पत्नी किंवा जोडीदार';

  @override
  String get careForChild => 'माझे मूल';

  @override
  String get careForChildHint => 'मुलगा किंवा मुलगी';

  @override
  String get careForOther => 'दुसरे कोणी';

  @override
  String get careForOtherHint => 'नातेवाईक, मित्र किंवा शेजारी';

  @override
  String get profileTitleSelf => 'तुमच्याबद्दल सांगा';

  @override
  String get profileTitleOther => 'त्यांच्याबद्दल सांगा';

  @override
  String get profileSubtitleSelf => 'यामुळे Gurtu तुम्हाला नावाने हाक मारेल.';

  @override
  String get profileSubtitleOther =>
      'घरी तुम्ही त्यांना ज्या नावाने हाक मारता ते लिहा.';

  @override
  String get yourName => 'तुमचे नाव';

  @override
  String get whatDoYouCallThem => 'तुम्ही त्यांना काय म्हणता?';

  @override
  String exampleName(String name) {
    return 'उदा. $name';
  }

  @override
  String get sampleSelfName => 'सुनीता';

  @override
  String get sampleYourName => 'प्रिया';

  @override
  String get yourAge => 'तुमचे वय';

  @override
  String get theirAge => 'त्यांचे वय';

  @override
  String get years => 'वर्षे';

  @override
  String get decreaseAge => 'वय कमी करा';

  @override
  String get increaseAge => 'वय वाढवा';

  @override
  String get gender => 'लिंग';

  @override
  String get female => 'स्त्री';

  @override
  String get male => 'पुरुष';

  @override
  String get genderOther => 'इतर';

  @override
  String get andYou => 'आणि तुम्ही?';

  @override
  String get andYouBody => 'त्यांच्या केअर सर्कलचे पहिले सदस्य तुम्ही असाल.';

  @override
  String get conditionsTitleSelf => 'तुम्हाला यापैकी कोणता आजार आहे का?';

  @override
  String conditionsTitleOther(String name) {
    return '$name यांना यापैकी कोणता आजार आहे का?';
  }

  @override
  String get conditionsSubtitle =>
      'लागू असलेले सगळे निवडा. यामुळे Gurtu काळजी योजना तयार करतो.';

  @override
  String get condDiabetes => 'शुगर (मधुमेह)';

  @override
  String get condHighBp => 'हाय BP';

  @override
  String get condHeart => 'हृदयाचा आजार';

  @override
  String get condThyroid => 'थायरॉईड';

  @override
  String get condCholesterol => 'कोलेस्टेरॉल';

  @override
  String get condAsthma => 'दमा / श्वासाचा त्रास';

  @override
  String get condKidney => 'किडनीचा आजार';

  @override
  String get condArthritis => 'सांधेदुखी / संधिवात';

  @override
  String get condStroke => 'आधी पक्षाघात झाला होता';

  @override
  String get condCancer => 'कर्करोगाचे उपचार';

  @override
  String get noneOfThese => 'यापैकी काहीही नाही';

  @override
  String get notADoctor =>
      'Gurtu डॉक्टर नाही. तो कधीही निदान करत नाही — फक्त कुटुंबाला काळजी लक्षात ठेवायला आणि व्यवस्थित करायला मदत करतो.';

  @override
  String get medicinesTitleSelf => 'तुम्ही रोज औषध घेता का?';

  @override
  String medicinesTitleOther(String name) {
    return '$name रोज औषध घेतात का?';
  }

  @override
  String get medicinesSubtitle =>
      'गोळ्या, सिरप, इनहेलर किंवा इन्सुलिन — सगळे धरा.';

  @override
  String get howMany => 'साधारण किती?';

  @override
  String get sixOrMore => '6 किंवा जास्त';

  @override
  String get scanLaterTip =>
      'नंतर फक्त प्रिस्क्रिप्शन किंवा गोळ्यांची पट्टी स्कॅन करा — टाइप करण्याची गरज नाही.';

  @override
  String get allergiesTitleSelf => 'तुम्हाला कशाची ॲलर्जी आहे का?';

  @override
  String allergiesTitleOther(String name) {
    return '$name यांना कशाची ॲलर्जी आहे का?';
  }

  @override
  String get allergiesSubtitle =>
      'हे कधीही सुटू नये म्हणून Gurtu प्रत्येक डॉक्टर ब्रीफमध्ये दाखवेल.';

  @override
  String get allergyNone => 'कोणतीही ज्ञात ॲलर्जी नाही';

  @override
  String get allergyPenicillin => 'पेनिसिलिन';

  @override
  String get allergySulfa => 'सल्फा औषधे';

  @override
  String get allergyAspirin => 'ॲस्पिरिन / वेदनाशामक';

  @override
  String get allergyFood => 'अन्नाची ॲलर्जी';

  @override
  String get allergyDust => 'धूळ / परागकण';

  @override
  String get allergyLatex => 'लेटेक्स';

  @override
  String get mobilityTitleSelf => 'तुम्ही रोज कसे फिरता?';

  @override
  String mobilityTitleOther(String name) {
    return '$name रोज कसे फिरतात?';
  }

  @override
  String get mobilitySubtitle =>
      'यामुळे कुटुंबाला भेटी, तपासण्या आणि घरी मदतीचे नियोजन करता येते.';

  @override
  String get mobilityIndependent => 'स्वतः चालतात';

  @override
  String get mobilityIndependentHint => 'रोजच्या कामात मदत लागत नाही';

  @override
  String get mobilitySomeHelp => 'थोडी मदत लागते';

  @override
  String get mobilitySomeHelpHint => 'काठी, वॉकर किंवा धरायला एखादा हात';

  @override
  String get mobilityFullHelp => 'बहुतेक अंथरुणात किंवा व्हीलचेअरवर';

  @override
  String get mobilityFullHelpHint => 'बहुतेक कामांसाठी मदत लागते';

  @override
  String get hospitalTitleSelf =>
      'गेल्या 30 दिवसांत तुम्ही हॉस्पिटल किंवा डॉक्टरकडे गेला होतात का?';

  @override
  String hospitalTitleOther(String name) {
    return 'गेल्या 30 दिवसांत $name हॉस्पिटल किंवा डॉक्टरकडे गेले होते का?';
  }

  @override
  String get hospitalSubtitle => 'अलीकडच्या भेटींसोबत सहसा नवीन सूचना येतात.';

  @override
  String get hospitalTip =>
      'डिस्चार्जचे कागद आणि प्रिस्क्रिप्शन जवळ ठेवा — सेटअपनंतर लगेच स्कॅन करता येतील.';

  @override
  String get permissionsTitle => 'तुमच्या मदतीसाठी काही परवानग्या';

  @override
  String get permissionsSubtitle =>
      'Gurtu फक्त गरजेचे तेच मागतो. का ते इथे आहे.';

  @override
  String get permMic => 'मायक्रोफोन';

  @override
  String get permMicWhy =>
      'डॉक्टर भेटी आणि व्हॉइस नोट्स रेकॉर्ड करण्यासाठी — फक्त तुम्ही रेकॉर्ड दाबल्यावर.';

  @override
  String get permCamera => 'कॅमेरा';

  @override
  String get permCameraWhy =>
      'प्रिस्क्रिप्शन, गोळ्यांची पट्टी आणि BP मशीनचे रीडिंग स्कॅन करण्यासाठी.';

  @override
  String get permNotifications => 'सूचना';

  @override
  String get permNotificationsWhy =>
      'औषधांची आठवण आणि कुटुंबाने काम पूर्ण केल्याची माहिती.';

  @override
  String get permPhotos => 'फोटो आणि फाइल्स';

  @override
  String get permPhotosWhy =>
      'गॅलरीत आधीपासून असलेले रिपोर्ट आणि प्रिस्क्रिप्शन जोडा.';

  @override
  String get permContacts => 'संपर्क';

  @override
  String get permContactsWhy =>
      'कुटुंबातील सदस्यांना केअर सर्कलमध्ये पटकन बोलवा.';

  @override
  String get needed => 'आवश्यक';

  @override
  String get allow => 'परवानगी द्या';

  @override
  String get allowed => 'परवानगी दिली';

  @override
  String get allowAndContinue => 'परवानगी द्या आणि पुढे चला';

  @override
  String get privacyNote =>
      'सगळे याच फोनवर राहते. रेकॉर्डिंग आपोआप कधीही सुरू होत नाही — आधी नेहमी संमती स्क्रीन दिसते.';

  @override
  String permissionBlocked(String permission) {
    return '$permission बंद आहे. सेटिंग्जमध्ये सुरू करा.';
  }

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String permissionsMissing(String items) {
    return '$items शिवाय काही सुविधा चालणार नाहीत. नंतर परवानगी देता येईल.';
  }

  @override
  String get modelTitleChoose => 'Gurtu चा ऑन-डिव्हाइस AI सेट करा';

  @override
  String get modelTitleDownloading => 'तुमचा AI सेट होत आहे…';

  @override
  String get modelTitleDone => 'तुमचा AI तयार आहे';

  @override
  String get modelSubtitleChoose =>
      'हे मॉडेल पूर्णपणे तुमच्या iQOO वर चालतात. कुटुंबाची आरोग्य माहिती फोनबाहेर जात नाही — आणि इंटरनेटशिवायही काम करते.';

  @override
  String get modelSubtitleDownloading =>
      'तुम्ही फोन वापरत राहू शकता. हे फक्त एकदाच होते.';

  @override
  String get modelSubtitleDone => 'सगळे याच फोनवर चालते, ऑफलाइनसुद्धा.';

  @override
  String get poweredByIqoo => 'तुमच्या iQOO द्वारे चालणारे';

  @override
  String get deviceCardSub => 'ऑन-डिव्हाइस AI · खाजगी · ऑफलाइन चालते';

  @override
  String get chooseCareModel => 'केअर मॉडेल निवडा';

  @override
  String get careModelHint => 'प्रश्नांची उत्तरे देणारा मेंदू हाच.';

  @override
  String get alwaysIncluded => 'नेहमी समाविष्ट';

  @override
  String get jobListens => 'ऐकतो';

  @override
  String get jobReads => 'वाचतो';

  @override
  String get jobSees => 'पाहतो';

  @override
  String get jobUnderstands => 'समजतो';

  @override
  String speechModelName(String language) {
    return 'आवाज · $language + इंग्रजी';
  }

  @override
  String get speechModelWhat => 'संवाद तुमच्या भाषेत लिखित स्वरूपात बदलतो.';

  @override
  String get readerModelName => 'दस्तऐवज वाचक (OCR)';

  @override
  String get readerModelWhat =>
      'प्रिस्क्रिप्शन, डिस्चार्जचे कागद आणि लॅब रिपोर्ट वाचतो.';

  @override
  String get visionModelName => 'औषध आणि रीडिंग ओळख';

  @override
  String get visionModelWhat =>
      'गोळ्यांची पट्टी आणि BP / शुगर मशीनचे आकडे ओळखतो.';

  @override
  String careModelName(String model) {
    return 'केअर मॉडेल · $model';
  }

  @override
  String get tierLite => 'लाइट';

  @override
  String get tierBalanced => 'संतुलित';

  @override
  String get tierPro => 'प्रो';

  @override
  String get tierLiteNote => 'सर्वात वेगवान. छोटी, सोपी उत्तरे.';

  @override
  String get tierBalancedNote => 'आवाज, फोटो आणि मजकूर एकत्र समजतो.';

  @override
  String get tierProNote => 'सर्वात सविस्तर उत्तरे आणि डॉक्टर ब्रीफ.';

  @override
  String get bestForIqoo => 'iQOO साठी सर्वोत्तम';

  @override
  String get wifiOnly => 'फक्त Wi-Fi वर डाउनलोड करा';

  @override
  String downloadSize(String size) {
    return 'डाउनलोड · $size';
  }

  @override
  String get settingUp => 'सेट होत आहे…';

  @override
  String get ready => 'तयार';

  @override
  String allSetName(String name) {
    return 'सगळे तयार, $name!';
  }

  @override
  String get allSet => 'सगळे तयार!';

  @override
  String get readySelf => 'तुमची काळजीची आठवण तयार आहे.';

  @override
  String readyOther(String name) {
    return '$name यांची काळजीची आठवण तयार आहे. आता कुटुंबाला बोलवा.';
  }

  @override
  String get rowYou => 'तुम्ही';

  @override
  String get rowCaringFor => 'कोणाची काळजी';

  @override
  String get rowHealth => 'आरोग्य';

  @override
  String get rowAllergies => 'ॲलर्जी';

  @override
  String get rowLanguage => 'भाषा';

  @override
  String get rowAi => 'ऑन-डिव्हाइस AI';

  @override
  String get notAdded => 'जोडले नाही';

  @override
  String ageYears(int age) {
    return '$age वर्षे';
  }

  @override
  String get careQuote => '“सोबत केली तर काळजी हलकी वाटते.”';

  @override
  String get enterGurtu => 'Gurtu उघडा';

  @override
  String get nextUpCareCircle => 'पुढे: केअर सर्कल';

  @override
  String get homeComingSoon => 'होम स्क्रीन पुढच्या भागात येत आहेत.';

  @override
  String get restartOnboarding => 'ऑनबोर्डिंग पुन्हा सुरू करा';

  @override
  String get navHome => 'होम';

  @override
  String get navMemory => 'आठवणी';

  @override
  String get navCircle => 'सर्कल';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String goodMorning(String name) {
    return 'सुप्रभात, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'नमस्कार, $name';
  }

  @override
  String goodEvening(String name) {
    return 'शुभ संध्याकाळ, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu मध्ये स्वागत आहे, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'तुमच्या कुटुंबाचे आरोग्य, सगळे मिळून लक्षात ठेवा.';

  @override
  String get caringFor => 'काळजी';

  @override
  String get switchPatientTitle => 'तुम्ही कोणाची काळजी घेत आहात?';

  @override
  String get addAnotherPerson => 'आणखी कोणाला जोडा';

  @override
  String get statusOnTrack => 'काळजी व्यवस्थित सुरू आहे';

  @override
  String get statusNeedsAttention => 'एका गोष्टीकडे लक्ष द्यायचे आहे';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'आपत्कालीन';

  @override
  String get sosHoldTitle => 'केअर सर्कलला सावध करण्यासाठी दाबून धरा';

  @override
  String get sosHoldBody =>
      'बटण 2 सेकंद दाबून धरा. तुमच्या आपत्कालीन संपर्कांना अलर्ट जाईल.';

  @override
  String get sosHoldButton => 'SOS पाठवण्यासाठी दाबून धरा';

  @override
  String get sosKeepHolding => 'दाबून धरा…';

  @override
  String get sosPreviewNote =>
      'आपत्कालीन अलर्ट अजून जोडलेले नाहीत. ही फक्त झलक आहे — कोणालाही अलर्ट जाणार नाही.';

  @override
  String get sosPreviewDone => 'झलक पूर्ण झाली. कोणालाही अलर्ट गेला नाही.';

  @override
  String get close => 'बंद करा';

  @override
  String get todayCare => 'आजची काळजी';

  @override
  String completedOf(int done, int total) {
    return '$total पैकी $done पूर्ण';
  }

  @override
  String get viewTodayCare => 'आजची काळजी पाहा';

  @override
  String get nothingUrgent => 'आत्ता काहीही तातडीचे नाही.';

  @override
  String get markDone => 'पूर्ण झाले म्हणून खूण करा';

  @override
  String get markNotDone => 'अपूर्ण म्हणून खूण करा';

  @override
  String get openToCircle => 'केअर सर्कलसाठी खुले';

  @override
  String get captureCare => 'काळजी नोंदवा';

  @override
  String get captureCareSubtitle => 'काळजीशी संबंधित महत्त्वाची गोष्ट नोंदवा.';

  @override
  String get whatHappened => 'काय घडले?';

  @override
  String get captureVoice => 'आवाज';

  @override
  String get captureVoiceHint => 'संवाद किंवा व्हॉइस नोट रेकॉर्ड करा';

  @override
  String get captureScan => 'स्कॅन';

  @override
  String get captureScanHint => 'प्रिस्क्रिप्शन किंवा गोळ्यांची पट्टी';

  @override
  String get captureVital => 'रीडिंग';

  @override
  String get captureVitalHint => 'BP, शुगर किंवा ताप';

  @override
  String get captureDocument => 'दस्तऐवज';

  @override
  String get captureDocumentHint => 'डिस्चार्ज पेपर किंवा लॅब रिपोर्ट';

  @override
  String get captureNote => 'नोंद';

  @override
  String get captureNoteHint => 'काय घडले ते लिहा';

  @override
  String get comingSoon => 'लवकरच येत आहे';

  @override
  String get noteHint => 'उदा. चालल्यानंतर चक्कर आली';

  @override
  String get saveNote => 'नोंद जतन करा';

  @override
  String get noteSaved => 'काळजीच्या आठवणीत जतन केले';

  @override
  String get recentMemory => 'अलीकडच्या आठवणी';

  @override
  String get viewAll => 'सर्व पाहा';

  @override
  String get emptyMemory => 'तुमची काळजीची गोष्ट इथून सुरू होते.';

  @override
  String addedBy(String name) {
    return '$name यांनी जोडले';
  }

  @override
  String get sourcePlay => 'ऐका';

  @override
  String get sourceView => 'पाहा';

  @override
  String get sourceOpen => 'उघडा';

  @override
  String get sourceTitle => 'स्रोत';

  @override
  String get sourceRecording => 'डॉक्टरांचे रेकॉर्डिंग';

  @override
  String get sourceScan => 'प्रिस्क्रिप्शन स्कॅन';

  @override
  String get sourceVital => 'रीडिंग';

  @override
  String get sourceDocument => 'दस्तऐवज';

  @override
  String get sourceNote => 'लिहिलेली नोंद';

  @override
  String get sourceSampleNote =>
      'हा नमुना डेटा आहे, त्यामुळे मूळ फाइल नाही. खरी रेकॉर्डिंग आणि स्कॅन इथे उघडतील.';

  @override
  String get yourCareCircle => 'तुमचे केअर सर्कल';

  @override
  String get manageCircle => 'सर्कल व्यवस्थापित करा';

  @override
  String get emptyCircle => 'सोबत केली तर काळजी सोपी होते.';

  @override
  String get addFamilyMember => 'कुटुंबातील सदस्य जोडा';

  @override
  String get rolePatient => 'रुग्ण';

  @override
  String get roleCaregiver => 'काळजीवाहक';

  @override
  String get roleFamily => 'कुटुंब';

  @override
  String get roleHelper => 'विश्वासू मदतनीस';

  @override
  String get askGurtuTitle => 'Gurtu ला विचारा';

  @override
  String get askGurtuPrompt => 'काही लक्षात ठेवायला मदत हवी आहे?';

  @override
  String get askExampleBloodTest => 'रक्त तपासणी कधी आहे?';

  @override
  String get askExampleDoctor => 'उद्या डॉक्टरांना काय विचारू?';

  @override
  String get askGurtuNote =>
      'उत्तरे तुम्ही जतन केलेल्या काळजीच्या माहितीतूनच येतात.';

  @override
  String get gettingReady => 'Gurtu तयार होत आहे';

  @override
  String get readyYourProfile => 'तुमची प्रोफाइल';

  @override
  String get readyPatientProfile => 'रुग्णाची प्रोफाइल';

  @override
  String get readyCareCircle => 'केअर सर्कल';

  @override
  String get readyEmergencyContact => 'आपत्कालीन संपर्क';

  @override
  String get previewSampleData => 'नमुना डेटासह पाहा';

  @override
  String get sampleDataOn => 'नमुना काळजी डेटा दाखवत आहे';

  @override
  String get remove => 'काढा';

  @override
  String get hide => 'लपवा';

  @override
  String get comingNextPhase => 'हा भाग पुढे तयार होत आहे.';

  @override
  String get fatherName => 'बाबा';

  @override
  String get sampleTaskMorningMedicine => 'सकाळचे औषध';

  @override
  String get sampleTaskRecordBp => 'BP नोंदवा';

  @override
  String get sampleTaskBloodTest => 'रक्त तपासणी';

  @override
  String get sampleTaskDoctorVisit => 'डॉक्टरांची भेट';

  @override
  String get sampleMomentDoctorTalk => 'डॉक्टरांशी संवाद';

  @override
  String get sampleMomentDoctorTalkDetail => '“नाश्त्यानंतर औषध घ्या.”';

  @override
  String get sampleMomentPrescription => 'प्रिस्क्रिप्शन स्कॅन केले';

  @override
  String get sampleMomentPrescriptionDetail => '2 औषधे सापडली';

  @override
  String get sampleMomentBp => 'BP नोंदवला';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'काल';

  @override
  String get doctorVisit => 'डॉक्टर भेट';

  @override
  String get doctorVisitHint => 'डॉक्टर काय म्हणाले ते नोंदवा';

  @override
  String get askDoctor => 'डॉक्टरांना विचारायचे प्रश्न';

  @override
  String get askDoctorHint => 'Gurtu तयारीत मदत करेल';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रश्न तयार',
      one: '1 प्रश्न तयार',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'मागील भेट: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'पुढील भेट: $date';
  }

  @override
  String get visitsTitle => 'डॉक्टर भेटी';

  @override
  String get visitsSubtitle => 'प्रत्येक डॉक्टर काय म्हणाले, सर्व एकाच ठिकाणी.';

  @override
  String get recordVisit => 'भेट नोंदवा';

  @override
  String get visitsOverview => 'सर्व भेटी एका नजरेत';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count भेटी',
      one: '1 भेट',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count डॉक्टर',
      one: '1 डॉक्टर',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'मागील भेट';

  @override
  String get nextVisit => 'पुढील भेट';

  @override
  String get notPlanned => 'अजून ठरलेली नाही';

  @override
  String get pastVisits => 'मागील भेटी';

  @override
  String get noVisitsTitle => 'अजून कोणतीही भेट नोंदवलेली नाही';

  @override
  String get noVisitsBody =>
      'पुढच्या अपॉइंटमेंटला ‘भेट नोंदवा’ दाबा, डॉक्टर जे सांगतील ते Gurtu नोंदवेल.';

  @override
  String get questionsForNextVisit => 'पुढील भेटीचे प्रश्न';

  @override
  String get prepareQuestionsHint =>
      'तुम्हाला कसे वाटते ते Gurtu ला सांगा. डॉक्टरांना काय विचारायचे ते सुचवेल.';

  @override
  String get prepareQuestions => 'प्रश्न तयार करा';

  @override
  String get viewQuestions => 'प्रश्न पहा';

  @override
  String get doctorFallback => 'डॉक्टर';

  @override
  String get doctorSaid => 'डॉक्टर काय म्हणाले';

  @override
  String get medicinesSection => 'औषधे';

  @override
  String get testsSection => 'करायच्या तपासण्या';

  @override
  String get questionsAsked => 'विचारलेले प्रश्न';

  @override
  String askedOf(int asked, int total) {
    return '$total पैकी $asked विचारले';
  }

  @override
  String get deleteVisit => 'भेट हटवा';

  @override
  String get deleteVisitConfirm => 'ही भेट हटवायची? ती परत मिळणार नाही.';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get delete => 'हटवा';

  @override
  String get doctorName => 'डॉक्टरांचे नाव';

  @override
  String get doctorNameHint => 'उदा. डॉ. मीना राव';

  @override
  String get visitReason => 'भेटीचे कारण';

  @override
  String get visitReasonHint => 'उदा. शुगर तपासणी';

  @override
  String get visitDate => 'भेटीची तारीख';

  @override
  String get listenToDoctor => 'डॉक्टरांचे ऐका';

  @override
  String get stopListening => 'ऐकणे थांबवा';

  @override
  String get speak => 'बोला';

  @override
  String get recordingConsent =>
      'तुम्ही Gurtu ने संभाषण नोंदवत आहात हे डॉक्टरांना सांगा.';

  @override
  String get doctorSaidHint => 'डॉक्टर जे सांगतील ते बोला किंवा टाइप करा';

  @override
  String get medicinesHint => 'उदा. मेटफॉर्मिन 500 mg नाश्त्यानंतर';

  @override
  String get testsHint => 'उदा. HbA1c रक्त तपासणी';

  @override
  String get addNextVisit => 'पुढील भेटीची तारीख जोडा';

  @override
  String get yourQuestions => 'तुमचे प्रश्न';

  @override
  String get tickWhenAsked => 'डॉक्टरांनी उत्तर दिल्यावर प्रत्येकावर टिक करा.';

  @override
  String get saveVisit => 'भेट सेव्ह करा';

  @override
  String get visitSaved => 'भेट सेव्ह झाली';

  @override
  String get leaveVisitTitle => 'सेव्ह न करता जायचे?';

  @override
  String get leaveVisitBody => 'या भेटीसाठी नोंदवलेले सर्व हरवेल.';

  @override
  String get discard => 'काढून टाका';

  @override
  String get keepEditing => 'लिहिणे सुरू ठेवा';

  @override
  String get voiceUnavailable =>
      'सध्या आवाजाने लिहिणे उपलब्ध नाही. तुम्ही टाइप करू शकता.';

  @override
  String get prepTitle => 'डॉक्टरांकडे जाण्याची तयारी';

  @override
  String get prepIntro =>
      'डॉक्टरांकडे जाण्याची तयारी करूया. कोणत्या आरोग्य तक्रारींबद्दल बोलायचे आहे?';

  @override
  String get prepPickOrSay =>
      'खाली तक्रारी निवडा, किंवा तुमच्या शब्दांत सांगा.';

  @override
  String get prepDescribeHint => 'उदा. तीन दिवसांपासून डोकेदुखी आणि थकवा';

  @override
  String prepHeard(String symptoms) {
    return 'मी ऐकले: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — कधीपासून?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — किती तीव्र आहे?';
  }

  @override
  String get askNewMedicine => 'अलीकडे कोणते औषध सुरू केले किंवा बदलले का?';

  @override
  String get askAnythingElse => 'डॉक्टरांना आणखी काही सांगायचे आहे का?';

  @override
  String get urgentWarning =>
      'तीव्र छातीत दुखणे किंवा धाप लागणे ही आणीबाणी असू शकते. अपॉइंटमेंटची वाट पाहू नका — लगेच वैद्यकीय मदत घ्या.';

  @override
  String get prepThinking => 'तुमचे प्रश्न तयार होत आहेत…';

  @override
  String get prepResultIntro =>
      'डॉक्टरांना हे विचारा. नको असलेले काढा, किंवा तुमचा प्रश्न जोडा.';

  @override
  String get prepNotDoctor =>
      'Gurtu डॉक्टर नाही. हे प्रश्न डॉक्टरांशी बोलायला मदत करतात.';

  @override
  String get addOwnQuestion => 'तुमचा स्वतःचा प्रश्न जोडा';

  @override
  String get add => 'जोडा';

  @override
  String get saveQuestions => 'भेटीसाठी सेव्ह करा';

  @override
  String get questionsSaved => 'प्रश्न भेटीसाठी सेव्ह झाले';

  @override
  String get startAgain => 'पुन्हा सुरू करा';

  @override
  String get startVisit => 'भेट सुरू करा';

  @override
  String get deleteQuestions => 'हे प्रश्न हटवा';

  @override
  String get removeQuestion => 'प्रश्न काढा';

  @override
  String get done => 'झाले';

  @override
  String get healthProblems => 'आरोग्य तक्रारी';

  @override
  String preparedOn(String date) {
    return '$date रोजी तयार केले';
  }

  @override
  String get symFever => 'ताप';

  @override
  String get symHeadache => 'डोकेदुखी';

  @override
  String get symBodyPain => 'अंगदुखी किंवा सांधेदुखी';

  @override
  String get symChestPain => 'छातीत दुखणे';

  @override
  String get symBreathless => 'धाप लागणे';

  @override
  String get symCough => 'खोकला';

  @override
  String get symDizziness => 'चक्कर';

  @override
  String get symTiredness => 'थकवा';

  @override
  String get symStomach => 'पोटाचा त्रास';

  @override
  String get symPoorSleep => 'झोप न येणे';

  @override
  String get symPoorAppetite => 'भूक कमी';

  @override
  String get symLowMood => 'उदासी किंवा काळजी';

  @override
  String get kwFever => 'ताप,थंडी,अंग गरम';

  @override
  String get kwHeadache => 'डोकेदुखी,डोके दुखते,डोकं दुखतं';

  @override
  String get kwBodyPain => 'अंगदुखी,सांधेदुखी,गुडघा,गुडघे,कंबरदुखी,पाय दुखतात';

  @override
  String get kwChestPain => 'छातीत,छाती,छातीत दुखणे';

  @override
  String get kwBreathless => 'धाप,श्वास,दम लागणे';

  @override
  String get kwCough => 'खोकला,कफ,सर्दी';

  @override
  String get kwDizziness => 'चक्कर,भोवळ,घेरी';

  @override
  String get kwTiredness => 'थकवा,अशक्तपणा,थकलो,थकले';

  @override
  String get kwStomach => 'पोट,अ‍ॅसिडिटी,गॅस,उलटी,जुलाब,बद्धकोष्ठता,मळमळ';

  @override
  String get kwPoorSleep => 'झोप,निद्रानाश';

  @override
  String get kwPoorAppetite => 'भूक,जेवण जात नाही';

  @override
  String get kwLowMood => 'उदास,काळजी,भीती,ताण,टेन्शन,चिंता';

  @override
  String get sinceToday => 'आजपासून';

  @override
  String get sinceFewDays => 'काही दिवसांपासून';

  @override
  String get sinceWeek => 'सुमारे एका आठवड्यापासून';

  @override
  String get sinceMonth => 'एक महिना किंवा जास्त';

  @override
  String get sevMild => 'सौम्य';

  @override
  String get sevModerate => 'मध्यम';

  @override
  String get sevSevere => 'तीव्र';

  @override
  String qCause(String symptom) {
    return '$symptom कशामुळे होत असेल?';
  }

  @override
  String qTests(String symptom) {
    return '$symptom साठी कोणती तपासणी करावी लागेल का?';
  }

  @override
  String qWarningSigns(String symptom) {
    return '$symptom सोबत कोणती लक्षणे दिसली तर लगेच परत यावे?';
  }

  @override
  String qHomeCare(String symptom) {
    return '$symptom कमी होण्यासाठी घरी काय करता येईल?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return '$symptom चा $conditions शी संबंध असू शकतो का?';
  }

  @override
  String get qSideEffect => 'नवीन किंवा बदललेल्या औषधामुळे हे होत असेल का?';

  @override
  String get qMedicinesStillRight =>
      'सध्याची औषधे योग्य आहेत का, की काही बदलावे?';

  @override
  String get qNextCheckup => 'पुढील तपासणीसाठी कधी यावे?';

  @override
  String qTellDoctor(String text) {
    return 'डॉक्टरांना सांगा: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'मधुमेह आढावा';

  @override
  String get sampleVisitDiabetesNotes =>
      'शुगर आधीपेक्षा चांगली नियंत्रणात आहे. तीच औषधे सुरू ठेवा. रोज 30 मिनिटे चाला आणि गोड कमी करा.';

  @override
  String get sampleVisitDiabetesMeds =>
      'मेटफॉर्मिन 500 mg नाश्ता आणि रात्रीच्या जेवणानंतर';

  @override
  String get sampleVisitDiabetesTests => 'पुढील भेटीपूर्वी HbA1c रक्त तपासणी';

  @override
  String get sampleVisitKneeReason => 'गुडघेदुखी';

  @override
  String get sampleVisitKneeNotes =>
      'उजव्या गुडघ्यात सौम्य संधिवात. संध्याकाळी गरम शेक द्या आणि जास्त जिने चढणे टाळा.';

  @override
  String get sampleVisitKneeMeds => 'वेदनाशामक जेल दिवसातून दोनदा';

  @override
  String get scanVerify => 'औषध स्कॅन करून तपासा';

  @override
  String get scanVerifyHint => 'हीच गोळी आत्ता घ्यायची आहे का?';

  @override
  String scanVerifySubtitle(String name) {
    return 'पत्ता किंवा डबा स्कॅन करा. Gurtu तो $name यांच्या औषध यादीशी जुळवून पाहील.';
  }

  @override
  String get scanWithCamera => 'औषध स्कॅन करा';

  @override
  String get orTypeName => 'किंवा पत्त्यावरचे नाव टाइप करा';

  @override
  String get typeNameHint => 'उदा. Glycomet 500';

  @override
  String get checkMedicine => 'तपासा';

  @override
  String get checkAnother => 'दुसरे औषध तपासा';

  @override
  String get readingStrip => 'पत्ता वाचत आहे…';

  @override
  String get cameraUnavailable =>
      'कॅमेरा स्कॅन फोन ॲपमध्ये चालतो. आत्ता नाव टाइप करा.';

  @override
  String get scanFailed =>
      'फोटो वाचता आला नाही. पुन्हा प्रयत्न करा, किंवा नाव टाइप करा.';

  @override
  String readFromStrip(String text) {
    return 'पत्त्यावर वाचले: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'Gurtu फक्त तुम्ही सेव्ह केलेल्या औषधांशी जुळवते. ते कधीही औषध सुचवत नाही.';

  @override
  String get verdictTakeNow => 'हो — हेच योग्य औषध आहे, आत्ता घ्यायचे आहे.';

  @override
  String get verdictNotNow => 'औषध योग्य आहे, पण आत्ता घेण्याची वेळ नाही.';

  @override
  String get verdictAlreadyTaken => 'हा डोस आधीच घेतला आहे. पुन्हा घेऊ नका.';

  @override
  String get verdictNoTimes =>
      'औषध योग्य आहे, पण त्याची वेळ सेव्ह केलेली नाही.';

  @override
  String get verdictWrongStrength =>
      'थांबा — मात्रा (mg) प्रिस्क्रिप्शनपेक्षा वेगळी आहे.';

  @override
  String verdictNotOnList(String name) {
    return 'थांबा — हे औषध $name यांच्या यादीत नाही.';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'थांबा — हे औषध $other यांच्या यादीतील आहे, $name यांचे नाही.';
  }

  @override
  String get verdictUnreadable =>
      'औषधाचे नाव वाचता आले नाही. चांगल्या प्रकाशात पुन्हा प्रयत्न करा, किंवा टाइप करा.';

  @override
  String get verdictCheckFirst =>
      'डॉक्टर किंवा फार्मासिस्टला विचारल्याशिवाय घेऊ नका.';

  @override
  String get rowOnList => 'औषध यादीत आहे';

  @override
  String rowStrengthMatches(String strength) {
    return 'मात्रा जुळते: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'पत्त्यावर $found, प्रिस्क्रिप्शनमध्ये $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'आत्ता घ्यायचा: $slot डोस';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot डोस $time ला घेतला';
  }

  @override
  String rowNextDose(String slot) {
    return 'पुढील डोस: $slot';
  }

  @override
  String get rowSetTimes => 'औषध यादीत कधी घ्यायचे ते जोडा';

  @override
  String get markTaken => 'घेतल्याची नोंद करा';

  @override
  String get markedTaken => 'डोसची नोंद झाली';

  @override
  String get undo => 'परत घ्या';

  @override
  String get medicineList => 'औषध यादी';

  @override
  String get medicineListSubtitle =>
      'प्रिस्क्रिप्शनमधील प्रत्येक औषध, ते कधी घ्यायचे यासह.';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count औषधे',
      one: '1 औषध',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'औषध जोडा';

  @override
  String get editMedicine => 'औषध बदला';

  @override
  String get addFromPrescription => 'प्रिस्क्रिप्शनच्या फोटोमधून जोडा';

  @override
  String get noMedicinesTitle => 'अजून कोणतेही औषध जोडलेले नाही';

  @override
  String get noMedicinesBody =>
      'प्रिस्क्रिप्शनमधील प्रत्येक औषध एकदा जोडा. मग कोणताही पत्ता स्कॅन करून ते योग्य आहे का ते तपासा.';

  @override
  String addMedicinesFirst(String name) {
    return 'आधी $name यांची औषधे जोडा, म्हणजे Gurtu त्यांच्याशी जुळवू शकेल.';
  }

  @override
  String get medicineName => 'औषधाचे नाव';

  @override
  String get medicineNameHint => 'उदा. Metformin';

  @override
  String get alsoCalled => 'पत्त्यावरचे दुसरे नाव';

  @override
  String get alsoCalledHint => 'उदा. Glycomet';

  @override
  String get strength => 'मात्रा';

  @override
  String get strengthHint => 'उदा. 500 mg';

  @override
  String get whenToTake => 'कधी घ्यायचे';

  @override
  String get doseMorning => 'सकाळ';

  @override
  String get doseAfternoon => 'दुपार';

  @override
  String get doseEvening => 'संध्याकाळ';

  @override
  String get doseNight => 'रात्र';

  @override
  String get foodAfter => 'जेवणानंतर';

  @override
  String get foodBefore => 'जेवणापूर्वी';

  @override
  String get foodAny => 'जेवणासोबत किंवा शिवाय';

  @override
  String get saveMedicine => 'औषध सेव्ह करा';

  @override
  String get medicineSaved => 'औषध सेव्ह झाले';

  @override
  String get deleteMedicine => 'औषध हटवा';

  @override
  String get deleteMedicineConfirm => 'हे औषध यादीतून काढायचे?';

  @override
  String get scanToFill => 'पत्ता स्कॅन करून भरा';

  @override
  String get timesNotSet => 'वेळ ठरवलेली नाही';

  @override
  String get takenToday => 'आज घेतलेले';

  @override
  String get prescriptionTitle => 'प्रिस्क्रिप्शनमधून जोडा';

  @override
  String get prescriptionHint =>
      'छापील प्रिस्क्रिप्शनचा स्पष्ट फोटो घ्या. Gurtu औषधे शोधेल; कोणती जोडायची ते तुम्ही निवडा.';

  @override
  String get takePhoto => 'फोटो घ्या';

  @override
  String get chooseFromGallery => 'गॅलरीमधून निवडा';

  @override
  String get medicinesFound => 'सापडलेली औषधे';

  @override
  String get tickToAdd =>
      'जोडायची आहेत त्यांवर टिक करा. प्रत्येक नाव आणि वेळ प्रिस्क्रिप्शनशी जुळवून पहा.';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count औषधे जोडा',
      one: '1 औषध जोडा',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'कोणतेही औषध सापडले नाही. स्पष्ट फोटो घ्या, किंवा हाताने जोडा.';

  @override
  String get handwrittenNote =>
      'हाताने लिहिलेली प्रिस्क्रिप्शन्स नीट वाचली जाणार नाहीत. प्रत्येक नाव तपासा.';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count औषधे जोडली',
      one: '1 औषध जोडले',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'पत्त्यावर $strength लिहिले आहे का ते पहा';
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
  String get addPhoto => 'फोटो जोडा';

  @override
  String get recordVoiceNote => 'व्हॉइस नोट रेकॉर्ड करा';

  @override
  String get voiceNote => 'व्हॉइस नोट';

  @override
  String get recordingNow => 'रेकॉर्ड होत आहे…';

  @override
  String get stopAndSave => 'थांबवा आणि सेव्ह करा';

  @override
  String get removeAttachmentTitle => 'हे काढायचे?';

  @override
  String get removeAttachmentBody => 'हे या फोनमधून हटवले जाईल.';

  @override
  String get attachFailed => 'हे जोडता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get attachHintMedicines =>
      'प्रिस्क्रिप्शनचा फोटो जोडा, किंवा औषधांबद्दल डॉक्टर जे बोलले ते रेकॉर्ड करा.';

  @override
  String get attachHintTests =>
      'तपासणीची चिठ्ठी किंवा रिपोर्टचा फोटो जोडा, किंवा डॉक्टर जे बोलले ते रेकॉर्ड करा.';

  @override
  String get attachHintNextVisit =>
      'अपॉइंटमेंट कार्डचा फोटो जोडा, किंवा पुढच्या भेटीबद्दल डॉक्टर जे बोलले ते रेकॉर्ड करा.';

  @override
  String get play => 'प्ले करा';

  @override
  String get pause => 'पॉज करा';

  @override
  String get viewPhoto => 'फोटो पाहा';

  @override
  String get doctorSpeaks => 'डॉक्टर बोलतात ती भाषा';

  @override
  String listeningIn(String language) {
    return 'ऐकत आहोत · $language';
  }

  @override
  String get liveCaptionHint => 'ऐकत आहोत… डॉक्टरांचे बोलणे इथे दिसेल.';

  @override
  String get transcriptHelp =>
      'प्रत्येक वाक्य ऐकताच इथे जोडले जाते. तुम्ही कोणताही शब्द दुरुस्त करू शकता.';

  @override
  String voiceLanguageMissing(String language) {
    return 'या फोनवर $language व्हॉइस टायपिंग सेट केलेले नाही. दुसरी भाषा निवडा, किंवा फोनच्या व्हॉइस टायपिंग सेटिंग्जमध्ये ती जोडा.';
  }

  @override
  String get voiceNeedsInternet =>
      'व्हॉइस टायपिंगसाठी इंटरनेट लागते. तुम्ही टाइपही करू शकता.';

  @override
  String get voiceWaitingInternet =>
      'इंटरनेट नाही. प्रयत्न सुरू आहे — आतापर्यंत ऐकलेले गमावले जाणार नाही.';

  @override
  String medicineNumber(int number) {
    return 'औषध $number';
  }

  @override
  String get addAnotherMedicine => 'आणखी एक औषध जोडा';

  @override
  String get medicinesVisitHint =>
      'डॉक्टरांनी दिलेले प्रत्येक औषध जोडा. पट्टीचा किंवा प्रिस्क्रिप्शनचा फोटो घ्या, डॉक्टर त्याबद्दल जे म्हणाले ते रेकॉर्ड करा, किंवा टाइप करा.';

  @override
  String get removeMedicineBody =>
      'याचे फोटो आणि व्हॉइस नोट्सही या फोनवरून हटवले जातील.';

  @override
  String get questionRemoved => 'प्रश्न काढला';

  @override
  String get recordDoctor => 'डॉक्टरांचा आवाज रेकॉर्ड करा';

  @override
  String get doctorRecordings => 'रेकॉर्डिंग';

  @override
  String recordingNumber(int number) {
    return 'रेकॉर्डिंग $number';
  }

  @override
  String get recordOrListenHint =>
      'ऐका दाबल्यास डॉक्टरांचे बोलणे लिहिले जाते. रेकॉर्ड दाबल्यास त्यांचा आवाज नंतर ऐकण्यासाठी राहतो. फोनचा माइक एका वेळी एकच काम करतो.';

  @override
  String get tomorrow => 'उद्या';

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिवसांत',
      one: '1 दिवसात',
    );
    return '$_temp0';
  }

  @override
  String withDoctor(String doctor) {
    return '$doctor यांच्याकडे';
  }

  @override
  String recordingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेकॉर्डिंग',
      one: '1 रेकॉर्डिंग',
    );
    return '$_temp0';
  }

  @override
  String photosCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फोटो',
      one: '1 फोटो',
    );
    return '$_temp0';
  }

  @override
  String get noNextVisitHint =>
      'डॉक्टरांनी पुन्हा येण्याची तारीख दिल्यास, भेट रेकॉर्ड करताना ती जोडा. ती इथे दिसेल.';

  @override
  String circleSubtitle(String name) {
    return '$name यांची काळजी घेणारे सर्व, एकत्र.';
  }

  @override
  String get familyCode => 'कुटुंब कोड';

  @override
  String familyCodeHint(String name) {
    return 'हा कोड पाठवा. कुटुंबीय आणि मदतनीस तो Gurtu मध्ये टाकून $name यांच्या वर्तुळात सामील होऊ शकतात.';
  }

  @override
  String get copyCode => 'कोड कॉपी करा';

  @override
  String get codeCopied => 'कोड कॉपी झाला';

  @override
  String get newCode => 'नवा कोड बनवा';

  @override
  String get newCodeTitle => 'नवा कोड बनवायचा?';

  @override
  String get newCodeBody =>
      'जुना कोड चालणार नाही. आधीपासून वर्तुळात असलेले तसेच राहतील.';

  @override
  String get circleMembers => 'वर्तुळातील लोक';

  @override
  String get circleOwner => 'वर्तुळ सुरू केले';

  @override
  String get getsReminders => 'स्मरणपत्रे मिळतात';

  @override
  String get noNotifications => 'सूचना बंद';

  @override
  String get notOnApp => 'ॲपवर नाहीत';

  @override
  String get sendTestNotification => 'चाचणी सूचना पाठवा';

  @override
  String testSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फोनवर पाठवले',
      one: '1 फोनवर पाठवले',
      zero: 'अजून कोणत्याही फोनपर्यंत पोहोचले नाही',
    );
    return '$_temp0';
  }

  @override
  String get testTitle => 'Gurtu कडून चाचणी';

  @override
  String testBody(String name) {
    return '$name यांच्या काळजी वर्तुळासाठी सूचना चालू आहेत.';
  }

  @override
  String get settingUpCode => 'तुमचा कुटुंब कोड तयार होत आहे…';

  @override
  String get offlineTitle => 'Gurtu सर्व्हरशी संपर्क झाला नाही';

  @override
  String get offlineBody =>
      'सर्व काही या फोनवर सुरक्षित आहे. इंटरनेट मिळताच कुटुंब कोड दिसेल.';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get haveFamilyCode => 'माझ्याकडे कुटुंब कोड आहे';

  @override
  String get joinTitle => 'काळजी वर्तुळात सामील व्हा';

  @override
  String get joinSubtitle =>
      'तुमच्या कुटुंबातील कोणी पाठवलेला 6 अंकी कोड टाका.';

  @override
  String get howHelping => 'तुम्ही कशी मदत करता?';

  @override
  String get joinButton => 'वर्तुळात सामील व्हा';

  @override
  String get invalidCode =>
      'हा कोड कोणत्याही कुटुंबाशी जुळत नाही. अंक तपासून पुन्हा प्रयत्न करा.';

  @override
  String get tooManyTries =>
      'खूप वेळा प्रयत्न झाले. काही मिनिटे थांबून पुन्हा प्रयत्न करा.';

  @override
  String get connectionFailed =>
      'कनेक्ट झाले नाही. इंटरनेट तपासून पुन्हा प्रयत्न करा.';

  @override
  String get somethingWrong => 'काहीतरी चुकले. कृपया पुन्हा प्रयत्न करा.';

  @override
  String joinedCircle(String name) {
    return 'तुम्ही $name यांच्या काळजी वर्तुळात सामील झालात';
  }

  @override
  String get peopleYouCareFor => 'तुम्ही ज्यांची काळजी घेता';

  @override
  String get addPersonTitle => 'काळजी घेण्यासाठी कोणाला तरी जोडा';

  @override
  String get setUpNew => 'नवीन व्यक्तीसाठी सेट करा';

  @override
  String get setUpNewHint =>
      'त्यांच्याबद्दल काही प्रश्नांची उत्तरे द्या. त्यांना स्वतःचा कुटुंब कोड मिळेल.';

  @override
  String get joinWithCode => 'कुटुंब कोडने सामील व्हा';

  @override
  String get joinWithCodeHint =>
      'कुटुंबातील कोणीतरी त्यांच्यासाठी आधीच Gurtu सेट केले आहे.';

  @override
  String get yourCare => 'तुमची काळजी';

  @override
  String get lookingAfterYou => 'तुमची काळजी घेणारे';

  @override
  String lookingAfterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोक तुमची काळजी घेतात',
      one: '1 व्यक्ती तुमची काळजी घेते',
      zero: 'अजून कोणी नाही',
    );
    return '$_temp0';
  }

  @override
  String get inviteFamily => 'तुमच्या कुटुंबाला आमंत्रित करा';

  @override
  String get inviteFamilyHint =>
      'तुमचा कुटुंब कोड पाठवा. त्यांना तुमची काळजी दिसेल आणि तुमची स्मरणपत्रे मिळतील.';

  @override
  String get askForHelp => 'कुटुंबाकडे मदत मागा';

  @override
  String get askForHelpTitle => 'कुटुंबाला संदेश पाठवायचा?';

  @override
  String get askForHelpBody =>
      'तुमच्या काळजी वर्तुळातील सर्वांना तुम्हाला फोन करण्याची किंवा भेटण्याची सूचना मिळेल.';

  @override
  String get send => 'पाठवा';

  @override
  String helpSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोकांना पाठवले',
      one: '1 व्यक्तीला पाठवले',
      zero: 'अजून कोणापर्यंत पोहोचले नाही',
    );
    return '$_temp0';
  }

  @override
  String get circleSubtitleSelf => 'तुमची काळजी घेणारे लोक.';

  @override
  String get iAmPatient => 'ज्यांची काळजी घेतली जाते ती व्यक्ती मी आहे';

  @override
  String get patientTaken =>
      'काळजी घेतली जाणारी व्यक्ती म्हणून कोणीतरी आधीच सामील झाले आहे. दुसरी भूमिका निवडा.';

  @override
  String get medRemindersTitle => 'औषधांची स्मरणपत्रे';

  @override
  String medRemindersIntro(String name) {
    return 'Gurtu ने $name यांच्यासाठी डॉक्टरांच्या सूचना वाचल्या. प्रत्येक वेळ तपासा, मग स्मरणपत्रे सुरू करा.';
  }

  @override
  String get readingMedicines => 'औषधे वाचत आहोत…';

  @override
  String get readByAi => 'Gurtu AI ने वाचले';

  @override
  String get readByRules => 'तुमच्या नोट्समधून वाचले';

  @override
  String get pickTimes => 'कधी घ्यायचे ते निवडा';

  @override
  String get everyDay => 'रोज';

  @override
  String forDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिवस',
      one: '1 दिवस',
    );
    return '$_temp0';
  }

  @override
  String get howLong => 'किती दिवस';

  @override
  String get turnOnReminders => 'स्मरणपत्रे सुरू करा';

  @override
  String remindersSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्मरणपत्रे सुरू आहेत',
      one: '1 स्मरणपत्र सुरू आहे',
    );
    return '$_temp0';
  }

  @override
  String remindersGoToPatient(String name) {
    return 'स्मरणपत्रे $name यांच्या फोनवर जातील. घेतल्याचे नोंदवले नाही, तर Gurtu आणखी दोनदा आठवण करून देईल, मग कुटुंबाला कळवेल.';
  }

  @override
  String remindersGoToFamily(String name) {
    return '$name Gurtu वापरत नाहीत, म्हणून स्मरणपत्रे कुटुंबाच्या फोनवर जातील. घेतल्याचे नोंदवले नाही, तर Gurtu आणखी दोनदा आठवण करून देईल, मग सर्वांना कळवेल.';
  }

  @override
  String get remindersPending =>
      'या फोनवर जतन केले. इंटरनेट मिळताच स्मरणपत्रे सुरू होतील.';

  @override
  String get setUpReminders => 'स्मरणपत्रे सेट करा';

  @override
  String get changeReminders => 'स्मरणपत्रे बदला';

  @override
  String get takenIt => 'मी घेतले';

  @override
  String get skipDose => 'या वेळी वगळा';

  @override
  String dueAt(String time) {
    return '$time वाजता घ्यायचे';
  }

  @override
  String get readAloud => 'वाचून दाखवा';

  @override
  String get missedDoseEyebrow => 'चुकलेला डोस';

  @override
  String get markTakenForThem => 'घेतले म्हणून नोंदवा';

  @override
  String get illCheck => 'मी लक्ष देतो';

  @override
  String get doseTakenThanks => 'घेतले म्हणून नोंदवले. छान!';

  @override
  String get noReminderForThis => 'स्मरणपत्र नाही';

  @override
  String get reminderEyebrow => 'औषधाचे स्मरणपत्र';

  @override
  String get autoReminders => 'आपोआप औषधांची स्मरणपत्रे';

  @override
  String get autoRemindersHint =>
      'डॉक्टरांनी दिलेले प्रत्येक औषध Gurtu AI समजून घेते आणि त्याची स्मरणपत्रे स्वतः सुरू करते. भेटीमध्ये तुम्ही ती पाहू किंवा बदलू शकता.';

  @override
  String autoRemindersDone(String medicines) {
    return '$medicines ची स्मरणपत्रे सुरू आहेत';
  }

  @override
  String get visitSavedAuto =>
      'भेट सेव्ह झाली. Gurtu औषधांची स्मरणपत्रे लावत आहे.';

  @override
  String get testReminder => 'आत्ता टेस्ट स्मरणपत्र पाठवा';

  @override
  String get testReminderHint =>
      'स्मरणपत्रे येणाऱ्या फोनवर खरे स्मरणपत्र लगेच जाते. कोणी खूण केली नाही, तर 1 आणि 2 मिनिटांनी पुन्हा येते, मग कुटुंबाला चुकलेल्या डोसची सूचना जाते.';

  @override
  String get testMedicine => 'टेस्ट औषध';

  @override
  String get testBadge => 'टेस्ट';

  @override
  String get skipConfirmTitle => 'हा डोस वगळायचा?';

  @override
  String get skipConfirmBody =>
      'या डोससाठी Gurtu पुन्हा आठवण करणार नाही, आणि कुटुंबाला कळवले जाईल.';
}
