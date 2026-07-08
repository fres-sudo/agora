import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A token-aware list row with leading/trailing slots.
///
/// TODO(design-system): add dense/three-line layouts and selected state.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: tokens.borderRadiusMd,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spaceMd,
          vertical: tokens.spaceSm,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: tokens.spaceMd)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.titleMd(title),
                  if (subtitle != null)
                    AppText.bodySm(
                      subtitle!,
                      color: context.colors.mutedForeground,
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: tokens.spaceMd),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
