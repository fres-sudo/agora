import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/src/responsive/responsive_scope.dart';

/// Different categories a device screen can be associated.
// One could add more types if necessary these three should suffice for most apps
enum ScreenSize {
  mobile,
  tablet,
  desktop;

  T map<T>({required T mobile, required T desktop, required T tablet}) {
    switch (this) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet;
      case ScreenSize.desktop:
        return desktop;
    }
  }
}

extension ScreenSizeX on BuildContext {
  /// {@macro BreakPoint.screenType}
  ///
  /// Resolves against the nearest [ResponsiveScope] when one is mounted (the
  /// normal case — the app root installs it), so overlay routes stay in
  /// agreement with the page that opened them and tests can pin a breakpoint.
  /// Falls back to the ambient [MediaQuery] width otherwise.
  ///
  /// Passing an explicit [breakpoint] bypasses the scope and always measures
  /// the ambient width.
  ScreenSize screenSize([BreakPoint? breakpoint]) {
    if (breakpoint == null) {
      final scope = ResponsiveScope.maybeOf(this);
      if (scope != null) return scope.screenSize;
    }
    return (breakpoint ?? BreakPoint.instance).screenType(
      MediaQuery.sizeOf(this).width,
    );
  }

  /// {@macro BreakPoint.isMobile}
  bool get isMobile => screenSize() == ScreenSize.mobile;

  /// {@macro BreakPoint.isTablet}
  bool get isTablet => screenSize() == ScreenSize.tablet;

  /// True if the device screen size is a tablet or desktop.
  bool get isTabletOrLarger =>
      screenSize() == ScreenSize.tablet || screenSize() == ScreenSize.desktop;

  /// {@macro BreakPoint.isDesktop}
  bool get isDesktop => screenSize() == ScreenSize.desktop;

  /// True when the viewport is too short for comfortable vertical chrome —
  /// a phone held in landscape, or a window squeezed by the soft keyboard.
  /// Independent of [screenSize], which is derived from width alone.
  bool get isCompactHeight =>
      ResponsiveScope.maybeOf(this)?.isCompactHeight ??
      MediaQuery.sizeOf(this).height < BreakPoint.compactHeight;

  /// True If the keyboard is visible in the screen
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 100;

  /// Picks one of three values for the current breakpoint. [tablet] falls back
  /// to [desktop] when omitted, which is the common case in this app (the
  /// tablet layout *is* the desktop layout).
  ///
  /// ```dart
  /// final columns = context.responsive(mobile: 2, desktop: 4);
  /// ```
  T responsive<T>({required T mobile, T? tablet, required T desktop}) {
    return screenSize().map(
      mobile: mobile,
      tablet: tablet ?? desktop,
      desktop: desktop,
    );
  }
}

/// A Breakpoint describes (in density) pixels certain points in which the UI should alter its appeal.
/// If a device screen size is greater than [desktop] it should be presented a desktop layout.
/// if its greater than [tablet] a tablet layout, else a [mobile] layout.
/// These breakpoints help to centralize in a place the different rules we apply to adapt apps
/// to different screen sizes.
///
/// See also [Device] as to segment the user experience based on the actual OS running in the device
/// not just the screen.
class BreakPoint {
  final num tablet;
  final num desktop;

  /// Viewport heights below this are "compact" — see
  /// [ScreenSizeX.isCompactHeight]. Sized to catch a phone in landscape
  /// (~390-430dp tall) without tripping on a short desktop window.
  static const double compactHeight = 500;

  static BreakPoint? _instance;

  static BreakPoint get instance {
    return _instance ?? const BreakPoint.agora();
  }

  /// Changes the default BreakPoint [instance] to [breakPoint].
  static void setDefaultBreakPoint(BreakPoint breakPoint) {
    _instance = breakPoint;
  }

  const BreakPoint({required this.tablet, required this.desktop});

  /// The app default. A phone (<600) gets the single-column layouts; a 10"
  /// tablet in portrait (768) and up gets the sidebar/multi-column layouts the
  /// app was originally built for; 1024+ is treated as desktop.
  const BreakPoint.agora() : this(tablet: 600, desktop: 1024);

  //https://developer.android.com/guide/topics/large-screens/support-different-screen-sizes
  const BreakPoint.android() : this(tablet: 600, desktop: 840);

  // https://m1.material.io/layout/responsive-ui.html#responsive-ui-breakpoints
  const BreakPoint.material() : this(tablet: 600, desktop: 960);

  // https://learn.microsoft.com/en-us/windows/apps/design/layout/screen-sizes-and-breakpoints-for-responsive-design
  const BreakPoint.windows() : this(tablet: 640, desktop: 1007);

  // https://developer.apple.com/design/human-interface-guidelines/foundations/layout/
  const BreakPoint.cupertino() : this(tablet: 767, desktop: 1024);

  /// {@template BreakPoint.isMobile}
  /// True if the device screen size is a mobile device according to a [BreakPoint]
  /// {@endtemplate}
  bool isMobile(double width) => width < tablet;

  /// {@template BreakPoint.isTablet}
  /// True if the device screen size is a tablet according to a [BreakPoint].
  /// {@endtemplate}
  bool isTablet(double width) => width >= tablet && width < desktop;

  /// {@template BreakPoint.isDesktop}
  /// True if the device screen size is a tablet according to a [BreakPoint].
  /// {@endtemplate}
  bool isDesktop(double width) => width >= desktop;

  /// {@template BreakPoint.screenType}
  /// Returns the [ScreenSize] for a viewport of [width] logical pixels.
  ///
  /// Keyed on width, not the shortest side, so a desktop window dragged narrow
  /// adopts the phone layout and a tablet in portrait keeps the tablet one.
  /// Height is handled separately by [ScreenSizeX.isCompactHeight].
  /// {@endtemplate}
  ScreenSize screenType(double width) {
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }
}

///Holds common sizes for icons, images, paddings, corners etc
// Change the base [unit] if necessary to accommodate to the design
class Sizes {
  static const double unit = 16;
  static const double xxs = 0.125 * unit;
  static const double xs = 0.25 * unit;
  static const double sm = 0.5 * unit;
  static const double md = 0.75 * unit;
  static const double lg = unit;
  static const double xl = 1.5 * unit;
  static const double xxl = 2 * unit;

  /// Border radius for buttons, cards, inputs etc. Kept a tight 4-6px per the
  /// design system's flat, structural style — never a full pill/capsule.
  static const double borderRadius = 5;

  /// Edge insets and margins for phone breakpoint size.
  static const double edgeInsetsPhone = xl;

  /// Edge insets and margins for tablet breakpoint size.
  static const double edgeInsetsTablet = xl;

  /// Edge insets and margins for desktop and medium desktop breakpoint sizes.
  static const double edgeInsetsDesktop = xl;

  static double responsiveInsets(BuildContext context) {
    final screen = context.screenSize();

    switch (screen) {
      case ScreenSize.mobile:
        return edgeInsetsPhone;
      case ScreenSize.tablet:
        return edgeInsetsTablet;
      case ScreenSize.desktop:
        return edgeInsetsDesktop;
    }
  }
}

/// Workaround to securely asses the underlying Operating System in which the flutter app is executing
// See https://github.com/flutter/flutter/issues/50845
class Device {
  static final isMobileDevice =
      !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  static final isAndroid = !kIsWeb && Platform.isAndroid;
  static final isIOS = !kIsWeb && Platform.isIOS;

  static final isDesktopDevice =
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  static final isLinux = !kIsWeb && Platform.isLinux;
  static final isMacOS = !kIsWeb && Platform.isMacOS;
  static final isWindows = !kIsWeb && Platform.isWindows;

  static const isWeb = kIsWeb;
}
