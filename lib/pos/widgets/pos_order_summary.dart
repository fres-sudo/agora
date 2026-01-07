import 'package:agora/core/ui/theme.dart';
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
    this.currencySymbol = '\$',
  });

  String _formatCents(int cents) {
    return '$currencySymbol ${(cents / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasItems = grandTotalCents > 0;

    return Column(
      children: [
        // Subtotal row
        _SummaryRow(
          label: 'Subtotal',
          value: _formatCents(subtotalCents),
          valueColor: hasItems ? AppColors.neutral800 : AppColors.neutral400,
        ),
        const SizedBox(height: 8),
        // Tax row
        _SummaryRow(
          label: 'Tax',
          value: _formatCents(taxCents),
          valueColor: hasItems ? AppColors.neutral800 : AppColors.neutral400,
        ),
        const SizedBox(height: 8),
        // Voucher/Discount row
        _SummaryRow(
          label: 'Voucher',
          value: _formatCents(discountCents),
          valueColor: hasItems ? AppColors.neutral800 : AppColors.neutral400,
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.neutral200),
        const SizedBox(height: 12),
        // Total row (emphasized)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral600,
              ),
            ),
            Text(
              '$currencySymbol ${(grandTotalCents / 100).toStringAsFixed(2)}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral800,
              ),
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
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.neutral500,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
