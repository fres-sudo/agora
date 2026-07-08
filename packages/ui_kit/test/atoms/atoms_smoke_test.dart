import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  group('AppIconButton', () {
    testWidgets('fires onPressed and is labelled via tooltip', (tester) async {
      var taps = 0;
      final handle = tester.ensureSemantics();
      await tester.pumpComponent(
        AppIconButton.primary(
          icon: const Icon(AgoraIcons.plus),
          tooltip: 'Add item',
          onPressed: () => taps++,
        ),
      );
      await tester.tap(find.byType(AppIconButton));
      expect(taps, 1);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });

  group('AppBadge', () {
    testWidgets('renders label across variants in both themes', (tester) async {
      for (final brightness in Brightness.values) {
        await tester.pumpComponent(
          const Wrap(
            children: [
              AppBadge('New', variant: AppBadgeVariant.primary),
              AppBadge('OK', variant: AppBadgeVariant.success),
              AppBadge('Warn', variant: AppBadgeVariant.warning),
              AppBadge('Err', variant: AppBadgeVariant.destructive),
              AppBadge('Info', variant: AppBadgeVariant.info),
              AppBadge('Tag', variant: AppBadgeVariant.outline),
            ],
          ),
          brightness: brightness,
        );
        expect(find.text('New'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('AppSurface / AppSpinner / AppDivider', () {
    testWidgets('surface handles tap and renders child', (tester) async {
      var taps = 0;
      await tester.pumpComponent(
        AppSurface(
          elevation: AppElevation.md,
          onTap: () => taps++,
          child: const SizedBox(width: 40, height: 40),
        ),
      );
      await tester.tap(find.byType(AppSurface));
      expect(taps, 1);
    });

    testWidgets('spinner and divider render in both themes', (tester) async {
      for (final brightness in Brightness.values) {
        await tester.pumpComponent(
          const Column(
            children: [AppSpinner(), AppDivider(), AppDivider.vertical()],
          ),
          brightness: brightness,
        );
        expect(find.byType(AppSpinner), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('form atoms', () {
    testWidgets('switch and checkbox toggle', (tester) async {
      var switched = false;
      var checked = false;
      await tester.pumpComponent(
        Column(
          children: [
            AppSwitch(
              value: switched,
              semanticLabel: 'notifications',
              onChanged: (v) => switched = v,
            ),
            AppCheckbox(
              value: checked,
              label: 'agree',
              onChanged: (v) => checked = v ?? false,
            ),
          ],
        ),
      );
      await tester.tap(find.byType(AppSwitch));
      expect(switched, isTrue);
      await tester.tap(find.text('agree'));
      expect(checked, isTrue);
    });
  });

  group('display atoms', () {
    testWidgets('chip, avatar and skeleton render', (tester) async {
      await tester.pumpComponent(
        Column(
          children: [
            AppChip(label: 'Filter', selected: true, onTap: () {}),
            const AppAvatar(initials: 'FC', label: 'Franco'),
            const AppSkeleton(width: 80),
          ],
        ),
      );
      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('FC'), findsOneWidget);
      expect(tester.takeException(), isNull);
      // Let the skeleton animation controller tick without leaking a timer.
      await tester.pump(const Duration(milliseconds: 200));
    });
  });
}
