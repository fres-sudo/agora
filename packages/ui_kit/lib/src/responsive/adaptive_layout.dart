import 'package:flutter/material.dart';
import 'package:ui_kit/src/responsive/device.dart';

/// Picks a widget subtree per breakpoint.
///
/// The canonical way to branch layout in this app — features should never
/// reach for [LayoutBuilder] or [MediaQuery] directly. [tablet] defaults to
/// [desktop], which is the usual arrangement here: the multi-column layout
/// serves both, and only the phone needs a distinct tree.
///
/// ```dart
/// AdaptiveLayout(
///   mobile: (context) => const _MobileLayout(),
///   desktop: (context) => const _TabletLayout(),
/// )
/// ```
///
/// Each branch is built lazily, so the off-breakpoint tree costs nothing.
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    return context.responsive<WidgetBuilder>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    )(context);
  }
}

/// Renders [child] only on the matching breakpoints, and nothing otherwise.
///
/// For chrome that belongs to one form factor — a mobile-only app bar action,
/// a desktop-only keyboard hint — where an [AdaptiveLayout] with an empty
/// branch would read as noise.
class BreakpointVisibility extends StatelessWidget {
  const BreakpointVisibility({
    super.key,
    required this.child,
    this.onMobile = true,
    this.onTablet = true,
    this.onDesktop = true,
  });

  /// Shows [child] only on phones.
  const BreakpointVisibility.mobileOnly({super.key, required this.child})
    : onMobile = true,
      onTablet = false,
      onDesktop = false;

  /// Shows [child] on tablet and desktop, but not phones.
  const BreakpointVisibility.tabletAndUp({super.key, required this.child})
    : onMobile = false,
      onTablet = true,
      onDesktop = true;

  final Widget child;
  final bool onMobile;
  final bool onTablet;
  final bool onDesktop;

  @override
  Widget build(BuildContext context) {
    final visible = context.responsive(
      mobile: onMobile,
      tablet: onTablet,
      desktop: onDesktop,
    );
    return visible ? child : const SizedBox.shrink();
  }
}
