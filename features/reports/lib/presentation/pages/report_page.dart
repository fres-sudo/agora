import 'package:bloc_exports/bloc_exports.dart';
import 'package:order_management/models/order.dart';
import 'package:order_management/models/order_type.dart';
import 'package:feature_reports/domain/models/report_data.dart';
import 'package:feature_reports/domain/models/report_period.dart';
import 'package:feature_reports/presentation/blocs/reports/reports_cubit.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:i18n/i18n.dart';
import 'package:feature_reports/presentation/widgets/end_of_day_summary.dart';
import 'package:feature_reports/presentation/widgets/summary_card.dart';
import 'package:feature_reports/presentation/widgets/sales_overview_chart.dart';
import 'package:feature_reports/presentation/widgets/status_donut_chart.dart';
import 'package:feature_reports/presentation/widgets/top_products_list.dart';
import 'package:utils/utils.dart';

@RoutePage()
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  // Breakpoints for responsive layout
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: const AppShellMenuButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ReportsState state) {
    if (state.isLoading && !state.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isFailure && !state.hasData) {
      return _buildError(context);
    }

    final data = state.data;

    return RefreshIndicator(
      onRefresh: () => context.reportsCubit.load(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isMobile = width < _mobileBreakpoint;
          final isTabletPortrait =
              width >= _mobileBreakpoint && width < _tabletBreakpoint;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isMobile ? Sizes.md : Sizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReportHeader(context, state, isMobile),
                const SizedBox(height: Sizes.lg),
                _buildSummaryCards(context, width, data.summary),
                const SizedBox(height: Sizes.xl),
                EndOfDaySummary(summary: data.summary),
                const SizedBox(height: Sizes.xl),
                _buildSalesAndProductsSection(
                  context,
                  isMobile,
                  isTabletPortrait,
                  data,
                ),
                const SizedBox(height: Sizes.xl),
                _buildStatusChartsSection(context, isMobile, data),
                const SizedBox(height: Sizes.xl),
                _buildRecentOrdersTable(context, data.recentOrders),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            AgoraIcons.alert_triangle,
            color: AppPalette.error500,
            size: 48,
          ),
          const SizedBox(height: Sizes.md),
          const AppText.body('Could not load the report.'),
          const SizedBox(height: Sizes.md),
          AppButton.outline(
            onPressed: () => context.reportsCubit.load(),
            label: 'Retry',
          ),
        ],
      ),
    );
  }

  /// In-page header replacing the former app bar: page title plus the period
  /// selector and export button. Stacks vertically on mobile so the controls
  /// stay reachable, sits inline on wider screens.
  Widget _buildReportHeader(
    BuildContext context,
    ReportsState state,
    bool isMobile,
  ) {
    final title = AppText.titleLg(t.report.title);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clear the floating menu button overlaid at the top-left.
          const SizedBox(height: Sizes.xxl),
          title,
          const SizedBox(height: Sizes.md),
          Row(
            children: [
              Expanded(child: _buildPeriodDropdown(context, state)),
              const SizedBox(width: Sizes.md),
              _buildDownloadButton(context),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        title,
        const Spacer(),
        _buildPeriodDropdown(context, state),
        const SizedBox(width: Sizes.md),
        _buildDownloadButton(context),
      ],
    );
  }

  Widget _buildPeriodDropdown(BuildContext context, ReportsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        border: Border.all(color: context.colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportPeriod>(
          value: state.period,
          icon: const Icon(AgoraIcons.chevron_down),
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: (period) {
            if (period != null) context.reportsCubit.selectPeriod(period);
          },
          items: [
            for (final period in ReportPeriod.values)
              DropdownMenuItem(
                value: period,
                child: AppText.body(period.label),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return AppButton.outline(
      onPressed: () {
        // Export (CSV/PDF) is tracked separately as P5-4 and needs a
        // file/share dependency; surface intent rather than silently no-op.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: AppText.body('Export is coming soon')),
        );
      },
      label: t.report.download,
      leadingIcon: const Icon(AgoraIcons.download, size: 20),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppPalette.neutral700,
        side: const BorderSide(color: AppPalette.neutral200),
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.lg,
          vertical: Sizes.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadius),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    double availableWidth,
    ReportSummary summary,
  ) {
    final cards = [
      SummaryCard(
        title: t.report.total_order,
        value: summary.totalOrders.toString(),
        trend: '',
        isPositive: true,
        icon: const Icon(
          AgoraIcons.cart,
          color: AppPalette.primary500,
          size: 20,
        ),
      ),
      SummaryCard(
        title: t.report.total_revenue,
        value: formatCents(summary.totalRevenueCents),
        trend: '',
        isPositive: true,
        icon: const Icon(
          AgoraIcons.coin_alt,
          color: AppPalette.primary500,
          size: 20,
        ),
      ),
      SummaryCard(
        title: 'Avg Ticket',
        value: formatCents(summary.averageTicketCents),
        trend: '',
        isPositive: true,
        icon: const Icon(
          AgoraIcons.receipt,
          color: AppPalette.primary500,
          size: 20,
        ),
      ),
      SummaryCard(
        title: 'Items Sold',
        value: summary.itemsSold.toString(),
        trend: '',
        isPositive: true,
        icon: const Icon(
          AgoraIcons.package,
          color: AppPalette.primary500,
          size: 20,
        ),
      ),
    ];

    int crossAxisCount;
    double childAspectRatio;

    if (availableWidth < _mobileBreakpoint) {
      crossAxisCount = 1;
      childAspectRatio = 3.0;
    } else if (availableWidth < _tabletBreakpoint) {
      crossAxisCount = 2;
      childAspectRatio = 2.2;
    } else {
      crossAxisCount = 4;
      childAspectRatio = 1.6;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Sizes.md,
        mainAxisSpacing: Sizes.md,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => cards[index],
    );
  }

  Widget _buildSalesAndProductsSection(
    BuildContext context,
    bool isMobile,
    bool isTabletPortrait,
    ReportData data,
  ) {
    final salesChart = SizedBox(
      height: isMobile ? 300 : 400,
      child: SalesOverviewChart(points: data.salesTrend),
    );

    final productsList = SizedBox(
      height: isMobile ? 350 : 400,
      child: TopProductsList(
        products: [
          for (final p in data.topProducts)
            TopProductData(name: p.name, sales: p.quantitySold),
        ],
      ),
    );

    if (isMobile || isTabletPortrait) {
      return Column(
        children: [
          salesChart,
          const SizedBox(height: Sizes.xl),
          productsList,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: salesChart),
        const SizedBox(width: Sizes.xl),
        Expanded(child: productsList),
      ],
    );
  }

  Widget _buildStatusChartsSection(
    BuildContext context,
    bool isMobile,
    ReportData data,
  ) {
    final status = data.statusBreakdown;
    final stock = data.stockBreakdown;

    final orderStatusChart = SizedBox(
      height: isMobile ? 320 : 350,
      child: StatusDonutChart(
        title: 'Order Status',
        totalLabel: 'Total Orders',
        totalValue: status.total,
        data: [
          DonutData(
            label: 'Completed',
            value: status.completed,
            color: AppPalette.primary500,
          ),
          DonutData(
            label: 'Pending',
            value: status.pending,
            color: AppPalette.warning500,
          ),
          DonutData(
            label: 'Voided',
            value: status.voided,
            color: AppPalette.error500,
          ),
        ],
      ),
    );

    final stockStatusChart = SizedBox(
      height: isMobile ? 320 : 350,
      child: StatusDonutChart(
        title: t.report.stock_status.title,
        totalLabel: t.report.stock_status.total,
        totalValue: stock.total,
        data: [
          DonutData(
            label: t.report.stock_status.in_stock,
            value: stock.inStock,
            color: AppPalette.primary500,
          ),
          DonutData(
            label: t.report.stock_status.low_stock,
            value: stock.lowStock,
            color: AppPalette.warning500,
          ),
          DonutData(
            label: t.report.stock_status.out_of_stock,
            value: stock.outOfStock,
            color: AppPalette.error500,
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          orderStatusChart,
          const SizedBox(height: Sizes.xl),
          stockStatusChart,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: orderStatusChart),
        const SizedBox(width: Sizes.xl),
        Expanded(child: stockStatusChart),
      ],
    );
  }

  Widget _buildRecentOrdersTable(BuildContext context, List<Order> orders) {
    if (orders.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Sizes.md),
          border: Border.all(color: context.colors.border),
        ),
        child: AppText.body(
          'No orders in this period',
          color: context.colors.mutedForeground,
        ),
      );
    }

    return SizedBox(
      height: 500,
      child: DataTableView<Order>(
        items: orders,
        columns: [
          DataTableColumn(
            id: 'id',
            label: t.report.recent_order.id,
            cellBuilder: (item) => AppText.titleMd('#${item.id ?? '-'}'),
          ),
          DataTableColumn(
            id: 'status',
            label: t.report.recent_order.status,
            cellBuilder: (item) => _buildStatusBadge(item.status),
          ),
          DataTableColumn(
            id: 'orderDate',
            label: t.report.recent_order.order_date,
            cellBuilder: (item) => AppText.bodySm(
              _formatDateTime(item.createdAt),
              color: context.colors.mutedForeground,
            ),
          ),
          DataTableColumn(
            id: 'orderType',
            label: t.report.recent_order.order_type,
            cellBuilder: (item) =>
                AppText.body(_orderTypeLabel(item.orderType)),
          ),
          DataTableColumn(
            id: 'payment',
            label: t.report.recent_order.customer,
            cellBuilder: (item) => AppText.body(item.paymentMethod ?? '—'),
          ),
          DataTableColumn(
            id: 'qty',
            label: t.report.recent_order.qty,
            cellBuilder: (item) => AppText.body(
              item.items.fold<int>(0, (sum, i) => sum + i.quantity).toString(),
            ),
          ),
          DataTableColumn(
            id: 'total',
            label: t.report.recent_order.total,
            cellBuilder: (item) =>
                AppText.titleMd(formatCents(item.grandTotalCents)),
          ),
        ],
        config: DataTableConfig(title: t.report.recent_order.title),
      ),
    );
  }

  String _orderTypeLabel(OrderType type) => switch (type) {
    OrderType.dineIn => 'Dine In',
    OrderType.takeAway => 'Take Away',
  };

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final period = dt.hour < 12 ? 'AM' : 'PM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}\n'
        '$hour12:$minute $period';
  }

  Widget _buildStatusBadge(OrderStatus status) {
    final (color, label) = switch (status) {
      OrderStatus.pending => (AppPalette.warning500, 'Pending'),
      OrderStatus.completed => (AppPalette.primary500, 'Completed'),
      OrderStatus.voided => (AppPalette.error500, 'Voided'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.sm,
        vertical: Sizes.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: AppText.label(label, color: color),
    );
  }
}
