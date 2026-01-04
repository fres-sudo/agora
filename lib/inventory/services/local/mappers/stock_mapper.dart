import 'package:agora/core/database/database.dart';
import 'package:drift/drift.dart';

/// Extension on [StockEntity] for converting to useful types.
extension StockEntityMapper on StockEntity {
  /// Creates a record containing productId and quantity.
  ({int productId, int quantity}) toRecord() {
    return (productId: productId, quantity: quantity);
  }
}

/// Extension for creating Stock companions from simple values.
extension StockCompanionFactory on int {
  /// Creates a [StocksTableCompanion] for inserting stock for this product ID.
  StocksTableCompanion toStockInsertCompanion({required int quantity}) {
    return StocksTableCompanion.insert(
      productId: this,
      quantity: Value(quantity),
    );
  }

  /// Creates a [StocksTableCompanion] for updating stock quantity.
  StocksTableCompanion toStockUpdateCompanion({required int quantity}) {
    return StocksTableCompanion(
      quantity: Value(quantity),
    );
  }
}
