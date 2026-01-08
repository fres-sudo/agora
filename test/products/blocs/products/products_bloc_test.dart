import 'dart:ui';
import 'package:agora/core/misc/result.dart';
import 'package:agora/products/blocs/products/products_bloc.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/models/product/product_status.dart';
import 'package:agora/products/repositories/categories_repository.dart';
import 'package:agora/products/repositories/products_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'products_bloc_test.mocks.dart';

@GenerateMocks([ProductsRepository, CategoriesRepository])
void main() {
  final category = Category(id: 1, name: 'Category 1', isEnabled: true, color: Color(0xFF0000));
  final product = Product(
    id: 1,
    name: 'Product 1',
    description: 'Desc',
    categoryId: 1,
    costCents: 50,
    priceCents: 100,
    taxPercent: 10,
    stockQuantity: 10,
    status: ProductStatus.active,
  );

  late MockProductsRepository mockProductsRepository;
  late MockCategoriesRepository mockCategoriesRepository;
  late ProductsBloc productsBloc;

  setUp(() {
    provideDummy<Result<Product>>(Result.ok(product));
    provideDummy<Result<Category>>(Result.ok(category));
    mockProductsRepository = MockProductsRepository();
    mockCategoriesRepository = MockCategoriesRepository();
    productsBloc = ProductsBloc(
      productsRepository: mockProductsRepository,
      categoriesRepository: mockCategoriesRepository,
    );
  });

  tearDown(() {
    productsBloc.close();
  });



  group('ProductsBloc', () {
    test('initial state is ProductsState.initial', () {
      expect(productsBloc.state, const ProductsState.initial());
    });

    blocTest<ProductsBloc, ProductsState>(
      'emits [loading, loaded] when started',
      setUp: () {
        when(mockCategoriesRepository.watchAllCategories())
            .thenAnswer((_) => Stream.value([category]));
        when(mockProductsRepository.watchAllProducts())
            .thenAnswer((_) => Stream.value([product]));
      },
      build: () => productsBloc,
      act: (bloc) => bloc.add(const ProductsEvent.started()),
      expect: () => [
        const ProductsState.loading(),
        ProductsState.loaded(
            products: [product],
            categories: [category],
            selectedCategoryId: null,
            searchQuery: ''),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'filters products by category',
      setUp: () {
        when(mockCategoriesRepository.watchAllCategories())
            .thenAnswer((_) => Stream.value([category]));
        when(mockProductsRepository.watchAllProducts())
            .thenAnswer((_) => Stream.value([product]));
      },
      build: () => productsBloc,
      act: (bloc) async {
        bloc.add(const ProductsEvent.started());
        await Future.delayed(Duration.zero);
        bloc.add(const ProductsEvent.categoryFilterChanged(1));
      },
      expect: () => [
        const ProductsState.loading(),
        ProductsState.loaded(
            products: [product],
            categories: [category],
            selectedCategoryId: null,
            searchQuery: ''),
        ProductsState.loaded(
            products: [product],
            categories: [category],
            selectedCategoryId: 1,
            searchQuery: ''),
      ],
    );

     blocTest<ProductsBloc, ProductsState>(
      'filters products by search query',
      setUp: () {
        when(mockCategoriesRepository.watchAllCategories())
            .thenAnswer((_) => Stream.value([category]));
        when(mockProductsRepository.watchAllProducts())
            .thenAnswer((_) => Stream.value([product]));
      },
      build: () => productsBloc,
      act: (bloc) async {
        bloc.add(const ProductsEvent.started());
        await Future.delayed(Duration.zero);
        bloc.add(const ProductsEvent.searchChanged('Product'));
      },
      expect: () => [
        const ProductsState.loading(),
        ProductsState.loaded(
            products: [product],
            categories: [category],
            selectedCategoryId: null,
            searchQuery: ''),
        ProductsState.loaded(
            products: [product],
            categories: [category],
            selectedCategoryId: null,
            searchQuery: 'product'),
      ],
    );

    // blocTest<ProductsBloc, ProductsState>(
    //   'calls deleteProduct when Deleted event added',
    //   setUp: () {
    //     when(mockProductsRepository.deleteProduct(1))
    //         .thenAnswer((_) async => const Result.ok(1));
    //      when(mockCategoriesRepository.watchAllCategories())
    //         .thenAnswer((_) => Stream.value([category]));
    //     when(mockProductsRepository.watchAllProducts())
    //         .thenAnswer((_) => Stream.value([product]));
    //   },
    //   build: () => productsBloc,
    //   act: (bloc) => bloc.add(const ProductsEvent.deleted(1)),
    //   verify: (_) {
    //     verify(mockProductsRepository.deleteProduct(1)).called(1);
    //   },
    // );
  });
}
