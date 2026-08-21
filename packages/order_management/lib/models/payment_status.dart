/// Durable lifecycle of a non-cash payment attempt.
enum PaymentStatus {
  pending,
  approved,
  declined,
  cancelled,
  unknown,
  failed;

  static PaymentStatus? fromName(String? value) {
    for (final status in values) {
      if (status.name == value) return status;
    }
    return null;
  }
}
