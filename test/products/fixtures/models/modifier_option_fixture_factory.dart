import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:agora/products/models/modifier_option/modifier_option.dart';

extension ModifierOptionFixture on ModifierOption {
  static ModifierOptionFixtureFactory factory() => ModifierOptionFixtureFactory();
}

class ModifierOptionFixtureFactory extends FixtureFactory<ModifierOption> {
  @override
  FixtureDefinition<ModifierOption> definition() => define(
    (faker, [int _ = 0]) => ModifierOption(
      // TODO put real properties here
      world: faker.randomGenerator.string(10),
    ),
  );
}
