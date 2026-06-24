import 'package:database/database.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:feature_inventory/data/sources/local/daos/stock_movements_dao.dart';
import 'package:feature_inventory/domain/repositories/inventory_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

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
