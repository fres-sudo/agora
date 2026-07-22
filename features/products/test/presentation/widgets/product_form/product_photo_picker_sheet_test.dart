import 'package:feature_products/feature_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n/i18n.dart';
import 'package:ui_kit/ui_kit.dart';

/// Pumps [ProductPhotoPickerSheet] pushed as a route, taps [openTrigger] to
/// open it, runs [act] against the tester, then returns whatever value the
/// sheet was popped with (or `null` if never popped).
Future<String?> _pumpSheetAndAct(
  WidgetTester tester, {
  String? initialValue,
  required Future<void> Function(WidgetTester tester) act,
}) async {
  String? result;
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Mirrors production usage (product_info_step.dart), which
                  // opens this widget via AdaptiveModal.show, not a bare
                  // Navigator.push — that's what gives it a Material
                  // ancestor (for the stock-tile InkWells) and a bounded
                  // height (avoiding a RenderFlex overflow).
                  result = await AdaptiveModal.show<String?>(
                    context: context,
                    style: AdaptiveModalStyle.sideSheet,
                    builder: (ctx, _) =>
                        ProductPhotoPickerSheet(initialValue: initialValue),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();

  await act(tester);
  await tester.pumpAndSettle();

  return result;
}

void main() {
  testWidgets('tapping an icon pops its type and code point', (tester) async {
    final result = await _pumpSheetAndAct(
      tester,
      act: (tester) async {
        await tester.tap(find.bySemanticsLabel('Burger Outline'));
      },
    );

    expect(result, 'icon:outline:f2d0');
  });

  testWidgets('remove photo pops an empty string', (tester) async {
    final result = await _pumpSheetAndAct(
      tester,
      initialValue: 'icon:outline:f2d0',
      act: (tester) async {
        await tester.tap(find.text('Remove Photo'));
      },
    );

    expect(result, '');
  });

  testWidgets('remove photo button only shows when a value is set', (
    tester,
  ) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: const Scaffold(body: ProductPhotoPickerSheet()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Remove Photo'), findsNothing);
  });
}
