import 'package:agora/app/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_inventory/feature_inventory.dart';
import 'package:feature_orders/feature_orders.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_products/feature_products.dart';
import 'package:feature_reports/feature_reports.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:feature_workforce/workforce.dart';
import 'package:utils/utils.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.persistenceService}) : super();

  final PersistenceService persistenceService;

  @override
  List<AutoRoute> get routes => [
    // Auth shell — PIN login lives here as an initial child
    AutoRoute(page: AuthShellRoute.page, children: [
      AutoRoute(page: PinLoginRoute.page, initial: true),
    ]),
    // Protected shell — main app content
    AutoRoute(
      initial: true,
      page: ProtectedShellRoute.page,
      children: [
        AutoRoute(page: PosRoute.page),
        AutoRoute(page: OrdersRoute.page),
        AutoRoute(page: OrderDetailRoute.page),
        AutoRoute(page: ReportRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: ProductsRoute.page),
        AutoRoute(page: InventoryRoute.page),
        AutoRoute(page: EmployeesRoute.page),
        AutoRoute(page: ClockRecordsRoute.page),
      ],
    ),
  ];
}
