import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  testWidgets('shows a compact themed dialog and returns a date-only value', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late Future<DateTime?> result;
    await tester.pumpComponent(
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Open picker',
          onPressed: () => result = AppDatePicker.show(
            context: context,
            firstDate: DateTime(2025, 1, 1),
            lastDate: DateTime(2025, 12, 31),
            initialDate: DateTime(2025, 3, 10, 14, 30),
          ),
        ),
      ),
      brightness: Brightness.dark,
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    expect(find.text('Select date'), findsOneWidget);
    expect(
      tester.widget<Dialog>(find.byType(Dialog)).backgroundColor,
      AppColors.dark.popover,
    );
    final dialogSize = tester.getSize(
      find.byKey(const ValueKey('app-date-picker-dialog')),
    );
    expect(dialogSize.width, lessThan(375));
    expect(dialogSize.height, lessThan(600));

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(await result, DateTime(2025, 3, 10));
  });

  testWidgets('requires a date before applying', (tester) async {
    late Future<DateTime?> result;
    await tester.pumpComponent(
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Open picker',
          onPressed: () => result = AppDatePicker.show(
            context: context,
            firstDate: DateTime(2025, 3, 1),
            lastDate: DateTime(2025, 3, 31),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    var applyButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Apply'),
    );
    expect(applyButton.onPressed, isNull);

    await tester.tap(find.text('10'));
    await tester.pumpAndSettle();
    applyButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Apply'),
    );
    expect(applyButton.onPressed, isNotNull);

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(await result, DateTime(2025, 3, 10));
  });
}
