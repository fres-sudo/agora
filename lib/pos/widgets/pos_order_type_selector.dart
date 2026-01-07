import 'package:agora/core/ui/theme.dart';
import 'package:flutter/material.dart';

/// Order type for the POS system.
enum OrderType { dineIn, takeAway }

/// A tab-style selector for choosing order type (Dine In / Take Away).
class PosOrderTypeSelector extends StatelessWidget {
  /// Currently selected order type.
  final OrderType selected;

  /// Callback when order type is changed.
  final ValueChanged<OrderType> onChanged;

  const PosOrderTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _OrderTypeTab(
              label: 'Dine In',
              isSelected: selected == OrderType.dineIn,
              onTap: () => onChanged(OrderType.dineIn),
            ),
          ),
          Expanded(
            child: _OrderTypeTab(
              label: 'Take Away',
              isSelected: selected == OrderType.takeAway,
              onTap: () => onChanged(OrderType.takeAway),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTypeTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OrderTypeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary500 : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.neutral800 : AppColors.neutral500,
          ),
        ),
      ),
    );
  }
}
