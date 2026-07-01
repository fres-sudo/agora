class Receipt {
  const Receipt({
    required this.orderNumber,
    required this.storeName,
    required this.createdAt,
    required this.items,
    required this.subtotalCents,
    required this.discountCents,
    required this.taxCents,
    required this.totalCents,
    this.paymentMethod,
    this.tenderedCents,
    this.changeCents,
    this.header,
    this.footer,
    this.currencySymbol = r'$',
  });

  final String orderNumber;
  final String storeName;
  final DateTime createdAt;
  final List<ReceiptLineItem> items;
  final int subtotalCents;
  final int discountCents;
  final int taxCents;
  final int totalCents;
  final String? paymentMethod;
  final int? tenderedCents;
  final int? changeCents;
  final String? header;
  final String? footer;
  final String currencySymbol;
}

class ReceiptLineItem {
  const ReceiptLineItem({
    required this.name,
    required this.quantity,
    required this.unitPriceCents,
    this.modifiers = const <String>[],
  });

  final String name;
  final int quantity;
  final int unitPriceCents;
  final List<String> modifiers;

  int get lineTotalCents => quantity * unitPriceCents;
}
