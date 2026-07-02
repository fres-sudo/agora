import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_orders/presentation/blocs/orders/orders_bloc.dart';
import 'package:feature_orders/domain/models/order.dart';
import 'package:feature_orders/domain/mappers/order_receipt_mapper.dart';
import 'package:feature_orders/presentation/routes/orders_router.dart';
import 'package:feature_orders/presentation/utils/receipt_config_builder.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';

@RoutePage()
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final DataTableController<Order> _tableController;

  @override
  void initState() {
    super.initState();
    _tableController = DataTableController<Order>(rowsPerPage: 10);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OrdersBloc>().add(const OrdersEvent.started());
      }
    });
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  void _openDetail(BuildContext context, Order order) {
    final id = order.id;
    if (id == null) return;
    context.router.push(OrderDetailRoute(orderId: id));
  }

  /// Re-renders [order] and sends it to the configured printer (P2-3).
  Future<void> _reprint(Order order) async {
    final messenger = ScaffoldMessenger.of(context);
    final printer = context.read<PrinterService>();
    final config = buildReceiptConfig(context.read<SettingsCubit>());
    final receipt = order.toReceipt(config);

    void toast(String message) {
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );
    }

    try {
      final bytes = await const ReceiptRenderer().toEscPos(receipt);
      final result = await printer.printBytes(bytes);
      result.when(
        success: (_) => toast('Receipt #${order.id ?? '-'} sent to printer'),
        error: (_) => toast('Reprint failed — check the printer connection'),
      );
    } catch (_) {
      toast('Reprint failed — check the printer connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<OrdersBloc, OrdersState>(
      listenWhen: (previous, current) =>
          current.maybeMap(error: (_) => true, orElse: () => false),
      listener: (context, state) {
        state.maybeMap(
          error: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message),
                backgroundColor: AppColors.error500,
              ),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Orders'),
            leading: context.isTabletOrLarger
                ? null
                : AppIconButton.ghost(
                    onPressed: AppShellScope.maybeOf(context)?.openSidebar,
                    icon: const Icon(Icons.menu_rounded),
                  ),
            actions: context.isTabletOrLarger
                ? const [
                    AppShellOperatorChip(),
                    SizedBox(width: 8),
                    AppShellUserMenu(),
                    SizedBox(width: 12),
                  ]
                : null,
          ),
          body: AnimatedBuilder(
            animation: _tableController,
            builder: (context, _) {
              final filteredOrders = _applySearchAndSort(state.orders);

              return DataTableView<Order>(
                controller: _tableController,
                items: filteredOrders,
                config: const DataTableConfig(
                  title: 'Orders',
                  searchHint: 'Search orders...',
                  addButtonLabel: 'Refresh',
                  emptyStateTitle: 'No orders found',
                  emptyStateSubtitle: 'Try changing your search or filters',
                  emptyStateIcon: Icons.receipt_long_outlined,
                ),
                showAddButton: false,
                showEditAction: false,
                showReprintAction: true,
                showDeleteAction: true,
                columns: [
                  DataTableColumn(
                    id: 'id',
                    label: 'Order #',
                    width: 110,
                    cellBuilder: (order) => Text(
                      '#${order.id ?? '-'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral700,
                      ),
                    ),
                  ),
                  DataTableColumn(
                    id: 'createdAt',
                    label: 'Date',
                    width: 160,
                    cellBuilder: (order) => Text(
                      _formatDateTime(context, order.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                  DataTableColumn(
                    id: 'status',
                    label: 'Status',
                    width: 120,
                    cellBuilder: (order) => _StatusBadge(status: order.status),
                  ),
                  DataTableColumn(
                    id: 'items',
                    label: 'Items',
                    width: 90,
                    alignment: Alignment.centerRight,
                    cellBuilder: (order) => Text(
                      order.items.length.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataTableColumn(
                    id: 'total',
                    label: 'Total',
                    width: 120,
                    alignment: Alignment.centerRight,
                    cellBuilder: (order) => Text(
                      _formatCurrency(order.grandTotalCents),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataTableColumn(
                    id: 'note',
                    label: 'Note',
                    flex: 3,
                    cellBuilder: (order) => Text(
                      order.note?.isNotEmpty == true ? order.note! : '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutral700,
                      ),
                    ),
                  ),
                ],
                onSearch: (query) => _tableController.searchQuery = query,
                onFilter: () => _showFilterDialog(context, state),
                onAdd: () =>
                    context.read<OrdersBloc>().add(const OrdersEvent.refresh()),
                onRowTap: (order) => _openDetail(context, order),
                onRowAction: (order, action) async {
                  switch (action) {
                    case DataTableRowAction.edit:
                      _openDetail(context, order);
                      break;
                    case DataTableRowAction.reprint:
                      await _reprint(order);
                      break;
                    case DataTableRowAction.delete:
                      final confirmed = await DataTableDeleteDialog.show(
                        context: context,
                        title: 'Delete order?',
                        message:
                            'This will remove order #${order.id ?? '-'} from the list. Completed orders will restore inventory.',
                        deleteButtonLabel: 'Delete',
                      );

                      if (confirmed && context.mounted) {
                        context.read<OrdersBloc>().add(
                          OrdersEvent.deleted(order.id ?? 0),
                        );
                      }
                      break;
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  List<Order> _applySearchAndSort(List<Order> orders) {
    final query = _tableController.searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return orders;
    }

    return orders.where((order) {
      final searchable = <String>[
        if (order.id != null) order.id.toString(),
        order.status.name,
        order.note ?? '',
        order.items.map((item) => item.productName).join(' '),
      ].join(' ').toLowerCase();

      return searchable.contains(query);
    }).toList();
  }

  Future<void> _showFilterDialog(
    BuildContext context,
    OrdersState state,
  ) async {
    OrderStatus? selectedStatus = state.maybeMap(
      loaded: (loaded) => loaded.statusFilter,
      orElse: () => null,
    );
    DateTimeRange? selectedRange;

    final startDate = state.maybeMap(
      loaded: (loaded) => loaded.startDate,
      orElse: () => null,
    );
    final endDate = state.maybeMap(
      loaded: (loaded) => loaded.endDate,
      orElse: () => null,
    );

    if (startDate != null || endDate != null) {
      selectedRange = DateTimeRange(
        start: startDate ?? DateTime.now().subtract(const Duration(days: 7)),
        end: endDate ?? DateTime.now(),
      );
    }

    await DataTableFilterDialog.show(
      context: context,
      title: 'Order filters',
      onApply: () {
        _tableController.applyFilters({
          if (selectedStatus != null) 'status': selectedStatus,
          if (selectedRange != null) 'startDate': selectedRange!.start,
          if (selectedRange != null) 'endDate': selectedRange!.end,
        });
        context.read<OrdersBloc>().add(
          OrdersEvent.filterChanged(
            status: selectedStatus,
            startDate: selectedRange?.start,
            endDate: selectedRange?.end,
          ),
        );
      },
      child: _OrderFilterDialogContent(
        initialStatus: selectedStatus,
        initialRange: selectedRange,
        onStatusChanged: (value) => selectedStatus = value,
        onRangeChanged: (value) => selectedRange = value,
      ),
    );
  }

  String _formatCurrency(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final localizations = MaterialLocalizations.of(context);
    final date = localizations.formatMediumDate(dateTime);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(dateTime),
    );
    return '$date\n$time';
  }
}

class _OrderFilterDialogContent extends StatefulWidget {
  const _OrderFilterDialogContent({
    required this.initialStatus,
    required this.initialRange,
    required this.onStatusChanged,
    required this.onRangeChanged,
  });

  final OrderStatus? initialStatus;
  final DateTimeRange? initialRange;
  final ValueChanged<OrderStatus?> onStatusChanged;
  final ValueChanged<DateTimeRange?> onRangeChanged;

  @override
  State<_OrderFilterDialogContent> createState() =>
      _OrderFilterDialogContentState();
}

class _OrderFilterDialogContentState extends State<_OrderFilterDialogContent> {
  late OrderStatus? _status;
  late DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _range = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<OrderStatus?>(
          initialValue: _status,
          decoration: const InputDecoration(
            labelText: 'Order status',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem<OrderStatus?>(
              value: null,
              child: Text('Any status'),
            ),
            DropdownMenuItem<OrderStatus?>(
              value: OrderStatus.pending,
              child: Text('Pending'),
            ),
            DropdownMenuItem<OrderStatus?>(
              value: OrderStatus.completed,
              child: Text('Completed'),
            ),
            DropdownMenuItem<OrderStatus?>(
              value: OrderStatus.voided,
              child: Text('Voided'),
            ),
          ],
          onChanged: (value) {
            setState(() => _status = value);
            widget.onStatusChanged(value);
          },
        ),
        const SizedBox(height: Sizes.lg),
        AppButton.outline(
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDateRange: _range,
            );
            if (picked != null && mounted) {
              setState(() => _range = picked);
              widget.onRangeChanged(picked);
            }
          },
          label: _range == null
              ? 'Pick date range'
              : 'From ${MaterialLocalizations.of(context).formatShortDate(_range!.start)} to ${MaterialLocalizations.of(context).formatShortDate(_range!.end)}',
          leadingIcon: const Icon(Icons.date_range_outlined),
        ),
        if (_range != null) ...[
          const SizedBox(height: Sizes.sm),
          AppButton.ghost(
            onPressed: () {
              setState(() => _range = null);
              widget.onRangeChanged(null);
            },
            label: 'Clear date range',
          ),
        ],
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: Sizes.sm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
