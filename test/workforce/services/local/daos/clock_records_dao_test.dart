import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_workforce/data/sources/local/daos/clock_records_dao.dart';
import 'package:feature_workforce/data/sources/local/daos/employees_dao.dart';
import 'package:feature_workforce/domain/mappers/clock_record_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AgoraDatabase db;
  late ClockRecordsDao clockRecordsDao;
  late EmployeesDao employeesDao;
  late int employeeId;

  setUp(() async {
    db = AgoraDatabase(NativeDatabase.memory());
    clockRecordsDao = ClockRecordsDao(db);
    employeesDao = EmployeesDao(db);

    employeeId = await employeesDao.insertEmployee(
      const EmployeesTableCompanion(
        name: Value('Alice'),
        pinHash: Value('1234'),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('ClockRecordsDao.tryClockIn', () {
    test('inserts a clock-in when the employee has no open shift', () async {
      final id = await clockRecordsDao.tryClockIn(
        employeeId,
        clockInCompanion(employeeId),
      );

      expect(id, isNotNull);
      final active = await clockRecordsDao.getActiveClockRecord(employeeId);
      expect(active, isNotNull);
      expect(active!.id, id);
    });

    test(
        'returns null and inserts nothing when the employee is already '
        'clocked in', () async {
      final firstId = await clockRecordsDao.tryClockIn(
        employeeId,
        clockInCompanion(employeeId),
      );
      expect(firstId, isNotNull);

      final secondId = await clockRecordsDao.tryClockIn(
        employeeId,
        clockInCompanion(employeeId),
      );

      expect(secondId, isNull);

      final all = await clockRecordsDao
          .watchClockRecords(
            employeeId: employeeId,
          )
          .first;
      expect(all, hasLength(1));
    });

    // Regression test for the check-then-insert race: two clockIn calls
    // fired without awaiting one before starting the other used to be able
    // to both observe "no open shift" and both insert, producing two
    // overlapping open shifts for the same employee. Wrapping the check and
    // the insert in a single Drift transaction (see tryClockIn) serializes
    // them, so exactly one of the two concurrent calls must win.
    test(
      'only one of two concurrent clock-ins for the same employee succeeds',
      () async {
        final results = await Future.wait([
          clockRecordsDao.tryClockIn(employeeId, clockInCompanion(employeeId)),
          clockRecordsDao.tryClockIn(employeeId, clockInCompanion(employeeId)),
        ]);

        final succeeded = results.where((id) => id != null).toList();
        final rejected = results.where((id) => id == null).toList();

        expect(
          succeeded,
          hasLength(1),
          reason: 'exactly one concurrent clock-in should have won',
        );
        expect(rejected, hasLength(1));

        final openShifts = await clockRecordsDao
            .watchClockRecords(
              employeeId: employeeId,
            )
            .first;
        expect(
          openShifts.where((r) => r.record.clockedOutAt == null),
          hasLength(1),
          reason: 'the employee must end up with a single open shift',
        );
      },
    );

    test(
      'the partial unique index rejects a second open shift inserted '
      'outside tryClockIn',
      () async {
        await clockRecordsDao.tryClockIn(
            employeeId, clockInCompanion(employeeId));

        // Bypass the DAO's transactional guard entirely and insert a second
        // open shift directly, simulating any future code path that forgets
        // to go through tryClockIn. The database-level partial unique index
        // (idx_clock_records_one_open_shift) must still reject it.
        await expectLater(
          clockRecordsDao.insertClockRecord(clockInCompanion(employeeId)),
          throwsException,
        );
      },
    );
  });
}
