import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cloud/cloud_models.dart';
import '../cloud/cloud_sync.dart';
import '../cloud/gurtu_api.dart';
import '../data/care_models.dart';
import '../data/care_repository.dart';
import '../home/care_text.dart';
import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import '../widgets/gurtu_page.dart';
import '../widgets/gurtu_widgets.dart';

/// The care circle of the selected person: the family code others join
/// with, everyone in it and whether their phone gets reminders, and a test
/// notification. Pull down to refresh.
class CirclePage extends StatelessWidget {
  const CirclePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CareScope.of(context);
    final cloud = CloudScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final patient = repo.selectedPatient;
    if (patient == null) return const SizedBox.shrink();
    final circle = cloud.circleFor(patient.id);

    Future<void> refresh() async {
      final messenger = ScaffoldMessenger.of(context);
      final error = await cloud.refresh(patient.id);
      if (error != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(_errorText(l, error)), persist: false),
          );
      }
    }

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: GurtuColors.primary,
        backgroundColor: GurtuColors.surface,
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            GurtuSpace.gutter,
            16,
            GurtuSpace.gutter,
            32,
          ),
          children: [
            Text(l.yourCareCircle, style: t.headlineMedium),
            const SizedBox(height: 4),
            Text(
              patient.isSelf
                  ? l.circleSubtitleSelf
                  : l.circleSubtitle(patient.name),
              style: t.bodyLarge,
            ),
            const SizedBox(height: 20),
            // Sample people are for trying the app: no code for them.
            if (!patient.isSample) ...[
              circle != null
                  ? _CodeCard(patientId: patient.id, circle: circle)
                  : _NotConnected(patient: patient, userName: repo.userName),
              const SizedBox(height: 28),
            ],
            SectionHeader(title: l.circleMembers),
            _Members(
              members:
                  circle?.members ??
                  [
                    for (final m in repo.circle)
                      CircleMember(
                        id: m.id,
                        name: m.name,
                        role: m.role.name,
                        isYou: m.isYou,
                        usesApp: m.isYou,
                      ),
                  ],
              live: circle != null,
            ),
            if (circle != null) ...[
              const SizedBox(height: 20),
              GurtuButton(
                label: l.sendTestNotification,
                style: GurtuButtonStyle.ghost,
                icon: Icons.notifications_active_rounded,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final sent = await cloud.notify(
                    patient.id,
                    l.testTitle,
                    l.testBody(patient.name),
                  );
                  messenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        persist: false,
                        content: Text(
                          sent == null
                              ? _errorText(l, cloud.error ?? ApiError.server)
                              : l.testSent(sent),
                        ),
                      ),
                    );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _errorText(AppLocalizations l, ApiError error) => switch (error) {
  ApiError.offline => l.connectionFailed,
  ApiError.tooMany => l.tooManyTries,
  _ => l.somethingWrong,
};

/// The 6-digit code, big enough to read out over the phone.
class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.patientId, required this.circle});

  final String patientId;
  final CircleInfo circle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cloud = CloudScope.of(context);
    final code = circle.code;
    final spaced = code.length == 6
        ? '${code.substring(0, 3)} ${code.substring(3)}'
        : code;
    final white = Colors.white.withValues(alpha: 0.85);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B5CFF), Color(0xFF4F36C9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(GurtuSpace.radiusLg),
        boxShadow: [
          BoxShadow(
            color: GurtuColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pin_rounded, size: 18, color: white),
              const SizedBox(width: 8),
              Text(
                l.familyCode.toUpperCase(),
                style: TextStyle(
                  color: white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Semantics(
            label: code.split('').join(' '),
            excludeSemantics: true,
            child: Text(
              spaced,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 44,
                height: 1.1,
                fontWeight: FontWeight.w800,
                letterSpacing: 6,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.familyCodeHint(circle.patientName),
            style: TextStyle(color: white, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(l.codeCopied)));
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(l.copyCode),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: GurtuColors.primaryDeep,
                  minimumSize: const Size(48, 48),
                  textStyle: const TextStyle(
                    fontFamily: GurtuFonts.sans,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              if (circle.isOwner)
                OutlinedButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final ok = await confirmAction(
                      context,
                      title: l.newCodeTitle,
                      body: l.newCodeBody,
                      confirm: l.newCode,
                    );
                    if (!ok) return;
                    final error = await cloud.newCode(patientId);
                    if (error != null) {
                      messenger
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            persist: false,
                            content: Text(_errorText(l, error)),
                          ),
                        );
                    }
                  },
                  icon: const Icon(Icons.autorenew_rounded, size: 18),
                  label: Text(l.newCode),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: const Size(48, 48),
                    side: BorderSide(color: white),
                    textStyle: const TextStyle(
                      fontFamily: GurtuFonts.sans,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// No code yet: being made now, or the server couldn't be reached.
class _NotConnected extends StatelessWidget {
  const _NotConnected({required this.patient, required this.userName});

  final PatientProfile patient;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final cloud = CloudScope.of(context);
    final busy = cloud.isBusy(patient.id);

    return GurtuCard(
      child: busy
          ? Row(
              children: [
                const SizedBox.square(
                  dimension: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(l.settingUpCode, style: t.titleMedium)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconBadge(
                      icon: Icons.cloud_off_rounded,
                      color: GurtuColors.textMuted,
                      size: 44,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.offlineTitle, style: t.titleMedium),
                          const SizedBox(height: 2),
                          Text(l.offlineBody, style: t.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                GurtuButton(
                  label: l.tryAgain,
                  style: GurtuButtonStyle.ghost,
                  icon: Icons.refresh_rounded,
                  onPressed: () => cloud.isPending(patient.id)
                      ? cloud.refresh(patient.id)
                      // Set up before Gurtu had a server: make its circle now.
                      : cloud.createCircle(
                          patient.id,
                          CloudSync.circlePayload(patient, myName: userName),
                        ),
                ),
              ],
            ),
    );
  }
}

class _Members extends StatelessWidget {
  const _Members({required this.members, required this.live});

  final List<CircleMember> members;

  /// From the server, so the notification status is known.
  final bool live;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return GurtuCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          for (final (i, m) in members.indexed) ...[
            if (i > 0) const Divider(height: 1, color: GurtuColors.outline),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  InitialsAvatar(
                    label: initialOf(m.name),
                    color: avatarColor(m.id),
                    size: 46,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(m.name, style: t.titleMedium),
                            if (m.isYou) _Tag(l.rowYou, GurtuColors.primary),
                          ],
                        ),
                        Text(
                          [
                            l.roleLabel(
                              CareRole.values.asNameMap()[m.role] ??
                                  CareRole.family,
                            ),
                            if (m.isOwner) l.circleOwner,
                          ].join(' · '),
                          style: t.bodySmall,
                        ),
                        if (live) _Status(member: m),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Whether this person's phone gets reminders: icon and words.
class _Status extends StatelessWidget {
  const _Status({required this.member});

  final CircleMember member;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (icon, text, color) = !member.usesApp
        ? (Icons.phone_android_rounded, l.notOnApp, GurtuColors.textMuted)
        : member.notificationsOn
        ? (
            Icons.notifications_active_rounded,
            l.getsReminders,
            GurtuColors.leaf,
          )
        : (
            Icons.notifications_off_rounded,
            l.noNotifications,
            GurtuColors.amber,
          );
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, this.color);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color),
    ),
  );
}
