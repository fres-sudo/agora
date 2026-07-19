import 'package:database/database.dart';
import 'package:feature_products/data/sources/local/daos/combos_dao.dart';
import 'package:feature_products/domain/mappers/combo_mapper.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/combo_item.dart';
import 'package:catalog/repositories/combos_repository.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

class CombosRepositoryImpl extends Repository implements CombosRepository {
  CombosRepositoryImpl({required CombosDao combosDao, Talker? logger})
    : _combosDao = combosDao,
      super(logger);

  final CombosDao _combosDao;

  // ============================================================
  // HELPERS - Entity to Model conversion
  // ============================================================

  Future<Combo> _entityToModel(ComboEntity entity) async {
    final items = await _combosDao.getItemsByComboId(entity.id);
    return entity.toModel(items: items.map((i) => i.toModel()).toList());
  }

  CombosTableCompanion _toInsertCompanion(Combo combo) {
    return CombosTableCompanion.insert(
      name: combo.name,
      price: combo.priceCents,
      isEnabled: Value(combo.isEnabled),
    );
  }

  CombosTableCompanion _toUpdateCompanion(Combo combo) {
    return CombosTableCompanion(
      name: Value(combo.name),
      price: Value(combo.priceCents),
      isEnabled: Value(combo.isEnabled),
    );
  }

  Future<void> _insertItems(int comboId, List<ComboItem> items) async {
    for (final item in items) {
      await _combosDao.insertComboItem(
        ComboItemsTableCompanion.insert(
          comboId: comboId,
          productId: item.productId,
          productName: item.productName,
          quantity: Value(item.quantity),
        ),
      );
    }
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<Combo>> watchAllCombos() {
    return _combosDao
        .watchAllCombos()
        .asyncMap((entities) async {
          final combos = <Combo>[];
          for (final entity in entities) {
            combos.add(await _entityToModel(entity));
          }
          return combos;
        })
        .safeCode(logger);
  }

  @override
  Stream<Combo?> watchComboById(int id) {
    return _combosDao
        .watchComboById(id)
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
  Future<Result<Combo?>> getComboById(int id) =>
      safe('getComboById($id)', () async {
        final entity = await _combosDao.getComboById(id);
        if (entity == null) return null;
        return _entityToModel(entity);
      });

  @override
  Future<Result<int>> getCombosCount() =>
      safe('getCombosCount', () => _combosDao.getCombosCount());

  // ============================================================
  // COMBO OPERATIONS
  // ============================================================

  @override
  Future<Result<Combo>> createCombo(Combo combo) =>
      safe('createCombo(${combo.name})', () async {
        final id = await _combosDao.insertCombo(_toInsertCompanion(combo));
        await _insertItems(id, combo.items);
        return _entityToModel((await _combosDao.getComboById(id))!);
      });

  @override
  Future<Result<Combo>> updateCombo(Combo combo) =>
      safe('updateCombo(${combo.id})', () async {
        await _combosDao.updateCombo(combo.id, _toUpdateCompanion(combo));
        // Whole-list replace, no incremental diffing needed (v1 fixed
        // contents, no independent item lifecycle).
        await _combosDao.hardDeleteItemsByComboId(combo.id);
        await _insertItems(combo.id, combo.items);
        return _entityToModel((await _combosDao.getComboById(combo.id))!);
      });

  @override
  Future<Result<int>> deleteCombo(int id) => safe('deleteCombo($id)', () async {
    await _combosDao.softDeleteCombo(id);
    // Items aren't independently referenced elsewhere (no cascade to
    // constituent product stock — a combo isn't a stock-tracked SKU).
    await _combosDao.hardDeleteItemsByComboId(id);
    return id;
  });
}
