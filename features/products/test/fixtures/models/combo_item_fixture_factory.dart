import 'package:feature_products/feature_products.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';

extension ComboItemFixture on ComboItem {
  static ComboItemFixtureFactory factory() => ComboItemFixtureFactory();
}

class ComboItemFixtureFactory extends FixtureFactory<ComboItem> {
  @override
  FixtureDefinition<ComboItem> definition() => define(
    (faker, [int _ = 0]) => ComboItem(
      productId: faker.randomGenerator.integer(100),
      productName: faker.food.dish(),
      quantity: faker.randomGenerator.integer(3, min: 1),
    ),
  );
}
