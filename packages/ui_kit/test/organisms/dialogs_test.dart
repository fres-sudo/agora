import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  group('ConfirmationDialog', () {
    testWidgets('returns true when confirmed', (tester) async {
      late Future<bool> result;
      await tester.pumpComponent(
        Builder(
          builder: (context) => AppButton.primary(
            label: 'open',
            onPressed: () => result = ConfirmationDialog.showDelete(
              context: context,
              title: 'Delete?',
              message: 'This cannot be undone',
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Delete?'), findsOneWidget);
      await tester.tap(find.text('Yes, Delete'));
      await tester.pumpAndSettle();
      expect(await result, isTrue);
    });

    testWidgets('returns false when cancelled', (tester) async {
      late Future<bool> result;
      await tester.pumpComponent(
        Builder(
          builder: (context) => AppButton.primary(
            label: 'open',
            onPressed: () => result = ConfirmationDialog.show(
              context: context,
              title: 'Sure?',
              message: 'confirm',
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(await result, isFalse);
    });
  });

  group('AppDialog', () {
    testWidgets('shows title, content and actions; returns popped value', (
      tester,
    ) async {
      late Future<String?> result;
      await tester.pumpComponent(
        Builder(
          builder: (context) => AppButton.primary(
            label: 'open',
            onPressed: () => result = AppDialog.show<String>(
              context: context,
              dialog: AppDialog(
                title: 'Pick',
                subtitle: 'choose one',
                content: const AppText.body('Body content'),
                actions: [
                  Builder(
                    builder: (ctx) => AppButton.primary(
                      label: 'Choose',
                      onPressed: () => Navigator.of(ctx).pop('picked'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Pick'), findsOneWidget);
      expect(find.text('Body content'), findsOneWidget);
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(await result, 'picked');
    });
  });

  group('AppSheetScaffold', () {
    testWidgets('aligns the close control with its title', (tester) async {
      await tester.pumpComponent(
        Builder(
          builder: (context) => AppButton.primary(
            label: 'open',
            onPressed: () => AdaptiveModal.show<void>(
              context: context,
              builder: (_, scrollController) => AppSheetScaffold(
                title: 'Filters',
                scrollController: scrollController,
                body: const AppText.body('Dialog body'),
                actions: [AppButton.primary(onPressed: () {}, label: 'Apply')],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final titleCenter = tester.getCenter(find.text('Filters'));
      final closeCenter = tester.getCenter(find.byTooltip('Close dialog'));
      expect((titleCenter.dy - closeCenter.dy).abs(), lessThanOrEqualTo(1));
    });
  });
}
