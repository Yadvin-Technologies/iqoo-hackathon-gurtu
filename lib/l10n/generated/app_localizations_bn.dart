// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get continueLabel => 'এগিয়ে যান';

  @override
  String get next => 'পরবর্তী';

  @override
  String get skip => 'বাদ দিন';

  @override
  String get later => 'পরে';

  @override
  String get back => 'পিছনে';

  @override
  String get optional => 'ঐচ্ছিক';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get notSure => 'জানি না';

  @override
  String get tagline => 'মনে রাখুন। যত্ন নিন। একসাথে।';

  @override
  String get motherName => 'মা';

  @override
  String get phaseAbout => 'পরিচয়';

  @override
  String get phaseHealth => 'স্বাস্থ্য';

  @override
  String get phasePermissions => 'অনুমতি';

  @override
  String get phaseAi => 'AI সেটআপ';

  @override
  String phaseStep(String phase, int current, int total) {
    return '$phase · $total-এর মধ্যে $current';
  }

  @override
  String get languageTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get languageSubtitle => 'Gurtu এই ভাষাতেই কথা বলবে, শুনবে আর লিখবে।';

  @override
  String get languageMixNote =>
      'ডাক্তাররা প্রায়ই আপনার ভাষার সাথে ইংরেজি মিশিয়ে কথা বলেন। Gurtu দুটোই একসাথে বোঝে।';

  @override
  String get welcomeTitle => 'আপনার পরিবারের\nযত্নের স্মৃতি';

  @override
  String get welcomeBody =>
      'ডাক্তার কী বললেন, কোন ওষুধ লিখলেন আর বাড়িতে কী ঘটল — সব একসাথে মনে রাখুন।';

  @override
  String get welcomeScript => 'আলাদা ভূমিকা। একই ভালোবাসা।';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String builtForBrand(String brand) {
    return '$brand-এর জন্য তৈরি';
  }

  @override
  String get madeInHyderabad => 'হায়দ্রাবাদে তৈরি';

  @override
  String get introRecordEyebrow => '1 · রেকর্ড';

  @override
  String get introRecordTitle => 'ডাক্তারের কথা কখনও ভুলবেন না';

  @override
  String get introRecordBody =>
      'সবার সম্মতিতে ডাক্তার, নার্স বা ফার্মাসিস্টের কথা রেকর্ড করুন। জরুরি কথাগুলো Gurtu রেখে দেয়।';

  @override
  String get introPlanEyebrow => '2 · বুঝুন ও ভাগ করুন';

  @override
  String get introPlanTitle => 'গোটা পরিবারের জন্য একটি যত্ন পরিকল্পনা';

  @override
  String get introPlanBody =>
      'প্রেসক্রিপশন আর রিপোর্ট স্ক্যান করুন। Gurtu সেগুলোকে সহজ কাজে বদলে দেয় যা পরিবার ভাগ করে নিতে পারে।';

  @override
  String get introAskEyebrow => '3 · জিজ্ঞাসা করুন ও মনে রাখুন';

  @override
  String get introAskTitle => 'যা খুশি জিজ্ঞাসা করুন, প্রমাণ দেখুন';

  @override
  String get introAskBody =>
      'প্রতিটি উত্তর দেখায় সেটা কোথা থেকে এসেছে — রেকর্ডিং, প্রেসক্রিপশন বা ছবি।';

  @override
  String get letsSetUp => 'সেটআপ করি';

  @override
  String get hospitalMode => 'হাসপাতাল মোড';

  @override
  String get consentRecording => 'উপস্থিত সবার সম্মতিতে রেকর্ডিং';

  @override
  String get doctorConversation => 'ডাক্তারের সাথে কথা';

  @override
  String get nurseInstructions => 'নার্সের নির্দেশ';

  @override
  String get pharmacistAdvice => 'ফার্মাসিস্টের পরামর্শ';

  @override
  String get yourCarePlan => 'আপনার যত্ন পরিকল্পনা';

  @override
  String get afterBreakfast => 'জলখাবারের পরে';

  @override
  String get checkBloodPressure => 'BP মাপুন';

  @override
  String get twiceDaily => 'দিনে দু\'বার';

  @override
  String get bloodTest => 'রক্ত পরীক্ষা (CBC)';

  @override
  String get instructionsFound =>
      'আপনার রেকর্ডিং আর প্রেসক্রিপশনে 4টি নির্দেশ পাওয়া গেছে';

  @override
  String get askQuestion => 'সন্ধ্যার ওষুধ নিয়ে ডাক্তার কী বলেছিলেন?';

  @override
  String get askAnswer => 'ডাক্তার Amlodipine রাতের খাবারের পরে খেতে বলেছেন।';

  @override
  String get sourceDoctorVisit => 'সূত্র: ডাক্তারের কাছে যাওয়া';

  @override
  String get careForTitle => 'আপনি কার জন্য Gurtu সেট করছেন?';

  @override
  String get careForSubtitle =>
      'Gurtu একজন মানুষকে ঘিরে যত্নের স্মৃতি তৈরি করে। বাকি পরিবারকে পরে আমন্ত্রণ জানাতে পারবেন।';

  @override
  String get careForMyself => 'নিজের জন্য';

  @override
  String get careForMyselfHint => 'নিজের যত্নের খেয়াল রাখতে চাই';

  @override
  String get careForParent => 'আমার বাবা-মা';

  @override
  String get careForParentHint => 'মা, বাবা বা পরিবারের কোনও বয়স্ক মানুষ';

  @override
  String get careForPartner => 'আমার জীবনসঙ্গী';

  @override
  String get careForPartnerHint => 'স্বামী, স্ত্রী বা সঙ্গী';

  @override
  String get careForChild => 'আমার সন্তান';

  @override
  String get careForChildHint => 'ছেলে বা মেয়ে';

  @override
  String get careForOther => 'অন্য কেউ';

  @override
  String get careForOtherHint => 'আত্মীয়, বন্ধু বা প্রতিবেশী';

  @override
  String get profileTitleSelf => 'আপনার সম্পর্কে বলুন';

  @override
  String get profileTitleOther => 'ওঁর সম্পর্কে বলুন';

  @override
  String get profileSubtitleSelf => 'এতে Gurtu আপনাকে নাম ধরে ডাকবে।';

  @override
  String get profileSubtitleOther => 'বাড়িতে যে নামে ডাকেন সেটাই লিখুন।';

  @override
  String get yourName => 'আপনার নাম';

  @override
  String get whatDoYouCallThem => 'আপনি ওঁকে কী বলে ডাকেন?';

  @override
  String exampleName(String name) {
    return 'যেমন $name';
  }

  @override
  String get sampleSelfName => 'সুমিতা';

  @override
  String get sampleYourName => 'প্রিয়া';

  @override
  String get yourAge => 'আপনার বয়স';

  @override
  String get theirAge => 'ওঁর বয়স';

  @override
  String get years => 'বছর';

  @override
  String get decreaseAge => 'বয়স কমান';

  @override
  String get increaseAge => 'বয়স বাড়ান';

  @override
  String get gender => 'লিঙ্গ';

  @override
  String get female => 'মহিলা';

  @override
  String get male => 'পুরুষ';

  @override
  String get genderOther => 'অন্যান্য';

  @override
  String get andYou => 'আর আপনি?';

  @override
  String get andYouBody => 'আপনিই হবেন ওঁর কেয়ার সার্কেলের প্রথম সদস্য।';

  @override
  String get conditionsTitleSelf => 'আপনার কি এগুলোর মধ্যে কোনও অসুখ আছে?';

  @override
  String conditionsTitleOther(String name) {
    return '$name-এর কি এগুলোর মধ্যে কোনও অসুখ আছে?';
  }

  @override
  String get conditionsSubtitle =>
      'যা যা প্রযোজ্য সব বেছে নিন। এতে Gurtu যত্ন পরিকল্পনা সাজায়।';

  @override
  String get condDiabetes => 'সুগার (ডায়াবেটিস)';

  @override
  String get condHighBp => 'হাই BP';

  @override
  String get condHeart => 'হার্টের সমস্যা';

  @override
  String get condThyroid => 'থাইরয়েড';

  @override
  String get condCholesterol => 'কোলেস্টেরল';

  @override
  String get condAsthma => 'হাঁপানি / শ্বাসকষ্ট';

  @override
  String get condKidney => 'কিডনির সমস্যা';

  @override
  String get condArthritis => 'গাঁটে ব্যথা / আর্থ্রাইটিস';

  @override
  String get condStroke => 'আগে স্ট্রোক হয়েছিল';

  @override
  String get condCancer => 'ক্যান্সারের চিকিৎসা';

  @override
  String get noneOfThese => 'এগুলোর কোনওটাই নয়';

  @override
  String get notADoctor =>
      'Gurtu ডাক্তার নয়। এটা কখনও রোগ নির্ণয় করে না — শুধু পরিবারকে যত্ন মনে রাখতে আর গুছিয়ে রাখতে সাহায্য করে।';

  @override
  String get medicinesTitleSelf => 'আপনি কি রোজ ওষুধ খান?';

  @override
  String medicinesTitleOther(String name) {
    return '$name কি রোজ ওষুধ খান?';
  }

  @override
  String get medicinesSubtitle =>
      'ট্যাবলেট, সিরাপ, ইনহেলার বা ইনসুলিন — সব ধরুন।';

  @override
  String get howMany => 'মোটামুটি কয়টা?';

  @override
  String get sixOrMore => '6 বা তার বেশি';

  @override
  String get scanLaterTip =>
      'পরে শুধু প্রেসক্রিপশন বা ওষুধের পাতা স্ক্যান করুন — টাইপ করতে হবে না।';

  @override
  String get allergiesTitleSelf => 'আপনার কি কিছুতে অ্যালার্জি আছে?';

  @override
  String allergiesTitleOther(String name) {
    return '$name-এর কি কিছুতে অ্যালার্জি আছে?';
  }

  @override
  String get allergiesSubtitle =>
      'যাতে কখনও বাদ না পড়ে, Gurtu এটা প্রতিটি ডাক্তার ব্রিফে দেখাবে।';

  @override
  String get allergyNone => 'জানা কোনও অ্যালার্জি নেই';

  @override
  String get allergyPenicillin => 'পেনিসিলিন';

  @override
  String get allergySulfa => 'সালফা ওষুধ';

  @override
  String get allergyAspirin => 'অ্যাসপিরিন / ব্যথার ওষুধ';

  @override
  String get allergyFood => 'খাবারে অ্যালার্জি';

  @override
  String get allergyDust => 'ধুলো / পরাগ';

  @override
  String get allergyLatex => 'ল্যাটেক্স';

  @override
  String get mobilityTitleSelf => 'রোজ আপনি কীভাবে চলাফেরা করেন?';

  @override
  String mobilityTitleOther(String name) {
    return 'রোজ $name কীভাবে চলাফেরা করেন?';
  }

  @override
  String get mobilitySubtitle =>
      'এতে পরিবার দেখা করা, পরীক্ষা আর বাড়িতে সাহায্যের পরিকল্পনা করতে পারে।';

  @override
  String get mobilityIndependent => 'নিজেই হাঁটেন';

  @override
  String get mobilityIndependentHint => 'রোজকার কাজে সাহায্য লাগে না';

  @override
  String get mobilitySomeHelp => 'একটু সাহায্য লাগে';

  @override
  String get mobilitySomeHelpHint => 'লাঠি, ওয়াকার বা ধরার জন্য একটা হাত';

  @override
  String get mobilityFullHelp => 'বেশিরভাগ সময় বিছানায় বা হুইলচেয়ারে';

  @override
  String get mobilityFullHelpHint => 'বেশিরভাগ কাজে সাহায্য লাগে';

  @override
  String get hospitalTitleSelf =>
      'গত 30 দিনে আপনি কি হাসপাতাল বা ডাক্তারের কাছে গিয়েছিলেন?';

  @override
  String hospitalTitleOther(String name) {
    return 'গত 30 দিনে $name কি হাসপাতাল বা ডাক্তারের কাছে গিয়েছিলেন?';
  }

  @override
  String get hospitalSubtitle =>
      'সাম্প্রতিক দেখানোর সাথে সাধারণত নতুন নির্দেশ আসে।';

  @override
  String get hospitalTip =>
      'ডিসচার্জের কাগজ আর প্রেসক্রিপশন হাতের কাছে রাখুন — সেটআপের পরেই স্ক্যান করতে পারবেন।';

  @override
  String get permissionsTitle => 'আপনাকে সাহায্য করতে কয়েকটি অনুমতি';

  @override
  String get permissionsSubtitle =>
      'Gurtu শুধু দরকারি জিনিসই চায়। কেন, তা এখানে দেওয়া আছে।';

  @override
  String get permMic => 'মাইক্রোফোন';

  @override
  String get permMicWhy =>
      'ডাক্তার দেখানো আর ভয়েস নোট রেকর্ড করতে — শুধু আপনি রেকর্ড টিপলে।';

  @override
  String get permCamera => 'ক্যামেরা';

  @override
  String get permCameraWhy =>
      'প্রেসক্রিপশন, ওষুধের পাতা আর BP মেশিনের রিডিং স্ক্যান করতে।';

  @override
  String get permNotifications => 'নোটিফিকেশন';

  @override
  String get permNotificationsWhy =>
      'ওষুধের রিমাইন্ডার আর পরিবার কাজ শেষ করলে খবর।';

  @override
  String get permPhotos => 'ছবি ও ফাইল';

  @override
  String get permPhotosWhy =>
      'গ্যালারিতে থাকা রিপোর্ট আর প্রেসক্রিপশন যোগ করতে।';

  @override
  String get permContacts => 'কন্টাক্ট';

  @override
  String get permContactsWhy =>
      'পরিবারের সদস্যদের তাড়াতাড়ি কেয়ার সার্কেলে ডাকতে।';

  @override
  String get needed => 'দরকারি';

  @override
  String get allow => 'অনুমতি দিন';

  @override
  String get allowed => 'অনুমতি দেওয়া হয়েছে';

  @override
  String get allowAndContinue => 'অনুমতি দিয়ে এগিয়ে যান';

  @override
  String get privacyNote =>
      'সবকিছু এই ফোনেই থাকে। রেকর্ডিং নিজে থেকে কখনও শুরু হয় না — আগে সবসময় সম্মতির স্ক্রিন দেখায়।';

  @override
  String permissionBlocked(String permission) {
    return '$permission বন্ধ আছে। সেটিংসে চালু করুন।';
  }

  @override
  String get settings => 'সেটিংস';

  @override
  String permissionsMissing(String items) {
    return '$items ছাড়া কিছু সুবিধা কাজ করবে না। পরে অনুমতি দিতে পারবেন।';
  }

  @override
  String get modelTitleChoose => 'Gurtu-র অন-ডিভাইস AI সেট করুন';

  @override
  String get modelTitleDownloading => 'আপনার AI সেট হচ্ছে…';

  @override
  String get modelTitleDone => 'আপনার AI তৈরি';

  @override
  String get modelSubtitleChoose =>
      'এই মডেলগুলো পুরোপুরি আপনার iQOO-তেই চলে। পরিবারের স্বাস্থ্যের তথ্য ফোনের বাইরে যায় না — আর ইন্টারনেট ছাড়াও কাজ করে।';

  @override
  String get modelSubtitleDownloading =>
      'আপনি ফোন ব্যবহার করতে থাকুন। এটা শুধু একবারই হয়।';

  @override
  String get modelSubtitleDone => 'সবকিছু এই ফোনেই চলে, অফলাইনেও।';

  @override
  String get poweredByIqoo => 'আপনার iQOO-র শক্তিতে চলে';

  @override
  String get deviceCardSub => 'অন-ডিভাইস AI · ব্যক্তিগত · অফলাইনে চলে';

  @override
  String get chooseCareModel => 'কেয়ার মডেল বেছে নিন';

  @override
  String get careModelHint => 'প্রশ্নের উত্তর দেওয়ার মস্তিষ্ক এটাই।';

  @override
  String get alwaysIncluded => 'সবসময় থাকে';

  @override
  String get jobListens => 'শোনে';

  @override
  String get jobReads => 'পড়ে';

  @override
  String get jobSees => 'দেখে';

  @override
  String get jobUnderstands => 'বোঝে';

  @override
  String speechModelName(String language) {
    return 'কথা · $language + ইংরেজি';
  }

  @override
  String get speechModelWhat => 'কথাবার্তাকে আপনার ভাষায় লেখায় বদলে দেয়।';

  @override
  String get readerModelName => 'ডকুমেন্ট রিডার (OCR)';

  @override
  String get readerModelWhat =>
      'প্রেসক্রিপশন, ডিসচার্জের কাগজ আর ল্যাব রিপোর্ট পড়ে।';

  @override
  String get visionModelName => 'ওষুধ ও রিডিং চেনা';

  @override
  String get visionModelWhat =>
      'ওষুধের পাতা আর BP / সুগার মেশিনের সংখ্যা চেনে।';

  @override
  String careModelName(String model) {
    return 'কেয়ার মডেল · $model';
  }

  @override
  String get tierLite => 'লাইট';

  @override
  String get tierBalanced => 'ব্যালান্সড';

  @override
  String get tierPro => 'প্রো';

  @override
  String get tierLiteNote => 'সবচেয়ে দ্রুত। ছোট, সহজ উত্তর।';

  @override
  String get tierBalancedNote => 'কথা, ছবি আর লেখা একসাথে বোঝে।';

  @override
  String get tierProNote => 'সবচেয়ে বিস্তারিত উত্তর আর ডাক্তার ব্রিফ।';

  @override
  String get bestForIqoo => 'iQOO-র জন্য সেরা';

  @override
  String get wifiOnly => 'শুধু Wi-Fi-তে ডাউনলোড করুন';

  @override
  String downloadSize(String size) {
    return 'ডাউনলোড · $size';
  }

  @override
  String get settingUp => 'সেট হচ্ছে…';

  @override
  String get ready => 'তৈরি';

  @override
  String allSetName(String name) {
    return 'সব তৈরি, $name!';
  }

  @override
  String get allSet => 'সব তৈরি!';

  @override
  String get readySelf => 'আপনার যত্নের স্মৃতি তৈরি।';

  @override
  String readyOther(String name) {
    return '$name-এর যত্নের স্মৃতি তৈরি। এবার পরিবারকে ডাকুন।';
  }

  @override
  String get rowYou => 'আপনি';

  @override
  String get rowCaringFor => 'কার যত্ন';

  @override
  String get rowHealth => 'স্বাস্থ্য';

  @override
  String get rowAllergies => 'অ্যালার্জি';

  @override
  String get rowLanguage => 'ভাষা';

  @override
  String get rowAi => 'অন-ডিভাইস AI';

  @override
  String get notAdded => 'যোগ করা হয়নি';

  @override
  String ageYears(int age) {
    return '$age বছর';
  }

  @override
  String get careQuote => '“একসাথে করলে যত্ন হালকা লাগে।”';

  @override
  String get enterGurtu => 'Gurtu খুলুন';

  @override
  String get nextUpCareCircle => 'এরপর: কেয়ার সার্কেল';

  @override
  String get homeComingSoon => 'হোম স্ক্রিন পরের পর্বে আসছে।';

  @override
  String get restartOnboarding => 'অনবোর্ডিং আবার শুরু করুন';

  @override
  String get navHome => 'হোম';

  @override
  String get navMemory => 'স্মৃতি';

  @override
  String get navCircle => 'সার্কেল';

  @override
  String get navAi => 'AI';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String goodMorning(String name) {
    return 'সুপ্রভাত, $name';
  }

  @override
  String goodAfternoon(String name) {
    return 'শুভ দুপুর, $name';
  }

  @override
  String goodEvening(String name) {
    return 'শুভ সন্ধ্যা, $name';
  }

  @override
  String welcomeName(String name) {
    return 'Gurtu-তে স্বাগত, $name';
  }

  @override
  String get welcomeHomeSubtitle =>
      'আপনার পরিবারের স্বাস্থ্য, সবাই মিলে মনে রাখুন।';

  @override
  String get caringFor => 'যত্ন';

  @override
  String get switchPatientTitle => 'আপনি কার যত্ন নিচ্ছেন?';

  @override
  String get addAnotherPerson => 'আরেকজনকে যোগ করুন';

  @override
  String get statusOnTrack => 'যত্ন ঠিকঠাক চলছে';

  @override
  String get statusNeedsAttention => 'একটা বিষয়ে নজর দিতে হবে';

  @override
  String get sosLabel => 'SOS';

  @override
  String get sosHint => 'জরুরি';

  @override
  String get sosHoldTitle => 'কেয়ার সার্কেলকে সতর্ক করতে চেপে ধরুন';

  @override
  String get sosHoldBody =>
      'বোতামটি 2 সেকেন্ড চেপে ধরুন। আপনার জরুরি কন্টাক্টদের কাছে সতর্কবার্তা যাবে।';

  @override
  String get sosHoldButton => 'SOS পাঠাতে চেপে ধরুন';

  @override
  String get sosKeepHolding => 'ধরে রাখুন…';

  @override
  String get sosPreviewNote =>
      'জরুরি সতর্কবার্তা এখনও যুক্ত হয়নি। এটা শুধু প্রিভিউ — কারও কাছে সতর্কবার্তা যাবে না।';

  @override
  String get sosPreviewDone => 'প্রিভিউ শেষ। কারও কাছে সতর্কবার্তা যায়নি।';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get todayCare => 'আজকের যত্ন';

  @override
  String completedOf(int done, int total) {
    return '$total-এর মধ্যে $doneটি হয়েছে';
  }

  @override
  String get viewTodayCare => 'আজকের যত্ন দেখুন';

  @override
  String get nothingUrgent => 'এখন জরুরি কিছু নেই।';

  @override
  String get markDone => 'হয়ে গেছে চিহ্নিত করুন';

  @override
  String get markNotDone => 'হয়নি চিহ্নিত করুন';

  @override
  String get openToCircle => 'কেয়ার সার্কেলের জন্য খোলা';

  @override
  String get captureCare => 'যত্ন লিখে রাখুন';

  @override
  String get captureCareSubtitle => 'যত্নের জরুরি কোনও কথা লিখে রাখুন।';

  @override
  String get whatHappened => 'কী হয়েছে?';

  @override
  String get captureVoice => 'ভয়েস';

  @override
  String get captureVoiceHint => 'কথাবার্তা বা ভয়েস নোট রেকর্ড করুন';

  @override
  String get captureScan => 'স্ক্যান';

  @override
  String get captureScanHint => 'প্রেসক্রিপশন বা ওষুধের পাতা';

  @override
  String get captureVital => 'রিডিং';

  @override
  String get captureVitalHint => 'BP, সুগার বা তাপমাত্রা';

  @override
  String get captureDocument => 'ডকুমেন্ট';

  @override
  String get captureDocumentHint => 'ডিসচার্জ পেপার বা ল্যাব রিপোর্ট';

  @override
  String get captureNote => 'নোট';

  @override
  String get captureNoteHint => 'কী হয়েছে লিখুন';

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get noteHint => 'যেমন হাঁটার পর মাথা ঘুরেছিল';

  @override
  String get saveNote => 'নোট সেভ করুন';

  @override
  String get noteSaved => 'যত্নের স্মৃতিতে সেভ হয়েছে';

  @override
  String get recentMemory => 'সাম্প্রতিক স্মৃতি';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get emptyMemory => 'আপনার যত্নের গল্প এখান থেকে শুরু।';

  @override
  String addedBy(String name) {
    return '$name যোগ করেছেন';
  }

  @override
  String get sourcePlay => 'শুনুন';

  @override
  String get sourceView => 'দেখুন';

  @override
  String get sourceOpen => 'খুলুন';

  @override
  String get sourceTitle => 'সূত্র';

  @override
  String get sourceRecording => 'ডাক্তারের রেকর্ডিং';

  @override
  String get sourceScan => 'প্রেসক্রিপশন স্ক্যান';

  @override
  String get sourceVital => 'রিডিং';

  @override
  String get sourceDocument => 'ডকুমেন্ট';

  @override
  String get sourceNote => 'লেখা নোট';

  @override
  String get sourceSampleNote =>
      'এটা নমুনা ডেটা, তাই আসল ফাইল নেই। আসল রেকর্ডিং আর স্ক্যান এখানে খুলবে।';

  @override
  String get yourCareCircle => 'আপনার কেয়ার সার্কেল';

  @override
  String get manageCircle => 'সার্কেল সামলান';

  @override
  String get emptyCircle => 'একসাথে করলে যত্ন সহজ হয়।';

  @override
  String get addFamilyMember => 'পরিবারের সদস্য যোগ করুন';

  @override
  String get rolePatient => 'রোগী';

  @override
  String get roleCaregiver => 'যত্নকারী';

  @override
  String get roleFamily => 'পরিবার';

  @override
  String get roleHelper => 'বিশ্বস্ত সহায়ক';

  @override
  String get askGurtuTitle => 'Gurtu-কে জিজ্ঞাসা করুন';

  @override
  String get askGurtuPrompt => 'কিছু মনে রাখতে সাহায্য লাগবে?';

  @override
  String get askExampleBloodTest => 'রক্ত পরীক্ষা কবে?';

  @override
  String get askExampleDoctor => 'কাল ডাক্তারকে কী জিজ্ঞাসা করব?';

  @override
  String get askGurtuNote => 'উত্তর আসে আপনার সেভ করা যত্নের তথ্য থেকে।';

  @override
  String get gettingReady => 'Gurtu তৈরি হচ্ছে';

  @override
  String get readyYourProfile => 'আপনার প্রোফাইল';

  @override
  String get readyPatientProfile => 'রোগীর প্রোফাইল';

  @override
  String get readyCareCircle => 'কেয়ার সার্কেল';

  @override
  String get readyEmergencyContact => 'জরুরি কন্টাক্ট';

  @override
  String get previewSampleData => 'নমুনা ডেটা দিয়ে দেখুন';

  @override
  String get sampleDataOn => 'নমুনা যত্নের ডেটা দেখানো হচ্ছে';

  @override
  String get remove => 'সরান';

  @override
  String get hide => 'লুকান';

  @override
  String get comingNextPhase => 'এই অংশটি এরপর তৈরি হচ্ছে।';

  @override
  String get fatherName => 'বাবা';

  @override
  String get sampleTaskMorningMedicine => 'সকালের ওষুধ';

  @override
  String get sampleTaskRecordBp => 'BP লিখুন';

  @override
  String get sampleTaskBloodTest => 'রক্ত পরীক্ষা';

  @override
  String get sampleTaskDoctorVisit => 'ডাক্তারের অ্যাপয়েন্টমেন্ট';

  @override
  String get sampleMomentDoctorTalk => 'ডাক্তারের সাথে কথা';

  @override
  String get sampleMomentDoctorTalkDetail => '“জলখাবারের পরে ওষুধ খাবেন।”';

  @override
  String get sampleMomentPrescription => 'প্রেসক্রিপশন স্ক্যান করা হয়েছে';

  @override
  String get sampleMomentPrescriptionDetail => '2টি ওষুধ পাওয়া গেছে';

  @override
  String get sampleMomentBp => 'BP লেখা হয়েছে';

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get doctorVisit => 'ডাক্তার দেখানো';

  @override
  String get doctorVisitHint => 'ডাক্তার যা বলেন লিখে রাখুন';

  @override
  String get askDoctor => 'ডাক্তারকে জিজ্ঞাসার প্রশ্ন';

  @override
  String get askDoctorHint => 'Gurtu প্রস্তুতিতে সাহায্য করবে';

  @override
  String questionsReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি প্রশ্ন তৈরি',
      one: '1টি প্রশ্ন তৈরি',
    );
    return '$_temp0';
  }

  @override
  String lastVisitOn(String date) {
    return 'শেষ ভিজিট: $date';
  }

  @override
  String nextVisitOn(String date) {
    return 'পরের ভিজিট: $date';
  }

  @override
  String get visitsTitle => 'ডাক্তার ভিজিট';

  @override
  String get visitsSubtitle => 'প্রত্যেক ডাক্তার যা বলেছেন, সব এক জায়গায়।';

  @override
  String get recordVisit => 'ভিজিট রেকর্ড করুন';

  @override
  String get visitsOverview => 'সব ভিজিট এক নজরে';

  @override
  String visitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ভিজিট',
      one: '1টি ভিজিট',
    );
    return '$_temp0';
  }

  @override
  String doctorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count জন ডাক্তার',
      one: '1 জন ডাক্তার',
    );
    return '$_temp0';
  }

  @override
  String get lastVisit => 'শেষ ভিজিট';

  @override
  String get nextVisit => 'পরের ভিজিট';

  @override
  String get notPlanned => 'এখনও ঠিক হয়নি';

  @override
  String get pastVisits => 'আগের ভিজিট';

  @override
  String get noVisitsTitle => 'এখনও কোনো ভিজিট রেকর্ড হয়নি';

  @override
  String get noVisitsBody =>
      'পরের অ্যাপয়েন্টমেন্টে ‘ভিজিট রেকর্ড করুন’ চাপুন, ডাক্তার যা বলবেন Gurtu লিখে রাখবে।';

  @override
  String get questionsForNextVisit => 'পরের ভিজিটের প্রশ্ন';

  @override
  String get prepareQuestionsHint =>
      'আপনি কেমন বোধ করছেন Gurtu-কে বলুন। ডাক্তারকে কী জিজ্ঞাসা করবেন তা বলে দেবে।';

  @override
  String get prepareQuestions => 'প্রশ্ন তৈরি করুন';

  @override
  String get viewQuestions => 'প্রশ্ন দেখুন';

  @override
  String get doctorFallback => 'ডাক্তার';

  @override
  String get doctorSaid => 'ডাক্তার কী বললেন';

  @override
  String get medicinesSection => 'ওষুধ';

  @override
  String get testsSection => 'যে পরীক্ষা করাতে হবে';

  @override
  String get questionsAsked => 'জিজ্ঞাসা করা প্রশ্ন';

  @override
  String askedOf(int asked, int total) {
    return '$totalটির মধ্যে $askedটি জিজ্ঞাসা করা হয়েছে';
  }

  @override
  String get deleteVisit => 'ভিজিট মুছুন';

  @override
  String get deleteVisitConfirm => 'এই ভিজিট মুছবেন? এটি আর ফেরত আনা যাবে না।';

  @override
  String get cancel => 'বাতিল';

  @override
  String get delete => 'মুছুন';

  @override
  String get doctorName => 'ডাক্তারের নাম';

  @override
  String get doctorNameHint => 'যেমন ডা. মীনা রাও';

  @override
  String get visitReason => 'ভিজিটের কারণ';

  @override
  String get visitReasonHint => 'যেমন সুগার চেক-আপ';

  @override
  String get visitDate => 'ভিজিটের তারিখ';

  @override
  String get listenToDoctor => 'ডাক্তারের কথা শুনুন';

  @override
  String get stopListening => 'শোনা বন্ধ করুন';

  @override
  String get speak => 'বলুন';

  @override
  String get recordingConsent =>
      'ডাক্তারকে জানান যে আপনি Gurtu দিয়ে কথোপকথন লিখে রাখছেন।';

  @override
  String get doctorSaidHint => 'ডাক্তার যা বলেন তা বলুন বা টাইপ করুন';

  @override
  String get medicinesHint => 'যেমন মেটফরমিন 500 mg জলখাবারের পরে';

  @override
  String get testsHint => 'যেমন HbA1c রক্ত পরীক্ষা';

  @override
  String get addNextVisit => 'পরের ভিজিটের তারিখ যোগ করুন';

  @override
  String get yourQuestions => 'আপনার প্রশ্ন';

  @override
  String get tickWhenAsked => 'ডাক্তার উত্তর দিলে প্রতিটিতে টিক দিন।';

  @override
  String get saveVisit => 'ভিজিট সেভ করুন';

  @override
  String get visitSaved => 'ভিজিট সেভ হয়েছে';

  @override
  String get leaveVisitTitle => 'সেভ না করে চলে যাবেন?';

  @override
  String get leaveVisitBody => 'এই ভিজিটের জন্য যা লিখেছেন তা মুছে যাবে।';

  @override
  String get discard => 'বাদ দিন';

  @override
  String get keepEditing => 'লেখা চালিয়ে যান';

  @override
  String get voiceUnavailable =>
      'এখন ভয়েস ইনপুট পাওয়া যাচ্ছে না। আপনি টাইপ করতে পারেন।';

  @override
  String get prepTitle => 'ডাক্তারের জন্য প্রস্তুতি';

  @override
  String get prepIntro =>
      'চলুন ডাক্তার দেখানোর প্রস্তুতি নিই। কোন স্বাস্থ্য সমস্যা নিয়ে কথা বলতে হবে?';

  @override
  String get prepPickOrSay => 'নিচে সমস্যা বেছে নিন, অথবা নিজের ভাষায় বলুন।';

  @override
  String get prepDescribeHint => 'যেমন তিন দিন ধরে মাথাব্যথা আর ক্লান্তি';

  @override
  String prepHeard(String symptoms) {
    return 'আমি শুনলাম: $symptoms';
  }

  @override
  String askSince(String symptom) {
    return '$symptom — কবে থেকে?';
  }

  @override
  String askSeverity(String symptom) {
    return '$symptom — কতটা বেশি?';
  }

  @override
  String get askNewMedicine => 'সম্প্রতি কোনো ওষুধ শুরু বা বদল হয়েছে কি?';

  @override
  String get askAnythingElse => 'ডাক্তারকে আর কিছু জানানোর আছে?';

  @override
  String get urgentWarning =>
      'তীব্র বুকে ব্যথা বা শ্বাসকষ্ট জরুরি অবস্থা হতে পারে। অ্যাপয়েন্টমেন্টের অপেক্ষা করবেন না — এখনই চিকিৎসা সাহায্য নিন।';

  @override
  String get prepThinking => 'আপনার প্রশ্ন তৈরি হচ্ছে…';

  @override
  String get prepResultIntro =>
      'ডাক্তারকে এগুলো জিজ্ঞাসা করুন। যেগুলো দরকার নেই সরিয়ে দিন, বা নিজের প্রশ্ন যোগ করুন।';

  @override
  String get prepNotDoctor =>
      'Gurtu ডাক্তার নয়। এই প্রশ্নগুলো ডাক্তারের সঙ্গে কথা বলতে সাহায্য করে।';

  @override
  String get addOwnQuestion => 'নিজের প্রশ্ন যোগ করুন';

  @override
  String get add => 'যোগ করুন';

  @override
  String get saveQuestions => 'ভিজিটের জন্য সেভ করুন';

  @override
  String get questionsSaved => 'প্রশ্ন ভিজিটের জন্য সেভ হয়েছে';

  @override
  String get startAgain => 'আবার শুরু করুন';

  @override
  String get startVisit => 'ভিজিট শুরু করুন';

  @override
  String get deleteQuestions => 'এই প্রশ্নগুলো মুছুন';

  @override
  String get removeQuestion => 'প্রশ্ন সরান';

  @override
  String get done => 'হয়ে গেছে';

  @override
  String get healthProblems => 'স্বাস্থ্য সমস্যা';

  @override
  String preparedOn(String date) {
    return '$date তারিখে তৈরি';
  }

  @override
  String get symFever => 'জ্বর';

  @override
  String get symHeadache => 'মাথাব্যথা';

  @override
  String get symBodyPain => 'গায়ে বা গাঁটে ব্যথা';

  @override
  String get symChestPain => 'বুকে ব্যথা';

  @override
  String get symBreathless => 'শ্বাসকষ্ট';

  @override
  String get symCough => 'কাশি';

  @override
  String get symDizziness => 'মাথা ঘোরা';

  @override
  String get symTiredness => 'ক্লান্তি';

  @override
  String get symStomach => 'পেটের সমস্যা';

  @override
  String get symPoorSleep => 'ঘুম না হওয়া';

  @override
  String get symPoorAppetite => 'খিদে কম';

  @override
  String get symLowMood => 'মন খারাপ বা দুশ্চিন্তা';

  @override
  String get kwFever => 'জ্বর,গা গরম,কাঁপুনি';

  @override
  String get kwHeadache => 'মাথাব্যথা,মাথা ব্যথা,মাথা ধরা';

  @override
  String get kwBodyPain =>
      'গায়ে ব্যথা,গাঁটে ব্যথা,হাঁটু,কোমরে ব্যথা,পায়ে ব্যথা';

  @override
  String get kwChestPain => 'বুকে ব্যথা,বুক,বুকে';

  @override
  String get kwBreathless => 'শ্বাস,শ্বাসকষ্ট,হাঁপ';

  @override
  String get kwCough => 'কাশি,কফ,সর্দি';

  @override
  String get kwDizziness => 'মাথা ঘোরা,মাথা ঘুরছে,অজ্ঞান';

  @override
  String get kwTiredness => 'ক্লান্তি,দুর্বল,দুর্বলতা,ক্লান্ত';

  @override
  String get kwStomach =>
      'পেট,অম্বল,গ্যাস,বমি,পাতলা পায়খানা,ডায়রিয়া,কোষ্ঠকাঠিন্য,বমি বমি';

  @override
  String get kwPoorSleep => 'ঘুম,অনিদ্রা';

  @override
  String get kwPoorAppetite => 'খিদে,খাওয়ার ইচ্ছা নেই';

  @override
  String get kwLowMood => 'মন খারাপ,দুশ্চিন্তা,ভয়,টেনশন,চাপ,উদ্বেগ';

  @override
  String get sinceToday => 'আজ থেকে';

  @override
  String get sinceFewDays => 'কয়েক দিন ধরে';

  @override
  String get sinceWeek => 'প্রায় এক সপ্তাহ ধরে';

  @override
  String get sinceMonth => 'এক মাস বা তার বেশি';

  @override
  String get sevMild => 'হালকা';

  @override
  String get sevModerate => 'মাঝারি';

  @override
  String get sevSevere => 'তীব্র';

  @override
  String qCause(String symptom) {
    return '$symptom-এর কারণ কী হতে পারে?';
  }

  @override
  String qTests(String symptom) {
    return '$symptom-এর জন্য কোনো পরীক্ষা দরকার?';
  }

  @override
  String qWarningSigns(String symptom) {
    return '$symptom-এর সঙ্গে কোন লক্ষণ দেখলে সঙ্গে সঙ্গে আসতে হবে?';
  }

  @override
  String qHomeCare(String symptom) {
    return '$symptom কমাতে বাড়িতে কী করা যায়?';
  }

  @override
  String qConditionLink(String symptom, String conditions) {
    return '$symptom-এর সঙ্গে $conditions-এর কোনো সম্পর্ক থাকতে পারে?';
  }

  @override
  String get qSideEffect => 'নতুন বা বদলানো কোনো ওষুধের জন্য কি এটা হচ্ছে?';

  @override
  String get qMedicinesStillRight =>
      'এখনকার ওষুধগুলো কি ঠিক আছে, নাকি কিছু বদলাতে হবে?';

  @override
  String get qNextCheckup => 'পরের চেক-আপে কবে আসতে হবে?';

  @override
  String qTellDoctor(String text) {
    return 'ডাক্তারকে বলুন: “$text”';
  }

  @override
  String get sampleVisitDiabetesReason => 'ডায়াবেটিস পর্যালোচনা';

  @override
  String get sampleVisitDiabetesNotes =>
      'সুগার আগের চেয়ে ভালো নিয়ন্ত্রণে আছে। একই ওষুধ চালিয়ে যান। রোজ 30 মিনিট হাঁটুন আর মিষ্টি কমান।';

  @override
  String get sampleVisitDiabetesMeds =>
      'মেটফরমিন 500 mg জলখাবার ও রাতের খাবারের পরে';

  @override
  String get sampleVisitDiabetesTests => 'পরের ভিজিটের আগে HbA1c রক্ত পরীক্ষা';

  @override
  String get sampleVisitKneeReason => 'হাঁটুতে ব্যথা';

  @override
  String get sampleVisitKneeNotes =>
      'ডান হাঁটুতে হালকা আর্থ্রাইটিস। সন্ধ্যায় গরম সেঁক দিন আর বেশি সিঁড়ি ভাঙা এড়িয়ে চলুন।';

  @override
  String get sampleVisitKneeMeds => 'ব্যথার জেল দিনে দু\'বার';

  @override
  String get scanVerify => 'ওষুধ স্ক্যান করে যাচাই করুন';

  @override
  String get scanVerifyHint => 'এই ট্যাবলেটটাই কি এখন খেতে হবে?';

  @override
  String scanVerifySubtitle(String name) {
    return 'পাতা বা বাক্স স্ক্যান করুন। Gurtu সেটি $name-এর ওষুধের তালিকার সঙ্গে মিলিয়ে দেখবে।';
  }

  @override
  String get scanWithCamera => 'ওষুধ স্ক্যান করুন';

  @override
  String get orTypeName => 'অথবা পাতায় লেখা নাম টাইপ করুন';

  @override
  String get typeNameHint => 'যেমন Glycomet 500';

  @override
  String get checkMedicine => 'যাচাই করুন';

  @override
  String get checkAnother => 'অন্য ওষুধ যাচাই করুন';

  @override
  String get readingStrip => 'পাতা পড়া হচ্ছে…';

  @override
  String get cameraUnavailable =>
      'ক্যামেরা স্ক্যান ফোনের অ্যাপে কাজ করে। এখন নাম টাইপ করুন।';

  @override
  String get scanFailed =>
      'ছবিটি পড়া গেল না। আবার চেষ্টা করুন, বা নাম টাইপ করুন।';

  @override
  String readFromStrip(String text) {
    return 'পাতায় পড়া হয়েছে: “$text”';
  }

  @override
  String get verifyDisclaimer =>
      'Gurtu শুধু আপনার সেভ করা ওষুধের সঙ্গে মেলায়। এটি কখনও ওষুধ সুপারিশ করে না।';

  @override
  String get verdictTakeNow => 'হ্যাঁ — এটাই সঠিক ওষুধ, এখন খাওয়া যাবে।';

  @override
  String get verdictNotNow => 'ওষুধ ঠিক আছে, কিন্তু এখন খাওয়ার সময় নয়।';

  @override
  String get verdictAlreadyTaken => 'এই ডোজ আগেই খাওয়া হয়েছে। আবার খাবেন না।';

  @override
  String get verdictNoTimes => 'ওষুধ ঠিক আছে, কিন্তু এর সময় সেভ করা নেই।';

  @override
  String get verdictWrongStrength =>
      'থামুন — মাত্রা (mg) প্রেসক্রিপশন থেকে আলাদা।';

  @override
  String verdictNotOnList(String name) {
    return 'থামুন — এই ওষুধ $name-এর তালিকায় নেই।';
  }

  @override
  String verdictOtherPatient(String other, String name) {
    return 'থামুন — এই ওষুধ $other-এর তালিকার, $name-এর নয়।';
  }

  @override
  String get verdictUnreadable =>
      'ওষুধের নাম পড়া গেল না। ভালো আলোয় আবার চেষ্টা করুন, বা টাইপ করুন।';

  @override
  String get verdictCheckFirst =>
      'ডাক্তার বা ফার্মাসিস্টকে জিজ্ঞাসা না করে খাবেন না।';

  @override
  String get rowOnList => 'ওষুধের তালিকায় আছে';

  @override
  String rowStrengthMatches(String strength) {
    return 'মাত্রা মিলেছে: $strength';
  }

  @override
  String rowStrengthDiffers(String found, String prescribed) {
    return 'পাতায় $found, প্রেসক্রিপশনে $prescribed';
  }

  @override
  String rowDueNow(String slot) {
    return 'এখন খেতে হবে: $slot-এর ডোজ';
  }

  @override
  String rowTakenAt(String slot, String time) {
    return '$slot-এর ডোজ $time-এ খাওয়া হয়েছে';
  }

  @override
  String rowNextDose(String slot) {
    return 'পরের ডোজ: $slot';
  }

  @override
  String get rowSetTimes => 'ওষুধের তালিকায় কখন খেতে হবে তা যোগ করুন';

  @override
  String get markTaken => 'খাওয়া হয়েছে বলে লিখুন';

  @override
  String get markedTaken => 'ডোজ লেখা হয়েছে';

  @override
  String get undo => 'ফিরিয়ে নিন';

  @override
  String get medicineList => 'ওষুধের তালিকা';

  @override
  String get medicineListSubtitle =>
      'প্রেসক্রিপশনের প্রতিটি ওষুধ, কখন খেতে হবে সহ।';

  @override
  String medicinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ওষুধ',
      one: '1টি ওষুধ',
    );
    return '$_temp0';
  }

  @override
  String get addMedicine => 'ওষুধ যোগ করুন';

  @override
  String get editMedicine => 'ওষুধ বদলান';

  @override
  String get addFromPrescription => 'প্রেসক্রিপশনের ছবি থেকে যোগ করুন';

  @override
  String get noMedicinesTitle => 'এখনও কোনো ওষুধ যোগ করা হয়নি';

  @override
  String get noMedicinesBody =>
      'প্রেসক্রিপশনের প্রতিটি ওষুধ একবার যোগ করুন। তারপর যেকোনো পাতা স্ক্যান করে দেখুন সঠিক কি না।';

  @override
  String addMedicinesFirst(String name) {
    return 'আগে $name-এর ওষুধগুলো যোগ করুন, যাতে Gurtu সেগুলোর সঙ্গে মেলাতে পারে।';
  }

  @override
  String get medicineName => 'ওষুধের নাম';

  @override
  String get medicineNameHint => 'যেমন Metformin';

  @override
  String get alsoCalled => 'পাতায় লেখা অন্য নাম';

  @override
  String get alsoCalledHint => 'যেমন Glycomet';

  @override
  String get strength => 'মাত্রা';

  @override
  String get strengthHint => 'যেমন 500 mg';

  @override
  String get whenToTake => 'কখন খেতে হবে';

  @override
  String get doseMorning => 'সকাল';

  @override
  String get doseAfternoon => 'দুপুর';

  @override
  String get doseEvening => 'সন্ধ্যা';

  @override
  String get doseNight => 'রাত';

  @override
  String get foodAfter => 'খাবারের পরে';

  @override
  String get foodBefore => 'খাবারের আগে';

  @override
  String get foodAny => 'খাবারের সঙ্গে বা ছাড়া';

  @override
  String get saveMedicine => 'ওষুধ সেভ করুন';

  @override
  String get medicineSaved => 'ওষুধ সেভ হয়েছে';

  @override
  String get deleteMedicine => 'ওষুধ মুছুন';

  @override
  String get deleteMedicineConfirm => 'এই ওষুধটি তালিকা থেকে সরাবেন?';

  @override
  String get scanToFill => 'পাতা স্ক্যান করে ভরুন';

  @override
  String get timesNotSet => 'সময় ঠিক করা নেই';

  @override
  String get takenToday => 'আজ খাওয়া হয়েছে';

  @override
  String get prescriptionTitle => 'প্রেসক্রিপশন থেকে যোগ করুন';

  @override
  String get prescriptionHint =>
      'ছাপা প্রেসক্রিপশনের পরিষ্কার ছবি তুলুন। Gurtu ওষুধ খুঁজে বের করবে; কোনগুলো যোগ করবেন আপনি বেছে নিন।';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get chooseFromGallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get medicinesFound => 'পাওয়া ওষুধ';

  @override
  String get tickToAdd =>
      'যেগুলো যোগ করবেন তাতে টিক দিন। প্রতিটি নাম ও সময় প্রেসক্রিপশনের সঙ্গে মিলিয়ে নিন।';

  @override
  String addSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ওষুধ যোগ করুন',
      one: '1টি ওষুধ যোগ করুন',
    );
    return '$_temp0';
  }

  @override
  String get nothingFound =>
      'কোনো ওষুধ পাওয়া যায়নি। পরিষ্কার ছবি তুলুন, বা হাতে যোগ করুন।';

  @override
  String get handwrittenNote =>
      'হাতে লেখা প্রেসক্রিপশন ঠিকমতো পড়া নাও যেতে পারে। প্রতিটি নাম যাচাই করুন।';

  @override
  String medicinesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি ওষুধ যোগ হয়েছে',
      one: '1টি ওষুধ যোগ হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String rowStrengthCheck(String strength) {
    return 'পাতায় $strength লেখা আছে কি না দেখে নিন';
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
}
