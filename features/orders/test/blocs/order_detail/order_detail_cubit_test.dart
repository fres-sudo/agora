import 'package:feature_inventory/feature_inventory.dart';
import 'package:feature_orders/feature_orders.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result/result.dart';

import 'order_detail_cubit_test.mocks.dart';

@GenerateMocks([OrdersRepository, InventoryRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockOrdersRepository ordersRepository;
  late MockInventoryRepository inventoryRepository;

  setUp(() {
    ordersRepository = MockOrdersRepository();
    inventoryRepository = MockInventoryRepository();
    provideDummy<Result<Order>>(Result.error(Exception('dummy')));
    provideDummy<Result<Stock>>(Result.error(Exception('dummy')));
  });

  Order order({required OrderStatus status, List<OrderLineItem>? items}) =>
      Order(
        id: 7,
        createdAt: DateTime(2026, 1, 1),
        status: status,
        orderType: OrderType.dineIn,
        items:
            items ??
            const [
              OrderLineItem(
                id: 1,
                productId: 1,
                productName: 'Tagliatelle',
                quantity: 2,
                unitPriceCents: 500,
                selectedModifiers: [],
              ),
              OrderLineItem(
                id: 2,
                productId: 1,
                productName: 'Tagliatelle',
                quantity: 1,
                unitPriceCents: 500,
                selectedModifiers: [],
              ),
            ],
        note: null,
        subtotalCents: 1500,
        taxCents: 0,
        discountCents: 0,
        grandTotalCents: 1500,
      );

  OrderDetailCubit buildCubit() => OrderDetailCubit(
    ordersRepository: ordersRepository,
    inventoryRepository: inventoryRepository,
  );

  group('OrderDetailCubit.voidOrder', () {
    test(
      'restores aggregated stock per product for a COMPLETED order, then voids',
      () async {
        final completed = order(status: OrderStatus.completed);
        when(
          ordersRepository.watchOrderById(7),
        ).thenAnswer((_) => Stream.value(completed));
        when(
          inventoryRepository.restoreForVoidedOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        ).thenAnswer((_) async => Result.ok((productId: 1, quantity: 3)));
        when(
          ordersRepository.voidOrder(7),
        ).thenAnswer((_) async => Result.ok(completed));

        final cubit = buildCubit()..load(7);
        await Future<void>.delayed(Duration.zero);
        await cubit.voidOrder();

        // Two lines of product 1 (qty 2 + 1) aggregate into a single restore
        // call of quantity 3.
        verify(
          inventoryRepository.restoreForVoidedOrder(
            productId: 1,
            quantity: 3,
            orderId: 7,
          ),
        ).called(1);
        verify(ordersRepository.voidOrder(7)).called(1);
        await cubit.close();
      },
    );

    test('does NOT restore stock for a PENDING order', () async {
      final pending = order(status: OrderStatus.pending);
      when(
        ordersRepository.watchOrderById(7),
      ).thenAnswer((_) => Stream.value(pending));
      when(
        ordersRepository.voidOrder(7),
      ).thenAnswer((_) async => Result.ok(pending));

      final cubit = buildCubit()..load(7);
      await Future<void>.delayed(Duration.zero);
      await cubit.voidOrder();

      verifyNever(
        inventoryRepository.restoreForVoidedOrder(
          productId: anyNamed('productId'),
          quantity: anyNamed('quantity'),
          orderId: anyNamed('orderId'),
        ),
      );
      verify(ordersRepository.voidOrder(7)).called(1);
      await cubit.close();
    });

    test('does NOT void when inventory restore fails', () async {
      final completed = order(status: OrderStatus.completed);
      when(
        ordersRepository.watchOrderById(7),
      ).thenAnswer((_) => Stream.value(completed));
      when(
        inventoryRepository.restoreForVoidedOrder(
          productId: anyNamed('productId'),
          quantity: anyNamed('quantity'),
          orderId: anyNamed('orderId'),
        ),
      ).thenAnswer((_) async => Result.error(Exception('stock down')));

      final cubit = buildCubit()..load(7);
      await Future<void>.delayed(Duration.zero);
      await cubit.voidOrder();

      verifyNever(ordersRepository.voidOrder(any));
      await cubit.close();
    });
  });
}
