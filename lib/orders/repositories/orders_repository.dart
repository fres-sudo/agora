import 'package:agora/core/database/database.dart';
import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/orders/local/daos/order_items_dao.dart';
import 'package:agora/orders/local/daos/orders_dao.dart';
import 'package:agora/orders/models/order/order.dart';
import 'package:agora/orders/models/order_line_item/order_line_item.dart';
import 'package:agora/orders/models/selected_modifiers/selected_modifiers.dart';
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

/// Implementation of [OrdersRepository] using Drift DAOs.
class OrdersRepositoryImpl extends Repository implements OrdersRepository {
  OrdersRepositoryImpl({
    required OrdersDao ordersDao,
    required OrderItemsDao orderItemsDao,
    Talker? logger,
  }) : _ordersDao = ordersDao,
       _orderItemsDao = orderItemsDao,
       super(logger);

  final OrdersDao _ordersDao;
  final OrderItemsDao _orderItemsDao;

  // ============================================================
  // HELPERS - Entity to Model conversion
  // ============================================================

  Future<Order> _entityToModel(OrderEntity entity) async {
    final itemEntities = await _orderItemsDao.getItemsByOrderId(entity.id);
    final items = <OrderLineItem>[];

    for (final itemEntity in itemEntities) {
      final modifierEntities = await _orderItemsDao.getModifiersByOrderItemId(
        itemEntity.id,
      );
      items.add(
        OrderLineItem(
          productId: itemEntity.productId,
          productName: itemEntity.productName,
          quantity: itemEntity.quantity,
          unitPriceCents: itemEntity.unitPrice,
          selectedModifiers: modifierEntities
              .map(
                (m) => SelectedModifiers(
                  groupName: m.modifierName,
                  optionName: m.optionName,
                  priceChangeCents: m.priceChange,
                ),
              )
              .toList(),
        ),
      );
    }

    return Order(
      id: entity.id,
      createdAt: entity.createdAt,
      status: OrderStatus.values.firstWhere((s) => s.value == entity.status),
      items: items,
      note: entity.note,
      subtotalCents: entity.subtotal,
      taxCents: entity.taxTotal,
      discountCents: entity.discountTotal,
      grandTotalCents: entity.grandTotal,
    );
  }

  OrderEntity _modelToEntity(Order order) {
    return OrderEntity(
      id: order.id ?? 0,
      createdAt: order.createdAt,
      status: order.status.value,
      subtotal: order.subtotalCents,
      taxTotal: order.taxCents,
      discountTotal: order.discountCents,
      grandTotal: order.grandTotalCents,
      note: order.note,
      paymentMethod: null,
      updatedAt: DateTime.now(),
      deletedAt: null,
    );
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<Order>> watchAllOrders() {
    return _ordersDao
        .watchAllOrders()
        .asyncMap((entities) async {
          final orders = <Order>[];
          for (final entity in entities) {
            orders.add(await _entityToModel(entity));
          }
          return orders;
        })
        .safeCode(logger);
  }

  @override
  Stream<List<Order>> watchPendingOrders() {
    return _ordersDao
        .watchPendingOrders()
        .asyncMap((entities) async {
          final orders = <Order>[];
          for (final entity in entities) {
            orders.add(await _entityToModel(entity));
          }
          return orders;
        })
        .safeCode(logger);
  }

  @override
  Stream<List<Order>> watchCompletedOrders() {
    return _ordersDao
        .watchCompletedOrders()
        .asyncMap((entities) async {
          final orders = <Order>[];
          for (final entity in entities) {
            orders.add(await _entityToModel(entity));
          }
          return orders;
        })
        .safeCode(logger);
  }

  @override
  Stream<Order?> watchOrderById(int id) {
    return _ordersDao
        .watchOrderById(id)
        .asyncMap((entity) async {
          if (entity == null) return null;
          return _entityToModel(entity);
        })
        .safeCode(logger);
  }

  @override
  Stream<List<Order>> watchOrdersByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _ordersDao
        .watchOrdersByDateRange(startDate: startDate, endDate: endDate)
        .asyncMap((entities) async {
          final orders = <Order>[];
          for (final entity in entities) {
            orders.add(await _entityToModel(entity));
          }
          return orders;
        })
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<Order?>> getOrderById(int id) =>
      safe('getOrderById($id)', () async {
        final entity = await _ordersDao.getOrderById(id);
        if (entity == null) return null;
        return _entityToModel(entity);
      });

  @override
  Future<Result<int>> getOrdersCount({
    OrderStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) => safe(
    'getOrdersCount',
    () => _ordersDao.getOrdersCount(
      status: status?.value,
      startDate: startDate,
      endDate: endDate,
    ),
  );

  // ============================================================
  // REPORTING
  // ============================================================

  @override
  Future<Result<int>> getTotalRevenue({
    required DateTime startDate,
    required DateTime endDate,
  }) => safe(
    'getTotalRevenue',
    () => _ordersDao.getTotalRevenue(startDate: startDate, endDate: endDate),
  );

  @override
  Future<Result<int>> getTotalDiscounts({
    required DateTime startDate,
    required DateTime endDate,
  }) => safe(
    'getTotalDiscounts',
    () => _ordersDao.getTotalDiscounts(startDate: startDate, endDate: endDate),
  );

  // ============================================================
  // WRITE OPERATIONS - Optimistic Update Support
  // ============================================================

  @override
  Future<Result<Order>> createOrder(Order order) =>
      safe('createOrder', () async {
        // Insert order
        final orderId = await _ordersDao.insertOrder(_modelToEntity(order));

        // Insert items and their modifiers
        for (final item in order.items) {
          final itemId = await _orderItemsDao.insertOrderItem(
            OrderItemEntity(
              id: 0,
              orderId: orderId,
              productId: item.productId,
              productName: item.productName,
              quantity: item.quantity,
              unitPrice: item.unitPriceCents,
              costPrice: 0, // Cost price not tracked in OrderLineItem model
              discountAmount: 0, // Discount applied at order level
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              deletedAt: null,
            ),
          );

          // Insert modifiers for this item
          for (final modifier in item.selectedModifiers) {
            await _orderItemsDao.addModifierToOrderItem(
              orderItemId: itemId,
              modifierName: modifier.groupName,
              optionName: modifier.optionName,
              priceChange: modifier.priceChangeCents,
            );
          }
        }

        // Return the created order with its new ID
        return order.copyWith(id: orderId);
      });

  @override
  Future<Result<Order>> updateOrder(Order order) =>
      safe('updateOrder(${order.id})', () async {
        if (order.id == null) {
          throw Exception('Cannot update an order without an ID');
        }
        await _ordersDao.updateOrder(order.id!, _modelToEntity(order));
        return order;
      });

  @override
  Future<Result<Order>> completeOrder(int id) =>
      safe('completeOrder($id)', () async {
        await _ordersDao.completeOrder(id);
        final order = await getOrderById(id);
        return order.unwrap()!;
      });

  @override
  Future<Result<Order>> voidOrder(int id) => safe('voidOrder($id)', () async {
    await _ordersDao.voidOrder(id);
    final order = await getOrderById(id);
    return order.unwrap()!;
  });

  @override
  Future<Result<int>> deleteOrder(int id) => safe('deleteOrder($id)', () async {
    await _ordersDao.softDeleteOrder(id);
    return id;
  });

  @override
  Stream<List<Order>> watchOrdersByStatus(OrderStatus orderStatus) {
    return _ordersDao
        .watchOrdersByStatus(orderStatus.value)
        .asyncMap((entities) async {
          final orders = <Order>[];
          for (final entity in entities) {
            orders.add(await _entityToModel(entity));
          }
          return orders;
        })
        .safeCode(logger);
  }
}
