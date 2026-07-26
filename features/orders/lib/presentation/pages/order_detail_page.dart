import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:inventory_contracts/repositories/inventory_repository.dart';
import 'package:order_management/mappers/order_receipt_mapper.dart';
import 'package:order_management/models/order.dart';
import 'package:order_management/models/order_line_item.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:feature_orders/presentation/blocs/order_detail/order_detail_cubit.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';
import 'package:ui_kit/ui_kit.dart';

/// Order detail page (P7-2).
///
/// Drills into a single order: line items + modifiers, financial breakdown,
/// payment method and status. Supports **void** (restores stock for completed
/// orders) and **reprint**.
@RoutePage()
class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({required this.orderId, super.key});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailCubit>(
      create: (ctx) => OrderDetailCubit(
        ordersRepository: ctx.read<OrdersRepository>(),
        inventoryRepository: ctx.read<InventoryRepository>(),
      )..load(orderId),
      child: const _OrderDetailView(),
    );
  }
}

class _OrderDetailView extends StatelessWidget {
  const _OrderDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailCubit, OrderDetailState>(
      listenWhen: (previous, current) =>
          current.maybeMap(error: (_) => true, orElse: () => false),
      listener: (context, state) {
        state.maybeMap(
          error: (s) => AppToast.error(context, message: s.message),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final order = state.maybeMap(
          loaded: (s) => s.order,
          completing: (s) => s.order,
          voiding: (s) => s.order,
          error: (s) => s.order,
          orElse: () => null,
        );

        return Scaffold(
          appBar: AppBar(
            title: AppText.titleLg(
              order != null ? 'Order #${order.id ?? '-'}' : 'Order details',
            ),
            actions: [
              if (order != null && order.status != OrderStatus.voided)
                AppIconButton.ghost(
                  onPressed: () => _reprint(context, order),
                  icon: const Icon(AgoraIcons.printer),
                ),
              const SizedBox(width: Sizes.sm),
            ],
          ),
          body: state.maybeMap(
            loading: (_) => const Center(child: CircularProgressIndicator()),
            initial: (_) => const Center(child: CircularProgressIndicator()),
            orElse: () => order == null
                ? const Center(child: AppText.body('Order not found'))
                : _OrderBody(order: order),
          ),
          bottomNavigationBar:
              order == null || order.status == OrderStatus.voided
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.lg),
                    child: AppButton.outline(
                      onPressed: () => _confirmVoid(context, order),
                      label: 'Void order',
                      leadingIcon: const Icon(AgoraIcons.x_mark),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> _confirmVoid(BuildContext context, Order order) async {
    final cubit = context.read<OrderDetailCubit>();
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Void order?',
      message:
          'Voiding order #${order.id ?? '-'} will restore any stock it consumed. This cannot be undone.',
      confirmButtonLabel: 'Void',
      isDestructive: true,
    );
    if (confirmed) {
      await cubit.voidOrder();
    }
  }

  Future<void> _reprint(BuildContext context, Order order) async {
    final printer = context.read<PrinterService>();
    final config = buildReceiptConfig(context.read<SettingsCubit>());
    final receipt = order.toReceipt(config);

    try {
      final bytes = await const ReceiptRenderer().toEscPos(receipt);
      final result = await printer.printBytes(bytes);
      if (!context.mounted) return;
      result.when(
        success: (_) => AppToast.success(
          context,
          message: 'Receipt #${order.id ?? '-'} sent to printer',
        ),
        error: (_) => AppToast.error(
          context,
          message: 'Reprint failed — check the printer connection',
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      AppToast.error(
        context,
        message: 'Reprint failed — check the printer connection',
      );
    }
  }
}

class _OrderBody extends StatelessWidget {
  const _OrderBody({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Sizes.lg),
      children: [
        Row(
          children: [
            _StatusBadge(status: order.status),
            const Spacer(),
            AppText.bodySm(
              _formatDateTime(context, order.createdAt),
              color: context.colors.mutedForeground,
              textAlign: TextAlign.right,
            ),
          ],
        ),
        const SizedBox(height: Sizes.lg),
        const AppText.titleMd('Items'),
        const SizedBox(height: Sizes.sm),
        ...order.items.map((item) => _LineItemTile(item: item)),
        const Divider(height: Sizes.xl),
        _TotalRow(label: 'Subtotal', cents: order.subtotalCents),
        if (order.discountCents > 0)
          _TotalRow(label: 'Discount', cents: -order.discountCents),
        _TotalRow(label: 'Tax', cents: order.taxCents),
        _TotalRow(
          label: 'Total',
          cents: order.grandTotalCents,
          emphasized: true,
        ),
        const SizedBox(height: Sizes.lg),
        _InfoRow(label: 'Payment', value: order.paymentMethod ?? '—'),
        if (order.note?.isNotEmpty == true)
          _InfoRow(label: 'Note', value: order.note!),
      ],
    );
  }

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final localizations = MaterialLocalizations.of(context);
    return '${localizations.formatMediumDate(dateTime)} '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(dateTime))}';
  }
}

class _LineItemTile extends StatelessWidget {
  const _LineItemTile({required this.item});

  final OrderLineItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final lineTotal =
        (item.unitPriceCents +
            item.selectedModifiers.fold<int>(
              0,
              (sum, m) => sum + m.priceChangeCents,
            )) *
        item.quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.tokens.spaceXl,
            child: AppText.titleMd('${item.quantity}×'),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleMd(item.productName),
                for (final modifier in item.selectedModifiers)
                  AppText.bodySm(
                    '${modifier.groupName}: ${modifier.optionName}'
                    '${modifier.priceChangeCents != 0 ? ' (${context.formatCurrency(modifier.priceChangeCents)})' : ''}',
                    color: colors.mutedForeground,
                  ),
              ],
            ),
          ),
          AppText.titleMd(context.formatCurrency(lineTotal)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.cents,
    this.emphasized = false,
  });

  final String label;
  final int cents;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget cell(String text) => emphasized
        ? AppText.titleMd(text)
        : AppText.body(text, color: colors.mutedForeground);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.tokens.spaceXxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [cell(label), cell(context.formatCurrency(cents))],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.tokens.spaceXxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.body(label, color: context.colors.mutedForeground),
          AppText.titleMd(value),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      OrderStatus.pending => (context.colors.warning, 'Pending'),
      OrderStatus.completed => (context.colors.success, 'Completed'),
      OrderStatus.voided => (context.colors.destructive, 'Voided'),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.md,
        vertical: context.tokens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: AppText.label(label, color: color),
    );
  }
}
