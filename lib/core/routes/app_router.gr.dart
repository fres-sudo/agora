// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:agora/auth/pages/auth_shell_page.dart' as _i1;
import 'package:agora/pos/pages/pos_page.dart' as _i2;
import 'package:agora/pos/pages/protected_shell_page.dart' as _i3;
import 'package:auto_route/auto_route.dart' as _i4;

/// generated route for
/// [_i1.AuthShellPage]
class AuthShellRoute extends _i4.PageRouteInfo<void> {
  const AuthShellRoute({List<_i4.PageRouteInfo>? children})
    : super(AuthShellRoute.name, initialChildren: children);

  static const String name = 'AuthShellRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthShellPage();
    },
  );
}

/// generated route for
/// [_i2.PosPage]
class PosRoute extends _i4.PageRouteInfo<void> {
  const PosRoute({List<_i4.PageRouteInfo>? children})
    : super(PosRoute.name, initialChildren: children);

  static const String name = 'PosRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.PosPage();
    },
  );
}

/// generated route for
/// [_i3.ProtectedShellPage]
class ProtectedShellRoute extends _i4.PageRouteInfo<void> {
  const ProtectedShellRoute({List<_i4.PageRouteInfo>? children})
    : super(ProtectedShellRoute.name, initialChildren: children);

  static const String name = 'ProtectedShellRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.ProtectedShellPage();
    },
  );
}
