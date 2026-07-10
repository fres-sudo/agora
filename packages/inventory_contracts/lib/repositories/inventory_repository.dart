import 'package:result/result.dart';

/// A stock record with product ID and quantity.
typedef Stock = ({int productId, int quantity});

/// A product paired with its current stock level (name + quantity + tracking).
/// Used by the inventory management UI, which needs product names alongside
/// quantities without depending on `feature_products`.
typedef StockLevel = ({
  int productId,
  String name,
  int quantity,
  bool trackStock,
});

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

  /// Watches every product joined with its current stock level (name +
  /// quantity + whether it's stock-tracked). Backs the inventory page.
  Stream<List<StockLevel>> watchStockLevels();

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

  // ============================================================
  // PRODUCT LIFECYCLE - Used by `feature_products` (create/update/delete
  // don't represent inventory "movements", so they're kept separate from
  // adjustStock/setStock, which record movement history).
  // ============================================================

  /// Creates or overwrites the stock record for [productId] with an absolute
  /// [quantity], without recording a movement. Used when a product is
  /// created or its stock count is edited directly on the product form.
  Future<Result<void>> initializeStock({
    required int productId,
    required int quantity,
  });

  /// Soft-deletes the stock record for [productId] (mirrors product
  /// soft-delete).
  Future<Result<void>> softDeleteStock(int productId);

  /// Restores a previously soft-deleted stock record for [productId].
  Future<Result<void>> restoreStock(int productId);
}
