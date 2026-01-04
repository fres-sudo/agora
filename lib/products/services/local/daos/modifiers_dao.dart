import 'package:agora/core/database/database.dart';
import 'package:agora/products/services/local/tables/modifiers_table.dart';
import 'package:agora/products/services/local/tables/products_table.dart';
import 'package:drift/drift.dart';

part 'modifiers_dao.g.dart';

@DriftAccessor(
  tables: [
    ModifiersTable,
    ModifierOptionsTable,
    ProductModifierLinksTable,
    ProductsTable,
  ],
)
class ModifiersDao extends DatabaseAccessor<AgoraDatabase>
    with _$ModifiersDaoMixin {
  ModifiersDao(super.db);

  // ============================================================
  // MODIFIERS - READ OPERATIONS
  // ============================================================

  /// Watches all active modifiers.
  Stream<List<ModifierEntity>> watchAllModifiers() {
    return (select(modifiersTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watches paginated modifiers for table display.
  Stream<List<ModifierEntity>> watchPaginatedModifiers({
    required int limit,
    required int offset,
  }) {
    return (select(modifiersTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)])
          ..limit(limit, offset: offset))
        .watch();
  }

  /// Watches a single modifier by ID.
  Stream<ModifierEntity?> watchModifierById(int id) {
    return (select(modifiersTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// Gets a single modifier by ID (Future-based).
  Future<ModifierEntity?> getModifierById(int id) {
    return (select(
      modifiersTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  /// Gets the total count of active modifiers.
  Future<int> getModifiersCount() async {
    final count = modifiersTable.id.count();
    final query = selectOnly(modifiersTable)
      ..addColumns([count])
      ..where(modifiersTable.deletedAt.isNull());
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ============================================================
  // MODIFIERS - WRITE OPERATIONS
  // ============================================================

  /// Inserts a new modifier and returns the new ID.
  Future<int> insertModifier(ModifiersTableCompanion companion) {
    return into(modifiersTable).insert(companion);
  }

  /// Updates an existing modifier.
  Future<bool> updateModifier(int id, ModifiersTableCompanion companion) {
    return (update(modifiersTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  // ============================================================
  // MODIFIERS - DELETE OPERATIONS
  // ============================================================

  /// Soft deletes a modifier by setting deletedAt.
  Future<bool> softDeleteModifier(int id) {
    return (update(modifiersTable)..where((t) => t.id.equals(id)))
        .write(ModifiersTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Restores a soft-deleted modifier.
  Future<bool> restoreModifier(int id) {
    return (update(modifiersTable)..where((t) => t.id.equals(id)))
        .write(const ModifiersTableCompanion(deletedAt: Value(null)))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes a modifier.
  Future<int> hardDeleteModifier(int id) {
    return (delete(modifiersTable)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================
  // MODIFIER OPTIONS - READ OPERATIONS
  // ============================================================

  /// Watches all options for a specific modifier.
  Stream<List<ModifierOptionEntity>> watchOptionsByModifierId(int modifierId) {
    return (select(modifierOptionsTable)
          ..where((t) => t.modifierId.equals(modifierId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Gets all options for a specific modifier (Future-based).
  Future<List<ModifierOptionEntity>> getOptionsByModifierId(int modifierId) {
    return (select(modifierOptionsTable)
          ..where((t) => t.modifierId.equals(modifierId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Gets a single modifier option by ID.
  Future<ModifierOptionEntity?> getModifierOptionById(int id) {
    return (select(
      modifierOptionsTable,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  // ============================================================
  // MODIFIER OPTIONS - WRITE OPERATIONS
  // ============================================================

  /// Inserts a new modifier option and returns the new ID.
  Future<int> insertModifierOption(ModifierOptionsTableCompanion companion) {
    return into(modifierOptionsTable).insert(companion);
  }

  /// Updates an existing modifier option.
  Future<bool> updateModifierOption(
    int id,
    ModifierOptionsTableCompanion companion,
  ) {
    return (update(modifierOptionsTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  // ============================================================
  // MODIFIER OPTIONS - DELETE OPERATIONS
  // ============================================================

  /// Soft deletes a modifier option.
  Future<bool> softDeleteModifierOption(int id) {
    return (update(modifierOptionsTable)..where((t) => t.id.equals(id)))
        .write(ModifierOptionsTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes a modifier option.
  Future<int> hardDeleteModifierOption(int id) {
    return (delete(modifierOptionsTable)..where((t) => t.id.equals(id))).go();
  }

  /// Permanently deletes all options for a modifier.
  Future<int> hardDeleteOptionsByModifierId(int modifierId) {
    return (delete(
      modifierOptionsTable,
    )..where((t) => t.modifierId.equals(modifierId))).go();
  }

  // ============================================================
  // PRODUCT-MODIFIER LINKS - READ OPERATIONS
  // ============================================================

  /// Watches all modifiers linked to a product.
  Stream<List<ModifierEntity>> watchModifiersByProductId(int productId) {
    final query =
        select(modifiersTable).join([
            innerJoin(
              productModifierLinksTable,
              productModifierLinksTable.modifierId.equalsExp(modifiersTable.id),
            ),
          ])
          ..where(
            productModifierLinksTable.productId.equals(productId) &
                modifiersTable.deletedAt.isNull(),
          )
          ..orderBy([OrderingTerm.asc(modifiersTable.name)]);

    return query.watch().map(
      (rows) => rows.map((row) => row.readTable(modifiersTable)).toList(),
    );
  }

  /// Gets all modifiers linked to a product (Future-based).
  Future<List<ModifierEntity>> getModifiersByProductId(int productId) async {
    final query =
        select(modifiersTable).join([
            innerJoin(
              productModifierLinksTable,
              productModifierLinksTable.modifierId.equalsExp(modifiersTable.id),
            ),
          ])
          ..where(
            productModifierLinksTable.productId.equals(productId) &
                modifiersTable.deletedAt.isNull(),
          )
          ..orderBy([OrderingTerm.asc(modifiersTable.name)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(modifiersTable)).toList();
  }

  /// Gets all product IDs linked to a modifier.
  Future<List<int>> getProductIdsByModifierId(int modifierId) async {
    final query = select(productModifierLinksTable)
      ..where((t) => t.modifierId.equals(modifierId));
    final rows = await query.get();
    return rows.map((row) => row.productId).toList();
  }

  // ============================================================
  // PRODUCT-MODIFIER LINKS - WRITE OPERATIONS
  // ============================================================

  /// Links a product to a modifier.
  Future<int> linkProductToModifier({
    required int productId,
    required int modifierId,
  }) {
    return into(productModifierLinksTable).insert(
      ProductModifierLinksTableCompanion.insert(
        productId: productId,
        modifierId: modifierId,
      ),
    );
  }

  /// Unlinks a product from a modifier.
  Future<int> unlinkProductFromModifier({
    required int productId,
    required int modifierId,
  }) {
    return (delete(productModifierLinksTable)..where(
          (t) =>
              t.productId.equals(productId) & t.modifierId.equals(modifierId),
        ))
        .go();
  }

  /// Removes all modifier links for a product.
  Future<int> unlinkAllModifiersFromProduct(int productId) {
    return (delete(
      productModifierLinksTable,
    )..where((t) => t.productId.equals(productId))).go();
  }

  /// Removes all product links for a modifier.
  Future<int> unlinkAllProductsFromModifier(int modifierId) {
    return (delete(
      productModifierLinksTable,
    )..where((t) => t.modifierId.equals(modifierId))).go();
  }
}
