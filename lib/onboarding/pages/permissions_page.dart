import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/language.dart';
import '../../theme/gurtu_theme.dart';
import '../../widgets/gurtu_widgets.dart';
import '../onboarding_flow.dart';
import '../onboarding_state.dart';
import '../step_scaffold.dart';

class _PermissionInfo {
  const _PermissionInfo({
    required this.id,
    required this.permission,
    required this.title,
    required this.why,
    required this.icon,
    required this.color,
    this.required = false,
  });

  final String id;
  final Permission permission;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) why;
  final IconData icon;
  final Color color;
  final bool required;
}

final _items = [
  _PermissionInfo(
    id: 'mic',
    permission: Permission.microphone,
    title: (l) => l.permMic,
    why: (l) => l.permMicWhy,
    icon: Icons.mic_rounded,
    color: GurtuColors.danger,
    required: true,
  ),
  _PermissionInfo(
    id: 'camera',
    permission: Permission.camera,
    title: (l) => l.permCamera,
    why: (l) => l.permCameraWhy,
    icon: Icons.photo_camera_rounded,
    color: GurtuColors.info,
    required: true,
  ),
  _PermissionInfo(
    id: 'notifications',
    permission: Permission.notification,
    title: (l) => l.permNotifications,
    why: (l) => l.permNotificationsWhy,
    icon: Icons.notifications_active_rounded,
    color: GurtuColors.orange,
  ),
  _PermissionInfo(
    id: 'photos',
    permission: Permission.photos,
    title: (l) => l.permPhotos,
    why: (l) => l.permPhotosWhy,
    icon: Icons.photo_library_rounded,
    color: GurtuColors.leaf,
  ),
  _PermissionInfo(
    id: 'contacts',
    permission: Permission.contacts,
    title: (l) => l.permContacts,
    why: (l) => l.permContactsWhy,
    icon: Icons.contacts_rounded,
    color: GurtuColors.primary,
  ),
];

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  final _status = <String, PermissionStatus>{};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    for (final p in _items) {
      try {
        _status[p.id] = await p.permission.status;
      } catch (_) {
        // Platform without runtime permissions (desktop / web preview).
        _status[p.id] = PermissionStatus.granted;
      }
    }
    if (mounted) setState(() {});
  }

  bool _granted(String id) {
    final s = _status[id];
    return s != null && (s.isGranted || s.isLimited);
  }

  Future<void> _request(_PermissionInfo p) async {
    final data = OnboardingScope.of(context);
    final l = context.l10n;
    PermissionStatus s;
    try {
      s = await p.permission.request();
    } catch (_) {
      s = PermissionStatus.granted;
    }
    if (!mounted) return;
    setState(() => _status[p.id] = s);
    data.update(() => data.permissions[p.id] = s.isGranted || s.isLimited);
    if (s.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.permissionBlocked(p.title(l))),
          action: SnackBarAction(
            label: l.settings,
            textColor: GurtuColors.amberBright,
            onPressed: openAppSettings,
          ),
        ),
      );
    }
  }

  Future<void> _allowAllAndContinue() async {
    setState(() => _busy = true);
    for (final p in _items) {
      if (!_granted(p.id) && !(_status[p.id]?.isPermanentlyDenied ?? false)) {
        await _request(p);
        if (!mounted) return;
      }
    }
    setState(() => _busy = false);
    if (!mounted) return;
    final l = context.l10n;
    final missing = _items.where((p) => p.required && !_granted(p.id));
    if (missing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l.permissionsMissing(missing.map((p) => p.title(l)).join(', ')),
          ),
        ),
      );
    }
    OnboardingFlow.of(context).next();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final allGranted = _items.every((p) => _granted(p.id));
    return StepScaffold(
      title: l.permissionsTitle,
      subtitle: l.permissionsSubtitle,
      body: Column(
        children: [
          for (final p in _items) ...[
            _PermissionTile(
              info: p,
              granted: _granted(p.id),
              onAllow: () => _request(p),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          InfoBanner(text: l.privacyNote),
        ],
      ),
      bottom: GurtuButton(
        label: allGranted ? l.continueLabel : l.allowAndContinue,
        icon: allGranted ? Icons.arrow_forward_rounded : null,
        onPressed: _busy
            ? null
            : allGranted
            ? OnboardingFlow.of(context).next
            : _allowAllAndContinue,
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.info,
    required this.granted,
    required this.onAllow,
  });

  final _PermissionInfo info;
  final bool granted;
  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    return GurtuCard(
      padding: const EdgeInsets.all(16),
      borderColor: granted
          ? GurtuColors.leaf.withValues(alpha: 0.4)
          : GurtuColors.outline,
      // The action sits under the text, not beside it: translated "Allow"
      // labels can be long enough to squeeze the text into a thin column.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon: info.icon, color: info.color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(info.title(l), style: t.titleMedium),
                    _Tag(
                      info.required ? l.needed : l.optional,
                      info.required ? GurtuColors.amber : GurtuColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(info.why(l), style: t.bodyMedium),
                const SizedBox(height: 12),
                granted
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: GurtuColors.leaf,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l.allowed,
                              style: t.titleMedium?.copyWith(
                                fontSize: 14,
                                color: GurtuColors.leaf,
                              ),
                            ),
                          ),
                        ],
                      )
                    : FilledButton(
                        onPressed: onAllow,
                        style: FilledButton.styleFrom(
                          backgroundColor: GurtuColors.primarySoft,
                          foregroundColor: GurtuColors.primaryDeep,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          textStyle: const TextStyle(
                            fontFamily: GurtuFonts.sans,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        child: Text(l.allow),
                      ),
              ],
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
