import 'package:result/result.dart';

import 'printer_service.dart';

/// An in-memory [PrinterService] for tests and previews.
///
/// Captures every job it is asked to print in [printedJobs] so tests can assert
/// on what was sent, and can be made to fail via [failPrint].
class FakePrinterService implements PrinterService {
  /// Every successfully "printed" job, in order, as a copy of its bytes.
  final List<List<int>> printedJobs = [];

  /// When true, [printBytes] reports a failure instead of capturing the job.
  bool failPrint = false;

  @override
  Future<PrintResult> printBytes(List<int> bytes) async {
    if (failPrint) {
      return Result.error(Exception('FakePrinterService: forced failure'));
    }
    printedJobs.add(List<int>.unmodifiable(bytes));
    return const Result.ok(true);
  }

  /// Clears all captured jobs.
  @override
  void dispose() => printedJobs.clear();
}
