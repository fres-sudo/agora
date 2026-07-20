import 'package:database/database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:feature_orders/data/repositories/orders_repository_impl.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:order_management/models/combo_line_component.dart';
import 'package:order_management/models/order.dart';
import 'package:order_management/models/order_line_item.dart';
import 'package:order_management/models/order_type.dart';
import 'package:order_management/models/selected_modifiers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result/result.dart';
import 'package:sync_engine/sync_engine.dart';

import 'orders_repository_impl_test.mocks.dart';

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

@GenerateMocks([SyncManager])
void main() {
  late AgoraDatabase db;
  late MockSyncManager syncManager;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
    syncManager = MockSyncManager();
    when(
      syncManager.enqueue(
        entityType: anyNamed('entityType'),
        operation: anyNamed('operation'),
        entityLocalId: anyNamed('entityLocalId'),
        payload: anyNamed('payload'),
        remoteId: anyNamed('remoteId'),
      ),
    ).thenAnswer((_) async {});
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
        syncManager: syncManager,
        deviceId: const DeviceId('test-device'),
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
        syncManager: syncManager,
        deviceId: const DeviceId('test-device'),
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

  group('OrdersRepositoryImpl.createOrder — combo fan-out', () {
    test('fans a combo line out into one row per constituent, sharing one '
        'comboLineId, with the full price on the lead row only '
        '(docs/features/03-combo-modifier-pricing.md)', () async {
      final ordersDao = OrdersDao(db);
      final orderItemsDao = OrderItemsDao(db);
      final repo = OrdersRepositoryImpl(
        ordersDao: ordersDao,
        orderItemsDao: orderItemsDao,
        syncManager: syncManager,
        deviceId: const DeviceId('test-device'),
      );

      final paninoId = await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion.insert(
              name: 'Panino',
              prepStation: const Value('Griglia'),
            ),
          );
      final patatineId = await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion.insert(
              name: 'Patatine',
              prepStation: const Value('Fritti'),
            ),
          );
      final bibitaId = await db
          .into(db.productsTable)
          .insert(ProductsTableCompanion.insert(name: 'Bibita'));

      final comboLine = OrderLineItem(
        id: 1,
        productId: null,
        comboId: 42,
        comboName: 'Menu Completo',
        productName: 'Menu Completo',
        unitPriceCents: 1000,
        quantity: 2, // 2 combo units sold on this cart line
        selectedModifiers: const [],
        comboComponents: [
          ComboLineComponent(
            productId: paninoId,
            productName: 'Panino',
            unitCostPriceCents: 200,
            prepStation: 'Griglia',
          ),
          ComboLineComponent(
            productId: patatineId,
            productName: 'Patatine',
            unitCostPriceCents: 150,
            prepStation: 'Fritti',
          ),
          ComboLineComponent(
            productId: bibitaId,
            productName: 'Bibita',
            unitCostPriceCents: 80,
          ),
        ],
      );

      final order = _buildOrder(items: [comboLine]);
      final result = await repo.createOrder(order);

      expect(result.isSuccess, isTrue);
      final persisted = result.unwrap();

      // The returned Order carries the fanned-out rows, not the original
      // single cart-level combo line — this is what lets stock decrement/
      // kitchen tickets/receipt read `order.items` unmodified.
      expect(persisted.items, hasLength(3));

      final rows = await db.select(db.orderItemsTable).get();
      expect(rows, hasLength(3));

      final comboLineIds = rows.map((r) => r.comboLineId).toSet();
      expect(comboLineIds, hasLength(1));
      expect(comboLineIds.single != null, isTrue);

      final leadRows = rows.where((r) => r.unitPrice > 0).toList();
      expect(leadRows, hasLength(1));
      final lead = leadRows.single;
      expect(lead.unitPrice, 1000);
      expect(lead.comboSaleQuantity, 2);
      expect(lead.productId, paninoId);
      expect(lead.quantity, 2); // constituent qty (1) * cart qty (2)
      expect(lead.prepStation, 'Griglia');
      expect(lead.comboId, 42);
      expect(lead.comboName, 'Menu Completo');

      final siblingRows = rows.where((r) => r.unitPrice == 0).toList();
      expect(siblingRows, hasLength(2));
      for (final row in siblingRows) {
        expect(row.comboLineId, comboLineIds.single);
        expect(row.comboSaleQuantity, null);
      }
      final siblingProductIds = siblingRows.map((r) => r.productId).toSet();
      expect(siblingProductIds, {patatineId, bibitaId});

      // Each row's own productId/prepStation/costPrice matches its own
      // constituent — never a shared/combo-level value.
      final bibitaRow = rows.firstWhere((r) => r.productId == bibitaId);
      expect(bibitaRow.prepStation, null);
      expect(bibitaRow.costPrice, 80 * 1 * 2); // unitCost * qty * cartQty
    });
  });

  group('OrdersRepositoryImpl — employeeId '
      '(docs/features/04-volunteer-shift-accountability.md)', () {
    test('round-trips through createOrder / getOrderById', () async {
      final employeeId = await db
          .into(db.employeesTable)
          .insert(EmployeesTableCompanion.insert(name: 'Ada', pinHash: 'hash'));
      final ordersDao = OrdersDao(db);
      final orderItemsDao = OrderItemsDao(db);
      final repo = OrdersRepositoryImpl(
        ordersDao: ordersDao,
        orderItemsDao: orderItemsDao,
        syncManager: syncManager,
        deviceId: const DeviceId('test-device'),
      );

      final order = _buildOrder(
        items: [_item(1)],
      ).copyWith(employeeId: employeeId);
      final result = await repo.createOrder(order);
      expect(result.isSuccess, isTrue);
      expect(result.unwrap().employeeId, employeeId);

      final fetched = await repo.getOrderById(result.unwrap().id!);
      expect(fetched.unwrap()!.employeeId, employeeId);
    });

    test('never appears in the LAN-sync outbound payload — employee records '
        "aren't synced cross-station, so a raw local id would be meaningless "
        '(or wrong) on a peer', () async {
      final ordersDao = OrdersDao(db);
      final orderItemsDao = OrderItemsDao(db);
      final repo = OrdersRepositoryImpl(
        ordersDao: ordersDao,
        orderItemsDao: orderItemsDao,
        syncManager: syncManager,
        deviceId: const DeviceId('test-device'),
      );

      final order = _buildOrder(items: [_item(1)]).copyWith(employeeId: 7);
      await repo.createOrder(order);

      final captured = verify(
        syncManager.enqueue(
          entityType: anyNamed('entityType'),
          operation: anyNamed('operation'),
          entityLocalId: anyNamed('entityLocalId'),
          payload: captureAnyNamed('payload'),
          remoteId: anyNamed('remoteId'),
        ),
      ).captured;
      final payload = captured.single as Map<String, dynamic>;
      expect(payload.containsKey('employeeId'), isFalse);
    });
  });
}
