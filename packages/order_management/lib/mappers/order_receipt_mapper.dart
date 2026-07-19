import 'package:printing/printing.dart';

import 'package:order_management/models/order.dart';
import 'package:order_management/models/order_line_item.dart';

/// Maps an [Order] into a printable [Receipt] using the store's
/// [ReceiptConfig].
extension OrderReceiptMapper on Order {
  /// Builds the [Receipt] for this order.
  ///
  /// [tenderedCents] / [changeCents] are supplied for cash sales so the receipt
  /// shows the amount paid and the change returned; pass null for card sales.
  Receipt toReceipt(
    ReceiptConfig config, {
    int? tenderedCents,
    int? changeCents,
  }) {
    return Receipt(
      storeName: config.storeName,
      storeAddress: config.storeAddress,
      header: config.header,
      footer: config.footer,
      orderNumber: (id ?? 0).toString(),
      createdAt: createdAt,
      lines: _receiptLines(),
      subtotalCents: subtotalCents,
      taxCents: taxCents,
      discountCents: discountCents,
      totalCents: grandTotalCents,
      paymentMethod: paymentMethod,
      tenderedCents: tenderedCents,
      changeCents: changeCents,
      currencySymbol: config.currencySymbol,
      showTax: config.showTax,
    );
  }

  /// Groups this order's line items by prep station and builds one ticket
  /// [Receipt] per station — a simpler receipt variant with no
  /// totals/payment block that matters to the kitchen. Items with no
  /// station are never ticketed; they stay on the customer receipt only
  /// (docs/features/02-kitchen-ticket-routing.md).
  List<Receipt> toStationTickets() {
    final byStation = <String, List<OrderLineItem>>{};
    for (final item in items) {
      final station = item.prepStation;
      if (station == null) continue;
      (byStation[station] ??= []).add(item);
    }

    return byStation.entries.map((entry) {
      final lines = entry.value.map(_lineFor).toList();
      final totalCents = lines.fold(
        0,
        (sum, line) => sum + line.lineTotalCents,
      );
      return Receipt(
        storeName: entry.key.toUpperCase(),
        header: 'KITCHEN TICKET',
        orderNumber: (id ?? 0).toString(),
        createdAt: createdAt,
        lines: lines,
        subtotalCents: totalCents,
        taxCents: 0,
        discountCents: 0,
        totalCents: totalCents,
        showTax: false,
      );
    }).toList();
  }

  /// Builds the customer-receipt line list, re-grouping fanned-out combo
  /// constituent rows (see `OrdersRepositoryImpl._insertComboLine`) back
  /// into one [ReceiptLine] per combo sale, keyed by [OrderLineItem.comboLineId].
  /// Non-combo rows go through [_lineFor] unchanged. Kitchen tickets
  /// ([toStationTickets]) intentionally do NOT group — each constituent
  /// should appear as its own ticket item routed to its own station.
  List<ReceiptLine> _receiptLines() {
    final lines = <ReceiptLine>[];
    final seenComboLineIds = <int>{};
    for (final item in items) {
      final comboLineId = item.comboLineId;
      if (comboLineId != null) {
        if (!seenComboLineIds.add(comboLineId)) {
          continue; // Already emitted this combo sale's grouped line.
        }
        final siblings = items.where((i) => i.comboLineId == comboLineId);
        final lead = siblings.firstWhere(
          (i) => i.unitPriceCents > 0,
          orElse: () => siblings.first,
        );
        lines.add(
          ReceiptLine(
            name: lead.comboName ?? lead.productName,
            quantity: lead.comboSaleQuantity ?? 1,
            unitPriceCents: lead.unitPriceCents,
            modifiers: [
              for (final sibling in siblings)
                '${sibling.quantity}x ${sibling.productName}',
            ],
          ),
        );
      } else {
        lines.add(_lineFor(item));
      }
    }
    return lines;
  }

  ReceiptLine _lineFor(OrderLineItem item) => ReceiptLine(
    name: item.productName,
    quantity: item.quantity,
    unitPriceCents: item.unitPriceCents,
    modifiers: [
      for (final modifier in item.selectedModifiers)
        '${modifier.groupName}: ${modifier.optionName}',
    ],
  );
}
