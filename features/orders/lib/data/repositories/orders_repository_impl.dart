import 'package:database/database.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/repositories/orders_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';
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
      final modifierEntities = await _orderItemsDao.getModifiersByOrderItemId(itemEntity.id);
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

  OrdersTableCompanion _modelToInsertCompanion(Order order) {
    return OrdersTableCompanion.insert(
      createdAt: Value(order.createdAt),
      status: Value(order.status.value),
      subtotal: order.subtotalCents,
      discountTotal: Value(order.discountCents),
      taxTotal: Value(order.taxCents),
      grandTotal: order.grandTotalCents,
      note: Value(order.note),
    );
  }

  OrderItemsTableCompanion _itemToInsertCompanion(int orderId, OrderLineItem item) {
    return OrderItemsTableCompanion.insert(
      orderId: orderId,
      productId: Value(item.productId),
      productName: item.productName,
      unitPrice: item.unitPriceCents,
      costPrice: 0, // Cost price not tracked in OrderLineItem model
      quantity: Value(item.quantity),
      discountAmount: Value(0), // Discount applied at order level
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
  Stream<List<Order>> watchOrdersByDateRange({DateTime? startDate, DateTime? endDate}) {
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
  Future<Result<Order?>> getOrderById(int id) => safe('getOrderById($id)', () async {
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
    () => _ordersDao.getOrdersCount(status: status?.value, startDate: startDate, endDate: endDate),
  );

  // ============================================================
  // REPORTING
  // ============================================================

  @override
  Future<Result<int>> getTotalRevenue({required DateTime startDate, required DateTime endDate}) =>
      safe(
        'getTotalRevenue',
        () => _ordersDao.getTotalRevenue(startDate: startDate, endDate: endDate),
      );

  @override
  Future<Result<int>> getTotalDiscounts({required DateTime startDate, required DateTime endDate}) =>
      safe(
        'getTotalDiscounts',
        () => _ordersDao.getTotalDiscounts(startDate: startDate, endDate: endDate),
      );

  // ============================================================
  // WRITE OPERATIONS - Optimistic Update Support
  // ============================================================

  @override
  Future<Result<Order>> createOrder(Order order) => safe('createOrder', () async {
    // Insert order
    final orderId = await _ordersDao.insertOrder(_modelToInsertCompanion(order));

    // Insert items and their modifiers
    for (final item in order.items) {
      final itemId = await _orderItemsDao.insertOrderItem(_itemToInsertCompanion(orderId, item));

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
  Future<Result<Order>> updateOrder(Order order) => safe('updateOrder(${order.id})', () async {
    if (order.id == null) {
      throw Exception('Cannot update an order without an ID');
    }
    await _ordersDao.updateOrder(order.id!, _modelToEntity(order));
    return order;
  });

  @override
  Future<Result<Order>> completeOrder(int id) => safe('completeOrder($id)', () async {
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
