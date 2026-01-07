import 'package:agora/core/database/database.dart';
import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/inventory/services/local/daos/stock_movements_dao.dart';
import 'package:agora/inventory/services/local/daos/stocks_dao.dart';
import 'package:talker/talker.dart';

/// A stock record with product ID and quantity.
typedef Stock = ({int productId, int quantity});

/// A stock movement record.
typedef StockMovement = ({
  int id,
  int productId,
  int quantityChange,
  String reason,
  DateTime timestamp,
});

/// Repository interface for inventory/stock operations.
///
/// All write operations return the affected entity to enable optimistic
/// updates in the UI layer.
abstract interface class InventoryRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all stock records.
  Stream<List<Stock>> watchAllStocks();

  /// Watches stock for a specific product.
  Stream<Stock?> watchStockByProductId(int productId);

  /// Watches stocks with low quantity (below threshold).
  Stream<List<Stock>> watchLowStocks(int threshold);

  /// Watches stock movements for a specific product.
  Stream<List<StockMovement>> watchMovementsByProductId(int productId);

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets the current stock quantity for a product.
  Future<Result<int>> getStockQuantity(int productId);

  /// Gets the full stock record for a product.
  Future<Result<Stock?>> getStockByProductId(int productId);

  /// Gets the total count of stock records.
  Future<Result<int>> getStocksCount();

  /// Gets movement history with optional filters.
  Future<Result<List<StockMovement>>> getMovementHistory({
    int? productId,
    DateTime? startDate,
    DateTime? endDate,
  });

  // ============================================================
  // WRITE OPERATIONS - Returns entity for optimistic updates
  // ============================================================

  /// Adjusts stock quantity by a delta (positive or negative).
  /// Records a movement and returns the new [Stock] for optimistic updates.
  Future<Result<Stock>> adjustStock({
    required int productId,
    required int delta,
    required String reason,
  });

  /// Sets stock to an absolute quantity.
  /// Records a movement and returns the new [Stock] for optimistic updates.
  Future<Result<Stock>> setStock({
    required int productId,
    required int quantity,
    required String reason,
  });

  /// Decrements stock when an order is placed.
  /// Returns the updated [Stock] for optimistic updates.
  Future<Result<Stock>> decrementForOrder({
    required int productId,
    required int quantity,
    required int orderId,
  });

  /// Restores stock when an order is voided.
  /// Returns the updated [Stock] for optimistic updates.
  Future<Result<Stock>> restoreForVoidedOrder({
    required int productId,
    required int quantity,
    required int orderId,
  });
}

/// Implementation of [InventoryRepository] using Drift DAOs.
class InventoryRepositoryImpl extends Repository
    implements InventoryRepository {
  InventoryRepositoryImpl({
    required StocksDao stocksDao,
    required StockMovementsDao stockMovementsDao,
    Talker? logger,
  }) : _stocksDao = stocksDao,
       _stockMovementsDao = stockMovementsDao,
       super(logger);

  final StocksDao _stocksDao;
  final StockMovementsDao _stockMovementsDao;

  // ============================================================
  // HELPERS
  // ============================================================

  Stock _entityToStock(StockEntity entity) {
    return (productId: entity.productId, quantity: entity.quantity);
  }

  StockMovement _entityToMovement(StockMovementEntity entity) {
    return (
      id: entity.id,
      productId: entity.productId,
      quantityChange: entity.quantityChange,
      reason: entity.reason,
      timestamp: entity.timestamp,
    );
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<Stock>> watchAllStocks() {
    return _stocksDao
        .watchAllStocks()
        .map((entities) => entities.map(_entityToStock).toList())
        .safeCode(logger);
  }

  @override
  Stream<Stock?> watchStockByProductId(int productId) {
    return _stocksDao
        .watchStockByProductId(productId)
        .map((entity) => entity != null ? _entityToStock(entity) : null)
        .safeCode(logger);
  }

  @override
  Stream<List<Stock>> watchLowStocks(int threshold) {
    return _stocksDao
        .watchLowStocks(threshold)
        .map((entities) => entities.map(_entityToStock).toList())
        .safeCode(logger);
  }

  @override
  Stream<List<StockMovement>> watchMovementsByProductId(int productId) {
    return _stockMovementsDao
        .watchMovementsByProductId(productId)
        .map((entities) => entities.map(_entityToMovement).toList())
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<int>> getStockQuantity(int productId) =>
      safe('getStockQuantity($productId)', () async {
        final entity = await _stocksDao.getStockByProductId(productId);
        return entity?.quantity ?? 0;
      });

  @override
  Future<Result<Stock?>> getStockByProductId(int productId) =>
      safe('getStockByProductId($productId)', () async {
        final entity = await _stocksDao.getStockByProductId(productId);
        return entity != null ? _entityToStock(entity) : null;
      });

  @override
  Future<Result<int>> getStocksCount() =>
      safe('getStocksCount', () => _stocksDao.getStocksCount());

  @override
  Future<Result<List<StockMovement>>> getMovementHistory({
    int? productId,
    DateTime? startDate,
    DateTime? endDate,
  }) => safe('getMovementHistory', () async {
    if (productId != null) {
      final entities = await _stockMovementsDao.getMovementsByProductId(
        productId,
      );
      return entities.map(_entityToMovement).toList();
    }
    // For all products, we would need a custom query in the DAO
    // containing getAllMovements with optional date filters.
    // For now, return empty list when no productId filter is provided.
    return const [];
  });

  // ============================================================
  // WRITE OPERATIONS - Optimistic Update Support
  // ============================================================

  @override
  Future<Result<Stock>> adjustStock({
    required int productId,
    required int delta,
    required String reason,
  }) => safe('adjustStock($productId, delta: $delta)', () async {
    // Get current stock
    final current = await _stocksDao.getStockByProductId(productId);
    final currentQty = current?.quantity ?? 0;
    final newQty = currentQty + delta;

    // Update or insert stock
    await _stocksDao.upsertStock(productId: productId, quantity: newQty);

    // Record movement
    await _stockMovementsDao.recordMovement(
      productId: productId,
      quantityChange: delta,
      reason: reason,
    );

    // Return the new stock for optimistic updates
    return (productId: productId, quantity: newQty);
  });

  @override
  Future<Result<Stock>> setStock({
    required int productId,
    required int quantity,
    required String reason,
  }) => safe('setStock($productId, qty: $quantity)', () async {
    // Get current stock to calculate delta
    final current = await _stocksDao.getStockByProductId(productId);
    final currentQty = current?.quantity ?? 0;
    final delta = quantity - currentQty;

    // Set absolute quantity
    await _stocksDao.upsertStock(productId: productId, quantity: quantity);

    // Record movement with the delta
    if (delta != 0) {
      await _stockMovementsDao.recordMovement(
        productId: productId,
        quantityChange: delta,
        reason: reason,
      );
    }

    return (productId: productId, quantity: quantity);
  });

  @override
  Future<Result<Stock>> decrementForOrder({
    required int productId,
    required int quantity,
    required int orderId,
  }) => adjustStock(
    productId: productId,
    delta: -quantity,
    reason: 'Order #$orderId',
  );

  @override
  Future<Result<Stock>> restoreForVoidedOrder({
    required int productId,
    required int quantity,
    required int orderId,
  }) => adjustStock(
    productId: productId,
    delta: quantity,
    reason: 'Voided Order #$orderId',
  );
}
