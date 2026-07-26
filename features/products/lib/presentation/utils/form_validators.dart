/// Client-side validation helpers for the product form.
///
/// Each method returns an error string if validation fails, null otherwise.
/// Field constraints are kept here as a single source of truth.
class FormValidators {
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxSkuLength = 50;
  // $999,999.99 expressed in cents
  static const int maxPriceCents = 99_999_999;
  static const int maxTaxPercent = 100;

  static String? validateName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Product name is required';
    if (trimmed.length > maxNameLength) {
      return 'Name cannot exceed $maxNameLength characters';
    }
    return null;
  }

  static String? validateDescription(String value) {
    if (value.length > maxDescriptionLength) {
      return 'Description cannot exceed $maxDescriptionLength characters';
    }
    return null;
  }

  static String? validateSku(String value) {
    if (value.length > maxSkuLength) {
      return 'SKU cannot exceed $maxSkuLength characters';
    }
    return null;
  }

  static String? validateCategory(int? categoryId) {
    if (categoryId == null) return 'Please select a category';
    return null;
  }

  static String? validatePrice(int priceCents) {
    if (priceCents <= 0) return 'Price must be greater than 0';
    if (priceCents > maxPriceCents) {
      return 'Price exceeds the maximum allowed amount';
    }
    return null;
  }

  static String? validateTax(int taxPercent) {
    if (taxPercent > maxTaxPercent) return 'Tax cannot exceed $maxTaxPercent%';
    return null;
  }
}
