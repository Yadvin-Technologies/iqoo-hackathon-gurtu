import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// Languages Gurtu speaks. Order is how they appear on the picker.
enum AppLanguage {
  english('en', 'English', 'English', 'Aa'),
  hindi('hi', 'हिन्दी', 'Hindi', 'हि'),
  telugu('te', 'తెలుగు', 'Telugu', 'తె'),
  tamil('ta', 'தமிழ்', 'Tamil', 'த'),
  kannada('kn', 'ಕನ್ನಡ', 'Kannada', 'ಕ'),
  malayalam('ml', 'മലയാളം', 'Malayalam', 'മ'),
  marathi('mr', 'मराठी', 'Marathi', 'म'),
  bengali('bn', 'বাংলা', 'Bengali', 'বা'),
  gujarati('gu', 'ગુજરાતી', 'Gujarati', 'ગુ'),
  punjabi('pa', 'ਪੰਜਾਬੀ', 'Punjabi', 'ਪੰ'),
  odia('or', 'ଓଡ଼ିଆ', 'Odia', 'ଓ'),
  assamese('as', 'অসমীয়া', 'Assamese', 'অ');

  const AppLanguage(this.code, this.nativeName, this.englishName, this.glyph);

  final String code;
  final String nativeName;
  final String englishName;

  /// First letter of the native name, shown large on the picker.
  final String glyph;

  Locale get locale => Locale(code);

  static AppLanguage? fromCode(String? code) {
    for (final l in values) {
      if (l.code == code) return l;
    }
    return null;
  }
}

/// Holds the app language, saves it, and drives [MaterialApp.locale].
class LanguageController extends ValueNotifier<AppLanguage> {
  LanguageController(this._prefs) : super(_initial(_prefs));

  static const _key = 'app_language';
  final SharedPreferences _prefs;

  /// Saved choice first, then the phone's language if Gurtu supports it.
  static AppLanguage _initial(SharedPreferences prefs) {
    final saved = AppLanguage.fromCode(prefs.getString(_key));
    if (saved != null) return saved;
    for (final locale in WidgetsBinding.instance.platformDispatcher.locales) {
      final match = AppLanguage.fromCode(locale.languageCode);
      if (match != null) return match;
    }
    return AppLanguage.english;
  }

  void select(AppLanguage language) {
    value = language;
    _prefs.setString(_key, language.code);
  }
}

class LanguageScope extends InheritedNotifier<LanguageController> {
  const LanguageScope({
    super.key,
    required LanguageController controller,
    required super.child,
  }) : super(notifier: controller);

  static LanguageController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LanguageScope>()!.notifier!;
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
