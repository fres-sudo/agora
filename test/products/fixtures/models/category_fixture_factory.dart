import 'package:agora/products/models/category/category.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';

extension CategoryFixture on Category {
  static CategoryFixtureFactory factory() => CategoryFixtureFactory();
}

class CategoryFixtureFactory extends FixtureFactory<Category> {
  @override
  FixtureDefinition<Category> definition() => define(
        (faker, [int _ = 0]) => Category(
          id: faker.randomGenerator.integer(100),
          name: faker.food.cuisine(),
        ),
      );
}
