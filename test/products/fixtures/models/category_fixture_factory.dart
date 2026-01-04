import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:agora/products/models/category/category.dart';

extension CategoryFixture on Category {
  static CategoryFixtureFactory factory() => CategoryFixtureFactory();
}

class CategoryFixtureFactory extends FixtureFactory<Category> {
  @override
  FixtureDefinition<Category> definition() => define(
    (faker, [int _ = 0]) => Category(
      // TODO put real properties here
      world: faker.randomGenerator.string(10),
    ),
  );
}
