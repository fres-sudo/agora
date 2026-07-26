import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A pulsing placeholder block for loading states, filled with the muted token.
///
/// TODO(design-system): integrate with `skeletonizer` for text-shaped bones and
/// provide `AppSkeleton.text` / `AppSkeleton.circle` helpers.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colors.muted,
            borderRadius: widget.borderRadius ?? context.tokens.radius.borderSm,
          ),
        ),
      ),
    );
  }
}
