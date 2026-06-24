import 'package:auto_route/auto_route.dart';
import 'package:feature_products/presentation/pages/products_page.dart';

part 'products_router.gr.dart';

@AutoRouterConfig()
class ProductsRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ProductsRoute.page),
  ];
}
