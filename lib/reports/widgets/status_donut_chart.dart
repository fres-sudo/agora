import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';

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

        return Container(
          padding: EdgeInsets.all(isCompact ? Sizes.md : Sizes.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.md),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                            fontSize: isCompact ? 16 : null,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onShowAll != null)
                    TextButton(
                      onPressed: onShowAll,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? Sizes.xs : Sizes.sm,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Show All',
                        style: TextStyle(fontSize: isCompact ? 12 : 14),
                      ),
                    ),
                ],
              ),
              SizedBox(height: isCompact ? Sizes.md : Sizes.xl),
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
                        Text(
                          totalValue.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.neutral900,
                                fontSize: isVeryCompact ? 20 : null,
                              ),
                        ),
                        Text(
                          totalLabel,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.neutral500,
                                    fontSize: isVeryCompact ? 10 : null,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: isCompact ? Sizes.md : Sizes.xl),
              // Legend
              ...data.map((d) => Padding(
                    padding: EdgeInsets.only(
                        bottom: isCompact ? Sizes.xxs : Sizes.xs),
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
                        const SizedBox(width: Sizes.sm),
                        Expanded(
                          child: Text(
                            d.label,
                            style: TextStyle(
                              color: AppColors.neutral600,
                              fontSize: isCompact ? 12 : 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          d.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                            fontSize: isCompact ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                  )),
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

  DonutData({
    required this.label,
    required this.value,
    required this.color,
  });
}
