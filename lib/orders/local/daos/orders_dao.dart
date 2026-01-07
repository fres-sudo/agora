import 'package:agora/core/database/database.dart';
import 'package:agora/orders/local/tables/oders_table.dart';
import 'package:drift/drift.dart';

part 'orders_dao.g.dart';

@DriftAccessor(tables: [OrdersTable])
class OrdersDao extends DatabaseAccessor<AgoraDatabase> with _$OrdersDaoMixin {
  OrdersDao(super.db);

  // Order status constants
  static const int statusPending = 0;
  static const int statusCompleted = 1;
  static const int statusVoided = 2;

  // ============================================================
  // READ OPERATIONS (Streams for CQRS pattern)
  // ============================================================

  /// Watches all active orders.
  Stream<List<OrderEntity>> watchAllOrders() {
    return (select(ordersTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Watches paginated orders with optional filters.
  Stream<List<OrderEntity>> watchPaginatedOrders({
    required int limit,
    required int offset,
    int? status,
    DateTime? startDate,
    DateTime? endDate,
    String? paymentMethod,
  }) {
    return (select(ordersTable)
          ..where((t) {
            var condition = t.deletedAt.isNull();
            if (status != null) {
              condition = condition & t.status.equals(status);
            }
            if (startDate != null) {
              condition =
                  condition & t.createdAt.isBiggerOrEqualValue(startDate);
            }
            if (endDate != null) {
              condition =
                  condition & t.createdAt.isSmallerOrEqualValue(endDate);
            }
            if (paymentMethod != null) {
              condition = condition & t.paymentMethod.equals(paymentMethod);
            }
            return condition;
          })
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit, offset: offset))
        .watch();
  }

  /// Watches a single order by ID.
  Stream<OrderEntity?> watchOrderById(int id) {
    return (select(ordersTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// Gets a single order by ID (Future-based).
  Future<OrderEntity?> getOrderById(int id) {
    return (select(
      ordersTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Watches orders filtered by status.
  Stream<List<OrderEntity>> watchOrdersByStatus(int status) {
    return (select(ordersTable)
          ..where((t) => t.status.equals(status) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Watches orders within a date range.
  Stream<List<OrderEntity>> watchOrdersByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return (select(ordersTable)
          ..where((t) {
            var condition = t.deletedAt.isNull();
            if (startDate != null) {
              condition =
                  condition & t.createdAt.isBiggerOrEqualValue(startDate);
            }
            if (endDate != null) {
              condition =
                  condition & t.createdAt.isSmallerOrEqualValue(endDate);
            }
            return condition;
          })
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Gets pending orders.
  Stream<List<OrderEntity>> watchPendingOrders() {
    return watchOrdersByStatus(statusPending);
  }

  /// Gets completed orders.
  Stream<List<OrderEntity>> watchCompletedOrders() {
    return watchOrdersByStatus(statusCompleted);
  }

  /// Gets the total count of orders with optional filters.
  Future<int> getOrdersCount({
    int? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final count = ordersTable.id.count();
    final query = selectOnly(ordersTable)..addColumns([count]);

    var condition = ordersTable.deletedAt.isNull();
    if (status != null) {
      condition = condition & ordersTable.status.equals(status);
    }
    if (startDate != null) {
      condition =
          condition & ordersTable.createdAt.isBiggerOrEqualValue(startDate);
    }
    if (endDate != null) {
      condition =
          condition & ordersTable.createdAt.isSmallerOrEqualValue(endDate);
    }
    query.where(condition);

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ============================================================
  // REPORTING HELPER OPERATIONS
  // ============================================================

  /// Gets total revenue for completed orders in a date range.
  Future<int> getTotalRevenue({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final sum = ordersTable.grandTotal.sum();
    final query = selectOnly(ordersTable)
      ..addColumns([sum])
      ..where(
        ordersTable.deletedAt.isNull() &
            ordersTable.status.equals(statusCompleted) &
            ordersTable.createdAt.isBiggerOrEqualValue(startDate) &
            ordersTable.createdAt.isSmallerOrEqualValue(endDate),
      );
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  /// Gets total discounts applied in a date range.
  Future<int> getTotalDiscounts({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final sum = ordersTable.discountTotal.sum();
    final query = selectOnly(ordersTable)
      ..addColumns([sum])
      ..where(
        ordersTable.deletedAt.isNull() &
            ordersTable.status.equals(statusCompleted) &
            ordersTable.createdAt.isBiggerOrEqualValue(startDate) &
            ordersTable.createdAt.isSmallerOrEqualValue(endDate),
      );
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  // ============================================================
  // WRITE OPERATIONS
  // ============================================================

  /// Inserts a new order and returns the new ID.
  Future<int> insertOrder(OrderEntity companion) {
    return into(ordersTable).insert(companion);
  }

  /// Updates an existing order.
  Future<bool> updateOrder(int id, OrderEntity companion) {
    return (update(ordersTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Updates only the order status.
  Future<bool> updateOrderStatus(int id, int status) {
    return (update(ordersTable)..where((t) => t.id.equals(id)))
        .write(
          OrdersTableCompanion(
            status: Value(status),
            updatedAt: Value(DateTime.now()),
          ),
        )
        .then((rows) => rows > 0);
  }

  /// Marks an order as completed.
  Future<bool> completeOrder(int id) {
    return updateOrderStatus(id, statusCompleted);
  }

  /// Marks an order as voided/refunded.
  Future<bool> voidOrder(int id) {
    return updateOrderStatus(id, statusVoided);
  }

  // ============================================================
  // DELETE OPERATIONS
  // ============================================================

  /// Soft deletes an order by setting deletedAt.
  Future<bool> softDeleteOrder(int id) {
    return (update(ordersTable)..where((t) => t.id.equals(id)))
        .write(OrdersTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Restores a soft-deleted order.
  Future<bool> restoreOrder(int id) {
    return (update(ordersTable)..where((t) => t.id.equals(id)))
        .write(const OrdersTableCompanion(deletedAt: Value(null)))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes an order.
  Future<int> hardDeleteOrder(int id) {
    return (delete(ordersTable)..where((t) => t.id.equals(id))).go();
  }
}
