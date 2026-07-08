import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AppColors', () {
    test('light and dark resolve to different backgrounds', () {
      expect(AppColors.light.background, isNot(AppColors.dark.background));
      expect(AppColors.light.foreground, isNot(AppColors.dark.foreground));
    });

    test('lerp(0) == start and lerp(1) == end', () {
      final mid = AppColors.light.lerp(AppColors.dark, 0);
      expect(mid.background, AppColors.light.background);
      final end = AppColors.light.lerp(AppColors.dark, 1);
      expect(end.background, AppColors.dark.background);
    });

    test('copyWith overrides only the given token', () {
      final custom = AppColors.light.copyWith(primary: const Color(0xFF0000FF));
      expect(custom.primary, const Color(0xFF0000FF));
      expect(custom.background, AppColors.light.background);
    });
  });

  group('AppTokens', () {
    test('shadows differ between light and dark, spacing does not', () {
      expect(AppTokens.light.spaceLg, AppTokens.dark.spaceLg);
      expect(AppTokens.light.shadowMd, isNot(AppTokens.dark.shadowMd));
    });

    test('lerp interpolates a scalar token', () {
      final t = AppTokens.light.lerp(
        AppTokens.light.copyWith(radiusMd: 20),
        0.5,
      );
      expect(t.radiusMd, closeTo((AppTokens.light.radiusMd + 20) / 2, 0.001));
    });
  });

  group('AppTheme', () {
    test('light registers all three design-system extensions', () {
      final theme = AppTheme.light;
      expect(theme.extension<AppColors>(), isNotNull);
      expect(theme.extension<AppTypography>(), isNotNull);
      expect(theme.extension<AppTokens>(), isNotNull);
      expect(theme.brightness, Brightness.light);
    });

    test('dark registers all three design-system extensions', () {
      final theme = AppTheme.dark;
      expect(theme.extension<AppColors>(), AppColors.dark);
      expect(theme.extension<AppTokens>(), AppTokens.dark);
      expect(theme.brightness, Brightness.dark);
    });
  });

  group('context accessors', () {
    testWidgets('context.colors/typography/tokens resolve per theme', (
      tester,
    ) async {
      late AppColors captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Builder(
            builder: (context) {
              captured = context.colors;
              expect(context.tokens, isA<AppTokens>());
              expect(context.typography.body, isA<TextStyle>());
              return const SizedBox();
            },
          ),
        ),
      );
      expect(captured.background, AppColors.dark.background);
    });
  });
}
