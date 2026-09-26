import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('as'),
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('or'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @notSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get notSure;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Remember. Care. Together.'**
  String get tagline;

  /// What people in this region commonly call their mother; used as an example name.
  ///
  /// In en, this message translates to:
  /// **'Amma'**
  String get motherName;

  /// No description provided for @phaseAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get phaseAbout;

  /// No description provided for @phaseHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get phaseHealth;

  /// No description provided for @phasePermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get phasePermissions;

  /// No description provided for @phaseAi.
  ///
  /// In en, this message translates to:
  /// **'AI setup'**
  String get phaseAi;

  /// No description provided for @phaseStep.
  ///
  /// In en, this message translates to:
  /// **'{phase} · {current} of {total}'**
  String phaseStep(String phase, int current, int total);

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gurtu will speak, listen and write in this language.'**
  String get languageSubtitle;

  /// No description provided for @languageMixNote.
  ///
  /// In en, this message translates to:
  /// **'Doctors often mix English with your language. Gurtu understands both together.'**
  String get languageMixNote;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your family\'s\nmemory of care'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'What the doctor said, what was prescribed and what happened at home — remembered together.'**
  String get welcomeBody;

  /// No description provided for @welcomeScript.
  ///
  /// In en, this message translates to:
  /// **'Different roles. Same love.'**
  String get welcomeScript;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// Footer; the brand is drawn in the iQOO gradient.
  ///
  /// In en, this message translates to:
  /// **'Built for {brand}'**
  String builtForBrand(String brand);

  /// No description provided for @madeInHyderabad.
  ///
  /// In en, this message translates to:
  /// **'Made in Hyderabad'**
  String get madeInHyderabad;

  /// No description provided for @introRecordEyebrow.
  ///
  /// In en, this message translates to:
  /// **'1 · Record'**
  String get introRecordEyebrow;

  /// No description provided for @introRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Never forget what the doctor said'**
  String get introRecordTitle;

  /// No description provided for @introRecordBody.
  ///
  /// In en, this message translates to:
  /// **'With everyone\'s consent, record the doctor, nurse or pharmacist. Gurtu keeps the important parts.'**
  String get introRecordBody;

  /// No description provided for @introPlanEyebrow.
  ///
  /// In en, this message translates to:
  /// **'2 · Understand & share'**
  String get introPlanEyebrow;

  /// No description provided for @introPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'One care plan for the whole family'**
  String get introPlanTitle;

  /// No description provided for @introPlanBody.
  ///
  /// In en, this message translates to:
  /// **'Scan prescriptions and reports. Gurtu turns them into simple tasks the family can share.'**
  String get introPlanBody;

  /// No description provided for @introAskEyebrow.
  ///
  /// In en, this message translates to:
  /// **'3 · Ask & remember'**
  String get introAskEyebrow;

  /// No description provided for @introAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask anything, see the proof'**
  String get introAskTitle;

  /// No description provided for @introAskBody.
  ///
  /// In en, this message translates to:
  /// **'Every answer shows where it came from — the recording, the prescription or the photo.'**
  String get introAskBody;

  /// No description provided for @letsSetUp.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up'**
  String get letsSetUp;

  /// No description provided for @hospitalMode.
  ///
  /// In en, this message translates to:
  /// **'Hospital Mode'**
  String get hospitalMode;

  /// No description provided for @consentRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording with consent of everyone present'**
  String get consentRecording;

  /// No description provided for @doctorConversation.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s conversation'**
  String get doctorConversation;

  /// No description provided for @nurseInstructions.
  ///
  /// In en, this message translates to:
  /// **'Nurse instructions'**
  String get nurseInstructions;

  /// No description provided for @pharmacistAdvice.
  ///
  /// In en, this message translates to:
  /// **'Pharmacist advice'**
  String get pharmacistAdvice;

  /// No description provided for @yourCarePlan.
  ///
  /// In en, this message translates to:
  /// **'Your Care Plan'**
  String get yourCarePlan;

  /// No description provided for @afterBreakfast.
  ///
  /// In en, this message translates to:
  /// **'After breakfast'**
  String get afterBreakfast;

  /// No description provided for @checkBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Check blood pressure'**
  String get checkBloodPressure;

  /// No description provided for @twiceDaily.
  ///
  /// In en, this message translates to:
  /// **'Twice daily'**
  String get twiceDaily;

  /// No description provided for @bloodTest.
  ///
  /// In en, this message translates to:
  /// **'Blood test (CBC)'**
  String get bloodTest;

  /// No description provided for @instructionsFound.
  ///
  /// In en, this message translates to:
  /// **'4 instructions found in your recordings and prescription'**
  String get instructionsFound;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'What did the doctor say about the evening medicine?'**
  String get askQuestion;

  /// No description provided for @askAnswer.
  ///
  /// In en, this message translates to:
  /// **'The doctor said to take Amlodipine after dinner.'**
  String get askAnswer;

  /// No description provided for @sourceDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Source: Doctor visit'**
  String get sourceDoctorVisit;

  /// No description provided for @careForTitle.
  ///
  /// In en, this message translates to:
  /// **'Who are you setting up Gurtu for?'**
  String get careForTitle;

  /// No description provided for @careForSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gurtu builds one care memory around one person. You can invite the rest of the family later.'**
  String get careForSubtitle;

  /// No description provided for @careForMyself.
  ///
  /// In en, this message translates to:
  /// **'Myself'**
  String get careForMyself;

  /// No description provided for @careForMyselfHint.
  ///
  /// In en, this message translates to:
  /// **'I want to keep track of my own care'**
  String get careForMyselfHint;

  /// No description provided for @careForParent.
  ///
  /// In en, this message translates to:
  /// **'My parent'**
  String get careForParent;

  /// No description provided for @careForParentHint.
  ///
  /// In en, this message translates to:
  /// **'Mother, father or an elder in the family'**
  String get careForParentHint;

  /// No description provided for @careForPartner.
  ///
  /// In en, this message translates to:
  /// **'My partner'**
  String get careForPartner;

  /// No description provided for @careForPartnerHint.
  ///
  /// In en, this message translates to:
  /// **'Husband, wife or partner'**
  String get careForPartnerHint;

  /// No description provided for @careForChild.
  ///
  /// In en, this message translates to:
  /// **'My child'**
  String get careForChild;

  /// No description provided for @careForChildHint.
  ///
  /// In en, this message translates to:
  /// **'Son or daughter'**
  String get careForChildHint;

  /// No description provided for @careForOther.
  ///
  /// In en, this message translates to:
  /// **'Someone else'**
  String get careForOther;

  /// No description provided for @careForOtherHint.
  ///
  /// In en, this message translates to:
  /// **'Relative, friend or neighbour'**
  String get careForOtherHint;

  /// No description provided for @profileTitleSelf.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get profileTitleSelf;

  /// No description provided for @profileTitleOther.
  ///
  /// In en, this message translates to:
  /// **'Tell us about them'**
  String get profileTitleOther;

  /// No description provided for @profileSubtitleSelf.
  ///
  /// In en, this message translates to:
  /// **'This helps Gurtu talk to you by name.'**
  String get profileSubtitleSelf;

  /// No description provided for @profileSubtitleOther.
  ///
  /// In en, this message translates to:
  /// **'Use the name you call them at home.'**
  String get profileSubtitleOther;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @whatDoYouCallThem.
  ///
  /// In en, this message translates to:
  /// **'What do you call them?'**
  String get whatDoYouCallThem;

  /// No description provided for @exampleName.
  ///
  /// In en, this message translates to:
  /// **'e.g. {name}'**
  String exampleName(String name);

  /// No description provided for @sampleSelfName.
  ///
  /// In en, this message translates to:
  /// **'Lakshmi'**
  String get sampleSelfName;

  /// No description provided for @sampleYourName.
  ///
  /// In en, this message translates to:
  /// **'Priya'**
  String get sampleYourName;

  /// No description provided for @yourAge.
  ///
  /// In en, this message translates to:
  /// **'Your age'**
  String get yourAge;

  /// No description provided for @theirAge.
  ///
  /// In en, this message translates to:
  /// **'Their age'**
  String get theirAge;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @decreaseAge.
  ///
  /// In en, this message translates to:
  /// **'Decrease age'**
  String get decreaseAge;

  /// No description provided for @increaseAge.
  ///
  /// In en, this message translates to:
  /// **'Increase age'**
  String get increaseAge;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @andYou.
  ///
  /// In en, this message translates to:
  /// **'And you?'**
  String get andYou;

  /// No description provided for @andYouBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be the first member of their Care Circle.'**
  String get andYouBody;

  /// No description provided for @conditionsTitleSelf.
  ///
  /// In en, this message translates to:
  /// **'Do you have any of these health conditions?'**
  String get conditionsTitleSelf;

  /// No description provided for @conditionsTitleOther.
  ///
  /// In en, this message translates to:
  /// **'Does {name} have any of these health conditions?'**
  String conditionsTitleOther(String name);

  /// No description provided for @conditionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap all that apply. This helps Gurtu organise the care plan.'**
  String get conditionsSubtitle;

  /// No description provided for @condDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Sugar (Diabetes)'**
  String get condDiabetes;

  /// No description provided for @condHighBp.
  ///
  /// In en, this message translates to:
  /// **'High BP'**
  String get condHighBp;

  /// No description provided for @condHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart problem'**
  String get condHeart;

  /// No description provided for @condThyroid.
  ///
  /// In en, this message translates to:
  /// **'Thyroid'**
  String get condThyroid;

  /// No description provided for @condCholesterol.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol'**
  String get condCholesterol;

  /// No description provided for @condAsthma.
  ///
  /// In en, this message translates to:
  /// **'Asthma / breathing'**
  String get condAsthma;

  /// No description provided for @condKidney.
  ///
  /// In en, this message translates to:
  /// **'Kidney problem'**
  String get condKidney;

  /// No description provided for @condArthritis.
  ///
  /// In en, this message translates to:
  /// **'Joint pain / arthritis'**
  String get condArthritis;

  /// No description provided for @condStroke.
  ///
  /// In en, this message translates to:
  /// **'Past stroke'**
  String get condStroke;

  /// No description provided for @condCancer.
  ///
  /// In en, this message translates to:
  /// **'Cancer care'**
  String get condCancer;

  /// No description provided for @noneOfThese.
  ///
  /// In en, this message translates to:
  /// **'None of these'**
  String get noneOfThese;

  /// No description provided for @notADoctor.
  ///
  /// In en, this message translates to:
  /// **'Gurtu is not a doctor. It never diagnoses — it only helps your family remember and organise care.'**
  String get notADoctor;

  /// No description provided for @medicinesTitleSelf.
  ///
  /// In en, this message translates to:
  /// **'Do you take medicines every day?'**
  String get medicinesTitleSelf;

  /// No description provided for @medicinesTitleOther.
  ///
  /// In en, this message translates to:
  /// **'Does {name} take medicines every day?'**
  String medicinesTitleOther(String name);

  /// No description provided for @medicinesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Include tablets, syrups, inhalers or insulin.'**
  String get medicinesSubtitle;

  /// No description provided for @howMany.
  ///
  /// In en, this message translates to:
  /// **'About how many?'**
  String get howMany;

  /// No description provided for @sixOrMore.
  ///
  /// In en, this message translates to:
  /// **'6 or more'**
  String get sixOrMore;

  /// No description provided for @scanLaterTip.
  ///
  /// In en, this message translates to:
  /// **'Later, just scan the prescription or medicine strip — no typing needed.'**
  String get scanLaterTip;

  /// No description provided for @allergiesTitleSelf.
  ///
  /// In en, this message translates to:
  /// **'Are you allergic to anything?'**
  String get allergiesTitleSelf;

  /// No description provided for @allergiesTitleOther.
  ///
  /// In en, this message translates to:
  /// **'Is {name} allergic to anything?'**
  String allergiesTitleOther(String name);

  /// No description provided for @allergiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gurtu will show this on every Doctor Brief so it is never missed.'**
  String get allergiesSubtitle;

  /// No description provided for @allergyNone.
  ///
  /// In en, this message translates to:
  /// **'No known allergies'**
  String get allergyNone;

  /// No description provided for @allergyPenicillin.
  ///
  /// In en, this message translates to:
  /// **'Penicillin'**
  String get allergyPenicillin;

  /// No description provided for @allergySulfa.
  ///
  /// In en, this message translates to:
  /// **'Sulfa drugs'**
  String get allergySulfa;

  /// No description provided for @allergyAspirin.
  ///
  /// In en, this message translates to:
  /// **'Aspirin / painkillers'**
  String get allergyAspirin;

  /// No description provided for @allergyFood.
  ///
  /// In en, this message translates to:
  /// **'Food allergy'**
  String get allergyFood;

  /// No description provided for @allergyDust.
  ///
  /// In en, this message translates to:
  /// **'Dust / pollen'**
  String get allergyDust;

  /// No description provided for @allergyLatex.
  ///
  /// In en, this message translates to:
  /// **'Latex'**
  String get allergyLatex;

  /// No description provided for @mobilityTitleSelf.
  ///
  /// In en, this message translates to:
  /// **'How do you get around day to day?'**
  String get mobilityTitleSelf;

  /// No description provided for @mobilityTitleOther.
  ///
  /// In en, this message translates to:
  /// **'How does {name} get around day to day?'**
  String mobilityTitleOther(String name);

  /// No description provided for @mobilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps the family plan visits, tests and help at home.'**
  String get mobilitySubtitle;

  /// No description provided for @mobilityIndependent.
  ///
  /// In en, this message translates to:
  /// **'Walks on their own'**
  String get mobilityIndependent;

  /// No description provided for @mobilityIndependentHint.
  ///
  /// In en, this message translates to:
  /// **'No help needed day to day'**
  String get mobilityIndependentHint;

  /// No description provided for @mobilitySomeHelp.
  ///
  /// In en, this message translates to:
  /// **'Needs some help'**
  String get mobilitySomeHelp;

  /// No description provided for @mobilitySomeHelpHint.
  ///
  /// In en, this message translates to:
  /// **'Stick, walker or a hand to hold'**
  String get mobilitySomeHelpHint;

  /// No description provided for @mobilityFullHelp.
  ///
  /// In en, this message translates to:
  /// **'Mostly in bed or wheelchair'**
  String get mobilityFullHelp;

  /// No description provided for @mobilityFullHelpHint.
  ///
  /// In en, this message translates to:
  /// **'Needs help for most things'**
  String get mobilityFullHelpHint;

  /// No description provided for @hospitalTitleSelf.
  ///
  /// In en, this message translates to:
  /// **'Have you been to a hospital or doctor in the last 30 days?'**
  String get hospitalTitleSelf;

  /// No description provided for @hospitalTitleOther.
  ///
  /// In en, this message translates to:
  /// **'Has {name} been to a hospital or doctor in the last 30 days?'**
  String hospitalTitleOther(String name);

  /// No description provided for @hospitalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent visits usually come with new instructions to track.'**
  String get hospitalSubtitle;

  /// No description provided for @hospitalTip.
  ///
  /// In en, this message translates to:
  /// **'Keep the discharge papers and prescriptions handy — you can scan them right after setup.'**
  String get hospitalTip;

  /// No description provided for @permissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'A few permissions to help you'**
  String get permissionsTitle;

  /// No description provided for @permissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gurtu only asks for what it needs. Here is exactly why.'**
  String get permissionsSubtitle;

  /// No description provided for @permMic.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get permMic;

  /// No description provided for @permMicWhy.
  ///
  /// In en, this message translates to:
  /// **'Record doctor visits and voice notes — only when you tap record.'**
  String get permMicWhy;

  /// No description provided for @permCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permCamera;

  /// No description provided for @permCameraWhy.
  ///
  /// In en, this message translates to:
  /// **'Scan prescriptions, medicine strips and BP machine readings.'**
  String get permCameraWhy;

  /// No description provided for @permNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permNotifications;

  /// No description provided for @permNotificationsWhy.
  ///
  /// In en, this message translates to:
  /// **'Medicine reminders and updates when family completes a task.'**
  String get permNotificationsWhy;

  /// No description provided for @permPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos & files'**
  String get permPhotos;

  /// No description provided for @permPhotosWhy.
  ///
  /// In en, this message translates to:
  /// **'Add reports and prescriptions already saved in your gallery.'**
  String get permPhotosWhy;

  /// No description provided for @permContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get permContacts;

  /// No description provided for @permContactsWhy.
  ///
  /// In en, this message translates to:
  /// **'Quickly invite family members to the Care Circle.'**
  String get permContactsWhy;

  /// No description provided for @needed.
  ///
  /// In en, this message translates to:
  /// **'Needed'**
  String get needed;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @allowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get allowed;

  /// No description provided for @allowAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Allow & continue'**
  String get allowAndContinue;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on this phone. Recording never starts on its own — it always shows a consent screen first.'**
  String get privacyNote;

  /// No description provided for @permissionBlocked.
  ///
  /// In en, this message translates to:
  /// **'{permission} is blocked. Turn it on in Settings.'**
  String permissionBlocked(String permission);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @permissionsMissing.
  ///
  /// In en, this message translates to:
  /// **'Without {items}, some features won\'t work. You can allow it later.'**
  String permissionsMissing(String items);

  /// No description provided for @modelTitleChoose.
  ///
  /// In en, this message translates to:
  /// **'Set up Gurtu\'s on-device AI'**
  String get modelTitleChoose;

  /// No description provided for @modelTitleDownloading.
  ///
  /// In en, this message translates to:
  /// **'Setting up your AI…'**
  String get modelTitleDownloading;

  /// No description provided for @modelTitleDone.
  ///
  /// In en, this message translates to:
  /// **'Your AI is ready'**
  String get modelTitleDone;

  /// No description provided for @modelSubtitleChoose.
  ///
  /// In en, this message translates to:
  /// **'These models run fully on your iQOO. Your family\'s health data never leaves the phone — and it works without internet.'**
  String get modelSubtitleChoose;

  /// No description provided for @modelSubtitleDownloading.
  ///
  /// In en, this message translates to:
  /// **'You can keep using your phone. This happens only once.'**
  String get modelSubtitleDownloading;

  /// No description provided for @modelSubtitleDone.
  ///
  /// In en, this message translates to:
  /// **'Everything runs on this phone, even offline.'**
  String get modelSubtitleDone;

  /// No description provided for @poweredByIqoo.
  ///
  /// In en, this message translates to:
  /// **'Powered by your iQOO'**
  String get poweredByIqoo;

  /// No description provided for @deviceCardSub.
  ///
  /// In en, this message translates to:
  /// **'On-device AI · Private · Works offline'**
  String get deviceCardSub;

  /// No description provided for @chooseCareModel.
  ///
  /// In en, this message translates to:
  /// **'Choose the care model'**
  String get chooseCareModel;

  /// No description provided for @careModelHint.
  ///
  /// In en, this message translates to:
  /// **'This is the brain that answers questions.'**
  String get careModelHint;

  /// No description provided for @alwaysIncluded.
  ///
  /// In en, this message translates to:
  /// **'Always included'**
  String get alwaysIncluded;

  /// No description provided for @jobListens.
  ///
  /// In en, this message translates to:
  /// **'Listens'**
  String get jobListens;

  /// No description provided for @jobReads.
  ///
  /// In en, this message translates to:
  /// **'Reads'**
  String get jobReads;

  /// No description provided for @jobSees.
  ///
  /// In en, this message translates to:
  /// **'Sees'**
  String get jobSees;

  /// No description provided for @jobUnderstands.
  ///
  /// In en, this message translates to:
  /// **'Understands'**
  String get jobUnderstands;

  /// No description provided for @speechModelName.
  ///
  /// In en, this message translates to:
  /// **'Speech · {language} + English'**
  String speechModelName(String language);

  /// No description provided for @speechModelWhat.
  ///
  /// In en, this message translates to:
  /// **'Turns conversations into text in your language.'**
  String get speechModelWhat;

  /// No description provided for @readerModelName.
  ///
  /// In en, this message translates to:
  /// **'Document reader (OCR)'**
  String get readerModelName;

  /// No description provided for @readerModelWhat.
  ///
  /// In en, this message translates to:
  /// **'Reads prescriptions, discharge papers and lab reports.'**
  String get readerModelWhat;

  /// No description provided for @visionModelName.
  ///
  /// In en, this message translates to:
  /// **'Medicine & vitals vision'**
  String get visionModelName;

  /// No description provided for @visionModelWhat.
  ///
  /// In en, this message translates to:
  /// **'Recognises medicine strips and BP / sugar machine numbers.'**
  String get visionModelWhat;

  /// No description provided for @careModelName.
  ///
  /// In en, this message translates to:
  /// **'Care model · {model}'**
  String careModelName(String model);

  /// No description provided for @tierLite.
  ///
  /// In en, this message translates to:
  /// **'Lite'**
  String get tierLite;

  /// No description provided for @tierBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get tierBalanced;

  /// No description provided for @tierPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get tierPro;

  /// No description provided for @tierLiteNote.
  ///
  /// In en, this message translates to:
  /// **'Fastest. Short, simple answers.'**
  String get tierLiteNote;

  /// No description provided for @tierBalancedNote.
  ///
  /// In en, this message translates to:
  /// **'Understands voice, photos and text together.'**
  String get tierBalancedNote;

  /// No description provided for @tierProNote.
  ///
  /// In en, this message translates to:
  /// **'Most detailed answers and Doctor Briefs.'**
  String get tierProNote;

  /// No description provided for @bestForIqoo.
  ///
  /// In en, this message translates to:
  /// **'Best for iQOO'**
  String get bestForIqoo;

  /// No description provided for @wifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Download on Wi-Fi only'**
  String get wifiOnly;

  /// No description provided for @downloadSize.
  ///
  /// In en, this message translates to:
  /// **'Download · {size}'**
  String downloadSize(String size);

  /// No description provided for @settingUp.
  ///
  /// In en, this message translates to:
  /// **'Setting up…'**
  String get settingUp;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @allSetName.
  ///
  /// In en, this message translates to:
  /// **'All set, {name}!'**
  String allSetName(String name);

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get allSet;

  /// No description provided for @readySelf.
  ///
  /// In en, this message translates to:
  /// **'Your care memory is ready.'**
  String get readySelf;

  /// No description provided for @readyOther.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s care memory is ready. Next, invite the family.'**
  String readyOther(String name);

  /// No description provided for @rowYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get rowYou;

  /// No description provided for @rowCaringFor.
  ///
  /// In en, this message translates to:
  /// **'Caring for'**
  String get rowCaringFor;

  /// No description provided for @rowHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get rowHealth;

  /// No description provided for @rowAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get rowAllergies;

  /// No description provided for @rowLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get rowLanguage;

  /// No description provided for @rowAi.
  ///
  /// In en, this message translates to:
  /// **'On-device AI'**
  String get rowAi;

  /// No description provided for @notAdded.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get notAdded;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String ageYears(int age);

  /// No description provided for @careQuote.
  ///
  /// In en, this message translates to:
  /// **'“Care is lighter when we do it together.”'**
  String get careQuote;

  /// No description provided for @enterGurtu.
  ///
  /// In en, this message translates to:
  /// **'Enter Gurtu'**
  String get enterGurtu;

  /// No description provided for @nextUpCareCircle.
  ///
  /// In en, this message translates to:
  /// **'Next up: Care Circle'**
  String get nextUpCareCircle;

  /// No description provided for @homeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'The home screens are coming in the next section.'**
  String get homeComingSoon;

  /// No description provided for @restartOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Restart onboarding'**
  String get restartOnboarding;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get navMemory;

  /// No description provided for @navCircle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get navCircle;

  /// No description provided for @navAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get navAi;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String goodMorning(String name);

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String goodAfternoon(String name);

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String goodEvening(String name);

  /// No description provided for @welcomeName.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Gurtu, {name}'**
  String welcomeName(String name);

  /// No description provided for @welcomeHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your family\'s healthcare, remembered together.'**
  String get welcomeHomeSubtitle;

  /// No description provided for @caringFor.
  ///
  /// In en, this message translates to:
  /// **'Caring for'**
  String get caringFor;

  /// No description provided for @switchPatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Who are you caring for?'**
  String get switchPatientTitle;

  /// No description provided for @addAnotherPerson.
  ///
  /// In en, this message translates to:
  /// **'Add another person'**
  String get addAnotherPerson;

  /// No description provided for @statusOnTrack.
  ///
  /// In en, this message translates to:
  /// **'Care is on track'**
  String get statusOnTrack;

  /// No description provided for @statusNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Something needs attention'**
  String get statusNeedsAttention;

  /// No description provided for @sosLabel.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sosLabel;

  /// No description provided for @sosHint.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get sosHint;

  /// No description provided for @sosHoldTitle.
  ///
  /// In en, this message translates to:
  /// **'Hold to alert your Care Circle'**
  String get sosHoldTitle;

  /// No description provided for @sosHoldBody.
  ///
  /// In en, this message translates to:
  /// **'Press and hold the button for 2 seconds. Your emergency contacts will be alerted.'**
  String get sosHoldBody;

  /// No description provided for @sosHoldButton.
  ///
  /// In en, this message translates to:
  /// **'Hold to send SOS'**
  String get sosHoldButton;

  /// No description provided for @sosKeepHolding.
  ///
  /// In en, this message translates to:
  /// **'Keep holding…'**
  String get sosKeepHolding;

  /// No description provided for @sosPreviewNote.
  ///
  /// In en, this message translates to:
  /// **'Emergency alerts are not connected yet. This is a preview — no one will be alerted.'**
  String get sosPreviewNote;

  /// No description provided for @sosPreviewDone.
  ///
  /// In en, this message translates to:
  /// **'Preview finished. No one was alerted.'**
  String get sosPreviewDone;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @todayCare.
  ///
  /// In en, this message translates to:
  /// **'Today\'s care'**
  String get todayCare;

  /// No description provided for @completedOf.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String completedOf(int done, int total);

  /// No description provided for @viewTodayCare.
  ///
  /// In en, this message translates to:
  /// **'View today\'s care'**
  String get viewTodayCare;

  /// No description provided for @nothingUrgent.
  ///
  /// In en, this message translates to:
  /// **'Nothing urgent right now.'**
  String get nothingUrgent;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get markDone;

  /// No description provided for @markNotDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as not done'**
  String get markNotDone;

  /// No description provided for @openToCircle.
  ///
  /// In en, this message translates to:
  /// **'Open to Care Circle'**
  String get openToCircle;

  /// No description provided for @captureCare.
  ///
  /// In en, this message translates to:
  /// **'Capture Care'**
  String get captureCare;

  /// No description provided for @captureCareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record something important for the care journey.'**
  String get captureCareSubtitle;

  /// No description provided for @whatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get whatHappened;

  /// No description provided for @captureVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get captureVoice;

  /// No description provided for @captureVoiceHint.
  ///
  /// In en, this message translates to:
  /// **'Record a conversation or voice note'**
  String get captureVoiceHint;

  /// No description provided for @captureScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get captureScan;

  /// No description provided for @captureScanHint.
  ///
  /// In en, this message translates to:
  /// **'Prescription or medicine strip'**
  String get captureScanHint;

  /// No description provided for @captureVital.
  ///
  /// In en, this message translates to:
  /// **'Vital'**
  String get captureVital;

  /// No description provided for @captureVitalHint.
  ///
  /// In en, this message translates to:
  /// **'BP, sugar or temperature'**
  String get captureVitalHint;

  /// No description provided for @captureDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get captureDocument;

  /// No description provided for @captureDocumentHint.
  ///
  /// In en, this message translates to:
  /// **'Discharge paper or lab report'**
  String get captureDocumentHint;

  /// No description provided for @captureNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get captureNote;

  /// No description provided for @captureNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Write what happened'**
  String get captureNoteHint;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Felt dizzy after walking'**
  String get noteHint;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get saveNote;

  /// No description provided for @noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to care memory'**
  String get noteSaved;

  /// No description provided for @recentMemory.
  ///
  /// In en, this message translates to:
  /// **'Recent memory'**
  String get recentMemory;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @emptyMemory.
  ///
  /// In en, this message translates to:
  /// **'Your care story starts here.'**
  String get emptyMemory;

  /// No description provided for @addedBy.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String addedBy(String name);

  /// No description provided for @sourcePlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get sourcePlay;

  /// No description provided for @sourceView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get sourceView;

  /// No description provided for @sourceOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get sourceOpen;

  /// No description provided for @sourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceTitle;

  /// No description provided for @sourceRecording.
  ///
  /// In en, this message translates to:
  /// **'Doctor recording'**
  String get sourceRecording;

  /// No description provided for @sourceScan.
  ///
  /// In en, this message translates to:
  /// **'Prescription scan'**
  String get sourceScan;

  /// No description provided for @sourceVital.
  ///
  /// In en, this message translates to:
  /// **'Vital reading'**
  String get sourceVital;

  /// No description provided for @sourceDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get sourceDocument;

  /// No description provided for @sourceNote.
  ///
  /// In en, this message translates to:
  /// **'Written note'**
  String get sourceNote;

  /// No description provided for @sourceSampleNote.
  ///
  /// In en, this message translates to:
  /// **'This is sample data, so there is no original file. Real recordings and scans will open here.'**
  String get sourceSampleNote;

  /// No description provided for @yourCareCircle.
  ///
  /// In en, this message translates to:
  /// **'Your Care Circle'**
  String get yourCareCircle;

  /// No description provided for @manageCircle.
  ///
  /// In en, this message translates to:
  /// **'Manage circle'**
  String get manageCircle;

  /// No description provided for @emptyCircle.
  ///
  /// In en, this message translates to:
  /// **'Care is easier together.'**
  String get emptyCircle;

  /// No description provided for @addFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Add family member'**
  String get addFamilyMember;

  /// No description provided for @rolePatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get rolePatient;

  /// No description provided for @roleCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver'**
  String get roleCaregiver;

  /// No description provided for @roleFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get roleFamily;

  /// No description provided for @roleHelper.
  ///
  /// In en, this message translates to:
  /// **'Trusted helper'**
  String get roleHelper;

  /// No description provided for @askGurtuTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask Gurtu'**
  String get askGurtuTitle;

  /// No description provided for @askGurtuPrompt.
  ///
  /// In en, this message translates to:
  /// **'Need help remembering something?'**
  String get askGurtuPrompt;

  /// No description provided for @askExampleBloodTest.
  ///
  /// In en, this message translates to:
  /// **'When is the blood test?'**
  String get askExampleBloodTest;

  /// No description provided for @askExampleDoctor.
  ///
  /// In en, this message translates to:
  /// **'What should I ask the doctor tomorrow?'**
  String get askExampleDoctor;

  /// No description provided for @askGurtuNote.
  ///
  /// In en, this message translates to:
  /// **'Answers come from your saved care information.'**
  String get askGurtuNote;

  /// No description provided for @gettingReady.
  ///
  /// In en, this message translates to:
  /// **'Getting Gurtu ready'**
  String get gettingReady;

  /// No description provided for @readyYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get readyYourProfile;

  /// No description provided for @readyPatientProfile.
  ///
  /// In en, this message translates to:
  /// **'Patient profile'**
  String get readyPatientProfile;

  /// No description provided for @readyCareCircle.
  ///
  /// In en, this message translates to:
  /// **'Care Circle'**
  String get readyCareCircle;

  /// No description provided for @readyEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get readyEmergencyContact;

  /// No description provided for @previewSampleData.
  ///
  /// In en, this message translates to:
  /// **'Preview with sample data'**
  String get previewSampleData;

  /// No description provided for @sampleDataOn.
  ///
  /// In en, this message translates to:
  /// **'Showing sample care data'**
  String get sampleDataOn;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @comingNextPhase.
  ///
  /// In en, this message translates to:
  /// **'This section is being built next.'**
  String get comingNextPhase;

  /// No description provided for @fatherName.
  ///
  /// In en, this message translates to:
  /// **'Nanna'**
  String get fatherName;

  /// No description provided for @sampleTaskMorningMedicine.
  ///
  /// In en, this message translates to:
  /// **'Morning medicine'**
  String get sampleTaskMorningMedicine;

  /// No description provided for @sampleTaskRecordBp.
  ///
  /// In en, this message translates to:
  /// **'Record BP'**
  String get sampleTaskRecordBp;

  /// No description provided for @sampleTaskBloodTest.
  ///
  /// In en, this message translates to:
  /// **'Blood test'**
  String get sampleTaskBloodTest;

  /// No description provided for @sampleTaskDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Doctor appointment'**
  String get sampleTaskDoctorVisit;

  /// No description provided for @sampleMomentDoctorTalk.
  ///
  /// In en, this message translates to:
  /// **'Doctor conversation'**
  String get sampleMomentDoctorTalk;

  /// No description provided for @sampleMomentDoctorTalkDetail.
  ///
  /// In en, this message translates to:
  /// **'“Take the medicine after breakfast.”'**
  String get sampleMomentDoctorTalkDetail;

  /// No description provided for @sampleMomentPrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription scanned'**
  String get sampleMomentPrescription;

  /// No description provided for @sampleMomentPrescriptionDetail.
  ///
  /// In en, this message translates to:
  /// **'2 medicines found'**
  String get sampleMomentPrescriptionDetail;

  /// No description provided for @sampleMomentBp.
  ///
  /// In en, this message translates to:
  /// **'BP recorded'**
  String get sampleMomentBp;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @doctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Doctor visit'**
  String get doctorVisit;

  /// No description provided for @doctorVisitHint.
  ///
  /// In en, this message translates to:
  /// **'Note what the doctor says'**
  String get doctorVisitHint;

  /// No description provided for @askDoctor.
  ///
  /// In en, this message translates to:
  /// **'Questions for the doctor'**
  String get askDoctor;

  /// No description provided for @askDoctorHint.
  ///
  /// In en, this message translates to:
  /// **'Gurtu helps you prepare'**
  String get askDoctorHint;

  /// No description provided for @questionsReady.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question ready} other{{count} questions ready}}'**
  String questionsReady(int count);

  /// No description provided for @lastVisitOn.
  ///
  /// In en, this message translates to:
  /// **'Last visit: {date}'**
  String lastVisitOn(String date);

  /// No description provided for @nextVisitOn.
  ///
  /// In en, this message translates to:
  /// **'Next visit: {date}'**
  String nextVisitOn(String date);

  /// No description provided for @visitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor visits'**
  String get visitsTitle;

  /// No description provided for @visitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What every doctor said, kept in one place.'**
  String get visitsSubtitle;

  /// No description provided for @recordVisit.
  ///
  /// In en, this message translates to:
  /// **'Record a visit'**
  String get recordVisit;

  /// No description provided for @visitsOverview.
  ///
  /// In en, this message translates to:
  /// **'All visits at a glance'**
  String get visitsOverview;

  /// No description provided for @visitsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 visit} other{{count} visits}}'**
  String visitsCount(int count);

  /// No description provided for @doctorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 doctor} other{{count} doctors}}'**
  String doctorsCount(int count);

  /// No description provided for @lastVisit.
  ///
  /// In en, this message translates to:
  /// **'Last visit'**
  String get lastVisit;

  /// No description provided for @nextVisit.
  ///
  /// In en, this message translates to:
  /// **'Next visit'**
  String get nextVisit;

  /// No description provided for @notPlanned.
  ///
  /// In en, this message translates to:
  /// **'Not planned yet'**
  String get notPlanned;

  /// No description provided for @pastVisits.
  ///
  /// In en, this message translates to:
  /// **'Past visits'**
  String get pastVisits;

  /// No description provided for @noVisitsTitle.
  ///
  /// In en, this message translates to:
  /// **'No visits recorded yet'**
  String get noVisitsTitle;

  /// No description provided for @noVisitsBody.
  ///
  /// In en, this message translates to:
  /// **'At the next appointment, tap Record a visit and Gurtu will note what the doctor says.'**
  String get noVisitsBody;

  /// No description provided for @questionsForNextVisit.
  ///
  /// In en, this message translates to:
  /// **'Questions for the next visit'**
  String get questionsForNextVisit;

  /// No description provided for @prepareQuestionsHint.
  ///
  /// In en, this message translates to:
  /// **'Tell Gurtu how you feel. It will suggest what to ask the doctor.'**
  String get prepareQuestionsHint;

  /// No description provided for @prepareQuestions.
  ///
  /// In en, this message translates to:
  /// **'Prepare questions'**
  String get prepareQuestions;

  /// No description provided for @viewQuestions.
  ///
  /// In en, this message translates to:
  /// **'View questions'**
  String get viewQuestions;

  /// No description provided for @doctorFallback.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorFallback;

  /// No description provided for @doctorSaid.
  ///
  /// In en, this message translates to:
  /// **'What the doctor said'**
  String get doctorSaid;

  /// No description provided for @medicinesSection.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicinesSection;

  /// No description provided for @testsSection.
  ///
  /// In en, this message translates to:
  /// **'Tests to do'**
  String get testsSection;

  /// No description provided for @questionsAsked.
  ///
  /// In en, this message translates to:
  /// **'Questions asked'**
  String get questionsAsked;

  /// No description provided for @askedOf.
  ///
  /// In en, this message translates to:
  /// **'{asked} of {total} asked'**
  String askedOf(int asked, int total);

  /// No description provided for @deleteVisit.
  ///
  /// In en, this message translates to:
  /// **'Delete visit'**
  String get deleteVisit;

  /// No description provided for @deleteVisitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this visit? This cannot be undone.'**
  String get deleteVisitConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s name'**
  String get doctorName;

  /// No description provided for @doctorNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dr. Meena Rao'**
  String get doctorNameHint;

  /// No description provided for @visitReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for the visit'**
  String get visitReason;

  /// No description provided for @visitReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sugar check-up'**
  String get visitReasonHint;

  /// No description provided for @visitDate.
  ///
  /// In en, this message translates to:
  /// **'Date of visit'**
  String get visitDate;

  /// No description provided for @listenToDoctor.
  ///
  /// In en, this message translates to:
  /// **'Listen to the doctor'**
  String get listenToDoctor;

  /// No description provided for @stopListening.
  ///
  /// In en, this message translates to:
  /// **'Stop listening'**
  String get stopListening;

  /// No description provided for @speak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speak;

  /// No description provided for @recordingConsent.
  ///
  /// In en, this message translates to:
  /// **'Let the doctor know you are noting the conversation with Gurtu.'**
  String get recordingConsent;

  /// No description provided for @doctorSaidHint.
  ///
  /// In en, this message translates to:
  /// **'Speak or type what the doctor says'**
  String get doctorSaidHint;

  /// No description provided for @medicinesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Metformin 500 mg after breakfast'**
  String get medicinesHint;

  /// No description provided for @testsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. HbA1c blood test'**
  String get testsHint;

  /// No description provided for @addNextVisit.
  ///
  /// In en, this message translates to:
  /// **'Add next visit date'**
  String get addNextVisit;

  /// No description provided for @yourQuestions.
  ///
  /// In en, this message translates to:
  /// **'Your questions'**
  String get yourQuestions;

  /// No description provided for @tickWhenAsked.
  ///
  /// In en, this message translates to:
  /// **'Tick each one once the doctor has answered.'**
  String get tickWhenAsked;

  /// No description provided for @saveVisit.
  ///
  /// In en, this message translates to:
  /// **'Save visit'**
  String get saveVisit;

  /// No description provided for @visitSaved.
  ///
  /// In en, this message translates to:
  /// **'Visit saved'**
  String get visitSaved;

  /// No description provided for @leaveVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving?'**
  String get leaveVisitTitle;

  /// No description provided for @leaveVisitBody.
  ///
  /// In en, this message translates to:
  /// **'What you noted for this visit will be lost.'**
  String get leaveVisitBody;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @voiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice input isn\'t available right now. You can type instead.'**
  String get voiceUnavailable;

  /// No description provided for @prepTitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare for the doctor'**
  String get prepTitle;

  /// No description provided for @prepIntro.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get ready for the doctor. What health problems should we talk about?'**
  String get prepIntro;

  /// No description provided for @prepPickOrSay.
  ///
  /// In en, this message translates to:
  /// **'Tap the problems below, or say it in your own words.'**
  String get prepPickOrSay;

  /// No description provided for @prepDescribeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Headache for three days and feeling tired'**
  String get prepDescribeHint;

  /// No description provided for @prepHeard.
  ///
  /// In en, this message translates to:
  /// **'I heard: {symptoms}'**
  String prepHeard(String symptoms);

  /// No description provided for @askSince.
  ///
  /// In en, this message translates to:
  /// **'{symptom} — since when?'**
  String askSince(String symptom);

  /// No description provided for @askSeverity.
  ///
  /// In en, this message translates to:
  /// **'{symptom} — how bad is it?'**
  String askSeverity(String symptom);

  /// No description provided for @askNewMedicine.
  ///
  /// In en, this message translates to:
  /// **'Was any medicine started or changed recently?'**
  String get askNewMedicine;

  /// No description provided for @askAnythingElse.
  ///
  /// In en, this message translates to:
  /// **'Anything else the doctor should know?'**
  String get askAnythingElse;

  /// No description provided for @urgentWarning.
  ///
  /// In en, this message translates to:
  /// **'Severe chest pain or breathlessness can be an emergency. Don\'t wait for the appointment — get medical help now.'**
  String get urgentWarning;

  /// No description provided for @prepThinking.
  ///
  /// In en, this message translates to:
  /// **'Preparing your questions…'**
  String get prepThinking;

  /// No description provided for @prepResultIntro.
  ///
  /// In en, this message translates to:
  /// **'Here is what to ask the doctor. Remove any you don\'t need, or add your own.'**
  String get prepResultIntro;

  /// No description provided for @prepNotDoctor.
  ///
  /// In en, this message translates to:
  /// **'Gurtu is not a doctor. These questions help you talk to one.'**
  String get prepNotDoctor;

  /// No description provided for @addOwnQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add your own question'**
  String get addOwnQuestion;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @saveQuestions.
  ///
  /// In en, this message translates to:
  /// **'Save for the visit'**
  String get saveQuestions;

  /// No description provided for @questionsSaved.
  ///
  /// In en, this message translates to:
  /// **'Questions saved for the visit'**
  String get questionsSaved;

  /// No description provided for @startAgain.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get startAgain;

  /// No description provided for @startVisit.
  ///
  /// In en, this message translates to:
  /// **'Start the visit'**
  String get startVisit;

  /// No description provided for @deleteQuestions.
  ///
  /// In en, this message translates to:
  /// **'Delete these questions'**
  String get deleteQuestions;

  /// No description provided for @removeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove question'**
  String get removeQuestion;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @healthProblems.
  ///
  /// In en, this message translates to:
  /// **'Health problems'**
  String get healthProblems;

  /// No description provided for @preparedOn.
  ///
  /// In en, this message translates to:
  /// **'Prepared {date}'**
  String preparedOn(String date);

  /// No description provided for @symFever.
  ///
  /// In en, this message translates to:
  /// **'Fever'**
  String get symFever;

  /// No description provided for @symHeadache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get symHeadache;

  /// No description provided for @symBodyPain.
  ///
  /// In en, this message translates to:
  /// **'Body or joint pain'**
  String get symBodyPain;

  /// No description provided for @symChestPain.
  ///
  /// In en, this message translates to:
  /// **'Chest pain'**
  String get symChestPain;

  /// No description provided for @symBreathless.
  ///
  /// In en, this message translates to:
  /// **'Breathlessness'**
  String get symBreathless;

  /// No description provided for @symCough.
  ///
  /// In en, this message translates to:
  /// **'Cough'**
  String get symCough;

  /// No description provided for @symDizziness.
  ///
  /// In en, this message translates to:
  /// **'Dizziness'**
  String get symDizziness;

  /// No description provided for @symTiredness.
  ///
  /// In en, this message translates to:
  /// **'Tiredness'**
  String get symTiredness;

  /// No description provided for @symStomach.
  ///
  /// In en, this message translates to:
  /// **'Stomach trouble'**
  String get symStomach;

  /// No description provided for @symPoorSleep.
  ///
  /// In en, this message translates to:
  /// **'Poor sleep'**
  String get symPoorSleep;

  /// No description provided for @symPoorAppetite.
  ///
  /// In en, this message translates to:
  /// **'Low appetite'**
  String get symPoorAppetite;

  /// No description provided for @symLowMood.
  ///
  /// In en, this message translates to:
  /// **'Low mood or worry'**
  String get symLowMood;

  /// No description provided for @kwFever.
  ///
  /// In en, this message translates to:
  /// **'fever,temperature,feverish,chills'**
  String get kwFever;

  /// No description provided for @kwHeadache.
  ///
  /// In en, this message translates to:
  /// **'headache,head ache,head pain,migraine'**
  String get kwHeadache;

  /// No description provided for @kwBodyPain.
  ///
  /// In en, this message translates to:
  /// **'body pain,joint pain,knee,back pain,leg pain,aches'**
  String get kwBodyPain;

  /// No description provided for @kwChestPain.
  ///
  /// In en, this message translates to:
  /// **'chest pain,chest,heart pain'**
  String get kwChestPain;

  /// No description provided for @kwBreathless.
  ///
  /// In en, this message translates to:
  /// **'breathless,short of breath,breathing,breath'**
  String get kwBreathless;

  /// No description provided for @kwCough.
  ///
  /// In en, this message translates to:
  /// **'cough,cold,phlegm'**
  String get kwCough;

  /// No description provided for @kwDizziness.
  ///
  /// In en, this message translates to:
  /// **'dizzy,dizziness,giddy,faint'**
  String get kwDizziness;

  /// No description provided for @kwTiredness.
  ///
  /// In en, this message translates to:
  /// **'tired,weak,weakness,fatigue'**
  String get kwTiredness;

  /// No description provided for @kwStomach.
  ///
  /// In en, this message translates to:
  /// **'stomach,acidity,gas,vomit,loose motion,diarrhoea,constipation,nausea'**
  String get kwStomach;

  /// No description provided for @kwPoorSleep.
  ///
  /// In en, this message translates to:
  /// **'sleep,insomnia'**
  String get kwPoorSleep;

  /// No description provided for @kwPoorAppetite.
  ///
  /// In en, this message translates to:
  /// **'appetite,not eating,no hunger'**
  String get kwPoorAppetite;

  /// No description provided for @kwLowMood.
  ///
  /// In en, this message translates to:
  /// **'sad,worried,anxious,anxiety,depressed,stress,tension,feeling low,feel low,hopeless'**
  String get kwLowMood;

  /// No description provided for @sinceToday.
  ///
  /// In en, this message translates to:
  /// **'Since today'**
  String get sinceToday;

  /// No description provided for @sinceFewDays.
  ///
  /// In en, this message translates to:
  /// **'A few days'**
  String get sinceFewDays;

  /// No description provided for @sinceWeek.
  ///
  /// In en, this message translates to:
  /// **'About a week'**
  String get sinceWeek;

  /// No description provided for @sinceMonth.
  ///
  /// In en, this message translates to:
  /// **'A month or more'**
  String get sinceMonth;

  /// No description provided for @sevMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get sevMild;

  /// No description provided for @sevModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get sevModerate;

  /// No description provided for @sevSevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get sevSevere;

  /// No description provided for @qCause.
  ///
  /// In en, this message translates to:
  /// **'What could be causing the {symptom}?'**
  String qCause(String symptom);

  /// No description provided for @qTests.
  ///
  /// In en, this message translates to:
  /// **'Does the {symptom} need any tests?'**
  String qTests(String symptom);

  /// No description provided for @qWarningSigns.
  ///
  /// In en, this message translates to:
  /// **'Which signs with the {symptom} mean we should come back straight away?'**
  String qWarningSigns(String symptom);

  /// No description provided for @qHomeCare.
  ///
  /// In en, this message translates to:
  /// **'What can we do at home to ease the {symptom}?'**
  String qHomeCare(String symptom);

  /// No description provided for @qConditionLink.
  ///
  /// In en, this message translates to:
  /// **'Could the {symptom} be linked to {conditions}?'**
  String qConditionLink(String symptom, String conditions);

  /// No description provided for @qSideEffect.
  ///
  /// In en, this message translates to:
  /// **'Could a new or changed medicine be causing any of this?'**
  String get qSideEffect;

  /// No description provided for @qMedicinesStillRight.
  ///
  /// In en, this message translates to:
  /// **'Are the current medicines still right, or should any change?'**
  String get qMedicinesStillRight;

  /// No description provided for @qNextCheckup.
  ///
  /// In en, this message translates to:
  /// **'When should we come back for a check-up?'**
  String get qNextCheckup;

  /// No description provided for @qTellDoctor.
  ///
  /// In en, this message translates to:
  /// **'Tell the doctor: “{text}”'**
  String qTellDoctor(String text);

  /// No description provided for @sampleVisitDiabetesReason.
  ///
  /// In en, this message translates to:
  /// **'Diabetes review'**
  String get sampleVisitDiabetesReason;

  /// No description provided for @sampleVisitDiabetesNotes.
  ///
  /// In en, this message translates to:
  /// **'Sugar is better controlled. Continue the same medicines. Walk for 30 minutes every day and cut down on sweets.'**
  String get sampleVisitDiabetesNotes;

  /// No description provided for @sampleVisitDiabetesMeds.
  ///
  /// In en, this message translates to:
  /// **'Metformin 500 mg after breakfast and dinner'**
  String get sampleVisitDiabetesMeds;

  /// No description provided for @sampleVisitDiabetesTests.
  ///
  /// In en, this message translates to:
  /// **'HbA1c blood test before the next visit'**
  String get sampleVisitDiabetesTests;

  /// No description provided for @sampleVisitKneeReason.
  ///
  /// In en, this message translates to:
  /// **'Knee pain'**
  String get sampleVisitKneeReason;

  /// No description provided for @sampleVisitKneeNotes.
  ///
  /// In en, this message translates to:
  /// **'Mild arthritis in the right knee. Use a warm compress in the evening and avoid too many stairs.'**
  String get sampleVisitKneeNotes;

  /// No description provided for @sampleVisitKneeMeds.
  ///
  /// In en, this message translates to:
  /// **'Pain relief gel twice a day'**
  String get sampleVisitKneeMeds;

  /// No description provided for @scanVerify.
  ///
  /// In en, this message translates to:
  /// **'Scan & verify medicine'**
  String get scanVerify;

  /// No description provided for @scanVerifyHint.
  ///
  /// In en, this message translates to:
  /// **'Is this the right tablet, right now?'**
  String get scanVerifyHint;

  /// No description provided for @scanVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the strip or box. Gurtu checks it against {name}\'s medicine list.'**
  String scanVerifySubtitle(String name);

  /// No description provided for @scanWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan the medicine'**
  String get scanWithCamera;

  /// No description provided for @orTypeName.
  ///
  /// In en, this message translates to:
  /// **'Or type the name printed on the strip'**
  String get orTypeName;

  /// No description provided for @typeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Glycomet 500'**
  String get typeNameHint;

  /// No description provided for @checkMedicine.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkMedicine;

  /// No description provided for @checkAnother.
  ///
  /// In en, this message translates to:
  /// **'Check another medicine'**
  String get checkAnother;

  /// No description provided for @readingStrip.
  ///
  /// In en, this message translates to:
  /// **'Reading the strip…'**
  String get readingStrip;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera scanning works in the phone app. Type the name instead.'**
  String get cameraUnavailable;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read the photo. Try again, or type the name.'**
  String get scanFailed;

  /// No description provided for @readFromStrip.
  ///
  /// In en, this message translates to:
  /// **'Read from the strip: “{text}”'**
  String readFromStrip(String text);

  /// No description provided for @verifyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Gurtu only checks against the medicines you saved. It never suggests medicines.'**
  String get verifyDisclaimer;

  /// No description provided for @verdictTakeNow.
  ///
  /// In en, this message translates to:
  /// **'Yes — this is the right medicine to take now.'**
  String get verdictTakeNow;

  /// No description provided for @verdictNotNow.
  ///
  /// In en, this message translates to:
  /// **'Right medicine, but it\'s not due now.'**
  String get verdictNotNow;

  /// No description provided for @verdictAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'Already taken. Don\'t take it again now.'**
  String get verdictAlreadyTaken;

  /// No description provided for @verdictNoTimes.
  ///
  /// In en, this message translates to:
  /// **'Right medicine, but no time is saved for it.'**
  String get verdictNoTimes;

  /// No description provided for @verdictWrongStrength.
  ///
  /// In en, this message translates to:
  /// **'Stop — the strength is different from the prescription.'**
  String get verdictWrongStrength;

  /// No description provided for @verdictNotOnList.
  ///
  /// In en, this message translates to:
  /// **'Stop — this medicine is not on {name}\'s list.'**
  String verdictNotOnList(String name);

  /// No description provided for @verdictOtherPatient.
  ///
  /// In en, this message translates to:
  /// **'Stop — this medicine is on {other}\'s list, not {name}\'s.'**
  String verdictOtherPatient(String other, String name);

  /// No description provided for @verdictUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read a medicine name. Try again in good light, or type it.'**
  String get verdictUnreadable;

  /// No description provided for @verdictCheckFirst.
  ///
  /// In en, this message translates to:
  /// **'Don\'t take it until you check with the doctor or pharmacist.'**
  String get verdictCheckFirst;

  /// No description provided for @rowOnList.
  ///
  /// In en, this message translates to:
  /// **'On the medicine list'**
  String get rowOnList;

  /// No description provided for @rowStrengthMatches.
  ///
  /// In en, this message translates to:
  /// **'Strength matches: {strength}'**
  String rowStrengthMatches(String strength);

  /// No description provided for @rowStrengthDiffers.
  ///
  /// In en, this message translates to:
  /// **'Strip says {found}, prescription says {prescribed}'**
  String rowStrengthDiffers(String found, String prescribed);

  /// No description provided for @rowDueNow.
  ///
  /// In en, this message translates to:
  /// **'Due now: {slot} dose'**
  String rowDueNow(String slot);

  /// No description provided for @rowTakenAt.
  ///
  /// In en, this message translates to:
  /// **'{slot} dose taken at {time}'**
  String rowTakenAt(String slot, String time);

  /// No description provided for @rowNextDose.
  ///
  /// In en, this message translates to:
  /// **'Next dose: {slot}'**
  String rowNextDose(String slot);

  /// No description provided for @rowSetTimes.
  ///
  /// In en, this message translates to:
  /// **'Add when to take it on the medicine list'**
  String get rowSetTimes;

  /// No description provided for @markTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark as taken'**
  String get markTaken;

  /// No description provided for @markedTaken.
  ///
  /// In en, this message translates to:
  /// **'Marked as taken'**
  String get markedTaken;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @medicineList.
  ///
  /// In en, this message translates to:
  /// **'Medicine list'**
  String get medicineList;

  /// No description provided for @medicineListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every medicine from the prescriptions, with when to take it.'**
  String get medicineListSubtitle;

  /// No description provided for @medicinesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 medicine} other{{count} medicines}}'**
  String medicinesCount(int count);

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get addMedicine;

  /// No description provided for @editMedicine.
  ///
  /// In en, this message translates to:
  /// **'Edit medicine'**
  String get editMedicine;

  /// No description provided for @addFromPrescription.
  ///
  /// In en, this message translates to:
  /// **'Add from a prescription photo'**
  String get addFromPrescription;

  /// No description provided for @noMedicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'No medicines added yet'**
  String get noMedicinesTitle;

  /// No description provided for @noMedicinesBody.
  ///
  /// In en, this message translates to:
  /// **'Add each medicine from the prescription once. Then scan any strip to check it\'s the right one.'**
  String get noMedicinesBody;

  /// No description provided for @addMedicinesFirst.
  ///
  /// In en, this message translates to:
  /// **'Add {name}\'s medicines first, so Gurtu has something to check against.'**
  String addMedicinesFirst(String name);

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get medicineName;

  /// No description provided for @medicineNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Metformin'**
  String get medicineNameHint;

  /// No description provided for @alsoCalled.
  ///
  /// In en, this message translates to:
  /// **'Other name on the strip'**
  String get alsoCalled;

  /// No description provided for @alsoCalledHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Glycomet'**
  String get alsoCalledHint;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @strengthHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500 mg'**
  String get strengthHint;

  /// No description provided for @whenToTake.
  ///
  /// In en, this message translates to:
  /// **'When to take it'**
  String get whenToTake;

  /// No description provided for @doseMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get doseMorning;

  /// No description provided for @doseAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get doseAfternoon;

  /// No description provided for @doseEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get doseEvening;

  /// No description provided for @doseNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get doseNight;

  /// No description provided for @foodAfter.
  ///
  /// In en, this message translates to:
  /// **'After food'**
  String get foodAfter;

  /// No description provided for @foodBefore.
  ///
  /// In en, this message translates to:
  /// **'Before food'**
  String get foodBefore;

  /// No description provided for @foodAny.
  ///
  /// In en, this message translates to:
  /// **'With or without food'**
  String get foodAny;

  /// No description provided for @saveMedicine.
  ///
  /// In en, this message translates to:
  /// **'Save medicine'**
  String get saveMedicine;

  /// No description provided for @medicineSaved.
  ///
  /// In en, this message translates to:
  /// **'Medicine saved'**
  String get medicineSaved;

  /// No description provided for @deleteMedicine.
  ///
  /// In en, this message translates to:
  /// **'Delete medicine'**
  String get deleteMedicine;

  /// No description provided for @deleteMedicineConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this medicine from the list?'**
  String get deleteMedicineConfirm;

  /// No description provided for @scanToFill.
  ///
  /// In en, this message translates to:
  /// **'Scan the strip to fill this in'**
  String get scanToFill;

  /// No description provided for @timesNotSet.
  ///
  /// In en, this message translates to:
  /// **'Times not set'**
  String get timesNotSet;

  /// No description provided for @takenToday.
  ///
  /// In en, this message translates to:
  /// **'Taken today'**
  String get takenToday;

  /// No description provided for @prescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Add from a prescription'**
  String get prescriptionTitle;

  /// No description provided for @prescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of a printed prescription. Gurtu finds the medicines; you choose which to add.'**
  String get prescriptionHint;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @medicinesFound.
  ///
  /// In en, this message translates to:
  /// **'Medicines found'**
  String get medicinesFound;

  /// No description provided for @tickToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tick the ones to add. Check each name and time against the prescription.'**
  String get tickToAdd;

  /// No description provided for @addSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add 1 medicine} other{Add {count} medicines}}'**
  String addSelected(int count);

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'No medicines found. Try a clearer photo, or add them by hand.'**
  String get nothingFound;

  /// No description provided for @handwrittenNote.
  ///
  /// In en, this message translates to:
  /// **'Handwritten prescriptions may not read well. Check every name.'**
  String get handwrittenNote;

  /// No description provided for @medicinesAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 medicine added} other{{count} medicines added}}'**
  String medicinesAdded(int count);

  /// No description provided for @rowStrengthCheck.
  ///
  /// In en, this message translates to:
  /// **'Check the strip says {strength}'**
  String rowStrengthCheck(String strength);

  /// No description provided for @aiPerkPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private: what you say stays on this phone'**
  String get aiPerkPrivate;

  /// No description provided for @aiPerkOffline.
  ///
  /// In en, this message translates to:
  /// **'Works without internet once set up'**
  String get aiPerkOffline;

  /// No description provided for @aiPerkQuestions.
  ///
  /// In en, this message translates to:
  /// **'Writes doctor questions for your situation'**
  String get aiPerkQuestions;

  /// No description provided for @aiRunsOnNpu.
  ///
  /// In en, this message translates to:
  /// **'Runs on your phone\'s AI chip (NPU)'**
  String get aiRunsOnNpu;

  /// No description provided for @aiRunsOnGpu.
  ///
  /// In en, this message translates to:
  /// **'Runs on your phone\'s graphics chip (GPU)'**
  String get aiRunsOnGpu;

  /// No description provided for @aiRunsOnCpu.
  ///
  /// In en, this message translates to:
  /// **'Runs on your phone\'s processor'**
  String get aiRunsOnCpu;

  /// No description provided for @aiStepCheck.
  ///
  /// In en, this message translates to:
  /// **'Checking your phone'**
  String get aiStepCheck;

  /// No description provided for @aiStepDownload.
  ///
  /// In en, this message translates to:
  /// **'Downloading Gurtu AI'**
  String get aiStepDownload;

  /// No description provided for @aiStepReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to help'**
  String get aiStepReady;

  /// No description provided for @aiInstall.
  ///
  /// In en, this message translates to:
  /// **'Set up Gurtu AI · {size}'**
  String aiInstall(String size);

  /// No description provided for @aiContinueInBackground.
  ///
  /// In en, this message translates to:
  /// **'Continue, finish in background'**
  String get aiContinueInBackground;

  /// No description provided for @aiProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String aiProgress(String done, String total);

  /// No description provided for @aiWaitingWifi.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Wi-Fi. The download starts as soon as you connect.'**
  String get aiWaitingWifi;

  /// No description provided for @aiUseMobileData.
  ///
  /// In en, this message translates to:
  /// **'Use mobile data now'**
  String get aiUseMobileData;

  /// No description provided for @aiFailedNetwork.
  ///
  /// In en, this message translates to:
  /// **'The download stopped. Check your internet and try again.'**
  String get aiFailedNetwork;

  /// No description provided for @aiFailedSpace.
  ///
  /// In en, this message translates to:
  /// **'Not enough space on the phone. Free up {size} and try again.'**
  String aiFailedSpace(String size);

  /// No description provided for @aiRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get aiRetry;

  /// No description provided for @aiUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This phone can\'t run Gurtu AI. Gurtu still helps using its built-in guidance.'**
  String get aiUnsupported;

  /// No description provided for @aiDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get aiDetails;

  /// No description provided for @aiDetailModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get aiDetailModel;

  /// No description provided for @aiDetailSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get aiDetailSize;

  /// No description provided for @aiDetailChip.
  ///
  /// In en, this message translates to:
  /// **'Runs on'**
  String get aiDetailChip;

  /// No description provided for @aiDetailPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get aiDetailPhone;

  /// No description provided for @aiStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready · runs on this phone'**
  String get aiStatusReady;

  /// No description provided for @aiStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Not set up. Gurtu uses its built-in guidance.'**
  String get aiStatusOff;

  /// No description provided for @aiStatusDownloading.
  ///
  /// In en, this message translates to:
  /// **'Setting up · {percent}%'**
  String aiStatusDownloading(int percent);

  /// No description provided for @aiStatusChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get aiStatusChecking;

  /// No description provided for @aiRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Gurtu AI from this phone?'**
  String get aiRemoveTitle;

  /// No description provided for @aiRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'This frees {size}. You can set it up again any time.'**
  String aiRemoveBody(String size);

  /// No description provided for @aiSetUpForPrep.
  ///
  /// In en, this message translates to:
  /// **'Set up Gurtu AI to get questions written for your situation.'**
  String get aiSetUpForPrep;

  /// No description provided for @prepUnderstanding.
  ///
  /// In en, this message translates to:
  /// **'Understanding what you said…'**
  String get prepUnderstanding;

  /// No description provided for @prepByAi.
  ///
  /// In en, this message translates to:
  /// **'Written by Gurtu AI on this phone. Check anything unclear with your doctor.'**
  String get prepByAi;

  /// No description provided for @prepByRules.
  ///
  /// In en, this message translates to:
  /// **'From Gurtu\'s built-in guidance.'**
  String get prepByRules;

  /// No description provided for @prepSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell the doctor'**
  String get prepSummaryTitle;

  /// No description provided for @prepSummaryHint.
  ///
  /// In en, this message translates to:
  /// **'Show or read this to the doctor at the start of the visit.'**
  String get prepSummaryHint;

  /// No description provided for @prepReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Or type or say your answer'**
  String get prepReplyHint;

  /// No description provided for @prepResultIntroAi.
  ///
  /// In en, this message translates to:
  /// **'Ask these during the visit, so you both leave knowing what the problem is and what to do. Remove any you don\'t need, or add your own.'**
  String get prepResultIntroAi;

  /// No description provided for @topicUnderstand.
  ///
  /// In en, this message translates to:
  /// **'Understand the problem'**
  String get topicUnderstand;

  /// No description provided for @topicTests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get topicTests;

  /// No description provided for @topicTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment and medicines'**
  String get topicTreatment;

  /// No description provided for @topicHome.
  ///
  /// In en, this message translates to:
  /// **'Care at home'**
  String get topicHome;

  /// No description provided for @topicFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Warning signs and next visit'**
  String get topicFollowUp;

  /// No description provided for @topicOwn.
  ///
  /// In en, this message translates to:
  /// **'Your own questions'**
  String get topicOwn;

  /// No description provided for @urgentAnswer.
  ///
  /// In en, this message translates to:
  /// **'This can be serious. Don\'t wait for the appointment — get medical help now, or call 108 for an ambulance.'**
  String get urgentAnswer;

  /// No description provided for @urgentSelfHarm.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have to face this alone. Please talk to someone now: call Tele-MANAS on 14416 (free, any time), or go to the nearest hospital.'**
  String get urgentSelfHarm;

  /// No description provided for @prepInTheirWords.
  ///
  /// In en, this message translates to:
  /// **'In your words'**
  String get prepInTheirWords;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'as',
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'or',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
