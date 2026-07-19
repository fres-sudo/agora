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
  group('AppSelect', () {
    testWidgets('renders placeholder when value is null, both themes', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        await tester.pumpComponent(
          AppSelect<String>(
            items: _items,
            placeholder: 'Pick a fruit',
            onChanged: (_) {},
          ),
          brightness: brightness,
        );
        expect(find.text('Pick a fruit'), findsOneWidget);
      }
    });

    testWidgets('renders the selected item label when value is set', (
      tester,
    ) async {
      await tester.pumpComponent(
        AppSelect<String>(
          items: _items,
          value: 'banana',
          placeholder: 'Pick a fruit',
          onChanged: (_) {},
        ),
      );
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Pick a fruit'), findsNothing);
    });

    testWidgets('tapping the trigger opens the popover with all options', (
      tester,
    ) async {
      await tester.pumpComponent(
        AppSelect<String>(
          items: _items,
          placeholder: 'Pick a fruit',
          onChanged: (_) {},
        ),
      );
      await tester.tap(find.text('Pick a fruit'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
    });

    testWidgets(
      'tapping an option fires onChanged with its value and closes the popover',
      (tester) async {
        String? selected;
        await tester.pumpComponent(
          StatefulBuilder(
            builder: (context, setState) {
              return AppSelect<String>(
                items: _items,
                value: selected,
                placeholder: 'Pick a fruit',
                onChanged: (value) => setState(() => selected = value),
              );
            },
          ),
        );

        await tester.tap(find.text('Pick a fruit'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));
        await tester.tap(find.text('Banana'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));

        expect(selected, 'banana');
        // Popover closed: only the trigger's own "Banana" text remains.
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Apple'), findsNothing);
      },
    );

    testWidgets('the selected row shows the check icon; others do not', (
      tester,
    ) async {
      await tester.pumpComponent(
        AppSelect<String>(items: _items, value: 'cherry', onChanged: (_) {}),
      );
      await tester.tap(find.byType(AppSelect<String>));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      expect(find.byIcon(AgoraIcons.check), findsOneWidget);
    });

    testWidgets('enabled: false blocks opening the popover', (tester) async {
      await tester.pumpComponent(
        AppSelect<String>(
          items: _items,
          placeholder: 'Pick a fruit',
          enabled: false,
          onChanged: (_) {},
        ),
      );
      await tester.tap(find.text('Pick a fruit'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('errorText renders a destructive caption', (tester) async {
      await tester.pumpComponent(
        AppSelect<String>(
          items: _items,
          placeholder: 'Pick a fruit',
          errorText: 'Required field',
          onChanged: (_) {},
        ),
      );
      expect(find.text('Required field'), findsOneWidget);
    });

    testWidgets('allowClear shows a clear affordance that nulls the value', (
      tester,
    ) async {
      String? selected = 'banana';
      await tester.pumpComponent(
        StatefulBuilder(
          builder: (context, setState) {
            return AppSelect<String>(
              items: _items,
              value: selected,
              allowClear: true,
              onChanged: (value) => setState(() => selected = value),
            );
          },
        ),
      );

      await tester.tap(find.byTooltip('Clear'));
      await tester.pump();
      expect(selected, isNull);
    });

    group('AppSelect accessibility', () {
      testWidgets('meets tap-target and labeled-tap-target guidelines', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await tester.pumpComponent(
          AppSelect<String>(
            items: _items,
            label: 'Fruit',
            placeholder: 'Pick a fruit',
            onChanged: (_) {},
          ),
        );
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });

      testWidgets('meets text-contrast guideline in both themes', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        for (final brightness in Brightness.values) {
          await tester.pumpComponent(
            AppSelect<String>(items: _items, value: 'apple', onChanged: (_) {}),
            brightness: brightness,
          );
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
        handle.dispose();
      });
    });
  });
}
