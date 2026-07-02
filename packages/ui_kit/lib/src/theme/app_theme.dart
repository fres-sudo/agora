import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_colors.dart';
import 'package:ui_kit/src/theme/app_tokens.dart';
import 'package:ui_kit/src/theme/app_typography.dart';

/// Builds the light/dark [ThemeData] for the app.
///
/// The design system is driven by three [ThemeExtension]s ([AppColors],
/// [AppTypography], [AppTokens]) registered here for both brightnesses. Material
/// widgets are additionally themed from the same semantic tokens so first-party
/// widgets (dialogs, switches, text fields) stay visually consistent with the
/// custom components without any per-widget overrides.
abstract final class AppTheme {
  static ThemeData get light => _build(
    brightness: Brightness.light,
    colors: AppColors.light,
    tokens: AppTokens.light,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    colors: AppColors.dark,
    tokens: AppTokens.dark,
  );

  /// @Deprecated Use [light].
  @Deprecated('Use AppTheme.light')
  static ThemeData get lightTheme => light;

  static ThemeData _build({
    required Brightness brightness,
    required AppColors colors,
    required AppTokens tokens,
  }) {
    final typography = AppTypography.standard();
    // Text styles already carry the bundled Inter family; only apply colors.
    final textTheme = typography.toTextTheme().apply(
      bodyColor: colors.foreground,
      displayColor: colors.foreground,
    );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.primaryForeground,
      secondary: colors.secondary,
      onSecondary: colors.secondaryForeground,
      error: colors.destructive,
      onError: colors.destructiveForeground,
      surface: colors.card,
      onSurface: colors.cardForeground,
      surfaceContainerHighest: colors.muted,
      onSurfaceVariant: colors.mutedForeground,
      outline: colors.border,
      outlineVariant: colors.border,
      // Material's "tonal" second surface used by FilledButton.tonal etc.
      secondaryContainer: colors.secondary,
      onSecondaryContainer: colors.secondaryForeground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      dividerColor: colors.border,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[colors, typography, tokens],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: typography.headingMd.copyWith(color: colors.foreground),
        shape: Border(bottom: BorderSide(color: colors.border)),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: tokens.borderHairline,
        space: tokens.borderHairline,
      ),
      iconTheme: IconThemeData(color: colors.foreground, size: tokens.iconMd),
      splashColor: colors.accent.withValues(alpha: 0.4),
      highlightColor: colors.accent.withValues(alpha: 0.3),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.popover,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: tokens.borderRadiusLg),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(colors.border),
      ),
    );
  }
}
