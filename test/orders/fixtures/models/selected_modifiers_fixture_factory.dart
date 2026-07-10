import 'package:order_management/order_management.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';

extension SelectedModifiersFixture on SelectedModifiers {
  static SelectedModifiersFixtureFactory factory() =>
      SelectedModifiersFixtureFactory();
}

class SelectedModifiersFixtureFactory
    extends FixtureFactory<SelectedModifiers> {
  @override
  FixtureDefinition<SelectedModifiers> definition() => define(
        (faker, [int _ = 0]) => SelectedModifiers(
          groupName: faker.lorem.word(),
          optionName: faker.lorem.word(),
          priceChangeCents: faker.randomGenerator.integer(500),
        ),
      );
}
