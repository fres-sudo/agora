import 'package:agora/core/misc/result.dart';
import 'package:agora/products/blocs/modifiers/modifiers_bloc.dart';
import 'package:agora/products/models/modifier_group/modifier_group.dart';
import 'package:agora/products/repositories/modifiers_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'modifiers_bloc_test.mocks.dart';

@GenerateMocks([ModifiersRepository])
void main() {
  late MockModifiersRepository mockModifiersRepository;
  late ModifiersBloc modifiersBloc;

  setUp(() {
    mockModifiersRepository = MockModifiersRepository();
    modifiersBloc = ModifiersBloc(modifiersRepository: mockModifiersRepository);
  });

  tearDown(() {
    modifiersBloc.close();
  });

  const modifierGroup = ModifierGroup(
    id: 1,
    name: 'Group 1',
    options: [],
    isMultiSelect: false,
  );

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
        ).thenAnswer((_) async => const Result.ok(1));
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
        ).thenAnswer((_) async => const Result.ok(true));
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
  });
}
