import 'package:flutter/foundation.dart';

/// A single printed line on a [Receipt].
@immutable
class ReceiptLine {
  const ReceiptLine({
    required this.name,
    required this.quantity,
    required this.unitPriceCents,
    this.modifiers = const [],
  });

  /// Item display name (snapshot taken at sale time).
  final String name;

  /// Quantity sold.
  final int quantity;

  /// Unit price in cents (already includes the item's modifiers).
  final int unitPriceCents;

  /// Human-readable modifier labels printed under the item (e.g. "Size: Large").
  final List<String> modifiers;

  /// Line total in cents (`quantity * unitPriceCents`).
  int get lineTotalCents => quantity * unitPriceCents;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptLine &&
          other.name == name &&
          other.quantity == quantity &&
          other.unitPriceCents == unitPriceCents &&
          listEquals(other.modifiers, modifiers);

  @override
  int get hashCode =>
      Object.hash(name, quantity, unitPriceCents, Object.hashAll(modifiers));
}

/// A fully-described receipt, ready to be previewed on screen
/// ([ReceiptPreview]) or rendered to printer bytes ([ReceiptRenderer]).
///
/// All monetary values are integer cents. A [Receipt] is produced by mapping a
/// feature's domain model (e.g. an `Order`) together with a `ReceiptConfig`.
@immutable
class Receipt {
  const Receipt({
    required this.storeName,
    required this.orderNumber,
    required this.createdAt,
    required this.lines,
    required this.subtotalCents,
    required this.taxCents,
    required this.discountCents,
    required this.totalCents,
    this.storeAddress,
    this.header,
    this.footer,
    this.paymentMethod,
    this.tenderedCents,
    this.changeCents,
    this.currencySymbol = '€',
    this.showTax = true,
  });

  /// Business name printed at the top.
  final String storeName;

  /// Optional address line(s) under the store name.
  final String? storeAddress;

  /// Optional header text above the items.
  final String? header;

  /// Optional footer text at the bottom.
  final String? footer;

  /// The order identifier shown on the receipt (e.g. `'42'`).
  final String orderNumber;

  /// When the sale completed.
  final DateTime createdAt;

  /// The purchased lines.
  final List<ReceiptLine> lines;

  /// Sum of the lines before tax/discount, in cents.
  final int subtotalCents;

  /// Tax amount in cents.
  final int taxCents;

  /// Discount amount in cents.
  final int discountCents;

  /// Grand total collected, in cents.
  final int totalCents;

  /// Payment method label (e.g. `'Cash'`), or null if unknown.
  final String? paymentMethod;

  /// Cash tendered by the customer, in cents (cash sales only).
  final int? tenderedCents;

  /// Change returned to the customer, in cents (cash sales only).
  final int? changeCents;

  /// Currency symbol used for every amount.
  final String currencySymbol;

  /// Whether the tax line is shown in the totals block.
  final bool showTax;

  Receipt copyWith({
    String? storeName,
    String? storeAddress,
    String? header,
    String? footer,
    String? orderNumber,
    DateTime? createdAt,
    List<ReceiptLine>? lines,
    int? subtotalCents,
    int? taxCents,
    int? discountCents,
    int? totalCents,
    String? paymentMethod,
    int? tenderedCents,
    int? changeCents,
    String? currencySymbol,
    bool? showTax,
  }) {
    return Receipt(
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      orderNumber: orderNumber ?? this.orderNumber,
      createdAt: createdAt ?? this.createdAt,
      lines: lines ?? this.lines,
      subtotalCents: subtotalCents ?? this.subtotalCents,
      taxCents: taxCents ?? this.taxCents,
      discountCents: discountCents ?? this.discountCents,
      totalCents: totalCents ?? this.totalCents,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tenderedCents: tenderedCents ?? this.tenderedCents,
      changeCents: changeCents ?? this.changeCents,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      showTax: showTax ?? this.showTax,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Receipt &&
          other.storeName == storeName &&
          other.storeAddress == storeAddress &&
          other.header == header &&
          other.footer == footer &&
          other.orderNumber == orderNumber &&
          other.createdAt == createdAt &&
          listEquals(other.lines, lines) &&
          other.subtotalCents == subtotalCents &&
          other.taxCents == taxCents &&
          other.discountCents == discountCents &&
          other.totalCents == totalCents &&
          other.paymentMethod == paymentMethod &&
          other.tenderedCents == tenderedCents &&
          other.changeCents == changeCents &&
          other.currencySymbol == currencySymbol &&
          other.showTax == showTax;

  @override
  int get hashCode => Object.hashAll([
    storeName,
    storeAddress,
    header,
    footer,
    orderNumber,
    createdAt,
    Object.hashAll(lines),
    subtotalCents,
    taxCents,
    discountCents,
    totalCents,
    paymentMethod,
    tenderedCents,
    changeCents,
    currencySymbol,
    showTax,
  ]);
}
