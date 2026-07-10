import 'package:bloc_test/bloc_test.dart';
import 'package:discounts/discounts.dart';
import 'package:feature_inventory/feature_inventory.dart';
import 'package:order_management/order_management.dart';
import 'package:feature_products/feature_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';

import 'checkout_cubit_test.mocks.dart';

@GenerateMocks([
  OrdersRepository,
  InventoryRepository,
  ProductsRepository,
  DiscountsRepository,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockOrdersRepository ordersRepository;
  late MockInventoryRepository inventoryRepository;
  late MockProductsRepository productsRepository;
  late MockDiscountsRepository discountsRepository;
  late FakePrinterService printerService;

  // A cart-shaped order (status pending, id null/0) ready for checkout.
  Order buildCart({
    List<OrderLineItem>? items,
    int grandTotalCents = 1000,
  }) {
    return Order(
      id: 0,
      createdAt: DateTime(2026, 1, 1),
      status: OrderStatus.pending,
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
          ],
      note: null,
      subtotalCents: grandTotalCents,
      taxCents: 0,
      discountCents: 0,
      grandTotalCents: grandTotalCents,
    );
  }

  Product product({required int id, bool trackStock = true}) => Product(
        id: id,
        name: 'P$id',
        categoryId: 1,
        priceCents: 500,
        costCents: 200,
        stockQuantity: 100,
        trackStock: trackStock,
      );

  CheckoutCubit buildCubit() => CheckoutCubit(
        ordersRepository: ordersRepository,
        inventoryRepository: inventoryRepository,
        productsRepository: productsRepository,
        discountsRepository: discountsRepository,
        printerService: printerService,
      );

  setUpAll(() {
    provideDummy<Result<Order>>(Result.error(Exception('dummy')));
    provideDummy<Result<Order?>>(Result.error(Exception('dummy')));
    provideDummy<Result<Product?>>(Result.error(Exception('dummy')));
    provideDummy<Result<Stock>>(Result.error(Exception('dummy')));
  });

  setUp(() {
    ordersRepository = MockOrdersRepository();
    inventoryRepository = MockInventoryRepository();
    productsRepository = MockProductsRepository();
    discountsRepository = MockDiscountsRepository();
    printerService = FakePrinterService();
  });

  tearDown(() => printerService.dispose());

  // Helper: a completed order as returned by createOrder.
  Order completedFrom(Order cart, {int id = 42, String? method = 'Cash'}) =>
      cart.copyWith(
          id: id, status: OrderStatus.completed, paymentMethod: method);

  group('CheckoutCubit', () {
    test('initial state is initial', () {
      expect(buildCubit().state, const CheckoutState.initial());
    });

    blocTest<CheckoutCubit, CheckoutState>(
      'start() emits selecting with cash default and zero tender',
      build: buildCubit,
      act: (cubit) => cubit.start(buildCart()),
      expect: () => [
        isA<CheckoutSelecting>()
            .having((s) => s.method, 'method', PaymentMethod.cash)
            .having((s) => s.tenderedCents, 'tendered', 0),
      ],
    );

    blocTest<CheckoutCubit, CheckoutState>(
      'selectMethod(card) switches method and resets tender',
      build: buildCubit,
      act: (cubit) {
        cubit.start(buildCart());
        cubit.setTendered(2000);
        cubit.selectMethod(PaymentMethod.card);
      },
      verify: (cubit) {
        expect(cubit.state.method, PaymentMethod.card);
        expect(cubit.state.tenderedCents, 0);
      },
    );

    test('cash: canConfirm only when tendered covers total; change computed',
        () {
      final cubit = buildCubit()..start(buildCart(grandTotalCents: 1000));

      cubit.setTendered(500);
      expect(cubit.state.canConfirm, isFalse);
      expect(cubit.state.changeDueCents, 0);

      cubit.setTendered(1500);
      expect(cubit.state.canConfirm, isTrue);
      expect(cubit.state.changeDueCents, 500);
    });

    test('card: canConfirm immediately without tender', () {
      final cubit = buildCubit()..start(buildCart());
      cubit.selectMethod(PaymentMethod.card);
      expect(cubit.state.canConfirm, isTrue);
    });

    blocTest<CheckoutCubit, CheckoutState>(
      'confirm() persists a COMPLETED order with the payment method (P1-2/P1-3)',
      build: buildCubit,
      setUp: () {
        when(ordersRepository.createOrder(any)).thenAnswer((invocation) async {
          final order = invocation.positionalArguments.first as Order;
          return Result.ok(order.copyWith(id: 42));
        });
        when(productsRepository.getProductById(any))
            .thenAnswer((_) async => Result.ok(product(id: 1)));
        when(
          inventoryRepository.decrementForOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        ).thenAnswer(
          (_) async => Result.ok((productId: 1, quantity: 98)),
        );
      },
      act: (cubit) {
        cubit.start(buildCart(grandTotalCents: 1000));
        cubit.setTendered(1000);
        return cubit.confirm();
      },
      verify: (cubit) {
        final captured =
            verify(ordersRepository.createOrder(captureAny)).captured;
        final persisted = captured.single as Order;
        expect(persisted.status, OrderStatus.completed);
        expect(persisted.paymentMethod, 'Cash');
        expect(cubit.state, isA<CheckoutSuccess>());
      },
    );

    blocTest<CheckoutCubit, CheckoutState>(
      'confirm() decrements stock for TRACKED products (P1-4)',
      build: buildCubit,
      setUp: () {
        when(ordersRepository.createOrder(any)).thenAnswer((invocation) async {
          final order = invocation.positionalArguments.first as Order;
          return Result.ok(order.copyWith(id: 42));
        });
        when(productsRepository.getProductById(1))
            .thenAnswer((_) async => Result.ok(product(id: 1)));
        when(
          inventoryRepository.decrementForOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        ).thenAnswer((_) async => Result.ok((productId: 1, quantity: 98)));
      },
      act: (cubit) {
        cubit.start(buildCart()); // qty 2 of product 1
        cubit.setTendered(1000);
        return cubit.confirm();
      },
      verify: (_) {
        verify(
          inventoryRepository.decrementForOrder(
            productId: 1,
            quantity: 2,
            orderId: 42,
          ),
        ).called(1);
      },
    );

    blocTest<CheckoutCubit, CheckoutState>(
      'confirm() does NOT decrement stock for untracked products (P1-4)',
      build: buildCubit,
      setUp: () {
        when(ordersRepository.createOrder(any)).thenAnswer((invocation) async {
          final order = invocation.positionalArguments.first as Order;
          return Result.ok(order.copyWith(id: 42));
        });
        when(productsRepository.getProductById(1)).thenAnswer(
          (_) async => Result.ok(product(id: 1, trackStock: false)),
        );
      },
      act: (cubit) {
        cubit.start(buildCart());
        cubit.setTendered(1000);
        return cubit.confirm();
      },
      verify: (_) {
        verifyNever(
          inventoryRepository.decrementForOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        );
      },
    );

    blocTest<CheckoutCubit, CheckoutState>(
      'confirm() emits failure when the order cannot be persisted',
      build: buildCubit,
      setUp: () {
        when(ordersRepository.createOrder(any))
            .thenAnswer((_) async => Result.error(Exception('db down')));
      },
      act: (cubit) {
        cubit.start(buildCart());
        cubit.setTendered(1000);
        return cubit.confirm();
      },
      verify: (cubit) {
        expect(cubit.state, isA<CheckoutState>());
        cubit.state.maybeMap(
          failure: (_) {},
          orElse: () => fail('expected failure state'),
        );
        verifyNever(
          inventoryRepository.decrementForOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        );
      },
    );

    blocTest<CheckoutCubit, CheckoutState>(
      'a stock decrement failure does NOT fail the sale (money already taken)',
      build: buildCubit,
      setUp: () {
        when(ordersRepository.createOrder(any)).thenAnswer((invocation) async {
          final order = invocation.positionalArguments.first as Order;
          return Result.ok(order.copyWith(id: 42));
        });
        when(productsRepository.getProductById(any))
            .thenAnswer((_) async => Result.ok(product(id: 1)));
        when(
          inventoryRepository.decrementForOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        ).thenAnswer((_) async => Result.error(Exception('stock error')));
      },
      act: (cubit) {
        cubit.start(buildCart());
        cubit.setTendered(1000);
        return cubit.confirm();
      },
      verify: (cubit) => expect(cubit.state, isA<CheckoutSuccess>()),
    );

    group('receipt printing (P2-3)', () {
      void stubSuccessfulSale() {
        when(ordersRepository.createOrder(any)).thenAnswer((invocation) async {
          final order = invocation.positionalArguments.first as Order;
          return Result.ok(order.copyWith(id: 42));
        });
        when(productsRepository.getProductById(any))
            .thenAnswer((_) async => Result.ok(product(id: 1)));
        when(
          inventoryRepository.decrementForOrder(
            productId: anyNamed('productId'),
            quantity: anyNamed('quantity'),
            orderId: anyNamed('orderId'),
          ),
        ).thenAnswer((_) async => Result.ok((productId: 1, quantity: 98)));
      }

      test('success state carries a rendered receipt for the preview',
          () async {
        stubSuccessfulSale();
        final cubit = buildCubit();
        cubit.start(
          buildCart(grandTotalCents: 1000),
          receiptConfig: const ReceiptConfig(storeName: 'Sagra'),
        );
        cubit.setTendered(1500);
        await cubit.confirm();

        final state = cubit.state as CheckoutSuccess;
        expect(state.receipt, isNotNull);
        expect(state.receipt!.storeName, 'Sagra');
        expect(state.receipt!.orderNumber, '42');
        // Cash change is captured on the receipt.
        expect(state.receipt!.changeCents, 500);
        expect(state.printStatus, PrintStatus.idle);
        await cubit.close();
      });

      test('printReceipt sends bytes and marks status printed', () async {
        stubSuccessfulSale();
        final cubit = buildCubit();
        cubit.start(buildCart(grandTotalCents: 1000));
        cubit.setTendered(1000);
        await cubit.confirm();

        await cubit.printReceipt();

        expect(printerService.printedJobs, hasLength(1));
        expect(printerService.printedJobs.single, isNotEmpty);
        expect(
            (cubit.state as CheckoutSuccess).printStatus, PrintStatus.printed);
        await cubit.close();
      });

      test('printReceipt marks status failed when the printer errors',
          () async {
        stubSuccessfulSale();
        printerService.failPrint = true;
        final cubit = buildCubit();
        cubit.start(buildCart(grandTotalCents: 1000));
        cubit.setTendered(1000);
        await cubit.confirm();

        await cubit.printReceipt();

        expect(
            (cubit.state as CheckoutSuccess).printStatus, PrintStatus.failed);
        await cubit.close();
      });

      test('printReceipt is a no-op when not in success state', () async {
        final cubit = buildCubit();
        await cubit.printReceipt();
        expect(cubit.state, isA<CheckoutState>());
        expect(printerService.printedJobs, isEmpty);
        await cubit.close();
      });
    });
  });

  // Keep the completedFrom helper referenced to avoid unused warnings if the
  // suite evolves; it documents the expected shape of a finished order.
  test('completedFrom helper builds a completed order', () {
    final done = completedFrom(buildCart());
    expect(done.status, OrderStatus.completed);
    expect(done.id, 42);
  });
}
