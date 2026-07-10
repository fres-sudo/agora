import 'package:discounts/models/discount.dart';
import 'package:result/result.dart';

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

  /// Increments the usage count of a discount by one (called when a discount
  /// is applied to a completed sale). No-op-safe if the discount is missing.
  Future<Result<void>> incrementUsage(int id);
}
