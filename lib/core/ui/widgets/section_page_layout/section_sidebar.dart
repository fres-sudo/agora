import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';

import 'section_sidebar_item.dart';

/// A collapsible sidebar for section navigation.
///
/// Displays a list of navigation items with collapse/expand functionality.
/// Shows only icons when collapsed, full items when expanded.
class SectionSidebar extends StatelessWidget {
  const SectionSidebar({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.isCollapsed = false,
    this.onCollapsedChanged,
  });

  /// List of navigation items to display.
  final List<SectionSidebarItemData> items;

  /// Currently selected item index.
  final int selectedIndex;

  /// Callback when an item is selected.
  final ValueChanged<int>? onItemSelected;

  /// Whether the sidebar is collapsed (icons only).
  final bool isCollapsed;

  /// Callback when the collapse state changes.
  final ValueChanged<bool>? onCollapsedChanged;

  /// Width of the sidebar when expanded.
  static const double expandedWidth = 220;

  /// Width of the sidebar when collapsed.
  static const double collapsedWidth = 72;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isCollapsed ? collapsedWidth : expandedWidth,
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        border: Border(
          right: BorderSide(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collapse toggle button
          _buildCollapseButton(context),
          const SizedBox(height: 8),
          // Navigation items
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 8 : 12,
                vertical: 8,
              ),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = items[index];
                return SectionSidebarItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: index == selectedIndex,
                  isCollapsed: isCollapsed,
                  onTap: () => onItemSelected?.call(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapseButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isCollapsed ? 8 : 12,
        16,
        isCollapsed ? 8 : 12,
        0,
      ),
      child: Align(
        alignment: isCollapsed ? Alignment.center : Alignment.centerRight,
        child: IconButton(
          onPressed: () => onCollapsedChanged?.call(!isCollapsed),
          icon: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: isCollapsed ? 0.5 : 0,
            child: const Icon(Icons.chevron_left_rounded),
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.neutral600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: AppColors.neutral200),
            ),
          ),
          iconSize: 20,
          constraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          padding: EdgeInsets.zero,
          tooltip: isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
        ),
      ),
    );
  }
}
