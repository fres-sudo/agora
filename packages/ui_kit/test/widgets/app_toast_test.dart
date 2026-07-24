import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  group('AppToast', () {
    testWidgets('renders semantic content and invokes its action', (
      tester,
    ) async {
      var actionCalled = false;
      await tester.pumpComponent(
        AppToast(
          variant: AppToastVariant.success,
          message: 'Order #42 completed',
          actionLabel: 'Undo',
          onAction: () => actionCalled = true,
        ),
      );

      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Order #42 completed'), findsOneWidget);
      expect(find.byTooltip('Dismiss'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      expect(actionCalled, isTrue);
    });

    testWidgets('supports each semantic variant in dark mode', (tester) async {
      for (final variant in AppToastVariant.values) {
        await tester.pumpComponent(
          AppToast(variant: variant, message: 'Toast message'),
          brightness: Brightness.dark,
        );

        expect(find.text('Toast message'), findsOneWidget);
        expect(find.byType(AppToast), findsOneWidget);
      }
    });

    testWidgets('shows the component through a floating SnackBar', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    AppToast.warning(context, message: 'Low stock'),
                child: const Text('Show toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show toast'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Warning'), findsOneWidget);
    });
  });
}
