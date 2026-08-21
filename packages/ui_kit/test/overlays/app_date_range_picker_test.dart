import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  testWidgets('shows a compact dialog and returns the applied range', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late Future<DateTimeRange?> result;
    final initialRange = DateTimeRange(
      start: DateTime(2025, 3, 10),
      end: DateTime(2025, 3, 14),
    );

    await tester.pumpComponent(
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Open picker',
          onPressed: () => result = AppDateRangePicker.show(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            initialRange: initialRange,
          ),
        ),
      ),
      brightness: Brightness.dark,
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    expect(find.text('Select date range'), findsOneWidget);
    expect(
      tester.widget<Dialog>(find.byType(Dialog)).backgroundColor,
      AppColors.dark.popover,
    );
    final dialogSize = tester.getSize(
      find.byKey(const ValueKey('app-date-range-picker-dialog')),
    );
    expect(dialogSize.width, lessThan(375));
    expect(dialogSize.height, lessThan(600));
    final dayTargetSize = tester.getSize(
      find.ancestor(of: find.text('10'), matching: find.byType(InkResponse)),
    );
    expect(dayTargetSize.width, greaterThanOrEqualTo(48));
    expect(dayTargetSize.height, greaterThanOrEqualTo(48));

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(await result, initialRange);
  });

  testWidgets('requires both ends of the range before applying', (
    tester,
  ) async {
    await tester.pumpComponent(
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Open picker',
          onPressed: () => AppDateRangePicker.show(
            context: context,
            firstDate: DateTime(2025, 1, 1),
            lastDate: DateTime(2025, 12, 31),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    final applyButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Apply'),
    );
    expect(applyButton.onPressed, isNull);
  });

  testWidgets('remains usable in a phone landscape viewport', (tester) async {
    tester.view.physicalSize = const Size(667, 375);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpComponent(
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Open picker',
          onPressed: () => AppDateRangePicker.show(
            context: context,
            firstDate: DateTime(2025, 1, 1),
            lastDate: DateTime(2025, 12, 31),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final dialogSize = tester.getSize(
      find.byKey(const ValueKey('app-date-range-picker-dialog')),
    );
    expect(dialogSize.height, lessThan(375));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
