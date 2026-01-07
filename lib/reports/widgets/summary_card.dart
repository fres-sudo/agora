import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';

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

        return Container(
          padding: EdgeInsets.all(isNarrow ? Sizes.sm : Sizes.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.md),
            border: Border.all(color: AppColors.neutral200),
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
                      color: (isPositive
                              ? AppColors.primary500
                              : AppColors.error500)
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
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral700,
                            fontWeight: FontWeight.w500,
                            fontSize: isNarrow ? 12 : null,
                          ),
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
                          child: Text(
                            value,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.neutral900,
                                ),
                          ),
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
                            child: Text(
                              value,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neutral900,
                                  ),
                            ),
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
        Text(
          trend,
          style: TextStyle(
            color: isPositive ? AppColors.primary500 : AppColors.error500,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: Sizes.xxs),
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          color: isPositive ? AppColors.primary500 : AppColors.error500,
          size: 16,
        ),
      ],
    );
  }
}
