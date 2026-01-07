import 'package:agora/products/models/product/product.dart';
import 'package:data_fixture_dart/data_fixture_dart.dart';

extension ProductFixture on Product {
  static ProductFixtureFactory factory() => ProductFixtureFactory();
}

class ProductFixtureFactory extends FixtureFactory<Product> {
  @override
  FixtureDefinition<Product> definition() => define(
        (faker, [int _ = 0]) => Product(
          id: faker.randomGenerator.integer(10000),
          name: faker.food.dish(),
          priceCents: faker.randomGenerator.integer(2000, min: 500),
          costCents: faker.randomGenerator.integer(400, min: 100),
          categoryId: faker.randomGenerator.integer(100),
          stockQuantity: faker.randomGenerator.integer(100),
        ),
      );
}
