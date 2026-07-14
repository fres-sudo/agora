import 'package:database/database.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:order_management/models/order.dart';
import 'package:order_management/models/order_line_item.dart';
import 'package:order_management/models/order_type.dart';
import 'package:order_management/models/selected_modifiers.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:result/result.dart';
import 'package:sync_engine/sync_engine.dart';

class OrdersRepositoryImpl extends SyncableRepository
    implements OrdersRepository {
  OrdersRepositoryImpl({
    required OrdersDao ordersDao,
    required OrderItemsDao orderItemsDao,
    required this.deviceId,
    required super.syncManager,
    super.logger,
  }) : _ordersDao = ordersDao,
       _orderItemsDao = orderItemsDao;

  final OrdersDao _ordersDao;
  final OrderItemsDao _orderItemsDao;
  final DeviceId deviceId;

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
          id: itemEntity.id,
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
          prepStation: itemEntity.prepStation,
        ),
      );
    }

    return Order(
      id: entity.id,
      createdAt: entity.createdAt,
      status: OrderStatus.values.firstWhere((s) => s.value == entity.status),
      orderType: OrderType.fromValue(entity.orderType),
      items: items,
      note: entity.note,
      paymentMethod: entity.paymentMethod,
      subtotalCents: entity.subtotal,
      taxCents: entity.taxTotal,
      discountCents: entity.discountTotal,
      grandTotalCents: entity.grandTotal,
      syncId: entity.syncId,
    );
  }

  OrderEntity _modelToEntity(Order order) {
    return OrderEntity(
      id: order.id ?? 0,
      createdAt: order.createdAt,
      status: order.status.value,
      orderType: order.orderType.value,
      subtotal: order.subtotalCents,
      taxTotal: order.taxCents,
      discountTotal: order.discountCents,
      grandTotal: order.grandTotalCents,
      note: order.note,
      paymentMethod: order.paymentMethod,
      updatedAt: DateTime.now(),
      deletedAt: null,
      syncId: order.syncId,
    );
  }

  OrdersTableCompanion _modelToInsertCompanion(Order order) {
    return OrdersTableCompanion.insert(
      createdAt: Value(order.createdAt),
      status: Value(order.status.value),
      orderType: Value(order.orderType.value),
      subtotal: order.subtotalCents,
      discountTotal: Value(order.discountCents),
      taxTotal: Value(order.taxCents),
      grandTotal: order.grandTotalCents,
      note: Value(order.note),
      paymentMethod: Value(order.paymentMethod),
      syncId: Value(order.syncId),
    );
  }

  Map<String, dynamic> _orderCreatedPayload(Order order, String syncId) => {
    'syncId': syncId,
    'originDeviceId': deviceId.value,
    'createdAt': order.createdAt.toIso8601String(),
    'status': order.status.value,
    'orderType': order.orderType.value,
    'subtotalCents': order.subtotalCents,
    'taxCents': order.taxCents,
    'discountCents': order.discountCents,
    'grandTotalCents': order.grandTotalCents,
    'paymentMethod': order.paymentMethod,
    'note': order.note,
    'items': order.items
        .map(
          (item) => {
            'productId': item.productId,
            'productName': item.productName,
            'quantity': item.quantity,
            'unitPriceCents': item.unitPriceCents,
            'prepStation': item.prepStation,
            'modifiers': item.selectedModifiers
                .map(
                  (m) => {
                    'groupName': m.groupName,
                    'optionName': m.optionName,
                    'priceChangeCents': m.priceChangeCents,
                  },
                )
                .toList(),
          },
        )
        .toList(),
  };

  OrderItemsTableCompanion _itemToInsertCompanion(
    int orderId,
    OrderLineItem item,
  ) {
    return OrderItemsTableCompanion.insert(
      orderId: orderId,
      productId: Value(item.productId),
      productName: item.productName,
      unitPrice: item.unitPriceCents,
      costPrice: 0, // Cost price not tracked in OrderLineItem model
      quantity: Value(item.quantity),
      discountAmount: Value(0), // Discount applied at order level
      prepStation: Value(item.prepStation),
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
  Future<Result<Order>> createOrder(Order order) {
    final syncId = order.syncId ?? generateSyncId();
    final orderWithSyncId = order.copyWith(syncId: syncId);

    return safeSync<Order>(
      operation: 'createOrder',
      entityType: 'order',
      outboxOperation: OutboxOperation.create,
      entityLocalId: syncId,
      payload: _orderCreatedPayload(orderWithSyncId, syncId),
      localWrite: () async {
        // Wrap the whole multi-table insert sequence (order header + line
        // items + modifiers) in a single transaction so a failure partway
        // through (crash, thrown exception, etc.) rolls back cleanly instead
        // of leaving a half-written order in the local DB. `_ordersDao` and
        // `_orderItemsDao` are both DatabaseAccessors attached to the same
        // AgoraDatabase instance, so starting the transaction on either DAO
        // covers writes made through both (Drift propagates the active
        // transaction via zone-local state to any accessor sharing the same
        // attached database).
        return _ordersDao.transaction(() async {
          // Insert order
          final orderId = await _ordersDao.insertOrder(
            _modelToInsertCompanion(orderWithSyncId),
          );

          // Insert items and their modifiers
          for (final item in order.items) {
            final itemId = await _orderItemsDao.insertOrderItem(
              _itemToInsertCompanion(orderId, item),
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
          return orderWithSyncId.copyWith(id: orderId);
        });
      },
    );
  }

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
  Future<Result<VoidOrderResult>> voidOrder(int id) async {
    Future<VoidOrderResult> localWrite() async {
      final transitioned = await _ordersDao.voidOrder(id);
      final order = await getOrderById(id);
      return (order: order.unwrap()!, wasAlreadyVoided: !transitioned);
    }

    // A legacy order created before this station ever synced has no
    // syncId — never attempt to sync its void either (nothing to
    // reconcile against on other stations, since they never saw it
    // created).
    final existing = await _ordersDao.getOrderById(id);
    final syncId = existing?.syncId;
    if (syncId == null) {
      return safe('voidOrder($id)', localWrite);
    }

    return safeSync<VoidOrderResult>(
      operation: 'voidOrder($id)',
      entityType: 'order',
      outboxOperation: OutboxOperation.update,
      entityLocalId: syncId,
      payload: {'syncId': syncId, 'originDeviceId': deviceId.value},
      localWrite: localWrite,
    );
  }

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
