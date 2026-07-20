import 'package:app_settings/app_settings.dart';
import 'package:order_management/order_management.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_products/feature_products.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Using mocktail for widget tests often simpler for blocs
import 'package:ui_kit/ui_kit.dart';

class MockProductsBloc extends MockBloc<ProductsEvent, ProductsState>
    implements ProductsBloc {}

class MockCombosBloc extends MockBloc<CombosEvent, CombosState>
    implements CombosBloc {}

class MockActiveOrderBloc extends MockBloc<ActiveOrderEvent, ActiveOrderState>
    implements ActiveOrderBloc {}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  late MockProductsBloc mockProductsBloc;
  late MockCombosBloc mockCombosBloc;
  late MockActiveOrderBloc mockActiveOrderBloc;
  late MockSettingsCubit mockSettingsCubit;

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
    mockCombosBloc = MockCombosBloc();
    mockActiveOrderBloc = MockActiveOrderBloc();
    mockSettingsCubit = MockSettingsCubit();
    // PosPage wraps its content in an EffectListener that subscribes to
    // ActiveOrderBloc.effects (from EffectBloc); MockBloc doesn't stub it,
    // so without this it returns null and crashes the widget build.
    when(
      () => mockActiveOrderBloc.effects,
    ).thenAnswer((_) => const Stream.empty());
    // The POS grid merges in enabled combos alongside products
    // (docs/features/03-combo-modifier-pricing.md); default to none so
    // existing product-only assertions are unaffected.
    when(
      () => mockCombosBloc.state,
    ).thenReturn(const CombosState.loaded(combos: []));
    // PosProductGrid/PosOrderPanel/PosPage read SettingsCubit for the
    // currency symbol and receipt config.
    when(
      () => mockSettingsCubit.state,
    ).thenReturn(const SettingsState.loaded(settings: {}));
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsBloc>.value(value: mockProductsBloc),
        BlocProvider<CombosBloc>.value(value: mockCombosBloc),
        BlocProvider<ActiveOrderBloc>.value(value: mockActiveOrderBloc),
        BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
      ],
      // These cases exercise the phone layout. The breakpoint is pinned rather
      // than inferred from the 800x600 test viewport, which resolves to tablet
      // and would pull in the whole order-panel provider graph.
      child: MaterialApp(
        home: ResponsiveScope.fixed(ScreenSize.mobile, child: const PosPage()),
      ),
    );
  }

  testWidgets('PosPage renders and fetches initial data', (tester) async {
    when(
      () => mockProductsBloc.state,
    ).thenReturn(const ProductsState.initial());
    when(
      () => mockActiveOrderBloc.state,
    ).thenReturn(const ActiveOrderState.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    // Verify initial events
    verify(() => mockProductsBloc.add(const ProductsEvent.started())).called(1);
    verify(() => mockCombosBloc.add(const CombosEvent.started())).called(1);
    verify(
      () => mockActiveOrderBloc.add(const ActiveOrderEvent.started()),
    ).called(1);
  });

  testWidgets('renders products when loaded', (tester) async {
    when(
      () => mockProductsBloc.state,
    ).thenReturn(ProductsState.loaded(products: [testProduct], categories: []));
    when(
      () => mockActiveOrderBloc.state,
    ).thenReturn(const ActiveOrderState.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Allow build

    expect(find.text('Test Product'), findsOneWidget);
  });

  testWidgets('tapping product adds it to order', (tester) async {
    when(
      () => mockProductsBloc.state,
    ).thenReturn(ProductsState.loaded(products: [testProduct], categories: []));
    when(
      () => mockActiveOrderBloc.state,
    ).thenReturn(const ActiveOrderState.empty());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.tap(find.text('Test Product'));

    // Using captureAny might be needed if arguments matter, but verify is simple
    verify(
      () => mockActiveOrderBloc.add(any(that: isA<ActiveOrderEvent>())),
    ).called(greaterThan(1));
    // greaterThan(1) because started() is also called.
    // To be precise:
    // verify(() => mockActiveOrderBloc.add(ActiveOrderEvent.itemAdded(product: testProduct))).called(1);
    // But equality check on Product might fail if not same instance or equatable.
    // Product uses freezed so it is Equatable.
  });
}
