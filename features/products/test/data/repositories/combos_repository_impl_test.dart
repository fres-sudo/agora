import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_products/data/repositories/combos_repository_impl.dart';
import 'package:feature_products/data/sources/local/daos/combos_dao.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/combo_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AgoraDatabase db;
  late CombosDao combosDao;
  late CombosRepositoryImpl repository;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
    combosDao = CombosDao(db);
    repository = CombosRepositoryImpl(combosDao: combosDao);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertProduct(String name) {
    return db
        .into(db.productsTable)
        .insert(ProductsTableCompanion.insert(name: name));
  }

  group('CombosRepositoryImpl', () {
    test('createCombo persists the combo and its items', () async {
      final paninoId = await insertProduct('Panino');
      final patatineId = await insertProduct('Patatine');

      const combo = Combo(
        id: 0,
        name: 'Menu Completo',
        priceCents: 1000,
        items: [],
      );
      final withItems = combo.copyWith(
        items: [
          ComboItem(productId: paninoId, productName: 'Panino', quantity: 1),
          ComboItem(
            productId: patatineId,
            productName: 'Patatine',
            quantity: 1,
          ),
        ],
      );

      final result = await repository.createCombo(withItems);
      final created = result.unwrap();

      expect(created.id, isNot(0));
      expect(created.name, 'Menu Completo');
      expect(created.priceCents, 1000);
      expect(created.items, hasLength(2));
    });

    test(
      'updateCombo replaces the item list entirely (whole-list replace)',
      () async {
        final paninoId = await insertProduct('Panino');
        final patatineId = await insertProduct('Patatine');
        final bibitaId = await insertProduct('Bibita');

        final created = (await repository.createCombo(
          Combo(
            id: 0,
            name: 'Menu Completo',
            priceCents: 1000,
            items: [
              ComboItem(
                productId: paninoId,
                productName: 'Panino',
                quantity: 1,
              ),
              ComboItem(
                productId: patatineId,
                productName: 'Patatine',
                quantity: 1,
              ),
            ],
          ),
        )).unwrap();

        final updated = (await repository.updateCombo(
          created.copyWith(
            priceCents: 1200,
            items: [
              ComboItem(
                productId: bibitaId,
                productName: 'Bibita',
                quantity: 2,
              ),
            ],
          ),
        )).unwrap();

        expect(updated.priceCents, 1200);
        expect(updated.items, hasLength(1));
        expect(updated.items.single.productId, bibitaId);
        expect(updated.items.single.quantity, 2);
      },
    );

    test(
      'deleteCombo soft-deletes the combo without touching product rows',
      () async {
        final paninoId = await insertProduct('Panino');
        final created = (await repository.createCombo(
          Combo(
            id: 0,
            name: 'Menu Completo',
            priceCents: 1000,
            items: [
              ComboItem(
                productId: paninoId,
                productName: 'Panino',
                quantity: 1,
              ),
            ],
          ),
        )).unwrap();

        final deleteResult = await repository.deleteCombo(created.id);
        expect(deleteResult.unwrap(), created.id);

        final combos = await repository.watchAllCombos().first;
        expect(combos, isEmpty);

        final product = await db.select(db.productsTable).getSingle();
        expect(product.deletedAt, isNull);
      },
    );

    test('watchAllCombos streams active combos with their items', () async {
      final paninoId = await insertProduct('Panino');
      await repository.createCombo(
        Combo(
          id: 0,
          name: 'Menu Completo',
          priceCents: 1000,
          items: [
            ComboItem(productId: paninoId, productName: 'Panino', quantity: 1),
          ],
        ),
      );

      final combos = await repository.watchAllCombos().first;
      expect(combos, hasLength(1));
      expect(combos.single.items, hasLength(1));
    });
  });
}
