import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// The phone-only top bar for pages inside the app shell.
///
/// On tablet and desktop the persistent sidebar already supplies navigation
/// and page identity, so these pages stay chromeless; on a phone the sidebar
/// is a drawer and there needs to be something that opens it and says where
/// you are.
///
/// [PreferredSizeWidget.preferredSize] cannot consult the breakpoint, so this
/// is resolved at the call site instead of inside a widget:
///
/// ```dart
/// Scaffold(
///   appBar: AdaptiveAppBar.of(context, title: 'Products'),
///   body: ...,
/// )
/// ```
///
/// Returns null on tablet/desktop, which `Scaffold.appBar` accepts as "no bar".
class AdaptiveAppBar {
  const AdaptiveAppBar._();

  /// Builds the phone app bar, or null when the sidebar is visible anyway.
  ///
  /// [leading] defaults to a menu button wired to [AppShellScope.openSidebar].
  /// Pass [showMenuButton] as false for pages that own their back navigation.
  static PreferredSizeWidget? of(
    BuildContext context, {
    String? title,
    List<Widget> actions = const [],
    Widget? leading,
    bool showMenuButton = true,
    PreferredSizeWidget? bottom,
  }) {
    if (context.isTabletOrLarger) return null;

    return AppAppBar(
      title: title,
      leading:
          leading ?? (showMenuButton ? const AppShellDrawerButton() : null),
      actions: actions,
      bottom: bottom,
    );
  }
}

/// Hamburger button that opens the app shell's navigation drawer. Reads
/// [AppShellScope.openSidebar]; renders nothing when that isn't available.
class AppShellDrawerButton extends StatelessWidget {
  const AppShellDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final onTap = AppShellScope.maybeOf(context)?.openSidebar;
    if (onTap == null) return const SizedBox.shrink();

    return AppIconButton.ghost(
      onPressed: onTap,
      icon: Icon(
        AgoraIcons.menu,
        size: context.tokens.iconLg,
        color: context.colors.foreground,
      ),
    );
  }
}
