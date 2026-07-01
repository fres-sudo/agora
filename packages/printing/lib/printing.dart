/// Receipt domain, ESC/POS rendering and thermal printing.
///
/// This package is intentionally free of any feature/business logic: it knows
/// how to describe a receipt ([Receipt]), turn it into printer bytes
/// ([ReceiptRenderer]) and send those bytes to a printer ([PrinterService]).
/// Features map their own domain models into a [Receipt] and depend only on the
/// [PrinterService] interface, never on a concrete printer/transport library.
library;

export 'src/config/receipt_config.dart';
export 'src/models/receipt.dart';
export 'src/rendering/receipt_renderer.dart';
export 'src/service/fake_printer_service.dart';
export 'src/service/printer_service.dart';
export 'src/service/thermal_printer_service.dart';
export 'src/widgets/receipt_preview.dart';
