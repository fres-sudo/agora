import 'package:flutter/material.dart';
import 'package:agora/core/ui/device.dart';

import 'section_sidebar.dart';
import 'section_sidebar_item.dart';
import 'section_tab_bar.dart';

/// A responsive page layout with sidebar navigation.
///
/// On desktop/tablet: Displays a collapsible sidebar on the left with content on the right.
/// On mobile: Displays a bottom tab bar for navigation.
///
/// Example usage:
/// ```dart
/// SectionPageLayout(
///   items: [
///     SectionSidebarItemData(
///       icon: Icons.store,
///       label: 'Store Setting',
///       child: StoreSettingSection(),
///     ),
///     SectionSidebarItemData(
///       icon: Icons.category,
///       label: 'Category',
///       child: CategorySection(),
///     ),
///   ],
///   selectedIndex: _currentIndex,
///   onItemSelected: (index) => setState(() => _currentIndex = index),
/// )
/// ```
class SectionPageLayout extends StatefulWidget {
  const SectionPageLayout({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.initiallyCollapsed = false,
    this.onCollapsedChanged,
  });

  /// List of navigation items with their associated content widgets.
  final List<SectionSidebarItemData> items;

  /// Currently selected item index.
  final int selectedIndex;

  /// Callback when an item is selected.
  final ValueChanged<int>? onItemSelected;

  /// Whether the sidebar starts in collapsed state.
  final bool initiallyCollapsed;

  /// Callback when the sidebar collapse state changes.
  final ValueChanged<bool>? onCollapsedChanged;

  @override
  State<SectionPageLayout> createState() => _SectionPageLayoutState();
}

class _SectionPageLayoutState extends State<SectionPageLayout> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.initiallyCollapsed;
  }

  void _handleCollapsedChanged(bool collapsed) {
    setState(() => _isCollapsed = collapsed);
    widget.onCollapsedChanged?.call(collapsed);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    if (isMobile) {
      return _buildMobileLayout();
    }

    return _buildDesktopLayout();
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Content area
        Expanded(
          child: _buildContent(),
        ),
        // Bottom tab bar
        SectionTabBar(
          items: widget.items,
          selectedIndex: widget.selectedIndex,
          onItemSelected: widget.onItemSelected,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar
        SectionSidebar(
          items: widget.items,
          selectedIndex: widget.selectedIndex,
          onItemSelected: widget.onItemSelected,
          isCollapsed: _isCollapsed,
          onCollapsedChanged: _handleCollapsedChanged,
        ),
        // Content area
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedIndex = widget.selectedIndex.clamp(0, widget.items.length - 1);
    final selectedItem = widget.items[selectedIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey(selectedIndex),
        child: selectedItem.child,
      ),
    );
  }
}
