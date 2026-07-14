@TestOn('vm')
library;

import 'dart:io';

import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

void main() {
  group('AgoraDatabase migrations', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('agora_db_migration_test');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('upgrading from schema v1 to v2 preserves existing order rows '
        '(regression test for #10: onUpgrade must not drop tables)', () async {
      final dbFile = File('${tempDir.path}/agora.sqlite');

      // Hand-build a schema v1 database on disk: `orders_table` without the
      // `order_type` column that was introduced in v2, pre-populated with a
      // row representing real, unsynced local data. `product_modifier_links_table`,
      // `clock_records_table`, `stock_movements_table`, `products_table` and
      // `order_items_table` already existed as of v1 too (they only gained
      // a dedup pass / unique index / syncId / prepStation+ticketStatus
      // column in later versions), so they're included here empty —
      // otherwise the v1->v6 onUpgrade chain below would hit "no such
      // table" on its v3/v4/v5/v6 steps.
      final legacyDb = sqlite3.sqlite3.open(dbFile.path);
      legacyDb.execute('''
          CREATE TABLE orders_table (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            status INTEGER NOT NULL DEFAULT 0,
            subtotal INTEGER NOT NULL,
            discount_total INTEGER NOT NULL DEFAULT 0,
            tax_total INTEGER NOT NULL DEFAULT 0,
            grand_total INTEGER NOT NULL,
            payment_method TEXT NULL,
            note TEXT NULL
          );
        ''');
      legacyDb.execute('''
          INSERT INTO orders_table
            (created_at, status, subtotal, discount_total, tax_total, grand_total, payment_method, note)
          VALUES
            (1700000000, 1, 1500, 0, 150, 1650, 'Cash', 'unsynced order');
        ''');
      legacyDb.execute('''
          CREATE TABLE product_modifier_links_table (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            product_id INTEGER NOT NULL,
            modifier_id INTEGER NOT NULL
          );
        ''');
      legacyDb.execute('''
          CREATE TABLE clock_records_table (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            employee_id INTEGER NOT NULL,
            clocked_in_at INTEGER NOT NULL,
            clocked_out_at INTEGER NULL,
            note TEXT NULL
          );
        ''');
      legacyDb.execute('''
          CREATE TABLE stock_movements_table (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            product_id INTEGER NOT NULL,
            quantity_change INTEGER NOT NULL,
            reason TEXT NOT NULL,
            timestamp INTEGER NOT NULL
          );
        ''');
      legacyDb.execute('''
          CREATE TABLE products_table (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            name TEXT NOT NULL,
            description TEXT NOT NULL DEFAULT '',
            image_url TEXT NULL,
            track_stock INTEGER NOT NULL DEFAULT 1,
            sku TEXT NULL,
            category_id INTEGER NULL,
            price INTEGER NOT NULL DEFAULT 0,
            cost INTEGER NOT NULL DEFAULT 0,
            tax_percent INTEGER NOT NULL DEFAULT 0,
            status TEXT NOT NULL DEFAULT 'draft'
          );
        ''');
      legacyDb.execute('''
          CREATE TABLE order_items_table (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NULL,
            deleted_at INTEGER NULL,
            order_id INTEGER NOT NULL,
            product_id INTEGER NULL,
            product_name TEXT NOT NULL,
            unit_price INTEGER NOT NULL,
            cost_price INTEGER NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 1,
            discount_amount INTEGER NOT NULL DEFAULT 0
          );
        ''');
      legacyDb.execute('PRAGMA user_version = 1;');
      legacyDb.dispose();

      // Now open it through AgoraDatabase (schemaVersion 2). This must run
      // the additive onUpgrade step, not wipe the database.
      final db = AgoraDatabase(NativeDatabase(dbFile));
      addTearDown(db.close);

      final orders = await db.select(db.ordersTable).get();

      expect(
        orders,
        hasLength(1),
        reason: 'Existing local order data must survive a schema upgrade',
      );
      final order = orders.single;
      expect(order.subtotal, 1500);
      expect(order.grandTotal, 1650);
      expect(order.paymentMethod, 'Cash');
      expect(order.note, 'unsynced order');
      // New column backfilled with its declared default rather than the
      // row being dropped/recreated.
      expect(order.orderType, 0);
    });

    test(
      'fresh install creates all tables at the current schema version',
      () async {
        final dbFile = File('${tempDir.path}/agora_fresh.sqlite');
        final db = AgoraDatabase(NativeDatabase(dbFile));
        addTearDown(db.close);

        // Should not throw, and the orders table should already have the v2
        // `orderType` column available for inserts.
        final id = await db
            .into(db.ordersTable)
            .insert(
              OrdersTableCompanion.insert(subtotal: 1000, grandTotal: 1000),
            );

        final inserted = await (db.select(
          db.ordersTable,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(inserted.orderType, 0);
      },
    );

    test('upgrading from schema v4 to v5 backfills syncId as null on existing '
        'orders/stock-movements and still enforces uniqueness on new rows '
        '(docs/features/01-lan-sync.md cross-station identity)', () async {
      final dbFile = File('${tempDir.path}/agora_v4_to_v5.sqlite');

      // Hand-build a schema v4 database: orders_table and
      // stock_movements_table as they were before the syncId column was
      // added, each pre-populated with a row of real, unsynced local
      // data. products_table and order_items_table are included empty —
      // otherwise the v4->v6 onUpgrade chain below would hit "no such
      // table" on its v6 step.
      final legacyDb = sqlite3.sqlite3.open(dbFile.path);
      legacyDb.execute('''
            CREATE TABLE orders_table (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NULL,
              deleted_at INTEGER NULL,
              status INTEGER NOT NULL DEFAULT 0,
              order_type INTEGER NOT NULL DEFAULT 0,
              subtotal INTEGER NOT NULL,
              discount_total INTEGER NOT NULL DEFAULT 0,
              tax_total INTEGER NOT NULL DEFAULT 0,
              grand_total INTEGER NOT NULL,
              payment_method TEXT NULL,
              note TEXT NULL
            );
          ''');
      legacyDb.execute('''
            INSERT INTO orders_table
              (created_at, status, subtotal, discount_total, tax_total, grand_total, payment_method, note)
            VALUES
              (1700000000, 1, 1500, 0, 150, 1650, 'Cash', 'unsynced order');
          ''');
      legacyDb.execute('''
            CREATE TABLE stock_movements_table (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NULL,
              deleted_at INTEGER NULL,
              product_id INTEGER NOT NULL,
              quantity_change INTEGER NOT NULL,
              reason TEXT NOT NULL,
              timestamp INTEGER NOT NULL
            );
          ''');
      legacyDb.execute('''
            INSERT INTO stock_movements_table
              (created_at, product_id, quantity_change, reason, timestamp)
            VALUES
              (1700000000, 1, -1, 'Sale #101', 1700000000);
          ''');
      legacyDb.execute('''
            CREATE TABLE products_table (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NULL,
              deleted_at INTEGER NULL,
              name TEXT NOT NULL,
              description TEXT NOT NULL DEFAULT '',
              image_url TEXT NULL,
              track_stock INTEGER NOT NULL DEFAULT 1,
              sku TEXT NULL,
              category_id INTEGER NULL,
              price INTEGER NOT NULL DEFAULT 0,
              cost INTEGER NOT NULL DEFAULT 0,
              tax_percent INTEGER NOT NULL DEFAULT 0,
              status TEXT NOT NULL DEFAULT 'draft'
            );
          ''');
      legacyDb.execute('''
            CREATE TABLE order_items_table (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NULL,
              deleted_at INTEGER NULL,
              order_id INTEGER NOT NULL,
              product_id INTEGER NULL,
              product_name TEXT NOT NULL,
              unit_price INTEGER NOT NULL,
              cost_price INTEGER NOT NULL,
              quantity INTEGER NOT NULL DEFAULT 1,
              discount_amount INTEGER NOT NULL DEFAULT 0
            );
          ''');
      legacyDb.execute('PRAGMA user_version = 4;');
      legacyDb.dispose();

      final db = AgoraDatabase(NativeDatabase(dbFile));
      addTearDown(db.close);

      final orders = await db.select(db.ordersTable).get();
      expect(orders, hasLength(1));
      expect(
        orders.single.syncId,
        isNull,
        reason: 'pre-migration rows must not be retroactively synced',
      );

      final movements = await db.select(db.stockMovementsTable).get();
      expect(movements, hasLength(1));
      expect(movements.single.syncId, isNull);

      // The hand-built legacy fixture's created_at column has no SQL-level
      // DEFAULT (unlike a drift-created table via m.createAll()), so
      // these inserts supply it explicitly — irrelevant to what's under
      // test here (syncId uniqueness).
      final now = Value(DateTime.now());

      // A second null-syncId row must still be insertable (SQLite treats
      // each NULL as distinct under a UNIQUE constraint).
      await db
          .into(db.ordersTable)
          .insert(
            OrdersTableCompanion.insert(
              createdAt: now,
              subtotal: 500,
              grandTotal: 500,
            ),
          );

      // A new order with a real syncId inserts cleanly...
      await db
          .into(db.ordersTable)
          .insert(
            OrdersTableCompanion.insert(
              createdAt: now,
              subtotal: 500,
              grandTotal: 500,
              syncId: const Value('11111111-1111-1111-1111-111111111111'),
            ),
          );

      // ...but a duplicate syncId is rejected.
      await expectLater(
        db
            .into(db.ordersTable)
            .insert(
              OrdersTableCompanion.insert(
                createdAt: now,
                subtotal: 500,
                grandTotal: 500,
                syncId: const Value('11111111-1111-1111-1111-111111111111'),
              ),
            ),
        throwsA(anything),
      );
    });

    test('upgrading from schema v5 to v6 backfills prepStation/ticketStatus '
        'as null/pending on existing order items, and lets new products/order '
        'items use them (docs/features/02-kitchen-ticket-routing.md)', () async {
      final dbFile = File('${tempDir.path}/agora_v5_to_v6.sqlite');

      // Hand-build a schema v5 database: products_table and
      // order_items_table as they were before prepStation/ticketStatus were
      // added, each pre-populated with a row of real, unsynced local data.
      final legacyDb = sqlite3.sqlite3.open(dbFile.path);
      legacyDb.execute('''
            CREATE TABLE orders_table (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NULL,
              deleted_at INTEGER NULL,
              status INTEGER NOT NULL DEFAULT 0,
              order_type INTEGER NOT NULL DEFAULT 0,
              subtotal INTEGER NOT NULL,
              discount_total INTEGER NOT NULL DEFAULT 0,
              tax_total INTEGER NOT NULL DEFAULT 0,
              grand_total INTEGER NOT NULL,
              payment_method TEXT NULL,
              note TEXT NULL,
              sync_id TEXT NULL
            );
          ''');
      legacyDb.execute('''
            CREATE UNIQUE INDEX idx_orders_sync_id ON orders_table (sync_id);
          ''');
      legacyDb.execute('''
            INSERT INTO orders_table
              (created_at, status, subtotal, discount_total, tax_total, grand_total, payment_method, note)
            VALUES
              (1700000000, 1, 1500, 0, 150, 1650, 'Cash', 'unsynced order');
          ''');
      legacyDb.execute('''
            CREATE TABLE products_table (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NULL,
              deleted_at INTEGER NULL,
              name TEXT NOT NULL,
              description TEXT NOT NULL DEFAULT '',
              image_url TEXT NULL,
              track_stock INTEGER NOT NULL DEFAULT 1,
              sku TEXT NULL,
              category_id INTEGER NULL,
              price INTEGER NOT NULL DEFAULT 0,
              cost INTEGER NOT NULL DEFAULT 0,
              tax_percent INTEGER NOT NULL DEFAULT 0,
              status TEXT NOT NULL DEFAULT 'draft'
            );
          ''');
      legacyDb.execute('''
            INSERT INTO products_table (created_at, name, price)
            VALUES (1700000000, 'Panino', 500);
          ''');
      legacyDb.execute('''
            CREATE TABLE order_items_table (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NULL,
              deleted_at INTEGER NULL,
              order_id INTEGER NOT NULL,
              product_id INTEGER NULL,
              product_name TEXT NOT NULL,
              unit_price INTEGER NOT NULL,
              cost_price INTEGER NOT NULL,
              quantity INTEGER NOT NULL DEFAULT 1,
              discount_amount INTEGER NOT NULL DEFAULT 0
            );
          ''');
      legacyDb.execute('''
            INSERT INTO order_items_table
              (created_at, order_id, product_id, product_name, unit_price, cost_price)
            VALUES
              (1700000000, 1, 1, 'Panino', 500, 0);
          ''');
      legacyDb.execute('''
            CREATE TABLE stock_movements_table (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NULL,
              deleted_at INTEGER NULL,
              product_id INTEGER NOT NULL,
              quantity_change INTEGER NOT NULL,
              reason TEXT NOT NULL,
              timestamp INTEGER NOT NULL,
              sync_id TEXT NULL
            );
          ''');
      legacyDb.execute('''
            CREATE UNIQUE INDEX idx_stock_movements_sync_id ON stock_movements_table (sync_id);
          ''');
      legacyDb.execute('PRAGMA user_version = 5;');
      legacyDb.dispose();

      final db = AgoraDatabase(NativeDatabase(dbFile));
      addTearDown(db.close);

      final items = await db.select(db.orderItemsTable).get();
      expect(items, hasLength(1));
      expect(
        items.single.prepStation,
        isNull,
        reason: 'pre-migration order items are never retroactively ticketed',
      );
      expect(
        items.single.ticketStatus,
        0,
        reason:
            'new ticketStatus column backfills to its declared default (pending)',
      );

      final products = await db.select(db.productsTable).get();
      expect(products.single.prepStation, isNull);

      // Same as above: the hand-built legacy fixture's created_at column has
      // no SQL-level DEFAULT, so these inserts supply it explicitly.
      final now = Value(DateTime.now());

      // A new product can be assigned a station, and a new order item can
      // carry the snapshot + an advanced ticket status, post-migration.
      final productId = await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion.insert(
              createdAt: now,
              name: 'Bruschette',
              prepStation: const Value('Griglia'),
            ),
          );
      final reloadedProduct = await (db.select(
        db.productsTable,
      )..where((t) => t.id.equals(productId))).getSingle();
      expect(reloadedProduct.prepStation, 'Griglia');

      final itemId = await db
          .into(db.orderItemsTable)
          .insert(
            OrderItemsTableCompanion.insert(
              createdAt: now,
              orderId: 1,
              productName: 'Bruschette',
              unitPrice: 400,
              costPrice: 0,
              prepStation: const Value('Griglia'),
              ticketStatus: const Value(1),
            ),
          );
      final reloadedItem = await (db.select(
        db.orderItemsTable,
      )..where((t) => t.id.equals(itemId))).getSingle();
      expect(reloadedItem.prepStation, 'Griglia');
      expect(reloadedItem.ticketStatus, 1);
    });
  });
}
