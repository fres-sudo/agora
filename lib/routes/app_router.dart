import 'package:agora/guards/pin_guard.dart';
import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      guards: [PinGuard()],
      initial: true,
      page: StartupRoute.page,
      path: '/',
    ),
    AutoRoute(page: PinInputRoute.page, path: '/pin-input'),
    AutoRoute(page: PinSetupRoute.page, path: '/pin-setup'),
    AutoRoute(
      page: RootRoute.page,
      path: '/root',
      children: [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: OrderRoute.page, fullscreenDialog: true),
      ],
    ),
  ];
}
