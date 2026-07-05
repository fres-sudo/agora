import 'package:auto_route/auto_route.dart';
import 'package:feature_onboarding/presentation/pages/onboarding_shell_page.dart';

part 'onboarding_router.gr.dart';

@AutoRouterConfig()
class OnboardingRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: OnboardingShellRoute.page)];
}
