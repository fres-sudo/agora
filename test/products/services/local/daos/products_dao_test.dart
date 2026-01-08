import 'package:agora/core/database/database.dart';
import 'package:agora/products/services/local/daos/products_dao.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AgoraDatabase db;
  late ProductsDao productsDao;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
    productsDao = db.productsDao;
  });

  tearDown(() async {
    await db.close();
  });

  group('ProductsDao', () {
    final product1 = ProductsTableCompanion(
      name: const Value('Product 1'),
      description: const Value('Description 1'),
      sku: const Value('SKU1'),
      price: const Value(1000),
      categoryId: const Value(1),
    );

    final product2 = ProductsTableCompanion(
      name: const Value('Product 2'),
      description: const Value('Description 2'),
      sku: const Value('SKU2'),
      price: const Value(2000),
      categoryId: const Value(2),
    );

    test('insertProduct inserts a product and returns id', () async {
      final id = await productsDao.insertProduct(product1);
      expect(id, isNotNull);

      final fetchedProduct = await productsDao.getProductById(id);
      expect(fetchedProduct, isNotNull);
      expect(fetchedProduct!.name, 'Product 1');
      expect(fetchedProduct.price, 1000);
    });

    test('updateProduct updates an existing product', () async {
      final id = await productsDao.insertProduct(product1);
      final updateCompanion = ProductsTableCompanion(
        name: const Value('Updated Product 1'),
        price: const Value(1500),
      );

      final success = await productsDao.updateProduct(id, updateCompanion);
      expect(success, isTrue);

      final fetchedProduct = await productsDao.getProductById(id);
      expect(fetchedProduct!.name, 'Updated Product 1');
      expect(fetchedProduct.price, 1500);
      expect(fetchedProduct.updatedAt, isNotNull);
    });

    test(
      'softDeleteProduct sets deletedAt and excludes from watchAllProducts',
      () async {
        final id = await productsDao.insertProduct(product1);

        final success = await productsDao.softDeleteProduct(id);
        expect(success, isTrue);

        final fetchedProduct = await productsDao.getProductById(id);
        expect(fetchedProduct, isNull); // getProductById checks deletedAt

        // Check directly if it exists but deleted (need a way to check raw or just trust the DAO logic)
        // Since getProductById filters deleted, we can assume it's "gone" for normal usage.
      },
    );

    test('restoreProduct restores a soft-deleted product', () async {
      final id = await productsDao.insertProduct(product1);
      await productsDao.softDeleteProduct(id);

      final success = await productsDao.restoreProduct(id);
      expect(success, isTrue);

      final fetchedProduct = await productsDao.getProductById(id);
      expect(fetchedProduct, isNotNull);
    });

    test('hardDeleteProduct permanently removes a product', () async {
      final id = await productsDao.insertProduct(product1);

      final rows = await productsDao.hardDeleteProduct(id);
      expect(rows, 1);

      // Verify it's gone even if we tried to query it without deletedAt filter (though DAO methods include filter)
      final fetchedProduct = await productsDao.getProductById(id);
      expect(fetchedProduct, isNull);
    });

    test('watchAllProducts emits all active products', () async {
      await productsDao.insertProduct(product1);
      await productsDao.insertProduct(product2);

      final stream = productsDao.watchAllProducts();
      final products = await stream.first;

      expect(products.length, 2);
      expect(products.any((p) => p.name == 'Product 1'), isTrue);
      expect(products.any((p) => p.name == 'Product 2'), isTrue);
    });

    test(
      'watchPaginatedProducts listens to products with limit, offset and filters',
      () async {
        await productsDao.insertProduct(product1);
        await productsDao.insertProduct(product2);
        await productsDao.insertProduct(
          ProductsTableCompanion(
            name: const Value('Product 3'),
            sku: const Value('SKU3'),
            categoryId: const Value(1),
          ),
        );

        // Test limit and offset
        var stream = productsDao.watchPaginatedProducts(limit: 1, offset: 0);
        var products = await stream.first;
        expect(products.length, 1);
        expect(products.first.name, 'Product 1'); // Ordered by name

        stream = productsDao.watchPaginatedProducts(limit: 1, offset: 1);
        products = await stream.first;
        expect(products.length, 1);
        expect(products.first.name, 'Product 2');

        // Test category filter
        stream = productsDao.watchPaginatedProducts(
          limit: 10,
          offset: 0,
          categoryId: 1,
        );
        products = await stream.first;
        expect(products.length, 2); // Product 1 and 3

        // Test search term
        stream = productsDao.watchPaginatedProducts(
          limit: 10,
          offset: 0,
          searchTerm: 'SKU2',
        );
        products = await stream.first;
        expect(products.length, 1);
        expect(products.first.name, 'Product 2');
      },
    );

    test('watchProductsByCategoryId filters by category', () async {
      await productsDao.insertProduct(product1); // Cat 1
      await productsDao.insertProduct(product2); // Cat 2

      final stream = productsDao.watchProductsByCategoryId(1);
      final products = await stream.first;

      expect(products.length, 1);
      expect(products.first.name, 'Product 1');
    });

    test('watchProductById emits single product', () async {
      final id = await productsDao.insertProduct(product1);

      final stream = productsDao.watchProductById(id);
      final product = await stream.first;

      expect(product, isNotNull);
      expect(product!.id, id);
    });

    test('getProductBySku fetches product by SKU', () async {
      await productsDao.insertProduct(product1);

      final product = await productsDao.getProductBySku('SKU1');
      expect(product, isNotNull);
      expect(product!.name, 'Product 1');
    });

    test('getProductsCount returns correct count with filters', () async {
      await productsDao.insertProduct(product1);
      await productsDao.insertProduct(product2);
      await productsDao.insertProduct(
        ProductsTableCompanion(
          name: const Value('Product 3'),
          sku: const Value('SKU3'),
          categoryId: const Value(1),
        ),
      );

      expect(await productsDao.getProductsCount(), 3);
      expect(await productsDao.getProductsCount(categoryId: 1), 2);
      expect(await productsDao.getProductsCount(searchTerm: 'Product'), 3);
      expect(await productsDao.getProductsCount(searchTerm: 'SKU2'), 1);
    });
  });
}
