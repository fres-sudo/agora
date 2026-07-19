import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

const _items = [
  AppComboboxItem(value: 'apple', label: 'Apple'),
  AppComboboxItem(value: 'banana', label: 'Banana'),
  AppComboboxItem(value: 'cherry', label: 'Cherry'),
];

Finder _optionRow(String label) =>
    find.descendant(of: find.byType(ListView), matching: find.text(label));

void main() {
  group('AppCombobox', () {
    testWidgets('.single renders placeholder/selected label, both themes', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        await tester.pumpComponent(
          AppCombobox<String>.single(
            items: _items,
            placeholder: 'Pick a fruit',
            onChanged: (_) {},
          ),
          brightness: brightness,
        );
        expect(find.text('Pick a fruit'), findsOneWidget);
      }
    });

    testWidgets('.multiple renders chips for the selected values', (
      tester,
    ) async {
      await tester.pumpComponent(
        AppCombobox<String>.multiple(
          items: _items,
          values: const ['apple'],
          onChanged: (_) {},
        ),
      );
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('typing filters the visible option rows', (tester) async {
      await tester.pumpComponent(
        AppCombobox<String>.single(
          items: _items,
          placeholder: 'Pick a fruit',
          onChanged: (_) {},
        ),
      );
      await tester.tap(find.text('Pick a fruit'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      await tester.enterText(find.byType(TextField), 'ban');
      await tester.pump();

      expect(_optionRow('Banana'), findsOneWidget);
      expect(_optionRow('Apple'), findsNothing);
      expect(_optionRow('Cherry'), findsNothing);
    });

    testWidgets('empty filter shows the empty-results row', (tester) async {
      await tester.pumpComponent(
        AppCombobox<String>.single(
          items: _items,
          placeholder: 'Pick a fruit',
          onChanged: (_) {},
        ),
      );
      await tester.tap(find.text('Pick a fruit'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();

      expect(find.text('No results found.'), findsOneWidget);
    });

    testWidgets('clearing the query restores the full list', (tester) async {
      await tester.pumpComponent(
        AppCombobox<String>.single(
          items: _items,
          placeholder: 'Pick a fruit',
          onChanged: (_) {},
        ),
      );
      await tester.tap(find.text('Pick a fruit'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));
      await tester.enterText(find.byType(TextField), 'ban');
      await tester.pump();

      await tester.tap(find.byIcon(AgoraIcons.x_mark));
      await tester.pump();

      expect(_optionRow('Apple'), findsOneWidget);
      expect(_optionRow('Banana'), findsOneWidget);
      expect(_optionRow('Cherry'), findsOneWidget);
    });

    testWidgets(
      'arrow keys move the highlight without losing search-field focus; Enter commits',
      (tester) async {
        String? selected;
        await tester.pumpComponent(
          StatefulBuilder(
            builder: (context, setState) {
              return AppCombobox<String>.single(
                items: _items,
                placeholder: 'Pick a fruit',
                onChanged: (value) => setState(() => selected = value),
              );
            },
          ),
        );
        await tester.tap(find.text('Pick a fruit'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));

        expect(
          FocusManager.instance.primaryFocus?.debugLabel,
          'AppCombobox search',
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(
          FocusManager.instance.primaryFocus?.debugLabel,
          'AppCombobox search',
        );

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle(const Duration(milliseconds: 20));

        expect(selected, 'banana');
      },
    );

    testWidgets(
      'selecting in .single mode closes the popover; .multiple keeps it open',
      (tester) async {
        await tester.pumpComponent(
          AppCombobox<String>.single(
            items: _items,
            placeholder: 'Pick a fruit',
            onChanged: (_) {},
          ),
        );
        await tester.tap(find.text('Pick a fruit'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));
        await tester.tap(_optionRow('Banana'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));
        expect(_optionRow('Apple'), findsNothing);

        List<String> values = const [];
        await tester.pumpComponent(
          StatefulBuilder(
            builder: (context, setState) {
              return AppCombobox<String>.multiple(
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
        await tester.tap(_optionRow('Banana'));
        await tester.pump();
        expect(_optionRow('Apple'), findsOneWidget);
      },
    );
  });
}
