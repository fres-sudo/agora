import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';

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
    final theme = Theme.of(context);

    // Background color: White when selected, light neutral when not.
    final Color backgroundColor = isSelected
        ? Colors.white
        : AppColors.neutral100;

    // Content colors based on selection and enabled state.
    final Color contentColor = isEnabled
        ? (isSelected ? AppColors.neutral800 : AppColors.neutral600)
        : AppColors.neutral400;

    // Icon color: slightly more muted when not selected.
    final Color iconColor = isEnabled
        ? (isSelected ? AppColors.neutral800 : AppColors.neutral400)
        : AppColors.neutral300;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            // Subtle border when selected to match the image's depth.
            border: isSelected
                ? Border.all(color: AppColors.neutral200, width: 1.5)
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
                  child: Container(
                    width: 6,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              // Main content.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 40, color: iconColor),
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: contentColor,
                        ),
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
                  child: Container(color: Colors.white.withValues(alpha: 0.3)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
