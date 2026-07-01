class ReceiptConfig {
  const ReceiptConfig({
    this.storeName = 'Agora POS',
    this.header,
    this.footer,
    this.currencySymbol = r'$',
  });

  final String storeName;
  final String? header;
  final String? footer;
  final String currencySymbol;
}
