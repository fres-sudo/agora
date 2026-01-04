import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:agora/orders/models/order_line_item/order_line_item.dart';

extension OrderLineItemFixture on OrderLineItem {
  static OrderLineItemFixtureFactory factory() => OrderLineItemFixtureFactory();
}

class OrderLineItemFixtureFactory extends FixtureFactory<OrderLineItem> {
  @override
  FixtureDefinition<OrderLineItem> definition() => define(
    (faker, [int _ = 0]) => OrderLineItem(
      // TODO put real properties here
      world: faker.randomGenerator.string(10),
    ),
  );
}
