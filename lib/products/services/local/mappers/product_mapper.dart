import 'package:agora/core/database/database.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:drift/drift.dart';

/// Extension on [ProductEntity] for converting to domain models.
extension ProductEntityMapper on ProductEntity {
  /// Converts a [ProductEntity] to a [Product] domain model.
  ///
  /// [stockQuantity] is required since stock is stored in a separate table.
  Product toModel({required int stockQuantity}) {
    return Product(
      id: id,
      name: name,
      sku: sku,
      categoryId: categoryId ?? 0,
      priceCents: price,
      costCents: cost,
      stockQuantity: stockQuantity,
    );
  }
}

/// Extension on [Product] for converting to database companions.
extension ProductModelMapper on Product {
  /// Creates a [ProductsTableCompanion] for inserting a new product.
  ProductsTableCompanion toInsertCompanion() {
    return ProductsTableCompanion.insert(
      name: name,
      description: '',
      sku: Value(sku),
      categoryId: Value(categoryId),
      price: Value(priceCents),
      cost: Value(costCents),
    );
  }

  /// Creates a [ProductsTableCompanion] for updating an existing product.
  ProductsTableCompanion toUpdateCompanion() {
    return ProductsTableCompanion(
      name: Value(name),
      sku: Value(sku),
      categoryId: Value(categoryId),
      price: Value(priceCents),
      cost: Value(costCents),
    );
  }
}
