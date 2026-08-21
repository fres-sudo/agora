import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  testWidgets('returns the selected date and time in 24-hour mode', (
    tester,
  ) async {
    late Future<DateTime?> result;
    await tester.pumpComponent(
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Open picker',
          onPressed: () => result = AppDateTimePicker.show(
            context: context,
            firstDate: DateTime(2025, 1, 1),
            lastDate: DateTime(2025, 12, 31),
            initialDateTime: DateTime(2025, 3, 10, 14, 30),
            minuteInterval: 15,
          ),
        ),
      ),
      alwaysUse24HourFormat: true,
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    expect(find.text('Select date and time'), findsOneWidget);
    expect(find.text('Hour'), findsOneWidget);
    expect(find.text('Minute'), findsOneWidget);
    expect(find.text('Period'), findsNothing);
    expect(find.text('14'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('app-date-time-minute')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('45').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Apply'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(await result, DateTime(2025, 3, 10, 14, 45));
  });

  testWidgets('supports 12-hour periods and phone landscape', (tester) async {
    tester.view.physicalSize = const Size(667, 375);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpComponent(
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Open picker',
          onPressed: () => AppDateTimePicker.show(
            context: context,
            firstDate: DateTime(2025, 1, 1),
            lastDate: DateTime(2025, 12, 31),
            initialDateTime: DateTime(2025, 3, 10, 14, 30),
          ),
        ),
      ),
      brightness: Brightness.dark,
      alwaysUse24HourFormat: false,
      textScaler: const TextScaler.linear(2),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    expect(find.text('Period'), findsOneWidget);
    expect(find.text('PM'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final dialogSize = tester.getSize(
      find.byKey(const ValueKey('app-date-time-picker-dialog')),
    );
    expect(dialogSize.height, lessThan(375));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('rejects unsupported minute intervals', (tester) async {
    await tester.pumpComponent(const SizedBox());
    final context = tester.element(find.byType(Scaffold));

    expect(
      () => AppDateTimePicker.show(
        context: context,
        firstDate: DateTime(2025, 1, 1),
        lastDate: DateTime(2025, 12, 31),
        minuteInterval: 7,
      ),
      throwsArgumentError,
    );
  });
}
