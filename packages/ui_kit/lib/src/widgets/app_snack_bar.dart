import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

/// Shows a standardized floating [SnackBar].
///
/// Use this instead of building `SnackBar`s ad-hoc so success/error surfacing
/// is consistent across the app (checkout, inventory, order detail, printing).
/// Errors use [AppColors.error500]; successes use the default surface.
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.error500 : null,
      ),
    );
}
