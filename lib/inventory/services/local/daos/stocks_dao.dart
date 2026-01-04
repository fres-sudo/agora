import 'package:agora/core/database/database.dart';
import 'package:agora/inventory/services/local/tables/stocks_table.dart';
import 'package:agora/products/services/local/tables/products_table.dart';
import 'package:drift/drift.dart';

part 'stocks_dao.g.dart';

@DriftAccessor(tables: [StocksTable, ProductsTable])
class StocksDao extends DatabaseAccessor<AgoraDatabase> with _$StocksDaoMixin {
  StocksDao(super.db);

  // ============================================================
  // READ OPERATIONS (Streams for CQRS pattern)
  // ============================================================

  /// Watches all active stock records.
  Stream<List<StockEntity>> watchAllStocks() {
    return (select(stocksTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.productId)]))
        .watch();
  }

  /// Watches paginated stocks for table display.
  Stream<List<StockEntity>> watchPaginatedStocks({
    required int limit,
    required int offset,
  }) {
    return (select(stocksTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.productId)])
          ..limit(limit, offset: offset))
        .watch();
  }

  /// Watches stock for a specific product.
  Stream<StockEntity?> watchStockByProductId(int productId) {
    return (select(stocksTable)
          ..where((t) => t.productId.equals(productId) & t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// Gets stock for a specific product (Future-based).
  Future<StockEntity?> getStockByProductId(int productId) {
    return (select(stocksTable)
          ..where((t) => t.productId.equals(productId) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Gets the total count of stock records.
  Future<int> getStocksCount() async {
    final count = stocksTable.id.count();
    final query = selectOnly(stocksTable)
      ..addColumns([count])
      ..where(stocksTable.deletedAt.isNull());
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Watches stocks with low quantity (below threshold).
  Stream<List<StockEntity>> watchLowStocks(int threshold) {
    return (select(stocksTable)
          ..where(
            (t) =>
                t.deletedAt.isNull() &
                t.quantity.isSmallerOrEqualValue(threshold),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.quantity)]))
        .watch();
  }

  // ============================================================
  // WRITE OPERATIONS
  // ============================================================

  /// Inserts a new stock record and returns the new ID.
  Future<int> insertStock(StocksTableCompanion companion) {
    return into(stocksTable).insert(companion);
  }

  /// Updates stock for a specific product.
  Future<bool> updateStock(int productId, StocksTableCompanion companion) {
    return (update(stocksTable)..where((t) => t.productId.equals(productId)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Creates or updates stock for a product (upsert).
  Future<void> upsertStock({
    required int productId,
    required int quantity,
  }) async {
    final existing = await getStockByProductId(productId);
    if (existing != null) {
      await updateStock(
        productId,
        StocksTableCompanion(quantity: Value(quantity)),
      );
    } else {
      await insertStock(
        StocksTableCompanion.insert(
          productId: productId,
          quantity: Value(quantity),
        ),
      );
    }
  }

  /// Adjusts stock quantity by a delta (positive for increase, negative for decrease).
  Future<bool> adjustStockQuantity({
    required int productId,
    required int delta,
  }) async {
    final existing = await getStockByProductId(productId);
    if (existing == null) {
      // Create new stock record if doesn't exist
      await insertStock(
        StocksTableCompanion.insert(
          productId: productId,
          quantity: Value(delta),
        ),
      );
      return true;
    }

    final newQuantity = existing.quantity + delta;
    return updateStock(
      productId,
      StocksTableCompanion(quantity: Value(newQuantity)),
    );
  }

  // ============================================================
  // DELETE OPERATIONS
  // ============================================================

  /// Soft deletes a stock record.
  Future<bool> softDeleteStock(int productId) {
    return (update(stocksTable)..where((t) => t.productId.equals(productId)))
        .write(StocksTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Restores a soft-deleted stock record.
  Future<bool> restoreStock(int productId) {
    return (update(stocksTable)..where((t) => t.productId.equals(productId)))
        .write(const StocksTableCompanion(deletedAt: Value(null)))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes a stock record.
  Future<int> hardDeleteStock(int productId) {
    return (delete(
      stocksTable,
    )..where((t) => t.productId.equals(productId))).go();
  }
}
