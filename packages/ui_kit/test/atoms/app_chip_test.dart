import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  group('AppChip', () {
    testWidgets('renders unchanged without onDeleted (backwards-compat)', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        await tester.pumpComponent(
          const AppChip(label: 'Filter'),
          brightness: brightness,
        );
        expect(find.text('Filter'), findsOneWidget);
        expect(find.byIcon(AgoraIcons.x_mark), findsNothing);
      }
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var taps = 0;
      await tester.pumpComponent(AppChip(label: 'Tag', onTap: () => taps++));
      await tester.tap(find.text('Tag'));
      expect(taps, 1);
    });

    testWidgets('with onDeleted shows a delete affordance', (tester) async {
      await tester.pumpComponent(AppChip(label: 'Removable', onDeleted: () {}));
      expect(find.byIcon(AgoraIcons.x_mark), findsOneWidget);
    });

    testWidgets('tapping delete fires onDeleted without firing onTap', (
      tester,
    ) async {
      var taps = 0;
      var deletes = 0;
      await tester.pumpComponent(
        AppChip(
          label: 'Removable',
          onTap: () => taps++,
          onDeleted: () => deletes++,
        ),
      );

      await tester.tap(find.byIcon(AgoraIcons.x_mark));
      expect(deletes, 1);
      expect(taps, 0);
    });

    testWidgets('delete affordance has a distinct "Remove" semantics label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpComponent(AppChip(label: 'Removable', onDeleted: () {}));
      expect(find.bySemanticsLabel('Remove Removable'), findsOneWidget);
      handle.dispose();
    });
  });
}
