import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Non-color design primitives — spacing, radii, borders, elevation, motion and
/// icon sizing — resolved via `context.tokens`.
///
/// This is a [ThemeExtension] mainly because **shadows are brightness-dependent**
/// (dark UIs need deeper, softer shadows). Spacing/radii/durations are identical
/// across themes but live here too so a widget has a single ergonomic accessor
/// for all non-color metrics.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.spaceXxs,
    required this.spaceXs,
    required this.spaceSm,
    required this.spaceMd,
    required this.spaceLg,
    required this.spaceXl,
    required this.spaceXxl,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusFull,
    required this.borderHairline,
    required this.borderThin,
    required this.borderThick,
    required this.iconSm,
    required this.iconMd,
    required this.iconLg,
    required this.durationFast,
    required this.durationNormal,
    required this.durationSlow,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
  });

  // Spacing scale (dp)
  final double spaceXxs; // 2
  final double spaceXs; // 4
  final double spaceSm; // 8
  final double spaceMd; // 12
  final double spaceLg; // 16
  final double spaceXl; // 24
  final double spaceXxl; // 32

  // Corner radii (dp)
  final double radiusSm; // 8
  final double radiusMd; // 12
  final double radiusLg; // 16
  final double radiusFull; // pill

  // Border widths (dp)
  final double borderHairline; // 1
  final double borderThin; // 1.5
  final double borderThick; // 2

  // Icon sizes (dp)
  final double iconSm; // 16
  final double iconMd; // 20
  final double iconLg; // 24

  // Motion
  final Duration durationFast;
  final Duration durationNormal;
  final Duration durationSlow;

  // Elevation (brightness-dependent)
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;

  BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // Notion-style neo-minimal / soft-brutalist scale: tight 4-6px radii,
  // generous whitespace for fast tap-accuracy, and flat surfaces — depth
  // (where unavoidable, e.g. dropdowns) reads as a crisp hard-edged offset
  // rather than a soft blur. See docs/architecture for the full style brief.
  static const AppTokens light = AppTokens(
    spaceXxs: 4,
    spaceXs: 8,
    spaceSm: 12,
    spaceMd: 16,
    spaceLg: 20,
    spaceXl: 28,
    spaceXxl: 40,
    radiusSm: 8,
    radiusMd: 12,
    radiusLg: 16,
    radiusFull: 999,
    borderHairline: 1,
    borderThin: 1,
    borderThick: 1.5,
    iconSm: 16,
    iconMd: 20,
    iconLg: 24,
    durationFast: Duration(milliseconds: 120),
    durationNormal: Duration(milliseconds: 200),
    durationSlow: Duration(milliseconds: 320),
    shadowSm: [],
    shadowMd: [BoxShadow(color: Color(0x33141414), blurRadius: 0, offset: Offset(2, 2))],
    shadowLg: [BoxShadow(color: Color(0x40141414), blurRadius: 0, offset: Offset(4, 4))],
  );

  static const AppTokens dark = AppTokens(
    spaceXxs: 4,
    spaceXs: 8,
    spaceSm: 12,
    spaceMd: 16,
    spaceLg: 20,
    spaceXl: 28,
    spaceXxl: 40,
    radiusSm: 8,
    radiusMd: 12,
    radiusLg: 16,
    radiusFull: 999,
    borderHairline: 1,
    borderThin: 1,
    borderThick: 1.5,
    iconSm: 16,
    iconMd: 20,
    iconLg: 24,
    durationFast: Duration(milliseconds: 120),
    durationNormal: Duration(milliseconds: 200),
    durationSlow: Duration(milliseconds: 320),
    shadowSm: [],
    // Dark canvases can't show a black offset shadow, so elevation reads as a
    // crisp, faint light-edged offset instead — same flat/hard-edge language.
    shadowMd: [BoxShadow(color: Color(0x33FFFFFF), blurRadius: 0, offset: Offset(2, 2))],
    shadowLg: [BoxShadow(color: Color(0x40FFFFFF), blurRadius: 0, offset: Offset(4, 4))],
  );

  @override
  AppTokens copyWith({
    double? spaceXxs,
    double? spaceXs,
    double? spaceSm,
    double? spaceMd,
    double? spaceLg,
    double? spaceXl,
    double? spaceXxl,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusFull,
    double? borderHairline,
    double? borderThin,
    double? borderThick,
    double? iconSm,
    double? iconMd,
    double? iconLg,
    Duration? durationFast,
    Duration? durationNormal,
    Duration? durationSlow,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowLg,
  }) {
    return AppTokens(
      spaceXxs: spaceXxs ?? this.spaceXxs,
      spaceXs: spaceXs ?? this.spaceXs,
      spaceSm: spaceSm ?? this.spaceSm,
      spaceMd: spaceMd ?? this.spaceMd,
      spaceLg: spaceLg ?? this.spaceLg,
      spaceXl: spaceXl ?? this.spaceXl,
      spaceXxl: spaceXxl ?? this.spaceXxl,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusFull: radiusFull ?? this.radiusFull,
      borderHairline: borderHairline ?? this.borderHairline,
      borderThin: borderThin ?? this.borderThin,
      borderThick: borderThick ?? this.borderThick,
      iconSm: iconSm ?? this.iconSm,
      iconMd: iconMd ?? this.iconMd,
      iconLg: iconLg ?? this.iconLg,
      durationFast: durationFast ?? this.durationFast,
      durationNormal: durationNormal ?? this.durationNormal,
      durationSlow: durationSlow ?? this.durationSlow,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
    );
  }

  @override
  AppTokens lerp(covariant ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    double d(double a, double b) => lerpDouble(a, b, t)!;
    List<BoxShadow> s(List<BoxShadow> a, List<BoxShadow> b) => BoxShadow.lerpList(a, b, t) ?? b;
    return AppTokens(
      spaceXxs: d(spaceXxs, other.spaceXxs),
      spaceXs: d(spaceXs, other.spaceXs),
      spaceSm: d(spaceSm, other.spaceSm),
      spaceMd: d(spaceMd, other.spaceMd),
      spaceLg: d(spaceLg, other.spaceLg),
      spaceXl: d(spaceXl, other.spaceXl),
      spaceXxl: d(spaceXxl, other.spaceXxl),
      radiusSm: d(radiusSm, other.radiusSm),
      radiusMd: d(radiusMd, other.radiusMd),
      radiusLg: d(radiusLg, other.radiusLg),
      radiusFull: d(radiusFull, other.radiusFull),
      borderHairline: d(borderHairline, other.borderHairline),
      borderThin: d(borderThin, other.borderThin),
      borderThick: d(borderThick, other.borderThick),
      iconSm: d(iconSm, other.iconSm),
      iconMd: d(iconMd, other.iconMd),
      iconLg: d(iconLg, other.iconLg),
      durationFast: t < 0.5 ? durationFast : other.durationFast,
      durationNormal: t < 0.5 ? durationNormal : other.durationNormal,
      durationSlow: t < 0.5 ? durationSlow : other.durationSlow,
      shadowSm: s(shadowSm, other.shadowSm),
      shadowMd: s(shadowMd, other.shadowMd),
      shadowLg: s(shadowLg, other.shadowLg),
    );
  }
}
