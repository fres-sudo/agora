part of 'clock_in_cubit.dart';

@freezed
abstract class ClockInState with _$ClockInState {
  const factory ClockInState.initial() = _Initial;
  const factory ClockInState.loading() = _Loading;
  const factory ClockInState.clockedIn(ClockRecord record) = _ClockedIn;
  const factory ClockInState.clockedOut() = _ClockedOut;
  const factory ClockInState.error(String message) = _Error;
}
