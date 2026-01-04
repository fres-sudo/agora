import 'package:agora/products/models/modifier_group/modifier_group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    String? sku,
    required int categoryId,
    required int priceCents, // Keep as int for math
    required int costCents,
    required int stockQuantity, // Merged from Stock table
    @Default([]) List<ModifierGroup> modifierGroups,
  }) = _Product;

  const Product._();
}
