import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:feature_products/data/sources/local/daos/products_dao.dart';
import 'package:feature_products/domain/mappers/product_mapper.dart';
import 'package:feature_products/domain/models/product.dart';
import 'package:feature_products/domain/repositories/products_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

class ProductsRepositoryImpl extends Repository implements ProductsRepository {
  ProductsRepositoryImpl({
    required ProductsDao productsDao,
    required StocksDao stocksDao,
    Talker? logger,
  }) : _productsDao = productsDao,
       _stocksDao = stocksDao,
       super(logger);

  final ProductsDao _productsDao;
  final StocksDao _stocksDao;

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<Product>> watchAllProducts() {
    return _productsDao
        .watchAllProducts()
        .asyncMap((entities) async {
          final products = <Product>[];
          for (final entity in entities) {
            final stock = await _stocksDao.getStockByProductId(entity.id);
            products.add(entity.toModel(stockQuantity: stock?.quantity ?? 0));
          }
          return products;
        })
        .safeCode(logger);
  }

  @override
  Stream<List<Product>> watchProductsByCategory(int categoryId) {
    return _productsDao
        .watchProductsByCategoryId(categoryId)
        .asyncMap((entities) async {
          final products = <Product>[];
          for (final entity in entities) {
            final stock = await _stocksDao.getStockByProductId(entity.id);
            products.add(entity.toModel(stockQuantity: stock?.quantity ?? 0));
          }
          return products;
        })
        .safeCode(logger);
  }

  @override
  Stream<Product?> watchProductById(int id) {
    return _productsDao
        .watchProductById(id)
        .asyncMap((entity) async {
          if (entity == null) return null;
          final stock = await _stocksDao.getStockByProductId(entity.id);
          return entity.toModel(stockQuantity: stock?.quantity ?? 0);
        })
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<Product?>> getProductById(int id) =>
      safe('getProductById($id)', () async {
        final entity = await _productsDao.getProductById(id);
        if (entity == null) return null;
        final stock = await _stocksDao.getStockByProductId(entity.id);
        return entity.toModel(stockQuantity: stock?.quantity ?? 0);
      });

  @override
  Future<Result<Product?>> getProductBySku(String sku) =>
      safe('getProductBySku($sku)', () async {
        final entity = await _productsDao.getProductBySku(sku);
        if (entity == null) return null;
        final stock = await _stocksDao.getStockByProductId(entity.id);
        return entity.toModel(stockQuantity: stock?.quantity ?? 0);
      });

  @override
  Future<Result<int>> getProductsCount({int? categoryId, String? searchTerm}) =>
      safe(
        'getProductsCount',
        () => _productsDao.getProductsCount(
          categoryId: categoryId,
          searchTerm: searchTerm,
        ),
      );

  // ============================================================
  // WRITE OPERATIONS - Optimistic Update Support
  // ============================================================

  @override
  Future<Result<Product>> createProduct(Product product) => safe(
    'createProduct(${product.name})',
    () async {
      // Insert product
      final id = await _productsDao.insertProduct(product.toInsertCompanion());

      // Initialize stock
      await _stocksDao.upsertStock(
        productId: id,
        quantity: product.stockQuantity,
      );

      // Return the created product with its new ID for optimistic updates
      return product.copyWith(id: id);
    },
  );

  @override
  Future<Result<Product>> updateProduct(Product product) => safe(
    'updateProduct(${product.id})',
    () async {
      // Update product
      await _productsDao.updateProduct(product.id, product.toUpdateCompanion());

      // Update stock
      await _stocksDao.upsertStock(
        productId: product.id,
        quantity: product.stockQuantity,
      );

      // Return the updated product for optimistic updates
      return product;
    },
  );

  @override
  Future<Result<int>> deleteProduct(int id) =>
      safe('deleteProduct($id)', () async {
        await _productsDao.softDeleteProduct(id);
        await _stocksDao.softDeleteStock(id);
        return id;
      });

  @override
  Future<Result<bool>> restoreProduct(int id) =>
      safe('restoreProduct($id)', () async {
        await _productsDao.restoreProduct(id);
        await _stocksDao.restoreStock(id);
        return true;
      });
}
