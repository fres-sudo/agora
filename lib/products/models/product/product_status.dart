/// Status of a product in the system.
enum ProductStatus {
  /// Product is active and can be ordered.
  active,

  /// Product is inactive and hidden from POS.
  inactive,

  /// Product is in draft mode (not yet published).
  draft,
}
