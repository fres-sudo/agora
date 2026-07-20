import 'package:result/result.dart';
import 'package:catalog/models/catalog_template.dart';

/// Repository interface for saving/restoring named catalog templates
/// (docs/features/06-season-to-season-catalog-reuse.md) — a season-to-season
/// snapshot of categories, products, modifier groups and combos. Never
/// touches stock levels.
abstract interface class CatalogTemplatesRepository {
  /// Watches all saved templates, newest first.
  Stream<List<CatalogTemplate>> watchAllTemplates();

  /// Gets a single template by id.
  Future<Result<CatalogTemplate?>> getTemplateById(int id);

  /// Snapshots the current live catalog (categories, products, modifier
  /// groups, combos — excluding stock) and saves it as a new named
  /// template.
  Future<Result<CatalogTemplate>> saveCurrentAsTemplate(String name);

  /// Restores [templateId] into the live catalog, inserting fresh rows for
  /// every category/product/modifier group/combo in the snapshot.
  ///
  /// If [replaceExisting] is true, the current catalog is soft-deleted
  /// first, in the same transaction. If false, the restored template is
  /// added alongside whatever is already there. Either way, a failure
  /// partway through leaves the catalog exactly as it was before the call.
  Future<Result<void>> restoreTemplate(
    int templateId, {
    required bool replaceExisting,
  });

  /// Deletes a saved template. Never touches the live catalog.
  Future<Result<int>> deleteTemplate(int id);
}
