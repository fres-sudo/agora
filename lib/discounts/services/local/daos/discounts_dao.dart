import 'package:agora/core/database/database.dart';
import 'package:agora/discounts/services/local/tables/discounts_table.dart';
import 'package:drift/drift.dart';

part 'discounts_dao.g.dart';

@DriftAccessor(tables: [DiscountsTable])
class DiscountsDao extends DatabaseAccessor<AgoraDatabase>
    with _$DiscountsDaoMixin {
  DiscountsDao(super.db);

  // Discount type constants
  static const int typePercentage = 0;
  static const int typeFixedAmount = 1;

  // ============================================================
  // READ OPERATIONS (Streams for CQRS pattern)
  // ============================================================

  /// Watches all active (non-deleted) discounts.
  Stream<List<DiscountsTableData>> watchAllDiscounts() {
    return (select(discountsTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Watches paginated discounts with optional filter.
  Stream<List<DiscountsTableData>> watchPaginatedDiscounts({
    required int limit,
    required int offset,
    bool? isActive,
  }) {
    return (select(discountsTable)
          ..where((t) {
            var condition = t.deletedAt.isNull();
            if (isActive != null) {
              condition = condition & t.isActive.equals(isActive);
            }
            return condition;
          })
          ..orderBy([(t) => OrderingTerm.asc(t.name)])
          ..limit(limit, offset: offset))
        .watch();
  }

  /// Watches a single discount by ID.
  Stream<DiscountsTableData?> watchDiscountById(int id) {
    return (select(discountsTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .watchSingleOrNull();
  }

  /// Gets a single discount by ID (Future-based).
  Future<DiscountsTableData?> getDiscountById(int id) {
    return (select(discountsTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Gets a discount by voucher code.
  Future<DiscountsTableData?> getDiscountByCode(String code) {
    return (select(discountsTable)
          ..where((t) => t.code.equals(code) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Watches only active and valid (non-expired) discounts.
  Stream<List<DiscountsTableData>> watchActiveDiscounts() {
    final now = DateTime.now();
    return (select(discountsTable)
          ..where(
            (t) =>
                t.deletedAt.isNull() &
                t.isActive.equals(true) &
                (t.validUntil.isNull() | t.validUntil.isBiggerOrEqualValue(now)),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Gets active and valid discounts (Future-based).
  Future<List<DiscountsTableData>> getActiveDiscounts() {
    final now = DateTime.now();
    return (select(discountsTable)
          ..where(
            (t) =>
                t.deletedAt.isNull() &
                t.isActive.equals(true) &
                (t.validUntil.isNull() | t.validUntil.isBiggerOrEqualValue(now)),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Validates if a discount code is valid and active.
  Future<DiscountsTableData?> validateDiscountCode(String code) async {
    final now = DateTime.now();
    return (select(discountsTable)
          ..where(
            (t) =>
                t.code.equals(code) &
                t.deletedAt.isNull() &
                t.isActive.equals(true) &
                (t.validUntil.isNull() | t.validUntil.isBiggerOrEqualValue(now)),
          ))
        .getSingleOrNull();
  }

  /// Gets the total count of discounts with optional filter.
  Future<int> getDiscountsCount({bool? isActive}) async {
    final count = discountsTable.id.count();
    final query = selectOnly(discountsTable)..addColumns([count]);

    var condition = discountsTable.deletedAt.isNull();
    if (isActive != null) {
      condition = condition & discountsTable.isActive.equals(isActive);
    }
    query.where(condition);

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Watches discounts by type (percentage or fixed).
  Stream<List<DiscountsTableData>> watchDiscountsByType(int type) {
    return (select(discountsTable)
          ..where((t) => t.type.equals(type) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  // ============================================================
  // WRITE OPERATIONS
  // ============================================================

  /// Inserts a new discount and returns the new ID.
  Future<int> insertDiscount(DiscountsTableCompanion companion) {
    return into(discountsTable).insert(companion);
  }

  /// Updates an existing discount.
  Future<bool> updateDiscount(int id, DiscountsTableCompanion companion) {
    return (update(discountsTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Toggles the active status of a discount.
  Future<bool> toggleDiscountActive(int id, bool isActive) {
    return (update(discountsTable)..where((t) => t.id.equals(id)))
        .write(
          DiscountsTableCompanion(
            isActive: Value(isActive),
            updatedAt: Value(DateTime.now()),
          ),
        )
        .then((rows) => rows > 0);
  }

  /// Activates a discount.
  Future<bool> activateDiscount(int id) {
    return toggleDiscountActive(id, true);
  }

  /// Deactivates a discount.
  Future<bool> deactivateDiscount(int id) {
    return toggleDiscountActive(id, false);
  }

  // ============================================================
  // DELETE OPERATIONS
  // ============================================================

  /// Soft deletes a discount by setting deletedAt.
  Future<bool> softDeleteDiscount(int id) {
    return (update(discountsTable)..where((t) => t.id.equals(id)))
        .write(DiscountsTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Restores a soft-deleted discount.
  Future<bool> restoreDiscount(int id) {
    return (update(discountsTable)..where((t) => t.id.equals(id)))
        .write(const DiscountsTableCompanion(deletedAt: Value(null)))
        .then((rows) => rows > 0);
  }

  /// Permanently deletes a discount.
  Future<int> hardDeleteDiscount(int id) {
    return (delete(discountsTable)..where((t) => t.id.equals(id))).go();
  }
}
