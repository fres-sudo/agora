import 'package:order_management/order_management.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'selected_modifiers_fixture_factory.dart';

extension OrderLineItemFixture on OrderLineItem {
  static OrderLineItemFixtureFactory factory() => OrderLineItemFixtureFactory();
}

class OrderLineItemFixtureFactory extends FixtureFactory<OrderLineItem> {
  @override
  FixtureDefinition<OrderLineItem> definition() => define(
        (faker, [int _ = 0]) => OrderLineItem(
          id: faker.randomGenerator.integer(100000),
          productId: faker.randomGenerator.integer(1000),
          productName: faker.food.dish(),
          quantity: faker.randomGenerator.integer(5, min: 1),
          unitPriceCents: faker.randomGenerator.integer(2000, min: 500),
          selectedModifiers: SelectedModifiersFixture.factory().makeMany(2),
        ),
      );
}
