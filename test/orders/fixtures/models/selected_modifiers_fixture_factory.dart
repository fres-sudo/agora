import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:agora/orders/models/selected_modifiers/selected_modifiers.dart';

extension SelectedModifiersFixture on SelectedModifiers {
  static SelectedModifiersFixtureFactory factory() => SelectedModifiersFixtureFactory();
}

class SelectedModifiersFixtureFactory extends FixtureFactory<SelectedModifiers> {
  @override
  FixtureDefinition<SelectedModifiers> definition() => define(
    (faker, [int _ = 0]) => SelectedModifiers(
      // TODO put real properties here
      world: faker.randomGenerator.string(10),
    ),
  );
}
