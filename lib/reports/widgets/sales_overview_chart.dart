import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/i18n/strings.g.dart';

class SalesOverviewChart extends StatelessWidget {
  const SalesOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 400;

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
              Text(
                t.report.sales_overview,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                      fontSize: isCompact ? 16 : null,
                    ),
              ),
              SizedBox(height: isCompact ? Sizes.md : Sizes.xl),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: !isCompact,
                      horizontalInterval: isCompact ? 2000 : 1000,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: AppColors.neutral200,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return const FlLine(
                          color: AppColors.neutral200,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: isCompact ? 30 : 40,
                          getTitlesWidget: (value, meta) {
                            final interval = isCompact ? 2000 : 1000;
                            if (value % interval != 0) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              isCompact
                                  ? '${(value / 1000).toInt()}k'
                                  : value.toInt().toString(),
                              style: TextStyle(
                                color: AppColors.neutral500,
                                fontSize: isCompact ? 10 : 12,
                              ),
                            );
                          },
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
                            const months = [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                              'Jul',
                              'Aug',
                              'Sep',
                              'Oct',
                              'Nov',
                              'Dec',
                            ];
                            // Mock data for May to Oct as in the image
                            final index = value.toInt();
                            if (index < 4 || index > 9) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              months[index],
                              style: TextStyle(
                                color: AppColors.neutral500,
                                fontSize: isCompact ? 10 : 12,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 4,
                    maxX: 9,
                    minY: 0,
                    maxY: 7000,
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(4, 2000),
                          FlSpot(5, 3500),
                          FlSpot(6, 3000),
                          FlSpot(7, 4500),
                          FlSpot(8, 4000),
                          FlSpot(9, 6000),
                        ],
                        isCurved: true,
                        gradient: const LinearGradient(
                          colors: [AppColors.primary500, AppColors.primary300],
                        ),
                        barWidth: isCompact ? 3 : 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary500.withValues(alpha: 0.3),
                              AppColors.primary300.withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => Colors.white,
                        tooltipBorderRadius: BorderRadius.circular(8),
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          return touchedBarSpots.map((barSpot) {
                            final flSpot = barSpot;
                            return LineTooltipItem(
                              '${t.report.sales}: \$${flSpot.y.toInt()}',
                              const TextStyle(
                                color: AppColors.neutral900,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
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
