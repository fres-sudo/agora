import 'package:agora/products/models/modifier_group/modifier_group.dart';
import 'package:agora/products/models/product/product_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    String? description,
    String? sku,
    String? imageUrl,
    required int categoryId,
    required int priceCents, // Keep as int for math
    required int costCents,
    @Default(0) int taxPercent, // Tax as percentage (e.g., 10 = 10%)
    required int stockQuantity, // Merged from Stock table
    @Default(ProductStatus.draft) ProductStatus status,
    @Default([]) List<ModifierGroup> modifierGroups,
  }) = _Product;

  const Product._();

  /// Returns the formatted price as a currency string.
  String get formattedPrice => '\$${(priceCents / 100.0).toStringAsFixed(2)}';
}
