import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

const _items = [
  AppComboboxItem(value: 'apple', label: 'Apple'),
  AppComboboxItem(value: 'banana', label: 'Banana'),
];

Widget _harness({
  required String? value,
  required ValueChanged<String?> onChanged,
  required Future<String> Function(String query) onCreate,
  void Function(Object, StackTrace)? onCreateError,
}) {
  return AppCreatableCombobox<String>(
    items: _items,
    value: value,
    onChanged: onChanged,
    onCreate: onCreate,
    optimisticValueBuilder: (query) => 'pending:$query',
    onCreateError: onCreateError,
  );
}

Future<void> _openAndType(WidgetTester tester, String query) async {
  await tester.tap(find.byType(AppCreatableCombobox<String>));
  await tester.pumpAndSettle(const Duration(milliseconds: 20));
  await tester.enterText(find.byType(TextField), query);
  await tester.pump();
}

void main() {
  group('AppCreatableCombobox', () {
    testWidgets('shows a "Create" row for a query with no match', (
      tester,
    ) async {
      await tester.pumpComponent(
        _harness(
          value: null,
          onChanged: (_) {},
          onCreate: (query) async => query,
        ),
      );
      await _openAndType(tester, 'Mango');
      expect(find.text('Create "Mango"'), findsOneWidget);
    });

    testWidgets('does not show a "Create" row for an exact-match query', (
      tester,
    ) async {
      await tester.pumpComponent(
        _harness(
          value: null,
          onChanged: (_) {},
          onCreate: (query) async => query,
        ),
      );
      await _openAndType(tester, 'Apple');
      expect(find.text('Create "Apple"'), findsNothing);
    });

    testWidgets(
      'activating create closes the popover and applies the optimistic value before onCreate resolves',
      (tester) async {
        final completer = Completer<String>();
        String? value;
        await tester.pumpComponent(
          StatefulBuilder(
            builder: (context, setState) {
              return _harness(
                value: value,
                onChanged: (v) => setState(() => value = v),
                onCreate: (query) => completer.future,
              );
            },
          ),
        );

        await _openAndType(tester, 'Mango');
        await tester.tap(find.text('Create "Mango"'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));

        // Optimistic value applied and popover closed, before the create
        // future has resolved.
        expect(value, 'pending:Mango');
        expect(find.text('Create "Mango"'), findsNothing);

        completer.complete('mango-real-id');
        await tester.pumpAndSettle();
      },
    );

    testWidgets('on success, swaps in the real value via a second onChanged', (
      tester,
    ) async {
      final completer = Completer<String>();
      final values = <String?>[];
      await tester.pumpComponent(
        StatefulBuilder(
          builder: (context, setState) {
            final current = values.isEmpty ? null : values.last;
            return _harness(
              value: current,
              onChanged: (v) => setState(() => values.add(v)),
              onCreate: (query) => completer.future,
            );
          },
        ),
      );

      await _openAndType(tester, 'Mango');
      await tester.tap(find.text('Create "Mango"'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      completer.complete('mango-real-id');
      await tester.pumpAndSettle();

      expect(values, ['pending:Mango', 'mango-real-id']);
    });

    testWidgets(
      'on failure, rolls back to the previous value, calls onCreateError, and shows a SnackBar',
      (tester) async {
        final completer = Completer<String>();
        Object? capturedError;
        final values = <String?>[];
        await tester.pumpComponent(
          StatefulBuilder(
            builder: (context, setState) {
              final current = values.isEmpty ? 'banana' : values.last;
              return _harness(
                value: current,
                onChanged: (v) => setState(() => values.add(v)),
                onCreate: (query) => completer.future,
                onCreateError: (error, stackTrace) => capturedError = error,
              );
            },
          ),
        );

        await _openAndType(tester, 'Mango');
        await tester.tap(find.text('Create "Mango"'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));

        completer.completeError(Exception('network down'));
        await tester.pumpAndSettle();

        expect(values.last, 'banana');
        expect(capturedError, isA<Exception>());
        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('Could not create item. Please try again.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('a second create cannot be triggered while one is pending', (
      tester,
    ) async {
      final completer = Completer<String>();
      var createCalls = 0;
      await tester.pumpComponent(
        _harness(
          value: null,
          onChanged: (_) {},
          onCreate: (query) {
            createCalls++;
            return completer.future;
          },
        ),
      );

      await _openAndType(tester, 'Mango');
      await tester.tap(find.text('Create "Mango"'));
      await tester.pumpAndSettle(const Duration(milliseconds: 20));

      expect(createCalls, 1);

      // Reopen while the create is still pending: no "Create" row available
      // for the same or a different query, so it cannot be tapped again.
      await _openAndType(tester, 'Mango');
      expect(find.text('Create "Mango"'), findsNothing);
      expect(createCalls, 1);

      completer.complete('mango-real-id');
      await tester.pumpAndSettle();
    });

    testWidgets(
      'a stale resolving create does not clobber a value selected in the meantime',
      (tester) async {
        final completer = Completer<String>();
        String? value;
        await tester.pumpComponent(
          StatefulBuilder(
            builder: (context, setState) {
              return _harness(
                value: value,
                onChanged: (v) => setState(() => value = v),
                onCreate: (query) => completer.future,
              );
            },
          ),
        );

        await _openAndType(tester, 'Mango');
        await tester.tap(find.text('Create "Mango"'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));
        expect(value, 'pending:Mango');

        // User picks a different, pre-existing item while the create is
        // still in flight.
        await tester.tap(find.byType(AppCreatableCombobox<String>));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));
        await tester.tap(find.text('Banana'));
        await tester.pumpAndSettle(const Duration(milliseconds: 20));
        expect(value, 'banana');

        // The stale create now resolves — it must not overwrite the newer
        // manual selection.
        completer.complete('mango-real-id');
        await tester.pumpAndSettle();

        expect(value, 'banana');
      },
    );
  });
}
