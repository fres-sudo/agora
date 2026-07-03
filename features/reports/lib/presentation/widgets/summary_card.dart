import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final bool isPositive;
  final Widget icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.trend,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust styling based on available width
        final isCompact = constraints.maxWidth < 200;
        final isNarrow = constraints.maxWidth < 160;

        final colors = context.colors;
        return Container(
          padding: EdgeInsets.all(isNarrow ? Sizes.sm : Sizes.lg),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(Sizes.md),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with icon and title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isNarrow ? Sizes.xs : Sizes.sm),
                    decoration: BoxDecoration(
                      color:
                          (isPositive
                                  ? AppPalette.primary500
                                  : AppPalette.error500)
                              .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: isNarrow ? 16 : 20,
                      height: isNarrow ? 16 : 20,
                      child: FittedBox(child: icon),
                    ),
                  ),
                  const SizedBox(width: Sizes.sm),
                  Expanded(
                    child: AppText.label(
                      title,
                      color: colors.mutedForeground,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Value and trend row
              isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: AppText.headingMd(value),
                        ),
                        const SizedBox(height: Sizes.xxs),
                        _buildTrendBadge(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: AppText.headingMd(value),
                          ),
                        ),
                        const SizedBox(width: Sizes.sm),
                        _buildTrendBadge(),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.label(
          trend,
          color: isPositive ? AppPalette.primary500 : AppPalette.error500,
        ),
        const SizedBox(width: Sizes.xxs),
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? AppPalette.primary500 : AppPalette.error500,
          size: 16,
        ),
      ],
    );
  }
}
