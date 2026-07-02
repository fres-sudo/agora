import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/widgets.dart';
import 'package:feature_reports/domain/models/report_data.dart';
import 'package:feature_reports/domain/models/report_period.dart';
import 'package:feature_reports/domain/repositories/reports_repository.dart';
import 'package:result/result.dart';

part 'reports_cubit.freezed.dart';
part 'reports_state.dart';

/// Drives the end-of-day / sales report screen.
///
/// Loads an aggregated [ReportData] for the selected [ReportPeriod] from the
/// [ReportsRepository] and exposes loading / success / failure states. Changing
/// the period reloads the report (P5-2).
class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit({required ReportsRepository reportsRepository})
    : _reportsRepository = reportsRepository,
      super(const ReportsState());

  final ReportsRepository _reportsRepository;

  /// Loads (or reloads) the report for the currently selected period.
  Future<void> load() => _loadFor(state.period);

  /// Switches the reporting window and reloads. No-op if unchanged and already
  /// loaded, to avoid redundant queries.
  Future<void> selectPeriod(ReportPeriod period) {
    if (period == state.period && state.status == ReportsStatus.success) {
      return Future.value();
    }
    return _loadFor(period);
  }

  Future<void> _loadFor(ReportPeriod period) async {
    emit(
      state.copyWith(
        period: period,
        status: ReportsStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _reportsRepository.getReport(period);

    switch (result) {
      case Ok<ReportData>(:final value):
        emit(
          state.copyWith(
            status: ReportsStatus.success,
            data: value,
          ),
        );
      case Error<ReportData>():
        emit(
          state.copyWith(
            status: ReportsStatus.failure,
            errorMessage: 'Could not load the report. Please try again.',
          ),
        );
    }
  }
}

extension ReportsCubitExtension on BuildContext {
  ReportsCubit get reportsCubit => read<ReportsCubit>();
}
