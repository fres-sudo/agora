import 'dart:async';

import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/domain/models/clock_record.dart';
import 'package:feature_workforce/domain/repositories/workforce_repository.dart';

part 'clock_records_state.dart';
part 'clock_records_cubit.freezed.dart';

/// Owns the clock-records stream subscription so it survives rebuilds of
/// [ClockRecordsCubit]'s consumers.
///
/// [watch] is meant to be called once (e.g. from a page's `initState`), not
/// from `build()` -- calling it repeatedly cancels the previous subscription
/// and starts a fresh one, which would reset the UI back to a loading state
/// on every rebuild. Because the cubit instance itself is provided once
/// (see `WorkforceFeature.providers`) and outlives individual widget
/// rebuilds, the subscription created here is created exactly once per
/// `watch` call and reused across rebuilds.
class ClockRecordsCubit extends Cubit<ClockRecordsState> {
  ClockRecordsCubit({required WorkforceRepository workforceRepository})
    : _repo = workforceRepository,
      super(const ClockRecordsState.loading());

  final WorkforceRepository _repo;
  StreamSubscription<List<ClockRecord>>? _subscription;

  /// Subscribes to clock records for [employeeId] (or every employee, when
  /// null). Safe to call again with a different [employeeId]; any previous
  /// subscription is cancelled first.
  void watch({int? employeeId}) {
    emit(const ClockRecordsState.loading());
    _subscription?.cancel();
    _subscription = _repo
        .watchClockRecords(employeeId: employeeId)
        .listen(
          (records) => emit(ClockRecordsState.loaded(records)),
          onError: (Object error, _) =>
              emit(ClockRecordsState.error(error.toString())),
        );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
