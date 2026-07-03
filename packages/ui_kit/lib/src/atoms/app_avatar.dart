import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A circular avatar showing an image or initials fallback.
///
/// TODO(design-system): add status dot, group/stacked avatars and sizes enum.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageProvider,
    this.initials,
    this.size = 40,
    this.label,
  });

  final ImageProvider? imageProvider;
  final String? initials;
  final double size;

  /// Accessible label (e.g. the person's full name).
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: label,
      image: true,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.muted,
          shape: BoxShape.circle,
          border: Border.all(
            color: colors.border,
            width: context.tokens.borderHairline,
          ),
          image: imageProvider == null
              ? null
              : DecorationImage(image: imageProvider!, fit: BoxFit.cover),
        ),
        child: imageProvider == null && initials != null
            ? Text(
                initials!,
                style: context.typography.label.copyWith(
                  color: colors.mutedForeground,
                ),
              )
            : null,
      ),
    );
  }
}
