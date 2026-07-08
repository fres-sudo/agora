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
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppPalette.neutral300),
      ),
      child: Row(
        children: [
          _buildAvatar(),
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
                    color: AppPalette.neutral900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.primary500,
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

  Widget _buildAvatar() {
    if (avatarUrl != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: AppPalette.neutral200,
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppPalette.neutral200,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        AgoraIcons.user_circle,
        color: AppPalette.neutral500,
        size: 24,
      ),
    );
  }

  Widget _buildClockInButton(BuildContext context) {
    return GestureDetector(
      onTap: onClockInTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isClockedIn ? AppPalette.error100 : AppPalette.primary50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isClockedIn ? AppPalette.error300 : AppPalette.primary300,
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
                color: isClockedIn
                    ? AppPalette.error500
                    : AppPalette.primary500,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isClockedIn ? 'Clock Out' : 'Clock In',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isClockedIn
                    ? AppPalette.error500
                    : AppPalette.primary600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
