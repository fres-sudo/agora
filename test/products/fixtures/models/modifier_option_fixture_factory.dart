import 'package:feature_products/feature_products.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';

extension ModifierOptionFixture on ModifierOption {
  static ModifierOptionFixtureFactory factory() =>
      ModifierOptionFixtureFactory();
}

class ModifierOptionFixtureFactory extends FixtureFactory<ModifierOption> {
  @override
  FixtureDefinition<ModifierOption> definition() => define(
        (faker, [int _ = 0]) => ModifierOption(
          id: faker.randomGenerator.integer(1000),
          name: faker.lorem.word(),
          priceChangeCents: faker.randomGenerator.integer(300),
        ),
      );
}
