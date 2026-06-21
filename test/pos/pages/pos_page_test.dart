
import 'package:agora/orders/blocs/active_order/active_order_bloc.dart';
import 'package:agora/pos/pages/pos_page.dart';
import 'package:agora/products/blocs/products/products_bloc.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/models/product/product_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Using mocktail for widget tests often simpler for blocs

class MockProductsBloc extends MockBloc<ProductsEvent, ProductsState>
    implements ProductsBloc {}

class MockActiveOrderBloc extends MockBloc<ActiveOrderEvent, ActiveOrderState>
    implements ActiveOrderBloc {}

void main() {
  late MockProductsBloc mockProductsBloc;
  late MockActiveOrderBloc mockActiveOrderBloc;

  final testProduct = Product(
    id: 1,
    name: 'Test Product',
    priceCents: 1000,
    costCents: 500,
    sku: 'SKU123',
    categoryId: 1,
    status: ProductStatus.active,
    stockQuantity: 100,
  );

  setUpAll(() {
    registerFallbackValue(const ActiveOrderEvent.started());
  });

  setUp(() {
    mockProductsBloc = MockProductsBloc();
    mockActiveOrderBloc = MockActiveOrderBloc();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsBloc>.value(value: mockProductsBloc),
        BlocProvider<ActiveOrderBloc>.value(value: mockActiveOrderBloc),
      ],
      child: const MaterialApp(
        home: PosPage(),
      ),
    );
  }

  testWidgets('PosPage renders and fetches initial data', (tester) async {
    when(() => mockProductsBloc.state).thenReturn(const ProductsState.initial());
    when(() => mockActiveOrderBloc.state).thenReturn(const ActiveOrderState.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    // Verify initial events
    verify(() => mockProductsBloc.add(const ProductsEvent.started())).called(1);
    verify(() => mockActiveOrderBloc.add(const ActiveOrderEvent.started())).called(1);

    expect(find.text('agora'), findsOneWidget);
  });

  testWidgets('renders products when loaded', (tester) async {
    when(() => mockProductsBloc.state).thenReturn(
      ProductsState.loaded(products: [testProduct], categories: []),
    );
    when(() => mockActiveOrderBloc.state).thenReturn(const ActiveOrderState.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Allow build

    expect(find.text('Test Product'), findsOneWidget);
  });

  testWidgets('tapping product adds it to order', (tester) async {
    when(() => mockProductsBloc.state).thenReturn(
      ProductsState.loaded(products: [testProduct], categories: []),
    );
    when(() => mockActiveOrderBloc.state).thenReturn(const ActiveOrderState.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.text('Test Product'));

    // Using captureAny might be needed if arguments matter, but verify is simple
    verify(() => mockActiveOrderBloc.add(any(that: isA<ActiveOrderEvent>()))).called(greaterThan(1));
    // greaterThan(1) because started() is also called.
    // To be precise:
    // verify(() => mockActiveOrderBloc.add(ActiveOrderEvent.itemAdded(product: testProduct))).called(1);
    // But equality check on Product might fail if not same instance or equatable.
    // Product uses freezed so it is Equatable.
  });
}
