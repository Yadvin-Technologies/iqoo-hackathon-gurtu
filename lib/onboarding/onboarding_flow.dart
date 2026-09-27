import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cloud/cloud_models.dart';
import '../l10n/language.dart';
import '../widgets/gurtu_widgets.dart';
import 'onboarding_state.dart';
import 'pages/care_for_page.dart';
import 'pages/health_pages.dart';
import 'pages/intro_page.dart';
import 'pages/language_page.dart';
import 'pages/model_setup_page.dart';
import 'pages/permissions_page.dart';
import 'pages/profile_page.dart';
import 'pages/ready_page.dart';
import 'pages/welcome_page.dart';

/// The phases shown in the segmented progress bar.
enum OnboardingPhase {
  profile,
  health,
  permissions,
  model;

  String label(AppLocalizations l) => switch (this) {
    profile => l.phaseAbout,
    health => l.phaseHealth,
    permissions => l.phasePermissions,
    model => l.phaseAi,
  };
}

class _Step {
  const _Step(this.builder, [this.phase]);
  final WidgetBuilder builder;
  final OnboardingPhase? phase;
}

/// Hosts the onboarding pages and handles forward / back navigation.
/// Swiping is disabled so each question is answered before moving on.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
    required this.prefs,
    required this.onFinished,
    this.onJoined,
    this.addingPerson = false,
    this.yourName = '',
    this.allowSelf = true,
  });

  /// Where the unfinished answers are kept between launches. Null: not kept.
  final SharedPreferences? prefs;

  /// Adding one more person to care for, from inside the app: only the
  /// questions about them (language, welcome, permissions and AI are done).
  final bool addingPerson;

  /// Filled in when adding a person: it's the same you.
  final String yourName;

  /// "Myself" can be chosen (not when you're already on this phone).
  final bool allowSelf;

  /// Called with everything collected, so the app can save it.
  final ValueChanged<OnboardingState> onFinished;

  /// Joined an existing family's care circle with a code instead: onboarding
  /// ends there, with the circle and the name typed.
  final void Function(CircleInfo circle, String myName)? onJoined;

  static OnboardingFlowState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_FlowScope>()!.flow;

  /// The position of the page [context] belongs to.
  static int stepIndexOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_StepIndex>()!.index;

  @override
  State<OnboardingFlow> createState() => OnboardingFlowState();

  static const _draftKey = 'onboarding_draft_v1';

  /// Forgets unfinished answers (after finishing, or on restart).
  static Future<void> clearDraft(SharedPreferences prefs) =>
      prefs.remove(_draftKey);

  /// True inside the "add a person" flow.
  static bool isAddingPerson(BuildContext context) =>
      of(context).widget.addingPerson;
}

class OnboardingFlowState extends State<OnboardingFlow> {
  final _data = OnboardingState();
  late final PageController _pages;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.addingPerson) {
      _data.yourName = widget.yourName;
    } else {
      _restoreDraft();
    }
    _pages = PageController(initialPage: _index);
    _data.addListener(_saveDraft);
  }

  void _restoreDraft() {
    final raw = widget.prefs?.getString(OnboardingFlow._draftKey);
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      _data.restore(j['answers'] as Map<String, dynamic>);
      // Never land back on the last page: it finishes onboarding.
      _index = ((j['step'] as int?) ?? 0).clamp(0, _steps.length - 2);
    } on Object {
      // A draft from an older build: start over rather than fail.
      _index = 0;
    }
  }

  void _saveDraft() => widget.prefs?.setString(
    OnboardingFlow._draftKey,
    jsonEncode({'step': _index, 'answers': _data.toJson()}),
  );

  late final List<_Step> _steps = widget.addingPerson
      ? [
          _Step((_) => const CareForPage(), OnboardingPhase.profile),
          _Step((_) => const ProfilePage(), OnboardingPhase.profile),
          _Step((_) => const ConditionsPage(), OnboardingPhase.health),
          _Step((_) => const MedicinesPage(), OnboardingPhase.health),
          _Step((_) => const AllergiesPage(), OnboardingPhase.health),
          _Step((_) => const MobilityPage(), OnboardingPhase.health),
          _Step((_) => const HospitalVisitPage(), OnboardingPhase.health),
          _Step((_) => ReadyPage(onEnter: () => widget.onFinished(_data))),
        ]
      : [
          // Language comes first so every screen after it is in that language.
          _Step((_) => const LanguagePage()),
          _Step((_) => const WelcomePage()),
          _Step((_) => const IntroPage()),
          _Step((_) => const CareForPage(), OnboardingPhase.profile),
          _Step((_) => const ProfilePage(), OnboardingPhase.profile),
          _Step((_) => const ConditionsPage(), OnboardingPhase.health),
          _Step((_) => const MedicinesPage(), OnboardingPhase.health),
          _Step((_) => const AllergiesPage(), OnboardingPhase.health),
          _Step((_) => const MobilityPage(), OnboardingPhase.health),
          _Step((_) => const HospitalVisitPage(), OnboardingPhase.health),
          _Step((_) => const PermissionsPage(), OnboardingPhase.permissions),
          _Step((_) => const ModelSetupPage(), OnboardingPhase.model),
          _Step((_) => ReadyPage(onEnter: () => widget.onFinished(_data))),
        ];

  /// The phases this flow has, in order, for the progress bar.
  late final List<OnboardingPhase> phases = [
    for (final p in OnboardingPhase.values)
      if (_steps.any((s) => s.phase == p)) p,
  ];

  /// Each page asks about its own position (via [stepIndexOf]) rather than
  /// the current one, so a page sliding out keeps its own step label.
  OnboardingPhase? phaseAt(int step) => _steps[step].phase;

  /// e.g. "Health · 2 of 5"
  String phaseLabelAt(AppLocalizations l, int step) {
    final phase = phaseAt(step);
    if (phase == null) return '';
    final inPhase = [
      for (var i = 0; i < _steps.length; i++)
        if (_steps[i].phase == phase) i,
    ];
    if (inPhase.length == 1) return phase.label(l);
    return l.phaseStep(
      phase.label(l),
      inPhase.indexOf(step) + 1,
      inPhase.length,
    );
  }

  void next() => _go(_index + 1);

  void joined(CircleInfo circle, String myName) =>
      widget.onJoined?.call(circle, myName);

  void back() {
    if (_index == 0) {
      // Adding a person: the first page's back leaves the flow.
      if (widget.addingPerson) Navigator.maybePop(context);
      return;
    }
    _go(_index - 1);
  }

  void _go(int index) {
    if (index < 0 || index >= _steps.length) return;
    FocusScope.of(context).unfocus();
    setState(() => _index = index);
    _saveDraft();
    _pages.animateToPage(
      index,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pages.dispose();
    _data
      ..removeListener(_saveDraft)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) back();
      },
      child: _FlowScope(
        flow: this,
        index: _index,
        child: OnboardingScope(
          state: _data,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: GlowBackground(
              amber:
                  (_index == 0 && !widget.addingPerson) ||
                  _index == _steps.length - 1,
              child: PageView.builder(
                controller: _pages,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                itemBuilder: (context, i) => _StepIndex(
                  index: i,
                  child: Builder(builder: _steps[i].builder),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FlowScope extends InheritedWidget {
  const _FlowScope({
    required this.flow,
    required this.index,
    required super.child,
  });

  final OnboardingFlowState flow;
  final int index;

  @override
  bool updateShouldNotify(_FlowScope old) => old.index != index;
}

class _StepIndex extends InheritedWidget {
  const _StepIndex({required this.index, required super.child});

  final int index;

  @override
  bool updateShouldNotify(_StepIndex old) => old.index != index;
}
