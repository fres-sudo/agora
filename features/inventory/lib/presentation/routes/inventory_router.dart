import 'package:auto_route/auto_route.dart';
import 'package:feature_inventory/presentation/pages/inventory_page.dart';

part 'inventory_router.gr.dart';

@AutoRouterConfig()
class InventoryRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: InventoryRoute.page)];
}
