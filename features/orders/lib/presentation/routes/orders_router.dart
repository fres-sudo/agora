import 'package:auto_route/auto_route.dart';
import 'package:feature_orders/presentation/pages/orders_page.dart';

part 'orders_router.gr.dart';

@AutoRouterConfig()
class OrdersRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: OrdersRoute.page)];
}
