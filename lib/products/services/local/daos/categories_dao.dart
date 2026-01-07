import 'package:agora/core/database/database.dart';
import 'package:agora/products/services/local/tables/categories_table.dart';
import 'package:drift/drift.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoriesDao extends DatabaseAccessor<AgoraDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  // ============================================================
  // READ OPERATIONS (Streams for CQRS pattern)
  // ============================================================

  /// Watches all active (non-deleted) categories.
  Stream<List<CategoryEntity>> watchAllCategories() {
    return (select(categoriesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watches paginated categories for table display.
  Stream<List<CategoryEntity>> watchPaginatedCategories({
    required int limit,
    required int offset,
  }) {
    return (select(categoriesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)])
          ..limit(limit, offset: offset))
        .watch();
  }

  /// Watches a single category by ID.
  Stream<CategoryEntity?> watchCategoryById(int id) {
    return (select(categoriesTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// Gets a single category by ID (Future-based).
  Future<CategoryEntity?> getCategoryById(int id) {
    return (select(
      categoriesTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Gets the total count of active categories.
  Future<int> getCategoriesCount() async {
    final count = categoriesTable.id.count();
    final query = selectOnly(categoriesTable)
      ..addColumns([count])
      ..where(categoriesTable.deletedAt.isNull());
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ============================================================
  // WRITE OPERATIONS
  // ============================================================

  /// Inserts a new category and returns the new ID.
  Future<int> insertCategory(CategoriesTableCompanion companion) {
    return into(categoriesTable).insert(companion);
  }

  /// Updates an existing category.
  Future<bool> updateCategory(int id, CategoriesTableCompanion companion) {
    return (update(categoriesTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  // ============================================================
  // DELETE OPERATIONS
  // ============================================================

  /// Soft deletes a category by setting deletedAt.
  Future<bool> softDeleteCategory(int id) {
    return (update(categoriesTable)..where((t) => t.id.equals(id)))
        .write(CategoriesTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Restores a soft-deleted category.
  Future<bool> restoreCategory(int id) {
    return (update(categoriesTable)..where((t) => t.id.equals(id)))
        .write(const CategoriesTableCompanion(deletedAt: Value(null)))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes a category.
  Future<int> hardDeleteCategory(int id) {
    return (delete(categoriesTable)..where((t) => t.id.equals(id))).go();
  }
}
