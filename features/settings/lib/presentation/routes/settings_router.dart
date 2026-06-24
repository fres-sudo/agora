import 'package:auto_route/auto_route.dart';
import 'package:feature_settings/presentation/pages/settings_page.dart';

part 'settings_router.gr.dart';

@AutoRouterConfig()
class SettingsRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SettingsRoute.page),
  ];
}
