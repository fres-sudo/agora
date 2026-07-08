import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_spinner.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Visual emphasis of an [AppIconButton].
enum AppIconButtonVariant { primary, secondary, ghost, outline, destructive }

/// Square, icon-only button bound to design tokens.
///
/// Always pass a [tooltip] — it doubles as the accessible label so screen
/// readers announce the action and the 48dp tap target stays labeled.
class AppIconButton extends StatelessWidget {
  const AppIconButton.primary({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppIconButtonVariant.primary;

  const AppIconButton.secondary({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppIconButtonVariant.secondary;

  const AppIconButton.ghost({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppIconButtonVariant.ghost;

  const AppIconButton.outline({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppIconButtonVariant.outline;

  const AppIconButton.destructive({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppIconButtonVariant.destructive;

  final Widget icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final String? tooltip;
  final bool autofocus;
  final FocusNode? focusNode;
  final ButtonStyle? style;
  final AppIconButtonVariant variant;

  ({Color bg, Color fg, Color? border}) _palette(BuildContext context) {
    final c = context.colors;
    return switch (variant) {
      AppIconButtonVariant.primary => (
        bg: c.primary,
        fg: c.primaryForeground,
        border: null,
      ),
      AppIconButtonVariant.secondary => (
        bg: c.secondary,
        fg: c.secondaryForeground,
        border: null,
      ),
      AppIconButtonVariant.ghost => (
        bg: Colors.transparent,
        fg: c.foreground,
        border: null,
      ),
      AppIconButtonVariant.outline => (
        bg: Colors.transparent,
        fg: c.foreground,
        border: c.border,
      ),
      AppIconButtonVariant.destructive => (
        bg: c.destructive,
        fg: c.destructiveForeground,
        border: null,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final p = _palette(context);
    final enabled = onPressed != null && !isLoading;

    final baseStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return p.bg == Colors.transparent
              ? Colors.transparent
              : context.colors.muted;
        }
        return p.bg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return context.colors.mutedForeground;
        }
        return p.fg;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return p.fg.withValues(alpha: 0.16);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return p.fg.withValues(alpha: 0.08);
        }
        return null;
      }),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: tokens.borderRadiusMd),
      ),
      side: p.border == null
          ? null
          : WidgetStatePropertyAll(
              BorderSide(color: p.border!, width: tokens.borderHairline),
            ),
    );

    return IconButton(
      onPressed: enabled ? onPressed : null,
      onLongPress: enabled ? onLongPress : null,
      icon: isLoading
          ? AppSpinner(size: tokens.iconMd, color: p.fg)
          : IconTheme.merge(
              data: IconThemeData(color: p.fg, size: tokens.iconMd),
              child: icon,
            ),
      tooltip: tooltip,
      autofocus: autofocus,
      focusNode: focusNode,
      style: style == null ? baseStyle : baseStyle.merge(style),
    );
  }
}
