import 'package:logger/logger.dart';
import 'package:result/result.dart';

abstract interface class PrinterService {
  Future<Result<void>> printBytes(List<int> bytes);
  Future<void> dispose();
}

class ThermalPrinterServiceImpl implements PrinterService {
  ThermalPrinterServiceImpl({Talker? logger}) : _logger = logger;

  final Talker? _logger;

  @override
  Future<Result<void>> printBytes(List<int> bytes) async {
    _logger?.debug('[Printer] printBytes called (${bytes.length} bytes)');
    return const Result.ok(null);
  }

  @override
  Future<void> dispose() async {}
}

class FakePrinterService implements PrinterService {
  final List<List<int>> printedJobs = <List<int>>[];
  bool failPrint = false;

  @override
  Future<Result<void>> printBytes(List<int> bytes) async {
    if (failPrint) {
      return Result.error(Exception('Printer unavailable'));
    }
    printedJobs.add(bytes);
    return const Result.ok(null);
  }

  @override
  Future<void> dispose() async {}
}
