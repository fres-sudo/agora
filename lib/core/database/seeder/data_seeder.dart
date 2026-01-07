import 'package:agora/core/database/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class DataSeeder {
  final AgoraDatabase db;

  DataSeeder(this.db);

  /// Seeds the database with mock data if it's empty.
  Future<void> seed() async {
    // Check if we already have categories
    final categoryCount = await db
        .select(db.categoriesTable)
        .get()
        .then((l) => l.length);

    if (categoryCount > 0) {
      debugPrint('Database already seeded. Skipping.');
      return;
    }

    debugPrint('Seeding database with mock data...');

    await db.transaction(() async {
      // --- 1. Categories ---
      final primiId = await db
          .into(db.categoriesTable)
          .insert(
            CategoriesTableCompanion(
              name: const Value('Primi'),
              color: Value(Colors.orange),
              iconCodePoint: Value(Icons.dinner_dining.codePoint),
              isEnabled: const Value(true),
            ),
          );

      final secondiId = await db
          .into(db.categoriesTable)
          .insert(
            CategoriesTableCompanion(
              name: const Value('Secondi'),
              color: Value(Colors.red),
              iconCodePoint: Value(Icons.restaurant.codePoint),
              isEnabled: const Value(true),
            ),
          );

      final contorniId = await db
          .into(db.categoriesTable)
          .insert(
            CategoriesTableCompanion(
              name: const Value('Contorni'),
              color: Value(Colors.green),
              iconCodePoint: Value(Icons.soup_kitchen.codePoint),
              isEnabled: const Value(true),
            ),
          );

      final bevandeId = await db
          .into(db.categoriesTable)
          .insert(
            CategoriesTableCompanion(
              name: const Value('Bevande'),
              color: Value(Colors.blue),
              iconCodePoint: Value(Icons.local_bar.codePoint),
              isEnabled: const Value(true),
            ),
          );

      final dolciId = await db
          .into(db.categoriesTable)
          .insert(
            CategoriesTableCompanion(
              name: const Value('Dolci'),
              color: Value(Colors.purple),
              iconCodePoint: Value(Icons.icecream.codePoint),
              isEnabled: const Value(true),
            ),
          );

      // --- 2. Products ---

      // Primi
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Tagliatelle al Ragù'),
              description: const Value('Pasta fresca con ragù alla bolognese'),
              categoryId: Value(primiId),
              price: const Value(800), // €8.00
              cost: const Value(250),
              status: const Value('active'),
            ),
          );
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Tortellini Panna e Prosciutto'),
              description: const Value('Classici tortellini modenesi'),
              categoryId: Value(primiId),
              price: const Value(900), // €9.00
              cost: const Value(300),
              status: const Value('active'),
            ),
          );
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Gramigna alla Salsiccia'),
              description: const Value('Gramigna con salsiccia locale'),
              categoryId: Value(primiId),
              price: const Value(750), // €7.50
              cost: const Value(200),
              status: const Value('active'),
            ),
          );

      // Secondi
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Grigliata Mista'),
              description: const Value('Costine, salsiccia, e coppone'),
              categoryId: Value(secondiId),
              price: const Value(1500), // €15.00
              cost: const Value(600),
              status: const Value('active'),
            ),
          );
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Cotoletta alla Bolognese'),
              description: const Value(
                'Cotoletta con prosciutto crudo e parmigiano',
              ),
              categoryId: Value(secondiId),
              price: const Value(1200), // €12.00
              cost: const Value(500),
              status: const Value('active'),
            ),
          );

      // Contorni
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Patatine Fritte'),
              categoryId: Value(contorniId),
              price: const Value(400), // €4.00
              cost: const Value(100),
              status: const Value('active'),
            ),
          );
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Insalata Mista'),
              categoryId: Value(contorniId),
              price: const Value(350), // €3.50
              cost: const Value(100),
              status: const Value('active'),
            ),
          );

      // Bevande
      final waterId = await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Acqua Naturale 50cl'),
              categoryId: Value(bevandeId),
              price: const Value(100), // €1.00
              cost: const Value(20),
              status: const Value('active'),
            ),
          );
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Birra Media'),
              categoryId: Value(bevandeId),
              price: const Value(450), // €4.50
              cost: const Value(150),
              status: const Value('active'),
            ),
          );
      final wineId = await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Lambrusco Caraffa 1L'),
              categoryId: Value(bevandeId),
              price: const Value(800), // €8.00
              cost: const Value(300),
              status: const Value('active'),
            ),
          );
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Coca Cola Lattina'),
              categoryId: Value(bevandeId),
              price: const Value(250), // €2.50
              cost: const Value(80),
              status: const Value('active'),
            ),
          );

      // Dolci
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Tiramisù'),
              categoryId: Value(dolciId),
              price: const Value(500), // €5.00
              cost: const Value(150),
              status: const Value('active'),
            ),
          );
      await db
          .into(db.productsTable)
          .insert(
            ProductsTableCompanion(
              name: const Value('Zuppa Inglese'),
              categoryId: Value(dolciId),
              price: const Value(500), // €5.00
              cost: const Value(150),
              status: const Value('active'),
            ),
          );

      // --- 3. Mock Orders ---

      // Order 1: Completed (Cash)
      final order1Id = await db
          .into(db.ordersTable)
          .insert(
            OrdersTableCompanion(
              status: const Value(1), // Completed
              subtotal: const Value(1300),
              grandTotal: const Value(1300),
              paymentMethod: const Value('Cash'),
              note: const Value('Tavolo 5'),
            ),
          );

      // 2 Waters + 1 Wine + 1 Insalata (mock logic for items)
      await db
          .into(db.orderItemsTable)
          .insert(
            OrderItemsTableCompanion(
              orderId: Value(order1Id),
              productId: Value(waterId),
              productName: const Value('Acqua Naturale 50cl'),
              unitPrice: const Value(100),
              costPrice: const Value(20),
              quantity: const Value(2),
            ),
          );
      await db
          .into(db.orderItemsTable)
          .insert(
            OrderItemsTableCompanion(
              orderId: Value(order1Id),
              productId: Value(wineId),
              productName: const Value('Lambrusco Caraffa 1L'),
              unitPrice: const Value(800),
              costPrice: const Value(300),
              quantity: const Value(1),
            ),
          );
      await db
          .into(db.orderItemsTable)
          .insert(
            OrderItemsTableCompanion(
              orderId: Value(order1Id),
              productId: Value(0), // manual item example? or just linked
              productName: const Value('Coperto'),
              unitPrice: const Value(150),
              costPrice: const Value(0),
              quantity: const Value(2),
            ),
          );

      // Order 2: Pending
      final order2Id = await db
          .into(db.ordersTable)
          .insert(
            OrdersTableCompanion(
              status: const Value(0), // Pending
              subtotal: const Value(3400),
              grandTotal: const Value(3400),
              note: const Value('Da asporto'),
            ),
          );
      // Just some random items logic - we won't detailedly link for brevity but normally we would
    });

    debugPrint('Database seeding completed!');
  }
}
