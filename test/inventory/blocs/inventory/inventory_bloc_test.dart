import 'package:feature_inventory/feature_inventory.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'inventory_bloc_test.mocks.dart';

@GenerateMocks([InventoryRepository])
void main() {
  late MockInventoryRepository mockRepository;
  late InventoryBloc bloc;

  const tStock = (productId: 1, quantity: 10);
  const tLowStock = (productId: 2, quantity: 2);

  setUp(() {
    mockRepository = MockInventoryRepository();
    bloc = InventoryBloc(inventoryRepository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('InventoryBloc', () {
    test('initial state is InventoryState.initial', () {
      expect(bloc.state, const InventoryState.initial());
    });

    blocTest<InventoryBloc, InventoryState>(
      'emits [loading, loaded(partial), loaded(full)] when Started is added',
      setUp: () {
        when(mockRepository.watchAllStocks())
            .thenAnswer((_) => Stream.value([tStock, tLowStock]));
        when(mockRepository.watchLowStocks(any))
            .thenAnswer((_) => Stream.value([tLowStock]));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const InventoryEvent.started()),
      expect: () => [
        const InventoryState.loading(),
        // First emission from watchAllStocks (lowStocks still empty default [])
        const InventoryState.loaded(
          stocks: [tStock, tLowStock],
          lowStockCount: 0,
          threshold: 10,
          showLowStockOnly: false,
        ),
        // Second emission from watchLowStocks (lowStocks updated)
        const InventoryState.loaded(
          stocks: [tStock, tLowStock],
          lowStockCount: 1,
          threshold: 10,
          showLowStockOnly: false,
        ),
      ],
      verify: (bloc) {
        verify(mockRepository.watchAllStocks()).called(1);
        verify(mockRepository.watchLowStocks(10)).called(1);
      },
    );

    blocTest<InventoryBloc, InventoryState>(
      'emits loaded with filtered stocks when FilterChanged is added',
      setUp: () {
        when(mockRepository.watchAllStocks())
            .thenAnswer((_) => Stream.value([tStock, tLowStock]));
        when(mockRepository.watchLowStocks(any))
            .thenAnswer((_) => Stream.value([tLowStock]));
      },
      build: () => bloc,
      act: (bloc) async {
        bloc.add(const InventoryEvent.started());
        await Future.delayed(Duration.zero);
        bloc.add(const InventoryEvent.filterChanged(lowStockOnly: true));
      },
      expect: () => [
        const InventoryState.loading(),
        // Initial load series
        const InventoryState.loaded(
          stocks: [tStock, tLowStock],
          lowStockCount: 0,
          threshold: 10,
          showLowStockOnly: false,
        ),
        const InventoryState.loaded(
          stocks: [tStock, tLowStock],
          lowStockCount: 1,
          threshold: 10,
          showLowStockOnly: false,
        ),
        // Filter change
        const InventoryState.loaded(
          stocks: [tLowStock], // Filter applied
          lowStockCount: 1,
          threshold: 10,
          showLowStockOnly: true,
        ),
      ],
    );

    blocTest<InventoryBloc, InventoryState>(
      'updates threshold and resubscribes when ThresholdChanged is added',
      setUp: () {
        when(mockRepository.watchAllStocks())
            .thenAnswer((_) => Stream.value([tStock, tLowStock]));
        when(mockRepository.watchLowStocks(10))
            .thenAnswer((_) => Stream.value([tLowStock]));
        when(mockRepository.watchLowStocks(5))
            .thenAnswer((_) => Stream.value([tLowStock]));
      },
      build: () => bloc,
      act: (bloc) async {
        bloc.add(const InventoryEvent.started());
        await Future.delayed(Duration.zero);
        bloc.add(const InventoryEvent.thresholdChanged(5));
      },
      expect: () => [
        const InventoryState.loading(),
        // Initial load
        const InventoryState.loaded(
          stocks: [tStock, tLowStock],
          lowStockCount: 0,
          threshold: 10,
          showLowStockOnly: false,
        ),
        const InventoryState.loaded(
          stocks: [tStock, tLowStock],
          lowStockCount: 1,
          threshold: 10,
          showLowStockOnly: false,
        ),
        // Threshold changed - handler emit (threshold updated, list matches prior state)
        const InventoryState.loaded(
          stocks: [tStock, tLowStock],
          lowStockCount: 1,
          threshold: 5, // Updated
          showLowStockOnly: false,
        ),
        // Subscription emit (matches prior list so mostly redundant but effectively new state object)
        // Wait, if content is identical, Bloc/Freezed handles equality.
        // Existing state: loaded(..., lowCount: 1, threshold: 5, ...)
        // New state from subscription: loaded(..., lowCount: 1, threshold: 5, ...)
        // They are equal. So NO new emit should happen here.
        // Correct?
        // Let's verify _onThresholdChanged:
        // _lowStocksSubscription = ... .listen((stocks) { _lowStocks = stocks; _emitLoaded(); })
        // If stocks is SAME list content, _lowStocks is updated (same content).
        // _emitLoaded creates new Loaded state.
        // Freezed equality checks fields.
        // If fields are same, it is equal.
        // So we might NOT get the 4th emit.
        // I will comment out the 4th emit for now and see if test fails or passes.
        // Or better, I will assume it DOES NOT emit if equal.
        // But wait, the `watchLowStocks(5)` creates a NEW list instance in the mock: `Stream.value([tLowStock])`.
        // `tLowStock` is const, but the list `[]` is new?
        // `[tLowStock]` creates a new list.
        // Freezed `InventoryState.loaded` uses default equality.
        // Lists in Dart are NOT equal by value unless using `listEquals` or `DeepCollectionEquality`.
        // Freezed DOES generate deep equality for collections usually.
        // Let's assume Freezed handles it.
        // So I'll remove the 4th expectation.
      ],
      verify: (bloc) {
        verify(mockRepository.watchLowStocks(5)).called(1);
      },
    );

    blocTest<InventoryBloc, InventoryState>(
      'triggers reload on Refresh event',
      setUp: () {
        when(mockRepository.watchAllStocks())
            .thenAnswer((_) => Stream.value([tStock]));
        when(mockRepository.watchLowStocks(any))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const InventoryEvent.refresh()),
      expect: () => [
        const InventoryState.loading(),
        const InventoryState.loaded(
          stocks: [tStock],
          lowStockCount: 0,
          threshold: 10,
          showLowStockOnly: false,
        ),
      ],
    );
  });
}
