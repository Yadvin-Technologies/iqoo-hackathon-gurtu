import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/language.dart';
import '../theme/gurtu_theme.dart';

/// "Gurtu" wordmark with the leaf, as on the concept board.
class GurtuLogo extends StatelessWidget {
  const GurtuLogo({super.key, this.size = 56, this.showTagline = false});

  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gurtu',
              style: TextStyle(
                fontFamily: GurtuFonts.script,
                fontSize: size,
                height: 1,
                fontWeight: FontWeight.w700,
                color: GurtuColors.logo,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: size * 0.04),
              child: Icon(
                Icons.eco_rounded,
                size: size * 0.38,
                color: GurtuColors.leaf,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 6),
          Text(
            context.l10n.tagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size * 0.26,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: GurtuColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Soft purple / amber glows behind the content.
class GlowBackground extends StatelessWidget {
  const GlowBackground({super.key, required this.child, this.amber = false});

  final Widget child;
  final bool amber;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: GurtuColors.background)),
        Positioned(
          top: -160,
          right: -120,
          child: _glow(GurtuColors.primary.withValues(alpha: 0.16), 420),
        ),
        Positioned(
          bottom: -200,
          left: -160,
          child: _glow(
            (amber ? GurtuColors.orange : GurtuColors.primaryDeep).withValues(
              alpha: amber ? 0.16 : 0.12,
            ),
            460,
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _glow(Color color, double size) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    ),
  );
}

enum GurtuButtonStyle { primary, amber, ghost }

/// Full-width pill button. Primary = Gurtu purple, amber = iQOO accent.
class GurtuButton extends StatelessWidget {
  const GurtuButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = GurtuButtonStyle.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final GurtuButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final fg = switch (style) {
      GurtuButtonStyle.amber => const Color(0xFF1E1400),
      GurtuButtonStyle.primary => Colors.white,
      GurtuButtonStyle.ghost => GurtuColors.textPrimary,
    };
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      gradient: !enabled || style == GurtuButtonStyle.ghost
          ? null
          : style == GurtuButtonStyle.amber
          ? GurtuColors.iqooGradient
          : GurtuColors.primaryGradient,
      color: !enabled
          ? GurtuColors.surfaceHigh
          : style == GurtuButtonStyle.ghost
          ? GurtuColors.surface
          : null,
      border: style == GurtuButtonStyle.ghost
          ? Border.all(color: GurtuColors.outline)
          : null,
      boxShadow: enabled && style != GurtuButtonStyle.ghost
          ? [
              BoxShadow(
                color:
                    (style == GurtuButtonStyle.amber
                            ? GurtuColors.orange
                            : GurtuColors.primary)
                        .withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ]
          : null,
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Grows when a long label wraps to a second line.
        constraints: const BoxConstraints(minHeight: 60),
        decoration: decoration,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: enabled
                ? () {
                    HapticFeedback.lightImpact();
                    onPressed!();
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flexible + two lines: long translations wrap, never clip.
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: enabled ? fg : GurtuColors.textMuted,
                      ),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      icon,
                      size: 22,
                      color: enabled ? fg : GurtuColors.textMuted,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Card surface used across screens.
class GurtuCard extends StatelessWidget {
  const GurtuCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color = GurtuColors.surface,
    this.borderColor = GurtuColors.outline,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(GurtuSpace.radius),
        border: Border.all(color: borderColor, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: GurtuColors.primaryDeep.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(GurtuSpace.radius),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Big tappable answer card with icon, title, hint and a check mark.
class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.hint,
    this.icon,
    this.leading,
    this.trailing,
    this.body,
  });

  final String title;

  /// Replaces the title / hint column when set.
  final Widget? body;
  final String? hint;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Semantics(
      selected: selected,
      button: true,
      child: GurtuCard(
        color: selected ? GurtuColors.primarySoft : GurtuColors.surface,
        borderColor: selected ? GurtuColors.primary : GurtuColors.outline,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else if (icon != null)
              IconBadge(icon: icon!, active: selected),
            if (leading != null || icon != null) const SizedBox(width: 14),
            Expanded(
              child:
                  body ??
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: t.titleMedium),
                      if (hint != null) ...[
                        const SizedBox(height: 2),
                        Text(hint!, style: t.bodyMedium),
                      ],
                    ],
                  ),
            ),
            const SizedBox(width: 10),
            trailing ?? _Check(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? GurtuColors.primary : Colors.transparent,
        border: Border.all(
          color: selected ? GurtuColors.primary : GurtuColors.textMuted,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
          : null,
    );
  }
}

class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.active = false,
    this.color,
    this.size = 48,
  });

  final IconData icon;
  final bool active;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = color ?? (active ? Colors.white : GurtuColors.primary);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        gradient: active && color == null ? GurtuColors.primaryGradient : null,
        color: active && color == null ? null : c.withValues(alpha: 0.14),
      ),
      child: Icon(icon, color: c, size: size * 0.5),
    );
  }
}

/// Pill chip for multi-select answers.
class GurtuChip extends StatelessWidget {
  const GurtuChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: selected ? GurtuColors.primarySoft : GurtuColors.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: selected ? GurtuColors.primary : GurtuColors.outline,
              width: 1.4,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : (icon ?? Icons.add),
                size: 20,
                color: selected ? GurtuColors.amber : GurtuColors.textMuted,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? GurtuColors.textPrimary
                        : GurtuColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small reassurance banner ("Gurtu is not a doctor", "stays on phone").
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.text,
    this.icon = Icons.lock_rounded,
    this.color = GurtuColors.leaf,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(GurtuSpace.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: GurtuColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Segmented progress bar (OriginOS style) shown at the top of each step.
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({
    super.key,
    required this.total,
    required this.current,
  });

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    // The step eyebrow under the bar already announces progress.
    return ExcludeSemantics(
      child: Row(
        children: List.generate(total, (i) {
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 5,
              margin: EdgeInsets.only(right: i == total - 1 ? 0 : 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: i <= current ? GurtuColors.iqooGradient : null,
                color: i <= current ? null : GurtuColors.outline,
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Section label in small caps ("STEP 2 · ABOUT YOU").
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = GurtuColors.amber});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
    );
  }
}

/// Round avatar with initials, used for the care-circle illustration.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.label,
    required this.color,
    this.size = 56,
    this.icon,
  });

  final String label;
  final Color color;
  final double size;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color, Color.lerp(color, Colors.black, 0.35)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, color: Colors.white, size: size * 0.48)
            : Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: size * 0.36,
                ),
              ),
      ),
    );
  }
}

/// Handle at the top of bottom sheets.
class SheetGrabber extends StatelessWidget {
  const SheetGrabber({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: GurtuColors.outline,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

Future<T?> showGurtuSheet<T>(BuildContext context, WidgetBuilder builder) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: GurtuColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: builder,
    );

/// Section title with an optional action ("View all"). Wraps instead of
/// clipping when a translation is long.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          // The action may wrap to two lines rather than push the row
          // past the screen edge (long in Malayalam, Marathi, Telugu).
          if (action != null)
            Flexible(
              flex: 2,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: GurtuColors.primary,
                  minimumSize: const Size(48, 48),
                  textStyle: const TextStyle(
                    fontFamily: GurtuFonts.sans,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                child: Text(action!, textAlign: TextAlign.end, maxLines: 2),
              ),
            ),
        ],
      ),
    );
  }
}

/// Stable colour per person so avatars stay recognisable across screens.
Color avatarColor(String seed) {
  const palette = [
    GurtuColors.primary,
    Color(0xFF3FA7D6),
    Color(0xFFE07A5F),
    Color(0xFF2BB39A),
    Color(0xFFB9855A),
    Color(0xFFD9577A),
  ];
  return palette[seed.hashCode.abs() % palette.length];
}

/// First visible letter of a name, grapheme-safe for Indic scripts.
String initialOf(String name) =>
    name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase();
