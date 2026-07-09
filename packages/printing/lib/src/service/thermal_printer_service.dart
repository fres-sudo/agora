import 'dart:async';

import 'package:result/result.dart';
import 'package:talker/talker.dart';

import 'printer_service.dart';

/// Sends already-rendered ESC/POS bytes to a physical thermal printer over an
/// injected [PrinterTransport].
typedef PrinterTransport = Future<void> Function(List<int> bytes);

/// Thrown when a [PrinterTransport] does not complete a write within the
/// configured timeout (e.g. a Bluetooth/USB connection that hung mid-write).
///
/// Surfaced to callers via [PrintResult] so checkout/reprint flows can show a
/// "printer not responding" message and let the cashier retry instead of the
/// UI blocking indefinitely.
class PrinterTimeoutException implements Exception {
  PrinterTimeoutException(this.timeout);

  final Duration timeout;

  @override
  String toString() =>
      'PrinterTimeoutException: printer did not respond within '
      '${timeout.inSeconds}s';
}

/// The default [PrinterService] used by the app.
///
/// This package only knows how to *generate* ESC/POS bytes; the actual wire
/// transport (TCP/9100, Bluetooth, USB) is supplied by the app as a
/// [PrinterTransport]. When no transport is configured the service logs the job
/// and reports success, so the checkout/receipt flow remains fully usable
/// before a printer is connected.
class ThermalPrinterServiceImpl implements PrinterService {
  ThermalPrinterServiceImpl({
    required Talker logger,
    PrinterTransport? transport,
    Duration transportTimeout = const Duration(seconds: 5),
  }) : _logger = logger,
       _transport = transport,
       _transportTimeout = transportTimeout;

  final Talker _logger;
  final PrinterTransport? _transport;

  /// Ceiling on how long a single [PrinterTransport] write may take.
  ///
  /// A hung Bluetooth/USB connection would otherwise block the caller
  /// (checkout/reprint) indefinitely. On expiry the job is reported as a
  /// [PrinterTimeoutException] rather than left pending forever.
  final Duration _transportTimeout;

  @override
  Future<PrintResult> printBytes(List<int> bytes) async {
    final transport = _transport;
    if (transport == null) {
      _logger.warning(
        '[Printing] No printer transport configured — '
        '${bytes.length} bytes were not sent to a physical printer.',
      );
      return const Result.ok(true);
    }

    try {
      await transport(bytes).timeout(
        _transportTimeout,
        onTimeout: () => throw PrinterTimeoutException(_transportTimeout),
      );
      _logger.debug('[Printing] Sent ${bytes.length} bytes to the printer.');
      return const Result.ok(true);
    } catch (error, stack) {
      _logger.handle(error, stack, '[Printing] printBytes failed');
      return Result.error(
        error is Exception ? error : Exception(error.toString()),
      );
    }
  }

  @override
  void dispose() {
    // No persistent connection is held: the transport is invoked per job.
  }
}
