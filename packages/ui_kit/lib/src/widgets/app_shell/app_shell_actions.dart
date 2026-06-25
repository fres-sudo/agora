import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

import 'app_shell_scope.dart';

enum _UserMenuAction { clockToggle, logout }

/// Pill chip showing the current operator/station. Reads from [AppShellScope].
/// Renders nothing if [AppShellScope.currentOperator] is null.
class AppShellOperatorChip extends StatelessWidget {
  const AppShellOperatorChip({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppShellScope.maybeOf(context);
    final operator = scope?.currentOperator;
    if (operator == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: scope?.onOperatorSwitchTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            const Icon(
              Icons.storefront_outlined,
              size: 14,
              color: AppColors.neutral500,
            ),
            Text(
              operator,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral700,
                  ),
            ),
            if (scope?.onOperatorSwitchTap != null)
              const Icon(
                Icons.unfold_more_rounded,
                size: 14,
                color: AppColors.neutral400,
              ),
          ],
        ),
      ),
    );
  }
}

/// Avatar button that opens a dropdown with user info, clock in/out, and logout.
/// Reads from [AppShellScope]. Renders nothing if [AppShellScope.userName] is null.
class AppShellUserMenu extends StatelessWidget {
  const AppShellUserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppShellScope.maybeOf(context);
    final name = scope?.userName;
    if (name == null) return const SizedBox.shrink();

    return PopupMenuButton<_UserMenuAction>(
      offset: const Offset(0, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.neutral200),
      ),
      elevation: 6,
      shadowColor: Colors.black12,
      itemBuilder: (context) => _buildMenuItems(context, scope!),
      onSelected: (action) {
        if (action == _UserMenuAction.clockToggle) scope?.onClockInTap?.call();
        if (action == _UserMenuAction.logout) scope?.onLogout?.call();
      },
      child: _AvatarChip(
        name: name,
        subtitle: scope?.userSubtitle,
        avatarUrl: scope?.userAvatarUrl,
      ),
    );
  }

  List<PopupMenuEntry<_UserMenuAction>> _buildMenuItems(
    BuildContext context,
    AppShellScope scope,
  ) {
    final isClockedIn = scope.isClockedIn;

    return [
      // User info header
      PopupMenuItem<_UserMenuAction>(
        enabled: false,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Row(
          spacing: 12,
          children: [
            _Avatar(
              name: scope.userName!,
              avatarUrl: scope.userAvatarUrl,
              radius: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  scope.userName!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral900,
                      ),
                ),
                if (scope.userSubtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    scope.userSubtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary600,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
      const PopupMenuDivider(height: 1),
      // Clock in / Clock out
      PopupMenuItem<_UserMenuAction>(
        value: _UserMenuAction.clockToggle,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          spacing: 12,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isClockedIn ? AppColors.error100 : AppColors.primary50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isClockedIn ? Icons.timer_off_outlined : Icons.timer_outlined,
                size: 16,
                color: isClockedIn ? AppColors.error500 : AppColors.primary600,
              ),
            ),
            Text(
              isClockedIn ? 'Clock Out' : 'Clock In',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isClockedIn ? AppColors.error700 : AppColors.neutral800,
                  ),
            ),
          ],
        ),
      ),
      const PopupMenuDivider(height: 1),
      // Logout
      PopupMenuItem<_UserMenuAction>(
        value: _UserMenuAction.logout,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          spacing: 12,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.error100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 16,
                color: AppColors.error500,
              ),
            ),
            Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.error500,
                  ),
            ),
          ],
        ),
      ),
    ];
  }
}

class _AvatarChip extends StatelessWidget {
  const _AvatarChip({
    required this.name,
    this.subtitle,
    this.avatarUrl,
  });

  final String name;
  final String? subtitle;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          _Avatar(name: name, avatarUrl: avatarUrl, radius: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral900,
                    ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral500,
                        fontSize: 10,
                      ),
                ),
            ],
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: AppColors.neutral400,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    this.avatarUrl,
    required this.radius,
  });

  final String name;
  final String? avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: AppColors.neutral200,
      );
    }

    final initials = _initials(name);
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary100,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.primary700,
          fontSize: radius * 0.65,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
