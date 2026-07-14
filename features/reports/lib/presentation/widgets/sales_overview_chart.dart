import 'package:feature_reports/domain/models/report_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:i18n/i18n.dart';
import 'package:utils/utils.dart';

/// Revenue-over-time line chart driven by aggregated [SalesPoint]s.
///
/// The X axis is the bucket index (hour / day / month depending on the selected
/// period); labels come from each point. The Y axis is revenue in whole
/// currency units (cents / 100).
class SalesOverviewChart extends StatelessWidget {
  const SalesOverviewChart({super.key, required this.points});

  final List<SalesPoint> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 400;

        return Container(
          padding: EdgeInsets.all(isCompact ? Sizes.md : Sizes.lg),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(Sizes.md),
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.headingSm(t.report.sales_overview),
              SizedBox(height: isCompact ? Sizes.md : Sizes.xl),
              Expanded(
                child: points.isEmpty
                    ? const _EmptyChart()
                    : _buildChart(context, isCompact),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChart(BuildContext context, bool isCompact) {
    final colors = context.colors;
    // Revenue in whole currency units keeps the axis readable.
    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].revenueCents / 100),
    ];

    final maxRevenue = spots
        .map((s) => s.y)
        .fold<double>(0, (max, y) => y > max ? y : max);
    // Round the axis ceiling up to a sensible interval and never zero.
    final maxY = maxRevenue <= 0 ? 10.0 : maxRevenue * 1.2;
    final horizontalInterval = (maxY / 4).clamp(1, double.infinity).toDouble();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: !isCompact,
          horizontalInterval: horizontalInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: colors.border,
            strokeWidth: 1,
            dashArray: const [5, 5],
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: colors.border,
            strokeWidth: 1,
            dashArray: const [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isCompact ? 34 : 44,
              interval: horizontalInterval,
              getTitlesWidget: (value, meta) => AppText.caption(
                value >= 1000
                    ? '${(value / 1000).toStringAsFixed(1)}k'
                    : value.toInt().toString(),
                color: colors.mutedForeground,
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isCompact ? 24 : 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                // Thin out labels when there are many buckets.
                final step = (points.length / 6).ceil();
                if (points.length > 6 && index % step != 0) {
                  return const SizedBox.shrink();
                }
                return AppText.caption(
                  points[index].label,
                  color: colors.mutedForeground,
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (points.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(colors: [colors.primary, colors.primary]),
            barWidth: isCompact ? 3 : 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: points.length <= 12),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  colors.primary.withValues(alpha: 0.3),
                  colors.primary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => colors.popover,
            tooltipBorderRadius: context.tokens.borderRadiusLg,
            getTooltipItems: (touchedBarSpots) => touchedBarSpots.map((
              barSpot,
            ) {
              return LineTooltipItem(
                '${t.report.sales}: ${formatCents((barSpot.y * 100).round())}',
                context.typography.titleMd.copyWith(
                  color: colors.popoverForeground,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText.body(
        'No sales in this period',
        color: context.colors.mutedForeground,
      ),
    );
  }
}
