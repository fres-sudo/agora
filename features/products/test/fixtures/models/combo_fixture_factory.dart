import 'package:feature_products/feature_products.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';

extension ComboFixture on Combo {
  static ComboFixtureFactory factory() => ComboFixtureFactory();
}

class ComboFixtureFactory extends FixtureFactory<Combo> {
  @override
  FixtureDefinition<Combo> definition() => define(
    (faker, [int _ = 0]) => Combo(
      id: faker.randomGenerator.integer(100),
      name: faker.food.dish(),
      priceCents: faker.randomGenerator.integer(2000, min: 500),
      isEnabled: faker.randomGenerator.boolean(),
    ),
  );
}
