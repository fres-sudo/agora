import 'package:agora/orders/models/order/order.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'order_line_item_fixture_factory.dart';

extension OrderFixture on Order {
  static OrderFixtureFactory factory() => OrderFixtureFactory();
}

class OrderFixtureFactory extends FixtureFactory<Order> {
  @override
  FixtureDefinition<Order> definition() => define(
        (faker, [int _ = 0]) {
          final items = OrderLineItemFixture.factory().makeMany(3);
          int subtotal = 0;
          for (final item in items) {
            subtotal += item.unitPriceCents * item.quantity;
            for (final mod in item.selectedModifiers) {
              subtotal += mod.priceChangeCents * item.quantity;
            }
          }
          final tax = (subtotal * 0.1).toInt();
          final discount = faker.randomGenerator.boolean() ? 500 : 0;
          final grandTotal = subtotal + tax - discount;

          return Order(
            id: faker.randomGenerator.integer(10000),
            createdAt: faker.date.dateTime(),
            status: OrderStatus.values[faker.randomGenerator.integer(3)],
            items: items,
            note: faker.randomGenerator.boolean() ? faker.lorem.sentence() : null,
            subtotalCents: subtotal,
            taxCents: tax,
            discountCents: discount,
            grandTotalCents: grandTotal,
          );
        },
      );
}
