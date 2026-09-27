import 'package:feature_reports/domain/models/closing_report.dart';
import 'package:printing/printing.dart';

/// Maps a [ClosingReport] to a [Receipt] suitable for ESC/POS printing.
///
/// The receipt reuses the existing [ReceiptRenderer] — no new renderer needed.
/// Item lines are empty; the Z-report content is encoded in the header (period,
/// order counts, payment split) and the standard totals block (revenue, tax,
/// discounts). Cash-reconciliation figures appear in the footer when present.
extension ClosingReportReceiptMapper on ClosingReport {
  Receipt toZReportReceipt(ReceiptConfig config) {
    final at = createdAt ?? DateTime.now();
    final sym = config.currencySymbol;

    final header = [
      '** CHIUSURA DI CASSA **',
      'Periodo: ${_fmtDateTime(periodStart)} - ${_fmtDateTime(periodEnd)}',
      '------------------------',
      'Ordini completati: $totalOrders',
      'Ordini annullati:  $voidedOrders',
      '------------------------',
      'Contanti:  ${_fmtMoney(cashRevenueCents, sym)}',
      'Carta:     ${_fmtMoney(cardRevenueCents, sym)}',
    ].join('\n');

    final footer = cashCountedCents != null
        ? [
            '--- RICONCILIAZIONE CASSA ---',
            'Attesi:   ${_fmtMoney(cashRevenueCents, sym)}',
            'Contati:  ${_fmtMoney(cashCountedCents!, sym)}',
            'Diff.:    ${_fmtMoney(cashVarianceCents, sym)}',
            if (notes != null && notes!.isNotEmpty) 'Note: $notes',
          ].join('\n')
        : (notes != null && notes!.isNotEmpty ? 'Note: $notes' : null);

    return Receipt(
      storeName: config.storeName,
      storeAddress: config.storeAddress,
      header: header,
      footer: footer,
      orderNumber: 'Z',
      createdAt: at,
      lines: const [],
      // subtotalCents is revenue minus tax so the totals block computes
      // subtotal + tax = total correctly.
      subtotalCents: totalRevenueCents - totalTaxCents,
      taxCents: totalTaxCents,
      discountCents: totalDiscountCents,
      totalCents: totalRevenueCents,
      currencySymbol: sym,
      showTax: config.showTax,
    );
  }

  static String _fmtMoney(int cents, String symbol) {
    final euros = cents / 100;
    return '$symbol${euros.toStringAsFixed(2)}';
  }

  static String _fmtDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$d/$mo/${dt.year} $h:$mi';
  }
}
