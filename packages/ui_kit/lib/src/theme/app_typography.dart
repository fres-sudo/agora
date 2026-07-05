import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Named typographic scale (Inter), resolved via `context.typography`.
///
/// Styles are intentionally **color-agnostic** — they carry size/weight/spacing
/// only and inherit their color from the surrounding [DefaultTextStyle] /
/// `context.colors.foreground`. That keeps a single type ramp valid in both
/// light and dark. Exposed as a [ThemeExtension] so it participates in theme
/// `lerp` and is reachable ergonomically from any [BuildContext].
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.displayLg,
    required this.displayMd,
    required this.headingLg,
    required this.headingMd,
    required this.headingSm,
    required this.titleLg,
    required this.titleMd,
    required this.body,
    required this.bodySm,
    required this.label,
    required this.caption,
    required this.mono,
  });

  final TextStyle displayLg;
  final TextStyle displayMd;

  /// h1
  final TextStyle headingLg;

  /// h2
  final TextStyle headingMd;

  /// h3
  final TextStyle headingSm;

  final TextStyle titleLg;
  final TextStyle titleMd;

  /// Default paragraph text.
  final TextStyle body;
  final TextStyle bodySm;

  /// Form labels / emphasized small text.
  final TextStyle label;

  /// Captions, helper text, timestamps.
  final TextStyle caption;

  /// Monospaced (prices in tables, codes, receipts).
  final TextStyle mono;

  /// Font family names (bundled as assets in this package — no runtime fetch).
  static const String monoFontFamily = 'JetBrainsMono';
  static const String _package = 'ui_kit';

  /// The Inter-based standard scale used by both light and dark themes.
  factory AppTypography.standard() {
    TextStyle sans({
      required double size,
      required FontWeight weight,
      double height = 1.4,
      double? letterSpacing,
    }) => GoogleFonts.interTight(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );

    return AppTypography(
      displayLg: sans(size: 36, weight: FontWeight.w700, height: 1.1, letterSpacing: -0.5),
      displayMd: sans(size: 30, weight: FontWeight.w700, height: 1.15, letterSpacing: -0.4),
      headingLg: sans(size: 24, weight: FontWeight.w600, height: 1.2, letterSpacing: -0.3),
      headingMd: sans(size: 20, weight: FontWeight.w600, height: 1.25, letterSpacing: -0.2),
      headingSm: sans(size: 18, weight: FontWeight.w600, height: 1.3, letterSpacing: -0.1),
      titleLg: sans(size: 16, weight: FontWeight.w600, height: 1.4),
      titleMd: sans(size: 14, weight: FontWeight.w600, height: 1.4),
      body: sans(size: 14, weight: FontWeight.w400, height: 1.5),
      bodySm: sans(size: 13, weight: FontWeight.w400, height: 1.5),
      label: sans(size: 13, weight: FontWeight.w500, height: 1.4, letterSpacing: 0.1),
      caption: sans(size: 12, weight: FontWeight.w400, height: 1.4),
      mono: const TextStyle(
        fontFamily: monoFontFamily,
        package: _package,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
    );
  }

  /// Builds a Material [TextTheme] from this scale so framework widgets that
  /// read `Theme.of(context).textTheme` stay visually consistent.
  TextTheme toTextTheme() => TextTheme(
    displayLarge: displayLg,
    displayMedium: displayMd,
    displaySmall: headingLg,
    headlineLarge: headingLg,
    headlineMedium: headingMd,
    headlineSmall: headingSm,
    titleLarge: titleLg,
    titleMedium: titleMd,
    titleSmall: label,
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: bodySm,
    labelLarge: label,
    labelMedium: label,
    labelSmall: caption,
  );

  @override
  AppTypography copyWith({
    TextStyle? displayLg,
    TextStyle? displayMd,
    TextStyle? headingLg,
    TextStyle? headingMd,
    TextStyle? headingSm,
    TextStyle? titleLg,
    TextStyle? titleMd,
    TextStyle? body,
    TextStyle? bodySm,
    TextStyle? label,
    TextStyle? caption,
    TextStyle? mono,
  }) {
    return AppTypography(
      displayLg: displayLg ?? this.displayLg,
      displayMd: displayMd ?? this.displayMd,
      headingLg: headingLg ?? this.headingLg,
      headingMd: headingMd ?? this.headingMd,
      headingSm: headingSm ?? this.headingSm,
      titleLg: titleLg ?? this.titleLg,
      titleMd: titleMd ?? this.titleMd,
      body: body ?? this.body,
      bodySm: bodySm ?? this.bodySm,
      label: label ?? this.label,
      caption: caption ?? this.caption,
      mono: mono ?? this.mono,
    );
  }

  @override
  AppTypography lerp(covariant ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    TextStyle s(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return AppTypography(
      displayLg: s(displayLg, other.displayLg),
      displayMd: s(displayMd, other.displayMd),
      headingLg: s(headingLg, other.headingLg),
      headingMd: s(headingMd, other.headingMd),
      headingSm: s(headingSm, other.headingSm),
      titleLg: s(titleLg, other.titleLg),
      titleMd: s(titleMd, other.titleMd),
      body: s(body, other.body),
      bodySm: s(bodySm, other.bodySm),
      label: s(label, other.label),
      caption: s(caption, other.caption),
      mono: s(mono, other.mono),
    );
  }
}
