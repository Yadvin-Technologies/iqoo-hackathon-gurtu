import 'package:flutter/material.dart';

import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';
import 'gurtu_widgets.dart';

/// Full-screen page opened on top of the tabs: back arrow, big title,
/// scrolling body and an optional action pinned to the bottom.
class GurtuPage extends StatelessWidget {
  const GurtuPage({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.bottom,
    this.actions = const [],
    this.controller,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? bottom;
  final List<Widget> actions;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      tooltip: context.l10n.back,
                      iconSize: 26,
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: GurtuColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    ...actions,
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(
                    GurtuSpace.gutter,
                    4,
                    GurtuSpace.gutter,
                    32,
                  ),
                  children: [
                    Text(title, style: t.headlineMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(subtitle!, style: t.bodyLarge),
                    ],
                    const SizedBox(height: 20),
                    ...children,
                  ],
                ),
              ),
              if (bottom != null)
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    GurtuSpace.gutter,
                    12,
                    GurtuSpace.gutter,
                    12,
                  ),
                  decoration: BoxDecoration(
                    color: GurtuColors.surface,
                    border: const Border(
                      top: BorderSide(color: GurtuColors.outline),
                    ),
                  ),
                  child: bottom,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small bold label above a form field or detail section.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.optional = false, this.icon});

  final String text;
  final bool optional;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 8),
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 20, color: GurtuColors.primary),
          Text(text, style: t.titleMedium),
          if (optional) Text(context.l10n.optional, style: t.bodySmall),
        ],
      ),
    );
  }
}

Future<T?> pushPage<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));

/// Yes / no dialog for destructive actions. Returns true on confirm.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  String? body,
  required String confirm,
  String? cancel,
}) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: GurtuColors.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancel ?? l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: GurtuColors.danger),
          child: Text(confirm),
        ),
      ],
    ),
  );
  return ok ?? false;
}
