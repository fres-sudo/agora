import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/domain/repositories/settings_repository.dart';
import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/printer_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';

/// Minimal in-memory [SettingsRepository] fake — only what [SettingsCubit]
/// needs to reach a `loaded` state and back reads/writes.
class _FakeSettingsRepository implements SettingsRepository {
  final Map<String, String> _alues = {};

  @override
  Stream<List<AppSetting>> watchAllSettings() => const Stream.empty();

  @override
  Stream<String?> watchSettingValue(String key) => const Stream.empty();

  @override
  Stream<List<AppSetting>> watchSettingsByPrefix(String prefix) => const Stream.empty();

  @override
  Future<Result<String?>> getString(String key) async => Result.ok(_values[key]);

  @override
  Future<Result<int?>> getInt(String key) async => Result.ok(int.tryParse(_values[key] ?? ''));

  @override
  Future<Result<bool?>> getBool(String key) async => Result.ok(_values[key] == 'true');

  @override
  Future<Result<double?>> getDouble(String key) async =>
      Result.ok(double.tryParse(_values[key] ?? ''));

  @override
  Future<Result<List<AppSetting>>> getPrinterSettings() async => const Result.ok([]);

  @override
  Future<Result<List<AppSetting>>> getReceiptSettings() async => const Result.ok([]);

  @override
  Future<Result<AppSetting>> setString(String key, String value) async {
    _values[key] = value;
    return Result.ok((key: key, value: value, type: 'string'));
  }

  @override
  Future<Result<AppSetting>> setInt(String key, int value) async {
    _values[key] = value.toString();
    return Result.ok((key: key, value: value.toString(), type: 'int'));
  }

  @override
  Future<Result<AppSetting>> setBool(String key, bool value) async {
    _values[key] = value.toString();
    return Result.ok((key: key, value: value.toString(), type: 'bool'));
  }

  @override
  Future<Result<AppSetting>> setDouble(String key, double value) async {
    _values[key] = value.toString();
    return Result.ok((key: key, value: value.toString(), type: 'double'));
  }

  @override
  Future<Result<String>> deleteSetting(String key) async {
    _values.remove(key);
    return Result.ok(key);
  }

  @override
  Future<Result<int>> deleteSettingsByPrefix(String prefix) async =>
      Result.ok(_values.keys.where((k) => k.startsWith(prefix)).length);
}

void main() {
  late _FakeSettingsRepository repository;
  late SettingsCubit settingsCubit;
  late FakePrinterService printerService;

  setUp(() {
    repository = _FakeSettingsRepository();
    settingsCubit = SettingsCubit(settingsRepository: repository);
    printerService = FakePrinterService();
  });

  tearDown(() {
    settingsCubit.close();
    printerService.dispose();
  });

  Future<void> pumpPrinterSection(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          BlocProvider<SettingsCubit>.value(value: settingsCubit),
          Provider<PrinterService>.value(value: printerService),
        ],
        child: const MaterialApp(home: Scaffold(body: PrinterSection())),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('PrinterSection — Print Test Receipt', () {
    testWidgets('tapping the button sends a test receipt through the '
        'PrinterService', (tester) async {
      await pumpPrinterSection(tester);

      expect(printerService.printedJobs, isEmpty);

      await tester.tap(find.text('Print Test Receipt'));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(printerService.printedJobs, hasLength(1));
      expect(printerService.printedJobs.single, isNotEmpty);
      expect(find.text('Test receipt sent to printer'), findsOneWidget);
    });

    testWidgets('surfaces an error snackbar when the printer fails', (tester) async {
      printerService.failPrint = true;
      await pumpPrinterSection(tester);

      await tester.tap(find.text('Print Test Receipt'));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(printerService.printedJobs, isEmpty);
      expect(find.text('Test print failed — check the printer connection'), findsOneWidget);
    });
  });
}
