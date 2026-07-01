import 'package:result/result.dart';
import 'package:talker/talker.dart';

import 'printer_service.dart';

/// Sends already-rendered ESC/POS bytes to a physical thermal printer over an
/// injected [PrinterTransport].
typedef PrinterTransport = Future<void> Function(List<int> bytes);

/// The default [PrinterService] used by the app.
///
/// This package only knows how to *generate* ESC/POS bytes; the actual wire
/// transport (TCP/9100, Bluetooth, USB) is supplied by the app as a
/// [PrinterTransport]. When no transport is configured the service logs the job
/// and reports success, so the checkout/receipt flow remains fully usable
/// before a printer is connected.
class ThermalPrinterServiceImpl implements PrinterService {
  ThermalPrinterServiceImpl({required Talker logger, PrinterTransport? transport})
    : _logger = logger,
      _transport = transport;

  final Talker _logger;
  final PrinterTransport? _transport;

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
      await transport(bytes);
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
