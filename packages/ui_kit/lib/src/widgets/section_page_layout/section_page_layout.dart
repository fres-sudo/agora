import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

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
///       icon: AgoraIcons.building,
///       label: 'Store Setting',
///       child: StoreSettingSection(),
///     ),
///     SectionSidebarItemData(
///       icon: AgoraIcons.categories,
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
    this.title,
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

  /// Page name shown in the mobile app bar. Desktop stays chromeless (the
  /// sidebar already names the page), so this is only used on phone.
  final String? title;

  @override
  State<SectionPageLayout> createState() => _SectionPageLayoutState();
}

class _SectionPageLayoutState extends State<SectionPageLayout> {
  /// Above this many sections the phone tab bar is abandoned in favour of
  /// [SectionMobileNavigator].
  static const int _maxMobileTabs = 5;

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
    // A tab bar only works while the sections fit across the bottom of a
    // phone; past that it silently becomes unusable, so anything longer gets
    // the list-then-detail treatment.
    if (widget.items.length > _maxMobileTabs) {
      return SectionMobileNavigator(
        items: widget.items,
        selectedIndex: widget.selectedIndex,
        onItemSelected: widget.onItemSelected,
        title: widget.title,
      );
    }

    return Column(
      children: [
        AppAppBar(title: widget.title, leading: const AppShellDrawerButton()),
        // Content area
        Expanded(child: _buildContent()),
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
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedIndex = widget.selectedIndex.clamp(
      0,
      widget.items.length - 1,
    );
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
