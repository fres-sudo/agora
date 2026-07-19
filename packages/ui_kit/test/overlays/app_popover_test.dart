import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/src/overlays/app_popover.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

Widget _harness({
  AppPopoverController? controller,
  bool barrierDismissible = true,
  double estimatedContentHeight = 320,
}) {
  return AppPopoverAnchor(
    controller: controller,
    barrierDismissible: barrierDismissible,
    estimatedContentHeight: estimatedContentHeight,
    triggerBuilder: (context, controller) =>
        TextButton(onPressed: controller.toggle, child: const Text('Trigger')),
    contentBuilder: (context, controller) => GestureDetector(
      // Absorb taps so the "inside tap does not dismiss" test can tap
      // content without the trigger's own tap semantics interfering.
      onTap: () {},
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text('Popover content'),
      ),
    ),
  );
}

void main() {
  group('AppPopoverAnchor', () {
    testWidgets('renders trigger only; content absent until opened', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        await tester.pumpComponent(_harness(), brightness: brightness);
        expect(find.text('Trigger'), findsOneWidget);
        expect(find.text('Popover content'), findsNothing);
      }
    });

    testWidgets('tapping the trigger opens the popover', (tester) async {
      await tester.pumpComponent(_harness());
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Popover content'), findsOneWidget);
    });

    testWidgets('tapping outside the popover (barrier) closes it', (
      tester,
    ) async {
      await tester.pumpComponent(_harness());
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Popover content'), findsOneWidget);

      // Tap far away from both trigger and popover content.
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets(
      'barrierDismissible: false keeps the popover open on outside tap',
      (tester) async {
        await tester.pumpComponent(_harness(barrierDismissible: false));
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));

        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));
        expect(find.text('Popover content'), findsOneWidget);
      },
    );

    testWidgets('tapping inside the popover content does not dismiss it', (
      tester,
    ) async {
      await tester.pumpComponent(_harness());
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      await tester.tap(find.text('Popover content'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Popover content'), findsOneWidget);
    });

    testWidgets('Escape key closes the popover', (tester) async {
      await tester.pumpComponent(_harness());
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Popover content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('flips above the trigger when there is not enough room below', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: _harness(estimatedContentHeight: 500),
            ),
          ),
        ),
      );

      final triggerTopBefore = tester.getTopLeft(find.text('Trigger')).dy;
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      final contentTop = tester.getTopLeft(find.text('Popover content')).dy;
      expect(contentTop, lessThan(triggerTopBefore));
    });

    testWidgets(
      'disposing the trigger while open does not throw or leak overlay entries',
      (tester) async {
        await tester.pumpComponent(_harness());
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));
        expect(find.text('Popover content'), findsOneWidget);

        // Replace the whole tree while the popover is open.
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // A fresh tree afterwards must not show any stale popover content.
        await tester.pumpComponent(_harness());
        expect(find.text('Popover content'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('an externally-supplied controller drives open state', (
      tester,
    ) async {
      final controller = AppPopoverController();
      await tester.pumpComponent(_harness(controller: controller));
      expect(find.text('Popover content'), findsNothing);

      controller.open();
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Popover content'), findsOneWidget);

      controller.close();
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Popover content'), findsNothing);
      controller.dispose();
    });
  });
}
