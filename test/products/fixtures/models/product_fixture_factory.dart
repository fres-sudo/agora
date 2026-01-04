import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:agora/products/models/product/product.dart';

extension ProductFixture on Product {
  static ProductFixtureFactory factory() => ProductFixtureFactory();
}

class ProductFixtureFactory extends FixtureFactory<Product> {
  @override
  FixtureDefinition<Product> definition() => define(
    (faker, [int _ = 0]) => Product(
      // TODO put real properties here
      world: faker.randomGenerator.string(10),
    ),
  );
}
