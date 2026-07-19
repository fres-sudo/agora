import 'package:database/database.dart';
import 'package:drift/drift.dart';

part 'combos_dao.g.dart';

@DriftAccessor(tables: [CombosTable, ComboItemsTable])
class CombosDao extends DatabaseAccessor<AgoraDatabase> with _$CombosDaoMixin {
  CombosDao(super.db);

  // ============================================================
  // COMBOS - READ OPERATIONS
  // ============================================================

  /// Watches all active combos.
  Stream<List<ComboEntity>> watchAllCombos() {
    return (select(combosTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watches a single combo by ID.
  Stream<ComboEntity?> watchComboById(int id) {
    return (select(combosTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// Gets a single combo by ID (Future-based).
  Future<ComboEntity?> getComboById(int id) {
    return (select(
      combosTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Gets the total count of active combos.
  Future<int> getCombosCount() async {
    final count = combosTable.id.count();
    final query = selectOnly(combosTable)
      ..addColumns([count])
      ..where(combosTable.deletedAt.isNull());
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ============================================================
  // COMBOS - WRITE OPERATIONS
  // ============================================================

  /// Inserts a new combo and returns the new ID.
  Future<int> insertCombo(CombosTableCompanion companion) {
    return into(combosTable).insert(companion);
  }

  /// Updates an existing combo.
  Future<bool> updateCombo(int id, CombosTableCompanion companion) {
    return (update(combosTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  // ============================================================
  // COMBOS - DELETE OPERATIONS
  // ============================================================

  /// Soft deletes a combo by setting deletedAt.
  Future<bool> softDeleteCombo(int id) {
    return (update(combosTable)..where((t) => t.id.equals(id)))
        .write(CombosTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  // ============================================================
  // COMBO ITEMS - READ OPERATIONS
  // ============================================================

  /// Gets all items for a specific combo (Future-based).
  Future<List<ComboItemEntity>> getItemsByComboId(int comboId) {
    return (select(comboItemsTable)
          ..where((t) => t.comboId.equals(comboId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  // ============================================================
  // COMBO ITEMS - WRITE OPERATIONS
  // ============================================================

  /// Inserts a new combo item and returns the new ID.
  Future<int> insertComboItem(ComboItemsTableCompanion companion) {
    return into(comboItemsTable).insert(companion);
  }

  /// Permanently deletes all items for a combo (v1 combos are edited as a
  /// whole — no independent item lifecycle, see [CombosRepository.updateCombo]).
  Future<int> hardDeleteItemsByComboId(int comboId) {
    return (delete(
      comboItemsTable,
    )..where((t) => t.comboId.equals(comboId))).go();
  }
}
