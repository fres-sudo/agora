import 'package:database/database.dart';
import 'package:result/result.dart';
import 'package:result/result.dart';
import 'package:feature_products/domain/models/modifier_group.dart';
import 'package:feature_products/domain/models/modifier_option.dart';
import 'package:feature_products/data/sources/local/daos/modifiers_dao.dart';
import 'package:drift/drift.dart';
import 'package:talker/talker.dart';

/// Repository interface for modifier operations.
///
/// All write operations return the affected entity to enable optimistic
/// updates in the UI layer.
abstract interface class ModifiersRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all active modifier groups.
  Stream<List<ModifierGroup>> watchAllModifiers();

  /// Watches modifier groups linked to a specific product.
  Stream<List<ModifierGroup>> watchModifiersByProductId(int productId);

  /// Watches a single modifier group by ID.
  Stream<ModifierGroup?> watchModifierById(int id);

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets a single modifier group by ID.
  Future<Result<ModifierGroup?>> getModifierById(int id);

  /// Gets all modifiers linked to a product.
  Future<Result<List<ModifierGroup>>> getModifiersByProductId(int productId);

  /// Gets the total count of modifier groups.
  Future<Result<int>> getModifiersCount();

  // ============================================================
  // MODIFIER GROUP OPERATIONS
  // ============================================================

  /// Creates a new modifier group.
  /// Returns the created [ModifierGroup] with its new ID for optimistic updates.
  Future<Result<ModifierGroup>> createModifier(ModifierGroup modifier);

  /// Updates an existing modifier group.
  /// Returns the updated [ModifierGroup] for optimistic updates.
  Future<Result<ModifierGroup>> updateModifier(ModifierGroup modifier);

  /// Deletes a modifier group (soft delete).
  /// Returns the deleted modifier ID for optimistic updates.
  Future<Result<int>> deleteModifier(int id);

  // ============================================================
  // MODIFIER OPTION OPERATIONS
  // ============================================================

  /// Creates a new modifier option.
  /// Returns the created [ModifierOption] with its new ID for optimistic updates.
  Future<Result<ModifierOption>> createModifierOption({
    required int modifierId,
    required ModifierOption option,
  });

  /// Updates a modifier option.
  /// Returns the updated [ModifierOption] for optimistic updates.
  Future<Result<ModifierOption>> updateModifierOption(ModifierOption option);

  /// Deletes a modifier option.
  /// Returns the deleted option ID for optimistic updates.
  Future<Result<int>> deleteModifierOption(int id);

  // ============================================================
  // PRODUCT-MODIFIER LINKS
  // ============================================================

  /// Links a modifier group to a product.
  Future<Result<void>> linkModifierToProduct({
    required int modifierId,
    required int productId,
  });

  /// Unlinks a modifier group from a product.
  Future<Result<void>> unlinkModifierFromProduct({
    required int modifierId,
    required int productId,
  });

  /// Sets the modifiers for a product (replaces all existing links).
  Future<Result<void>> setProductModifiers({
    required int productId,
    required List<int> modifierIds,
  });
}
