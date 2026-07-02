import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_inventory/domain/repositories/inventory_repository.dart';
import 'package:feature_orders/domain/mappers/order_receipt_mapper.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/models/order_line_item.dart';
import 'package:feature_orders/domain/repositories/orders_repository.dart';
import 'package:feature_orders/presentation/blocs/order_detail/order_detail_cubit.dart';
import 'package:feature_orders/presentation/utils/receipt_config_builder.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';
import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

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
          error: (s) => showAppSnackBar(context, s.message, isError: true),
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
            title: Text(order != null ? 'Order #${order.id ?? '-'}' : 'Order details'),
            actions: [
              if (order != null && order.status != OrderStatus.voided)
                AppIconButton.ghost(
                  onPressed: () => _reprint(context, order),
                  icon: const Icon(Icons.print_outlined),
                ),
              const SizedBox(width: Sizes.sm),
            ],
          ),
          body: state.maybeMap(
            loading: (_) => const Center(child: CircularProgressIndicator()),
            initial: (_) => const Center(child: CircularProgressIndicator()),
            orElse: () => order == null
                ? const Center(child: Text('Order not found'))
                : _OrderBody(order: order),
          ),
          bottomNavigationBar: order == null ||
                  order.status == OrderStatus.voided
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.lg),
                    child: AppButton.outline(
                      onPressed: () => _confirmVoid(context, order),
                      label: 'Void order',
                      leadingIcon: const Icon(Icons.block_outlined),
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
        success: (_) =>
            showAppSnackBar(context, 'Receipt #${order.id ?? '-'} sent to printer'),
        error: (_) => showAppSnackBar(
          context,
          'Reprint failed — check the printer connection',
          isError: true,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      showAppSnackBar(
        context,
        'Reprint failed — check the printer connection',
        isError: true,
      );
    }
  }
}

class _OrderBody extends StatelessWidget {
  const _OrderBody({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(Sizes.lg),
      children: [
        Row(
          children: [
            _StatusBadge(status: order.status),
            const Spacer(),
            Text(
              _formatDateTime(context, order.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.neutral500,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        const SizedBox(height: Sizes.lg),
        Text('Items', style: theme.textTheme.titleSmall),
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
    final theme = Theme.of(context);
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
            width: 32,
            child: Text(
              '${item.quantity}×',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                for (final modifier in item.selectedModifiers)
                  Text(
                    '${modifier.groupName}: ${modifier.optionName}'
                    '${modifier.priceChangeCents != 0 ? ' (${formatCents(modifier.priceChangeCents)})' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            formatCents(lineTotal),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
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
    final theme = Theme.of(context);
    final style = emphasized
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyMedium?.copyWith(color: AppColors.neutral600);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(formatCents(cents), style: style),
        ],
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
              fontWeight: FontWeight.w600,
            ),
          ),
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
      OrderStatus.pending => (AppColors.warning500, 'Pending'),
      OrderStatus.completed => (AppColors.primary500, 'Completed'),
      OrderStatus.voided => (AppColors.error500, 'Voided'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.md, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
