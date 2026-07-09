import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AgoraDatabase db;
  late AppSettingsDao appSettingsDao;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
    appSettingsDao = AppSettingsDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AppSettingsDao', () {
    group('setDouble/getDouble', () {
      for (final value in <double>[0.0, 22.0, 3.14, -1.5, 100.99, 0.0001]) {
        test('round-trips $value exactly', () async {
          await appSettingsDao.setDouble('tax_rate', value);

          final result = await appSettingsDao.getDouble('tax_rate');

          expect(result, value);
        });
      }

      test('tags the stored value with the double type', () async {
        await appSettingsDao.setDouble('tax_rate', 22.5);

        final entity = await appSettingsDao.getSettingByKey('tax_rate');

        expect(entity, isNotNull);
        expect(entity!.type, AppSettingsDao.typeDouble);
      });

      test('overwrites a previously stored value on repeated sets', () async {
        await appSettingsDao.setDouble('tax_rate', 10.0);
        await appSettingsDao.setDouble('tax_rate', 20.5);

        final result = await appSettingsDao.getDouble('tax_rate');

        expect(result, 20.5);
      });

      test('returns null for a key that was never set', () async {
        final result = await appSettingsDao.getDouble('missing_key');

        expect(result, isNull);
      });
    });

    group('setInt/getInt', () {
      test('round-trips an int value and tags it correctly', () async {
        await appSettingsDao.setInt('printer_timeout', 42);

        final result = await appSettingsDao.getInt('printer_timeout');
        final entity = await appSettingsDao.getSettingByKey(
          'printer_timeout',
        );

        expect(result, 42);
        expect(entity!.type, AppSettingsDao.typeInt);
      });
    });

    group('setBool/getBool', () {
      test('round-trips a bool value and tags it correctly', () async {
        await appSettingsDao.setBool('receipt_show_logo', true);

        final result = await appSettingsDao.getBool('receipt_show_logo');
        final entity = await appSettingsDao.getSettingByKey(
          'receipt_show_logo',
        );

        expect(result, isTrue);
        expect(entity!.type, AppSettingsDao.typeBool);
      });
    });

    group('setString/getString', () {
      test('round-trips a string value and tags it correctly', () async {
        await appSettingsDao.setString('business_name', 'Agora Cafe');

        final result = await appSettingsDao.getString('business_name');
        final entity = await appSettingsDao.getSettingByKey('business_name');

        expect(result, 'Agora Cafe');
        expect(entity!.type, AppSettingsDao.typeString);
      });
    });
  });
}
