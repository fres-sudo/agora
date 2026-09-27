import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_auth/data/repositories/auth_repository_impl.dart';
import 'package:feature_auth/data/sources/local/daos/auth_dao.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result/result.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AgoraDatabase database;
  late FlutterSecureStorage secureStorage;
  late AuthRepositoryImpl repository;
  late DateTime now;

  AuthRepositoryImpl createRepository() => AuthRepositoryImpl(
    authDao: AuthDao(database),
    secureStorage: secureStorage,
    now: () => now,
  );

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    database = AgoraDatabase(NativeDatabase.memory());
    secureStorage = const FlutterSecureStorage();
    now = DateTime(2026, 9, 20, 12);
    repository = createRepository();
  });

  tearDown(() => database.close());

  Future<int> seedEmployee({String pin = '1234', String? storedPin}) => database
      .into(database.employeesTable)
      .insert(
        EmployeesTableCompanion.insert(
          name: 'Ada',
          pinHash: storedPin ?? PinHasher.hash(pin),
        ),
      );

  String errorMessage(Result<Object?> result) => switch (result) {
    Error<Object?>(:final error) => error.toString(),
    Ok<Object?>() => fail('Expected authentication to fail'),
  };

  test('lockout survives restart, expires, and clears on success', () async {
    final employeeId = await seedEmployee();

    for (var attempt = 0; attempt < 5; attempt++) {
      await repository.loginWithPin(employeeId, '9999');
    }

    final result = await repository.loginWithPin(employeeId, '1234');

    expect(result.isError, isTrue);
    expect(errorMessage(result), contains('Too many incorrect attempts'));

    repository = createRepository();
    final afterRestart = await repository.loginWithPin(employeeId, '1234');
    expect(afterRestart.isError, isTrue);
    expect(errorMessage(afterRestart), contains('30 seconds'));

    now = now.add(const Duration(seconds: 31));
    final afterExpiry = await repository.loginWithPin(employeeId, '1234');
    expect(afterExpiry.isSuccess, isTrue);
    expect(
      await secureStorage.read(key: 'agora_pin_attempts_$employeeId'),
      isNull,
    );
  });

  test(
    'serializes concurrent attempts so they cannot bypass lockout',
    () async {
      final employeeId = await seedEmployee();

      await Future.wait(
        List.generate(5, (_) => repository.loginWithPin(employeeId, '9999')),
      );

      final result = await repository.loginWithPin(employeeId, '1234');
      expect(result.isError, isTrue);
      expect(errorMessage(result), contains('Too many incorrect attempts'));
    },
  );

  test('rejects PINs outside the documented numeric format', () async {
    final employeeId = await seedEmployee();

    for (final pin in ['123', '1234567', '12ab']) {
      final result = await repository.loginWithPin(employeeId, pin);
      expect(result.isError, isTrue, reason: 'PIN "$pin" must be rejected');
      expect(errorMessage(result), 'Invalid PIN');
    }
  });

  test('upgrades a legacy plaintext PIN after successful login', () async {
    final employeeId = await seedEmployee(storedPin: '1234');

    final result = await repository.loginWithPin(employeeId, '1234');
    final employee = await (database.select(
      database.employeesTable,
    )..where((row) => row.id.equals(employeeId))).getSingle();

    expect(result.isSuccess, isTrue);
    expect(PinHasher.looksHashed(employee.pinHash), isTrue);
    expect(PinHasher.verify('1234', employee.pinHash), isTrue);
  });
}
