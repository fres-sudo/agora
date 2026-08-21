import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:database/database.dart';
import 'package:order_management/order_management.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Segmented selector for the order's [PaymentMethod] (Cash / Card).
///
/// Reads [SettingsKeys.paymentMethodCashEnabled] /
/// [SettingsKeys.paymentMethodCardEnabled] from [SettingsCubit] to filter
/// the displayed methods. Card defaults off until SumUp is configured.
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
    final cubit = context.watch<SettingsCubit>();
    final enabledMethods = PaymentMethod.values.where((m) {
      return switch (m) {
        PaymentMethod.cash => cubit.getBool(
          SettingsKeys.paymentMethodCashEnabled,
          defaultValue: true,
        ),
        PaymentMethod.card => cubit.getBool(
          SettingsKeys.paymentMethodCardEnabled,
          defaultValue: false,
        ),
      };
    }).toList();

    // Safe fallback: never surface card merely because both toggles are off.
    final methods = enabledMethods.isEmpty
        ? const [PaymentMethod.cash]
        : enabledMethods;

    return Row(
      children: [
        for (final method in methods)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: method == methods.last ? 0 : context.tokens.spacing.xs,
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
    PaymentMethod.cash => AgoraIcons.money,
    PaymentMethod.card => AgoraIcons.card,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = isSelected ? colors.primary : colors.border;
    final foreground = isSelected ? colors.primary : colors.mutedForeground;
    final fill = isSelected ? colors.primary.withValues(alpha: 0.08) : null;

    return Material(
      color: fill,
      type: fill == null ? MaterialType.transparency : MaterialType.canvas,
      borderRadius: BorderRadius.circular(context.tokens.radius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.tokens.radius.md),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.tokens.spacing.sm),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(context.tokens.radius.md),
          ),
          child: Column(
            children: [
              Icon(_icon, color: foreground),
              SizedBox(height: context.tokens.spacing.xxs),
              AppText.label(method.label, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}
