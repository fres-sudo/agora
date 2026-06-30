import 'package:feature_orders/feature_orders.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

/// Segmented selector for the order's [PaymentMethod] (Cash / Card).
///
/// For the free tier the set is fixed; P4-5 will make it configurable.
class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PaymentMethod selected;

  /// Null disables interaction (e.g. while a sale is processing).
  final ValueChanged<PaymentMethod>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final method in PaymentMethod.values)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: method == PaymentMethod.values.last ? 0 : Sizes.sm,
              ),
              child: _MethodTile(
                method: method,
                isSelected: method == selected,
                onTap: onChanged == null ? null : () => onChanged!(method),
              ),
            ),
          ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback? onTap;

  IconData get _icon => switch (method) {
    PaymentMethod.cash => Icons.payments_outlined,
    PaymentMethod.card => Icons.credit_card,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? AppColors.primary500 : AppColors.neutral300;
    final foreground = isSelected ? AppColors.primary500 : AppColors.neutral600;

    return Material(
      color: isSelected
          ? AppColors.primary500.withValues(alpha: 0.08)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(Sizes.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Sizes.md),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(Sizes.md),
          ),
          child: Column(
            children: [
              Icon(_icon, color: foreground),
              const SizedBox(height: Sizes.xs),
              Text(
                method.label,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: foreground,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
