import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Gurtu design tokens.
///
/// Light, airy surfaces with a Gurtu purple primary and the iQOO amber accent,
/// using OriginOS-style large radii, bold left-aligned titles and pill buttons.
class GurtuColors {
  GurtuColors._();

  static const background = Color(0xFFF6F5FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceHigh = Color(0xFFF0EEF7);
  static const outline = Color(0xFFE4E1EE);

  static const primary = Color(0xFF6A4DF4);
  static const primaryDeep = Color(0xFF4F36C9);
  static const primarySoft = Color(0xFFEFEBFF);

  /// iQOO brand amber → orange, for fills and gradients.
  static const amberBright = Color(0xFFFFC23D);
  static const orange = Color(0xFFFF7A1A);

  /// Deeper amber that stays readable as text / icons on white.
  static const amber = Color(0xFFA86300);

  static const leaf = Color(0xFF2E9D57);
  static const danger = Color(0xFFE5484D);
  static const info = Color(0xFF1F7FD1);

  static const textPrimary = Color(0xFF17142A);
  static const textSecondary = Color(0xFF545070);
  static const textMuted = Color(0xFF8C88A3);

  /// Wordmark ink.
  static const logo = Color(0xFF2A1F4E);

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF8468FF), Color(0xFF5A3FDB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const iqooGradient = LinearGradient(
    colors: [amberBright, orange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class GurtuSpace {
  GurtuSpace._();

  static const gutter = 20.0;
  static const radiusSm = 14.0;
  static const radius = 20.0;
  static const radiusLg = 28.0;
}

class GurtuFonts {
  GurtuFonts._();

  static const sans = 'PlusJakartaSans';
  static const script = 'Caveat';

  /// Handwritten accent line. Caveat only covers Latin, so other scripts get
  /// a softer italic of the system font instead of an oversized fallback.
  static TextStyle handwritten(BuildContext context, {required Color color}) {
    final latin = Localizations.localeOf(context).languageCode == 'en';
    return latin
        ? TextStyle(fontFamily: script, fontSize: 26, color: color)
        : TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: color,
          );
  }
}

ThemeData buildGurtuTheme() {
  const scheme = ColorScheme.light(
    primary: GurtuColors.primary,
    onPrimary: Colors.white,
    secondary: GurtuColors.amberBright,
    onSecondary: Color(0xFF1A1200),
    surface: GurtuColors.surface,
    onSurface: GurtuColors.textPrimary,
    error: GurtuColors.danger,
    outline: GurtuColors.outline,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,
    fontFamily: GurtuFonts.sans,
    scaffoldBackgroundColor: GurtuColors.background,
  );

  // Sizes are deliberately generous: many Gurtu users are elderly patients.
  final text = base.textTheme.copyWith(
    displaySmall: const TextStyle(
      fontSize: 34,
      height: 1.15,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.6,
      color: GurtuColors.textPrimary,
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      height: 1.2,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.4,
      color: GurtuColors.textPrimary,
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: GurtuColors.textPrimary,
    ),
    titleMedium: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: GurtuColors.textPrimary,
    ),
    bodyLarge: const TextStyle(
      fontSize: 17,
      height: 1.45,
      fontWeight: FontWeight.w500,
      color: GurtuColors.textSecondary,
    ),
    bodyMedium: const TextStyle(
      fontSize: 15,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: GurtuColors.textSecondary,
    ),
    bodySmall: const TextStyle(
      fontSize: 13,
      height: 1.35,
      fontWeight: FontWeight.w500,
      color: GurtuColors.textMuted,
    ),
    labelLarge: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
    ),
    labelSmall: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: GurtuColors.textMuted,
    ),
  );

  return base.copyWith(
    textTheme: text,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GurtuColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      hintStyle: const TextStyle(color: GurtuColors.textMuted, fontSize: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        borderSide: const BorderSide(color: GurtuColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        borderSide: const BorderSide(color: GurtuColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        borderSide: const BorderSide(color: GurtuColors.primary, width: 2),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? Colors.white
            : GurtuColors.textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? GurtuColors.primary
            : GurtuColors.outline,
      ),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: GurtuColors.textPrimary,
      contentTextStyle: const TextStyle(
        fontFamily: GurtuFonts.sans,
        color: Colors.white,
        fontSize: 15,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
      ),
    ),
  );
}
