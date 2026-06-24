import 'package:database/database.dart';
import 'package:result/result.dart';
import 'package:result/result.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/models/selected_modifiers.dart';
import 'package:drift/drift.dart';
import 'package:talker/talker.dart';

/// Repository interface for order operations.
///
/// All write operations return the affected entity to enable optimistic
/// updates in the UI layer.
abstract interface class OrdersRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all active orders.
  Stream<List<Order>> watchAllOrders();

  /// Watches pending orders only.
  Stream<List<Order>> watchPendingOrders();

  /// Watches completed orders only.
  Stream<List<Order>> watchCompletedOrders();

  /// Watches a single order by ID with its items.
  Stream<Order?> watchOrderById(int id);

  /// Watches orders within a date range.
  Stream<List<Order>> watchOrdersByDateRange({DateTime? startDate, DateTime? endDate});

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets a single order by ID with all its items.
  Future<Result<Order?>> getOrderById(int id);

  /// Gets the total count of orders.
  Future<Result<int>> getOrdersCount({OrderStatus? status, DateTime? startDate, DateTime? endDate});

  // ============================================================
  // REPORTING
  // ============================================================

  /// Gets total revenue for completed orders in a date range.
  Future<Result<int>> getTotalRevenue({required DateTime startDate, required DateTime endDate});

  /// Gets total discounts applied in a date range.
  Future<Result<int>> getTotalDiscounts({required DateTime startDate, required DateTime endDate});

  // ============================================================
  // WRITE OPERATIONS - Returns entity for optimistic updates
  // ============================================================

  /// Creates a new order with all its items.
  /// Returns the created [Order] with its new ID for optimistic updates.
  Future<Result<Order>> createOrder(Order order);

  /// Updates an existing order.
  /// Returns the updated [Order] for optimistic updates.
  Future<Result<Order>> updateOrder(Order order);

  /// Completes an order.
  /// Returns the completed [Order] for optimistic updates.
  Future<Result<Order>> completeOrder(int id);

  /// Voids/refunds an order.
  /// Returns the voided [Order] for optimistic updates.
  Future<Result<Order>> voidOrder(int id);

  /// Deletes an order (soft delete).
  /// Returns the deleted order ID for optimistic updates.
  Future<Result<int>> deleteOrder(int id);

  Stream<List<Order>> watchOrdersByStatus(OrderStatus orderStatus);
}

