import 'dart:ui';
import 'package:agora/core/misc/result.dart';
import 'package:agora/products/blocs/categories/categories_bloc.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:agora/products/repositories/categories_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_bloc_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  const category = Category(
    id: 1,
    name: 'Category 1',
    isEnabled: true,
    color: Color(0xFF0000),
  );

  late MockCategoriesRepository mockCategoriesRepository;
  late CategoriesBloc categoriesBloc;

  setUp(() {
    provideDummy<Result<Category>>(const Result.ok(category));
    mockCategoriesRepository = MockCategoriesRepository();
    categoriesBloc = CategoriesBloc(
      categoriesRepository: mockCategoriesRepository,
    );
  });

  tearDown(() {
    categoriesBloc.close();
  });



  group('CategoriesBloc', () {
    test('initial state is CategoriesState.initial', () {
      expect(categoriesBloc.state, const CategoriesState.initial());
    });

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [loading, loaded] when started and stream emits data',
      setUp: () {
        when(
          mockCategoriesRepository.watchAllCategories(),
        ).thenAnswer((_) => Stream.value([category]));
      },
      build: () => categoriesBloc,
      act: (bloc) => bloc.add(const CategoriesEvent.started()),
      expect: () => [
        const CategoriesState.loading(),
        const CategoriesState.loaded(categories: [category]),
      ],
      verify: (_) {
        verify(mockCategoriesRepository.watchAllCategories()).called(1);
      },
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'calls createCategory when Created event added',
      setUp: () {
        when(
          mockCategoriesRepository.createCategory(any),
        ).thenAnswer((_) async => const Result.ok(category));
      },
      build: () => categoriesBloc,
      act: (bloc) => bloc.add(const CategoriesEvent.created(category)),
      verify: (_) {
        verify(mockCategoriesRepository.createCategory(category)).called(1);
      },
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'calls updateCategory when Updated event added',
      setUp: () {
        when(
          mockCategoriesRepository.updateCategory(any),
        ).thenAnswer((_) async => const Result.ok(category));
      },
      build: () => categoriesBloc,
      act: (bloc) => bloc.add(const CategoriesEvent.updated(category)),
      verify: (_) {
        verify(mockCategoriesRepository.updateCategory(category)).called(1);
      },
    );

    // blocTest<CategoriesBloc, CategoriesState>(
    //   'calls deleteCategory when Deleted event added',
    //   setUp: () {
    //     when(mockCategoriesRepository.deleteCategory(1))
    //         .thenAnswer((_) async => const Result.ok(1));
    //   },
    //   build: () => categoriesBloc,
    //   act: (bloc) => bloc.add(const CategoriesEvent.deleted(1)),
    //   expect: () => [],
    //   verify: (_) {
    //     verify(mockCategoriesRepository.deleteCategory(1)).called(1);
    //   },
    // );
  });
}
