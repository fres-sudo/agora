import 'package:feature_products/feature_products.dart';
import 'package:result/result.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'combos_bloc_test.mocks.dart';

@GenerateMocks([CombosRepository])
void main() {
  late MockCombosRepository mockCombosRepository;
  late CombosBloc combosBloc;

  const combo = Combo(
    id: 1,
    name: 'Menu Completo',
    priceCents: 1000,
    isEnabled: true,
    items: [
      ComboItem(productId: 1, productName: 'Panino', quantity: 1),
      ComboItem(productId: 2, productName: 'Patatine', quantity: 1),
    ],
  );

  setUpAll(() {
    // Mockito needs a dummy value for any Result<T> return type it can't
    // auto-construct (Result is a sealed class with private constructors),
    // even when every call is explicitly stubbed via `when(...).thenAnswer`.
    provideDummy<Result<Combo>>(const Result.ok(combo));
    provideDummy<Result<int>>(const Result.ok(0));
  });

  setUp(() {
    mockCombosRepository = MockCombosRepository();
    combosBloc = CombosBloc(combosRepository: mockCombosRepository);
  });

  tearDown(() {
    combosBloc.close();
  });

  group('CombosBloc', () {
    test('initial state is CombosState.initial', () {
      expect(combosBloc.state, const CombosState.initial());
    });

    blocTest<CombosBloc, CombosState>(
      'emits [loading, loaded] when started and stream emits data',
      setUp: () {
        when(
          mockCombosRepository.watchAllCombos(),
        ).thenAnswer((_) => Stream.value([combo]));
      },
      build: () => combosBloc,
      act: (bloc) => bloc.add(const CombosEvent.started()),
      expect: () => [
        const CombosState.loading(),
        const CombosState.loaded(combos: [combo]),
      ],
    );

    blocTest<CombosBloc, CombosState>(
      'calls createCombo when Created event added',
      setUp: () {
        when(
          mockCombosRepository.createCombo(any),
        ).thenAnswer((_) async => const Result.ok(combo));
      },
      build: () => combosBloc,
      act: (bloc) => bloc.add(const CombosEvent.created(combo)),
      verify: (_) {
        verify(mockCombosRepository.createCombo(combo)).called(1);
      },
    );

    blocTest<CombosBloc, CombosState>(
      'calls updateCombo when Updated event added',
      setUp: () {
        when(
          mockCombosRepository.updateCombo(any),
        ).thenAnswer((_) async => const Result.ok(combo));
      },
      build: () => combosBloc,
      act: (bloc) => bloc.add(const CombosEvent.updated(combo)),
      verify: (_) {
        verify(mockCombosRepository.updateCombo(combo)).called(1);
      },
    );

    blocTest<CombosBloc, CombosState>(
      'calls deleteCombo when Deleted event added',
      setUp: () {
        when(
          mockCombosRepository.deleteCombo(1),
        ).thenAnswer((_) async => const Result.ok(1));
      },
      build: () => combosBloc,
      act: (bloc) => bloc.add(const CombosEvent.deleted(1)),
      verify: (_) {
        verify(mockCombosRepository.deleteCombo(1)).called(1);
      },
    );
  });
}
