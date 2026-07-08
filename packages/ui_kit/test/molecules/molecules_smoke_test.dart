import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import '../helpers/pump_component.dart';

void main() {
  group('AppCard', () {
    testWidgets('renders header, child and handles tap', (tester) async {
      var taps = 0;
      await tester.pumpComponent(
        AppCard(
          title: 'Revenue',
          subtitle: 'Today',
          trailing: const AppBadge('+12%', variant: AppBadgeVariant.success),
          onTap: () => taps++,
          child: const AppText.displayMd('€1,234'),
        ),
      );
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('€1,234'), findsOneWidget);
      await tester.tap(find.text('Revenue'));
      expect(taps, 1);
    });
  });

  group('AppAlert', () {
    testWidgets('renders each variant in both themes', (tester) async {
      for (final brightness in Brightness.values) {
        for (final variant in AppAlertVariant.values) {
          await tester.pumpComponent(
            AppAlert(title: 'Heads up', message: 'Something', variant: variant),
            brightness: brightness,
          );
          expect(find.text('Something'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      }
    });
  });

  group('AppListTile / AppEmptyState', () {
    testWidgets('list tile taps and empty state renders action', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpComponent(
        AppListTile(
          title: 'Row',
          subtitle: 'sub',
          leading: const Icon(AgoraIcons.categories),
          onTap: () => taps++,
        ),
      );
      await tester.tap(find.text('Row'));
      expect(taps, 1);

      await tester.pumpComponent(
        AppEmptyState(
          title: 'Nothing here',
          message: 'Add your first item',
          icon: AgoraIcons.inbox,
          action: AppButton.primary(label: 'Add', onPressed: () {}),
        ),
      );
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });
  });

  group('AppSearchField / AppSegmentedControl', () {
    testWidgets('search forwards changes; segmented switches selection', (
      tester,
    ) async {
      var query = '';
      await tester.pumpComponent(AppSearchField(onChanged: (v) => query = v));
      await tester.enterText(find.byType(TextField), 'pizza');
      expect(query, 'pizza');

      var selected = 'list';
      await tester.pumpComponent(
        StatefulBuilder(
          builder: (context, setState) => AppSegmentedControl<String>(
            selected: selected,
            segments: const [
              AppSegment(value: 'list', label: 'List'),
              AppSegment(value: 'grid', label: 'Grid'),
            ],
            onChanged: (v) => setState(() => selected = v),
          ),
        ),
      );
      await tester.tap(find.text('Grid'));
      await tester.pump();
      expect(selected, 'grid');
    });
  });
}
