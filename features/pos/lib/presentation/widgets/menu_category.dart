import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// A reusable menu category item widget for the POS system.
/// Displays an icon and a title in a card-like container.
/// Supports [isSelected] state with a primary color indicator on the left.
class MenuCategoryItem extends StatelessWidget {
  /// The text displayed below the icon.
  final String title;

  /// The icon displayed in the center.
  final IconData icon;

  /// Whether this category is currently selected/active.
  final bool isSelected;

  /// Whether the item is enabled for interaction.
  final bool isEnabled;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// The width and height of the square item.
  final double size;

  const MenuCategoryItem({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Background color: card when selected, muted surface when not.
    final Color backgroundColor = isSelected ? colors.card : colors.muted;

    // Content colors based on selection and enabled state.
    final Color contentColor = isEnabled
        ? (isSelected ? colors.foreground : colors.mutedForeground)
        : colors.mutedForeground;

    // Icon color mirrors the content color.
    final Color iconColor = isEnabled
        ? (isSelected ? colors.foreground : colors.mutedForeground)
        : colors.border;

    return Material(
      color: backgroundColor,
      borderRadius: context.tokens.borderRadiusLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: context.tokens.borderRadiusLg,
            // Subtle border when selected to match the image's depth.
            border: isSelected
                ? Border.all(color: colors.border, width: 1.5)
                : null,
          ),
          child: Stack(
            children: [
              // Selection indicator on the left.
              if (isSelected)
                Positioned(
                  left: 0,
                  top: size * 0.25,
                  bottom: size * 0.25,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 6,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              // Main content.
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.tokens.spaceSm,
                  vertical: context.tokens.spaceMd,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 40, color: iconColor),
                      AppText.titleMd(
                        title,
                        color: contentColor,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Disable overlay.
              if (!isEnabled)
                Positioned.fill(
                  child: Container(
                    color: colors.background.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
