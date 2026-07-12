import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

/// Displays order totals in the POS order panel.
/// Shows subtotal, tax, voucher/discount, and grand total.
class PosOrderSummary extends StatelessWidget {
  /// Subtotal in cents.
  final int subtotalCents;

  /// Tax amount in cents.
  final int taxCents;

  /// Discount/voucher amount in cents.
  final int discountCents;

  /// Grand total in cents.
  final int grandTotalCents;

  /// Currency symbol to display. Defaults to '$'.
  final String currencySymbol;

  const PosOrderSummary({
    super.key,
    required this.subtotalCents,
    required this.taxCents,
    required this.discountCents,
    required this.grandTotalCents,
    this.currencySymbol = '€',
  });

  String _formatCents(int cents) {
    return '$currencySymbol ${(cents / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasItems = grandTotalCents > 0;
    final valueColor = hasItems ? colors.foreground : colors.mutedForeground;

    return Column(
      children: [
        // Subtotal row
        _SummaryRow(
          label: 'Subtotal',
          value: _formatCents(subtotalCents),
          valueColor: valueColor,
        ),
        SizedBox(height: context.tokens.spaceXs),
        // Tax row
        _SummaryRow(
          label: 'Tax',
          value: _formatCents(taxCents),
          valueColor: valueColor,
        ),
        SizedBox(height: context.tokens.spaceXs),
        // Voucher/Discount row
        _SummaryRow(
          label: 'Voucher',
          value: _formatCents(discountCents),
          valueColor: valueColor,
        ),
        SizedBox(height: context.tokens.spaceSm),
        Divider(height: 1, color: colors.border),
        SizedBox(height: context.tokens.spaceSm),
        // Total row (emphasized)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.body('Total', color: colors.mutedForeground),
            AppText.headingSm(
              '$currencySymbol ${(grandTotalCents / 100).toStringAsFixed(2)}',
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.body(label, color: context.colors.mutedForeground),
        AppText.body(value, color: valueColor),
      ],
    );
  }
}
