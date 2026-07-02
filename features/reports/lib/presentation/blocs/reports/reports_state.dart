part of 'reports_cubit.dart';

/// Lifecycle of a report load.
enum ReportsStatus { initial, loading, success, failure }

@freezed
abstract class ReportsState with _$ReportsState {
  const factory ReportsState({
    @Default(ReportPeriod.today) ReportPeriod period,
    @Default(ReportsStatus.initial) ReportsStatus status,
    @Default(ReportData.empty) ReportData data,
    String? errorMessage,
  }) = _ReportsState;

  const ReportsState._();

  bool get isLoading => status == ReportsStatus.loading;
  bool get isFailure => status == ReportsStatus.failure;

  /// True once data has been loaded at least once (used to keep the previous
  /// report visible while a new period loads).
  bool get hasData => status == ReportsStatus.success;
}
