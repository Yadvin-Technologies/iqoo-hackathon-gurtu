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
