// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:agora/pages/home_page.dart' as _i1;
import 'package:agora/pages/order_page.dart' as _i2;
import 'package:agora/pages/root_page.dart' as _i3;
import 'package:auto_route/auto_route.dart' as _i4;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.OrderPage]
class OrderRoute extends _i4.PageRouteInfo<void> {
  const OrderRoute({List<_i4.PageRouteInfo>? children})
    : super(OrderRoute.name, initialChildren: children);

  static const String name = 'OrderRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.OrderPage();
    },
  );
}

/// generated route for
/// [_i3.RootPage]
class RootRoute extends _i4.PageRouteInfo<void> {
  const RootRoute({List<_i4.PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.WrappedRoute(child: const _i3.RootPage());
    },
  );
}
