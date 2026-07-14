import 'package:feature_reports/domain/models/report_data.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

/// Festival-operator "end of day" strip (P5-3): the raw numbers that wrap up an
/// event — cash vs card split, peak trading hour and discounts given — derived
/// entirely from local data.
class EndOfDaySummary extends StatelessWidget {
  const EndOfDaySummary({super.key, required this.summary});

  final ReportSummary summary;

  @override
  Widget build(BuildContext context) {
    final metrics = <_Metric>[
      _Metric(
        icon: AgoraIcons.money,
        label: 'Cash',
        value: formatCents(summary.cashRevenueCents),
      ),
      _Metric(
        icon: AgoraIcons.card,
        label: 'Card',
        value: formatCents(summary.cardRevenueCents),
      ),
      _Metric(
        icon: AgoraIcons.discount,
        label: 'Discounts',
        value: formatCents(summary.totalDiscountCents),
      ),
      _Metric(
        icon: AgoraIcons.clock,
        label: 'Peak Hour',
        value: _formatPeakHour(summary.peakHour),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(Sizes.lg),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Sizes.md),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText.headingSm('End of Day'),
          const SizedBox(height: Sizes.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              // One row on wide layouts, wrap to a grid when cramped.
              final perRow = constraints.maxWidth < 420 ? 2 : metrics.length;
              final spacing = Sizes.md;
              final itemWidth =
                  (constraints.maxWidth - spacing * (perRow - 1)) / perRow;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final metric in metrics)
                    SizedBox(width: itemWidth, child: _MetricTile(metric)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatPeakHour(int? hour) {
    if (hour == null) return '—';
    final end = (hour + 1) % 24;
    String pad(int h) => h.toString().padLeft(2, '0');
    return '${pad(hour)}:00–${pad(end)}:00';
  }
}

class _Metric {
  const _Metric({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile(this.metric);

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(Sizes.sm),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(metric.icon, color: context.colors.primary, size: 18),
        ),
        const SizedBox(width: Sizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.bodySm(
                metric.label,
                color: context.colors.mutedForeground,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.tokens.spaceXxs),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: AppText.titleMd(metric.value),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
