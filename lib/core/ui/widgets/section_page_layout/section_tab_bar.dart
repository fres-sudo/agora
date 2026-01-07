import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';

import 'section_sidebar_item.dart';

/// A bottom tab bar for mobile section navigation.
///
/// Displays navigation items as a horizontal scrollable tab bar
/// at the bottom of the screen on mobile devices.
class SectionTabBar extends StatelessWidget {
  const SectionTabBar({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
  });

  /// List of navigation items to display.
  final List<SectionSidebarItemData> items;

  /// Currently selected item index.
  final int selectedIndex;

  /// Callback when an item is selected.
  final ValueChanged<int>? onItemSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: items.length <= 5
              ? Row(
                  children: List.generate(items.length, (index) {
                    return Expanded(
                      child: _buildTabItem(context, theme, index),
                    );
                  }),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 80,
                      child: _buildTabItem(context, theme, index),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, ThemeData theme, int index) {
    final item = items[index];
    final isSelected = index == selectedIndex;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onItemSelected?.call(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Selection indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
            // Icon
            Icon(
              item.icon,
              size: 24,
              color: isSelected ? theme.primaryColor : AppColors.neutral400,
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              item.label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? theme.primaryColor : AppColors.neutral500,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
