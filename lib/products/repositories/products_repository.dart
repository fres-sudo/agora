import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/services/local/daos/products_dao.dart';
import 'package:agora/products/services/local/mappers/product_mapper.dart';
import 'package:agora/inventory/services/local/daos/stocks_dao.dart';
import 'package:talker/talker.dart';

/// Repository interface for product operations.
///
/// All write operations return the affected entity to enable optimistic
/// updates in the UI layer.
abstract interface class ProductsRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all active products with their stock quantities.
  Stream<List<Product>> watchAllProducts();

  /// Watches products filtered by category.
  Stream<List<Product>> watchProductsByCategory(int categoryId);

  /// Watches a single product by ID.
  Stream<Product?> watchProductById(int id);

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets a single product by ID.
  Future<Result<Product?>> getProductById(int id);

  /// Gets a product by SKU/barcode.
  Future<Result<Product?>> getProductBySku(String sku);

  /// Gets the total count of products.
  Future<Result<int>> getProductsCount({int? categoryId, String? searchTerm});

  // ============================================================
  // WRITE OPERATIONS - Returns entity for optimistic updates
  // ============================================================

  /// Creates a new product.
  /// Returns the created [Product] with its new ID for optimistic updates.
  Future<Result<Product>> createProduct(Product product);

  /// Updates an existing product.
  /// Returns the updated [Product] for optimistic updates.
  Future<Result<Product>> updateProduct(Product product);

  /// Deletes a product (soft delete).
  /// Returns the deleted product ID for optimistic updates.
  Future<Result<int>> deleteProduct(int id);

  /// Restores a soft-deleted product.
  Future<Result<bool>> restoreProduct(int id);
}

/// Implementation of [ProductsRepository] using Drift DAOs.
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
