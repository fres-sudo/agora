import 'package:ui_kit/ui_kit.dart';
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
                icon: AgoraIcons.user_group,
                label: 'Customer',
                onTap: onCustomerTap,
              ),
            ),
            SizedBox(width: context.tokens.spacing.sm),
            Expanded(
              child: _ActionButton(
                icon: AgoraIcons.map,
                label: 'Tables',
                onTap: onTablesTap,
              ),
            ),
          ],
        ),
        SizedBox(height: context.tokens.spacing.sm),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: AgoraIcons.discount,
                label: 'Discount',
                onTap: onDiscountTap,
              ),
            ),
            SizedBox(width: context.tokens.spacing.sm),
            Expanded(
              child: _ActionButton(
                icon: AgoraIcons.receipt,
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

  const _ActionButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEnabled = onTap != null;
    final contentColor = isEnabled ? colors.foreground : colors.mutedForeground;

    return Material(
      color: colors.card,
      borderRadius: context.tokens.radius.borderLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.tokens.spacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: context.tokens.radius.borderLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: contentColor),
              SizedBox(height: context.tokens.spacing.xxs),
              AppText.bodySm(label, color: contentColor),
            ],
          ),
        ),
      ),
    );
  }
}
