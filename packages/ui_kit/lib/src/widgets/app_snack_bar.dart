import 'package:flutter/material.dart';
import 'package:ui_kit/src/widgets/app_toast.dart';

/// Shows a standardized floating toast.
///
/// Kept for source compatibility while older callers migrate to [AppToast].
/// Deprecated: use [AppToast.info] or [AppToast.error] for semantic feedback.
@Deprecated('Use AppToast.info or AppToast.error instead.')
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  if (isError) {
    AppToast.error(context, message: message);
  } else {
    AppToast.info(context, message: message);
  }
}
