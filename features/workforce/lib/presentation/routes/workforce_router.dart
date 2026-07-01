import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:feature_workforce/presentation/pages/clock_records_page.dart';
import 'package:feature_workforce/presentation/pages/employees_page.dart';
import 'package:flutter/widgets.dart';

part 'workforce_router.gr.dart';

@AutoRouterConfig()
class WorkforceRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: EmployeesRoute.page),
    AutoRoute(page: ClockRecordsRoute.page),
  ];
}
