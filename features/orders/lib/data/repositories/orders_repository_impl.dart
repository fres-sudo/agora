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

/// Synthetic per-line grouping token used only in the outbound/inbound sync
/// wire payload (never persisted as-is) to tie a combo cart line's fanned-out
/// JSON item entries back together — two different stations assign
/// different local DB ids to "the same" combo line, so the wire format
/// can't reuse the local `comboLineId` integer scheme.
String _comboWireGroup(String syncId, int lineIndex) => '$syncId#$lineIndex';

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
          comboId: itemEntity.comboId,
          comboName: itemEntity.comboName,
          comboLineId: itemEntity.comboLineId,
          comboSaleQuantity: itemEntity.comboSaleQuantity,
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
      employeeId: entity.employeeId,
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
      employeeId: Value(order.employeeId),
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
      employeeId: Value(order.employeeId),
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
    'items': [
      for (final entry in order.items.asMap().entries)
        ..._itemPayloads(entry.value, syncId, entry.key),
    ],
  };

  Map<String, dynamic> _plainItemPayload(OrderLineItem item) => {
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
    'comboId': null,
    'comboName': null,
    'comboWireGroup': null,
    'comboSaleQuantity': null,
  };

  /// One cart-level [OrderLineItem] becomes one JSON entry for a plain
  /// product line, or N entries (one per constituent) for a combo line —
  /// mirroring the local fan-out in [_insertComboLine], so a peer station
  /// receives the already-split rows directly and doesn't need to resolve
  /// the combo definition itself.
  List<Map<String, dynamic>> _itemPayloads(
    OrderLineItem item,
    String syncId,
    int lineIndex,
  ) {
    if (item.comboId == null || item.comboComponents.isEmpty) {
      return [_plainItemPayload(item)];
    }

    final wireGroup = _comboWireGroup(syncId, lineIndex);
    final components = item.comboComponents;
    final lead = components.first;
    final payloads = <Map<String, dynamic>>[
      {
        'productId': lead.productId,
        'productName': lead.productName,
        'quantity': lead.quantity * item.quantity,
        'unitPriceCents': item.unitPriceCents, // Full combo price on lead
        'prepStation': lead.prepStation,
        'modifiers': const [],
        'comboId': item.comboId,
        'comboName': item.comboName,
        'comboWireGroup': wireGroup,
        'comboSaleQuantity': item.quantity, // Lead-only marker
      },
    ];
    for (final sibling in components.skip(1)) {
      payloads.add({
        'productId': sibling.productId,
        'productName': sibling.productName,
        'quantity': sibling.quantity * item.quantity,
        'unitPriceCents': 0,
        'prepStation': sibling.prepStation,
        'modifiers': const [],
        'comboId': item.comboId,
        'comboName': item.comboName,
        'comboWireGroup': wireGroup,
        'comboSaleQuantity': null,
      });
    }
    return payloads;
  }

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

  /// Fans a combo cart line out into one `OrderItemsTable` row per
  /// constituent product (docs/features/03-combo-modifier-pricing.md), so
  /// kitchen ticket routing (per-row prepStation) and stock decrement
  /// (per-row productId) work unmodified — see [CheckoutCubit._decrementStock]
  /// and `TicketsDao`. The first component is the "lead" row: it carries
  /// the full flat combo price and `comboSaleQuantity` (how many combo
  /// units were sold); siblings get `unitPrice = 0` but keep their own real
  /// cost snapshot for margin accuracy. All rows share `comboLineId` (set to
  /// the lead row's own id) so the receipt mapper can regroup them.
  Future<List<OrderLineItem>> _insertComboLine(
    int orderId,
    OrderLineItem item,
  ) async {
    final components = item.comboComponents;
    if (components.isEmpty) return const []; // Defensive; should never happen

    final lead = components.first;
    final leadId = await _orderItemsDao.insertOrderItem(
      OrderItemsTableCompanion.insert(
        orderId: orderId,
        productId: Value(lead.productId),
        productName: lead.productName,
        unitPrice: item.unitPriceCents, // Full combo price on the lead row
        costPrice: lead.unitCostPriceCents * lead.quantity * item.quantity,
        quantity: Value(lead.quantity * item.quantity),
        discountAmount: const Value(0),
        prepStation: Value(lead.prepStation),
        comboId: Value(item.comboId),
        comboName: Value(item.comboName),
        comboSaleQuantity: Value(item.quantity),
      ),
    );
    await _orderItemsDao.setOrderItemComboLineId(leadId, leadId);

    final inserted = <OrderLineItem>[
      item.copyWith(
        id: leadId,
        productId: lead.productId,
        productName: lead.productName,
        quantity: lead.quantity * item.quantity,
        prepStation: lead.prepStation,
        comboLineId: leadId,
        comboSaleQuantity: item.quantity,
        comboComponents: const [],
      ),
    ];

    for (final sibling in components.skip(1)) {
      final siblingId = await _orderItemsDao.insertOrderItem(
        OrderItemsTableCompanion.insert(
          orderId: orderId,
          productId: Value(sibling.productId),
          productName: sibling.productName,
          unitPrice: 0,
          costPrice:
              sibling.unitCostPriceCents * sibling.quantity * item.quantity,
          quantity: Value(sibling.quantity * item.quantity),
          discountAmount: const Value(0),
          prepStation: Value(sibling.prepStation),
          comboId: Value(item.comboId),
          comboName: Value(item.comboName),
          comboLineId: Value(leadId),
        ),
      );
      inserted.add(
        item.copyWith(
          id: siblingId,
          productId: sibling.productId,
          productName: sibling.productName,
          unitPriceCents: 0,
          quantity: sibling.quantity * item.quantity,
          prepStation: sibling.prepStation,
          comboLineId: leadId,
          comboComponents: const [],
        ),
      );
    }

    return inserted;
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

  @override
  Future<Result<int>> getCashRevenueForEmployeeShift({
    required int employeeId,
    required DateTime startDate,
    DateTime? endDate,
  }) => safe(
    'getCashRevenueForEmployeeShift($employeeId)',
    () => _ordersDao.getCashRevenueForEmployeeShift(
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
    ),
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

          // Insert items (and their modifiers), fanning combo lines out
          // into one row per constituent — see [_insertComboLine].
          final insertedItems = <OrderLineItem>[];
          for (final item in order.items) {
            if (item.comboId == null) {
              final itemId = await _orderItemsDao.insertOrderItem(
                _itemToInsertCompanion(orderId, item),
              );

              for (final modifier in item.selectedModifiers) {
                await _orderItemsDao.addModifierToOrderItem(
                  orderItemId: itemId,
                  modifierName: modifier.groupName,
                  optionName: modifier.optionName,
                  priceChange: modifier.priceChangeCents,
                );
              }
              insertedItems.add(item.copyWith(id: itemId));
            } else {
              insertedItems.addAll(await _insertComboLine(orderId, item));
            }
          }

          // Return the created order with its new ID and fanned-out items —
          // downstream consumers (stock decrement, kitchen tickets,
          // receipt) all read `order.items` and expect the persisted,
          // per-row shape, not the cart-level combo line.
          return orderWithSyncId.copyWith(id: orderId, items: insertedItems);
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
