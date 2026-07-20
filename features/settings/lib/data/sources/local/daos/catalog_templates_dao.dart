import 'package:database/database.dart';
import 'package:drift/drift.dart';

part 'catalog_templates_dao.g.dart';

@DriftAccessor(tables: [CatalogTemplatesTable])
class CatalogTemplatesDao extends DatabaseAccessor<AgoraDatabase>
    with _$CatalogTemplatesDaoMixin {
  CatalogTemplatesDao(super.db);

  /// Watches all saved templates, newest first.
  Stream<List<CatalogTemplateEntity>> watchAllTemplates() {
    return (select(catalogTemplatesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Gets a single template by id.
  Future<CatalogTemplateEntity?> getTemplateById(int id) {
    return (select(
      catalogTemplatesTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Inserts a new template row, returning its new id.
  Future<int> insertTemplate({
    required String name,
    required String snapshotJson,
  }) {
    return into(catalogTemplatesTable).insert(
      CatalogTemplatesTableCompanion.insert(
        name: name,
        snapshotJson: snapshotJson,
      ),
    );
  }

  /// Soft-deletes a template by id.
  Future<bool> softDeleteTemplate(int id) {
    return (update(catalogTemplatesTable)..where((t) => t.id.equals(id)))
        .write(CatalogTemplatesTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }
}
