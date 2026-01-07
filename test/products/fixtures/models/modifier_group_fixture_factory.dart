import 'package:agora/products/models/modifier_group/modifier_group.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';

extension ModifierGroupFixture on ModifierGroup {
  static ModifierGroupFixtureFactory factory() => ModifierGroupFixtureFactory();
}

class ModifierGroupFixtureFactory extends FixtureFactory<ModifierGroup> {
  @override
  FixtureDefinition<ModifierGroup> definition() => define(
        (faker, [int _ = 0]) => ModifierGroup(
          id: faker.randomGenerator.integer(100),
          name: faker.lorem.word(),
          isMultiSelect: faker.randomGenerator.boolean(),
        ),
      );
}
