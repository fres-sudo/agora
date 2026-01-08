import 'package:agora/core/database/database.dart';
import 'package:agora/inventory/services/local/daos/stocks_dao.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/models/product/product_status.dart';
import 'package:agora/products/repositories/products_repository.dart';
import 'package:agora/products/services/local/daos/products_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'products_repository_test.mocks.dart';

@GenerateMocks([ProductsDao, StocksDao])
void main() {
  late MockProductsDao mockProductsDao;
  late MockStocksDao mockStocksDao;
  late ProductsRepositoryImpl repository;

  setUp(() {
    mockProductsDao = MockProductsDao();
    mockStocksDao = MockStocksDao();
    repository = ProductsRepositoryImpl(
      productsDao: mockProductsDao,
      stocksDao: mockStocksDao,
    );
  });

  group('ProductsRepositoryImpl', () {
    final productEntity = ProductEntity(
      id: 1,
      name: 'Product 1',
      description: 'Desc',
      categoryId: 1,
      cost: 50,
      price: 100,
      taxPercent: 10,
      status: 'active',
      trackStock: true,
      updatedAt: null, // nullable in table
      createdAt:
          DateTime.now(), // will be auto-set by drift usually, but here manually
      deletedAt: null,
      imageUrl: null,
      sku: 'SKU1',
    );

    final stockEntity = StockEntity(
      id: 1,
      productId: 1,
      quantity: 10,
      updatedAt: null,
      createdAt: DateTime.now(),
      deletedAt: null,
    );

    const productModel = Product(
      id: 1,
      name: 'Product 1',
      description: 'Desc',
      categoryId: 1,
      costCents: 50,
      priceCents: 100,
      taxPercent: 10,
      sku: 'SKU1',
      stockQuantity: 10,
      status: ProductStatus.active,
    );

    test('watchAllProducts emits products with stock', () async {
      when(
        mockProductsDao.watchAllProducts(),
      ).thenAnswer((_) => Stream.value([productEntity]));
      when(
        mockStocksDao.getStockByProductId(1),
      ).thenAnswer((_) async => stockEntity);

      final stream = repository.watchAllProducts();
      final products = await stream.first;

      expect(products.length, 1);
      expect(products.first, productModel);
      verify(mockProductsDao.watchAllProducts()).called(1);
      verify(mockStocksDao.getStockByProductId(1)).called(1);
    });

    test('watchProductsByCategory emits filtered products', () async {
      when(
        mockProductsDao.watchProductsByCategoryId(1),
      ).thenAnswer((_) => Stream.value([productEntity]));
      when(
        mockStocksDao.getStockByProductId(1),
      ).thenAnswer((_) async => stockEntity);

      final stream = repository.watchProductsByCategory(1);
      final products = await stream.first;

      expect(products.length, 1);
      expect(products.first, productModel);
    });

    test('watchProductById emits single product', () async {
      when(
        mockProductsDao.watchProductById(1),
      ).thenAnswer((_) => Stream.value(productEntity));
      when(
        mockStocksDao.getStockByProductId(1),
      ).thenAnswer((_) async => stockEntity);

      final stream = repository.watchProductById(1);
      final product = await stream.first;

      expect(product, productModel);
    });

    test('createProduct inserts into both DAOs and returns result', () async {
      when(mockProductsDao.insertProduct(any)).thenAnswer((_) async => 1);
      when(
        mockStocksDao.upsertStock(productId: 1, quantity: 10),
      ).thenAnswer((_) async {});

      final result = await repository.createProduct(productModel);

      final product = result.unwrap();
      expect(product.id, 1);
      verify(mockProductsDao.insertProduct(any)).called(1);
      verify(mockStocksDao.upsertStock(productId: 1, quantity: 10)).called(1);
    });

    test('updateProduct updates both DAOs', () async {
      when(mockProductsDao.updateProduct(1, any)).thenAnswer((_) async => true);
      when(
        mockStocksDao.upsertStock(productId: 1, quantity: 10),
      ).thenAnswer((_) async {});

      final result = await repository.updateProduct(productModel);

      expect(result.unwrap(), isA<Product>());
      verify(mockProductsDao.updateProduct(1, any)).called(1);
      verify(mockStocksDao.upsertStock(productId: 1, quantity: 10)).called(1);
    });

    test('deleteProduct soft deletes from both DAOs', () async {
      when(mockProductsDao.softDeleteProduct(1)).thenAnswer((_) async => true);
      when(mockStocksDao.softDeleteStock(1)).thenAnswer((_) async => true);

      final result = await repository.deleteProduct(1);

      expect(result.unwrap(), 1);
      verify(mockProductsDao.softDeleteProduct(1)).called(1);
      verify(mockStocksDao.softDeleteStock(1)).called(1);
    });
  });
}
