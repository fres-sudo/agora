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
          padding: EdgeInsets.all(
            isNarrow ? context.tokens.spacing.xs : context.tokens.spacing.md,
          ),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(context.tokens.radius.md),
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
                    padding: EdgeInsets.all(
                      isNarrow
                          ? context.tokens.spacing.xxs
                          : context.tokens.spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: (isPositive ? colors.success : colors.destructive)
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: isNarrow ? 16 : 20,
                      height: isNarrow ? 16 : 20,
                      child: FittedBox(child: icon),
                    ),
                  ),
                  SizedBox(width: context.tokens.spacing.xs),
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
                        SizedBox(height: context.tokens.spacing.xxxs),
                        _buildTrendBadge(context),
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
                        SizedBox(width: context.tokens.spacing.xs),
                        _buildTrendBadge(context),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendBadge(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.label(
          trend,
          color: isPositive ? colors.success : colors.destructive,
        ),
        SizedBox(width: context.tokens.spacing.xxxs),
        Icon(
          isPositive ? AgoraIcons.arrow_up_right : AgoraIcons.arrow_down_right,
          color: isPositive ? colors.success : colors.destructive,
          size: 16,
        ),
      ],
    );
  }
}
