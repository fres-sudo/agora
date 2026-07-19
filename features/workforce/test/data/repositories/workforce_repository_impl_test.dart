import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_workforce/data/repositories/workforce_repository_impl.dart';
import 'package:feature_workforce/data/sources/local/daos/cash_reconciliations_dao.dart';
import 'package:feature_workforce/data/sources/local/daos/clock_records_dao.dart';
import 'package:feature_workforce/data/sources/local/daos/employees_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:result/result.dart';

/// Only [getCashRevenueForEmployeeShift] is exercised by
/// `WorkforceRepositoryImpl` — every other member is unused by these tests
/// and throws if accidentally called.
class _FakeOrdersRepository implements OrdersRepository {
  int cashRevenueCents = 0;
  ({int employeeId, DateTime startDate, DateTime? endDate})? lastCall;

  @override
  Future<Result<int>> getCashRevenueForEmployeeShift({
    required int employeeId,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    lastCall = (employeeId: employeeId, startDate: startDate, endDate: endDate);
    return Result.ok(cashRevenueCents);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

void main() {
  late AgoraDatabase db;
  late EmployeesDao employeesDao;
  late ClockRecordsDao clockRecordsDao;
  late CashReconciliationsDao cashReconciliationsDao;
  late _FakeOrdersRepository ordersRepository;
  late WorkforceRepositoryImpl repository;

  setUp(() async {
    db = AgoraDatabase(NativeDatabase.memory());
    employeesDao = EmployeesDao(db);
    clockRecordsDao = ClockRecordsDao(db);
    cashReconciliationsDao = CashReconciliationsDao(db);
    ordersRepository = _FakeOrdersRepository();
    repository = WorkforceRepositoryImpl(
      employeesDao: employeesDao,
      clockRecordsDao: clockRecordsDao,
      cashReconciliationsDao: cashReconciliationsDao,
      ordersRepository: ordersRepository,
    );
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> seedEmployee() => db
      .into(db.employeesTable)
      .insert(EmployeesTableCompanion.insert(name: 'Ada', pinHash: 'hash'));

  Future<int> seedClockRecord(
    int employeeId, {
    required DateTime clockedInAt,
    DateTime? clockedOutAt,
  }) => db
      .into(db.clockRecordsTable)
      .insert(
        ClockRecordsTableCompanion.insert(
          employeeId: employeeId,
          clockedInAt: clockedInAt,
        ).copyWith(
          clockedOutAt: clockedOutAt == null
              ? const Value.absent()
              : Value(clockedOutAt),
        ),
      );

  group(
    'expectedCashCentsForShift '
    '(docs/features/04-volunteer-shift-accountability.md)',
    () {
      test('returns 0 (not an error) when there were no cash orders',
          () async {
        final employeeId = await seedEmployee();
        final clockRecordId = await seedClockRecord(
          employeeId,
          clockedInAt: DateTime(2026, 1, 1, 9),
          clockedOutAt: DateTime(2026, 1, 1, 17),
        );
        ordersRepository.cashRevenueCents = 0;

        final result = await repository.expectedCashCentsForShift(
          clockRecordId,
        );

        expect(result.isSuccess, isTrue);
        expect(result.unwrap(), 0);
      });

      test('delegates to OrdersRepository with the shift\'s employee and '
          'clock-in/out window', () async {
        final employeeId = await seedEmployee();
        final clockedInAt = DateTime(2026, 1, 1, 9);
        final clockedOutAt = DateTime(2026, 1, 1, 17);
        final clockRecordId = await seedClockRecord(
          employeeId,
          clockedInAt: clockedInAt,
          clockedOutAt: clockedOutAt,
        );
        ordersRepository.cashRevenueCents = 4250;

        final result = await repository.expectedCashCentsForShift(
          clockRecordId,
        );

        expect(result.unwrap(), 4250);
        expect(ordersRepository.lastCall?.employeeId, employeeId);
        expect(ordersRepository.lastCall?.startDate, clockedInAt);
        expect(ordersRepository.lastCall?.endDate, clockedOutAt);
      });

      test(
        'passes a null endDate for a still-open shift, so the DAO treats it '
        'as "up to now"',
        () async {
          final employeeId = await seedEmployee();
          final clockRecordId = await seedClockRecord(
            employeeId,
            clockedInAt: DateTime(2026, 1, 1, 9),
          );

          await repository.expectedCashCentsForShift(clockRecordId);

          expect(ordersRepository.lastCall?.endDate, isNull);
        },
      );

      test('errors when the clock record does not exist', () async {
        final result = await repository.expectedCashCentsForShift(999);
        expect(result.isError, isTrue);
      });
    },
  );

  group('recordCashReconciliation', () {
    test('computes and stores varianceCents for a shortfall', () async {
      final employeeId = await seedEmployee();
      final clockRecordId = await seedClockRecord(
        employeeId,
        clockedInAt: DateTime(2026, 1, 1, 9),
        clockedOutAt: DateTime(2026, 1, 1, 17),
      );

      final result = await repository.recordCashReconciliation(
        clockRecordId: clockRecordId,
        expectedCents: 1000,
        countedCents: 950,
      );

      expect(result.isSuccess, isTrue);
      expect(result.unwrap().varianceCents, -50);
      expect(result.unwrap().isBalanced, isFalse);

      final stored = await cashReconciliationsDao.getByClockRecordId(
        clockRecordId,
      );
      expect(stored?.varianceCents, -50);
    });

    test('computes zero variance when counted matches expected', () async {
      final employeeId = await seedEmployee();
      final clockRecordId = await seedClockRecord(
        employeeId,
        clockedInAt: DateTime(2026, 1, 1, 9),
        clockedOutAt: DateTime(2026, 1, 1, 17),
      );

      final result = await repository.recordCashReconciliation(
        clockRecordId: clockRecordId,
        expectedCents: 1000,
        countedCents: 1000,
      );

      expect(result.unwrap().isBalanced, isTrue);
    });

    test('overage produces a positive varianceCents', () async {
      final employeeId = await seedEmployee();
      final clockRecordId = await seedClockRecord(
        employeeId,
        clockedInAt: DateTime(2026, 1, 1, 9),
        clockedOutAt: DateTime(2026, 1, 1, 17),
      );

      final result = await repository.recordCashReconciliation(
        clockRecordId: clockRecordId,
        expectedCents: 1000,
        countedCents: 1100,
      );

      expect(result.unwrap().varianceCents, 100);
      expect(result.unwrap().hasShortfall, isFalse);
    });
  });

  group('getTotalCashVarianceForRange', () {
    test('sums varianceCents across reconciliations in the period', () async {
      final employeeId = await seedEmployee();
      final shiftA = await seedClockRecord(
        employeeId,
        clockedInAt: DateTime(2026, 1, 1, 9),
        clockedOutAt: DateTime(2026, 1, 1, 17),
      );
      final shiftB = await seedClockRecord(
        employeeId,
        clockedInAt: DateTime(2026, 1, 2, 9),
        clockedOutAt: DateTime(2026, 1, 2, 17),
      );

      await repository.recordCashReconciliation(
        clockRecordId: shiftA,
        expectedCents: 1000,
        countedCents: 950,
      );
      await repository.recordCashReconciliation(
        clockRecordId: shiftB,
        expectedCents: 1000,
        countedCents: 1020,
      );

      // CashReconciliationsTable.createdAt is stamped at insert time (the
      // real "now"), not derived from the shift's own dates — so the query
      // range must bracket the actual moment these rows were written.
      final now = DateTime.now();
      final result = await repository.getTotalCashVarianceForRange(
        startDate: now.subtract(const Duration(minutes: 1)),
        endDate: now.add(const Duration(minutes: 1)),
      );

      expect(result.unwrap(), -30); // -50 + 20
    });
  });
}
