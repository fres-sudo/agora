import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A minimal, token-driven top app bar with a hairline bottom border.
///
/// Implements [PreferredSizeWidget] so it can be dropped into
/// `Scaffold.appBar` or `AppScaffold.appBar`.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions = const [],
    this.centerTitle = false,
    this.bottom,
  });

  final String? title;
  final Widget? leading;
  final List<Widget> actions;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  static const double _height = 56;

  @override
  Size get preferredSize =>
      Size.fromHeight(_height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: tokens.border.hairline,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
                child: Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      SizedBox(width: tokens.spacing.sm),
                    ],
                    Expanded(
                      child: title == null
                          ? const SizedBox.shrink()
                          : AppText.headingMd(
                              title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: centerTitle
                                  ? TextAlign.center
                                  : TextAlign.start,
                            ),
                    ),
                    for (final action in actions) action,
                  ],
                ),
              ),
            ),
            if (bottom != null) bottom!,
          ],
        ),
      ),
    );
  }
}
