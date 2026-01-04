import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:agora/products/models/modifier_group/modifier_group.dart';

extension ModifierGroupFixture on ModifierGroup {
  static ModifierGroupFixtureFactory factory() => ModifierGroupFixtureFactory();
}

class ModifierGroupFixtureFactory extends FixtureFactory<ModifierGroup> {
  @override
  FixtureDefinition<ModifierGroup> definition() => define(
    (faker, [int _ = 0]) => ModifierGroup(
      // TODO put real properties here
      world: faker.randomGenerator.string(10),
    ),
  );
}
