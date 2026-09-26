import '../data/medicine_models.dart';
import '../l10n/language.dart';

/// Localized labels for the medicine list. Medicine names are shown exactly
/// as saved; drug names read the same in every language.
extension MedicineText on AppLocalizations {
  String doseLabel(DoseTime t) => switch (t) {
    DoseTime.morning => doseMorning,
    DoseTime.afternoon => doseAfternoon,
    DoseTime.evening => doseEvening,
    DoseTime.night => doseNight,
  };

  String foodLabel(FoodTiming f) => switch (f) {
    FoodTiming.afterFood => foodAfter,
    FoodTiming.beforeFood => foodBefore,
    FoodTiming.any => foodAny,
  };
}
