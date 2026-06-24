import 'package:auto_route/auto_route.dart';
import 'package:feature_reports/presentation/pages/report_page.dart';

part 'reports_router.gr.dart';

@AutoRouterConfig()
class ReportsRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ReportRoute.page),
  ];
}
