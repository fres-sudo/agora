part of 'clock_records_cubit.dart';

@freezed
abstract class ClockRecordsState with _$ClockRecordsState {
  const factory ClockRecordsState.loading() = _Loading;
  const factory ClockRecordsState.loaded(List<ClockRecord> records) = _Loaded;
  const factory ClockRecordsState.error(String message) = _Error;
}
