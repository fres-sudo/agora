import 'package:flutter/foundation.dart';

/// The physical paper width of the receipt printer.
enum ReceiptPaperSize {
  /// 58mm paper (≈ 32 chars at font A).
  mm58,

  /// 80mm paper (≈ 48 chars at font A).
  mm80,
}

/// Store / receipt presentation settings used when building and rendering a
/// [Receipt].
///
/// This is pure configuration — it carries no order data. Features build it
/// from their own settings (see `buildReceiptConfig`) and pass it to the
/// receipt mapper.
@immutable
class ReceiptConfig {
  const ReceiptConfig({
    this.storeName = '',
    this.storeAddress,
    this.header,
    this.footer,
    this.currencySymbol = '€',
    this.showTax = true,
    this.paperSize = ReceiptPaperSize.mm80,
  });

  /// Business name printed at the top of the receipt.
  final String storeName;

  /// Optional address line(s) printed under the store name.
  final String? storeAddress;

  /// Optional free-text header printed above the items (e.g. a greeting).
  final String? header;

  /// Optional free-text footer printed at the bottom (e.g. "Thank you!").
  final String? footer;

  /// Currency symbol used for every amount on the receipt.
  final String currencySymbol;

  /// Whether the tax line is shown in the totals block.
  final bool showTax;

  /// The target printer paper width.
  final ReceiptPaperSize paperSize;

  ReceiptConfig copyWith({
    String? storeName,
    String? storeAddress,
    String? header,
    String? footer,
    String? currencySymbol,
    bool? showTax,
    ReceiptPaperSize? paperSize,
  }) {
    return ReceiptConfig(
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      showTax: showTax ?? this.showTax,
      paperSize: paperSize ?? this.paperSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptConfig &&
          other.storeName == storeName &&
          other.storeAddress == storeAddress &&
          other.header == header &&
          other.footer == footer &&
          other.currencySymbol == currencySymbol &&
          other.showTax == showTax &&
          other.paperSize == paperSize;

  @override
  int get hashCode => Object.hash(
    storeName,
    storeAddress,
    header,
    footer,
    currencySymbol,
    showTax,
    paperSize,
  );
}
