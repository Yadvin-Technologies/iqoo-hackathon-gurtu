import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ai/on_device_ai.dart';
import 'cloud/cloud_models.dart';
import 'cloud/cloud_sync.dart';
import 'cloud/push_service.dart';
import 'data/attachment_store.dart';
import 'data/care_repository.dart';
import 'l10n/language.dart';
import 'onboarding/onboarding_flow.dart';
import 'onboarding/onboarding_state.dart';
import 'reminders/dose_alert.dart';
import 'reminders/dose_reminder_page.dart';
import 'shell/app_shell.dart';
import 'theme/gurtu_theme.dart';
import 'widgets/in_app_notice.dart';
import 'widgets/splash_screen.dart';

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
  final ai = GurtuAi(prefs);
  runApp(
    GurtuApp(
      prefs: prefs,
      ai: ai,
      // Finished behind the splash screen.
      boot: AttachmentStore.instance.init(),
      online: true,
    ),
  );
  // Not awaited: the app opens straight away and the AI reports its state
  // (installed, resuming a download…) as soon as it knows.
  ai.init();
}

class GurtuApp extends StatefulWidget {
  const GurtuApp({
    super.key,
    required this.prefs,
    required this.ai,
    this.boot,
    this.online = false,
    this.cloud,
  });

  final SharedPreferences prefs;
  final GurtuAi ai;

  /// Start-up work the splash screen waits for. Without it (tests) the app
  /// opens straight away.
  final Future<void>? boot;

  /// Connect to the Gurtu backend and push notifications at start.
  final bool online;

  /// Replaced in tests.
  final CloudSync? cloud;

  @override
  State<GurtuApp> createState() => _GurtuAppState();
}

class _GurtuAppState extends State<GurtuApp> with WidgetsBindingObserver {
  late final _language = LanguageController(widget.prefs);
  late final _care = CareRepository(widget.prefs);
  late final _cloud = (widget.cloud ?? CloudSync(widget.prefs))
    ..onCircle = _care.applyCircle
    // Doses marked as taken on other family phones: ticked here too.
    ..onDoses = (patientId, doses) => _care.applyRemoteDoses(patientId, doses);
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  final _navigator = GlobalKey<NavigatorState>();
  StreamSubscription<PushMessage>? _messages;
  StreamSubscription<PushMessage>? _taps;

  /// The reminder (or missed-dose alert) on screen, so a follow-up for the
  /// same dose doesn't open it a second time.
  String? _openDose;
  late bool _booting = widget.boot != null;

  /// The splash stays at least this long, so it never just flickers.
  static const _splashAtLeast = Duration(milliseconds: 1300);

  @override
  void initState() {
    super.initState();
    final boot = widget.boot;
    if (boot == null) {
      _pruneFiles();
    } else {
      Future.wait([
        boot.catchError((Object e) => debugPrint('Start-up: $e')),
        Future<void>.delayed(_splashAtLeast),
      ]).whenComplete(() {
        _pruneFiles();
        if (mounted) setState(() => _booting = false);
      });
    }
    _messages = _cloud.messages.listen(_showMessage);
    _taps = _cloud.opened.listen(_opened);
    if (widget.online) {
      _language.addListener(_languageChanged);
      WidgetsBinding.instance.addObserver(this);
      unawaited(_cloud.start(language: _language.value.code));
    }
  }

  /// Back from Settings (notifications allowed?) or a long pause (new push
  /// token?): let the server know.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Also sends reminders and answers saved while offline, and fetches
      // doses marked on other phones.
      unawaited(_cloud.recheckPhone().then((_) => _cloud.syncAll()));
    }
  }

  /// Photos or voice notes from a visit that was never saved.
  void _pruneFiles() => AttachmentStore.instance.prune(_care.attachmentFiles);

  void _languageChanged() => _cloud.setLanguage(_language.value.code);

  /// A notification that arrived while Gurtu was open (Android only shows
  /// them itself in the background): dropped in from the top, above every
  /// screen.
  void _showMessage(PushMessage m) {
    // A medicine reminder opens full screen, even while Gurtu is in use.
    if (DoseAlert.from(m) case final alert?) {
      _openAlert(alert);
      return;
    }
    // Someone marked a dose as taken: show it ticked here too.
    if (m.data?['type'] == 'dose_taken') unawaited(_cloud.pullAllDoses());
    if (m.title.isEmpty && m.body.isEmpty) return;
    final overlay = _navigator.currentState?.overlay;
    if (overlay == null) return;
    InAppNotice.show(
      overlay,
      title: m.title.isEmpty ? 'Gurtu' : m.title,
      body: m.body,
    );
  }

  /// A notification the person tapped.
  void _opened(PushMessage m) {
    if (DoseAlert.from(m) case final alert?) {
      _openAlert(alert);
    } else if (m.data?['type'] == 'dose_taken') {
      unawaited(_cloud.pullAllDoses());
    }
  }

  /// The full-screen reminder, or the family's red missed-dose screen.
  void _openAlert(DoseAlert alert, {bool retried = false}) {
    if (!_onboarded) return;
    final key = '${alert.missed ? 'missed' : 'dose'}:${alert.doseId}';
    if (_openDose == key) return;
    final navigator = _navigator.currentState;
    if (navigator == null) {
      // Tapped to start the app, before its first frame.
      if (!retried) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _openAlert(alert, retried: true),
        );
      }
      return;
    }
    _openDose = key;
    InAppNotice.hide();
    navigator
        .push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => alert.missed
                ? MissedDosePage(alert: alert)
                : DoseReminderPage(alert: alert),
          ),
        )
        .whenComplete(() {
          if (_openDose == key) _openDose = null;
        });
  }

  // Builds from before patient data was saved have no patient: onboard again.
  late bool _onboarded =
      (widget.prefs.getBool(_onboardedKey) ?? false) && _care.hasPatient;

  void _finishOnboarding(OnboardingState data) {
    _care.createFromOnboarding(data);
    widget.prefs.setBool(_onboardedKey, true);
    OnboardingFlow.clearDraft(widget.prefs);
    setState(() => _onboarded = true);
    // Saved to the backend in the background (kept and retried when
    // offline), which gives the family its code.
    final patient = _care.selectedPatient;
    if (patient != null && widget.online) {
      unawaited(
        _cloud.createCircle(
          patient.id,
          CloudSync.circlePayload(patient, myName: _care.userName),
        ),
      );
    }
  }

  /// Joined a family's existing circle with its code.
  void _finishJoin(CircleInfo circle, String myName) {
    final patientId = _care.createFromCircle(circle, myName: myName);
    _cloud.link(patientId, circle);
    widget.prefs.setBool(_onboardedKey, true);
    OnboardingFlow.clearDraft(widget.prefs);
    setState(() => _onboarded = true);
    final l = lookupAppLocalizations(_language.value.locale);
    // Above every screen, so it's fine while the join screen closes.
    final overlay = _navigator.currentState?.overlay;
    if (overlay != null) {
      InAppNotice.show(
        overlay,
        title: l.joinedCircle(circle.patientName),
        icon: Icons.diversity_1_rounded,
      );
    }
  }

  void _restartOnboarding() {
    // The downloaded AI model is kept: it isn't personal data and is large.
    _care.clear();
    _cloud.forgetCircles();
    widget.prefs.setBool(_onboardedKey, false);
    OnboardingFlow.clearDraft(widget.prefs);
    setState(() => _onboarded = false);
  }

  @override
  void dispose() {
    _messages?.cancel();
    _taps?.cancel();
    InAppNotice.hide();
    WidgetsBinding.instance.removeObserver(this);
    _language.removeListener(_languageChanged);
    _cloud.dispose();
    _language.dispose();
    _care.dispose();
    widget.ai.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilding MaterialApp with a new locale re-renders every screen in the
    // chosen language immediately.
    return AiScope(
      ai: widget.ai,
      child: CloudScope(
        sync: _cloud,
        child: CareScope(
          repository: _care,
          child: LanguageScope(
            controller: _language,
            child: ValueListenableBuilder<AppLanguage>(
              valueListenable: _language,
              builder: (context, language, _) => MaterialApp(
                scaffoldMessengerKey: _messenger,
                navigatorKey: _navigator,
                onGenerateTitle: (context) => 'Gurtu',
                debugShowCheckedModeBanner: false,
                theme: buildGurtuTheme(),
                locale: language.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _booting
                      ? const SplashScreen(key: ValueKey('splash'))
                      : _onboarded
                      ? AppShell(
                          key: const ValueKey('app'),
                          onRestartOnboarding: _restartOnboarding,
                        )
                      : OnboardingFlow(
                          key: const ValueKey('onboarding'),
                          prefs: widget.prefs,
                          onFinished: _finishOnboarding,
                          onJoined: _finishJoin,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
