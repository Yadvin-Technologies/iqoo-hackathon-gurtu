import 'package:flutter/material.dart';

import '../ask/ask_gurtu_page.dart';
import '../circle/circle_page.dart';
import '../memory/memory_page.dart';
import '../profile/person_details.dart';

import '../home/home_page.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../reminders/auto_reminders.dart';
import '../reminders/test_reminder_button.dart';
import '../widgets/ai_status.dart';
import '../widgets/gurtu_widgets.dart';
import '../widgets/language_grid.dart';

enum AppTab { home, memory, circle, ai, profile }

/// Main app after onboarding: five tabs, no more. SOS is not a tab — it
/// lives on the screens themselves.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.onRestartOnboarding});

  final VoidCallback onRestartOnboarding;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppTab _tab = AppTab.home;
  String? _pendingQuestion;

  void _open(AppTab tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      // Back from another tab returns Home before leaving the app.
      canPop: _tab == AppTab.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _open(AppTab.home);
      },
      child: Scaffold(
        body: GlowBackground(
          child: IndexedStack(
            index: _tab.index,
            children: [
              HomePage(
                onOpenMemory: () => _open(AppTab.memory),
                onOpenCircle: () => _open(AppTab.circle),
                onAsk: (q) => setState(() {
                  _pendingQuestion = q;
                  _tab = AppTab.ai;
                }),
              ),
              const MemoryPage(),
              const CirclePage(),
              AskGurtuPage(
                question: _pendingQuestion,
                onQuestionTaken: () => _pendingQuestion = null,
              ),
              _ProfileTab(onRestartOnboarding: widget.onRestartOnboarding),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab.index,
          onDestinationSelected: (i) => _open(AppTab.values[i]),
          backgroundColor: GurtuColors.surface,
          indicatorColor: GurtuColors.primarySoft,
          surfaceTintColor: Colors.transparent,
          shadowColor: GurtuColors.primaryDeep,
          elevation: 8,
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            _dest(Icons.home_outlined, Icons.home_rounded, l.navHome),
            _dest(
              Icons.auto_stories_outlined,
              Icons.auto_stories_rounded,
              l.navMemory,
            ),
            NavigationDestination(
              icon: const _CircleNavIcon(selected: false),
              selectedIcon: const _CircleNavIcon(selected: true),
              label: l.navCircle,
            ),
            _dest(
              Icons.auto_awesome_outlined,
              Icons.auto_awesome_rounded,
              l.navAi,
            ),
            _dest(
              Icons.person_outline_rounded,
              Icons.person_rounded,
              l.navProfile,
            ),
          ],
        ),
      ),
    );
  }

  NavigationDestination _dest(IconData icon, IconData selected, String label) =>
      NavigationDestination(
        icon: Icon(icon, color: GurtuColors.textSecondary),
        selectedIcon: Icon(selected, color: GurtuColors.primary),
        label: label,
      );
}

/// The care circle's tab: a filled, coloured circle so it stands out as the
/// heart of the app.
class _CircleNavIcon extends StatelessWidget {
  const _CircleNavIcon({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: GurtuColors.iqooGradient,
        border: Border.all(
          color: selected ? GurtuColors.primary : Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: GurtuColors.orange.withValues(alpha: selected ? 0.45 : 0.25),
            blurRadius: selected ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.diversity_1_rounded,
        size: 19,
        color: Colors.white,
      ),
    );
  }
}

/// Profile: the person's details from onboarding (editable), language,
/// Gurtu AI, medicine reminders and restart.
class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.onRestartOnboarding});

  final VoidCallback onRestartOnboarding;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: ListView(
        key: const ValueKey('profile'),
        padding: const EdgeInsets.fromLTRB(
          GurtuSpace.gutter,
          16,
          GurtuSpace.gutter,
          32,
        ),
        children: [
          Text(l.navProfile, style: t.headlineMedium),
          const SizedBox(height: 24),
          const PersonDetailsCard(),
          const SizedBox(height: 28),
          SectionHeader(title: l.rowLanguage),
          const LanguageGrid(),
          const SizedBox(height: 28),
          SectionHeader(title: l.rowAi),
          const AiStatusCard(showRemove: false),
          const AiTechDetails(),
          const SizedBox(height: 28),
          if (AutoScope.maybeOf(context) case final auto?) ...[
            SectionHeader(title: l.medRemindersTitle),
            _MedicineReminders(auto: auto),
            const SizedBox(height: 28),
          ],
          GurtuButton(
            label: l.restartOnboarding,
            style: GurtuButtonStyle.ghost,
            icon: Icons.replay_rounded,
            onPressed: onRestartOnboarding,
          ),
        ],
      ),
    );
  }
}

/// Automatic medicine reminders on or off, and a test reminder sent now.
class _MedicineReminders extends StatelessWidget {
  const _MedicineReminders({required this.auto});

  final AutoReminders auto;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return GurtuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: GurtuColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.autoReminders, style: t.titleMedium),
                      const SizedBox(height: 4),
                      Text(l.autoRemindersHint, style: t.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: auto.enabled,
                  activeTrackColor: GurtuColors.primary,
                  onChanged: (on) => auto.enabled = on,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: GurtuColors.outline),
          const SizedBox(height: 16),
          const TestReminderButton(),
          const SizedBox(height: 10),
          Text(l.testReminderHint, style: t.bodySmall),
        ],
      ),
    );
  }
}
