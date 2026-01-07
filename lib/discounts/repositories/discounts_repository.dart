import 'package:agora/core/database/database.dart';
import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/discounts/services/local/daos/discounts_dao.dart';
import 'package:agora/discounts/models/discount/discount.dart';
import 'package:drift/drift.dart';
import 'package:talker/talker.dart';


/// Repository interface for discount operations.
///
/// All write operations return the affected entity to enable optimistic
/// updates in the UI layer.
abstract interface class DiscountsRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all active (non-deleted) discounts.
  Stream<List<Discount>> watchAllDiscounts();

  /// Watches only active and valid (non-expired) discounts.
  Stream<List<Discount>> watchActiveDiscounts();

  /// Watches a single discount by ID.
  Stream<Discount?> watchDiscountById(int id);

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets a discount by ID.
  Future<Result<Discount?>> getDiscountById(int id);

  /// Gets a discount by voucher code.
  Future<Result<Discount?>> getDiscountByCode(String code);

  /// Validates if a discount code is valid and active.
  /// Returns the discount if valid, null if invalid/expired/inactive.
  Future<Result<Discount?>> validateDiscountCode(String code);

  /// Gets the total count of discounts.
  Future<Result<int>> getDiscountsCount({bool? isActive});

  // ============================================================
  // WRITE OPERATIONS - Returns entity for optimistic updates
  // ============================================================

  /// Creates a new discount.
  /// Returns the created [Discount] with its new ID for optimistic updates.
  Future<Result<Discount>> createDiscount(Discount discount);

  /// Updates an existing discount.
  /// Returns the updated [Discount] for optimistic updates.
  Future<Result<Discount>> updateDiscount(Discount discount);

  /// Activates a discount.
  /// Returns the [Discount] for optimistic updates.
  Future<Result<Discount>> activateDiscount(int id);

  /// Deactivates a discount.
  /// Returns the [Discount] for optimistic updates.
  Future<Result<Discount>> deactivateDiscount(int id);

  /// Deletes a discount (soft delete).
  /// Returns the deleted discount ID for optimistic updates.
  Future<Result<int>> deleteDiscount(int id);
}

/// Implementation of [DiscountsRepository] using Drift DAOs.
class DiscountsRepositoryImpl extends Repository
    implements DiscountsRepository {
  DiscountsRepositoryImpl({required DiscountsDao discountsDao, Talker? logger})
    : _discountsDao = discountsDao,
      super(logger);

  final DiscountsDao _discountsDao;

  // ============================================================
  // HELPERS
  // ============================================================

  Discount _entityToModel(DiscountsTableData entity) {
    return Discount(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      type: DiscountType.values[entity.type],
      value: entity.value,
      isActive: entity.isActive,
      validUntil: entity.validUntil,
    );
  }

  DiscountsTableCompanion _modelToInsertCompanion(Discount discount) {
    return DiscountsTableCompanion.insert(
      name: discount.name,
      code: Value(discount.code),
      type: discount.type.index,
      value: discount.value,
      isActive: Value(discount.isActive),
      validUntil: Value(discount.validUntil),
    );
  }

  DiscountsTableCompanion _modelToUpdateCompanion(Discount discount) {
    return DiscountsTableCompanion(
      name: Value(discount.name),
      code: Value(discount.code),
      type: Value(discount.type.index),
      value: Value(discount.value),
      isActive: Value(discount.isActive),
      validUntil: Value(discount.validUntil),
    );
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<Discount>> watchAllDiscounts() {
    return _discountsDao
        .watchAllDiscounts()
        .map((entities) => entities.map(_entityToModel).toList())
        .safeCode(logger);
  }

  @override
  Stream<List<Discount>> watchActiveDiscounts() {
    return _discountsDao
        .watchActiveDiscounts()
        .map((entities) => entities.map(_entityToModel).toList())
        .safeCode(logger);
  }

  @override
  Stream<Discount?> watchDiscountById(int id) {
    return _discountsDao
        .watchDiscountById(id)
        .map((entity) => entity != null ? _entityToModel(entity) : null)
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<Discount?>> getDiscountById(int id) =>
      safe('getDiscountById($id)', () async {
        final entity = await _discountsDao.getDiscountById(id);
        return entity != null ? _entityToModel(entity) : null;
      });

  @override
  Future<Result<Discount?>> getDiscountByCode(String code) =>
      safe('getDiscountByCode($code)', () async {
        final entity = await _discountsDao.getDiscountByCode(code);
        return entity != null ? _entityToModel(entity) : null;
      });

  @override
  Future<Result<Discount?>> validateDiscountCode(String code) =>
      safe('validateDiscountCode($code)', () async {
        final entity = await _discountsDao.validateDiscountCode(code);
        return entity != null ? _entityToModel(entity) : null;
      });

  @override
  Future<Result<int>> getDiscountsCount({bool? isActive}) => safe(
    'getDiscountsCount',
    () => _discountsDao.getDiscountsCount(isActive: isActive),
  );

  // ============================================================
  // WRITE OPERATIONS - Optimistic Update Support
  // ============================================================

  @override
  Future<Result<Discount>> createDiscount(Discount discount) =>
      safe('createDiscount(${discount.name})', () async {
        final id = await _discountsDao.insertDiscount(
          _modelToInsertCompanion(discount),
        );
        // Return with new ID
        return discount.copyWith(id: id);
      });

  @override
  Future<Result<Discount>> updateDiscount(Discount discount) =>
      safe('updateDiscount(${discount.id})', () async {
        await _discountsDao.updateDiscount(
          discount.id,
          _modelToUpdateCompanion(discount),
        );
        return discount;
      });

  @override
  Future<Result<Discount>> activateDiscount(int id) =>
      safe('activateDiscount($id)', () async {
        await _discountsDao.activateDiscount(id);
        final entity = await _discountsDao.getDiscountById(id);
        return _entityToModel(entity!);
      });

  @override
  Future<Result<Discount>> deactivateDiscount(int id) =>
      safe('deactivateDiscount($id)', () async {
        await _discountsDao.deactivateDiscount(id);
        final entity = await _discountsDao.getDiscountById(id);
        return _entityToModel(entity!);
      });

  @override
  Future<Result<int>> deleteDiscount(int id) =>
      safe('deleteDiscount($id)', () async {
        await _discountsDao.softDeleteDiscount(id);
        return id;
      });
}
