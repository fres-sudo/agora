import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Shows a standardized floating [SnackBar].
///
/// Use this instead of building `SnackBar`s ad-hoc so success/error surfacing
/// is consistent across the app (checkout, inventory, order detail, printing).
/// Errors use `context.colors.destructive`; successes use the default surface.
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
        backgroundColor: isError ? context.colors.destructive : null,
      ),
    );
}
