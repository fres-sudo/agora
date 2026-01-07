import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';

/// Data class for section sidebar/tab bar items.
class SectionSidebarItemData {
  const SectionSidebarItemData({
    required this.icon,
    required this.label,
    required this.child,
  });

  /// The icon displayed for this item.
  final IconData icon;

  /// The label text for this item.
  final String label;

  /// The content widget to display when this item is selected.
  final Widget child;
}

/// A single sidebar navigation item with selection indicator.
///
/// Displays an icon and label, with a green left indicator when selected.
/// Supports collapsed mode where only the icon is shown.
class SectionSidebarItem extends StatelessWidget {
  const SectionSidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.isCollapsed = false,
    this.onTap,
  });

  /// The icon to display.
  final IconData icon;

  /// The label text (hidden when collapsed).
  final String label;

  /// Whether this item is currently selected.
  final bool isSelected;

  /// Whether the sidebar is in collapsed mode.
  final bool isCollapsed;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 12 : 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: AppColors.neutral200, width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: isCollapsed ? MainAxisSize.min : MainAxisSize.max,
            children: [
              // Selection indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 4,
                height: 24,
                margin: EdgeInsets.only(right: isCollapsed ? 8 : 12),
                decoration: BoxDecoration(
                  color: isSelected ? theme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Icon
              Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.neutral800 : AppColors.neutral500,
              ),
              // Label (hidden when collapsed)
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isSelected ? AppColors.neutral800 : AppColors.neutral600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
