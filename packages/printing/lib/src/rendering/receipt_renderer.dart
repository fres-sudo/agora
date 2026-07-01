import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

import '../config/receipt_config.dart';
import '../models/receipt.dart';
import 'money_format.dart';

/// Turns a [Receipt] into ESC/POS bytes for a thermal printer.
///
/// The renderer is stateless and `const`-constructible. It loads the default
/// capability profile lazily, which is why [toEscPos] is asynchronous.
class ReceiptRenderer {
  const ReceiptRenderer();

  /// Renders [receipt] to ESC/POS bytes for the given [paperSize].
  Future<List<int>> toEscPos(
    Receipt receipt, {
    ReceiptPaperSize paperSize = ReceiptPaperSize.mm80,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(_paperSize(paperSize), profile);
    final symbol = receipt.currencySymbol;

    final bytes = <int>[];

    // Header: store name + optional address / header text.
    bytes.addAll(
      generator.text(
        _safe(receipt.storeName.isEmpty ? 'Receipt' : receipt.storeName),
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    );
    if (receipt.storeAddress case final String address when address.isNotEmpty) {
      bytes.addAll(generator.text(_safe(address), styles: const PosStyles(align: PosAlign.center)));
    }
    if (receipt.header case final String header when header.isNotEmpty) {
      bytes.addAll(generator.text(_safe(header), styles: const PosStyles(align: PosAlign.center)));
    }

    bytes.addAll(generator.hr());

    // Order metadata.
    bytes.addAll(generator.text(_safe('Order #${receipt.orderNumber}')));
    bytes.addAll(generator.text(_safe(_formatDateTime(receipt.createdAt))));
    bytes.addAll(generator.hr());

    // Line items.
    for (final line in receipt.lines) {
      bytes.addAll(
        generator.row([
          PosColumn(text: _safe('${line.quantity}x ${line.name}'), width: 8),
          PosColumn(
            text: _safe(formatReceiptMoney(line.lineTotalCents, symbol: symbol)),
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]),
      );
      for (final modifier in line.modifiers) {
        bytes.addAll(
          generator.text(
            _safe('  + $modifier'),
            styles: const PosStyles(fontType: PosFontType.fontB),
          ),
        );
      }
    }

    bytes.addAll(generator.hr());

    // Totals.
    bytes.addAll(_amountRow(generator, 'Subtotal', receipt.subtotalCents, symbol));
    if (receipt.discountCents > 0) {
      bytes.addAll(_amountRow(generator, 'Discount', -receipt.discountCents, symbol));
    }
    if (receipt.showTax && receipt.taxCents > 0) {
      bytes.addAll(_amountRow(generator, 'Tax', receipt.taxCents, symbol));
    }
    bytes.addAll(
      _amountRow(generator, 'TOTAL', receipt.totalCents, symbol, bold: true, size2: true),
    );

    // Payment / change.
    if (receipt.paymentMethod case final String method when method.isNotEmpty) {
      bytes.addAll(generator.hr());
      bytes.addAll(generator.text(_safe('Paid by: $method')));
    }
    if (receipt.tenderedCents case final int tendered) {
      bytes.addAll(_amountRow(generator, 'Tendered', tendered, symbol));
    }
    if (receipt.changeCents case final int change) {
      bytes.addAll(_amountRow(generator, 'Change', change, symbol));
    }

    // Footer.
    if (receipt.footer case final String footer when footer.isNotEmpty) {
      bytes.addAll(generator.feed(1));
      bytes.addAll(generator.text(_safe(footer), styles: const PosStyles(align: PosAlign.center)));
    }

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }

  List<int> _amountRow(
    Generator generator,
    String label,
    int cents,
    String symbol, {
    bool bold = false,
    bool size2 = false,
  }) {
    final styles = PosStyles(
      bold: bold,
      height: size2 ? PosTextSize.size2 : PosTextSize.size1,
      width: size2 ? PosTextSize.size2 : PosTextSize.size1,
    );
    return generator.row([
      PosColumn(text: _safe(label), width: 6, styles: styles),
      PosColumn(
        text: _safe(formatReceiptMoney(cents, symbol: symbol)),
        width: 6,
        styles: styles.copyWith(align: PosAlign.right),
      ),
    ]);
  }

  PaperSize _paperSize(ReceiptPaperSize size) => switch (size) {
    ReceiptPaperSize.mm58 => PaperSize.mm58,
    ReceiptPaperSize.mm80 => PaperSize.mm80,
  };

  /// Makes [text] safe for the printer's Latin-1 code table.
  ///
  /// The ESC/POS generator encodes text as Latin-1, which cannot represent the
  /// Euro sign (and other Unicode symbols). We spell out `€` as `EUR` and drop
  /// any remaining non-Latin-1 runes so rendering never throws on a symbol the
  /// printer can't encode. The on-screen preview keeps the original symbols.
  String _safe(String text) {
    final mapped = text.replaceAll('€', 'EUR ');
    return String.fromCharCodes(mapped.runes.map((rune) => rune <= 0xFF ? rune : 0x3F /* '?' */));
  }

  String _formatDateTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }
}
