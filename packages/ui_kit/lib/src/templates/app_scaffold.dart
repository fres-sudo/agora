import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// The base page template.
///
/// A thin, token-aware wrapper over [Scaffold] that paints the background from
/// `context.colors.background` and (optionally) applies responsive horizontal
/// tokenized insets so page content stays comfortably guttered
/// on phones, tablets and desktop without per-page breakpoint code.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.applyResponsiveInsets = false,
    this.safeArea = true,
    this.backgroundColor,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;

  /// When true, wraps [body] in symmetric horizontal padding sized for the
  /// current breakpoint.
  final bool applyResponsiveInsets;
  final bool safeArea;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    if (applyResponsiveInsets) {
      content = Padding(
        padding: EdgeInsets.symmetric(horizontal: context.tokens.spacing.lg),
        child: content,
      );
    }

    if (safeArea) {
      content = SafeArea(top: appBar == null, child: content);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? context.colors.background,
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: content,
    );
  }
}
