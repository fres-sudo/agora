import 'package:auto_route/auto_route.dart';
import 'package:feature_kitchen/presentation/pages/station_queue_page.dart';

part 'kitchen_router.gr.dart';

@AutoRouterConfig()
class KitchenRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: StationQueueRoute.page)];
}
