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
      // row representing real, unsynced local data.
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
  });
}
