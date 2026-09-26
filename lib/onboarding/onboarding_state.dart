import 'package:flutter/material.dart';

import '../l10n/language.dart';

// Answers are stored as enums, never as display text, so they read correctly
// in whichever language the app is switched to. Labels live in l10n.

/// Who the person setting up the app is caring for.
enum CareFor {
  myself(Icons.person_rounded),
  parent(Icons.elderly_rounded),
  partner(Icons.favorite_rounded),
  child(Icons.child_care_rounded),
  other(Icons.people_rounded);

  const CareFor(this.icon);
  final IconData icon;

  String label(AppLocalizations l) => switch (this) {
    myself => l.careForMyself,
    parent => l.careForParent,
    partner => l.careForPartner,
    child => l.careForChild,
    other => l.careForOther,
  };

  String hint(AppLocalizations l) => switch (this) {
    myself => l.careForMyselfHint,
    parent => l.careForParentHint,
    partner => l.careForPartnerHint,
    child => l.careForChildHint,
    other => l.careForOtherHint,
  };
}

enum Gender { female, male, other }

enum YesNoUnsure {
  yes,
  no,
  unsure;

  String label(AppLocalizations l) => switch (this) {
    yes => l.yes,
    no => l.no,
    unsure => l.notSure,
  };
}

enum HealthCondition {
  diabetes,
  highBp,
  heart,
  thyroid,
  cholesterol,
  asthma,
  kidney,
  arthritis,
  stroke,
  cancer,
  none;

  String label(AppLocalizations l) => switch (this) {
    diabetes => l.condDiabetes,
    highBp => l.condHighBp,
    heart => l.condHeart,
    thyroid => l.condThyroid,
    cholesterol => l.condCholesterol,
    asthma => l.condAsthma,
    kidney => l.condKidney,
    arthritis => l.condArthritis,
    stroke => l.condStroke,
    cancer => l.condCancer,
    none => l.noneOfThese,
  };
}

enum Allergy {
  none,
  penicillin,
  sulfa,
  aspirin,
  food,
  dust,
  latex,
  unsure;

  String label(AppLocalizations l) => switch (this) {
    none => l.allergyNone,
    penicillin => l.allergyPenicillin,
    sulfa => l.allergySulfa,
    aspirin => l.allergyAspirin,
    food => l.allergyFood,
    dust => l.allergyDust,
    latex => l.allergyLatex,
    unsure => l.notSure,
  };
}

enum MedicineCount {
  oneTwo,
  threeFive,
  sixPlus;

  String label(AppLocalizations l) => switch (this) {
    oneTwo => '1 – 2',
    threeFive => '3 – 5',
    sixPlus => l.sixOrMore,
  };
}

enum Mobility {
  independent(Icons.directions_walk_rounded),
  someHelp(Icons.accessibility_new_rounded),
  fullHelp(Icons.accessible_rounded);

  const Mobility(this.icon);
  final IconData icon;

  String label(AppLocalizations l) => switch (this) {
    independent => l.mobilityIndependent,
    someHelp => l.mobilitySomeHelp,
    fullHelp => l.mobilityFullHelp,
  };

  String hint(AppLocalizations l) => switch (this) {
    independent => l.mobilityIndependentHint,
    someHelp => l.mobilitySomeHelpHint,
    fullHelp => l.mobilityFullHelpHint,
  };
}

/// Size tier for the on-device care model.
enum ModelTier {
  lite,
  balanced,
  pro;

  String label(AppLocalizations l) => switch (this) {
    lite => l.tierLite,
    balanced => l.tierBalanced,
    pro => l.tierPro,
  };

  String note(AppLocalizations l) => switch (this) {
    lite => l.tierLiteNote,
    balanced => l.tierBalancedNote,
    pro => l.tierProNote,
  };
}

/// Everything collected during onboarding. Kept in memory for now; later
/// sections (Care Circle, Care Plan) read from this. The app language lives
/// in [LanguageController] because it applies outside onboarding too.
class OnboardingState extends ChangeNotifier {
  CareFor? careFor;
  String patientName = '';
  String yourName = '';
  int? age;
  Gender? gender;

  final Set<HealthCondition> conditions = {};
  YesNoUnsure? takesMedicines;
  MedicineCount? medicineCount;
  final Set<Allergy> allergies = {};
  Mobility? mobility;
  YesNoUnsure? recentHospitalVisit;

  final Map<String, bool> permissions = {};

  ModelTier modelTier = ModelTier.balanced;
  bool wifiOnly = true;

  bool get isForSelf => careFor == CareFor.myself;

  String get patientLabel => patientName.trim();

  void update(VoidCallback change) {
    change();
    notifyListeners();
  }

  /// Toggles [value]; [exclusive] (e.g. "None of these") clears the others.
  void toggle<T>(Set<T> set, T value, {T? exclusive}) {
    if (value == exclusive) {
      final had = set.contains(value);
      set.clear();
      if (!had) set.add(value);
    } else {
      set.remove(exclusive);
      set.contains(value) ? set.remove(value) : set.add(value);
    }
    notifyListeners();
  }
}

class OnboardingScope extends InheritedNotifier<OnboardingState> {
  const OnboardingScope({
    super.key,
    required OnboardingState state,
    required super.child,
  }) : super(notifier: state);

  static OnboardingState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<OnboardingScope>()!.notifier!;
}
