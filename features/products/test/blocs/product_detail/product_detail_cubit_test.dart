import 'dart:async';

import 'package:feature_products/feature_products.dart';
import 'package:result/result.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_detail_cubit_test.mocks.dart';

@GenerateMocks([ProductsRepository, ModifiersRepository])
void main() {
  provideDummy<Result<Category>>(
    const Result.ok(Category(id: 0, name: 'dummy')),
  );
  provideDummy<Result<int>>(const Result.ok(0));
  provideDummy<Result<bool>>(const Result.ok(true));
  provideDummy<Result<Product>>(
    Result.ok(
      Product(
        id: 0,
        name: 'dummy',
        description: '',
        categoryId: 0,
        costCents: 0,
        priceCents: 0,
        taxPercent: 0,
        stockQuantity: 0,
        status: ProductStatus.active,
      ),
    ),
  );

  late MockProductsRepository mockProductsRepository;
  late MockModifiersRepository mockModifiersRepository;
  late ProductDetailCubit productDetailCubit;

  setUp(() {
    mockProductsRepository = MockProductsRepository();
    mockModifiersRepository = MockModifiersRepository();
    productDetailCubit = ProductDetailCubit(
      productsRepository: mockProductsRepository,
      modifiersRepository: mockModifiersRepository,
    );
  });

  tearDown(() {
    productDetailCubit.close();
  });

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

  const modifierGroup = ModifierGroup(
    id: 1,
    name: 'Group 1',
    isMultiSelect: false,
    options: [],
  );

  group('ProductDetailCubit', () {
    test('initial state is ProductDetailState.initial', () {
      expect(productDetailCubit.state, const ProductDetailState.initial());
    });

    blocTest<ProductDetailCubit, ProductDetailState>(
      'load emits [loading, loaded] when streams emit',
      setUp: () {
        when(
          mockProductsRepository.watchProductById(1),
        ).thenAnswer((_) => Stream.value(product));
        when(
          mockModifiersRepository.watchModifiersByProductId(1),
        ).thenAnswer((_) => Stream.value([modifierGroup]));
      },
      build: () => productDetailCubit,
      act: (cubit) => cubit.load(1),
      expect: () => [
        const ProductDetailState.loading(),
        ProductDetailState.loaded(product: product, modifiers: [modifierGroup]),
      ],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'createNew emits creating',
      build: () => productDetailCubit,
      act: (cubit) => cubit.createNew(),
      expect: () => [const ProductDetailState.creating()],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'save calls updateProduct for existing product',
      setUp: () {
        when(
          mockProductsRepository.updateProduct(product),
        ).thenAnswer((_) async => Result.ok(product));
      },
      build: () => productDetailCubit,
      act: (cubit) => cubit.save(product),
      expect: () => [
        ProductDetailState.saving(product: product),
        ProductDetailState.saved(product: product),
      ],
      verify: (_) {
        verify(mockProductsRepository.updateProduct(product)).called(1);
      },
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'emits notFound when the watched product stream emits null after being loaded '
      '(e.g. deleted on another device)',
      setUp: () {
        final controller = StreamController<Product?>();
        addTearDown(controller.close);
        when(
          mockProductsRepository.watchProductById(1),
        ).thenAnswer((_) => controller.stream);
        when(
          mockModifiersRepository.watchModifiersByProductId(1),
        ).thenAnswer((_) => Stream.value([modifierGroup]));

        scheduleMicrotask(() async {
          controller.add(product);
          await Future.delayed(Duration.zero);
          controller.add(null);
        });
      },
      build: () => productDetailCubit,
      act: (cubit) => cubit.load(1),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        const ProductDetailState.loading(),
        ProductDetailState.loaded(product: product, modifiers: [modifierGroup]),
        const ProductDetailState.notFound(),
      ],
    );

    late StreamController<Product?> deleteRaceController;

    blocTest<ProductDetailCubit, ProductDetailState>(
      'does not emit notFound when the product stream re-emits null right after '
      'a user-initiated delete() completes',
      setUp: () {
        deleteRaceController = StreamController<Product?>();
        addTearDown(deleteRaceController.close);
        when(
          mockProductsRepository.watchProductById(1),
        ).thenAnswer((_) => deleteRaceController.stream);
        when(
          mockModifiersRepository.watchModifiersByProductId(1),
        ).thenAnswer((_) => Stream.value([]));
        when(
          mockProductsRepository.deleteProduct(1),
        ).thenAnswer((_) async => const Result.ok(1));

        scheduleMicrotask(() => deleteRaceController.add(product));
      },
      build: () => productDetailCubit,
      act: (cubit) async {
        await cubit.load(1);
        await Future.delayed(Duration.zero);
        await cubit.delete();
        // Simulate the watch stream catching up with the deletion.
        deleteRaceController.add(null);
        await Future.delayed(Duration.zero);
      },
      skip: 2, // Skip loading and loaded
      expect: () => [
        ProductDetailState.deleting(product: product),
        const ProductDetailState.deleted(),
      ],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'delete calls deleteProduct',
      setUp: () {
        when(
          mockProductsRepository.watchProductById(1),
        ).thenAnswer((_) => Stream.value(product));
        when(
          mockModifiersRepository.watchModifiersByProductId(1),
        ).thenAnswer((_) => Stream.value([]));
        when(
          mockProductsRepository.deleteProduct(1),
        ).thenAnswer((_) async => const Result.ok(1));
      },
      build: () => productDetailCubit,
      act: (cubit) async {
        await cubit.load(1);
        await Future.delayed(Duration.zero);
        await cubit.delete();
      },
      skip: 2, // Skip loading and loaded
      expect: () => [
        ProductDetailState.deleting(product: product),
        const ProductDetailState.deleted(),
      ],
      verify: (_) {
        verify(mockProductsRepository.deleteProduct(1)).called(1);
      },
    );
  });
}
