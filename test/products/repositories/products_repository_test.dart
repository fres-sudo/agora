import 'package:database/database.dart';
import 'package:feature_inventory/feature_inventory.dart';
import 'package:feature_products/data/repositories/products_repository_impl.dart';
import 'package:feature_products/data/sources/local/daos/modifiers_dao.dart';
import 'package:feature_products/data/sources/local/daos/products_dao.dart';
import 'package:feature_products/feature_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'products_repository_test.mocks.dart';

@GenerateMocks([ProductsDao, StocksDao, ModifiersDao])
void main() {
  late MockProductsDao mockProductsDao;
  late MockStocksDao mockStocksDao;
  late MockModifiersDao mockModifiersDao;
  late ProductsRepositoryImpl repository;

  setUp(() {
    mockProductsDao = MockProductsDao();
    mockStocksDao = MockStocksDao();
    mockModifiersDao = MockModifiersDao();
    when(
      mockModifiersDao.getModifiersByProductId(any),
    ).thenAnswer((_) async => []);
    repository = ProductsRepositoryImpl(
      productsDao: mockProductsDao,
      stocksDao: mockStocksDao,
      modifiersDao: mockModifiersDao,
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
      createdAt: DateTime
          .now(), // will be auto-set by drift usually, but here manually
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

    test('watchAllProducts hydrates modifierGroups from linked modifiers',
        () async {
      final modifierEntity = ModifierEntity(
        id: 5,
        name: 'Size',
        isMultiSelect: false,
        updatedAt: null,
        createdAt: DateTime.now(),
        deletedAt: null,
      );
      final optionEntity = ModifierOptionEntity(
        id: 9,
        modifierId: 5,
        name: 'Large',
        priceChange: 100,
        updatedAt: null,
        createdAt: DateTime.now(),
        deletedAt: null,
      );

      when(
        mockProductsDao.watchAllProducts(),
      ).thenAnswer((_) => Stream.value([productEntity]));
      when(
        mockStocksDao.getStockByProductId(1),
      ).thenAnswer((_) async => stockEntity);
      when(
        mockModifiersDao.getModifiersByProductId(1),
      ).thenAnswer((_) async => [modifierEntity]);
      when(
        mockModifiersDao.getOptionsByModifierId(5),
      ).thenAnswer((_) async => [optionEntity]);

      final stream = repository.watchAllProducts();
      final products = await stream.first;

      expect(products.first.modifierGroups, hasLength(1));
      expect(products.first.modifierGroups.first.id, 5);
      expect(products.first.modifierGroups.first.name, 'Size');
      expect(products.first.modifierGroups.first.options, hasLength(1));
      expect(
        products.first.modifierGroups.first.options.first.priceChangeCents,
        100,
      );
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
