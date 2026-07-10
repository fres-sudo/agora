/// The means by which a customer paid for an order.
///
/// Phase 1 ships a fixed set (cash + card). Phase 4 (P4-5) will let operators
/// configure/label the available methods; until then these two cover the
/// free-tier festival flow. The [label] is what gets persisted to
/// `OrdersTable.paymentMethod` and shown on the receipt.
enum PaymentMethod {
  cash('Cash'),
  card('Card');

  final String label;

  const PaymentMethod(this.label);

  /// Whether this method takes a tendered amount and computes change.
  bool get requiresTender => this == PaymentMethod.cash;

  /// Maps a persisted label back to a [PaymentMethod], or null if unknown.
  static PaymentMethod? fromLabel(String? label) {
    if (label == null) return null;
    for (final method in PaymentMethod.values) {
      if (method.label == label) return method;
    }
    return null;
  }
}
