import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A small, token-aware activity indicator.
///
/// Defaults to `context.colors.primary` and `context.tokens.iconMd`, so it
/// stays legible in both themes without configuration.
class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key, this.size, this.color, this.strokeWidth = 2});

  final double? size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? context.tokens.iconMd;
    return Semantics(
      label: 'Loading',
      liveRegion: true,
      child: SizedBox(
        height: dimension,
        width: dimension,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? context.colors.primary,
          ),
        ),
      ),
    );
  }
}
