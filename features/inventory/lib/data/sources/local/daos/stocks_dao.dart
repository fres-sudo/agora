import 'package:database/database.dart';
import 'package:drift/drift.dart';

part 'stocks_dao.g.dart';

/// A product paired with its current stock level, produced by
/// [StocksDao.watchStockLevels] (products ⋈ stocks).
typedef StockLevelRow = ({
  int productId,
  String name,
  int quantity,
  bool trackStock,
});

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

  /// Watches every product joined with its current stock level.
  ///
  /// Left-joins so products without a stock row still appear (quantity 0).
  /// Reads the shared `ProductsTable` directly (already declared on this
  /// accessor) so the inventory feature never depends on `feature_products`.
  Stream<List<StockLevelRow>> watchStockLevels() {
    final query =
        select(productsTable).join([
            leftOuterJoin(
              stocksTable,
              stocksTable.productId.equalsExp(productsTable.id) &
                  stocksTable.deletedAt.isNull(),
            ),
          ])
          ..where(productsTable.deletedAt.isNull())
          ..orderBy([OrderingTerm.asc(productsTable.name)]);

    return query.watch().map(
      (rows) => rows.map((row) {
        final product = row.readTable(productsTable);
        final stock = row.readTableOrNull(stocksTable);
        return (
          productId: product.id,
          name: product.name,
          quantity: stock?.quantity ?? 0,
          trackStock: product.trackStock,
        );
      }).toList(),
    );
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

  /// Atomically adjusts stock quantity by [delta] using a single SQL
  /// `UPDATE ... SET quantity = quantity + ?` expression instead of a
  /// Dart-side read-then-write. This avoids the lost-update race where two
  /// concurrent adjustments to the same product (e.g. two POS terminals
  /// selling the last few units) both read the same starting quantity and
  /// the second write silently clobbers the first.
  ///
  /// Callers should invoke this inside a [transaction] together with any
  /// related writes (e.g. recording a stock movement) so the whole
  /// operation is atomic.
  ///
  /// If no active stock row exists yet for [productId], one is created with
  /// [delta] as its initial quantity. Returns the resulting quantity.
  Future<int> adjustStockQuantityAtomic({
    required int productId,
    required int delta,
  }) async {
    final rowsAffected =
        await (update(stocksTable)..where(
              (t) => t.productId.equals(productId) & t.deletedAt.isNull(),
            ))
            .write(
              StocksTableCompanion.custom(
                quantity: stocksTable.quantity + Variable(delta),
                updatedAt: Constant(DateTime.now()),
              ),
            );

    if (rowsAffected > 0) {
      final updated = await getStockByProductId(productId);
      return updated?.quantity ?? delta;
    }

    // No active stock row yet for this product — create one with the
    // delta as its initial quantity.
    await insertStock(
      StocksTableCompanion.insert(productId: productId, quantity: Value(delta)),
    );
    return delta;
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
