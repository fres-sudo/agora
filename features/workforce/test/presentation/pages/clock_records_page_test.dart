import 'dart:async';

import 'package:auth_session/auth_session.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/domain/models/cash_reconciliation.dart';
import 'package:feature_workforce/domain/models/clock_record.dart';
import 'package:feature_workforce/domain/models/employee.dart';
import 'package:feature_workforce/domain/repositories/workforce_repository.dart';
import 'package:feature_workforce/presentation/blocs/clock_records/clock_records_cubit.dart';
import 'package:feature_workforce/presentation/pages/clock_records_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result/result.dart';
import 'package:ui_kit/ui_kit.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._employee);
  final SessionEmployee? _employee;

  @override
  Future<SessionEmployee?> loadSession() async => _employee;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

/// Fake repository that counts how many times [watchClockRecords] is
/// invoked, so tests can assert the stream is only ever subscribed once.
class _FakeWorkforceRepository implements WorkforceRepository {
  _FakeWorkforceRepository(this._controller);

  final StreamController<List<ClockRecord>> _controller;
  int watchClockRecordsCallCount = 0;

  @override
  Stream<List<ClockRecord>> watchClockRecords({int? employeeId}) {
    watchClockRecordsCallCount++;
    return _controller.stream;
  }

  @override
  Stream<List<Employee>> watchActiveEmployees() => throw UnimplementedError();

  @override
  Future<Result<List<Employee>>> getActiveEmployees() =>
      throw UnimplementedError();

  @override
  Future<Result<Employee>> createEmployee(Employee employee) =>
      throw UnimplementedError();

  @override
  Future<Result<Employee>> updateEmployee(Employee employee) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> deleteEmployee(int id) => throw UnimplementedError();

  @override
  Future<Result<ClockRecord?>> getActiveClockRecord(int employeeId) =>
      throw UnimplementedError();

  @override
  Future<Result<ClockRecord>> clockIn(int employeeId) =>
      throw UnimplementedError();

  @override
  Future<Result<ClockRecord>> clockOut(int employeeId) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> expectedCashCentsForShift(int clockRecordId) =>
      throw UnimplementedError();

  @override
  Future<Result<CashReconciliation>> recordCashReconciliation({
    required int clockRecordId,
    required int expectedCents,
    required int countedCents,
    String? note,
  }) => throw UnimplementedError();

  @override
  Future<Result<int>> getTotalCashVarianceForRange({
    required DateTime startDate,
    required DateTime endDate,
  }) => throw UnimplementedError();
}

/// Wraps [child] and exposes a way to force a rebuild of [child]'s parent,
/// simulating an unrelated ancestor rebuild (e.g. from an app-shell timer or
/// a sibling's setState).
class _RebuildHost extends StatefulWidget {
  const _RebuildHost({required this.child});
  final Widget child;

  @override
  State<_RebuildHost> createState() => _RebuildHostState();
}

class _RebuildHostState extends State<_RebuildHost> {
  void forceRebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // Returning the same `widget.child` instance (no key change) means
    // Flutter reuses the existing Element/State below, exactly like a real
    // ancestor rebuild that doesn't touch this subtree's identity.
    return widget.child;
  }
}

void main() {
  late StreamController<List<ClockRecord>> controller;
  late _FakeWorkforceRepository repository;
  late ClockRecordsCubit cubit;

  setUp(() {
    controller = StreamController<List<ClockRecord>>.broadcast();
    repository = _FakeWorkforceRepository(controller);
    cubit = ClockRecordsCubit(workforceRepository: repository);
  });

  tearDown(() async {
    await cubit.close();
    await controller.close();
  });

  Future<void> pumpPage(WidgetTester tester, {SessionEmployee? viewer}) async {
    final sessionCubit = SessionCubit(_FakeAuthRepository(viewer));
    await sessionCubit.init();
    addTearDown(sessionCubit.close);

    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepositoryProvider<WorkforceRepository>.value(
          value: repository,
          child: BlocProvider<ClockRecordsCubit>.value(
            value: cubit,
            child: BlocProvider<SessionCubit>.value(
              value: sessionCubit,
              child: const _RebuildHost(child: ClockRecordsPage()),
            ),
          ),
        ),
      ),
    );
  }

  final record = ClockRecord(
    id: 1,
    employeeId: 1,
    employeeName: 'Ada Lovelace',
    clockedInAt: DateTime(2026, 1, 1, 9),
  );

  testWidgets(
    'subscribes to the repository stream exactly once, even across rebuilds',
    (tester) async {
      await pumpPage(tester);

      // Initial subscription happens once, in initState.
      expect(repository.watchClockRecordsCallCount, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      controller.add([record]);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Ada Lovelace'), findsOneWidget);

      // Simulate an unrelated ancestor rebuild (previously this recreated
      // the stream via `context.read<WorkforceRepository>().watchClockRecords(...)`
      // inside `build()`, resetting the UI back to a loading state).
      final hostState = tester.state<_RebuildHostState>(
        find.byType(_RebuildHost),
      );
      hostState.forceRebuild();
      await tester.pump();

      // No second subscription, and no flicker back to the loading spinner.
      expect(repository.watchClockRecordsCallCount, 1);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Ada Lovelace'), findsOneWidget);
    },
  );

  group(
    'variance badge (docs/features/04-volunteer-shift-accountability.md)',
    () {
      const manager = SessionEmployee(id: 9, name: 'Manager', role: 'manager');
      const cashier = SessionEmployee(id: 9, name: 'Cashier', role: 'cashier');

      final closedShift = ClockRecord(
        id: 1,
        employeeId: 1,
        employeeName: 'Ada Lovelace',
        clockedInAt: DateTime(2026, 1, 1, 9),
        clockedOutAt: DateTime(2026, 1, 1, 17),
      );

      testWidgets('unreconciled shift shows "Unreconciled" to everyone', (
        tester,
      ) async {
        await pumpPage(tester, viewer: cashier);
        controller.add([closedShift]);
        await tester.pump();

        expect(find.text('Unreconciled'), findsOneWidget);
      });

      testWidgets('reconciled shift hides the amount from a non-manager', (
        tester,
      ) async {
        await pumpPage(tester, viewer: cashier);
        controller.add([
          closedShift.copyWith(
            reconciliation: const CashReconciliation(
              id: 1,
              clockRecordId: 1,
              expectedCents: 1000,
              countedCents: 1000,
              varianceCents: 0,
            ),
          ),
        ]);
        await tester.pump();

        expect(find.text('Reconciled'), findsOneWidget);
        expect(find.textContaining('€'), findsNothing);
      });

      testWidgets('reconciled shift shows the variance amount to a manager', (
        tester,
      ) async {
        await pumpPage(tester, viewer: manager);
        controller.add([
          closedShift.copyWith(
            reconciliation: const CashReconciliation(
              id: 1,
              clockRecordId: 1,
              expectedCents: 1000,
              countedCents: 950,
              varianceCents: -50,
            ),
          ),
        ]);
        await tester.pump();

        expect(find.textContaining('€'), findsOneWidget);
        expect(find.text('Reconciled'), findsNothing);
      });
    },
  );
}
