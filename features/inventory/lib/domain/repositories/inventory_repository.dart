import 'package:database/database.dart';
import 'package:result/result.dart';
import 'package:result/result.dart';
import 'package:feature_inventory/data/sources/local/daos/stock_movements_dao.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
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

