import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:ui_kit/ui_kit.dart';

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
    final colors = context.colors;
    final color = isSufficient ? colors.success : colors.foreground;
    final background = isSufficient
        ? colors.success.withValues(alpha: 0.12)
        : colors.muted;

    return Container(
      padding: EdgeInsets.all(context.tokens.spacing.sm),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.tokens.radius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.titleMd('Change Due', color: color),
          AppText.titleLg(
            isSufficient
                ? context.formatCurrency(changeDueCents)
                : 'Insufficient',
            color: color,
          ),
        ],
      ),
    );
  }
}
