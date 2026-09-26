// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get continueLabel => 'आगे बढ़ें';

  @override
  String get next => 'आगे';

  @override
  String get skip => 'छोड़ें';

  @override
  String get later => 'बाद में';

  @override
  String get back => 'पीछे';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get notSure => 'पता नहीं';

  @override
  String get tagline => 'याद रखें। देखभाल करें। साथ मिलकर।';

  @override
  String get motherName => 'माँ';

  @override
  String get phaseAbout => 'परिचय';

  @override
  String get phaseHealth => 'सेहत';

  @override
  String get phasePermissions => 'अनुमतियाँ';

  @override
  String get phaseAi => 'AI सेटअप';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $total में से $current';
  }

  @override
  String get languageTitle => 'अपनी भाषा चुनें';

  @override
  String get languageSubtitle => 'Gurtu इसी भाषा में बोलेगा, सुनेगा और लिखेगा।';

  @override
  String get languageMixNote =>
      'डॉक्टर अक्सर आपकी भाषा में अंग्रेज़ी मिलाकर बोलते हैं। Gurtu दोनों को साथ में समझता है।';

  @override
  String get welcomeTitle => 'आपके परिवार की\nदेखभाल की याद';

  @override
  String get welcomeBody =>
      'डॉक्टर ने क्या कहा, कौन-सी दवा लिखी और घर पर क्या हुआ — सब मिलकर याद रखें।';

  @override
  String get welcomeScript => 'अलग भूमिकाएँ। एक ही प्यार।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String builtForBrand(String brand) {
    return '$brand के लिए बनाया गया';
  }

  @override
  String get madeInHyderabad => 'हैदराबाद में बना';

  @override
  String get introRecordEyebrow => '1 · रिकॉर्ड करें';

  @override
  String get introRecordTitle => 'डॉक्टर की बात कभी न भूलें';

  @override
  String get introRecordBody =>
      'सबकी सहमति से डॉक्टर, नर्स या फार्मासिस्ट की बात रिकॉर्ड करें। Gurtu ज़रूरी बातें संभाल कर रखता है।';

  @override
  String get introPlanEyebrow => '2 · समझें और बाँटें';

  @override
  String get introPlanTitle => 'पूरे परिवार के लिए एक देखभाल योजना';

  @override
  String get introPlanBody =>
      'पर्चे और रिपोर्ट स्कैन करें। Gurtu उन्हें आसान कामों में बदल देता है जिन्हें परिवार बाँट सकता है।';

  @override
  String get introAskEyebrow => '3 · पूछें और याद रखें';

  @override
  String get introAskTitle => 'कुछ भी पूछें, सबूत देखें';

  @override
  String get introAskBody =>
      'हर जवाब बताता है कि वह कहाँ से आया — रिकॉर्डिंग, पर्चा या फ़ोटो।';

  @override
  String get letsSetUp => 'सेटअप करें';

  @override
  String get hospitalMode => 'हॉस्पिटल मोड';

  @override
  String get consentRecording => 'सभी की सहमति से रिकॉर्डिंग';

  @override
  String get doctorConversation => 'डॉक्टर से बातचीत';

  @override
  String get nurseInstructions => 'नर्स के निर्देश';

  @override
  String get pharmacistAdvice => 'फार्मासिस्ट की सलाह';

  @override
  String get yourCarePlan => 'आपकी देखभाल योजना';

  @override
  String get afterBreakfast => 'नाश्ते के बाद';

  @override
  String get checkBloodPressure => 'BP जाँचें';

  @override
  String get twiceDaily => 'दिन में दो बार';

  @override
  String get bloodTest => 'खून की जाँच (CBC)';

  @override
  String get instructionsFound => 'आपकी रिकॉर्डिंग और पर्चे में 4 निर्देश मिले';

  @override
  String get askQuestion => 'डॉक्टर ने शाम की दवा के बारे में क्या कहा?';

  @override
  String get askAnswer =>
      'डॉक्टर ने Amlodipine रात के खाने के बाद लेने को कहा।';

  @override
  String get sourceDoctorVisit => 'स्रोत: डॉक्टर विज़िट';

  @override
  String get careForTitle => 'आप Gurtu किसके लिए सेट कर रहे हैं?';

  @override
  String get careForSubtitle =>
      'Gurtu एक व्यक्ति के आसपास देखभाल की याद बनाता है। बाकी परिवार को आप बाद में जोड़ सकते हैं।';

  @override
  String get careForMyself => 'अपने लिए';

  @override
  String get careForMyselfHint =>
      'मैं अपनी देखभाल का ध्यान रखना चाहता/चाहती हूँ';

  @override
  String get careForParent => 'माता-पिता';

  @override
  String get careForParentHint => 'माँ, पिताजी या परिवार के कोई बुज़ुर्ग';

  @override
  String get careForPartner => 'जीवनसाथी';

  @override
  String get careForPartnerHint => 'पति, पत्नी या साथी';

  @override
  String get careForChild => 'मेरा बच्चा';

  @override
  String get careForChildHint => 'बेटा या बेटी';

  @override
  String get careForOther => 'कोई और';

  @override
  String get careForOtherHint => 'रिश्तेदार, दोस्त या पड़ोसी';

  @override
  String get profileTitleSelf => 'अपने बारे में बताएँ';

  @override
  String get profileTitleOther => 'उनके बारे में बताएँ';

  @override
  String get profileSubtitleSelf => 'इससे Gurtu आपको नाम से बुला पाएगा।';

  @override
  String get profileSubtitleOther =>
      'वही नाम लिखें जिससे आप उन्हें घर पर बुलाते हैं।';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get whatDoYouCallThem => 'आप उन्हें क्या बुलाते हैं?';

  @override
  String exampleName(String name) {
    return 'जैसे $name';
  }

  @override
  String get sampleSelfName => 'सुनीता';

  @override
  String get sampleYourName => 'प्रिया';

  @override
  String get yourAge => 'आपकी उम्र';

  @override
  String get theirAge => 'उनकी उम्र';

  @override
  String get years => 'साल';

  @override
  String get decreaseAge => 'उम्र घटाएँ';

  @override
  String get increaseAge => 'उम्र बढ़ाएँ';

  @override
  String get gender => 'लिंग';

  @override
  String get female => 'महिला';

  @override
  String get male => 'पुरुष';

  @override
  String get genderOther => 'अन्य';

  @override
  String get andYou => 'और आप?';

  @override
  String get andYouBody => 'आप उनके केयर सर्कल के पहले सदस्य होंगे।';

  @override
  String get conditionsTitleSelf => 'क्या आपको इनमें से कोई बीमारी है?';

  @override
  String conditionsTitleOther(String name) {
    return 'क्या $name को इनमें से कोई बीमारी है?';
  }

  @override
  String get conditionsSubtitle =>
      'जो भी लागू हों, सब चुनें। इससे Gurtu देखभाल योजना बनाता है।';

  @override
  String get condDiabetes => 'शुगर (डायबिटीज़)';

  @override
  String get condHighBp => 'हाई BP';

  @override
  String get condHeart => 'दिल की बीमारी';

  @override
  String get condThyroid => 'थायराइड';

  @override
  String get condCholesterol => 'कोलेस्ट्रॉल';

  @override
  String get condAsthma => 'दमा / साँस की तकलीफ़';

  @override
  String get condKidney => 'किडनी की बीमारी';

  @override
  String get condArthritis => 'जोड़ों का दर्द / गठिया';

  @override
  String get condStroke => 'पहले लकवा हुआ था';

  @override
  String get condCancer => 'कैंसर का इलाज';

  @override
  String get noneOfThese => 'इनमें से कोई नहीं';

  @override
  String get notADoctor =>
      'Gurtu डॉक्टर नहीं है। यह कभी बीमारी नहीं बताता — बस परिवार को देखभाल याद रखने और संभालने में मदद करता है।';

  @override
  String get medicinesTitleSelf => 'क्या आप रोज़ दवा लेते हैं?';

  @override
  String medicinesTitleOther(String name) {
    return 'क्या $name रोज़ दवा लेते हैं?';
  }

  @override
  String get medicinesSubtitle =>
      'गोलियाँ, सिरप, इनहेलर या इंसुलिन — सब शामिल करें।';

  @override
  String get howMany => 'लगभग कितनी?';

  @override
  String get sixOrMore => '6 या ज़्यादा';

  @override
  String get scanLaterTip =>
      'बाद में बस पर्चा या दवा की पट्टी स्कैन करें — टाइप करने की ज़रूरत नहीं।';

  @override
  String get allergiesTitleSelf => 'क्या आपको किसी चीज़ से एलर्जी है?';

  @override
  String allergiesTitleOther(String name) {
    return 'क्या $name को किसी चीज़ से एलर्जी है?';
  }

  @override
  String get allergiesSubtitle =>
      'Gurtu इसे हर डॉक्टर ब्रीफ़ में दिखाएगा ताकि यह कभी न छूटे।';

  @override
  String get allergyNone => 'कोई ज्ञात एलर्जी नहीं';

  @override
  String get allergyPenicillin => 'पेनिसिलिन';

  @override
  String get allergySulfa => 'सल्फ़ा दवाएँ';

  @override
  String get allergyAspirin => 'एस्पिरिन / दर्द की दवा';

  @override
  String get allergyFood => 'खाने से एलर्जी';

  @override
  String get allergyDust => 'धूल / पराग';

  @override
  String get allergyLatex => 'लेटेक्स';

  @override
  String get mobilityTitleSelf => 'आप रोज़ाना कैसे चलते-फिरते हैं?';

  @override
  String mobilityTitleOther(String name) {
    return '$name रोज़ाना कैसे चलते-फिरते हैं?';
  }

  @override
  String get mobilitySubtitle =>
      'इससे परिवार विज़िट, जाँच और घर पर मदद की योजना बना पाता है।';

  @override
  String get mobilityIndependent => 'खुद चल लेते हैं';

  @override
  String get mobilityIndependentHint => 'रोज़ के कामों में मदद नहीं चाहिए';

  @override
  String get mobilitySomeHelp => 'थोड़ी मदद चाहिए';

  @override
  String get mobilitySomeHelpHint => 'छड़ी, वॉकर या किसी का हाथ';

  @override
  String get mobilityFullHelp => 'ज़्यादातर बिस्तर या व्हीलचेयर पर';

  @override
  String get mobilityFullHelpHint => 'ज़्यादातर कामों में मदद चाहिए';

  @override
  String get hospitalTitleSelf =>
      'क्या पिछले 30 दिनों में आप अस्पताल या डॉक्टर के पास गए हैं?';

  @override
  String hospitalTitleOther(String name) {
    return 'क्या पिछले 30 दिनों में $name अस्पताल या डॉक्टर के पास गए हैं?';
  }

  @override
  String get hospitalSubtitle =>
      'हाल की विज़िट के साथ अक्सर नए निर्देश आते हैं।';

  @override
  String get hospitalTip =>
      'डिस्चार्ज के कागज़ और पर्चे पास रखें — सेटअप के तुरंत बाद आप उन्हें स्कैन कर सकते हैं।';

  @override
  String get permissionsTitle => 'आपकी मदद के लिए कुछ अनुमतियाँ';

  @override
  String get permissionsSubtitle =>
      'Gurtu सिर्फ़ ज़रूरी चीज़ें माँगता है। यहाँ बताया गया है क्यों।';

  @override
  String get permMic => 'माइक्रोफ़ोन';

  @override
  String get permMicWhy =>
      'डॉक्टर विज़िट और वॉइस नोट रिकॉर्ड करें — सिर्फ़ जब आप रिकॉर्ड दबाएँ।';

  @override
  String get permCamera => 'कैमरा';

  @override
  String get permCameraWhy =>
      'पर्चे, दवा की पट्टी और BP मशीन की रीडिंग स्कैन करें।';

  @override
  String get permNotifications => 'सूचनाएँ';

  @override
  String get permNotificationsWhy =>
      'दवा की याद और परिवार के काम पूरा होने की जानकारी।';

  @override
  String get permPhotos => 'फ़ोटो और फ़ाइलें';

  @override
  String get permPhotosWhy => 'गैलरी में पहले से रखी रिपोर्ट और पर्चे जोड़ें।';

  @override
  String get permContacts => 'संपर्क';

  @override
  String get permContactsWhy =>
      'परिवार के सदस्यों को केयर सर्कल में जल्दी बुलाएँ।';

  @override
  String get needed => 'ज़रूरी';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get allowed => 'अनुमति मिली';

  @override
  String get allowAndContinue => 'अनुमति दें और आगे बढ़ें';

  @override
  String get privacyNote =>
      'सब कुछ इसी फ़ोन में रहता है। रिकॉर्डिंग अपने-आप कभी शुरू नहीं होती — पहले हमेशा सहमति स्क्रीन दिखती है।';

  @override
  String permissionBlocked(String permission) {
    return '$permission बंद है। इसे सेटिंग्स में चालू करें।';
  }

  @override
  String get settings => 'सेटिंग्स';

  @override
  String permissionsMissing(String items) {
    return '$items के बिना कुछ सुविधाएँ काम नहीं करेंगी। आप बाद में अनुमति दे सकते हैं।';
  }

  @override
  String get modelTitleChoose => 'Gurtu का ऑन-डिवाइस AI सेट करें';

  @override
  String get modelTitleDownloading => 'आपका AI सेट हो रहा है…';

  @override
  String get modelTitleDone => 'आपका AI तैयार है';

  @override
  String get modelSubtitleChoose =>
      'ये मॉडल पूरी तरह आपके iQOO पर चलते हैं। परिवार की सेहत की जानकारी फ़ोन से बाहर नहीं जाती — और बिना इंटरनेट भी काम करता है।';

  @override
  String get modelSubtitleDownloading =>
      'आप फ़ोन चलाते रह सकते हैं। यह सिर्फ़ एक बार होता है।';

  @override
  String get modelSubtitleDone => 'सब कुछ इसी फ़ोन पर चलता है, ऑफ़लाइन भी।';

  @override
  String get poweredByIqoo => 'आपके iQOO से संचालित';

  @override
  String get deviceCardSub => 'ऑन-डिवाइस AI · निजी · ऑफ़लाइन काम करता है';

  @override
  String get chooseCareModel => 'केयर मॉडल चुनें';

  @override
  String get careModelHint => 'यही दिमाग आपके सवालों के जवाब देता है।';

  @override
  String get alwaysIncluded => 'हमेशा शामिल';

  @override
  String get jobListens => 'सुनता है';

  @override
  String get jobReads => 'पढ़ता है';

  @override
  String get jobSees => 'देखता है';

  @override
  String get jobUnderstands => 'समझता है';

  @override
  String speechModelName(String language) {
    return 'आवाज़ · $language + अंग्रेज़ी';
  }

  @override
  String get speechModelWhat =>
      'बातचीत को आपकी भाषा में लिखित रूप में बदलता है।';

  @override
  String get readerModelName => 'दस्तावेज़ रीडर (OCR)';

  @override
  String get readerModelWhat =>
      'पर्चे, डिस्चार्ज के कागज़ और लैब रिपोर्ट पढ़ता है।';

  @override
  String get visionModelName => 'दवा और रीडिंग पहचान';

  @override
  String get visionModelWhat =>
      'दवा की पट्टी और BP / शुगर मशीन के अंक पहचानता है।';

  @override
  String careModelName(String model) {
    return 'केयर मॉडल · $model';
  }

  @override
  String get tierLite => 'लाइट';

  @override
  String get tierBalanced => 'संतुलित';

  @override
  String get tierPro => 'प्रो';

  @override
  String get tierLiteNote => 'सबसे तेज़। छोटे, आसान जवाब।';

  @override
  String get tierBalancedNote => 'आवाज़, फ़ोटो और टेक्स्ट को साथ में समझता है।';

  @override
  String get tierProNote => 'सबसे विस्तृत जवाब और डॉक्टर ब्रीफ़।';

  @override
  String get bestForIqoo => 'iQOO के लिए सबसे अच्छा';

  @override
  String get wifiOnly => 'सिर्फ़ Wi-Fi पर डाउनलोड करें';

  @override
  String downloadSize(String size) {
    return 'डाउनलोड · $size';
  }

  @override
  String get settingUp => 'सेट हो रहा है…';

  @override
  String get ready => 'तैयार';

  @override
  String allSetName(String name) {
    return 'सब तैयार है, $name!';
  }

  @override
  String get allSet => 'सब तैयार है!';

  @override
  String get readySelf => 'आपकी देखभाल की याद तैयार है।';

  @override
  String readyOther(String name) {
    return '$name की देखभाल की याद तैयार है। अब परिवार को बुलाएँ।';
  }

  @override
  String get rowYou => 'आप';

  @override
  String get rowCaringFor => 'किसकी देखभाल';

  @override
  String get rowHealth => 'सेहत';

  @override
  String get rowAllergies => 'एलर्जी';

  @override
  String get rowLanguage => 'भाषा';

  @override
  String get rowAi => 'ऑन-डिवाइस AI';

  @override
  String get notAdded => 'नहीं जोड़ा गया';

  @override
  String ageYears(int age) {
    return '$age साल';
  }

  @override
  String get careQuote => '“साथ मिलकर देखभाल करें तो बोझ हल्का लगता है।”';

  @override
  String get enterGurtu => 'Gurtu खोलें';

  @override
  String get nextUpCareCircle => 'आगे: केयर सर्कल';

  @override
  String get homeComingSoon => 'होम स्क्रीन अगले भाग में आ रही हैं।';

  @override
  String get restartOnboarding => 'ऑनबोर्डिंग फिर से शुरू करें';

  @override
  String get navHome => 'होम';

  @override
  String get navMemory => 'यादें';

  @override
  String get navCircle => 'सर्कल';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String goodMorning(String name) {
    return 'सुप्रभात, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String goodEvening(String name) {
    return 'शुभ संध्या, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu में आपका स्वागत है, $name';
  }

  @override
  String get welcomeHomeSubtitle => 'आपके परिवार की सेहत, सब मिलकर याद रखें।';

  @override
  String get caringFor => 'देखभाल';

  @override
  String get switchPatientTitle => 'आप किसकी देखभाल कर रहे हैं?';

  @override
  String get addAnotherPerson => 'किसी और को जोड़ें';

  @override
  String get statusOnTrack => 'देखभाल ठीक चल रही है';

  @override
  String get statusNeedsAttention => 'किसी चीज़ पर ध्यान देना है';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'आपातकाल';

  @override
  String get sosHoldTitle => 'केयर सर्कल को अलर्ट करने के लिए दबाकर रखें';

  @override
  String get sosHoldBody =>
      'बटन को 2 सेकंड दबाकर रखें। आपके आपातकालीन संपर्कों को अलर्ट भेजा जाएगा।';

  @override
  String get sosHoldButton => 'SOS भेजने के लिए दबाकर रखें';

  @override
  String get sosKeepHolding => 'दबाए रखें…';

  @override
  String get sosPreviewNote =>
      'आपातकालीन अलर्ट अभी जुड़े नहीं हैं। यह सिर्फ़ झलक है — किसी को अलर्ट नहीं जाएगा।';

  @override
  String get sosPreviewDone => 'झलक पूरी हुई। किसी को अलर्ट नहीं भेजा गया।';

  @override
  String get close => 'बंद करें';

  @override
  String get todayCare => 'आज की देखभाल';

  @override
  String completedOf(int done, int total) {
    return '$total में से $done पूरे';
  }

  @override
  String get viewTodayCare => 'आज की देखभाल देखें';

  @override
  String get nothingUrgent => 'अभी कुछ ज़रूरी नहीं है।';

  @override
  String get markDone => 'पूरा हुआ चिह्नित करें';

  @override
  String get markNotDone => 'अधूरा चिह्नित करें';

  @override
  String get openToCircle => 'केयर सर्कल के लिए खुला';

  @override
  String get captureCare => 'देखभाल दर्ज करें';

  @override
  String get captureCareSubtitle => 'देखभाल से जुड़ी कोई ज़रूरी बात दर्ज करें।';

  @override
  String get whatHappened => 'क्या हुआ?';

  @override
  String get captureVoice => 'आवाज़';

  @override
  String get captureVoiceHint => 'बातचीत या वॉइस नोट रिकॉर्ड करें';

  @override
  String get captureScan => 'स्कैन';

  @override
  String get captureScanHint => 'पर्चा या दवा की पट्टी';

  @override
  String get captureVital => 'रीडिंग';

  @override
  String get captureVitalHint => 'BP, शुगर या तापमान';

  @override
  String get captureDocument => 'दस्तावेज़';

  @override
  String get captureDocumentHint => 'डिस्चार्ज पेपर या लैब रिपोर्ट';

  @override
  String get captureNote => 'नोट';

  @override
  String get captureNoteHint => 'जो हुआ वह लिखें';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get noteHint => 'जैसे चलने के बाद चक्कर आया';

  @override
  String get saveNote => 'नोट सहेजें';

  @override
  String get noteSaved => 'देखभाल की याद में सहेजा गया';

  @override
  String get recentMemory => 'हाल की यादें';

  @override
  String get viewAll => 'सब देखें';

  @override
  String get emptyMemory => 'आपकी देखभाल की कहानी यहाँ से शुरू होती है।';

  @override
  String addedBy(String name) {
    return '$name द्वारा';
  }

  @override
  String get sourcePlay => 'सुनें';

  @override
  String get sourceView => 'देखें';

  @override
  String get sourceOpen => 'खोलें';

  @override
  String get sourceTitle => 'स्रोत';

  @override
  String get sourceRecording => 'डॉक्टर की रिकॉर्डिंग';

  @override
  String get sourceScan => 'पर्चा स्कैन';

  @override
  String get sourceVital => 'रीडिंग';

  @override
  String get sourceDocument => 'दस्तावेज़';

  @override
  String get sourceNote => 'लिखा हुआ नोट';

  @override
  String get sourceSampleNote =>
      'यह नमूना डेटा है, इसलिए कोई असली फ़ाइल नहीं है। असली रिकॉर्डिंग और स्कैन यहाँ खुलेंगे।';

  @override
  String get yourCareCircle => 'आपका केयर सर्कल';

  @override
  String get manageCircle => 'सर्कल संभालें';

  @override
  String get emptyCircle => 'साथ मिलकर देखभाल आसान होती है।';

  @override
  String get addFamilyMember => 'परिवार का सदस्य जोड़ें';

  @override
  String get rolePatient => 'मरीज़';

  @override
  String get roleCaregiver => 'देखभाल करने वाले';

  @override
  String get roleFamily => 'परिवार';

  @override
  String get roleHelper => 'भरोसेमंद सहायक';

  @override
  String get askGurtuTitle => 'Gurtu से पूछें';

  @override
  String get askGurtuPrompt => 'कुछ याद रखने में मदद चाहिए?';

  @override
  String get askExampleBloodTest => 'खून की जाँच कब है?';

  @override
  String get askExampleDoctor => 'कल डॉक्टर से क्या पूछूँ?';

  @override
  String get askGurtuNote => 'जवाब आपकी सहेजी गई देखभाल जानकारी से आते हैं।';

  @override
  String get gettingReady => 'Gurtu तैयार हो रहा है';

  @override
  String get readyYourProfile => 'आपकी प्रोफ़ाइल';

  @override
  String get readyPatientProfile => 'मरीज़ की प्रोफ़ाइल';

  @override
  String get readyCareCircle => 'केयर सर्कल';

  @override
  String get readyEmergencyContact => 'आपातकालीन संपर्क';

  @override
  String get previewSampleData => 'नमूना डेटा के साथ देखें';

  @override
  String get sampleDataOn => 'नमूना देखभाल डेटा दिख रहा है';

  @override
  String get remove => 'हटाएँ';

  @override
  String get hide => 'छिपाएँ';

  @override
  String get comingNextPhase => 'यह भाग आगे बनाया जा रहा है।';

  @override
  String get fatherName => 'पापा';

  @override
  String get sampleTaskMorningMedicine => 'सुबह की दवा';

  @override
  String get sampleTaskRecordBp => 'BP दर्ज करें';

  @override
  String get sampleTaskBloodTest => 'खून की जाँच';

  @override
  String get sampleTaskDoctorVisit => 'डॉक्टर से मुलाक़ात';

  @override
  String get sampleMomentDoctorTalk => 'डॉक्टर से बातचीत';

  @override
  String get sampleMomentDoctorTalkDetail => '“दवा नाश्ते के बाद लें।”';

  @override
  String get sampleMomentPrescription => 'पर्चा स्कैन किया गया';

  @override
  String get sampleMomentPrescriptionDetail => '2 दवाएँ मिलीं';

  @override
  String get sampleMomentBp => 'BP दर्ज किया गया';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';
}
