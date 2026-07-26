import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ui_kit/ui_kit.dart';

class StatusDonutChart extends StatelessWidget {
  final String title;
  final String totalLabel;
  final int totalValue;
  final List<DonutData> data;
  final VoidCallback? onShowAll;

  const StatusDonutChart({
    super.key,
    required this.title,
    required this.totalLabel,
    required this.totalValue,
    required this.data,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 300;
        final isVeryCompact = constraints.maxWidth < 220;

        // Adjust donut size based on available space
        final centerRadius = isVeryCompact
            ? 40.0
            : isCompact
            ? 50.0
            : 60.0;
        final pieRadius = isVeryCompact ? 16.0 : 20.0;

        final colors = context.colors;
        return Container(
          padding: EdgeInsets.all(
            isCompact ? context.tokens.spacing.sm : context.tokens.spacing.md,
          ),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(context.tokens.radius.md),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText.headingSm(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onShowAll != null)
                    AppButton.ghost(
                      onPressed: onShowAll,
                      label: 'Show All',
                      size: AppButtonSize.sm,
                    ),
                ],
              ),
              SizedBox(
                height: isCompact
                    ? context.tokens.spacing.sm
                    : context.tokens.spacing.lg,
              ),
              // Chart
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: centerRadius,
                        startDegreeOffset: -90,
                        sections: data.map((d) {
                          return PieChartSectionData(
                            color: d.color,
                            value: d.value.toDouble(),
                            title: '',
                            radius: pieRadius,
                          );
                        }).toList(),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.headingMd(totalValue.toString()),
                        AppText.bodySm(
                          totalLabel,
                          color: colors.mutedForeground,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: isCompact
                    ? context.tokens.spacing.sm
                    : context.tokens.spacing.lg,
              ),
              // Legend
              ...data.map(
                (d) => Padding(
                  padding: EdgeInsets.only(
                    bottom: isCompact
                        ? context.tokens.spacing.xxxs
                        : context.tokens.spacing.xxs,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: d.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: context.tokens.spacing.xs),
                      Expanded(
                        child: AppText.body(
                          d.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppText.titleMd(d.value.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DonutData {
  final String label;
  final int value;
  final Color color;

  DonutData({required this.label, required this.value, required this.color});
}
