import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/domain/models/clock_record.dart';
import 'package:feature_workforce/domain/repositories/workforce_repository.dart';
import 'package:result/result.dart';

part 'clock_in_state.dart';
part 'clock_in_cubit.freezed.dart';

class ClockInCubit extends Cubit<ClockInState> {
  ClockInCubit({required WorkforceRepository workforceRepository})
      : _repo = workforceRepository,
        super(const ClockInState.initial());

  final WorkforceRepository _repo;

  Future<void> checkStatus(int employeeId) async {
    emit(const ClockInState.loading());
    final result = await _repo.getActiveClockRecord(employeeId);
    switch (result) {
      case Ok<ClockRecord?>(:final value):
        emit(
          value != null
              ? ClockInState.clockedIn(value)
              : const ClockInState.clockedOut(),
        );
      case Error<ClockRecord?>(:final error):
        emit(ClockInState.error(error.toString()));
    }
  }

  Future<void> clockIn(int employeeId) async {
    emit(const ClockInState.loading());
    final result = await _repo.clockIn(employeeId);
    switch (result) {
      case Ok<ClockRecord>(:final value):
        emit(ClockInState.clockedIn(value));
      case Error<ClockRecord>(:final error):
        emit(ClockInState.error(error.toString()));
    }
  }

  Future<void> clockOut(int employeeId) async {
    emit(const ClockInState.loading());
    final result = await _repo.clockOut(employeeId);
    switch (result) {
      case Ok<ClockRecord>():
        emit(const ClockInState.clockedOut());
      case Error<ClockRecord>(:final error):
        emit(ClockInState.error(error.toString()));
    }
  }

  bool get isClockedIn =>
      state.maybeWhen(clockedIn: (_) => true, orElse: () => false);
}
