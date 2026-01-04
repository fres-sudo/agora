import 'package:agora/core/database/database.dart';
import 'package:agora/inventory/services/local/tables/stock_movements_table.dart';
import 'package:agora/products/services/local/tables/products_table.dart';
import 'package:drift/drift.dart';

part 'stock_movements_dao.g.dart';

@DriftAccessor(tables: [StockMovementsTable, ProductsTable])
class StockMovementsDao extends DatabaseAccessor<AgoraDatabase>
    with _$StockMovementsDaoMixin {
  StockMovementsDao(super.db);

  // ============================================================
  // READ OPERATIONS (Streams for CQRS pattern)
  // ============================================================

  /// Watches all stock movements.
  Stream<List<StockMovementEntity>> watchAllMovements() {
    return (select(stockMovementsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  /// Watches paginated movements with optional filters.
  Stream<List<StockMovementEntity>> watchPaginatedMovements({
    required int limit,
    required int offset,
    int? productId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return (select(stockMovementsTable)
          ..where((t) {
            var condition = t.deletedAt.isNull();
            if (productId != null) {
              condition = condition & t.productId.equals(productId);
            }
            if (startDate != null) {
              condition =
                  condition & t.timestamp.isBiggerOrEqualValue(startDate);
            }
            if (endDate != null) {
              condition =
                  condition & t.timestamp.isSmallerOrEqualValue(endDate);
            }
            return condition;
          })
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit, offset: offset))
        .watch();
  }

  /// Watches movements for a specific product.
  Stream<List<StockMovementEntity>> watchMovementsByProductId(int productId) {
    return (select(stockMovementsTable)
          ..where((t) => t.productId.equals(productId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  /// Gets movements for a specific product (Future-based).
  Future<List<StockMovementEntity>> getMovementsByProductId(int productId) {
    return (select(stockMovementsTable)
          ..where((t) => t.productId.equals(productId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  /// Gets a single movement by ID.
  Future<StockMovementEntity?> getMovementById(int id) {
    return (select(
      stockMovementsTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Gets the total count of movements with optional filters.
  Future<int> getMovementsCount({
    int? productId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final count = stockMovementsTable.id.count();
    final query = selectOnly(stockMovementsTable)..addColumns([count]);

    var condition = stockMovementsTable.deletedAt.isNull();
    if (productId != null) {
      condition = condition & stockMovementsTable.productId.equals(productId);
    }
    if (startDate != null) {
      condition =
          condition &
          stockMovementsTable.timestamp.isBiggerOrEqualValue(startDate);
    }
    if (endDate != null) {
      condition =
          condition &
          stockMovementsTable.timestamp.isSmallerOrEqualValue(endDate);
    }
    query.where(condition);

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Watches movements within a date range.
  Stream<List<StockMovementEntity>> watchMovementsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return (select(stockMovementsTable)
          ..where(
            (t) =>
                t.deletedAt.isNull() &
                t.timestamp.isBiggerOrEqualValue(startDate) &
                t.timestamp.isSmallerOrEqualValue(endDate),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  // ============================================================
  // WRITE OPERATIONS
  // ============================================================

  /// Inserts a new movement record and returns the new ID.
  Future<int> insertMovement(StockMovementsTableCompanion companion) {
    return into(stockMovementsTable).insert(companion);
  }

  /// Records a stock movement with all required fields.
  Future<int> recordMovement({
    required int productId,
    required int quantityChange,
    required String reason,
    DateTime? timestamp,
  }) {
    return into(stockMovementsTable).insert(
      StockMovementsTableCompanion.insert(
        productId: productId,
        quantityChange: quantityChange,
        reason: reason,
        timestamp: timestamp != null ? Value(timestamp) : const Value.absent(),
      ),
    );
  }

  // ============================================================
  // DELETE OPERATIONS
  // ============================================================

  /// Soft deletes a movement record.
  Future<bool> softDeleteMovement(int id) {
    return (update(stockMovementsTable)..where((t) => t.id.equals(id)))
        .write(StockMovementsTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes a movement record.
  Future<int> hardDeleteMovement(int id) {
    return (delete(stockMovementsTable)..where((t) => t.id.equals(id))).go();
  }

  /// Permanently deletes all movements for a product.
  Future<int> hardDeleteMovementsByProductId(int productId) {
    return (delete(
      stockMovementsTable,
    )..where((t) => t.productId.equals(productId))).go();
  }
}
