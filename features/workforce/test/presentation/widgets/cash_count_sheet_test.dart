import 'package:app_settings/app_settings.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/presentation/widgets/cash_count_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

/// Pumps [CashCountSheet] via [CashCountSheet.show] (mirroring production
/// usage from `ProtectedShellPage`), taps "open" to display it, runs [act]
/// against the tester, then returns whatever the sheet was popped with (or
/// `null` if skipped/dismissed).
Future<CashCountResult?> _pumpSheetAndAct(
  WidgetTester tester, {
  required Future<void> Function(WidgetTester tester) act,
}) async {
  CashCountResult? result;
  await tester.pumpWidget(
    BlocProvider<SettingsCubit>(
      create: (_) =>
          SettingsCubit(settingsRepository: _NoopSettingsRepository()),
      child: MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await CashCountSheet.show(
                    context,
                    expectedCents: 1000,
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

class _NoopSettingsRepository implements SettingsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  testWidgets('shows the expected cash amount', (tester) async {
    await _pumpSheetAndAct(tester, act: (_) async {});
    expect(find.textContaining('€10,00'), findsOneWidget);
  });

  testWidgets('"Skip" resolves to null', (tester) async {
    final result = await _pumpSheetAndAct(
      tester,
      act: (tester) async {
        await tester.tap(find.text('Skip'));
      },
    );
    expect(result, isNull);
  });

  testWidgets('barrier dismiss resolves to null', (tester) async {
    final result = await _pumpSheetAndAct(
      tester,
      act: (tester) async {
        await tester.tapAt(const Offset(10, 10));
      },
    );
    expect(result, isNull);
  });

  testWidgets('"Confirm Count" resolves the entered amount', (tester) async {
    final result = await _pumpSheetAndAct(
      tester,
      act: (tester) async {
        // Enter 950 via the money keypad: digits 9, 5, 0. Each tap must
        // settle (setState rebuilds MoneyKeypad with the new valueCents)
        // before the next one, or every tap computes off the same stale
        // base value instead of chaining onto the previous digit.
        await tester.tap(find.text('9'));
        await tester.pump();
        await tester.tap(find.text('5'));
        await tester.pump();
        await tester.tap(find.text('0'));
        await tester.pump();
        await tester.tap(find.text('Confirm Count'));
      },
    );
    expect(result, isNotNull);
    expect(result!.countedCents, 950);
  });
}
