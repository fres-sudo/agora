import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

const _items = [
  AppSelectItem(value: 'apple', label: 'Apple'),
  AppSelectItem(value: 'banana', label: 'Banana'),
  AppSelectItem(value: 'cherry', label: 'Cherry'),
];

void main() {
  group('AppMultiSelect', () {
    testWidgets('renders placeholder when values is empty, both themes', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        await tester.pumpComponent(
          AppMultiSelect<String>(
            items: _items,
            values: const [],
            placeholder: 'Pick fruits',
            onChanged: (_) {},
          ),
          brightness: brightness,
        );
        expect(find.text('Pick fruits'), findsOneWidget);
      }
    });

    testWidgets('renders chips for the selected values', (tester) async {
      await tester.pumpComponent(
        AppMultiSelect<String>(
          items: _items,
          values: const ['apple', 'cherry'],
          onChanged: (_) {},
        ),
      );
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('toggling a row adds/removes values, preserving items order', (
      tester,
    ) async {
      List<String> values = const [];
      await tester.pumpComponent(
        StatefulBuilder(
          builder: (context, setState) {
            return AppMultiSelect<String>(
              items: _items,
              values: values,
              placeholder: 'Pick fruits',
              onChanged: (next) => setState(() => values = next),
            );
          },
        ),
      );

      await tester.tap(find.text('Pick fruits'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      // Once open, selected values render both as a trigger chip and as an
      // option row — scope taps to the option list to disambiguate.
      Finder optionRow(String label) => find.descendant(
        of: find.byType(ListView),
        matching: find.text(label),
      );

      // Select cherry then apple (reverse order) — result must still
      // follow `items` order (apple, cherry), not selection order.
      await tester.tap(optionRow('Cherry'));
      await tester.pump();
      await tester.tap(optionRow('Apple'));
      await tester.pump();

      expect(values, ['apple', 'cherry']);

      // Popover stays open after toggling (multi-select never auto-closes).
      expect(find.text('Banana'), findsOneWidget);

      // Toggling apple off again removes just that value.
      await tester.tap(optionRow('Apple'));
      await tester.pump();
      expect(values, ['cherry']);
    });

    testWidgets(
      "tapping a trigger chip's delete removes just that value and does not toggle the popover",
      (tester) async {
        List<String> values = const ['apple', 'banana'];
        await tester.pumpComponent(
          StatefulBuilder(
            builder: (context, setState) {
              return AppMultiSelect<String>(
                items: _items,
                values: values,
                onChanged: (next) => setState(() => values = next),
              );
            },
          ),
        );

        await tester.tap(find.byIcon(AgoraIcons.x_mark).first);
        await tester.pumpAndSettle(const Duration(milliseconds: 20));

        expect(values, ['banana']);
        // Popover must not have opened as a side effect of the delete tap.
        expect(find.text('Cherry'), findsNothing);
      },
    );

    testWidgets('maxVisibleChips collapses overflow into a +N chip', (
      tester,
    ) async {
      await tester.pumpComponent(
        AppMultiSelect<String>(
          items: _items,
          values: const ['apple', 'banana', 'cherry'],
          maxVisibleChips: 2,
          onChanged: (_) {},
        ),
      );

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsNothing);
      expect(find.text('+1'), findsOneWidget);
    });
  });
}
