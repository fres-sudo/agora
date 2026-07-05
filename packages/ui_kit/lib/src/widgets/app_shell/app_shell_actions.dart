import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';


enum _UserMenuAction { clockToggle, logout }

/// Pill chip showing the current operator/station. Reads from [AppShellScope].
/// Renders nothing if [AppShellScope.currentOperator] is null.
///
/// Set [onDark] when placed on a dark surface (e.g. the sidebar). Set
/// [isCompact] to render only the station icon (collapsed sidebar).
class AppShellOperatorChip extends StatelessWidget {
  const AppShellOperatorChip({
    super.key,
    this.onDark = false,
    this.isCompact = false,
  });

  final bool onDark;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final scope = AppShellScope.maybeOf(context);
    final operator = scope?.currentOperator;
    if (operator == null) return const SizedBox.shrink();

    final bgColor = onDark ? const Color(0xff1f1f1f) : AppPalette.neutral100;
    final borderColor = onDark ? const Color(0xff2b2b2b) : AppPalette.neutral200;
    final iconColor = onDark ? AppPalette.neutral400 : AppPalette.neutral500;
    final textColor = onDark ? Colors.white : AppPalette.neutral700;

    return GestureDetector(
      onTap: scope?.onOperatorSwitchTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 8 : 12,
          vertical: isCompact ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(isCompact ? 10 : 20),
          border: Border.all(color: borderColor),
        ),
        child: isCompact
            ? Icon(Icons.storefront_outlined, size: 16, color: iconColor)
            : Row(
                mainAxisSize: onDark ? MainAxisSize.max : MainAxisSize.min,
                spacing: 6,
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 14,
                    color: iconColor,
                  ),
                  _OperatorLabel(
                    operator: operator,
                    color: textColor,
                    flexible: onDark,
                  ),
                  if (scope?.onOperatorSwitchTap != null)
                    Icon(
                      Icons.unfold_more_rounded,
                      size: 14,
                      color: onDark ? AppPalette.neutral500 : AppPalette.neutral400,
                    ),
                ],
              ),
      ),
    );
  }
}

class _OperatorLabel extends StatelessWidget {
  const _OperatorLabel({
    required this.operator,
    required this.color,
    required this.flexible,
  });

  final String operator;
  final Color color;
  final bool flexible;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      operator,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
    );
    // In the fixed-width sidebar the label flexes/ellipsizes; in the app bar
    // the chip shrink-wraps its text.
    return flexible ? Expanded(child: text) : text;
  }
}

/// Circular menu button that opens the sidebar drawer on narrow screens.
/// Reads [AppShellScope.openSidebar]. Renders nothing on tablet/desktop where
/// the sidebar is always visible. Meant to be overlaid at the top-left of a
/// page body via [Align] / [Stack].
class AppShellMenuButton extends StatelessWidget {
  const AppShellMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.isTabletOrLarger) return const SizedBox.shrink();
    final onTap = AppShellScope.maybeOf(context)?.openSidebar;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.sm),
        child: Material(
          color: context.colors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.borderRadius),
            side: BorderSide(color: context.colors.border),
          ),
          elevation: 2,
          shadowColor: Colors.black12,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Sizes.borderRadius),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                Icons.menu_rounded,
                color: context.colors.foreground,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar button that opens a dropdown with user info, clock in/out, and logout.
/// Reads from [AppShellScope]. Renders nothing if [AppShellScope.userName] is null.
///
/// Set [onDark] when placed on a dark surface (e.g. the sidebar) so the label
/// colors invert for contrast. Set [isCompact] to render only the avatar
/// (used when the sidebar is collapsed).
class AppShellUserMenu extends StatelessWidget {
  const AppShellUserMenu({
    super.key,
    this.onDark = false,
    this.isCompact = false,
  });

  final bool onDark;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final scope = AppShellScope.maybeOf(context);
    final name = scope?.userName;
    if (name == null) return const SizedBox.shrink();

    return PopupMenuButton<_UserMenuAction>(
      offset: const Offset(0, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppPalette.neutral200),
      ),
      elevation: 6,
      shadowColor: Colors.black12,
      itemBuilder: (context) => _buildMenuItems(context, scope!),
      onSelected: (action) {
        if (action == _UserMenuAction.clockToggle) scope?.onClockInTap?.call();
        if (action == _UserMenuAction.logout) scope?.onLogout?.call();
      },
      child: isCompact
          ? _Avatar(name: name, avatarUrl: scope?.userAvatarUrl, radius: 16)
          : _AvatarChip(
              name: name,
              subtitle: scope?.userSubtitle,
              avatarUrl: scope?.userAvatarUrl,
              onDark: onDark,
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
                        color: AppPalette.neutral900,
                      ),
                ),
                if (scope.userSubtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    scope.userSubtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppPalette.primary600,
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
                color: isClockedIn ? AppPalette.error100 : AppPalette.primary50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isClockedIn ? Icons.timer_off_outlined : Icons.timer_outlined,
                size: 16,
                color: isClockedIn ? AppPalette.error500 : AppPalette.primary600,
              ),
            ),
            Text(
              isClockedIn ? 'Clock Out' : 'Clock In',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isClockedIn ? AppPalette.error700 : AppPalette.neutral800,
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
                color: AppPalette.error100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 16,
                color: AppPalette.error500,
              ),
            ),
            Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppPalette.error500,
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
    this.onDark = false,
  });

  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final nameColor = onDark ? Colors.white : AppPalette.neutral900;
    final subtitleColor = onDark ? AppPalette.neutral400 : AppPalette.neutral500;

    final labels = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: nameColor,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: subtitleColor,
                  fontSize: 10,
                ),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        // On a dark surface the chip lives in the fixed-width sidebar, so the
        // labels flex to fill and ellipsize. In the app bar the row shrink-wraps.
        mainAxisSize: onDark ? MainAxisSize.max : MainAxisSize.min,
        spacing: 8,
        children: [
          _Avatar(name: name, avatarUrl: avatarUrl, radius: 16),
          if (onDark) Expanded(child: labels) else labels,
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: onDark ? AppPalette.neutral500 : AppPalette.neutral400,
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
        backgroundColor: AppPalette.neutral200,
      );
    }

    final initials = _initials(name);
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppPalette.primary100,
      child: Text(
        initials,
        style: TextStyle(
          color: AppPalette.primary700,
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
