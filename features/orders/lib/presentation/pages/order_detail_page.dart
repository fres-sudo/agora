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
              if (order != null &&
                  order.status != OrderStatus.voided &&
                  order.status != OrderStatus.paymentPending)
                AppIconButton.ghost(
                  onPressed: () => _reprint(context, order),
                  icon: const Icon(AgoraIcons.printer),
                ),
              SizedBox(width: context.tokens.spacing.xs),
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
              order == null ||
                  order.status == OrderStatus.voided ||
                  order.status == OrderStatus.paymentPending
              ? null
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(context.tokens.spacing.md),
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
      padding: EdgeInsets.all(context.tokens.spacing.md),
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
        SizedBox(height: context.tokens.spacing.md),
        const AppText.titleMd('Items'),
        SizedBox(height: context.tokens.spacing.xs),
        ...order.items.map((item) => _LineItemTile(item: item)),
        Divider(height: context.tokens.spacing.lg),
        _TotalRow(label: 'Subtotal', cents: order.subtotalCents),
        if (order.discountCents > 0)
          _TotalRow(label: 'Discount', cents: -order.discountCents),
        _TotalRow(label: 'Tax', cents: order.taxCents),
        _TotalRow(
          label: 'Total',
          cents: order.grandTotalCents,
          emphasized: true,
        ),
        SizedBox(height: context.tokens.spacing.md),
        _InfoRow(label: 'Payment', value: order.paymentMethod ?? '—'),
        if (order.paymentProvider != null)
          _InfoRow(label: 'Provider', value: order.paymentProvider!),
        if (order.paymentStatus != null)
          _InfoRow(label: 'Payment status', value: order.paymentStatus!.name),
        if (order.paymentAttemptId != null)
          _InfoRow(label: 'Attempt ID', value: order.paymentAttemptId!),
        if (order.paymentTransactionCode != null)
          _InfoRow(
            label: 'Transaction code',
            value: order.paymentTransactionCode!,
          ),
        if (order.paymentError != null)
          _InfoRow(label: 'Payment detail', value: order.paymentError!),
        if (order.status == OrderStatus.paymentPending)
          Padding(
            padding: EdgeInsets.only(top: context.tokens.spacing.sm),
            child: AppText.bodySm(
              'Do not charge this order again. Check the SumUp transaction '
              'history with the attempt ID before resolving it.',
              color: context.colors.destructive,
            ),
          ),
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
      padding: EdgeInsets.symmetric(vertical: context.tokens.spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.tokens.spacing.xl,
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
      padding: EdgeInsets.symmetric(vertical: context.tokens.spacing.xxs),
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
      padding: EdgeInsets.symmetric(vertical: context.tokens.spacing.xxs),
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
      OrderStatus.paymentPending => (
        context.colors.destructive,
        'Payment review',
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spacing.sm,
        vertical: context.tokens.spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.tokens.radius.xs),
      ),
      child: AppText.label(label, color: color),
    );
  }
}
