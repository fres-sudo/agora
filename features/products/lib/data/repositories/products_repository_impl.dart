import 'package:feature_products/data/sources/local/daos/modifiers_dao.dart';
import 'package:feature_products/data/sources/local/daos/products_dao.dart';
import 'package:feature_products/domain/mappers/modifier_mapper.dart';
import 'package:feature_products/domain/mappers/product_mapper.dart';
import 'package:catalog/models/modifier_group.dart';
import 'package:catalog/models/product.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:inventory_contracts/inventory_contracts.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

class ProductsRepositoryImpl extends Repository implements ProductsRepository {
  ProductsRepositoryImpl({
    required ProductsDao productsDao,
    required InventoryRepository inventoryRepository,
    required ModifiersDao modifiersDao,
    Talker? logger,
  }) : _productsDao = productsDao,
       _inventoryRepository = inventoryRepository,
       _modifiersDao = modifiersDao,
       super(logger);

  final ProductsDao _productsDao;
  final InventoryRepository _inventoryRepository;
  final ModifiersDao _modifiersDao;

  // ============================================================
  // HELPERS
  // ============================================================

  /// Loads the modifier groups (with their options) linked to [productId].
  ///
  /// Mirrors [ModifiersRepositoryImpl]'s hydration; kept here too (rather
  /// than depending on `ModifiersRepository`) to match the existing direct
  /// DAO-dependency style this repository already uses for stock.
  Future<List<ModifierGroup>> _getModifierGroups(int productId) async {
    final entities = await _modifiersDao.getModifiersByProductId(productId);
    final groups = <ModifierGroup>[];
    for (final entity in entities) {
      final options = await _modifiersDao.getOptionsByModifierId(entity.id);
      groups.add(
        entity.toModel(options: options.map((o) => o.toModel()).toList()),
      );
    }
    return groups;
  }

  /// Resolves the current stock quantity for [productId] via
  /// [InventoryRepository] — never `feature_inventory`'s DAO directly (see
  /// GitHub issue #4). Falls back to 0 on error, matching the old DAO-based
  /// code's `stock?.quantity ?? 0` null-safety.
  Future<int> _stockQuantityFor(int productId) async {
    final result = await _inventoryRepository.getStockByProductId(productId);
    return result.fold(
      success: (stock) => stock?.quantity ?? 0,
      error: (_) => 0,
    );
  }

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
            final quantity = await _stockQuantityFor(entity.id);
            final modifierGroups = await _getModifierGroups(entity.id);
            products.add(
              entity.toModel(
                stockQuantity: quantity,
                modifierGroups: modifierGroups,
              ),
            );
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
            final quantity = await _stockQuantityFor(entity.id);
            final modifierGroups = await _getModifierGroups(entity.id);
            products.add(
              entity.toModel(
                stockQuantity: quantity,
                modifierGroups: modifierGroups,
              ),
            );
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
          final quantity = await _stockQuantityFor(entity.id);
          final modifierGroups = await _getModifierGroups(entity.id);
          return entity.toModel(
            stockQuantity: quantity,
            modifierGroups: modifierGroups,
          );
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
        final quantity = await _stockQuantityFor(entity.id);
        final modifierGroups = await _getModifierGroups(entity.id);
        return entity.toModel(
          stockQuantity: quantity,
          modifierGroups: modifierGroups,
        );
      });

  @override
  Future<Result<Product?>> getProductBySku(String sku) =>
      safe('getProductBySku($sku)', () async {
        final entity = await _productsDao.getProductBySku(sku);
        if (entity == null) return null;
        final quantity = await _stockQuantityFor(entity.id);
        final modifierGroups = await _getModifierGroups(entity.id);
        return entity.toModel(
          stockQuantity: quantity,
          modifierGroups: modifierGroups,
        );
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
      await _inventoryRepository.initializeStock(
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
      await _inventoryRepository.initializeStock(
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
        await _inventoryRepository.softDeleteStock(id);
        return id;
      });

  @override
  Future<Result<bool>> restoreProduct(int id) =>
      safe('restoreProduct($id)', () async {
        await _productsDao.restoreProduct(id);
        await _inventoryRepository.restoreStock(id);
        return true;
      });
}
