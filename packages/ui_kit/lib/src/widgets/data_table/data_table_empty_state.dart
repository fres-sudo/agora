import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Empty state widget displayed when the data table has no items.
class DataTableEmptyState extends StatelessWidget {
  const DataTableEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = AgoraIcons.search,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.xxl * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with circular background
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.colors.muted,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    AgoraIcons.inbox,
                    size: 36,
                    color: context.colors.mutedForeground,
                  ),
                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: context.colors.muted,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colors.muted,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        AgoraIcons.help_circle,
                        size: 20,
                        color: context.colors.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.lg),
            // Title
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Sizes.xs),
            // Subtitle
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
