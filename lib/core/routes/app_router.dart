import 'package:auto_route/auto_route.dart';
import 'package:agora/core/services/persistence/persistence_service.dart';
import 'package:agora/core/routes/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.persistenceService}) : super();

  final PersistenceService persistenceService;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: ProtectedShellRoute.page,
      children: [AutoRoute(page: HomeRoute.page)],
    ),
  ];
}
