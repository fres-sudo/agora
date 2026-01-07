import 'package:agora/core/ui/theme.dart';
import 'package:flutter/material.dart';

/// A reusable empty state widget for the POS system.
/// Displays an icon, title, optional description, and optional action button.
class PosEmptyState extends StatelessWidget {
  /// The icon to display in the center.
  final IconData icon;

  /// The main title text.
  final String title;

  /// Optional description text below the title.
  final String? description;

  /// Optional action button label.
  final String? actionLabel;

  /// Optional callback when action button is tapped.
  final VoidCallback? onAction;

  /// The size of the icon. Defaults to 48.
  final double iconSize;

  const PosEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with circular background
            Container(
              width: iconSize * 2,
              height: iconSize * 2,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: AppColors.neutral400,
                  ),
                  // Question mark badge
                  Positioned(
                    right: iconSize * 0.15,
                    bottom: iconSize * 0.15,
                    child: Container(
                      width: iconSize * 0.5,
                      height: iconSize * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.neutral300,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.question_mark_rounded,
                        size: iconSize * 0.3,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral800,
              ),
              textAlign: TextAlign.center,
            ),
            // Description
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // Action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
