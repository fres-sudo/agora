import 'package:feature_products/data/sources/local/daos/categories_dao.dart';
import 'package:feature_products/domain/mappers/category_mapper.dart';
import 'package:catalog/models/category.dart';
import 'package:catalog/repositories/categories_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

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
