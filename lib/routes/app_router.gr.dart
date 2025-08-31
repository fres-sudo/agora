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
import 'package:agora/pages/root_page.dart' as _i5;
import 'package:agora/pages/setup/pin_input_page.dart' as _i3;
import 'package:agora/pages/setup/pin_setup_page.dart' as _i4;
import 'package:agora/pages/setup/startup_page.dart' as _i6;
import 'package:auto_route/auto_route.dart' as _i7;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.OrderPage]
class OrderRoute extends _i7.PageRouteInfo<void> {
  const OrderRoute({List<_i7.PageRouteInfo>? children})
    : super(OrderRoute.name, initialChildren: children);

  static const String name = 'OrderRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.OrderPage();
    },
  );
}

/// generated route for
/// [_i3.PinInputPage]
class PinInputRoute extends _i7.PageRouteInfo<void> {
  const PinInputRoute({List<_i7.PageRouteInfo>? children})
    : super(PinInputRoute.name, initialChildren: children);

  static const String name = 'PinInputRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.PinInputPage();
    },
  );
}

/// generated route for
/// [_i4.PinSetupPage]
class PinSetupRoute extends _i7.PageRouteInfo<void> {
  const PinSetupRoute({List<_i7.PageRouteInfo>? children})
    : super(PinSetupRoute.name, initialChildren: children);

  static const String name = 'PinSetupRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.PinSetupPage();
    },
  );
}

/// generated route for
/// [_i5.RootPage]
class RootRoute extends _i7.PageRouteInfo<void> {
  const RootRoute({List<_i7.PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return _i7.WrappedRoute(child: const _i5.RootPage());
    },
  );
}

/// generated route for
/// [_i6.StartupPage]
class StartupRoute extends _i7.PageRouteInfo<void> {
  const StartupRoute({List<_i7.PageRouteInfo>? children})
    : super(StartupRoute.name, initialChildren: children);

  static const String name = 'StartupRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.StartupPage();
    },
  );
}
