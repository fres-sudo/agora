import 'package:database/database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:feature_orders/data/repositories/orders_repository_impl.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/models/order_type.dart';
import 'package:feature_orders/domain/models/selected_modifiers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result/result.dart';

/// A DAO that behaves exactly like [OrderItemsDao] except it throws after a
/// configurable number of successful `insertOrderItem` calls, simulating a
/// crash/exception partway through the multi-item insert sequence used by
/// `OrdersRepositoryImpl.createOrder`.
class _FlakyOrderItemsDao extends OrderItemsDao {
  _FlakyOrderItemsDao(super.db, {required this.failAfter});

  /// Number of successful inserts allowed before the next call throws.
  final int failAfter;
  int _insertCount = 0;

  @override
  Future<int> insertOrderItem(Insertable<OrderItemEntity> companion) async {
    if (_insertCount >= failAfter) {
      throw Exception('Simulated mid-insert failure');
    }
    _insertCount++;
    return super.insertOrderItem(companion);
  }
}

Order _buildOrder({required List<OrderLineItem> items}) {
  return Order(
    id: null,
    createdAt: DateTime(2026, 1, 1),
    status: OrderStatus.pending,
    orderType: OrderType.dineIn,
    items: items,
    note: null,
    subtotalCents: 1000,
    taxCents: 0,
    discountCents: 0,
    grandTotalCents: 1000,
  );
}

OrderLineItem _item(int id, {List<SelectedModifiers> modifiers = const []}) {
  return OrderLineItem(
    id: id,
    productId: null, // avoid FK coupling to ProductsTable in this test
    productName: 'Item $id',
    quantity: 1,
    unitPriceCents: 500,
    selectedModifiers: modifiers,
  );
}

void main() {
  late AgoraDatabase db;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('OrdersRepositoryImpl.createOrder', () {
    test('persists order header, items and modifiers together', () async {
      final ordersDao = OrdersDao(db);
      final orderItemsDao = OrderItemsDao(db);
      final repo = OrdersRepositoryImpl(
        ordersDao: ordersDao,
        orderItemsDao: orderItemsDao,
      );

      final order = _buildOrder(
        items: [
          _item(
            1,
            modifiers: const [
              SelectedModifiers(
                groupName: 'Size',
                optionName: 'Large',
                priceChangeCents: 100,
              ),
            ],
          ),
          _item(2),
        ],
      );

      final result = await repo.createOrder(order);

      expect(result.isSuccess, isTrue);

      final orderCount = await ordersDao.getOrdersCount();
      expect(orderCount, 1);

      final persistedOrders = await db.select(db.ordersTable).get();
      expect(persistedOrders, hasLength(1));

      final persistedItems = await orderItemsDao.getItemsByOrderId(
        persistedOrders.single.id,
      );
      expect(persistedItems, hasLength(2));

      final modifiers = await orderItemsDao.getModifiersByOrderItemId(
        persistedItems.first.id,
      );
      expect(modifiers, hasLength(1));
    });

    test('rolls back the order header and prior items when a later insert '
        'fails mid-sequence', () async {
      final ordersDao = OrdersDao(db);
      // Allow the first item to insert successfully, then throw on the
      // second — simulating a crash after the order header and first item
      // are written but before the rest of the order is persisted.
      final flakyItemsDao = _FlakyOrderItemsDao(db, failAfter: 1);
      final repo = OrdersRepositoryImpl(
        ordersDao: ordersDao,
        orderItemsDao: flakyItemsDao,
      );

      final order = _buildOrder(items: [_item(1), _item(2), _item(3)]);

      final result = await repo.createOrder(order);

      expect(result.isError, isTrue);

      // Nothing should have been persisted: the order header insert and
      // the first (successful) item insert must both be rolled back
      // because they ran inside the same transaction as the failing
      // second item insert.
      final orderCount = await ordersDao.getOrdersCount();
      expect(orderCount, 0);

      final allOrders = await db.select(db.ordersTable).get();
      expect(allOrders, isEmpty);

      final allItems = await db.select(db.orderItemsTable).get();
      expect(allItems, isEmpty);
    });
  });
}
