import 'package:agora/orders/models/order_line_item/order_line_item.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'selected_modifiers_fixture_factory.dart';

extension OrderLineItemFixture on OrderLineItem {
  static OrderLineItemFixtureFactory factory() => OrderLineItemFixtureFactory();
}

class OrderLineItemFixtureFactory extends FixtureFactory<OrderLineItem> {
  @override
  FixtureDefinition<OrderLineItem> definition() => define(
        (faker, [int _ = 0]) => OrderLineItem(
          productId: faker.randomGenerator.integer(1000),
          productName: faker.food.dish(),
          quantity: faker.randomGenerator.integer(5, min: 1),
          unitPriceCents: faker.randomGenerator.integer(2000, min: 500),
          selectedModifiers: SelectedModifiersFixture.factory().makeMany(2),
        ),
      );
}
