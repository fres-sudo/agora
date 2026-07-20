import 'package:flutter/material.dart';
import 'package:ui_kit/src/responsive/device.dart';

/// Publishes the resolved [ScreenSize] to the whole subtree.
///
/// Mounted once near the app root. Two reasons it exists rather than every
/// widget re-deriving the size from [MediaQuery]:
///
/// 1. Overlay routes (dialogs, sheets, drawers) build against the *root*
///    navigator's MediaQuery. Reading the breakpoint from a scope inherited
///    through the widget tree keeps a sheet's internals in agreement with the
///    page that opened it.
/// 2. It is a single seam for tests and for previewing a layout at another
///    breakpoint — wrap a subtree in `ResponsiveScope.fixed(ScreenSize.mobile)`
///    and everything below it renders the phone layout.
///
/// Widgets should never call [MediaQuery] for layout decisions; use
/// `context.screenSize()`, `context.isMobile`, [AdaptiveLayout], or
/// `context.responsive(...)` instead.
class ResponsiveScope extends InheritedWidget {
  const ResponsiveScope({
    super.key,
    required this.screenSize,
    required this.isCompactHeight,
    required super.child,
  });

  /// Wraps [child] in a scope whose values are derived from the ambient
  /// [MediaQuery]. This is the form used at the app root.
  static Widget fromMediaQuery({Key? key, required Widget child}) =>
      _MediaQueryResponsiveScope(key: key, child: child);

  /// Forces a fixed [screenSize] for the subtree. Intended for tests, golden
  /// files, and widget previews.
  factory ResponsiveScope.fixed(
    ScreenSize screenSize, {
    Key? key,
    bool isCompactHeight = false,
    required Widget child,
  }) => ResponsiveScope(
    key: key,
    screenSize: screenSize,
    isCompactHeight: isCompactHeight,
    child: child,
  );

  final ScreenSize screenSize;

  /// True when the viewport is too short for comfortable vertical chrome
  /// (phone in landscape, or a keyboard-shrunk window). Layouts use it to drop
  /// headers/illustrations independently of the width-derived [screenSize].
  final bool isCompactHeight;

  static ResponsiveScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();

  @override
  bool updateShouldNotify(ResponsiveScope oldWidget) =>
      screenSize != oldWidget.screenSize ||
      isCompactHeight != oldWidget.isCompactHeight;
}

class _MediaQueryResponsiveScope extends StatelessWidget {
  const _MediaQueryResponsiveScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ResponsiveScope(
      screenSize: BreakPoint.instance.screenType(size.width),
      isCompactHeight: size.height < BreakPoint.compactHeight,
      child: child,
    );
  }
}
