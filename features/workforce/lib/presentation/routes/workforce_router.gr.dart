// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'workforce_router.dart';

/// generated route for
/// [ClockRecordsPage]
class ClockRecordsRoute extends PageRouteInfo<ClockRecordsRouteArgs> {
  ClockRecordsRoute({Key? key, int? employeeId, List<PageRouteInfo>? children})
    : super(
        ClockRecordsRoute.name,
        args: ClockRecordsRouteArgs(key: key, employeeId: employeeId),
        initialChildren: children,
      );

  static const String name = 'ClockRecordsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClockRecordsRouteArgs>(
        orElse: () => const ClockRecordsRouteArgs(),
      );
      return ClockRecordsPage(key: args.key, employeeId: args.employeeId);
    },
  );
}

class ClockRecordsRouteArgs {
  const ClockRecordsRouteArgs({this.key, this.employeeId});

  final Key? key;

  final int? employeeId;

  @override
  String toString() {
    return 'ClockRecordsRouteArgs{key: $key, employeeId: $employeeId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClockRecordsRouteArgs) return false;
    return key == other.key && employeeId == other.employeeId;
  }

  @override
  int get hashCode => key.hashCode ^ employeeId.hashCode;
}

/// generated route for
/// [EmployeesPage]
class EmployeesRoute extends PageRouteInfo<void> {
  const EmployeesRoute({List<PageRouteInfo>? children})
    : super(EmployeesRoute.name, initialChildren: children);

  static const String name = 'EmployeesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EmployeesPage();
    },
  );
}
