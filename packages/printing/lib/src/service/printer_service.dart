import 'package:result/result.dart';

/// The outcome of a print attempt: `Ok(true)` on success, `Error` on failure.
///
/// Callers only care about success/failure — the boolean payload exists solely
/// because [Result] always carries a value on the success branch.
typedef PrintResult = Result<bool>;

/// Sends pre-rendered ESC/POS bytes to a printer.
///
/// This is the only printing contract features depend on. It is deliberately
/// transport-agnostic: byte *generation* is done by `ReceiptRenderer`, and the
/// concrete transport (network, Bluetooth, USB) is an implementation detail of
/// whichever [PrinterService] the app wires up (see `ThermalPrinterServiceImpl`).
abstract interface class PrinterService {
  /// Sends [bytes] to the printer.
  ///
  /// Returns an `Ok` result when the job was handed off successfully, or an
  /// `Error` describing why it could not be sent. Implementations must not
  /// throw — failures are reported through the returned [PrintResult].
  Future<PrintResult> printBytes(List<int> bytes);

  /// Releases any resources held by the service (e.g. an open connection).
  ///
  /// Called when the owning provider tree is torn down. Implementations that
  /// hold no resources may leave this as a no-op.
  void dispose();
}
