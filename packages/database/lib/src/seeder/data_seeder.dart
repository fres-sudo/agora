// Seed data assigns persisted category colors (stored as ints), not theme
// tokens — the design-system color rule does not apply here.
// ignore_for_file: avoid_hardcoded_colors
import 'package:database/database.dart';
import 'package:flutter/material.dart';

/// The starter catalog to load during onboarding. Kept as a plain enum local to
/// `package:database` so this low-level package stays free of `feature_flags`;
/// the onboarding layer maps its `BusinessType` onto one of these.
enum StarterCatalog { restaurant, barCafe, quickService, festival }

/// A single product row in a starter catalog. [categoryIndex] refers into the
/// catalog's category list.
class _SeedProduct {
  const _SeedProduct(
    this.categoryIndex,
    this.name,
    this.priceCents,
    this.costCents,
    this.stock,
  );
  final int categoryIndex;
  final String name;
  final int priceCents;
  final int costCents;
  final int stock;
}

class _SeedCategory {
  const _SeedCategory(this.name, this.color, this.icon);
  final String name;
  final Color color;
  final IconData icon;
}

class DataSeeder {
  final AgoraDatabase db;

  DataSeeder(this.db);

  /// Seeds a starter catalog (categories + products + opening stock) for the
  /// given business type. Idempotent: if any category already exists it does
  /// nothing, so it is safe to call from onboarding. Does not create demo
  /// orders — a freshly set-up business starts with zero sales.
  Future<void> seedStarterCatalog(StarterCatalog catalog) async {
    final categoryCount = await db
        .select(db.categoriesTable)
        .get()
        .then((l) => l.length);
    if (categoryCount > 0) {
      debugPrint('Catalog already present. Skipping starter seed.');
      return;
    }

    final categories = _categoriesFor(catalog);
    final products = _productsFor(catalog);

    await db.transaction(() async {
      final categoryIds = <int>[];
      for (final c in categories) {
        final id = await db.into(db.categoriesTable).insert(
              CategoriesTableCompanion(
                name: Value(c.name),
                color: Value(c.color),
                iconCodePoint: Value(c.icon.codePoint),
                isEnabled: const Value(true),
              ),
            );
        categoryIds.add(id);
      }

      for (final p in products) {
        final productId = await db.into(db.productsTable).insert(
              ProductsTableCompanion(
                name: Value(p.name),
                categoryId: Value(categoryIds[p.categoryIndex]),
                price: Value(p.priceCents),
                cost: Value(p.costCents),
                status: const Value('active'),
              ),
            );
        await db.into(db.stocksTable).insert(
              StocksTableCompanion(
                productId: Value(productId),
                quantity: Value(p.stock),
              ),
            );
        await db.into(db.stockMovementsTable).insert(
              StockMovementsTableCompanion(
                productId: Value(productId),
                quantityChange: Value(p.stock),
                reason: const Value('Initial stock'),
              ),
            );
      }
    });

    debugPrint('Seeded ${products.length} products for $catalog.');
  }

  List<_SeedCategory> _categoriesFor(StarterCatalog catalog) {
    switch (catalog) {
      case StarterCatalog.restaurant:
        return const [
          _SeedCategory('Primi', Colors.orange, Icons.dinner_dining),
          _SeedCategory('Secondi', Colors.red, Icons.restaurant),
          _SeedCategory('Contorni', Colors.green, Icons.soup_kitchen),
          _SeedCategory('Bevande', Colors.blue, Icons.local_bar),
          _SeedCategory('Dolci', Colors.purple, Icons.icecream),
        ];
      case StarterCatalog.barCafe:
        return const [
          _SeedCategory('Coffee', Colors.brown, Icons.coffee),
          _SeedCategory('Drinks', Colors.blue, Icons.local_bar),
          _SeedCategory('Pastries', Colors.orange, Icons.bakery_dining),
          _SeedCategory('Snacks', Colors.green, Icons.lunch_dining),
        ];
      case StarterCatalog.quickService:
        return const [
          _SeedCategory('Mains', Colors.red, Icons.lunch_dining),
          _SeedCategory('Sides', Colors.green, Icons.fastfood),
          _SeedCategory('Drinks', Colors.blue, Icons.local_drink),
          _SeedCategory('Desserts', Colors.purple, Icons.icecream),
        ];
      case StarterCatalog.festival:
        return const [
          _SeedCategory('Food', Colors.red, Icons.fastfood),
          _SeedCategory('Drinks', Colors.blue, Icons.local_bar),
        ];
    }
  }

  List<_SeedProduct> _productsFor(StarterCatalog catalog) {
    switch (catalog) {
      case StarterCatalog.restaurant:
        return const [
          _SeedProduct(0, 'Tagliatelle al Ragù', 800, 250, 40),
          _SeedProduct(0, 'Tortellini Panna e Prosciutto', 900, 300, 35),
          _SeedProduct(0, 'Gramigna alla Salsiccia', 750, 200, 20),
          _SeedProduct(1, 'Grigliata Mista', 1500, 600, 25),
          _SeedProduct(1, 'Cotoletta alla Bolognese', 1200, 500, 30),
          _SeedProduct(2, 'Patatine Fritte', 400, 100, 50),
          _SeedProduct(2, 'Insalata Mista', 350, 100, 45),
          _SeedProduct(3, 'Acqua Naturale 50cl', 100, 20, 150),
          _SeedProduct(3, 'Birra Media', 450, 150, 80),
          _SeedProduct(3, 'Lambrusco Caraffa 1L', 800, 300, 30),
          _SeedProduct(3, 'Coca Cola Lattina', 250, 80, 100),
          _SeedProduct(4, 'Tiramisù', 500, 150, 20),
          _SeedProduct(4, 'Zuppa Inglese', 500, 150, 18),
        ];
      case StarterCatalog.barCafe:
        return const [
          _SeedProduct(0, 'Espresso', 120, 30, 500),
          _SeedProduct(0, 'Cappuccino', 160, 45, 500),
          _SeedProduct(0, 'Caffè Latte', 180, 50, 500),
          _SeedProduct(1, 'Orange Juice', 300, 90, 60),
          _SeedProduct(1, 'Beer', 450, 150, 80),
          _SeedProduct(1, 'Aperol Spritz', 600, 200, 60),
          _SeedProduct(2, 'Croissant', 150, 40, 40),
          _SeedProduct(2, 'Muffin', 250, 70, 30),
          _SeedProduct(3, 'Toasted Sandwich', 450, 150, 25),
        ];
      case StarterCatalog.quickService:
        return const [
          _SeedProduct(0, 'Classic Burger', 750, 250, 60),
          _SeedProduct(0, 'Cheeseburger', 850, 300, 60),
          _SeedProduct(0, 'Chicken Wrap', 700, 230, 40),
          _SeedProduct(1, 'Fries', 350, 90, 100),
          _SeedProduct(1, 'Onion Rings', 400, 110, 50),
          _SeedProduct(2, 'Soft Drink', 250, 60, 200),
          _SeedProduct(2, 'Water', 150, 30, 200),
          _SeedProduct(3, 'Ice Cream', 300, 90, 40),
        ];
      case StarterCatalog.festival:
        return const [
          _SeedProduct(0, 'Panino Salsiccia', 500, 150, 100),
          _SeedProduct(0, 'Patatine Fritte', 400, 100, 100),
          _SeedProduct(0, 'Piadina', 600, 200, 80),
          _SeedProduct(1, 'Acqua 50cl', 100, 20, 300),
          _SeedProduct(1, 'Birra Media', 400, 130, 200),
          _SeedProduct(1, 'Coca Cola', 250, 80, 150),
        ];
    }
  }
}
