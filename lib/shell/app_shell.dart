import 'package:flutter/material.dart';

import '../circle/circle_page.dart';

import '../data/care_repository.dart';
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
              _ComingTab(title: l.navMemory, icon: Icons.auto_stories_rounded),
              const CirclePage(),
              _ComingTab(
                title: l.askGurtuTitle,
                icon: Icons.auto_awesome_rounded,
                question: _pendingQuestion,
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
            _dest(
              Icons.diversity_1_outlined,
              Icons.diversity_1_rounded,
              l.navCircle,
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

/// Placeholder for tabs built in later phases.
class _ComingTab extends StatelessWidget {
  const _ComingTab({required this.title, required this.icon, this.question});

  final String title;
  final IconData icon;

  /// Question handed over from Home's "Ask Gurtu", shown so the tap has a
  /// visible result until the assistant exists.
  final String? question;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(GurtuSpace.gutter),
          child: Column(
            children: [
              IconBadge(icon: icon, size: 72),
              const SizedBox(height: 20),
              Text(title, textAlign: TextAlign.center, style: t.headlineMedium),
              const SizedBox(height: 8),
              Text(
                context.l10n.comingNextPhase,
                textAlign: TextAlign.center,
                style: t.bodyLarge,
              ),
              if (question != null) ...[
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      gradient: GurtuColors.primaryGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      question!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal Profile for now: language, Gurtu AI, sample data and restart. The full
/// profile (patients, SOS settings, privacy…) comes in later phases.
class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.onRestartOnboarding});

  final VoidCallback onRestartOnboarding;

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          GurtuSpace.gutter,
          16,
          GurtuSpace.gutter,
          32,
        ),
        children: [
          Text(l.navProfile, style: t.headlineMedium),
          const SizedBox(height: 24),
          SectionHeader(title: l.rowLanguage),
          const LanguageGrid(),
          const SizedBox(height: 28),
          SectionHeader(title: l.rowAi),
          const AiStatusCard(),
          const AiTechDetails(),
          const SizedBox(height: 28),
          if (AutoScope.maybeOf(context) case final auto?) ...[
            SectionHeader(title: l.medRemindersTitle),
            _MedicineReminders(auto: auto),
            const SizedBox(height: 28),
          ],
          if (repo.hasSampleData) ...[
            Text(l.sampleDataOn, style: t.bodyMedium),
            const SizedBox(height: 8),
            GurtuButton(
              label: l.remove,
              style: GurtuButtonStyle.ghost,
              icon: Icons.delete_outline_rounded,
              onPressed: repo.removeSampleData,
            ),
            const SizedBox(height: 12),
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
