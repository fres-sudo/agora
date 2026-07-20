import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class AppShellSidebar extends StatelessWidget {
  const AppShellSidebar({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.isCollapsed = false,
    this.onCollapsedChanged,
    this.logo,
    this.appName = 'agora',
    this.showHeader = true,
    this.showCollapseToggle = true,
    this.showUserMenu = true,
  });

  final List<AppShellNavItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final bool isCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final Widget? logo;
  final String appName;
  final bool showHeader;
  final bool showCollapseToggle;
  final bool showUserMenu;

  static const double expandedWidth = 220;
  static const double collapsedWidth = 72;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isCollapsed ? collapsedWidth : expandedWidth,
      decoration: BoxDecoration(
        color: AppColors.dark.background,
        border: Border(right: BorderSide(color: Color(0xff1f1f1f), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader) _buildHeader(context),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 12, vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final item = items[index];
                return _SidebarNavItem(
                  icon: item.icon,
                  selectedIcon: item.selectedIcon,
                  label: item.label,
                  isSelected: index == selectedIndex,
                  isCollapsed: isCollapsed,
                  isEnabled: item.isEnabled,
                  onTap: item.isEnabled ? () => onItemSelected?.call(index) : null,
                );
              },
            ),
          ),
          if (showUserMenu) _buildUserFooter(context),
          if (showCollapseToggle) _buildCollapseToggle(context),
        ],
      ),
    );
  }

  Widget _buildUserFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xff1f1f1f), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
            child: AppShellOperatorChip(onDark: true, isCompact: isCollapsed),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
            child: AppShellUserMenu(onDark: true, isCompact: isCollapsed),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isCollapsed ? 0 : 20, 20, 0, 12),
      child: isCollapsed
          ? Center(child: logo)
          : AppText.titleMd(appName, color: context.colors.background),
    );
  }

  Widget _buildCollapseToggle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isCollapsed ? 8 : 12, 0, isCollapsed ? 8 : 12, 20),
      child: Align(
        alignment: isCollapsed ? Alignment.center : Alignment.centerRight,
        child: Tooltip(
          message: isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
          preferBelow: false,
          child: InkWell(
            onTap: () => onCollapsedChanged?.call(!isCollapsed),
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xff1f1f1f),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 250),
                  turns: isCollapsed ? 0.5 : 0,
                  child: Icon(
                    AgoraIcons.chevron_left,
                    size: 18,
                    color: AppColors.dark.mutedForeground,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.isSelected = false,
    this.isCollapsed = false,
    this.isEnabled = true,
    this.onTap,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final bool isSelected;
  final bool isCollapsed;
  final bool isEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = !isEnabled
        ? context.colors.foreground
        : isSelected
        ? context.colors.background
        : context.colors.muted.withValues(alpha: 0.7);
    final displayIcon = isSelected ? (selectedIcon ?? icon) : icon;

    return Tooltip(
      message: isCollapsed && isEnabled ? label : '',
      preferBelow: false,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          splashColor: Colors.white10,
          highlightColor: Colors.white10,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 10, vertical: 11),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xff1f1f1f) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: isCollapsed
                ? Center(child: Icon(displayIcon, size: 20, color: iconColor))
                : Flex(
                    direction: Axis.horizontal,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Left accent indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 3,
                        height: 18,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.dark.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Icon(displayIcon, size: 20, color: iconColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: iconColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
