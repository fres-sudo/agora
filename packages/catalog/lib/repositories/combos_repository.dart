import 'package:result/result.dart';
import 'package:catalog/models/combo.dart';

/// Repository interface for combo operations.
///
/// v1 combos are fixed-contents only (docs/features/03-combo-modifier-pricing.md):
/// there's no independent item-level CRUD like [ModifiersRepository] has for
/// options — [updateCombo] replaces the whole item list at once.
abstract interface class CombosRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all active combos.
  Stream<List<Combo>> watchAllCombos();

  /// Watches a single combo by ID.
  Stream<Combo?> watchComboById(int id);

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets a single combo by ID.
  Future<Result<Combo?>> getComboById(int id);

  /// Gets the total count of combos.
  Future<Result<int>> getCombosCount();

  // ============================================================
  // COMBO OPERATIONS
  // ============================================================

  /// Creates a new combo (with its items).
  /// Returns the created [Combo] with its new ID for optimistic updates.
  Future<Result<Combo>> createCombo(Combo combo);

  /// Updates an existing combo, replacing its item list entirely.
  /// Returns the updated [Combo] for optimistic updates.
  Future<Result<Combo>> updateCombo(Combo combo);

  /// Deletes a combo (soft delete). Never touches constituent product stock.
  /// Returns the deleted combo ID for optimistic updates.
  Future<Result<int>> deleteCombo(int id);
}
