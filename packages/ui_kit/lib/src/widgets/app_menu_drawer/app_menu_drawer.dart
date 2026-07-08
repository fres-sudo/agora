import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// A reusable menu drawer widget that displays navigation items,
/// user information, and a logout option.
class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.onLogout,
    this.userName,
    this.userSubtitle,
    this.userAvatarUrl,
    this.showClockIn = true,
    this.isClockedIn = false,
    this.onClockInTap,
    this.logo,
    this.appName = 'agora',
  });

  /// List of menu items to display
  final List<MenuDrawerItemData> items;

  /// Currently selected item index
  final int selectedIndex;

  /// Callback when an item is selected
  final ValueChanged<int>? onItemSelected;

  /// Callback when logout is tapped
  final VoidCallback? onLogout;

  /// User's display name
  final String? userName;

  /// User's subtitle (e.g., employee ID)
  final String? userSubtitle;

  /// User's avatar URL
  final String? userAvatarUrl;

  /// Whether to show the clock in button
  final bool showClockIn;

  /// Whether the user is currently clocked in
  final bool isClockedIn;

  /// Callback when clock in/out is tapped
  final VoidCallback? onClockInTap;

  /// Custom logo widget
  final Widget? logo;

  /// App name displayed in header
  final String appName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppPalette.neutral100,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(child: _buildMenuItems()),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
      child: Row(
        children: [
          logo ?? Icon(AgoraIcons.zap, color: AppPalette.primary500, size: 28),
          const SizedBox(width: 8),
          Text(
            appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppPalette.neutral900,
            ),
          ),
          const Spacer(),
          AppIconButton.ghost(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              AgoraIcons.x_mark,
              color: AppPalette.neutral600,
              size: 24,
            ),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = index == selectedIndex;

          return MenuDrawerItem(
            icon: item.icon,
            label: item.label,
            isSelected: isSelected,
            onTap: () {
              onItemSelected?.call(index);
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logout button
          MenuDrawerItem(
            icon: AgoraIcons.logout,
            label: 'Logout',
            isSelected: false,
            onTap: onLogout,
          ),
          const SizedBox(height: 16),
          // User tile
          if (userName != null)
            MenuDrawerUserTile(
              name: userName!,
              subtitle: userSubtitle,
              avatarUrl: userAvatarUrl,
              showClockIn: showClockIn,
              isClockedIn: isClockedIn,
              onClockInTap: onClockInTap,
            ),
        ],
      ),
    );
  }
}

/// Data class for menu drawer items
class MenuDrawerItemData {
  const MenuDrawerItemData({
    required this.icon,
    required this.label,
    this.route,
  });

  final IconData icon;
  final String label;
  final PageRouteInfo? route;
}
