import 'package:feature_products/feature_products.dart';
import 'package:result/result.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'modifiers_bloc_test.mocks.dart';

@GenerateMocks([ModifiersRepository])
void main() {
  late MockModifiersRepository mockModifiersRepository;
  late ModifiersBloc modifiersBloc;

  const modifierGroup = ModifierGroup(
    id: 1,
    name: 'Group 1',
    options: [],
    isMultiSelect: false,
  );

  const modifierOption = ModifierOption(
    id: 1,
    name: 'Large',
    priceChangeCents: 100,
  );

  setUpAll(() {
    // Mockito needs a dummy value for any Result<T> return type it can't
    // auto-construct (Result is a sealed class with private constructors),
    // even when every call is explicitly stubbed via `when(...).thenAnswer`.
    provideDummy<Result<ModifierGroup>>(const Result.ok(modifierGroup));
    provideDummy<Result<ModifierOption>>(const Result.ok(modifierOption));
    provideDummy<Result<int>>(const Result.ok(0));
    provideDummy<Result<void>>(const Result.ok(null));
  });

  setUp(() {
    mockModifiersRepository = MockModifiersRepository();
    modifiersBloc = ModifiersBloc(modifiersRepository: mockModifiersRepository);
  });

  tearDown(() {
    modifiersBloc.close();
  });

  group('ModifiersBloc', () {
    test('initial state is ModifiersState.initial', () {
      expect(modifiersBloc.state, const ModifiersState.initial());
    });

    blocTest<ModifiersBloc, ModifiersState>(
      'emits [loading, loaded] when started and stream emits data',
      setUp: () {
        when(
          mockModifiersRepository.watchAllModifiers(),
        ).thenAnswer((_) => Stream.value([modifierGroup]));
      },
      build: () => modifiersBloc,
      act: (bloc) => bloc.add(const ModifiersEvent.started()),
      expect: () => [
        const ModifiersState.loading(),
        const ModifiersState.loaded(modifiers: [modifierGroup]),
      ],
    );

    blocTest<ModifiersBloc, ModifiersState>(
      'calls createModifier when Created event added',
      setUp: () {
        when(
          mockModifiersRepository.createModifier(any),
        ).thenAnswer((_) async => const Result.ok(modifierGroup));
      },
      build: () => modifiersBloc,
      act: (bloc) => bloc.add(const ModifiersEvent.created(modifierGroup)),
      verify: (_) {
        verify(mockModifiersRepository.createModifier(modifierGroup)).called(1);
      },
    );

    blocTest<ModifiersBloc, ModifiersState>(
      'calls updateModifier when Updated event added',
      setUp: () {
        when(
          mockModifiersRepository.updateModifier(any),
        ).thenAnswer((_) async => const Result.ok(modifierGroup));
      },
      build: () => modifiersBloc,
      act: (bloc) => bloc.add(const ModifiersEvent.updated(modifierGroup)),
      verify: (_) {
        verify(mockModifiersRepository.updateModifier(modifierGroup)).called(1);
      },
    );

    blocTest<ModifiersBloc, ModifiersState>(
      'calls deleteModifier when Deleted event added',
      setUp: () {
        when(
          mockModifiersRepository.deleteModifier(1),
        ).thenAnswer((_) async => const Result.ok(1));
      },
      build: () => modifiersBloc,
      act: (bloc) => bloc.add(const ModifiersEvent.deleted(1)),
      verify: (_) {
        verify(mockModifiersRepository.deleteModifier(1)).called(1);
      },
    );
    blocTest<ModifiersBloc, ModifiersState>(
      'calls linkModifierToProduct when LinkedToProduct event added',
      setUp: () {
        when(
          mockModifiersRepository.linkModifierToProduct(
            productId: 1,
            modifierId: 1,
          ),
        ).thenAnswer((_) async => const Result.ok(null));
      },
      build: () => modifiersBloc,
      act: (bloc) => bloc.add(
        const ModifiersEvent.linkedToProduct(productId: 1, modifierId: 1),
      ),
      verify: (_) {
        verify(
          mockModifiersRepository.linkModifierToProduct(
            productId: 1,
            modifierId: 1,
          ),
        ).called(1);
      },
    );

    blocTest<ModifiersBloc, ModifiersState>(
      'calls unlinkModifierFromProduct when UnlinkedFromProduct event added',
      setUp: () {
        when(
          mockModifiersRepository.unlinkModifierFromProduct(
            productId: 1,
            modifierId: 1,
          ),
        ).thenAnswer((_) async => const Result.ok(null));
      },
      build: () => modifiersBloc,
      act: (bloc) => bloc.add(
        const ModifiersEvent.unlinkedFromProduct(productId: 1, modifierId: 1),
      ),
      verify: (_) {
        verify(
          mockModifiersRepository.unlinkModifierFromProduct(
            productId: 1,
            modifierId: 1,
          ),
        ).called(1);
      },
    );

    blocTest<ModifiersBloc, ModifiersState>(
      'calls createModifierOption when OptionCreated event added',
      setUp: () {
        when(
          mockModifiersRepository.createModifierOption(
            modifierId: 1,
            option: modifierOption,
          ),
        ).thenAnswer((_) async => const Result.ok(modifierOption));
      },
      build: () => modifiersBloc,
      act: (bloc) => bloc.add(
        const ModifiersEvent.optionCreated(
          modifierId: 1,
          option: modifierOption,
        ),
      ),
      verify: (_) {
        verify(
          mockModifiersRepository.createModifierOption(
            modifierId: 1,
            option: modifierOption,
          ),
        ).called(1);
      },
    );

    blocTest<ModifiersBloc, ModifiersState>(
      'calls updateModifierOption when OptionUpdated event added',
      setUp: () {
        when(
          mockModifiersRepository.updateModifierOption(modifierOption),
        ).thenAnswer((_) async => const Result.ok(modifierOption));
      },
      build: () => modifiersBloc,
      act: (bloc) =>
          bloc.add(const ModifiersEvent.optionUpdated(modifierOption)),
      verify: (_) {
        verify(
          mockModifiersRepository.updateModifierOption(modifierOption),
        ).called(1);
      },
    );

    blocTest<ModifiersBloc, ModifiersState>(
      'calls deleteModifierOption when OptionDeleted event added',
      setUp: () {
        when(
          mockModifiersRepository.deleteModifierOption(1),
        ).thenAnswer((_) async => const Result.ok(1));
      },
      build: () => modifiersBloc,
      act: (bloc) => bloc.add(const ModifiersEvent.optionDeleted(1)),
      verify: (_) {
        verify(mockModifiersRepository.deleteModifierOption(1)).called(1);
      },
    );
  });
}
