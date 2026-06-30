import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/domain/models/clock_record.dart';
import 'package:feature_workforce/domain/repositories/workforce_repository.dart';

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
    result.when(
      success: (record) => emit(
        record != null
            ? ClockInState.clockedIn(record)
            : const ClockInState.clockedOut(),
      ),
      error: (e) => emit(ClockInState.error(e.toString())),
    );
  }

  Future<void> clockIn(int employeeId) async {
    emit(const ClockInState.loading());
    final result = await _repo.clockIn(employeeId);
    result.when(
      success: (record) => emit(ClockInState.clockedIn(record)),
      error: (e) => emit(ClockInState.error(e.toString())),
    );
  }

  Future<void> clockOut(int employeeId) async {
    emit(const ClockInState.loading());
    final result = await _repo.clockOut(employeeId);
    result.when(
      success: (_) => emit(const ClockInState.clockedOut()),
      error: (e) => emit(ClockInState.error(e.toString())),
    );
  }

  bool get isClockedIn => state is _ClockedIn;
}
