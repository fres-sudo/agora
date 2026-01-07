import 'package:agora/core/ui/theme.dart';
import 'package:flutter/material.dart';

/// A 2x2 grid of action buttons for the POS order panel.
/// Displays Customer, Tables, Discount, and Save Bill buttons.
class PosActionButtons extends StatelessWidget {
  /// Callback when Customer button is tapped.
  final VoidCallback? onCustomerTap;

  /// Callback when Tables button is tapped.
  final VoidCallback? onTablesTap;

  /// Callback when Discount button is tapped.
  final VoidCallback? onDiscountTap;

  /// Callback when Save Bill button is tapped.
  final VoidCallback? onSaveBillTap;

  const PosActionButtons({
    super.key,
    this.onCustomerTap,
    this.onTablesTap,
    this.onDiscountTap,
    this.onSaveBillTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.people_outline,
                label: 'Customer',
                onTap: onCustomerTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.table_restaurant_outlined,
                label: 'Tables',
                onTap: onTablesTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.discount_outlined,
                label: 'Discount',
                onTap: onDiscountTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.receipt_long_outlined,
                label: 'Save Bill',
                onTap: onSaveBillTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isEnabled ? AppColors.neutral600 : AppColors.neutral400,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      isEnabled ? AppColors.neutral600 : AppColors.neutral400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
