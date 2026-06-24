import 'package:result/result.dart';
import 'package:result/result.dart';
import 'package:feature_products/domain/models/category.dart';
import 'package:feature_products/data/sources/local/daos/categories_dao.dart';
import 'package:feature_products/domain/mappers/category_mapper.dart';
import 'package:talker/talker.dart';

/// Repository interface for category operations.
///
/// All write operations return the affected entity to enable optimistic
/// updates in the UI layer.
abstract interface class CategoriesRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all active categories.
  Stream<List<Category>> watchAllCategories();

  /// Watches a single category by ID.
  Stream<Category?> watchCategoryById(int id);

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets a single category by ID.
  Future<Result<Category?>> getCategoryById(int id);

  /// Gets the total count of categories.
  Future<Result<int>> getCategoriesCount();

  // ============================================================
  // WRITE OPERATIONS - Returns entity for optimistic updates
  // ============================================================

  /// Creates a new category.
  /// Returns the created [Category] with its new ID for optimistic updates.
  Future<Result<Category>> createCategory(Category category);

  /// Updates an existing category.
  /// Returns the updated [Category] for optimistic updates.
  Future<Result<Category>> updateCategory(Category category);

  /// Deletes a category (soft delete).
  /// Returns the deleted category ID for optimistic updates.
  Future<Result<int>> deleteCategory(int id);

  /// Restores a soft-deleted category.
  Future<Result<bool>> restoreCategory(int id);
}
