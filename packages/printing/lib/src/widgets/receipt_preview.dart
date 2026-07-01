import 'package:flutter/material.dart';

import '../models/receipt.dart';
import '../rendering/money_format.dart';

/// An on-screen, paper-like preview of a [Receipt].
///
/// Mirrors the layout produced by `ReceiptRenderer` using a monospace font so
/// operators can confirm the receipt before printing.
class ReceiptPreview extends StatelessWidget {
  const ReceiptPreview({super.key, required this.receipt, this.width = 280});

  /// The receipt to display.
  final Receipt receipt;

  /// The width of the simulated paper, in logical pixels.
  final double width;

  @override
  Widget build(BuildContext context) {
    final symbol = receipt.currencySymbol;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          height: 1.4,
          color: Colors.black87,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              receipt.storeName.isEmpty ? 'Receipt' : receipt.storeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (_isNotEmpty(receipt.storeAddress))
              Text(receipt.storeAddress!, textAlign: TextAlign.center),
            if (_isNotEmpty(receipt.header)) Text(receipt.header!, textAlign: TextAlign.center),
            const _Divider(),
            Text('Order #${receipt.orderNumber}'),
            Text(_formatDateTime(receipt.createdAt)),
            const _Divider(),
            for (final line in receipt.lines) ...[
              _Row(
                left: '${line.quantity}x ${line.name}',
                right: formatReceiptMoney(line.lineTotalCents, symbol: symbol),
              ),
              for (final modifier in line.modifiers)
                Text(
                  '  + $modifier',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
            ],
            const _Divider(),
            _Row(
              left: 'Subtotal',
              right: formatReceiptMoney(receipt.subtotalCents, symbol: symbol),
            ),
            if (receipt.discountCents > 0)
              _Row(
                left: 'Discount',
                right: formatReceiptMoney(-receipt.discountCents, symbol: symbol),
              ),
            if (receipt.showTax && receipt.taxCents > 0)
              _Row(
                left: 'Tax',
                right: formatReceiptMoney(receipt.taxCents, symbol: symbol),
              ),
            _Row(
              left: 'TOTAL',
              right: formatReceiptMoney(receipt.totalCents, symbol: symbol),
              bold: true,
            ),
            if (_isNotEmpty(receipt.paymentMethod)) ...[
              const _Divider(),
              Text('Paid by: ${receipt.paymentMethod}'),
            ],
            if (receipt.tenderedCents != null)
              _Row(
                left: 'Tendered',
                right: formatReceiptMoney(receipt.tenderedCents!, symbol: symbol),
              ),
            if (receipt.changeCents != null)
              _Row(
                left: 'Change',
                right: formatReceiptMoney(receipt.changeCents!, symbol: symbol),
              ),
            if (_isNotEmpty(receipt.footer)) ...[
              const SizedBox(height: 8),
              Text(receipt.footer!, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }

  static bool _isNotEmpty(String? value) => value != null && value.isNotEmpty;

  static String _formatDateTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.left, required this.right, this.bold = false});

  final String left;
  final String right;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final weight = bold ? FontWeight.bold : FontWeight.normal;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              left,
              style: TextStyle(fontFamily: 'monospace', fontWeight: weight),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            right,
            style: TextStyle(fontFamily: 'monospace', fontWeight: weight),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Text(
        '--------------------------------',
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: TextStyle(fontFamily: 'monospace', color: Colors.black45),
      ),
    );
  }
}
