import 'package:catalog/models/product_status.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'product_form_data.freezed.dart';

/// Form data model for the product create/edit form.
/// Separate from the domain Product model to handle form-specific state.
@freezed
abstract class ProductFormData with _$ProductFormData {
  const factory ProductFormData({
    /// The product ID (0 for new products).
    @Default(0) int id,

    /// Product name.
    @Default('') String name,

    /// Product description.
    @Default('') String description,

    /// Product SKU/barcode.
    @Default('') String sku,

    /// Product image URL.
    String? imageUrl,

    /// Selected category ID.
    int? categoryId,

    /// Price in cents.
    @Default(0) int priceCents,

    /// Cost in cents.
    @Default(0) int costCents,

    /// Tax percentage.
    @Default(0) int taxPercent,

    /// Stock quantity.
    @Default(0) int stockQuantity,

    /// Product status.
    @Default(ProductStatus.draft) ProductStatus status,

    /// Selected modifier group IDs.
    @Default([]) List<int> selectedModifierIds,

    /// Free-text kitchen prep-station label (e.g. "Griglia"). Null = this
    /// product's line items stay on the customer receipt only, never
    /// ticketed (docs/features/02-kitchen-ticket-routing.md).
    String? prepStation,
  }) = _ProductFormData;

  const ProductFormData._();

  /// Returns true if the form has minimum required data.
  bool get isValid => name.trim().isNotEmpty && categoryId != null;
}
