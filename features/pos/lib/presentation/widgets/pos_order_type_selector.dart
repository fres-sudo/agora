import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:order_management/models/order_type.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

/// A tab-style selector for choosing order type (Dine In / Take Away).
///
/// The available tabs are gated on the active [BusinessProfile]: a business
/// without dine-in (e.g. quick-service / festival) never sees the Dine In tab,
/// and when only one order type is available the selector hides itself.
///
/// Uses the shared [OrderType] from `feature_orders` so the selection can be
/// persisted on the order (the enum is no longer POS-private).
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
    final profile = context.watch<BusinessProfileCubit>().state;
    final types = [
      if (profile.has(Capability.dineIn)) OrderType.dineIn,
      if (profile.has(Capability.takeaway)) OrderType.takeAway,
    ];
    // Nothing to choose between — hide the selector entirely.
    if (types.length < 2) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: context.colors.muted,
        borderRadius: context.tokens.borderRadiusLg,
      ),
      child: Row(
        children: [
          for (final type in types)
            Expanded(
              child: _OrderTypeTab(
                label: type == OrderType.dineIn ? 'Dine In' : 'Take Away',
                isSelected: selected == type,
                onTap: () => onChanged(type),
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
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.tokens.spaceSm),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(bottom: BorderSide(color: colors.primary, width: 3))
              : null,
        ),
        child: isSelected
            ? AppText.titleMd(
                label,
                textAlign: TextAlign.center,
                color: colors.foreground,
              )
            : AppText.body(
                label,
                textAlign: TextAlign.center,
                color: colors.mutedForeground,
              ),
      ),
    );
  }
}
