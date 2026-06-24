import 'package:auto_route/auto_route.dart';
import 'package:feature_pos/presentation/pages/pos_page.dart';

part 'pos_router.gr.dart';

@AutoRouterConfig()
class PosRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: PosRoute.page),
  ];
}
