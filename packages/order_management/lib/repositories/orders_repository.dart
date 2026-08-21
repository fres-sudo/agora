import 'package:order_management/models/order.dart';
import 'package:result/result.dart';

/// Result of a [OrdersRepository.voidOrder] call.
///
/// The completed/pending → voided transition is atomic and idempotent at
/// the data layer: [wasAlreadyVoided] tells the caller whether *this* call
/// performed the transition (`false`) or the order was already voided by
/// an earlier call (`true`). Callers use this to gate one-time side
/// effects — like restoring inventory — so retrying a void can't repeat
/// them.
typedef VoidOrderResult = ({Order order, bool wasAlreadyVoided});

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
  Stream<List<Order>> watchOrdersByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  });

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets a single order by ID with all its items.
  Future<Result<Order?>> getOrderById(int id);

  /// Gets the total count of orders.
  Future<Result<int>> getOrdersCount({
    OrderStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  // ============================================================
  // REPORTING
  // ============================================================

  /// Gets total revenue for completed orders in a date range.
  Future<Result<int>> getTotalRevenue({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Gets total discounts applied in a date range.
  Future<Result<int>> getTotalDiscounts({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Sum of completed cash-order revenue for one employee's shift, from
  /// [startDate] (shift clock-in) up to [endDate] (clock-out), or open-ended
  /// if the shift hasn't closed yet. Backs
  /// `WorkforceRepository.expectedCashCentsForShift`
  /// (docs/features/04-volunteer-shift-accountability.md).
  Future<Result<int>> getCashRevenueForEmployeeShift({
    required int employeeId,
    required DateTime startDate,
    DateTime? endDate,
  });

  // ============================================================
  // WRITE OPERATIONS - Returns entity for optimistic updates
  // ============================================================

  /// Creates a new order with all its items.
  /// Returns the created [Order] with its new ID for optimistic updates.
  Future<Result<Order>> createOrder(Order order);

  /// Persists a card attempt locally without publishing it to the LAN.
  /// Fulfillment must wait for [completePaymentAttempt].
  Future<Result<Order>> createPaymentAttempt(Order order);

  /// Marks a staged, approved payment completed and publishes the order.
  Future<Result<Order>> completePaymentAttempt(Order order);

  /// Retains the terminal outcome for audit, then hides the abandoned attempt.
  Future<Result<Order>> abandonPaymentAttempt(Order order);

  /// Updates an existing order.
  /// Returns the updated [Order] for optimistic updates.
  Future<Result<Order>> updateOrder(Order order);

  /// Completes an order.
  /// Returns the completed [Order] for optimistic updates.
  Future<Result<Order>> completeOrder(int id);

  /// Voids/refunds an order.
  ///
  /// Atomically transitions the order to voided — a no-op if it is already
  /// voided. See [VoidOrderResult.wasAlreadyVoided].
  Future<Result<VoidOrderResult>> voidOrder(int id);

  /// Deletes an order (soft delete).
  /// Returns the deleted order ID for optimistic updates.
  Future<Result<int>> deleteOrder(int id);

  Stream<List<Order>> watchOrdersByStatus(OrderStatus orderStatus);
}
