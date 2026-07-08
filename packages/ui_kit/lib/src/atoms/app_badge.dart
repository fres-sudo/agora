import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Semantic tone of an [AppBadge].
enum AppBadgeVariant {
  neutral,
  primary,
  success,
  warning,
  destructive,
  info,
  outline,
}

/// A compact status pill (labels, counts, states).
///
/// Tone-only API — colors resolve from `context.colors`, so a `success` badge is
/// legible in both themes without the caller thinking about it.
class AppBadge extends StatelessWidget {
  const AppBadge(
    this.label, {
    super.key,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
  });

  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  ({Color bg, Color fg, Color? border}) _palette(BuildContext context) {
    final c = context.colors;
    return switch (variant) {
      AppBadgeVariant.neutral => (
        bg: c.muted,
        fg: c.mutedForeground,
        border: null,
      ),
      AppBadgeVariant.primary => (
        bg: c.primary,
        fg: c.primaryForeground,
        border: null,
      ),
      AppBadgeVariant.success => (
        bg: c.success,
        fg: c.successForeground,
        border: null,
      ),
      AppBadgeVariant.warning => (
        bg: c.warning,
        fg: c.warningForeground,
        border: null,
      ),
      AppBadgeVariant.destructive => (
        bg: c.destructive,
        fg: c.destructiveForeground,
        border: null,
      ),
      AppBadgeVariant.info => (bg: c.info, fg: c.infoForeground, border: null),
      AppBadgeVariant.outline => (
        bg: Colors.transparent,
        fg: c.foreground,
        border: c.border,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final p = _palette(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spaceSm,
        vertical: tokens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(tokens.radiusFull),
        border: p.border == null
            ? null
            : Border.all(color: p.border!, width: tokens.borderHairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: tokens.iconSm, color: p.fg),
            SizedBox(width: tokens.spaceXxs),
          ],
          Text(label, style: context.typography.caption.copyWith(color: p.fg)),
        ],
      ),
    );
  }
}
