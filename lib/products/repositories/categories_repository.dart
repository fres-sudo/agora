import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:agora/products/services/local/daos/categories_dao.dart';
import 'package:agora/products/services/local/mappers/category_mapper.dart';
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

/// Implementation of [CategoriesRepository] using Drift DAOs.
class CategoriesRepositoryImpl extends Repository
    implements CategoriesRepository {
  CategoriesRepositoryImpl({
    required CategoriesDao categoriesDao,
    Talker? logger,
  }) : _categoriesDao = categoriesDao,
       super(logger);

  final CategoriesDao _categoriesDao;

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<Category>> watchAllCategories() {
    return _categoriesDao
        .watchAllCategories()
        .map((entities) => entities.map((e) => e.toModel()).toList())
        .safeCode(logger);
  }

  @override
  Stream<Category?> watchCategoryById(int id) {
    return _categoriesDao
        .watchCategoryById(id)
        .map((entity) => entity?.toModel())
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<Category?>> getCategoryById(int id) =>
      safe('getCategoryById($id)', () async {
        final entity = await _categoriesDao.getCategoryById(id);
        return entity?.toModel();
      });

  @override
  Future<Result<int>> getCategoriesCount() =>
      safe('getCategoriesCount', () => _categoriesDao.getCategoriesCount());

  // ============================================================
  // WRITE OPERATIONS - Optimistic Update Support
  // ============================================================

  @override
  Future<Result<Category>> createCategory(Category category) =>
      safe('createCategory(${category.name})', () async {
        final id = await _categoriesDao.insertCategory(
          category.toInsertCompanion(),
        );
        // Return the created category with its new ID
        return category.copyWith(id: id);
      });

  @override
  Future<Result<Category>> updateCategory(Category category) =>
      safe('updateCategory(${category.id})', () async {
        await _categoriesDao.updateCategory(
          category.id,
          category.toUpdateCompanion(),
        );
        // Return the updated category
        return category;
      });

  @override
  Future<Result<int>> deleteCategory(int id) =>
      safe('deleteCategory($id)', () async {
        await _categoriesDao.softDeleteCategory(id);
        return id;
      });

  @override
  Future<Result<bool>> restoreCategory(int id) =>
      safe('restoreCategory($id)', () => _categoriesDao.restoreCategory(id));
}
