import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// The semantic tone of an [AppToast].
enum AppToastVariant { info, success, warning, error }

/// A floating, shadcn-inspired feedback surface.
///
/// The widget can be embedded in previews, while the convenience methods show
/// it through the nearest [ScaffoldMessenger]. New messages replace the
/// current toast, keeping time-sensitive POS feedback easy to scan.
///
/// ```dart
/// AppToast.success(
///   context,
///   message: 'Order #42 completed',
///   title: 'Sale complete',
/// );
/// ```
class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.message,
    this.title,
    this.variant = AppToastVariant.info,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.dismissible = true,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'Provide both actionLabel and onAction, or neither.',
       );

  /// Main toast copy. Keep this short enough to be read while working.
  final String message;

  /// Optional heading. Defaults to a title appropriate for [variant].
  final String? title;
  final AppToastVariant variant;

  /// Replaces the icon associated with [variant].
  final IconData? icon;

  /// Optional compact action, such as "Undo" or "Retry".
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Called by the close control when [dismissible] is true.
  final VoidCallback? onDismiss;
  final bool dismissible;

  /// Shows a neutral informational toast.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> info(
    BuildContext context, {
    required String message,
    String? title,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool dismissible = true,
  }) => show(
    context,
    message: message,
    title: title,
    variant: AppToastVariant.info,
    icon: icon,
    actionLabel: actionLabel,
    onAction: onAction,
    duration: duration,
    dismissible: dismissible,
  );

  /// Shows a positive confirmation toast.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> success(
    BuildContext context, {
    required String message,
    String? title,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool dismissible = true,
  }) => show(
    context,
    message: message,
    title: title,
    variant: AppToastVariant.success,
    icon: icon,
    actionLabel: actionLabel,
    onAction: onAction,
    duration: duration,
    dismissible: dismissible,
  );

  /// Shows a cautionary toast.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> warning(
    BuildContext context, {
    required String message,
    String? title,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 5),
    bool dismissible = true,
  }) => show(
    context,
    message: message,
    title: title,
    variant: AppToastVariant.warning,
    icon: icon,
    actionLabel: actionLabel,
    onAction: onAction,
    duration: duration,
    dismissible: dismissible,
  );

  /// Shows an error toast. Errors stay visible a little longer by default.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error(
    BuildContext context, {
    required String message,
    String? title,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 6),
    bool dismissible = true,
  }) => show(
    context,
    message: message,
    title: title,
    variant: AppToastVariant.error,
    icon: icon,
    actionLabel: actionLabel,
    onAction: onAction,
    duration: duration,
    dismissible: dismissible,
  );

  /// Shows a toast with a custom [variant].
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    AppToastVariant variant = AppToastVariant.info,
    String? title,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
    bool dismissible = true,
  }) {
    assert(
      (actionLabel == null) == (onAction == null),
      'Provide both actionLabel and onAction, or neither.',
    );
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    return messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: duration,
        dismissDirection: dismissible
            ? DismissDirection.horizontal
            : DismissDirection.none,
        content: AppToast(
          message: message,
          title: title,
          variant: variant,
          icon: icon,
          actionLabel: actionLabel,
          onAction: actionLabel == null
              ? null
              : () {
                  onAction?.call();
                  messenger.hideCurrentSnackBar();
                },
          onDismiss: messenger.hideCurrentSnackBar,
          dismissible: dismissible,
        ),
      ),
    );
  }

  Color _accent(BuildContext context) {
    final colors = context.colors;
    return switch (variant) {
      AppToastVariant.info => colors.info,
      AppToastVariant.success => colors.success,
      AppToastVariant.warning => colors.warning,
      AppToastVariant.error => colors.destructive,
    };
  }

  String _defaultTitle() => switch (variant) {
    AppToastVariant.info => 'Info',
    AppToastVariant.success => 'Success',
    AppToastVariant.warning => 'Warning',
    AppToastVariant.error => 'Something went wrong',
  };

  IconData _defaultIcon() => switch (variant) {
    AppToastVariant.info => AgoraIcons.info_circle,
    AppToastVariant.success => AgoraIcons.check_circle,
    AppToastVariant.warning => AgoraIcons.alert_triangle,
    AppToastVariant.error => AgoraIcons.alert_circle,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final accent = _accent(context);
    final heading = title ?? _defaultTitle();

    return Semantics(
      container: true,
      liveRegion: true,
      label: '$heading. $message',
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: EdgeInsets.all(tokens.spacing.sm),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: tokens.radius.borderMd,
          border: Border.all(
            color: colors.border,
            width: tokens.border.hairline,
          ),
          boxShadow: tokens.shadows.lg,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? _defaultIcon(),
                color: accent,
                size: tokens.iconSize.md,
              ),
            ),
            SizedBox(width: tokens.spacing.sm),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: tokens.spacing.xxs),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.titleMd(
                      heading,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: tokens.spacing.xxs),
                    AppText.bodySm(
                      message,
                      color: colors.mutedForeground,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (actionLabel != null) ...[
                      SizedBox(height: tokens.spacing.xs),
                      TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          foregroundColor: accent,
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: AppText.label(actionLabel!, color: accent),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (dismissible)
              IconButton(
                onPressed: onDismiss,
                icon: Icon(AgoraIcons.x_mark, size: tokens.iconSize.sm),
                color: colors.mutedForeground,
                tooltip: 'Dismiss',
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}
