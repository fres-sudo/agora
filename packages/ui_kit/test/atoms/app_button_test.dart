import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  group('AppButton widget', () {
    testWidgets('renders its label in both themes', (tester) async {
      for (final brightness in Brightness.values) {
        await tester.pumpComponent(
          AppButton.primary(label: 'Save', onPressed: () {}),
          brightness: brightness,
        );
        expect(find.text('Save'), findsOneWidget);
      }
    });

    testWidgets('fires onPressed when enabled', (tester) async {
      var taps = 0;
      await tester.pumpComponent(
        AppButton.primary(label: 'Tap', onPressed: () => taps++),
      );
      await tester.tap(find.byType(AppButton));
      expect(taps, 1);
    });

    testWidgets('does not fire when disabled (onPressed null)', (tester) async {
      await tester.pumpComponent(const AppButton.primary(label: 'Nope'));
      await tester.tap(find.byType(AppButton));
      expect(tester.takeException(), isNull);
    });

    testWidgets('isLoading shows a spinner, hides label taps', (tester) async {
      var taps = 0;
      await tester.pumpComponent(
        AppButton.primary(label: 'Busy', isLoading: true, onPressed: () => taps++),
      );
      expect(find.byType(AppSpinner), findsOneWidget);
      await tester.tap(find.byType(AppButton), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('all variants render without error', (tester) async {
      await tester.pumpComponent(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton.primary(label: 'P', onPressed: () {}),
            AppButton.secondary(label: 'S', onPressed: () {}),
            AppButton.ghost(label: 'G', onPressed: () {}),
            AppButton.outline(label: 'O', onPressed: () {}),
            AppButton.destructive(label: 'D', onPressed: () {}),
          ],
        ),
      );
      expect(find.byType(AppButton), findsNWidgets(5));
      expect(tester.takeException(), isNull);
    });
  });

  group('AppButton accessibility', () {
    testWidgets('meets tap-target and labeled-tap-target guidelines',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpComponent(
        AppButton.primary(label: 'Confirm', onPressed: () {}),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('primary and outline meet text-contrast guideline',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpComponent(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton.primary(label: 'Primary', onPressed: () {}),
            AppButton.outline(label: 'Outline', onPressed: () {}),
          ],
        ),
      );
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('keeps the accessible name while loading', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpComponent(
        const AppButton.primary(label: 'Saving', isLoading: true),
      );
      final node = tester.getSemantics(find.byType(AppButton));
      expect(node.label, 'Saving');
      handle.dispose();
    });
  });
}
