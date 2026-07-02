import 'package:feature_reports/domain/models/report_data.dart';
import 'package:feature_reports/domain/models/report_period.dart';
import 'package:result/result.dart';

/// Composes order, order-item and product data into an aggregated [ReportData]
/// for a reporting period. Read-only — reporting never mutates state.
abstract interface class ReportsRepository {
  /// Builds the full report for the given [period].
  ///
  /// [now] is injectable for deterministic testing; production callers omit it.
  Future<Result<ReportData>> getReport(ReportPeriod period, {DateTime? now});
}
