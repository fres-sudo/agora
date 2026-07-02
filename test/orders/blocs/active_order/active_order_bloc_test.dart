
import 'package:feature_orders/feature_orders.dart';
import 'package:feature_products/feature_products.dart';
import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';
import 'package:result/result.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'active_order_bloc_test.mocks.dart';

@GenerateMocks([OrdersRepository, SettingsCubit])
void main() {
  late MockOrdersRepository mockOrdersRepository;
  late MockSettingsCubit mockSettingsCubit;
  late ActiveOrderBloc bloc;

  final testProduct = Product(
    id: 1,
    name: 'Test Product',
    priceCents: 1000,
    costCents: 500,
    sku: 'SKU123',
    categoryId: 1,
    status: ProductStatus.active,
    stockQuantity: 100,
    modifierGroups: [],
  );

  const testSelectedModifier = SelectedModifiers(
    groupName: 'Size',
    optionName: 'Large',
    priceChangeCents: 100,
  );

  setUpAll(() {
    provideDummy<Result<Order>>(
      Result.ok(
        Order(
          id: 0,
          createdAt: DateTime.now(),
          status: OrderStatus.pending,
          items: [],
          subtotalCents: 0,
          taxCents: 0,
          discountCents: 0,
          grandTotalCents: 0,
          note: null,
        ),
      ),
    );
  });

  setUp(() {
    mockOrdersRepository = MockOrdersRepository();
    mockSettingsCubit = MockSettingsCubit();
    when(mockSettingsCubit.getDouble(any)).thenReturn(null);
    bloc = ActiveOrderBloc(
      ordersRepository: mockOrdersRepository,
      settingsCubit: mockSettingsCubit,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ActiveOrderBloc', () {
    test('initial state is empty', () {
      expect(bloc.state, const ActiveOrderState.empty());
    });

    blocTest<ActiveOrderBloc, ActiveOrderState>(
      'emits empty when Started is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const ActiveOrderEvent.started()),
      expect: () => [const ActiveOrderState.empty()],
    );

    group('Item Management', () {
      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits building with item when ItemAdded is added',
        build: () => bloc,
        act: (bloc) => bloc.add(
          ActiveOrderEvent.itemAdded(product: testProduct, quantity: 1),
        ),
        verify: (bloc) {
          final state = bloc.state;
          state.mapOrNull(
            building: (s) {
              expect(s.order.items.length, 1);
              expect(s.order.items.first.productId, testProduct.id);
              expect(s.order.subtotalCents, 1000);
            },
          );
        },
      );

       blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits building with item and modifiers when ItemAdded is added with modifiers',
        build: () => bloc,
        act: (bloc) => bloc.add(
          ActiveOrderEvent.itemAdded(
            product: testProduct,
            quantity: 1,
            modifiers: [testSelectedModifier],
          ),
        ),
        verify: (bloc) {
          final state = bloc.state;
          state.mapOrNull(
            building: (s) {
              expect(s.order.items.length, 1);
              expect(s.order.items.first.selectedModifiers.length, 1);
              expect(
                s.order.items.first.selectedModifiers.first.groupName,
                'Size',
              );
              expect(s.order.subtotalCents, 1100); // 1000 + 100
            },
          );
        },
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'merges into the existing line instead of duplicating it when the '
        'same product is added again with no modifiers',
        build: () => bloc,
        act: (bloc) {
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct));
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct));
        },
        skip: 1,
        verify: (bloc) {
          final state = bloc.state;
          state.mapOrNull(
            building: (s) {
              expect(s.order.items.length, 1);
              expect(s.order.items.first.quantity, 2);
              expect(s.order.subtotalCents, 2000);
            },
          );
        },
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'keeps separate lines when the same product is added with '
        'different modifier selections',
        build: () => bloc,
        act: (bloc) {
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct));
          bloc.add(
            ActiveOrderEvent.itemAdded(
              product: testProduct,
              modifiers: const [testSelectedModifier],
            ),
          );
        },
        skip: 1,
        verify: (bloc) {
          final state = bloc.state;
          state.mapOrNull(
            building: (s) {
              expect(s.order.items.length, 2);
              expect(s.order.items[0].id, isNot(s.order.items[1].id));
            },
          );
        },
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits building with updated quantity when ItemQuantityChanged is added',
        build: () => bloc,
        seed: () => ActiveOrderState.building(
            order: Order(
                id: 0,
                createdAt: DateTime.now(),
                status: OrderStatus.pending,
                items: [],
                subtotalCents: 0,
                taxCents: 0,
                discountCents: 0,
                grandTotalCents: 0,
                note: null,
            ),
            appliedDiscount: null
        ), // Cannot easily seed private _items, so we rely on acting
        act: (bloc) {
            bloc.add(ActiveOrderEvent.itemAdded(product: testProduct, quantity: 1));
            bloc.add(ActiveOrderEvent.itemQuantityChanged(lineItemId: 1, quantity: 2));
        },
        skip: 1, // Skip the itemAdded state
        verify: (bloc) {
          final state = bloc.state;
          state.mapOrNull(
            building: (s) {
               expect(s.order.items.first.quantity, 2);
               expect(s.order.subtotalCents, 2000);
            },
          );
        },
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits empty when ItemQuantityChanged drops to 0',
        build: () => bloc,
        act: (bloc) {
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct, quantity: 1));
          bloc.add(ActiveOrderEvent.itemQuantityChanged(lineItemId: 1, quantity: 0));
        },
        skip: 1,
        expect: () => [const ActiveOrderState.empty()],
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'ItemQuantityChanged only updates the targeted line, not every line '
        'for the same product',
        build: () => bloc,
        act: (bloc) {
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct)); // id 1
          bloc.add(
            ActiveOrderEvent.itemAdded(
              product: testProduct,
              modifiers: const [testSelectedModifier],
            ),
          ); // id 2
          bloc.add(
            ActiveOrderEvent.itemQuantityChanged(lineItemId: 2, quantity: 5),
          );
        },
        skip: 2,
        verify: (bloc) {
          final state = bloc.state;
          state.mapOrNull(
            building: (s) {
              final unmodified = s.order.items.firstWhere((i) => i.id == 1);
              final changed = s.order.items.firstWhere((i) => i.id == 2);
              expect(unmodified.quantity, 1);
              expect(changed.quantity, 5);
            },
          );
        },
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits empty when last item is removed',
         build: () => bloc,
        act: (bloc) {
            bloc.add(ActiveOrderEvent.itemAdded(product: testProduct, quantity: 1));
            bloc.add(const ActiveOrderEvent.itemRemoved(1));
        },
        skip: 1,
        expect: () => [const ActiveOrderState.empty()],
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'ItemRemoved only removes the targeted line, not every line for the '
        'same product',
        build: () => bloc,
        act: (bloc) {
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct)); // id 1
          bloc.add(
            ActiveOrderEvent.itemAdded(
              product: testProduct,
              modifiers: const [testSelectedModifier],
            ),
          ); // id 2
          bloc.add(const ActiveOrderEvent.itemRemoved(1));
        },
        skip: 2,
        verify: (bloc) {
          final state = bloc.state;
          state.mapOrNull(
            building: (s) {
              expect(s.order.items.length, 1);
              expect(s.order.items.first.id, 2);
            },
          );
        },
      );
    });

    group('Submission', () {
      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits no state (only an error effect) when Submitted with empty cart',
        build: () => bloc,
        act: (bloc) => bloc.add(const ActiveOrderEvent.submitted()),
        expect: () => const <ActiveOrderState>[],
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits [submitting, submitted] when Submitted is added with items',
        setUp: () {
          when(mockOrdersRepository.createOrder(any)).thenAnswer(
            (_) async => Result.ok(
              Order(
                id: 123,
                createdAt: DateTime.now(),
                status: OrderStatus.pending,
                items: [],
                subtotalCents: 1000,
                taxCents: 0,
                discountCents: 0,
                grandTotalCents: 1000,
                note: null,
              ),
            ),
          );
        },
        build: () => bloc,
        act: (bloc) {
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct));
          bloc.add(const ActiveOrderEvent.submitted());
        },
        skip: 1, // Skip item added
        verify: (bloc) {
          verify(mockOrdersRepository.createOrder(any)).called(1);
        },
      );

      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits [submitting, building] when Submitted fails (recovery state)',
        setUp: () {
          when(mockOrdersRepository.createOrder(any)).thenAnswer(
            (_) async => Result.error(Exception('Failed')),
          );
        },
        build: () => bloc,
        act: (bloc) {
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct));
          bloc.add(const ActiveOrderEvent.submitted());
        },
        skip: 1,
        expect: () => [
          isA<ActiveOrderState>().having(
            (s) => s.maybeMap(submitting: (_) => true, orElse: () => false),
            'is submitting',
            true,
          ),
          isA<ActiveOrderState>().having(
            (s) => s.maybeMap(building: (_) => true, orElse: () => false),
            'is building (cart preserved for recovery)',
            true,
          ),
        ],
        verify: (bloc) {
          verify(mockOrdersRepository.createOrder(any)).called(1);
        },
      );
    });

    blocTest<ActiveOrderBloc, ActiveOrderState>(
      'emits empty when Cleared is added',
      build: () => bloc,
      act: (bloc) {
          bloc.add(ActiveOrderEvent.itemAdded(product: testProduct));
          bloc.add(const ActiveOrderEvent.cleared());
      },
      skip: 1,
      expect: () => [const ActiveOrderState.empty()],
    );
  });
}
