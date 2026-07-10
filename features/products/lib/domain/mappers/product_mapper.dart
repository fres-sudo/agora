import 'package:database/database.dart';
import 'package:catalog/models/modifier_group.dart';
import 'package:catalog/models/product.dart';
import 'package:catalog/models/product_status.dart';

/// Extension on [ProductEntity] for converting to domain models.
extension ProductEntityMapper on ProductEntity {
  /// Converts a [ProductEntity] to a [Product] domain model.
  ///
  /// [stockQuantity] is required since stock is stored in a separate table.
  /// [modifierGroups] is optional since modifier links are stored in a
  /// separate join table (`ProductModifierLinksTable`) — callers that don't
  /// need modifier data can omit it and get an empty list.
  Product toModel({
    required int stockQuantity,
    List<ModifierGroup> modifierGroups = const [],
  }) {
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
      trackStock: trackStock,
      status: _parseStatus(status),
      modifierGroups: modifierGroups,
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
      trackStock: Value(trackStock),
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
      trackStock: Value(trackStock),
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
