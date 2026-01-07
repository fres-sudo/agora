import 'package:agora/core/database/database.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/models/product/product_status.dart';
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
      description: description.isEmpty ? null : description,
      sku: sku,
      imageUrl: imageUrl,
      categoryId: categoryId ?? 0,
      priceCents: price,
      costCents: cost,
      taxPercent: taxPercent,
      stockQuantity: stockQuantity,
      status: _parseStatus(status),
    );
  }

  ProductStatus _parseStatus(String status) {
    switch (status) {
      case 'active':
        return ProductStatus.active;
      case 'inactive':
        return ProductStatus.inactive;
      case 'draft':
      default:
        return ProductStatus.draft;
    }
  }
}

/// Extension on [Product] for converting to database companions.
extension ProductModelMapper on Product {
  /// Creates a [ProductsTableCompanion] for inserting a new product.
  ProductsTableCompanion toInsertCompanion() {
    return ProductsTableCompanion.insert(
      name: name,
      description: Value(description ?? ''),
      imageUrl: Value(imageUrl),
      sku: Value(sku),
      categoryId: Value(categoryId),
      price: Value(priceCents),
      cost: Value(costCents),
      taxPercent: Value(taxPercent),
      status: Value(_statusToString(status)),
    );
  }

  /// Creates a [ProductsTableCompanion] for updating an existing product.
  ProductsTableCompanion toUpdateCompanion() {
    return ProductsTableCompanion(
      name: Value(name),
      description: Value(description ?? ''),
      imageUrl: Value(imageUrl),
      sku: Value(sku),
      categoryId: Value(categoryId),
      price: Value(priceCents),
      cost: Value(costCents),
      taxPercent: Value(taxPercent),
      status: Value(_statusToString(status)),
    );
  }

  String _statusToString(ProductStatus status) {
    switch (status) {
      case ProductStatus.active:
        return 'active';
      case ProductStatus.inactive:
        return 'inactive';
      case ProductStatus.draft:
        return 'draft';
    }
  }
}
