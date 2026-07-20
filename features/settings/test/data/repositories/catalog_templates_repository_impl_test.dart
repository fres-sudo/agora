import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_settings/data/repositories/catalog_templates_repository_impl.dart';
import 'package:feature_settings/data/sources/local/daos/catalog_templates_dao.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result/result.dart';

// Fakes rather than mocks/the real `feature_products` implementations —
// `feature_settings` must never import `feature_products` (no cross-feature
// imports, see CLAUDE.md). These fakes are deliberately minimal in-memory
// stores; the goal here is to test `CatalogTemplatesRepositoryImpl`'s own
// orchestration (id remapping, replace-vs-merge, transaction wrapping), not
// to re-test the Categories/Products/Modifiers/Combos repositories
// themselves (already covered in `features/products`'s own test suite).

class _FakeCategoriesRepository implements CategoriesRepository {
  final categories = <int, Category>{};
  int _nextId = 1;

  @override
  Stream<List<Category>> watchAllCategories() =>
      Stream.value(categories.values.toList());

  @override
  Stream<Category?> watchCategoryById(int id) => Stream.value(categories[id]);

  @override
  Future<Result<Category?>> getCategoryById(int id) async =>
      Result.ok(categories[id]);

  @override
  Future<Result<int>> getCategoriesCount() async =>
      Result.ok(categories.length);

  @override
  Future<Result<Category>> createCategory(Category category) async {
    final created = category.copyWith(id: _nextId++);
    categories[created.id] = created;
    return Result.ok(created);
  }

  @override
  Future<Result<Category>> updateCategory(Category category) async {
    categories[category.id] = category;
    return Result.ok(category);
  }

  @override
  Future<Result<int>> deleteCategory(int id) async {
    categories.remove(id);
    return Result.ok(id);
  }

  @override
  Future<Result<bool>> restoreCategory(int id) async => Result.ok(true);
}

class _FakeProductsRepository implements ProductsRepository {
  final products = <int, Product>{};
  int _nextId = 1;

  @override
  Stream<List<Product>> watchAllProducts() =>
      Stream.value(products.values.toList());

  @override
  Stream<List<Product>> watchProductsByCategory(int categoryId) => Stream.value(
    products.values.where((p) => p.categoryId == categoryId).toList(),
  );

  @override
  Stream<Product?> watchProductById(int id) => Stream.value(products[id]);

  @override
  Future<Result<Product?>> getProductById(int id) async =>
      Result.ok(products[id]);

  @override
  Future<Result<Product?>> getProductBySku(String sku) async =>
      Result.ok(products.values.where((p) => p.sku == sku).firstOrNull);

  @override
  Future<Result<int>> getProductsCount({int? categoryId, String? searchTerm}) =>
      throw UnimplementedError();

  @override
  Future<Result<List<String>>> getPrepStations() => throw UnimplementedError();

  @override
  Future<Result<Product>> createProduct(Product product) async {
    final created = product.copyWith(id: _nextId++);
    products[created.id] = created;
    return Result.ok(created);
  }

  @override
  Future<Result<Product>> updateProduct(Product product) async {
    products[product.id] = product;
    return Result.ok(product);
  }

  @override
  Future<Result<int>> deleteProduct(int id) async {
    products.remove(id);
    return Result.ok(id);
  }

  @override
  Future<Result<bool>> restoreProduct(int id) async => Result.ok(true);
}

class _FakeModifiersRepository implements ModifiersRepository {
  final groups = <int, ModifierGroup>{};
  final productLinks = <int, List<int>>{};
  int _nextGroupId = 1;
  int _nextOptionId = 1;

  @override
  Stream<List<ModifierGroup>> watchAllModifiers() =>
      Stream.value(groups.values.toList());

  @override
  Stream<List<ModifierGroup>> watchModifiersByProductId(int productId) =>
      throw UnimplementedError();

  @override
  Stream<ModifierGroup?> watchModifierById(int id) => Stream.value(groups[id]);

  @override
  Future<Result<ModifierGroup?>> getModifierById(int id) async =>
      Result.ok(groups[id]);

  @override
  Future<Result<List<ModifierGroup>>> getModifiersByProductId(int productId) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> getModifiersCount() async => Result.ok(groups.length);

  @override
  Future<Result<ModifierGroup>> createModifier(ModifierGroup modifier) async {
    final options = modifier.options
        .map((o) => o.copyWith(id: _nextOptionId++))
        .toList();
    final created = modifier.copyWith(id: _nextGroupId++, options: options);
    groups[created.id] = created;
    return Result.ok(created);
  }

  @override
  Future<Result<ModifierGroup>> updateModifier(ModifierGroup modifier) async {
    groups[modifier.id] = modifier;
    return Result.ok(modifier);
  }

  @override
  Future<Result<int>> deleteModifier(int id) async {
    groups.remove(id);
    return Result.ok(id);
  }

  @override
  Future<Result<ModifierOption>> createModifierOption({
    required int modifierId,
    required ModifierOption option,
  }) => throw UnimplementedError();

  @override
  Future<Result<ModifierOption>> updateModifierOption(ModifierOption option) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> deleteModifierOption(int id) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> linkModifierToProduct({
    required int modifierId,
    required int productId,
  }) => throw UnimplementedError();

  @override
  Future<Result<void>> unlinkModifierFromProduct({
    required int modifierId,
    required int productId,
  }) => throw UnimplementedError();

  @override
  Future<Result<void>> setProductModifiers({
    required int productId,
    required List<int> modifierIds,
  }) async {
    productLinks[productId] = modifierIds;
    return const Result.ok(null);
  }
}

class _FakeCombosRepository implements CombosRepository {
  final combos = <int, Combo>{};
  int _nextId = 1;

  @override
  Stream<List<Combo>> watchAllCombos() => Stream.value(combos.values.toList());

  @override
  Stream<Combo?> watchComboById(int id) => Stream.value(combos[id]);

  @override
  Future<Result<Combo?>> getComboById(int id) async => Result.ok(combos[id]);

  @override
  Future<Result<int>> getCombosCount() async => Result.ok(combos.length);

  @override
  Future<Result<Combo>> createCombo(Combo combo) async {
    final created = combo.copyWith(id: _nextId++);
    combos[created.id] = created;
    return Result.ok(created);
  }

  @override
  Future<Result<Combo>> updateCombo(Combo combo) async {
    combos[combo.id] = combo;
    return Result.ok(combo);
  }

  @override
  Future<Result<int>> deleteCombo(int id) async {
    combos.remove(id);
    return Result.ok(id);
  }
}

void main() {
  late AgoraDatabase db;
  late CatalogTemplatesDao dao;
  late _FakeCategoriesRepository categoriesRepository;
  late _FakeProductsRepository productsRepository;
  late _FakeModifiersRepository modifiersRepository;
  late _FakeCombosRepository combosRepository;
  late CatalogTemplatesRepositoryImpl repository;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
    dao = CatalogTemplatesDao(db);
    categoriesRepository = _FakeCategoriesRepository();
    productsRepository = _FakeProductsRepository();
    modifiersRepository = _FakeModifiersRepository();
    combosRepository = _FakeCombosRepository();
    repository = CatalogTemplatesRepositoryImpl(
      catalogTemplatesDao: dao,
      database: db,
      categoriesRepository: categoriesRepository,
      productsRepository: productsRepository,
      modifiersRepository: modifiersRepository,
      combosRepository: combosRepository,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('CatalogTemplatesRepositoryImpl', () {
    test('saveCurrentAsTemplate snapshots the current catalog (excluding stock '
        'from what matters for a restore)', () async {
      final category = (await categoriesRepository.createCategory(
        const Category(id: 0, name: 'Food'),
      )).unwrap();
      final group = (await modifiersRepository.createModifier(
        const ModifierGroup(
          id: 0,
          name: 'Size',
          isMultiSelect: false,
          options: [
            ModifierOption(id: 0, name: 'Large', priceChangeCents: 100),
          ],
        ),
      )).unwrap();
      await productsRepository.createProduct(
        Product(
          id: 0,
          name: 'Panino',
          categoryId: category.id,
          priceCents: 500,
          costCents: 150,
          stockQuantity: 42,
          modifierGroups: [group],
        ),
      );

      final saved = (await repository.saveCurrentAsTemplate(
        'Sagra 2026',
      )).unwrap();

      expect(saved.name, 'Sagra 2026');
      expect(saved.snapshot.categories, hasLength(1));
      expect(saved.snapshot.products, hasLength(1));
      expect(saved.snapshot.modifierGroups, hasLength(1));
    });

    test('restoreTemplate(replaceExisting: false) adds fresh rows alongside '
        'the existing catalog, relinking category/modifier ids and resetting '
        'stock', () async {
      final category = (await categoriesRepository.createCategory(
        const Category(id: 0, name: 'Food'),
      )).unwrap();
      final group = (await modifiersRepository.createModifier(
        const ModifierGroup(
          id: 0,
          name: 'Size',
          isMultiSelect: false,
          options: [
            ModifierOption(id: 0, name: 'Large', priceChangeCents: 100),
          ],
        ),
      )).unwrap();
      final product = (await productsRepository.createProduct(
        Product(
          id: 0,
          name: 'Panino',
          categoryId: category.id,
          priceCents: 500,
          costCents: 150,
          stockQuantity: 42,
          modifierGroups: [group],
        ),
      )).unwrap();
      await combosRepository.createCombo(
        Combo(
          id: 0,
          name: 'Menu',
          priceCents: 900,
          items: [ComboItem(productId: product.id, productName: product.name)],
        ),
      );

      final saved = (await repository.saveCurrentAsTemplate(
        'Sagra 2026',
      )).unwrap();

      // Simulate the operator having already started a new category
      // before remembering the template exists.
      await categoriesRepository.createCategory(
        const Category(id: 0, name: 'Already here'),
      );

      final restoreResult = await repository.restoreTemplate(
        saved.id,
        replaceExisting: false,
      );
      expect(restoreResult.isSuccess, isTrue);

      // Additive: the original category, the one created after saving
      // the template, and the newly-restored one all coexist.
      expect(categoriesRepository.categories, hasLength(3));
      expect(productsRepository.products, hasLength(2));
      expect(modifiersRepository.groups, hasLength(2));
      expect(combosRepository.combos, hasLength(2));

      final restoredProduct = productsRepository.products.values.firstWhere(
        (p) => p.id != product.id,
      );
      // Stock is never part of a template restore.
      expect(restoredProduct.stockQuantity, 0);
      // categoryId was remapped to the newly-inserted category, not the
      // stale id captured in the snapshot.
      expect(restoredProduct.categoryId, isNot(category.id));
      expect(
        categoriesRepository.categories[restoredProduct.categoryId]?.name,
        'Food',
      );

      // The restored product was relinked to the newly-inserted modifier
      // group via setProductModifiers.
      final newGroupId = modifiersRepository.groups.keys.firstWhere(
        (id) => id != group.id,
      );
      expect(modifiersRepository.productLinks[restoredProduct.id], [
        newGroupId,
      ]);

      // The restored combo item points at the new product id.
      final restoredCombo = combosRepository.combos.values.firstWhere(
        (c) => c.items.single.productId != product.id,
      );
      expect(restoredCombo.items.single.productId, restoredProduct.id);
    });

    test('restoreTemplate(replaceExisting: true) removes the existing catalog '
        'before inserting the restored one', () async {
      await categoriesRepository.createCategory(
        const Category(id: 0, name: 'Old category'),
      );
      final saved = (await repository.saveCurrentAsTemplate(
        'Empty template',
      )).unwrap();

      await categoriesRepository.createCategory(
        const Category(id: 0, name: 'Should be removed'),
      );
      expect(categoriesRepository.categories, hasLength(2));

      final restoreResult = await repository.restoreTemplate(
        saved.id,
        replaceExisting: true,
      );
      expect(restoreResult.isSuccess, isTrue);

      // The template snapshotted 1 category ("Old category"); replace
      // wipes everything present at restore time, then inserts that 1
      // category fresh.
      expect(categoriesRepository.categories, hasLength(1));
      expect(
        categoriesRepository.categories.values.single.name,
        'Old category',
      );
    });

    test(
      'deleteTemplate soft-deletes without touching the live catalog',
      () async {
        await categoriesRepository.createCategory(
          const Category(id: 0, name: 'Food'),
        );
        final saved = (await repository.saveCurrentAsTemplate(
          'Sagra 2026',
        )).unwrap();

        final deleteResult = await repository.deleteTemplate(saved.id);
        expect(deleteResult.unwrap(), saved.id);

        final templates = await repository.watchAllTemplates().first;
        expect(templates, isEmpty);
        expect(categoriesRepository.categories, hasLength(1));
      },
    );
  });
}
