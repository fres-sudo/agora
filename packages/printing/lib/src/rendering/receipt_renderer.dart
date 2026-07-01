import 'dart:convert';

import '../models/receipt.dart';

class ReceiptRenderer {
  const ReceiptRenderer();

  Future<List<int>> toEscPos(Receipt receipt) async {
    final buffer = StringBuffer()
      ..writeln(receipt.storeName)
      ..writeln('Order #${receipt.orderNumber}')
      ..writeln(receipt.createdAt.toIso8601String())
      ..writeln('------------------------------');

    for (final item in receipt.items) {
      buffer.writeln('${item.quantity} x ${item.name}');
      if (item.modifiers.isNotEmpty) {
        buffer.writeln('  ${item.modifiers.join(', ')}');
      }
      buffer.writeln(_formatMoney(receipt.currencySymbol, item.lineTotalCents));
    }

    buffer
      ..writeln('------------------------------')
      ..writeln('TOTAL ${_formatMoney(receipt.currencySymbol, receipt.totalCents)}');

    if (receipt.tenderedCents != null) {
      buffer.writeln(
        'Tendered ${_formatMoney(receipt.currencySymbol, receipt.tenderedCents!)}',
      );
    }
    if (receipt.changeCents != null) {
      buffer.writeln(
        'Change ${_formatMoney(receipt.currencySymbol, receipt.changeCents!)}',
      );
    }

    return utf8.encode(buffer.toString());
  }

  String _formatMoney(String symbol, int cents) {
    return '$symbol${(cents / 100).toStringAsFixed(2)}';
  }
}
