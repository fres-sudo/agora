import 'package:order_management/models/order.dart';
import 'package:order_management/models/order_line_item.dart';
import 'package:order_management/models/selected_modifiers.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:catalog/models/product.dart';
import 'package:catalog/models/product_status.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:feature_reports/domain/models/report_period.dart';
import 'package:feature_reports/data/repositories/reports_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportsRepositoryImpl.getReport', () {
    late _FakeOrdersRepository orders;
    late _FakeProductsRepository products;
    late ReportsRepositoryImpl repository;

    // A fixed "now" so ReportPeriod.all always covers the seeded orders.
    final now = DateTime(2026, 7, 2, 20);

    setUp(() {
      orders = _FakeOrdersRepository();
      products = _FakeProductsRepository();
      repository = ReportsRepositoryImpl(
        ordersRepository: orders,
        productsRepository: products,
      );
    });

    OrderLineItem item({
      required String name,
      required int qty,
      required int priceCents,
      int modifierCents = 0,
    }) => OrderLineItem(
      id: name.hashCode,
      productId: name.hashCode,
      productName: name,
      quantity: qty,
      unitPriceCents: priceCents,
      selectedModifiers: modifierCents == 0
          ? const []
          : [
              SelectedModifiers(
                groupName: 'Extra',
                optionName: 'Cheese',
                priceChangeCents: modifierCents,
              ),
            ],
    );

    Order order({
      required int id,
      required OrderStatus status,
      required List<OrderLineItem> items,
      String? paymentMethod,
      int discountCents = 0,
      int grandTotalCents = 0,
      DateTime? createdAt,
    }) => Order(
      id: id,
      createdAt: createdAt ?? DateTime(2026, 7, 2, 12),
      status: status,
      items: items,
      note: null,
      paymentMethod: paymentMethod,
      subtotalCents: grandTotalCents,
      taxCents: 0,
      discountCents: discountCents,
      grandTotalCents: grandTotalCents,
    );

    test('aggregates only completed orders into the summary', () async {
      orders.orders = [
        order(
          id: 1,
          status: OrderStatus.completed,
          paymentMethod: 'Cash',
          grandTotalCents: 1000,
          discountCents: 100,
          items: [item(name: 'Panino', qty: 2, priceCents: 500)],
        ),
        order(
          id: 2,
          status: OrderStatus.completed,
          paymentMethod: 'Card',
          grandTotalCents: 3000,
          items: [item(name: 'Birra', qty: 3, priceCents: 1000)],
        ),
        // Pending + voided must not count toward revenue/items.
        order(
          id: 3,
          status: OrderStatus.pending,
          grandTotalCents: 9999,
          items: [item(name: 'Panino', qty: 9, priceCents: 500)],
        ),
        order(
          id: 4,
          status: OrderStatus.voided,
          grandTotalCents: 9999,
          items: [item(name: 'Birra', qty: 9, priceCents: 1000)],
        ),
      ];

      final result = await repository.getReport(ReportPeriod.all, now: now);
      final data = result.unwrap();

      expect(data.summary.totalOrders, 2);
      expect(data.summary.totalRevenueCents, 4000);
      expect(data.summary.totalDiscountCents, 100);
      expect(data.summary.itemsSold, 5); // 2 + 3
      expect(data.summary.averageTicketCents, 2000); // 4000 / 2
      expect(data.summary.cashRevenueCents, 1000);
      expect(data.summary.cardRevenueCents, 3000);
    });

    test('counts every status in the status breakdown', () async {
      orders.orders = [
        order(id: 1, status: OrderStatus.completed, items: const []),
        order(id: 2, status: OrderStatus.completed, items: const []),
        order(id: 3, status: OrderStatus.pending, items: const []),
        order(id: 4, status: OrderStatus.voided, items: const []),
      ];

      final data = (await repository.getReport(
        ReportPeriod.all,
        now: now,
      )).unwrap();

      expect(data.statusBreakdown.completed, 2);
      expect(data.statusBreakdown.pending, 1);
      expect(data.statusBreakdown.voided, 1);
      expect(data.statusBreakdown.total, 4);
    });

    test('ranks top products by quantity, summing modifier revenue', () async {
      orders.orders = [
        order(
          id: 1,
          status: OrderStatus.completed,
          grandTotalCents: 3000,
          items: [
            item(name: 'Birra', qty: 3, priceCents: 1000),
            item(name: 'Panino', qty: 1, priceCents: 500, modifierCents: 100),
          ],
        ),
        order(
          id: 2,
          status: OrderStatus.completed,
          grandTotalCents: 1500,
          items: [item(name: 'Panino', qty: 3, priceCents: 500)],
        ),
      ];

      final data = (await repository.getReport(
        ReportPeriod.all,
        now: now,
      )).unwrap();

      expect(data.topProducts.first.name, 'Panino'); // 1 + 3 = 4 units
      expect(data.topProducts.first.quantitySold, 4);
      // 1 * (500 + 100) + 3 * 500 = 600 + 1500 = 2100
      expect(data.topProducts.first.revenueCents, 2100);
      expect(data.topProducts[1].name, 'Birra');
      expect(data.topProducts[1].quantitySold, 3);
    });

    test('derives stock breakdown from tracked products', () async {
      products.products = [
        _product(id: 1, stock: 20, trackStock: true), // in stock
        _product(id: 2, stock: 3, trackStock: true), // low (<= 5)
        _product(id: 3, stock: 0, trackStock: true), // out
        _product(id: 4, stock: 0, trackStock: false), // untracked -> in stock
      ];

      final data = (await repository.getReport(
        ReportPeriod.all,
        now: now,
      )).unwrap();

      expect(data.stockBreakdown.inStock, 2);
      expect(data.stockBreakdown.lowStock, 1);
      expect(data.stockBreakdown.outOfStock, 1);
    });

    test('returns an empty summary when there are no orders', () async {
      final data = (await repository.getReport(
        ReportPeriod.today,
        now: now,
      )).unwrap();

      expect(data.summary.totalOrders, 0);
      expect(data.summary.totalRevenueCents, 0);
      expect(data.topProducts, isEmpty);
      expect(data.recentOrders, isEmpty);
    });
  });
}

Product _product({
  required int id,
  required int stock,
  required bool trackStock,
}) => Product(
  id: id,
  name: 'Product $id',
  categoryId: 1,
  priceCents: 500,
  costCents: 200,
  stockQuantity: stock,
  trackStock: trackStock,
  status: ProductStatus.active,
);

class _FakeOrdersRepository implements OrdersRepository {
  List<Order> orders = [];

  @override
  Stream<List<Order>> watchOrdersByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) => Stream.value(
    orders
        .where(
          (o) =>
              (startDate == null || !o.createdAt.isBefore(startDate)) &&
              (endDate == null || !o.createdAt.isAfter(endDate)),
        )
        .toList(),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

class _FakeProductsRepository implements ProductsRepository {
  List<Product> products = [];

  @override
  Stream<List<Product>> watchAllProducts() => Stream.value(products);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}
