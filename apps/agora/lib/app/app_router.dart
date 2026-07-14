import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_inventory/feature_inventory.dart';
import 'package:feature_kitchen/feature_kitchen.dart';
import 'package:feature_onboarding/onboarding.dart';
import 'package:feature_orders/feature_orders.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_products/feature_products.dart';
import 'package:feature_reports/feature_reports.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:feature_workforce/workforce.dart';
import 'package:utils/utils.dart';

import 'pages/protected_shell_page.dart';
import 'pages/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.persistenceService}) : super();

  final PersistenceService persistenceService;

  /// Whether onboarding has been completed. Read synchronously here (prefs are
  /// loaded before `runApp`) so the very first route is correct with no flash
  /// of the POS for a user who hasn't set up yet.
  bool get _onboarded => persistenceService.getBool(SPKeys.onboarding) ?? false;

  @override
  List<AutoRoute> get routes => [
    // First-run setup wizard — the initial route until onboarding is completed.
    AutoRoute(page: OnboardingShellRoute.page, initial: !_onboarded),
    // Splash — the initial route once onboarded. Session restoration is
    // async (secure storage + DB lookup), so we can't yet know whether to
    // land on the PIN login or the protected shell; this neutral route holds
    // the screen until `AppRootListener` resolves the session and redirects,
    // avoiding a flash of protected content for logged-out users.
    AutoRoute(page: SplashRoute.page, initial: _onboarded),
    // Auth shell — PIN login lives here as an initial child
    AutoRoute(
      page: AuthShellRoute.page,
      children: [AutoRoute(page: PinLoginRoute.page, initial: true)],
    ),
    // Protected shell — main app content
    AutoRoute(
      page: ProtectedShellRoute.page,
      children: [
        AutoRoute(page: PosRoute.page),
        AutoRoute(page: OrdersRoute.page),
        AutoRoute(page: OrderDetailRoute.page),
        AutoRoute(page: ReportRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: ProductsRoute.page),
        AutoRoute(page: InventoryRoute.page),
        AutoRoute(page: StationQueueRoute.page),
        AutoRoute(page: EmployeesRoute.page),
        AutoRoute(page: ClockRecordsRoute.page),
      ],
    ),
  ];
}
