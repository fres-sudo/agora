import 'dart:async';

import 'package:catalog/models/category.dart';
import 'package:catalog/models/product.dart';
import 'package:catalog/repositories/categories_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:catalog/blocs/products/products_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result/result.dart';

/// Categories repository whose stream always errors, simulating a
/// persistently broken category query (e.g. DB corruption).
class _AlwaysErroringCategoriesRepository implements CategoriesRepository {
  int watchCallCount = 0;

  @override
  Stream<List<Category>> watchAllCategories() {
    watchCallCount++;
    return Stream<List<Category>>.error(Exception('category stream boom'));
  }

  @override
  Stream<Category?> watchCategoryById(int id) => throw UnimplementedError();

  @override
  Future<Result<Category?>> getCategoryById(int id) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> getCategoriesCount() => throw UnimplementedError();

  @override
  Future<Result<Category>> createCategory(Category category) =>
      throw UnimplementedError();

  @override
  Future<Result<Category>> updateCategory(Category category) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> deleteCategory(int id) => throw UnimplementedError();

  @override
  Future<Result<bool>> restoreCategory(int id) => throw UnimplementedError();
}

/// Categories repository that errors on the first N calls, then succeeds.
class _RecoveringCategoriesRepository implements CategoriesRepository {
  _RecoveringCategoriesRepository({required this.failuresBeforeSuccess});

  final int failuresBeforeSuccess;
  int watchCallCount = 0;

  @override
  Stream<List<Category>> watchAllCategories() {
    watchCallCount++;
    if (watchCallCount <= failuresBeforeSuccess) {
      return Stream<List<Category>>.error(Exception('transient error'));
    }
    return Stream<List<Category>>.value(const [
      Category(id: 1, name: 'Drinks'),
    ]);
  }

  @override
  Stream<Category?> watchCategoryById(int id) => throw UnimplementedError();

  @override
  Future<Result<Category?>> getCategoryById(int id) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> getCategoriesCount() => throw UnimplementedError();

  @override
  Future<Result<Category>> createCategory(Category category) =>
      throw UnimplementedError();

  @override
  Future<Result<Category>> updateCategory(Category category) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> deleteCategory(int id) => throw UnimplementedError();

  @override
  Future<Result<bool>> restoreCategory(int id) => throw UnimplementedError();
}

class _FakeProductsRepository implements ProductsRepository {
  @override
  Stream<List<Product>> watchAllProducts() =>
      Stream<List<Product>>.value(const []);

  @override
  Stream<List<Product>> watchProductsByCategory(int categoryId) =>
      throw UnimplementedError();

  @override
  Stream<Product?> watchProductById(int id) => throw UnimplementedError();

  @override
  Future<Result<Product?>> getProductById(int id) => throw UnimplementedError();

  @override
  Future<Result<Product?>> getProductBySku(String sku) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> getProductsCount({int? categoryId, String? searchTerm}) =>
      throw UnimplementedError();

  @override
  Future<Result<Product>> createProduct(Product product) =>
      throw UnimplementedError();

  @override
  Future<Result<Product>> updateProduct(Product product) =>
      throw UnimplementedError();

  @override
  Future<Result<int>> deleteProduct(int id) => throw UnimplementedError();

  @override
  Future<Result<List<String>>> getPrepStations() => throw UnimplementedError();

  @override
  Future<Result<bool>> restoreProduct(int id) => throw UnimplementedError();
}

void main() {
  group('ProductsBloc categories-stream retry', () {
    test('retries a bounded number of times with backoff, then emits a '
        'terminal error state instead of looping forever', () async {
      final categoriesRepository = _AlwaysErroringCategoriesRepository();
      final bloc = ProductsBloc(
        productsRepository: _FakeProductsRepository(),
        categoriesRepository: categoriesRepository,
        maxCategoryRetryAttempts: 3,
        categoryRetryBaseDelay: const Duration(milliseconds: 1),
        categoryRetryMaxDelay: const Duration(milliseconds: 4),
      );
      addTearDown(bloc.close);

      final states = <ProductsState>[];
      final sub = bloc.stream.listen(states.add);
      addTearDown(sub.cancel);

      bloc.add(const ProductsEvent.started());

      // Give every scheduled retry timer a chance to fire: with
      // maxCategoryRetryAttempts = 3 and small backoff delays, this is
      // comfortably enough time for the whole bounded sequence to finish.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Initial subscribe + exactly 3 retries = 4 calls. Bounded, not
      // unbounded.
      expect(categoriesRepository.watchCallCount, 4);

      expect(
        bloc.state,
        isA<ProductsState>().having(
          (s) => s.maybeMap(error: (_) => true, orElse: () => false),
          'is a terminal error state',
          isTrue,
        ),
      );

      // Confirm the retry loop is truly bounded: waiting longer doesn't
      // trigger any further resubscription attempts.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(categoriesRepository.watchCallCount, 4);
    });

    test('recovers and resets the retry counter once the stream succeeds '
        'again', () async {
      final categoriesRepository = _RecoveringCategoriesRepository(
        failuresBeforeSuccess: 2,
      );
      final bloc = ProductsBloc(
        productsRepository: _FakeProductsRepository(),
        categoriesRepository: categoriesRepository,
        maxCategoryRetryAttempts: 5,
        categoryRetryBaseDelay: const Duration(milliseconds: 1),
        categoryRetryMaxDelay: const Duration(milliseconds: 4),
      );
      addTearDown(bloc.close);

      bloc.add(const ProductsEvent.started());

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(bloc.state, isA<ProductsLoaded>());
      expect(
        (bloc.state as ProductsLoaded).categories.map((c) => c.name),
        contains('Drinks'),
      );
    });
  });
}
