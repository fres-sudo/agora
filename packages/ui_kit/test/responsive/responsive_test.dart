import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('BreakPoint', () {
    const bp = BreakPoint.agora();

    test('classifies by width, with inclusive lower bounds', () {
      expect(bp.screenType(320), ScreenSize.mobile);
      expect(bp.screenType(599), ScreenSize.mobile);
      expect(bp.screenType(600), ScreenSize.tablet);
      expect(bp.screenType(1023), ScreenSize.tablet);
      expect(bp.screenType(1024), ScreenSize.desktop);
    });

    test('a phone in landscape is still classified by its width', () {
      // 844x390: the old shortest-side rule called this mobile. Width-keyed
      // classification calls it a tablet, and isCompactHeight is what layouts
      // use to notice the missing vertical room.
      expect(bp.screenType(844), ScreenSize.tablet);
    });
  });

  group('context.screenSize', () {
    testWidgets('derives from the viewport width when no scope is mounted', (
      tester,
    ) async {
      late ScreenSize seen;
      tester.view.physicalSize = const Size(500, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              seen = context.screenSize();
              return const SizedBox();
            },
          ),
        ),
      );

      expect(seen, ScreenSize.mobile);
    });

    testWidgets('a mounted ResponsiveScope wins over the viewport', (
      tester,
    ) async {
      late ScreenSize seen;

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveScope.fixed(
            ScreenSize.mobile,
            child: Builder(
              builder: (context) {
                seen = context.screenSize();
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // The 800x600 test viewport would otherwise resolve to tablet.
      expect(seen, ScreenSize.mobile);
    });
  });

  group('AdaptiveLayout', () {
    Widget harness(ScreenSize size) => MaterialApp(
      home: ResponsiveScope.fixed(
        size,
        child: AdaptiveLayout(
          mobile: (_) => const Text('phone'),
          tablet: (_) => const Text('tablet'),
          desktop: (_) => const Text('desktop'),
        ),
      ),
    );

    testWidgets('builds the branch matching the breakpoint', (tester) async {
      await tester.pumpWidget(harness(ScreenSize.mobile));
      expect(find.text('phone'), findsOneWidget);
      expect(find.text('desktop'), findsNothing);

      await tester.pumpWidget(harness(ScreenSize.desktop));
      expect(find.text('desktop'), findsOneWidget);
      expect(find.text('phone'), findsNothing);
    });

    testWidgets('tablet falls back to the desktop branch when omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveScope.fixed(
            ScreenSize.tablet,
            child: AdaptiveLayout(
              mobile: (_) => const Text('phone'),
              desktop: (_) => const Text('desktop'),
            ),
          ),
        ),
      );

      expect(find.text('desktop'), findsOneWidget);
    });
  });

  group('DataTableView responsive rendering', () {
    final columns = [
      DataTableColumn<String>(
        id: 'name',
        label: 'Name',
        priority: DataTableColumnPriority.primary,
        cellBuilder: (item) => Text(item),
      ),
      DataTableColumn<String>(
        id: 'internal',
        label: 'Internal',
        cellBuilder: (item) => Text('internal-$item'),
      ),
    ];

    Widget harness(ScreenSize size) => MaterialApp(
      home: ResponsiveScope.fixed(
        size,
        child: Scaffold(
          body: DataTableView<String>(
            items: const ['alpha'],
            columns: columns,
            config: const DataTableConfig(
              title: 'Things',
              searchHint: 'Search',
              addButtonLabel: 'Add',
              sortOptions: [],
            ),
          ),
        ),
      ),
    );

    testWidgets('renders column headers and every column on desktop', (
      tester,
    ) async {
      await tester.pumpWidget(harness(ScreenSize.desktop));
      await tester.pumpAndSettle();

      expect(find.text('NAME'), findsOneWidget);
      expect(find.text('alpha'), findsOneWidget);
      expect(find.text('internal-alpha'), findsOneWidget);
    });

    testWidgets('renders cards on mobile, dropping unprioritised columns', (
      tester,
    ) async {
      await tester.pumpWidget(harness(ScreenSize.mobile));
      await tester.pumpAndSettle();

      expect(find.byType(DataTableMobileList<String>), findsOneWidget);
      expect(find.text('alpha'), findsOneWidget);
      // No column headers, and the hidden-priority column is not rendered.
      expect(find.text('NAME'), findsNothing);
      expect(find.text('internal-alpha'), findsNothing);
    });
  });
}
