import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Empty state widget displayed when the data table has no items.
class DataTableEmptyState extends StatelessWidget {
  const DataTableEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = AgoraIcons
        .eye, // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.search_off_rounded
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
                color: AppPalette.neutral200,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    AgoraIcons.invoice,
                    size: 36,
                    color: AppPalette.neutral400,
                  ),
                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppPalette.neutral200,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppPalette.neutral200,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        AgoraIcons
                            .info, // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.help_outline_rounded
                        size: 20,
                        color: AppPalette.neutral500,
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppPalette.neutral500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
