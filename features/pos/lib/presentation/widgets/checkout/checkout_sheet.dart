import 'package:bloc_exports/bloc_exports.dart';
import 'package:discounts/models/discount.dart';
import 'package:order_management/order_management.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

import 'package:feature_pos/presentation/widgets/checkout/change_due_display.dart';
import 'package:feature_pos/presentation/widgets/checkout/payment_method_selector.dart';

/// The checkout / payment sheet (P1-5, P2-3).
///
/// Presents an order summary, a payment-method selector and — for cash — a
/// money keypad with live change calculation. On confirmation it drives the
/// [CheckoutCubit] to persist the completed order and decrement stock, then
/// shows a receipt preview (Print / Done) before popping and returning the
/// finished [Order] so the caller can clear the cart.
class CheckoutSheet extends StatelessWidget {
  const CheckoutSheet({super.key, this.scrollController});

  final ScrollController? scrollController;

  /// Opens the checkout sheet for [order]. Resolves with the completed [Order]
  /// when the sale succeeds, or `null` if the operator dismissed it.
  ///
  /// [receiptConfig] (store/receipt settings) drives the receipt preview/print.
  static Future<Order?> show(
    BuildContext context,
    Order order, {
    ReceiptConfig receiptConfig = const ReceiptConfig(),
    Discount? appliedDiscount,
  }) {
    final cubit = context.read<CheckoutCubit>()
      ..start(
        order,
        receiptConfig: receiptConfig,
        appliedDiscount: appliedDiscount,
      );

    return AdaptiveModal.show<Order>(
      context: context,
      style: AdaptiveModalStyle.sideSheet,
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
    return BlocBuilder<CheckoutCubit, CheckoutState>(
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
                child: state is CheckoutSuccess
                    ? _ReceiptStage(state: state)
                    : _CheckoutBody(state: state),
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
              color: context.colors.border,
              borderRadius: context.tokens.borderRadiusFull,
            ),
          ),
        ),
        const AppText.headingSm('Checkout'),
        const SizedBox(height: Sizes.md),

        // Total to pay.
        _TotalRow(totalCents: state.totalCents),
        const SizedBox(height: Sizes.lg),

        // Payment method.
        const AppText.titleMd('Payment Method'),
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

/// Post-payment stage: receipt preview with Print / Done actions (P2-3).
class _ReceiptStage extends StatelessWidget {
  const _ReceiptStage({required this.state});

  final CheckoutSuccess state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();
    final receipt = state.receipt;
    final printing = state.printStatus == PrintStatus.printing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: Sizes.md),
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: context.tokens.borderRadiusFull,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AgoraIcons.check, color: context.colors.success),
            const SizedBox(width: Sizes.sm),
            const AppText.headingSm('Payment complete'),
          ],
        ),
        const SizedBox(height: Sizes.lg),

        // Receipt preview.
        if (receipt != null)
          Center(child: ReceiptPreview(receipt: receipt, width: 300)),
        const SizedBox(height: Sizes.lg),

        if (state.printStatus == PrintStatus.printed)
          _PrintStatusBanner(
            icon: AgoraIcons.check,
            color: context.colors.success,
            message: 'Receipt printed',
          ),
        if (state.printStatus == PrintStatus.failed)
          _PrintStatusBanner(
            icon: AgoraIcons.alert_triangle,
            color: context.colors.destructive,
            message: 'Print failed — the sale is still recorded',
          ),
        if (state.printStatus != PrintStatus.idle)
          const SizedBox(height: Sizes.sm),

        // Print / reprint.
        AppButton.primary(
          label: state.printStatus == PrintStatus.printed
              ? 'Print Again'
              : 'Print Receipt',
          fullWidth: true,
          isLoading: printing,
          leadingIcon: const Icon(AgoraIcons.printer, size: 20),
          onPressed: printing ? null : cubit.printReceipt,
        ),
        const SizedBox(height: Sizes.sm),
        AppButton.outline(
          label: 'Done',
          fullWidth: true,
          onPressed: printing
              ? null
              : () => Navigator.of(context).pop(state.order),
        ),
      ],
    );
  }
}

class _PrintStatusBanner extends StatelessWidget {
  const _PrintStatusBanner({
    required this.icon,
    required this.color,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Sizes.sm),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: Sizes.sm),
          Expanded(child: AppText.body(message, color: color)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.totalCents});

  final int totalCents;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(Sizes.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppText.titleMd('Total'),
          AppText.headingSm(formatCents(totalCents), color: colors.primary),
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
            const AppText.titleMd('Amount Tendered'),
            AppText.headingSm(formatCents(tendered)),
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
            label: AppText.body(preset.label),
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
        color: context.colors.destructive.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Sizes.sm),
      ),
      child: Row(
        children: [
          Icon(
            AgoraIcons.alert_triangle,
            color: context.colors.destructive,
            size: 20,
          ),
          const SizedBox(width: Sizes.sm),
          Expanded(
            child: AppText.body(message, color: context.colors.destructive),
          ),
        ],
      ),
    );
  }
}
