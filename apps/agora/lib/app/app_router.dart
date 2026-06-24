import 'package:agora/app/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_orders/feature_orders.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_products/feature_products.dart';
import 'package:feature_reports/feature_reports.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:utils/utils.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.persistenceService}) : super();

  final PersistenceService persistenceService;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthShellRoute.page),
    AutoRoute(
      initial: true,
      page: ProtectedShellRoute.page,
      children: [
        AutoRoute(page: PosRoute.page),
        AutoRoute(page: OrdersRoute.page),
        AutoRoute(page: ReportRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: ProductsRoute.page),
      ],
    ),
  ];
}
