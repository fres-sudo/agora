import 'package:catalog/models/modifier_group.dart';
import 'package:catalog/models/product_status.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'product.freezed.dart';
part 'product.g.dart';

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
    @Default(true) bool trackStock, // Whether sales decrement stock
    @Default(ProductStatus.draft) ProductStatus status,
    @Default([]) List<ModifierGroup> modifierGroups,
    // Free-text kitchen prep-station label (e.g. "Griglia"). Null = this
    // product's line items stay on the customer receipt only, never
    // ticketed (docs/features/02-kitchen-ticket-routing.md).
    String? prepStation,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  const Product._();
}
