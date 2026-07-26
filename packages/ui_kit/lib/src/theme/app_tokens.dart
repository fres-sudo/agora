import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// The non-colour parts of Agora's design language, resolved with
/// `context.tokens`.
///
/// Grouping related values keeps call sites expressive: for example,
/// `context.tokens.spacing.sm` and `context.tokens.radius.lg`.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.spacing,
    required this.border,
    required this.radius,
    required this.iconSize,
    required this.shadows,
    required this.durations,
  });

  final AppSpacing spacing;
  final AppBorder border;
  final AppRadius radius;
  final AppIconSize iconSize;
  final AppShadows shadows;
  final AppDurations durations;

  static const AppTokens light = AppTokens(
    spacing: AppSpacing.standard(),
    border: AppBorder.standard(),
    radius: AppRadius.standard(),
    iconSize: AppIconSize.standard(),
    durations: AppDurations.standard(),
    shadows: AppShadows.light(),
  );

  static const AppTokens dark = AppTokens(
    spacing: AppSpacing.standard(),
    border: AppBorder.standard(),
    radius: AppRadius.standard(),
    iconSize: AppIconSize.standard(),
    durations: AppDurations.standard(),
    shadows: AppShadows.dark(),
  );

  @override
  AppTokens copyWith({
    AppSpacing? spacing,
    AppBorder? border,
    AppRadius? radius,
    AppIconSize? iconSize,
    AppShadows? shadows,
    AppDurations? durations,
  }) => AppTokens(
    spacing: spacing ?? this.spacing,
    border: border ?? this.border,
    radius: radius ?? this.radius,
    iconSize: iconSize ?? this.iconSize,
    shadows: shadows ?? this.shadows,
    durations: durations ?? this.durations,
  );

  @override
  AppTokens lerp(covariant ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      spacing: spacing.lerp(other.spacing, t),
      border: border.lerp(other.border, t),
      radius: radius.lerp(other.radius, t),
      iconSize: iconSize.lerp(other.iconSize, t),
      shadows: shadows.lerp(other.shadows, t),
      durations: durations.lerp(other.durations, t),
    );
  }
}

@immutable
class AppSpacing {
  const AppSpacing({
    required this.xxxs,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  const AppSpacing.standard()
    : xxxs = 2,
      xxs = 4,
      xs = 8,
      sm = 12,
      md = 16,
      lg = 20,
      xl = 28,
      xxl = 40;

  final double xxxs;
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  AppSpacing copyWith({
    double? xxxs,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) => AppSpacing(
    xxxs: xxxs ?? this.xxxs,
    xxs: xxs ?? this.xxs,
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    xl: xl ?? this.xl,
    xxl: xxl ?? this.xxl,
  );

  AppSpacing lerp(AppSpacing other, double t) => AppSpacing(
    xxxs: _lerp(xxxs, other.xxxs, t),
    xxs: _lerp(xxs, other.xxs, t),
    xs: _lerp(xs, other.xs, t),
    sm: _lerp(sm, other.sm, t),
    md: _lerp(md, other.md, t),
    lg: _lerp(lg, other.lg, t),
    xl: _lerp(xl, other.xl, t),
    xxl: _lerp(xxl, other.xxl, t),
  );
}

@immutable
class AppBorder {
  const AppBorder({
    required this.hairline,
    required this.thin,
    required this.thick,
  });

  const AppBorder.standard() : hairline = 1, thin = 1, thick = 1.5;

  final double hairline;
  final double thin;
  final double thick;

  AppBorder copyWith({double? hairline, double? thin, double? thick}) =>
      AppBorder(
        hairline: hairline ?? this.hairline,
        thin: thin ?? this.thin,
        thick: thick ?? this.thick,
      );

  AppBorder lerp(AppBorder other, double t) => AppBorder(
    hairline: _lerp(hairline, other.hairline, t),
    thin: _lerp(thin, other.thin, t),
    thick: _lerp(thick, other.thick, t),
  );
}

@immutable
class AppRadius {
  const AppRadius({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.full,
  });

  const AppRadius.standard() : xs = 4, sm = 8, md = 12, lg = 16, full = 999;

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double full;

  BorderRadius get borderXs => BorderRadius.circular(xs);
  BorderRadius get borderSm => BorderRadius.circular(sm);
  BorderRadius get borderMd => BorderRadius.circular(md);
  BorderRadius get borderLg => BorderRadius.circular(lg);
  BorderRadius get borderFull => BorderRadius.circular(full);

  AppRadius copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? full,
  }) => AppRadius(
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    full: full ?? this.full,
  );

  AppRadius lerp(AppRadius other, double t) => AppRadius(
    xs: _lerp(xs, other.xs, t),
    sm: _lerp(sm, other.sm, t),
    md: _lerp(md, other.md, t),
    lg: _lerp(lg, other.lg, t),
    full: _lerp(full, other.full, t),
  );
}

@immutable
class AppIconSize {
  const AppIconSize({required this.sm, required this.md, required this.lg});

  const AppIconSize.standard() : sm = 16, md = 20, lg = 24;

  final double sm;
  final double md;
  final double lg;

  AppIconSize copyWith({double? sm, double? md, double? lg}) =>
      AppIconSize(sm: sm ?? this.sm, md: md ?? this.md, lg: lg ?? this.lg);

  AppIconSize lerp(AppIconSize other, double t) => AppIconSize(
    sm: _lerp(sm, other.sm, t),
    md: _lerp(md, other.md, t),
    lg: _lerp(lg, other.lg, t),
  );
}

@immutable
class AppDurations {
  const AppDurations({
    required this.fast,
    required this.normal,
    required this.slow,
  });

  const AppDurations.standard()
    : fast = const Duration(milliseconds: 120),
      normal = const Duration(milliseconds: 200),
      slow = const Duration(milliseconds: 320);

  final Duration fast;
  final Duration normal;
  final Duration slow;

  AppDurations copyWith({Duration? fast, Duration? normal, Duration? slow}) =>
      AppDurations(
        fast: fast ?? this.fast,
        normal: normal ?? this.normal,
        slow: slow ?? this.slow,
      );

  AppDurations lerp(AppDurations other, double t) => t < 0.5 ? this : other;
}

@immutable
class AppShadows {
  const AppShadows({required this.sm, required this.md, required this.lg});

  const AppShadows.light()
    : sm = const [],
      md = const [
        BoxShadow(
          color: Color(0x33141414),
          blurRadius: 0,
          offset: Offset(2, 2),
        ),
      ],
      lg = const [
        BoxShadow(
          color: Color(0x40141414),
          blurRadius: 0,
          offset: Offset(4, 4),
        ),
      ];

  const AppShadows.dark()
    : sm = const [],
      md = const [
        BoxShadow(
          color: Color(0x33FFFFFF),
          blurRadius: 0,
          offset: Offset(2, 2),
        ),
      ],
      lg = const [
        BoxShadow(
          color: Color(0x40FFFFFF),
          blurRadius: 0,
          offset: Offset(4, 4),
        ),
      ];

  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;

  AppShadows copyWith({
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
  }) => AppShadows(sm: sm ?? this.sm, md: md ?? this.md, lg: lg ?? this.lg);

  AppShadows lerp(AppShadows other, double t) => AppShadows(
    sm: BoxShadow.lerpList(sm, other.sm, t) ?? other.sm,
    md: BoxShadow.lerpList(md, other.md, t) ?? other.md,
    lg: BoxShadow.lerpList(lg, other.lg, t) ?? other.lg,
  );
}

double _lerp(double a, double b, double t) => lerpDouble(a, b, t)!;
