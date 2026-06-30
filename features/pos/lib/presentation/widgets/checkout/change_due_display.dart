import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

/// Shows the change owed back to the customer for a cash payment.
///
/// When the tendered amount does not yet cover the total ([isSufficient] is
/// false) it renders a muted prompt instead of a change figure.
class ChangeDueDisplay extends StatelessWidget {
  const ChangeDueDisplay({
    super.key,
    required this.changeDueCents,
    required this.isSufficient,
  });

  final int changeDueCents;
  final bool isSufficient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSufficient ? AppColors.success700 : AppColors.neutral600;
    final background = isSufficient
        ? AppColors.success100
        : AppColors.neutral200.withValues(alpha: 0.4);

    return Container(
      padding: const EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Change Due',
            style: theme.textTheme.titleMedium?.copyWith(color: color),
          ),
          Text(
            isSufficient ? formatCents(changeDueCents) : 'Insufficient',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
