import 'package:database/database.dart';
import 'package:feature_products/data/sources/local/daos/modifiers_dao.dart';
import 'package:feature_products/domain/models/modifier_group.dart';
import 'package:feature_products/domain/models/modifier_option.dart';
import 'package:feature_products/domain/repositories/modifiers_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';
class ModifiersRepositoryImpl extends Repository
    implements ModifiersRepository {
  ModifiersRepositoryImpl({required ModifiersDao modifiersDao, Talker? logger})
    : _modifiersDao = modifiersDao,
      super(logger);

  final ModifiersDao _modifiersDao;

  // ============================================================
  // HELPERS - Entity to Model conversion
  // ============================================================

  Future<ModifierGroup> _entityToModel(ModifierEntity entity) async {
    final options = await _modifiersDao.getOptionsByModifierId(entity.id);
    return ModifierGroup(
      id: entity.id,
      name: entity.name,
      isMultiSelect: entity.isMultiSelect,
      options: options
          .map(
            (o) => ModifierOption(
              id: o.id,
              name: o.name,
              priceChangeCents: o.priceChange,
            ),
          )
          .toList(),
    );
  }

  ModifiersTableCompanion _toInsertCompanion(ModifierGroup modifier) {
    return ModifiersTableCompanion.insert(
      name: modifier.name,
      isMultiSelect: Value(modifier.isMultiSelect),
    );
  }

  ModifiersTableCompanion _toUpdateCompanion(ModifierGroup modifier) {
    return ModifiersTableCompanion(
      name: Value(modifier.name),
      isMultiSelect: Value(modifier.isMultiSelect),
    );
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<ModifierGroup>> watchAllModifiers() {
    return _modifiersDao
        .watchAllModifiers()
        .asyncMap((entities) async {
          final modifiers = <ModifierGroup>[];
          for (final entity in entities) {
            modifiers.add(await _entityToModel(entity));
          }
          return modifiers;
        })
        .safeCode(logger);
  }

  @override
  Stream<List<ModifierGroup>> watchModifiersByProductId(int productId) {
    return _modifiersDao
        .watchModifiersByProductId(productId)
        .asyncMap((entities) async {
          final modifiers = <ModifierGroup>[];
          for (final entity in entities) {
            modifiers.add(await _entityToModel(entity));
          }
          return modifiers;
        })
        .safeCode(logger);
  }

  @override
  Stream<ModifierGroup?> watchModifierById(int id) {
    return _modifiersDao
        .watchModifierById(id)
        .asyncMap((entity) async {
          if (entity == null) return null;
          return _entityToModel(entity);
        })
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<ModifierGroup?>> getModifierById(int id) =>
      safe('getModifierById($id)', () async {
        final entity = await _modifiersDao.getModifierById(id);
        if (entity == null) return null;
        return _entityToModel(entity);
      });

  @override
  Future<Result<List<ModifierGroup>>> getModifiersByProductId(int productId) =>
      safe('getModifiersByProductId($productId)', () async {
        final entities = await _modifiersDao.getModifiersByProductId(productId);
        final modifiers = <ModifierGroup>[];
        for (final entity in entities) {
          modifiers.add(await _entityToModel(entity));
        }
        return modifiers;
      });

  @override
  Future<Result<int>> getModifiersCount() =>
      safe('getModifiersCount', () => _modifiersDao.getModifiersCount());

  // ============================================================
  // MODIFIER GROUP OPERATIONS
  // ============================================================

  @override
  Future<Result<ModifierGroup>> createModifier(ModifierGroup modifier) =>
      safe('createModifier(${modifier.name})', () async {
        // Insert modifier group
        final id = await _modifiersDao.insertModifier(
          _toInsertCompanion(modifier),
        );

        // Insert options
        final createdOptions = <ModifierOption>[];
        for (final option in modifier.options) {
          final optionId = await _modifiersDao.insertModifierOption(
            ModifierOptionsTableCompanion.insert(
              modifierId: id,
              name: option.name,
              priceChange: Value(option.priceChangeCents),
            ),
          );
          createdOptions.add(option.copyWith(id: optionId));
        }

        // Return the created modifier with new ID and option IDs
        return modifier.copyWith(id: id, options: createdOptions);
      });

  @override
  Future<Result<ModifierGroup>> updateModifier(ModifierGroup modifier) =>
      safe('updateModifier(${modifier.id})', () async {
        await _modifiersDao.updateModifier(
          modifier.id,
          _toUpdateCompanion(modifier),
        );
        // Return the updated modifier
        return modifier;
      });

  @override
  Future<Result<int>> deleteModifier(int id) =>
      safe('deleteModifier($id)', () async {
        await _modifiersDao.softDeleteModifier(id);
        return id;
      });

  // ============================================================
  // MODIFIER OPTION OPERATIONS
  // ============================================================

  @override
  Future<Result<ModifierOption>> createModifierOption({
    required int modifierId,
    required ModifierOption option,
  }) => safe('createModifierOption($modifierId, ${option.name})', () async {
    final id = await _modifiersDao.insertModifierOption(
      ModifierOptionsTableCompanion.insert(
        modifierId: modifierId,
        name: option.name,
        priceChange: Value(option.priceChangeCents),
      ),
    );
    return option.copyWith(id: id);
  });

  @override
  Future<Result<ModifierOption>> updateModifierOption(ModifierOption option) =>
      safe('updateModifierOption(${option.id})', () async {
        await _modifiersDao.updateModifierOption(
          option.id,
          ModifierOptionsTableCompanion(
            name: Value(option.name),
            priceChange: Value(option.priceChangeCents),
          ),
        );
        return option;
      });

  @override
  Future<Result<int>> deleteModifierOption(int id) =>
      safe('deleteModifierOption($id)', () async {
        await _modifiersDao.hardDeleteModifierOption(id);
        return id;
      });

  // ============================================================
  // PRODUCT-MODIFIER LINKS
  // ============================================================

  @override
  Future<Result<void>> linkModifierToProduct({
    required int modifierId,
    required int productId,
  }) => safe('linkModifierToProduct($modifierId -> $productId)', () async {
    await _modifiersDao.linkProductToModifier(
      productId: productId,
      modifierId: modifierId,
    );
  });

  @override
  Future<Result<void>> unlinkModifierFromProduct({
    required int modifierId,
    required int productId,
  }) => safe('unlinkModifierFromProduct($modifierId -x- $productId)', () async {
    await _modifiersDao.unlinkProductFromModifier(
      productId: productId,
      modifierId: modifierId,
    );
  });

  @override
  Future<Result<void>> setProductModifiers({
    required int productId,
    required List<int> modifierIds,
  }) => safe(
    'setProductModifiers($productId, [${modifierIds.length} modifiers])',
    () async {
      // Remove all existing links
      await _modifiersDao.unlinkAllModifiersFromProduct(productId);

      // Add new links
      for (final modifierId in modifierIds) {
        await _modifiersDao.linkProductToModifier(
          productId: productId,
          modifierId: modifierId,
        );
      }
    },
  );
}
