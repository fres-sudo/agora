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
    provideDummy<Result<VoidOrderResult>>(Result.error(Exception('dummy')));
    provideDummy<Result<Stock>>(Result.error(Exception('dummy')));
  });

  Order order({
    required OrderStatus status,
    List<OrderLineItem>? items,
  }) =>
      Order(
        id: 7,
        createdAt: DateTime(2026, 1, 1),
        status: status,
        orderType: OrderType.dineIn,
        items: items ??
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
      'voids first (atomically), then restores aggregated stock per product '
      'for a COMPLETED order',
      () async {
        final completed = order(status: OrderStatus.completed);
        final voided = completed.copyWith(status: OrderStatus.voided);
        when(ordersRepository.watchOrderById(7))
            .thenAnswer((_) => Stream.value(completed));
        when(ordersRepository.voidOrder(7)).thenAnswer(
          (_) async => Result.ok((order: voided, wasAlreadyVoided: false)),
        );
        when(
          inventoryRepository.restoreForVoidedOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        ).thenAnswer((_) async => Result.ok((productId: 1, quantity: 3)));

        final cubit = buildCubit()..load(7);
        await Future<void>.delayed(Duration.zero);
        await cubit.voidOrder();

        verify(ordersRepository.voidOrder(7)).called(1);
        // Two lines of product 1 (qty 2 + 1) aggregate into a single restore
        // call of quantity 3.
        verify(
          inventoryRepository.restoreForVoidedOrder(
            productId: 1,
            quantity: 3,
            orderId: 7,
          ),
        ).called(1);
        await cubit.close();
      },
    );

    test('does NOT restore stock for a PENDING order', () async {
      final pending = order(status: OrderStatus.pending);
      final voided = pending.copyWith(status: OrderStatus.voided);
      when(ordersRepository.watchOrderById(7))
          .thenAnswer((_) => Stream.value(pending));
      when(ordersRepository.voidOrder(7)).thenAnswer(
        (_) async => Result.ok((order: voided, wasAlreadyVoided: false)),
      );

      final cubit = buildCubit()..load(7);
      await Future<void>.delayed(Duration.zero);
      await cubit.voidOrder();

      verify(ordersRepository.voidOrder(7)).called(1);
      verifyNever(
        inventoryRepository.restoreForVoidedOrder(
          productId: anyNamed('productId'),
          quantity: anyNamed('quantity'),
          orderId: anyNamed('orderId'),
        ),
      );
      await cubit.close();
    });

    test(
      'still voids the order even when inventory restore fails, and surfaces '
      'a reconciliation error (the transition is the idempotency guard, so '
      'it must land regardless of restore outcome)',
      () async {
        final completed = order(status: OrderStatus.completed);
        final voided = completed.copyWith(status: OrderStatus.voided);
        when(ordersRepository.watchOrderById(7))
            .thenAnswer((_) => Stream.value(completed));
        when(ordersRepository.voidOrder(7)).thenAnswer(
          (_) async => Result.ok((order: voided, wasAlreadyVoided: false)),
        );
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

        verify(ordersRepository.voidOrder(7)).called(1);
        expect(
          cubit.state.maybeMap(error: (_) => true, orElse: () => false),
          isTrue,
        );
        await cubit.close();
      },
    );

    test(
      'retrying voidOrder after the order is already voided does NOT '
      'double-credit stock',
      () async {
        final completed = order(status: OrderStatus.completed);
        final voided = completed.copyWith(status: OrderStatus.voided);

        // First call: not yet voided -> this call performs the transition
        // and is responsible for the restore. Second call (the retry, after
        // reloading — e.g. the operator re-opened the order detail page,
        // which re-subscribes to the now-updated order) sees the order is
        // already voided, so no further restore should happen.
        var callCount = 0;
        when(ordersRepository.voidOrder(7)).thenAnswer((_) async {
          callCount++;
          return Result.ok(
            (order: voided, wasAlreadyVoided: callCount > 1),
          );
        });
        when(
          inventoryRepository.restoreForVoidedOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        ).thenAnswer((_) async => Result.ok((productId: 1, quantity: 3)));

        final cubit = buildCubit();

        when(ordersRepository.watchOrderById(7))
            .thenAnswer((_) => Stream.value(completed));
        cubit.load(7);
        await Future<void>.delayed(Duration.zero);
        await cubit.voidOrder(); // first attempt: claims + restores

        // Simulate a retry: the operator reloads the order (now reflecting
        // the DB's already-voided status from the first attempt) and taps
        // void again.
        when(ordersRepository.watchOrderById(7))
            .thenAnswer((_) => Stream.value(voided));
        cubit.load(7);
        await Future<void>.delayed(Duration.zero);
        await cubit.voidOrder(); // retry: already voided, must not restore

        verify(ordersRepository.voidOrder(7)).called(2);
        verify(
          inventoryRepository.restoreForVoidedOrder(
            productId: 1,
            quantity: 3,
            orderId: 7,
          ),
        ).called(1);
        await cubit.close();
      },
    );
  });
}
