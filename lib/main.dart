import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/care_repository.dart';
import 'l10n/language.dart';
import 'onboarding/onboarding_flow.dart';
import 'onboarding/onboarding_state.dart';
import 'shell/app_shell.dart';
import 'theme/gurtu_theme.dart';

const _onboardedKey = 'onboarding_complete';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: GurtuColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  final prefs = await SharedPreferences.getInstance();
  runApp(GurtuApp(prefs: prefs));
}

class GurtuApp extends StatefulWidget {
  const GurtuApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<GurtuApp> createState() => _GurtuAppState();
}

class _GurtuAppState extends State<GurtuApp> {
  late final _language = LanguageController(widget.prefs);
  late final _care = CareRepository(widget.prefs);

  // Builds from before patient data was saved have no patient: onboard again.
  late bool _onboarded =
      (widget.prefs.getBool(_onboardedKey) ?? false) && _care.hasPatient;

  void _finishOnboarding(OnboardingState data) {
    _care.createFromOnboarding(data);
    widget.prefs.setBool(_onboardedKey, true);
    setState(() => _onboarded = true);
  }

  void _restartOnboarding() {
    _care.clear();
    widget.prefs.setBool(_onboardedKey, false);
    setState(() => _onboarded = false);
  }

  @override
  void dispose() {
    _language.dispose();
    _care.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilding MaterialApp with a new locale re-renders every screen in the
    // chosen language immediately.
    return CareScope(
      repository: _care,
      child: LanguageScope(
        controller: _language,
        child: ValueListenableBuilder<AppLanguage>(
          valueListenable: _language,
          builder: (context, language, _) => MaterialApp(
            onGenerateTitle: (context) => 'Gurtu',
            debugShowCheckedModeBanner: false,
            theme: buildGurtuTheme(),
            locale: language.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _onboarded
                  ? AppShell(
                      key: const ValueKey('app'),
                      onRestartOnboarding: _restartOnboarding,
                    )
                  : OnboardingFlow(
                      key: const ValueKey('onboarding'),
                      onFinished: _finishOnboarding,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
