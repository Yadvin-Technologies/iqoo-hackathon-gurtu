// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Assamese (`as`).
class AppLocalizationsAs extends AppLocalizations {
  AppLocalizationsAs([String locale = 'as']) : super(locale);

  @override
  String get continueLabel => 'আগবাঢ়ক';

  @override
  String get next => 'পৰৱৰ্তী';

  @override
  String get skip => 'এৰি দিয়ক';

  @override
  String get later => 'পিছত';

  @override
  String get back => 'উভতি যাওক';

  @override
  String get optional => 'ঐচ্ছিক';

  @override
  String get yes => 'হয়';

  @override
  String get no => 'নহয়';

  @override
  String get notSure => 'নাজানো';

  @override
  String get tagline => 'মনত ৰাখক। যত্ন লওক। একেলগে।';

  @override
  String get motherName => 'মা';

  @override
  String get phaseAbout => 'পৰিচয়';

  @override
  String get phaseHealth => 'স্বাস্থ্য';

  @override
  String get phasePermissions => 'অনুমতি';

  @override
  String get phaseAi => 'AI ছেটআপ';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $totalৰ ভিতৰত $current';
  }

  @override
  String get languageTitle => 'আপোনাৰ ভাষা বাছক';

  @override
  String get languageSubtitle => 'Gurtu এই ভাষাতে কথা ক\'ব, শুনিব আৰু লিখিব।';

  @override
  String get languageMixNote =>
      'ডাক্তৰে প্ৰায়ে আপোনাৰ ভাষাত ইংৰাজী মিহলাই কথা কয়। Gurtu এ দুয়োটা একেলগে বুজি পায়।';

  @override
  String get welcomeTitle => 'আপোনাৰ পৰিয়ালৰ\nযত্নৰ স্মৃতি';

  @override
  String get welcomeBody =>
      'ডাক্তৰে কি ক\'লে, কি ঔষধ লিখিলে আৰু ঘৰত কি হ\'ল — সকলো একেলগে মনত ৰাখক।';

  @override
  String get welcomeScript => 'বেলেগ বেলেগ ভূমিকা। একেই মৰম।';

  @override
  String get getStarted => 'আৰম্ভ কৰক';

  @override
  String builtForBrand(String brand) {
    return '$brandৰ বাবে নিৰ্মিত';
  }

  @override
  String get madeInHyderabad => 'হায়দৰাবাদত নিৰ্মিত';

  @override
  String get introRecordEyebrow => '1 · ৰেকৰ্ড';

  @override
  String get introRecordTitle => 'ডাক্তৰৰ কথা কেতিয়াও নাপাহৰিব';

  @override
  String get introRecordBody =>
      'সকলোৰে সন্মতিত ডাক্তৰ, নাৰ্ছ বা ফাৰ্মাচিষ্টৰ কথা ৰেকৰ্ড কৰক। দৰকাৰী কথাখিনি Gurtu এ সাঁচি ৰাখে।';

  @override
  String get introPlanEyebrow => '2 · বুজক আৰু ভাগ কৰক';

  @override
  String get introPlanTitle => 'গোটেই পৰিয়ালৰ বাবে এটা যত্ন পৰিকল্পনা';

  @override
  String get introPlanBody =>
      'প্ৰেছক্ৰিপচন আৰু ৰিপৰ্ট স্কেন কৰক। Gurtu এ সেইবোৰক পৰিয়ালে ভাগ কৰিব পৰা সহজ কামলৈ সলনি কৰে।';

  @override
  String get introAskEyebrow => '3 · সোধক আৰু মনত ৰাখক';

  @override
  String get introAskTitle => 'যিকোনো কথা সোধক, প্ৰমাণ চাওক';

  @override
  String get introAskBody =>
      'প্ৰতিটো উত্তৰে দেখুৱায় সেয়া ক\'ৰ পৰা আহিল — ৰেকৰ্ডিং, প্ৰেছক্ৰিপচন বা ফটো।';

  @override
  String get letsSetUp => 'ছেটআপ কৰোঁ আহক';

  @override
  String get hospitalMode => 'হাস্পতাল ম\'ড';

  @override
  String get consentRecording => 'উপস্থিত সকলোৰে সন্মতিত ৰেকৰ্ডিং';

  @override
  String get doctorConversation => 'ডাক্তৰৰ সৈতে কথা-বতৰা';

  @override
  String get nurseInstructions => 'নাৰ্ছৰ নিৰ্দেশ';

  @override
  String get pharmacistAdvice => 'ফাৰ্মাচিষ্টৰ পৰামৰ্শ';

  @override
  String get yourCarePlan => 'আপোনাৰ যত্ন পৰিকল্পনা';

  @override
  String get afterBreakfast => 'ৰাতিপুৱাৰ আহাৰৰ পিছত';

  @override
  String get checkBloodPressure => 'BP পৰীক্ষা কৰক';

  @override
  String get twiceDaily => 'দিনে দুবাৰ';

  @override
  String get bloodTest => 'তেজ পৰীক্ষা (CBC)';

  @override
  String get instructionsFound =>
      'আপোনাৰ ৰেকৰ্ডিং আৰু প্ৰেছক্ৰিপচনত 4টা নিৰ্দেশ পোৱা গ\'ল';

  @override
  String get askQuestion => 'সন্ধিয়াৰ ঔষধৰ বিষয়ে ডাক্তৰে কি কৈছিল?';

  @override
  String get askAnswer => 'ডাক্তৰে Amlodipine ৰাতিৰ আহাৰৰ পিছত খাবলৈ ক\'লে।';

  @override
  String get sourceDoctorVisit => 'উৎস: ডাক্তৰ দেখুওৱা';

  @override
  String get careForTitle => 'আপুনি কাৰ বাবে Gurtu ছেট কৰিছে?';

  @override
  String get careForSubtitle =>
      'Gurtu এ এজন মানুহক কেন্দ্ৰ কৰি যত্নৰ স্মৃতি গঢ়ে। বাকী পৰিয়ালক পিছত আমন্ত্ৰণ জনাব পাৰিব।';

  @override
  String get careForMyself => 'নিজৰ বাবে';

  @override
  String get careForMyselfHint => 'নিজৰ যত্নৰ খবৰ ৰাখিব বিচাৰো';

  @override
  String get careForParent => 'মোৰ মাক-দেউতাক';

  @override
  String get careForParentHint => 'মা, দেউতা বা পৰিয়ালৰ কোনো জ্যেষ্ঠজন';

  @override
  String get careForPartner => 'মোৰ জীৱনসংগী';

  @override
  String get careForPartnerHint => 'স্বামী, পত্নী বা সংগী';

  @override
  String get careForChild => 'মোৰ সন্তান';

  @override
  String get careForChildHint => 'ল\'ৰা বা ছোৱালী';

  @override
  String get careForOther => 'আন কোনোবা';

  @override
  String get careForOtherHint => 'আত্মীয়, বন্ধু বা চুবুৰীয়া';

  @override
  String get profileTitleSelf => 'নিজৰ বিষয়ে কওক';

  @override
  String get profileTitleOther => 'তেওঁৰ বিষয়ে কওক';

  @override
  String get profileSubtitleSelf => 'ইয়াৰ দ্বাৰা Gurtu এ আপোনাক নামেৰে মাতিব।';

  @override
  String get profileSubtitleOther => 'ঘৰত যি নামেৰে মাতে সেই নামটো লিখক।';

  @override
  String get yourName => 'আপোনাৰ নাম';

  @override
  String get whatDoYouCallThem => 'আপুনি তেওঁক কি বুলি মাতে?';

  @override
  String exampleName(String name) {
    return 'যেনে $name';
  }

  @override
  String get sampleSelfName => 'অনিমা';

  @override
  String get sampleYourName => 'প্ৰিয়া';

  @override
  String get yourAge => 'আপোনাৰ বয়স';

  @override
  String get theirAge => 'তেওঁৰ বয়স';

  @override
  String get years => 'বছৰ';

  @override
  String get decreaseAge => 'বয়স কমাওক';

  @override
  String get increaseAge => 'বয়স বঢ়াওক';

  @override
  String get gender => 'লিংগ';

  @override
  String get female => 'মহিলা';

  @override
  String get male => 'পুৰুষ';

  @override
  String get genderOther => 'অন্য';

  @override
  String get andYou => 'আৰু আপুনি?';

  @override
  String get andYouBody => 'আপুনিয়েই হ\'ব তেওঁৰ কেয়াৰ চাৰ্কলৰ প্ৰথম সদস্য।';

  @override
  String get conditionsTitleSelf => 'আপোনাৰ এইবোৰৰ ভিতৰত কোনো ৰোগ আছে নেকি?';

  @override
  String conditionsTitleOther(String name) {
    return '$nameৰ এইবোৰৰ ভিতৰত কোনো ৰোগ আছে নেকি?';
  }

  @override
  String get conditionsSubtitle =>
      'যিবোৰ খাটে সকলো বাছক। ইয়াৰ দ্বাৰা Gurtu এ যত্ন পৰিকল্পনা সজায়।';

  @override
  String get condDiabetes => 'চুগাৰ (মধুমেহ)';

  @override
  String get condHighBp => 'হাই BP';

  @override
  String get condHeart => 'হৃদৰোগ';

  @override
  String get condThyroid => 'থাইৰয়ড';

  @override
  String get condCholesterol => 'কোলেষ্টেৰল';

  @override
  String get condAsthma => 'হাঁপানি / উশাহৰ কষ্ট';

  @override
  String get condKidney => 'কিডনীৰ সমস্যা';

  @override
  String get condArthritis => 'গাঁঠিৰ বিষ / আৰ্থ্ৰাইটিছ';

  @override
  String get condStroke => 'আগতে ষ্ট্ৰ\'ক হৈছিল';

  @override
  String get condCancer => 'কৰ্কট ৰোগৰ চিকিৎসা';

  @override
  String get noneOfThese => 'এইবোৰৰ এটাও নহয়';

  @override
  String get notADoctor =>
      'Gurtu ডাক্তৰ নহয়। ই কেতিয়াও ৰোগ নিৰ্ণয় নকৰে — কেৱল পৰিয়ালক যত্ন মনত ৰখাত আৰু সজাই ৰখাত সহায় কৰে।';

  @override
  String get medicinesTitleSelf => 'আপুনি প্ৰতিদিনে ঔষধ খায় নেকি?';

  @override
  String medicinesTitleOther(String name) {
    return '$nameএ প্ৰতিদিনে ঔষধ খায় নেকি?';
  }

  @override
  String get medicinesSubtitle =>
      'টেবলেট, চিৰাপ, ইনহেলাৰ বা ইনচুলিন — সকলো ধৰক।';

  @override
  String get howMany => 'প্ৰায় কেইটা?';

  @override
  String get sixOrMore => '6 বা তাতকৈ বেছি';

  @override
  String get scanLaterTip =>
      'পিছত কেৱল প্ৰেছক্ৰিপচন বা ঔষধৰ পাত স্কেন কৰক — টাইপ কৰিব নালাগে।';

  @override
  String get allergiesTitleSelf => 'আপোনাৰ কিবা বস্তুত এলাৰ্জী আছে নেকি?';

  @override
  String allergiesTitleOther(String name) {
    return '$nameৰ কিবা বস্তুত এলাৰ্জী আছে নেকি?';
  }

  @override
  String get allergiesSubtitle =>
      'এইটো কেতিয়াও বাদ নপৰে বুলি Gurtu এ প্ৰতিখন ডাক্তৰ ব্ৰিফত দেখুৱাব।';

  @override
  String get allergyNone => 'জনা কোনো এলাৰ্জী নাই';

  @override
  String get allergyPenicillin => 'পেনিচিলিন';

  @override
  String get allergySulfa => 'চালফা ঔষধ';

  @override
  String get allergyAspirin => 'এছপিৰিন / বিষৰ ঔষধ';

  @override
  String get allergyFood => 'খাদ্যত এলাৰ্জী';

  @override
  String get allergyDust => 'ধূলি / পৰাগ';

  @override
  String get allergyLatex => 'লেটেক্স';

  @override
  String get mobilityTitleSelf => 'প্ৰতিদিনে আপুনি কেনেকৈ অহা-যোৱা কৰে?';

  @override
  String mobilityTitleOther(String name) {
    return 'প্ৰতিদিনে $nameএ কেনেকৈ অহা-যোৱা কৰে?';
  }

  @override
  String get mobilitySubtitle =>
      'ইয়াৰ দ্বাৰা পৰিয়ালে দেখা-সাক্ষাৎ, পৰীক্ষা আৰু ঘৰত সহায়ৰ পৰিকল্পনা কৰিব পাৰে।';

  @override
  String get mobilityIndependent => 'নিজেই খোজ কাঢ়ে';

  @override
  String get mobilityIndependentHint => 'দৈনিক কামত সহায় নালাগে';

  @override
  String get mobilitySomeHelp => 'অলপ সহায় লাগে';

  @override
  String get mobilitySomeHelpHint => 'লাখুটি, ৱাকাৰ বা ধৰিবলৈ এখন হাত';

  @override
  String get mobilityFullHelp => 'বেছিভাগ সময় বিচনাত বা হুইলচেয়াৰত';

  @override
  String get mobilityFullHelpHint => 'বেছিভাগ কামত সহায় লাগে';

  @override
  String get hospitalTitleSelf =>
      'যোৱা 30 দিনত আপুনি হাস্পতাল বা ডাক্তৰৰ ওচৰলৈ গৈছিল নেকি?';

  @override
  String hospitalTitleOther(String name) {
    return 'যোৱা 30 দিনত $name হাস্পতাল বা ডাক্তৰৰ ওচৰলৈ গৈছিল নেকি?';
  }

  @override
  String get hospitalSubtitle =>
      'শেহতীয়া দেখুওৱাৰ লগত সাধাৰণতে নতুন নিৰ্দেশ আহে।';

  @override
  String get hospitalTip =>
      'ডিচচাৰ্জৰ কাগজ আৰু প্ৰেছক্ৰিপচন ওচৰত ৰাখক — ছেটআপৰ পিছতে স্কেন কৰিব পাৰিব।';

  @override
  String get permissionsTitle => 'আপোনাক সহায় কৰিবলৈ কেইটামান অনুমতি';

  @override
  String get permissionsSubtitle =>
      'Gurtu এ কেৱল দৰকাৰী বস্তুহে বিচাৰে। কিয়, সেয়া ইয়াত আছে।';

  @override
  String get permMic => 'মাইক্ৰ\'ফ\'ন';

  @override
  String get permMicWhy =>
      'ডাক্তৰ দেখুওৱা আৰু ভইচ ন\'ট ৰেকৰ্ড কৰিবলৈ — কেৱল আপুনি ৰেকৰ্ড টিপিলেহে।';

  @override
  String get permCamera => 'কেমেৰা';

  @override
  String get permCameraWhy =>
      'প্ৰেছক্ৰিপচন, ঔষধৰ পাত আৰু BP মেচিনৰ ৰিডিং স্কেন কৰিবলৈ।';

  @override
  String get permNotifications => 'জাননী';

  @override
  String get permNotificationsWhy =>
      'ঔষধৰ সোঁৱৰণী আৰু পৰিয়ালে কাম শেষ কৰিলে খবৰ।';

  @override
  String get permPhotos => 'ফটো আৰু ফাইল';

  @override
  String get permPhotosWhy => 'গেলেৰীত থকা ৰিপৰ্ট আৰু প্ৰেছক্ৰিপচন যোগ কৰক।';

  @override
  String get permContacts => 'যোগাযোগ';

  @override
  String get permContactsWhy => 'পৰিয়ালৰ সদস্যক সোনকালে কেয়াৰ চাৰ্কললৈ মাতক।';

  @override
  String get needed => 'দৰকাৰী';

  @override
  String get allow => 'অনুমতি দিয়ক';

  @override
  String get allowed => 'অনুমতি দিয়া হ\'ল';

  @override
  String get allowAndContinue => 'অনুমতি দি আগবাঢ়ক';

  @override
  String get privacyNote =>
      'সকলো এই ফ\'নতে থাকে। ৰেকৰ্ডিং নিজে নিজে কেতিয়াও আৰম্ভ নহয় — প্ৰথমে সদায় সন্মতিৰ স্ক্ৰীণ দেখুৱায়।';

  @override
  String permissionBlocked(String permission) {
    return '$permission বন্ধ আছে। ছেটিংছত অন কৰক।';
  }

  @override
  String get settings => 'ছেটিংছ';

  @override
  String permissionsMissing(String items) {
    return '$items অবিহনে কিছুমান সুবিধাই কাম নকৰিব। পিছত অনুমতি দিব পাৰিব।';
  }

  @override
  String get modelTitleChoose => 'Gurtuৰ অন-ডিভাইচ AI ছেট কৰক';

  @override
  String get modelTitleDownloading => 'আপোনাৰ AI ছেট হৈ আছে…';

  @override
  String get modelTitleDone => 'আপোনাৰ AI সাজু';

  @override
  String get modelSubtitleChoose =>
      'এই মডেলবোৰ সম্পূৰ্ণৰূপে আপোনাৰ iQOOত চলে। পৰিয়ালৰ স্বাস্থ্যৰ তথ্য ফ\'নৰ বাহিৰলৈ নাযায় — ইণ্টাৰনেট অবিহনেও কাম কৰে।';

  @override
  String get modelSubtitleDownloading =>
      'আপুনি ফ\'ন ব্যৱহাৰ কৰি থাকিব পাৰে। এইটো কেৱল এবাৰহে হয়।';

  @override
  String get modelSubtitleDone => 'সকলো এই ফ\'নতে চলে, অফলাইনতো।';

  @override
  String get poweredByIqoo => 'আপোনাৰ iQOOৰ দ্বাৰা চালিত';

  @override
  String get deviceCardSub => 'অন-ডিভাইচ AI · ব্যক্তিগত · অফলাইনত চলে';

  @override
  String get chooseCareModel => 'কেয়াৰ মডেল বাছক';

  @override
  String get careModelHint => 'প্ৰশ্নৰ উত্তৰ দিয়া মগজুটো এইটোৱেই।';

  @override
  String get alwaysIncluded => 'সদায় অন্তৰ্ভুক্ত';

  @override
  String get jobListens => 'শুনে';

  @override
  String get jobReads => 'পঢ়ে';

  @override
  String get jobSees => 'চায়';

  @override
  String get jobUnderstands => 'বুজে';

  @override
  String speechModelName(String language) {
    return 'কথা · $language + ইংৰাজী';
  }

  @override
  String get speechModelWhat => 'কথা-বতৰাক আপোনাৰ ভাষাত লিখনিলৈ সলনি কৰে।';

  @override
  String get readerModelName => 'নথি পঢ়োতা (OCR)';

  @override
  String get readerModelWhat =>
      'প্ৰেছক্ৰিপচন, ডিচচাৰ্জৰ কাগজ আৰু লেব ৰিপৰ্ট পঢ়ে।';

  @override
  String get visionModelName => 'ঔষধ আৰু ৰিডিং চিনাক্তকৰণ';

  @override
  String get visionModelWhat =>
      'ঔষধৰ পাত আৰু BP / চুগাৰ মেচিনৰ সংখ্যা চিনি পায়।';

  @override
  String careModelName(String model) {
    return 'কেয়াৰ মডেল · $model';
  }

  @override
  String get tierLite => 'লাইট';

  @override
  String get tierBalanced => 'সন্তুলিত';

  @override
  String get tierPro => 'প্ৰ\'';

  @override
  String get tierLiteNote => 'আটাইতকৈ দ্ৰুত। চমু, সহজ উত্তৰ।';

  @override
  String get tierBalancedNote => 'কথা, ফটো আৰু লিখনি একেলগে বুজে।';

  @override
  String get tierProNote => 'আটাইতকৈ বিতং উত্তৰ আৰু ডাক্তৰ ব্ৰিফ।';

  @override
  String get bestForIqoo => 'iQOOৰ বাবে শ্ৰেষ্ঠ';

  @override
  String get wifiOnly => 'কেৱল Wi-Fiত ডাউনলোড কৰক';

  @override
  String downloadSize(String size) {
    return 'ডাউনলোড · $size';
  }

  @override
  String get settingUp => 'ছেট হৈ আছে…';

  @override
  String get ready => 'সাজু';

  @override
  String allSetName(String name) {
    return 'সকলো সাজু, $name!';
  }

  @override
  String get allSet => 'সকলো সাজু!';

  @override
  String get readySelf => 'আপোনাৰ যত্নৰ স্মৃতি সাজু।';

  @override
  String readyOther(String name) {
    return '$nameৰ যত্নৰ স্মৃতি সাজু। এতিয়া পৰিয়ালক মাতক।';
  }

  @override
  String get rowYou => 'আপুনি';

  @override
  String get rowCaringFor => 'কাৰ যত্ন';

  @override
  String get rowHealth => 'স্বাস্থ্য';

  @override
  String get rowAllergies => 'এলাৰ্জী';

  @override
  String get rowLanguage => 'ভাষা';

  @override
  String get rowAi => 'অন-ডিভাইচ AI';

  @override
  String get notAdded => 'যোগ কৰা হোৱা নাই';

  @override
  String ageYears(int age) {
    return '$age বছৰ';
  }

  @override
  String get careQuote => '“একেলগে কৰিলে যত্ন পাতল লাগে।”';

  @override
  String get enterGurtu => 'Gurtu খোলক';

  @override
  String get nextUpCareCircle => 'পৰৱৰ্তী: কেয়াৰ চাৰ্কল';

  @override
  String get homeComingSoon => 'হোম স্ক্ৰীণ পৰৱৰ্তী অংশত আহি আছে।';

  @override
  String get restartOnboarding => 'অনব\'ৰ্ডিং পুনৰ আৰম্ভ কৰক';

  @override
  String get navHome => 'হোম';

  @override
  String get navMemory => 'স্মৃতি';

  @override
  String get navCircle => 'চাৰ্কল';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'প্ৰফাইল';

  @override
  String goodMorning(String name) {
    return 'সুপ্ৰভাত, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'নমস্কাৰ, $name';
  }

  @override
  String goodEvening(String name) {
    return 'শুভ সন্ধিয়া, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtuলৈ স্বাগতম, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'আপোনাৰ পৰিয়ালৰ স্বাস্থ্য, সকলোৱে মিলি মনত ৰাখক।';

  @override
  String get caringFor => 'যত্ন';

  @override
  String get switchPatientTitle => 'আপুনি কাৰ যত্ন লৈছে?';

  @override
  String get addAnotherPerson => 'আন এজনক যোগ কৰক';

  @override
  String get statusOnTrack => 'যত্ন ঠিকমতে চলি আছে';

  @override
  String get statusNeedsAttention => 'এটা কথালৈ মন দিব লাগিব';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'জৰুৰী';

  @override
  String get sosHoldTitle => 'কেয়াৰ চাৰ্কলক সতৰ্ক কৰিবলৈ টিপি ধৰি ৰাখক';

  @override
  String get sosHoldBody =>
      'বুটামটো 2 ছেকেণ্ড টিপি ধৰি ৰাখক। আপোনাৰ জৰুৰী যোগাযোগলৈ সতৰ্কবাণী যাব।';

  @override
  String get sosHoldButton => 'SOS পঠিয়াবলৈ টিপি ধৰি ৰাখক';

  @override
  String get sosKeepHolding => 'ধৰি ৰাখক…';

  @override
  String get sosPreviewNote =>
      'জৰুৰী সতৰ্কবাণী এতিয়াও সংযোগ হোৱা নাই। এইটো কেৱল প্ৰিভিউ — কাৰো ওচৰলৈ সতৰ্কবাণী নাযায়।';

  @override
  String get sosPreviewDone =>
      'প্ৰিভিউ শেষ হ\'ল। কাৰো ওচৰলৈ সতৰ্কবাণী যোৱা নাই।';

  @override
  String get close => 'বন্ধ কৰক';

  @override
  String get todayCare => 'আজিৰ যত্ন';

  @override
  String completedOf(int done, int total) {
    return '$totalৰ ভিতৰত $done হ\'ল';
  }

  @override
  String get viewTodayCare => 'আজিৰ যত্ন চাওক';

  @override
  String get nothingUrgent => 'এতিয়া জৰুৰী একো নাই।';

  @override
  String get markDone => 'হ\'ল বুলি চিহ্নিত কৰক';

  @override
  String get markNotDone => 'হোৱা নাই বুলি চিহ্নিত কৰক';

  @override
  String get openToCircle => 'কেয়াৰ চাৰ্কলৰ বাবে মুকলি';

  @override
  String get captureCare => 'যত্ন লিপিবদ্ধ কৰক';

  @override
  String get captureCareSubtitle => 'যত্নৰ কোনো দৰকাৰী কথা লিপিবদ্ধ কৰক।';

  @override
  String get whatHappened => 'কি হ\'ল?';

  @override
  String get captureVoice => 'ভইচ';

  @override
  String get captureVoiceHint => 'কথা-বতৰা বা ভইচ ন\'ট ৰেকৰ্ড কৰক';

  @override
  String get captureScan => 'স্কেন';

  @override
  String get captureScanHint => 'প্ৰেছক্ৰিপচন বা ঔষধৰ পাত';

  @override
  String get captureVital => 'ৰিডিং';

  @override
  String get captureVitalHint => 'BP, চুগাৰ বা জ্বৰ';

  @override
  String get captureDocument => 'নথি';

  @override
  String get captureDocumentHint => 'ডিচচাৰ্জৰ কাগজ বা লেব ৰিপৰ্ট';

  @override
  String get captureNote => 'ন\'ট';

  @override
  String get captureNoteHint => 'কি হ\'ল লিখক';

  @override
  String get comingSoon => 'সোনকালে আহিব';

  @override
  String get noteHint => 'যেনে খোজ কঢ়াৰ পিছত মূৰ ঘূৰাইছিল';

  @override
  String get saveNote => 'ন\'ট ছেভ কৰক';

  @override
  String get noteSaved => 'যত্নৰ স্মৃতিত ছেভ হ\'ল';

  @override
  String get recentMemory => 'শেহতীয়া স্মৃতি';

  @override
  String get viewAll => 'সকলো চাওক';

  @override
  String get emptyMemory => 'আপোনাৰ যত্নৰ কাহিনী ইয়াৰ পৰা আৰম্ভ।';

  @override
  String addedBy(String name) {
    return '$nameএ যোগ কৰিছে';
  }

  @override
  String get sourcePlay => 'শুনক';

  @override
  String get sourceView => 'চাওক';

  @override
  String get sourceOpen => 'খোলক';

  @override
  String get sourceTitle => 'উৎস';

  @override
  String get sourceRecording => 'ডাক্তৰৰ ৰেকৰ্ডিং';

  @override
  String get sourceScan => 'প্ৰেছক্ৰিপচন স্কেন';

  @override
  String get sourceVital => 'ৰিডিং';

  @override
  String get sourceDocument => 'নথি';

  @override
  String get sourceNote => 'লিখা ন\'ট';

  @override
  String get sourceSampleNote =>
      'এইটো নমুনা ডাটা, সেয়ে মূল ফাইল নাই। প্ৰকৃত ৰেকৰ্ডিং আৰু স্কেন ইয়াত খুলিব।';

  @override
  String get yourCareCircle => 'আপোনাৰ কেয়াৰ চাৰ্কল';

  @override
  String get manageCircle => 'চাৰ্কল পৰিচালনা';

  @override
  String get emptyCircle => 'একেলগে কৰিলে যত্ন সহজ হয়।';

  @override
  String get addFamilyMember => 'পৰিয়ালৰ সদস্য যোগ কৰক';

  @override
  String get rolePatient => 'ৰোগী';

  @override
  String get roleCaregiver => 'যত্নকাৰী';

  @override
  String get roleFamily => 'পৰিয়াল';

  @override
  String get roleHelper => 'বিশ্বাসী সহায়ক';

  @override
  String get askGurtuTitle => 'Gurtuক সোধক';

  @override
  String get askGurtuPrompt => 'কিবা মনত ৰাখিবলৈ সহায় লাগে নেকি?';

  @override
  String get askExampleBloodTest => 'তেজ পৰীক্ষা কেতিয়া?';

  @override
  String get askExampleDoctor => 'কাইলৈ ডাক্তৰক কি সুধিম?';

  @override
  String get askGurtuNote => 'উত্তৰ আপুনি ছেভ কৰা যত্নৰ তথ্যৰ পৰাহে আহে।';

  @override
  String get gettingReady => 'Gurtu সাজু হৈ আছে';

  @override
  String get readyYourProfile => 'আপোনাৰ প্ৰফাইল';

  @override
  String get readyPatientProfile => 'ৰোগীৰ প্ৰফাইল';

  @override
  String get readyCareCircle => 'কেয়াৰ চাৰ্কল';

  @override
  String get readyEmergencyContact => 'জৰুৰী যোগাযোগ';

  @override
  String get previewSampleData => 'নমুনা ডাটাৰে চাওক';

  @override
  String get sampleDataOn => 'নমুনা যত্ন ডাটা দেখুওৱা হৈছে';

  @override
  String get remove => 'আঁতৰাওক';

  @override
  String get hide => 'লুকুৱাওক';

  @override
  String get comingNextPhase => 'এই অংশটো পিছত তৈয়াৰ হৈ আছে।';

  @override
  String get fatherName => 'দেউতা';

  @override
  String get sampleTaskMorningMedicine => 'ৰাতিপুৱাৰ ঔষধ';

  @override
  String get sampleTaskRecordBp => 'BP লিখক';

  @override
  String get sampleTaskBloodTest => 'তেজ পৰীক্ষা';

  @override
  String get sampleTaskDoctorVisit => 'ডাক্তৰৰ এপইণ্টমেণ্ট';

  @override
  String get sampleMomentDoctorTalk => 'ডাক্তৰৰ সৈতে কথা-বতৰা';

  @override
  String get sampleMomentDoctorTalkDetail => '“ৰাতিপুৱাৰ আহাৰৰ পিছত ঔষধ খাব।”';

  @override
  String get sampleMomentPrescription => 'প্ৰেছক্ৰিপচন স্কেন কৰা হ\'ল';

  @override
  String get sampleMomentPrescriptionDetail => '2টা ঔষধ পোৱা গ\'ল';

  @override
  String get sampleMomentBp => 'BP লিখা হ\'ল';

  @override
  String get today => 'আজি';

  @override
  String get yesterday => 'কালি';
}
