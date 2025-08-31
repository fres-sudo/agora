import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: RootRoute.page,
      children: [AutoRoute(page: HomeRoute.page, fullscreenDialog: true)],
    ),
  ];
}
