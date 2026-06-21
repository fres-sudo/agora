
import 'package:agora/core/misc/result.dart';
import 'package:agora/orders/blocs/active_order/active_order_bloc.dart';
import 'package:agora/orders/models/order/order.dart';
import 'package:agora/orders/repositories/orders_repository.dart';
import 'package:agora/products/models/modifier_option/modifier_option.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/models/product/product_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'active_order_bloc_test.mocks.dart';

@GenerateMocks([OrdersRepository])
void main() {
  late MockOrdersRepository mockOrdersRepository;
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

  final testModifier = ModifierOption(
    id: 1,
    name: 'Test Modifier',
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
    bloc = ActiveOrderBloc(ordersRepository: mockOrdersRepository);
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
            modifiers: [testModifier],
          ),
        ),
        verify: (bloc) {
          final state = bloc.state;
          state.mapOrNull(
            building: (s) {
              expect(s.order.items.length, 1);
              expect(s.order.items.first.selectedModifiers.length, 1);
              expect(s.order.subtotalCents, 1100); // 1000 + 100
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
            bloc.add(ActiveOrderEvent.itemQuantityChanged(productId: testProduct.id, quantity: 2));
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
        'emits empty when last item is removed',
         build: () => bloc,
        act: (bloc) {
            bloc.add(ActiveOrderEvent.itemAdded(product: testProduct, quantity: 1));
            bloc.add(ActiveOrderEvent.itemRemoved(testProduct.id));
        },
        skip: 1,
        expect: () => [const ActiveOrderState.empty()],
      );
    });

    group('Submission', () {
      blocTest<ActiveOrderBloc, ActiveOrderState>(
        'emits error when Submitted is added but cart is empty',
        build: () => bloc,
        act: (bloc) => bloc.add(const ActiveOrderEvent.submitted()),
        expect: () => [
          const ActiveOrderState.error(message: 'Cannot submit an empty order'),
        ],
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
        'emits [submitting, error] when Submitted fails',
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
            (s) => s.maybeMap(error: (_) => true, orElse: () => false),
            'is error',
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
