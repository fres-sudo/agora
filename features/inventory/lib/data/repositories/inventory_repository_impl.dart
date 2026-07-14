import 'package:database/database.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:feature_inventory/data/sources/local/daos/stock_movements_dao.dart';
import 'package:inventory_contracts/repositories/inventory_repository.dart';
import 'package:result/result.dart';
import 'package:sync_engine/sync_engine.dart';

class InventoryRepositoryImpl extends SyncableRepository
    implements InventoryRepository {
  InventoryRepositoryImpl({
    required StocksDao stocksDao,
    required StockMovementsDao stockMovementsDao,
    required this.deviceId,
    required super.syncManager,
    super.logger,
  }) : _stocksDao = stocksDao,
       _stockMovementsDao = stockMovementsDao;

  final StocksDao _stocksDao;
  final StockMovementsDao _stockMovementsDao;
  final DeviceId deviceId;

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
  Stream<List<StockLevel>> watchStockLevels() {
    return _stocksDao
        .watchStockLevels()
        .map(
          (rows) => rows
              .map<StockLevel>(
                (r) => (
                  productId: r.productId,
                  name: r.name,
                  quantity: r.quantity,
                  trackStock: r.trackStock,
                ),
              )
              .toList(),
        )
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
  }) {
    final syncId = generateSyncId();

    return safeSync<Stock>(
      operation: 'adjustStock($productId, delta: $delta)',
      entityType: 'stock_movement',
      outboxOperation: OutboxOperation.create,
      entityLocalId: syncId,
      payload: {
        'syncId': syncId,
        'originDeviceId': deviceId.value,
        'productId': productId,
        'delta': delta,
        'reason': reason,
      },
      localWrite: () async {
        // Run the quantity adjustment and the movement record in a single
        // Drift transaction, using an atomic SQL UPDATE (quantity = quantity
        // + delta) rather than a Dart-side read-then-write. This prevents
        // lost updates when two writers (e.g. two POS terminals, or a
        // checkout racing a manual adjustment) touch the same product
        // concurrently.
        final newQty = await _stocksDao.transaction(() async {
          final qty = await _stocksDao.adjustStockQuantityAtomic(
            productId: productId,
            delta: delta,
          );

          await _stockMovementsDao.recordMovement(
            productId: productId,
            quantityChange: delta,
            reason: reason,
            syncId: syncId,
          );

          return qty;
        });

        // Return the new stock for optimistic updates
        return (productId: productId, quantity: newQty);
      },
    );
  }

  // `setStock` is an ABSOLUTE write (sets stock to a target quantity), not
  // a delta — per docs/features/01-lan-sync.md's conflict model, only
  // delta-based writes (`adjustStock` above) are safe to sync, since two
  // stations concurrently applying two different absolute corrections
  // would silently clobber one another. This stays on plain `safe(...)`
  // deliberately — do not convert it to `safeSync` in a future refactor.
  @override
  Future<Result<Stock>> setStock({
    required int productId,
    required int quantity,
    required String reason,
  }) => safe('setStock($productId, qty: $quantity)', () async {
    // Read the current quantity, write the new absolute quantity and
    // record the movement all inside one transaction, so no other writer
    // can adjust the stock between the read and the write.
    await _stocksDao.transaction(() async {
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
    });

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

  // ============================================================
  // PRODUCT LIFECYCLE
  // ============================================================

  // Absolute write, product-create-time only, deliberately not synced —
  // same reasoning as `setStock` above.
  @override
  Future<Result<void>> initializeStock({
    required int productId,
    required int quantity,
  }) => safe(
    'initializeStock($productId, qty: $quantity)',
    () => _stocksDao.upsertStock(productId: productId, quantity: quantity),
  );

  @override
  Future<Result<void>> softDeleteStock(int productId) => safe(
    'softDeleteStock($productId)',
    () => _stocksDao.softDeleteStock(productId),
  );

  @override
  Future<Result<void>> restoreStock(int productId) => safe(
    'restoreStock($productId)',
    () => _stocksDao.restoreStock(productId),
  );
}
