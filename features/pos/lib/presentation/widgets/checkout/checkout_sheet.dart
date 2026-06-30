import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_orders/feature_orders.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

import 'package:feature_pos/presentation/widgets/checkout/change_due_display.dart';
import 'package:feature_pos/presentation/widgets/checkout/payment_method_selector.dart';

/// The checkout / payment sheet (P1-5).
///
/// Presents an order summary, a payment-method selector and — for cash — a
/// money keypad with live change calculation. On confirmation it drives the
/// [CheckoutCubit] to persist the completed order and decrement stock, then
/// pops returning the finished [Order] so the caller can clear the cart.
class CheckoutSheet extends StatelessWidget {
  const CheckoutSheet({super.key, this.scrollController});

  final ScrollController? scrollController;

  /// Opens the checkout sheet for [order]. Resolves with the completed [Order]
  /// when the sale succeeds, or `null` if the operator dismissed it.
  static Future<Order?> show(BuildContext context, Order order) {
    final cubit = context.read<CheckoutCubit>()..start(order);

    return AdaptiveSheet.show<Order>(
      context: context,
      builder: (sheetContext, scrollController) {
        // Re-provide the already-registered cubit so the sheet (built under the
        // root navigator) can access it regardless of tree position.
        return BlocProvider<CheckoutCubit>.value(
          value: cubit,
          child: CheckoutSheet(scrollController: scrollController),
        );
      },
    ).whenComplete(cubit.cancel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) => current is CheckoutSuccess,
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          Navigator.of(context).pop(state.order);
        }
      },
      builder: (context, state) {
        return Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Sizes.lg),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.lg),
              child: SingleChildScrollView(
                controller: scrollController,
                child: _CheckoutBody(state: state),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckoutBody extends StatelessWidget {
  const _CheckoutBody({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<CheckoutCubit>();
    final method = state.method ?? PaymentMethod.cash;
    final isProcessing = state.isProcessing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Drag handle.
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: Sizes.md),
            decoration: BoxDecoration(
              color: AppColors.neutral300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Text(
          'Checkout',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Sizes.md),

        // Total to pay.
        _TotalRow(totalCents: state.totalCents),
        const SizedBox(height: Sizes.lg),

        // Payment method.
        Text('Payment Method', style: theme.textTheme.titleSmall),
        const SizedBox(height: Sizes.sm),
        PaymentMethodSelector(
          selected: method,
          onChanged: isProcessing ? null : cubit.selectMethod,
        ),
        const SizedBox(height: Sizes.lg),

        // Cash-only: tender entry + change.
        if (method.requiresTender) ...[
          _CashSection(state: state),
          const SizedBox(height: Sizes.lg),
        ],

        // Error message (failure state).
        if (state.maybeMap(failure: (s) => s.message, orElse: () => null)
            case final String message) ...[
          _ErrorBanner(message: message),
          const SizedBox(height: Sizes.md),
        ],

        // Confirm button.
        AppButton.primary(
          label: method.requiresTender ? 'Confirm Cash Payment' : 'Charge Card',
          fullWidth: true,
          isLoading: isProcessing,
          onPressed: state.canConfirm && !isProcessing ? cubit.confirm : null,
        ),
        const SizedBox(height: Sizes.sm),
        AppButton.outline(
          label: 'Cancel',
          fullWidth: true,
          onPressed: isProcessing ? null : () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.totalCents});

  final int totalCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
        color: AppColors.neutral200.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total', style: theme.textTheme.titleMedium),
          Text(
            formatCents(totalCents),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CashSection extends StatelessWidget {
  const _CashSection({required this.state});

  final CheckoutState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<CheckoutCubit>();
    final tendered = state.tenderedCents;
    final total = state.totalCents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Amount tendered display.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Amount Tendered', style: theme.textTheme.titleSmall),
            Text(
              formatCents(tendered),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: Sizes.sm),

        // Quick-tender presets.
        _QuickTenderRow(totalCents: total, onSelected: cubit.setTendered),
        const SizedBox(height: Sizes.md),

        // Keypad.
        MoneyKeypad(valueCents: tendered, onChanged: cubit.setTendered),
        const SizedBox(height: Sizes.md),

        // Change due.
        ChangeDueDisplay(
          changeDueCents: state.changeDueCents,
          isSufficient: tendered >= total,
        ),
      ],
    );
  }
}

/// Common "exact / round-up" tender shortcuts.
class _QuickTenderRow extends StatelessWidget {
  const _QuickTenderRow({required this.totalCents, required this.onSelected});

  final int totalCents;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final presets = _buildPresets(totalCents);
    return Wrap(
      spacing: Sizes.sm,
      runSpacing: Sizes.sm,
      children: [
        for (final preset in presets)
          ActionChip(
            label: Text(preset.label),
            onPressed: () => onSelected(preset.cents),
          ),
      ],
    );
  }

  /// Builds tender shortcuts: the exact amount, then the next sensible round
  /// banknotes above the total (€5/€10/€20/€50 steps).
  List<({String label, int cents})> _buildPresets(int totalCents) {
    final result = <({String label, int cents})>[
      (label: 'Exact', cents: totalCents),
    ];

    const banknotes = [500, 1000, 2000, 5000, 10000]; // €5..€100 in cents
    for (final note in banknotes) {
      // Round the total up to the next multiple of this banknote.
      final rounded = ((totalCents + note - 1) ~/ note) * note;
      if (rounded > totalCents && !result.any((p) => p.cents == rounded)) {
        result.add((label: formatCents(rounded), cents: rounded));
      }
      if (result.length >= 4) break;
    }

    return result;
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
        color: AppColors.error500.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Sizes.sm),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error500, size: 20),
          const SizedBox(width: Sizes.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.error500),
            ),
          ),
        ],
      ),
    );
  }
}
