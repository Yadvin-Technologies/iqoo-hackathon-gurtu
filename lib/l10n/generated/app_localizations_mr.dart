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
}
