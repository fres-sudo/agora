import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_palette.dart';

/// Semantic color tokens, resolved from [BuildContext] via `context.colors`.
///
/// This is a [ThemeExtension], so the *same* field (e.g. [background]) returns a
/// different [Color] under light vs dark automatically — components never branch
/// on [Brightness]. Values are mapped from raw [AppPalette] ramps; the naming
/// follows the shadcn model (background/foreground pairs, muted, border, ring…).
///
/// ```dart
/// Container(color: context.colors.card) // resolves per theme, animates on switch
/// ```
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.success,
    required this.successForeground,
    required this.warning,
    required this.warningForeground,
    required this.info,
    required this.infoForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.overlay,
  });

  /// App canvas / scaffold background.
  final Color background;

  /// Default text/icon color on [background].
  final Color foreground;

  /// Elevated surface (cards, sheets, menus).
  final Color card;
  final Color cardForeground;

  /// Popover/tooltip/dropdown surface.
  final Color popover;
  final Color popoverForeground;

  /// Brand/primary action color.
  final Color primary;
  final Color primaryForeground;

  /// Low-emphasis secondary action/surface.
  final Color secondary;
  final Color secondaryForeground;

  /// Muted surface for subtle fills and disabled states.
  final Color muted;

  /// Muted text (captions, placeholders, secondary labels).
  final Color mutedForeground;

  /// Accent surface for hover/highlight.
  final Color accent;
  final Color accentForeground;

  /// Destructive/danger action color.
  final Color destructive;
  final Color destructiveForeground;

  /// Positive/success feedback.
  final Color success;
  final Color successForeground;

  /// Caution/warning feedback.
  final Color warning;
  final Color warningForeground;

  /// Informational feedback.
  final Color info;
  final Color infoForeground;

  /// Hairline separators and component outlines.
  final Color border;

  /// Input field border (may differ from [border]).
  final Color input;

  /// Focus ring color.
  final Color ring;

  /// Scrim behind modals/sheets.
  final Color overlay;

  /// Light theme token mapping.
  static const AppColors light = AppColors(
    background: AppPalette.white,
    foreground: AppPalette.neutral900,
    card: AppPalette.white,
    cardForeground: AppPalette.neutral900,
    popover: AppPalette.white,
    popoverForeground: AppPalette.neutral900,
    primary: AppPalette.primary500,
    // Dark text on the vivid brand green — meets WCAG AA (white would not).
    primaryForeground: AppPalette.neutral900,
    secondary: AppPalette.neutral100,
    secondaryForeground: AppPalette.neutral900,
    muted: AppPalette.neutral100,
    mutedForeground: AppPalette.neutral500,
    accent: AppPalette.neutral100,
    accentForeground: AppPalette.neutral900,
    destructive: AppPalette.error500,
    destructiveForeground: AppPalette.white,
    success: AppPalette.success600,
    successForeground: AppPalette.white,
    warning: AppPalette.warning500,
    warningForeground: AppPalette.neutral900,
    info: AppPalette.info500,
    infoForeground: AppPalette.white,
    border: AppPalette.neutral200,
    input: AppPalette.neutral200,
    ring: AppPalette.primary500,
    overlay: Color(0x80000000),
  );

  /// Dark theme token mapping.
  static const AppColors dark = AppColors(
    background: AppPalette.neutral900,
    foreground: AppPalette.neutral50,
    card: AppPalette.neutral800,
    cardForeground: AppPalette.neutral50,
    popover: AppPalette.neutral800,
    popoverForeground: AppPalette.neutral50,
    primary: AppPalette.primary500,
    primaryForeground: AppPalette.neutral900,
    secondary: AppPalette.neutral800,
    secondaryForeground: AppPalette.neutral50,
    muted: AppPalette.neutral800,
    mutedForeground: AppPalette.neutral400,
    accent: AppPalette.neutral700,
    accentForeground: AppPalette.neutral50,
    destructive: AppPalette.error500,
    destructiveForeground: AppPalette.neutral50,
    success: AppPalette.success500,
    successForeground: AppPalette.neutral950,
    warning: AppPalette.warning500,
    warningForeground: AppPalette.neutral950,
    info: AppPalette.info500,
    infoForeground: AppPalette.neutral50,
    border: AppPalette.neutral700,
    input: AppPalette.neutral700,
    ring: AppPalette.primary500,
    overlay: Color(0x99000000),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? success,
    Color? successForeground,
    Color? warning,
    Color? warningForeground,
    Color? info,
    Color? infoForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? overlay,
  }) {
    return AppColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      success: success ?? this.success,
      successForeground: successForeground ?? this.successForeground,
      warning: warning ?? this.warning,
      warningForeground: warningForeground ?? this.warningForeground,
      info: info ?? this.info,
      infoForeground: infoForeground ?? this.infoForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: c(background, other.background),
      foreground: c(foreground, other.foreground),
      card: c(card, other.card),
      cardForeground: c(cardForeground, other.cardForeground),
      popover: c(popover, other.popover),
      popoverForeground: c(popoverForeground, other.popoverForeground),
      primary: c(primary, other.primary),
      primaryForeground: c(primaryForeground, other.primaryForeground),
      secondary: c(secondary, other.secondary),
      secondaryForeground: c(secondaryForeground, other.secondaryForeground),
      muted: c(muted, other.muted),
      mutedForeground: c(mutedForeground, other.mutedForeground),
      accent: c(accent, other.accent),
      accentForeground: c(accentForeground, other.accentForeground),
      destructive: c(destructive, other.destructive),
      destructiveForeground:
          c(destructiveForeground, other.destructiveForeground),
      success: c(success, other.success),
      successForeground: c(successForeground, other.successForeground),
      warning: c(warning, other.warning),
      warningForeground: c(warningForeground, other.warningForeground),
      info: c(info, other.info),
      infoForeground: c(infoForeground, other.infoForeground),
      border: c(border, other.border),
      input: c(input, other.input),
      ring: c(ring, other.ring),
      overlay: c(overlay, other.overlay),
    );
  }
}
