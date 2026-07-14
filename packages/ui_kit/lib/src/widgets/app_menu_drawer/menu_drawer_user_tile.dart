import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// User profile tile displayed at the bottom of the drawer
class MenuDrawerUserTile extends StatelessWidget {
  const MenuDrawerUserTile({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.showClockIn = true,
    this.isClockedIn = false,
    this.onClockInTap,
  });

  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final bool showClockIn;
  final bool isClockedIn;
  final VoidCallback? onClockInTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          _buildAvatar(context),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.foreground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.colors.mutedForeground,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (showClockIn) _buildClockInButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (avatarUrl != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: context.colors.muted,
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.colors.muted,
        shape: BoxShape.circle,
      ),
      child: Icon(
        AgoraIcons.user_circle,
        color: context.colors.mutedForeground,
        size: 24,
      ),
    );
  }

  Widget _buildClockInButton(BuildContext context) {
    final statusColor = isClockedIn
        ? context.colors.destructive
        : context.colors.success;
    return GestureDetector(
      onTap: onClockInTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isClockedIn ? 'Clock Out' : 'Clock In',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
