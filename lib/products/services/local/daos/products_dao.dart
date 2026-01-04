import 'package:agora/core/database/database.dart';
import 'package:agora/products/services/local/tables/categories_table.dart';
import 'package:agora/products/services/local/tables/products_table.dart';
import 'package:drift/drift.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [ProductsTable, CategoriesTable])
class ProductsDao extends DatabaseAccessor<AgoraDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.db);

  // ============================================================
  // READ OPERATIONS (Streams for CQRS pattern)
  // ============================================================

  /// Watches all active (non-deleted) products.
  Stream<List<ProductEntity>> watchAllProducts() {
    return (select(productsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watches paginated products with optional filters.
  Stream<List<ProductEntity>> watchPaginatedProducts({
    required int limit,
    required int offset,
    int? categoryId,
    String? searchTerm,
  }) {
    return (select(productsTable)
          ..where((t) {
            var condition = t.deletedAt.isNull();
            if (categoryId != null) {
              condition = condition & t.categoryId.equals(categoryId);
            }
            if (searchTerm != null && searchTerm.isNotEmpty) {
              condition =
                  condition &
                  (t.name.like('%$searchTerm%') |
                      t.description.like('%$searchTerm%') |
                      t.sku.like('%$searchTerm%'));
            }
            return condition;
          })
          ..orderBy([(t) => OrderingTerm.asc(t.name)])
          ..limit(limit, offset: offset))
        .watch();
  }

  /// Watches products filtered by category.
  Stream<List<ProductEntity>> watchProductsByCategoryId(int categoryId) {
    return (select(productsTable)
          ..where((t) => t.deletedAt.isNull() & t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watches a single product by ID.
  Stream<ProductEntity?> watchProductById(int id) {
    return (select(productsTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// Gets a single product by ID (Future-based).
  Future<ProductEntity?> getProductById(int id) {
    return (select(
      productsTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Gets a product by SKU/barcode.
  Future<ProductEntity?> getProductBySku(String sku) {
    return (select(productsTable)
          ..where((t) => t.sku.equals(sku) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Gets the total count of active products with optional filters.
  Future<int> getProductsCount({int? categoryId, String? searchTerm}) async {
    final count = productsTable.id.count();
    final query = selectOnly(productsTable)..addColumns([count]);

    var condition = productsTable.deletedAt.isNull();
    if (categoryId != null) {
      condition = condition & productsTable.categoryId.equals(categoryId);
    }
    if (searchTerm != null && searchTerm.isNotEmpty) {
      condition =
          condition &
          (productsTable.name.like('%$searchTerm%') |
              productsTable.description.like('%$searchTerm%') |
              productsTable.sku.like('%$searchTerm%'));
    }
    query.where(condition);

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ============================================================
  // WRITE OPERATIONS
  // ============================================================

  /// Inserts a new product and returns the new ID.
  Future<int> insertProduct(ProductsTableCompanion companion) {
    return into(productsTable).insert(companion);
  }

  /// Updates an existing product.
  Future<bool> updateProduct(int id, ProductsTableCompanion companion) {
    return (update(productsTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  // ============================================================
  // DELETE OPERATIONS
  // ============================================================

  /// Soft deletes a product by setting deletedAt.
  Future<bool> softDeleteProduct(int id) {
    return (update(productsTable)..where((t) => t.id.equals(id)))
        .write(ProductsTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Restores a soft-deleted product.
  Future<bool> restoreProduct(int id) {
    return (update(productsTable)..where((t) => t.id.equals(id)))
        .write(const ProductsTableCompanion(deletedAt: Value(null)))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes a product.
  Future<int> hardDeleteProduct(int id) {
    return (delete(productsTable)..where((t) => t.id.equals(id))).go();
  }
}
