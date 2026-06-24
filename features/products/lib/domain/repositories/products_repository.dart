import 'package:result/result.dart';
import 'package:feature_products/domain/models/product.dart';

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
