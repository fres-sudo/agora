import 'package:printing/printing.dart';

import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';

/// Maps an [Order] into a printable [Receipt] using the store's
/// [ReceiptConfig].
extension OrderReceiptMapper on Order {
  /// Builds the [Receipt] for this order.
  ///
  /// [tenderedCents] / [changeCents] are supplied for cash sales so the receipt
  /// shows the amount paid and the change returned; pass null for card sales.
  Receipt toReceipt(ReceiptConfig config, {int? tenderedCents, int? changeCents}) {
    return Receipt(
      storeName: config.storeName,
      storeAddress: config.storeAddress,
      header: config.header,
      footer: config.footer,
      orderNumber: (id ?? 0).toString(),
      createdAt: createdAt,
      lines: items.map(_lineFor).toList(),
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
