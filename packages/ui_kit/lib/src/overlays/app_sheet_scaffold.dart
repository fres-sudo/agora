import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Chrome for the inside of an [AdaptiveModal]: header, scrolling body and a
/// sticky action footer.
///
/// Written once per form and correct in all three presentations — it reads
/// [AdaptiveModalScope] to decide whether to draw a drag grabber (phone sheet)
/// or a close button (dialog / side sheet), and keeps the footer clear of the
/// soft keyboard.
///
/// [body] is placed inside the sheet's own scroll view, so it should be a
/// plain (non-scrollable) column of fields. Pass [bodyIsScrollable] when the
/// content brings its own scrollable — a list — and needs the full height
/// instead.
class AppSheetScaffold extends StatelessWidget {
  const AppSheetScaffold({
    super.key,
    this.title,
    this.subtitle,
    required this.body,
    this.actions = const [],
    this.scrollController,
    this.bodyIsScrollable = false,
    this.showCloseButton = true,
    this.onClose,
    this.headerTrailing,
    this.padding,
  });

  final String? title;
  final String? subtitle;
  final Widget body;

  /// Buttons pinned to the bottom of the modal. Laid out in a row on wide
  /// presentations and stacked full-width on a phone, where thumb reach and
  /// label length both argue against a cramped row.
  final List<Widget> actions;

  /// The controller handed to the builder by [AdaptiveModal]. Wiring it up is
  /// what lets a drag that starts on the body move the sheet.
  final ScrollController? scrollController;

  final bool bodyIsScrollable;
  final bool showCloseButton;

  /// Defaults to popping the enclosing route with `null`.
  final VoidCallback? onClose;

  /// Optional widget placed in the header before the close button, e.g. a
  /// "Delete" action for an edit form.
  final Widget? headerTrailing;

  final EdgeInsetsGeometry? padding;

  bool get _hasHeader => title != null || subtitle != null;

  @override
  Widget build(BuildContext context) {
    final presentation =
        AdaptiveModalScope.maybeOf(context) ??
        (context.isMobile
            ? AdaptiveModalPresentation.bottomSheet
            : AdaptiveModalPresentation.dialog);
    final isSheet = presentation == AdaptiveModalPresentation.bottomSheet;
    final tokens = context.tokens;
    final contentPadding =
        padding ?? EdgeInsets.symmetric(horizontal: tokens.spacing.xl);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isSheet) const _SheetGrabber(),
        if (_hasHeader)
          Padding(
            padding: EdgeInsets.fromLTRB(
              tokens.spacing.xl,
              isSheet ? tokens.spacing.sm : tokens.spacing.xl,
              tokens.spacing.sm,
              tokens.spacing.sm,
            ),
            child: _Header(
              title: title,
              subtitle: subtitle,
              trailing: headerTrailing,
              showCloseButton: showCloseButton && !isSheet,
              onClose: onClose ?? () => Navigator.of(context).maybePop(),
            ),
          ),
        Flexible(
          child: bodyIsScrollable
              ? Padding(padding: contentPadding, child: body)
              : SingleChildScrollView(
                  controller: scrollController,
                  padding: contentPadding,
                  child: body,
                ),
        ),
        if (actions.isNotEmpty) _Footer(actions: actions, stacked: isSheet),
      ],
    );
  }
}

/// The iOS-style drag handle. Purely decorative — the whole sheet is draggable
/// — but it is the affordance users look for.
class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.tokens.spacing.sm),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: context.colors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.showCloseButton,
    required this.onClose,
  });

  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final bool showCloseButton;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) AppText.headingSm(title!),
              if (subtitle != null) ...[
                SizedBox(height: context.tokens.spacing.xxs),
                AppText.bodySm(
                  subtitle!,
                  color: context.colors.mutedForeground,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
        if (showCloseButton)
          AppIconButton.ghost(
            onPressed: onClose,
            tooltip: 'Close dialog',
            icon: Icon(
              AgoraIcons.x_mark,
              size: context.tokens.iconSize.md,
              color: context.colors.mutedForeground,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.actions, required this.stacked});

  final List<Widget> actions;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    // Lift the footer above the soft keyboard and the home indicator, so the
    // primary action stays tappable while a field is focused.
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.xl,
        tokens.spacing.lg,
        tokens.spacing.xl,
        tokens.spacing.lg + bottomInset,
      ),
      decoration: BoxDecoration(color: context.colors.popover),
      child: stacked
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Primary action last in the list but first on screen: on a
                // phone the bottom-most control is the easiest to reach.
                for (var i = actions.length - 1; i >= 0; i--) ...[
                  if (i < actions.length - 1)
                    SizedBox(height: tokens.spacing.sm),
                  actions[i],
                ],
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) SizedBox(width: tokens.spacing.sm),
                  actions[i],
                ],
              ],
            ),
    );
  }
}
