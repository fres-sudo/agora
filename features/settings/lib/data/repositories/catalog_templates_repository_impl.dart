import 'dart:convert';

import 'package:database/database.dart';
import 'package:feature_settings/data/sources/local/daos/catalog_templates_dao.dart';
import 'package:catalog/models/catalog_snapshot.dart';
import 'package:catalog/models/catalog_template.dart';
import 'package:catalog/models/combo_item.dart';
import 'package:catalog/repositories/catalog_templates_repository.dart';
import 'package:catalog/repositories/categories_repository.dart';
import 'package:catalog/repositories/combos_repository.dart';
import 'package:catalog/repositories/modifiers_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

/// Implements season-to-season catalog templates
/// (docs/features/06-season-to-season-catalog-reuse.md) by composing the
/// existing catalog repositories rather than writing to their tables
/// directly — every insert/delete goes through the same
/// create/delete methods the rest of the app uses (so stock
/// initialization, soft-delete cascades, etc. all stay correct), wrapped in
/// one [AgoraDatabase.transaction] for atomicity.
class CatalogTemplatesRepositoryImpl extends Repository
    implements CatalogTemplatesRepository {
  CatalogTemplatesRepositoryImpl({
    required CatalogTemplatesDao catalogTemplatesDao,
    required AgoraDatabase database,
    required CategoriesRepository categoriesRepository,
    required ProductsRepository productsRepository,
    required ModifiersRepository modifiersRepository,
    required CombosRepository combosRepository,
    Talker? logger,
  }) : _dao = catalogTemplatesDao,
       _database = database,
       _categoriesRepository = categoriesRepository,
       _productsRepository = productsRepository,
       _modifiersRepository = modifiersRepository,
       _combosRepository = combosRepository,
       super(logger);

  final CatalogTemplatesDao _dao;
  final AgoraDatabase _database;
  final CategoriesRepository _categoriesRepository;
  final ProductsRepository _productsRepository;
  final ModifiersRepository _modifiersRepository;
  final CombosRepository _combosRepository;

  // ============================================================
  // HELPERS
  // ============================================================

  CatalogTemplate _entityToModel(CatalogTemplateEntity entity) {
    return CatalogTemplate(
      id: entity.id,
      name: entity.name,
      savedAt: entity.createdAt,
      snapshot: CatalogSnapshot.fromJson(
        jsonDecode(entity.snapshotJson) as Map<String, dynamic>,
      ),
    );
  }

  /// Unwraps a [Result], throwing on failure so it's caught by the
  /// enclosing [safe] block and rolls back the surrounding transaction
  /// instead of leaving a partial restore in place.
  T _unwrap<T>(Result<T> result) {
    return result.fold(
      success: (value) => value,
      error: (error) => throw Exception(error.toString()),
    );
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<CatalogTemplate>> watchAllTemplates() {
    return _dao
        .watchAllTemplates()
        .map((entities) => entities.map(_entityToModel).toList())
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<CatalogTemplate?>> getTemplateById(int id) =>
      safe('getTemplateById($id)', () async {
        final entity = await _dao.getTemplateById(id);
        return entity == null ? null : _entityToModel(entity);
      });

  // ============================================================
  // SAVE
  // ============================================================

  @override
  Future<Result<CatalogTemplate>> saveCurrentAsTemplate(String name) =>
      safe('saveCurrentAsTemplate($name)', () async {
        final snapshot = CatalogSnapshot(
          categories: await _categoriesRepository.watchAllCategories().first,
          modifierGroups: await _modifiersRepository.watchAllModifiers().first,
          products: await _productsRepository.watchAllProducts().first,
          combos: await _combosRepository.watchAllCombos().first,
        );

        final id = await _dao.insertTemplate(
          name: name,
          snapshotJson: jsonEncode(snapshot.toJson()),
        );
        final entity = await _dao.getTemplateById(id);
        return _entityToModel(entity!);
      });

  // ============================================================
  // RESTORE
  // ============================================================

  @override
  Future<Result<void>> restoreTemplate(
    int templateId, {
    required bool replaceExisting,
  }) => safe(
    'restoreTemplate($templateId, replace: $replaceExisting)',
    () async {
      final entity = await _dao.getTemplateById(templateId);
      if (entity == null) {
        throw Exception('Catalog template $templateId not found');
      }
      final snapshot = CatalogSnapshot.fromJson(
        jsonDecode(entity.snapshotJson) as Map<String, dynamic>,
      );

      await _database.transaction(() async {
        if (replaceExisting) {
          for (final combo in await _combosRepository.watchAllCombos().first) {
            _unwrap(await _combosRepository.deleteCombo(combo.id));
          }
          for (final product
              in await _productsRepository.watchAllProducts().first) {
            _unwrap(await _productsRepository.deleteProduct(product.id));
          }
          for (final group
              in await _modifiersRepository.watchAllModifiers().first) {
            _unwrap(await _modifiersRepository.deleteModifier(group.id));
          }
          for (final category
              in await _categoriesRepository.watchAllCategories().first) {
            _unwrap(await _categoriesRepository.deleteCategory(category.id));
          }
        }

        // Old snapshot id -> newly-inserted row id, so later entities (e.g. a
        // product's categoryId, a combo item's productId) can be relinked.
        final categoryIdMap = <int, int>{};
        for (final category in snapshot.categories) {
          final created = _unwrap(
            await _categoriesRepository.createCategory(
              category.copyWith(id: 0),
            ),
          );
          categoryIdMap[category.id] = created.id;
        }

        final groupIdMap = <int, int>{};
        for (final group in snapshot.modifierGroups) {
          final created = _unwrap(
            await _modifiersRepository.createModifier(group.copyWith(id: 0)),
          );
          groupIdMap[group.id] = created.id;
        }

        final productIdMap = <int, int>{};
        for (final product in snapshot.products) {
          final sku = product.sku;
          final hasActiveSkuConflict =
              !replaceExisting &&
              sku != null &&
              _unwrap(await _productsRepository.getProductBySku(sku)) != null;

          // Stock is deliberately never part of a template — a restored
          // product starts with whatever stock behavior a newly-created
          // product normally gets. In additive mode, the current product
          // keeps a conflicting SKU and the fresh restored copy starts
          // without one so active SKU uniqueness remains intact.
          final created = _unwrap(
            await _productsRepository.createProduct(
              product.copyWith(
                id: 0,
                sku: hasActiveSkuConflict ? null : sku,
                categoryId:
                    categoryIdMap[product.categoryId] ?? product.categoryId,
                stockQuantity: 0,
              ),
            ),
          );
          productIdMap[product.id] = created.id;

          final newGroupIds = product.modifierGroups
              .map((g) => groupIdMap[g.id])
              .whereType<int>()
              .toList();
          if (newGroupIds.isNotEmpty) {
            _unwrap(
              await _modifiersRepository.setProductModifiers(
                productId: created.id,
                modifierIds: newGroupIds,
              ),
            );
          }
        }

        for (final combo in snapshot.combos) {
          final remappedItems = combo.items
              .map<ComboItem?>((item) {
                final newProductId = productIdMap[item.productId];
                return newProductId == null
                    ? null
                    : item.copyWith(productId: newProductId);
              })
              .whereType<ComboItem>()
              .toList();
          _unwrap(
            await _combosRepository.createCombo(
              combo.copyWith(id: 0, items: remappedItems),
            ),
          );
        }
      });
    },
  );

  // ============================================================
  // DELETE
  // ============================================================

  @override
  Future<Result<int>> deleteTemplate(int id) =>
      safe('deleteTemplate($id)', () async {
        await _dao.softDeleteTemplate(id);
        return id;
      });
}
