import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_spinner.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Visual emphasis of an [AppButton].
enum AppButtonVariant { primary, secondary, ghost, outline, destructive }

/// Size (height/padding/typography) of an [AppButton].
enum AppButtonSize { sm, md, lg }

/// The design-system button.
///
/// Fully token-driven: every color, radius, padding and text style comes from
/// `context.colors` / `context.tokens` / `context.typography`, so it renders
/// correctly in light and dark with no branching. Built on a Material
/// [TextButton] purely to inherit focus, hover, ink and semantics — all visuals
/// are overridden from tokens.
///
/// Accessibility: exposes a button role with [label] as its accessible name
/// (preserved even while [isLoading] hides the text), and keeps a >=48dp tap
/// target via [MaterialTapTargetSize.padded].
class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppButtonVariant.ghost;

  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppButtonVariant.outline;

  const AppButton.destructive({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : variant = AppButtonVariant.destructive;

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool fullWidth;
  final AppButtonSize size;
  final bool autofocus;
  final FocusNode? focusNode;

  /// Optional overrides merged on top of the computed token style.
  final ButtonStyle? style;
  final AppButtonVariant variant;

  double get _height => switch (size) {
    AppButtonSize.sm => 36,
    AppButtonSize.md => 44,
    AppButtonSize.lg => 52,
  };

  double _horizontalPadding(BuildContext context) => switch (size) {
    AppButtonSize.sm => context.tokens.spaceMd,
    AppButtonSize.md => context.tokens.spaceLg,
    AppButtonSize.lg => context.tokens.spaceXl,
  };

  ({Color bg, Color fg, Color? border, Color overlay}) _palette(
    BuildContext context,
  ) {
    final c = context.colors;
    return switch (variant) {
      AppButtonVariant.primary => (
        bg: c.primary,
        fg: c.primaryForeground,
        border: null,
        overlay: c.primaryForeground,
      ),
      AppButtonVariant.secondary => (
        bg: c.secondary,
        fg: c.secondaryForeground,
        border: null,
        overlay: c.foreground,
      ),
      AppButtonVariant.ghost => (
        bg: Colors.transparent,
        fg: c.foreground,
        border: null,
        overlay: c.foreground,
      ),
      AppButtonVariant.outline => (
        bg: Colors.transparent,
        fg: c.foreground,
        border: c.border,
        overlay: c.foreground,
      ),
      AppButtonVariant.destructive => (
        bg: c.destructive,
        fg: c.destructiveForeground,
        border: null,
        overlay: c.destructiveForeground,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = context.colors;
    final typography = context.typography;
    final p = _palette(context);
    final enabled = onPressed != null && !isLoading;

    final textStyle =
        (size == AppButtonSize.sm ? typography.label : typography.titleMd)
            .copyWith(color: p.fg);

    final baseStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, _height)),
      fixedSize: WidgetStatePropertyAll(Size.fromHeight(_height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: _horizontalPadding(context)),
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return p.bg == Colors.transparent ? Colors.transparent : colors.muted;
        }
        return p.bg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.mutedForeground;
        }
        return p.fg;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return p.overlay.withValues(alpha: 0.16);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return p.overlay.withValues(alpha: 0.08);
        }
        return null;
      }),
      textStyle: WidgetStatePropertyAll(textStyle),
      iconColor: WidgetStatePropertyAll(p.fg),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: tokens.borderRadiusMd),
      ),
      side: p.border == null
          ? null
          : WidgetStateProperty.resolveWith((states) {
              final color = states.contains(WidgetState.disabled)
                  ? colors.border
                  : p.border!;
              return BorderSide(color: color, width: tokens.borderHairline);
            }),
      elevation: const WidgetStatePropertyAll(0),
    );

    final effectiveStyle = style == null ? baseStyle : baseStyle.merge(style);

    final Widget content;
    if (isLoading) {
      content = SizedBox(
        height: tokens.iconMd,
        width: tokens.iconMd,
        child: AppSpinner(size: tokens.iconMd, color: p.fg),
      );
    } else if (leadingIcon == null && trailingIcon == null) {
      content = Text(label);
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            leadingIcon!,
            SizedBox(width: tokens.spaceSm),
          ],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          if (trailingIcon != null) ...[
            SizedBox(width: tokens.spaceSm),
            trailingIcon!,
          ],
        ],
      );
    }

    Widget button = TextButton(
      onPressed: enabled ? onPressed : null,
      onLongPress: enabled ? onLongPress : null,
      autofocus: autofocus,
      focusNode: focusNode,
      style: effectiveStyle,
      child: content,
    );

    // While loading the child is a spinner with no text, so inject the label as
    // the accessible name and announce the busy state to assistive tech.
    // Otherwise the TextButton's own text already provides the button semantics.
    if (isLoading) {
      button = Semantics(
        button: true,
        enabled: false,
        label: label,
        liveRegion: true,
        child: ExcludeSemantics(child: button),
      );
    }

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
