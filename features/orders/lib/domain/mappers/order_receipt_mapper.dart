import 'package:feature_orders/domain/models/order.dart';
import 'package:printing/printing.dart';

extension OrderReceiptMapper on Order {
  Receipt toReceipt(
    ReceiptConfig config, {
    int? tenderedCents,
    int? changeCents,
  }) {
    return Receipt(
      orderNumber: (id ?? 0).toString(),
      storeName: config.storeName,
      createdAt: createdAt,
      items: items
          .map(
            (item) => ReceiptLineItem(
              name: item.productName,
              quantity: item.quantity,
              unitPriceCents: item.unitPriceCents,
              modifiers: item.selectedModifiers
                  .map((m) => '${m.groupName}: ${m.optionName}')
                  .toList(),
            ),
          )
          .toList(),
      subtotalCents: subtotalCents,
      discountCents: discountCents,
      taxCents: taxCents,
      totalCents: grandTotalCents,
      paymentMethod: paymentMethod,
      tenderedCents: tenderedCents,
      changeCents: changeCents,
      header: config.header,
      footer: config.footer,
      currencySymbol: config.currencySymbol,
    );
  }
}
