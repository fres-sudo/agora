import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:agora/orders/models/order/order.dart';

extension OrderFixture on Order {
  static OrderFixtureFactory factory() => OrderFixtureFactory();
}

class OrderFixtureFactory extends FixtureFactory<Order> {
  @override
  FixtureDefinition<Order> definition() => define(
    (faker, [int _ = 0]) => Order(
      // TODO put real properties here
      world: faker.randomGenerator.string(10),
    ),
  );
}
