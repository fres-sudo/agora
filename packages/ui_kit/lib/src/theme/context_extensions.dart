import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_colors.dart';
import 'package:ui_kit/src/theme/app_tokens.dart';
import 'package:ui_kit/src/theme/app_typography.dart';

/// Ergonomic, null-safe access to the design-system [ThemeExtension]s.
///
/// These are the **only** sanctioned way for widgets to read design tokens.
/// Because they resolve through [Theme.of], the values are always correct for
/// the current light/dark context and animate across theme changes — no
/// `Theme.of(context).brightness == Brightness.dark` branching anywhere.
extension AppThemeContextX on BuildContext {
  /// Semantic color tokens (background, primary, border, …).
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;

  /// Typographic scale.
  AppTypography get typography =>
      Theme.of(this).extension<AppTypography>() ?? AppTypography.standard();

  /// Spacing, radii, borders, shadows, motion, icon sizes.
  AppTokens get tokens =>
      Theme.of(this).extension<AppTokens>() ?? AppTokens.light;
}
