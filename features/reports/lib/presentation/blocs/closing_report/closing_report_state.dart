part of 'closing_report_cubit.dart';

enum ClosingReportStatus { initial, loading, ready, saving, saved, error }

@freezed
abstract class ClosingReportState with _$ClosingReportState {
  const factory ClosingReportState({
    @Default(ClosingReportStatus.initial) ClosingReportStatus status,

    /// The closure being built for the current session (not yet persisted).
    ClosingReport? currentReport,

    /// All previously saved closures, newest first.
    @Default([]) List<ClosingReport> history,

    String? errorMessage,
  }) = _ClosingReportState;

  const ClosingReportState._();

  bool get isLoading => status == ClosingReportStatus.loading;

  bool get isReady =>
      status == ClosingReportStatus.ready ||
      status == ClosingReportStatus.saved;

  bool get isSaving => status == ClosingReportStatus.saving;
}
