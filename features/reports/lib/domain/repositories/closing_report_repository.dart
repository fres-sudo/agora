import 'package:feature_reports/domain/models/closing_report.dart';
import 'package:result/result.dart';

/// Computes and persists end-of-day cash-closure reports.
abstract interface class ClosingReportRepository {
  /// Builds an unsaved [ClosingReport] by aggregating all completed and voided
  /// orders that fall within [[start], [end]]. Does not write to the database.
  Future<Result<ClosingReport>> buildForPeriod(DateTime start, DateTime end);

  /// Streams all persisted closures, newest first.
  Stream<List<ClosingReport>> watchAll();

  /// Persists [report] and returns the saved copy (with [ClosingReport.id] and
  /// [ClosingReport.createdAt] populated).
  Future<Result<ClosingReport>> save(ClosingReport report);
}
