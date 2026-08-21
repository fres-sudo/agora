import 'package:bloc_exports/bloc_exports.dart';
import 'package:order_management/models/order.dart';
import 'package:order_management/models/order_type.dart';
import 'package:feature_reports/domain/models/report_data.dart';
import 'package:app_settings/app_settings.dart';
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
          appBar: AdaptiveAppBar.of(context, title: 'Reports'),
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
            padding: EdgeInsets.all(
              isMobile ? context.tokens.spacing.sm : context.tokens.spacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReportHeader(context, state, isMobile),
                SizedBox(height: context.tokens.spacing.md),
                _buildSummaryCards(context, width, data.summary),
                SizedBox(height: context.tokens.spacing.lg),
                EndOfDaySummary(summary: data.summary),
                SizedBox(height: context.tokens.spacing.lg),
                _buildSalesAndProductsSection(
                  context,
                  isMobile,
                  isTabletPortrait,
                  data,
                ),
                SizedBox(height: context.tokens.spacing.lg),
                _buildStatusChartsSection(context, isMobile, data),
                SizedBox(height: context.tokens.spacing.lg),
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
          Icon(
            AgoraIcons.alert_triangle,
            color: context.colors.destructive,
            size: 48,
          ),
          SizedBox(height: context.tokens.spacing.sm),
          const AppText.body('Could not load the report.'),
          SizedBox(height: context.tokens.spacing.sm),
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
          SizedBox(height: context.tokens.spacing.xl),
          title,
          SizedBox(height: context.tokens.spacing.sm),
          Row(
            children: [
              Expanded(child: _buildPeriodDropdown(context, state)),
              SizedBox(width: context.tokens.spacing.sm),
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
        SizedBox(width: context.tokens.spacing.sm),
        _buildDownloadButton(context),
      ],
    );
  }

  Widget _buildPeriodDropdown(BuildContext context, ReportsState state) {
    return SizedBox(
      width: 180,
      child: AppSelect<ReportPeriod>(
        items: [
          for (final period in ReportPeriod.values)
            AppSelectItem(value: period, label: period.label),
        ],
        value: state.period,
        onChanged: (period) {
          if (period != null) context.reportsCubit.selectPeriod(period);
        },
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return AppButton.outline(
      onPressed: () {
        // Export (CSV/PDF) is tracked separately as P5-4 and needs a
        // file/share dependency; surface intent rather than silently no-op.
        AppToast.info(context, message: 'Export is coming soon');
      },
      label: t.report.download,
      leadingIcon: const Icon(AgoraIcons.download, size: 20),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.colors.foreground,
        side: BorderSide(color: context.colors.border),
        padding: EdgeInsets.symmetric(
          horizontal: context.tokens.spacing.md,
          vertical: context.tokens.spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.tokens.radius.xs),
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
        icon: Icon(AgoraIcons.cart, color: context.colors.primary, size: 20),
      ),
      SummaryCard(
        title: t.report.total_revenue,
        value: context.formatCurrency(summary.totalRevenueCents),
        trend: '',
        isPositive: true,
        icon: Icon(
          AgoraIcons.coin_alt,
          color: context.colors.primary,
          size: 20,
        ),
      ),
      SummaryCard(
        title: 'Avg Ticket',
        value: context.formatCurrency(summary.averageTicketCents),
        trend: '',
        isPositive: true,
        icon: Icon(AgoraIcons.receipt, color: context.colors.primary, size: 20),
      ),
      SummaryCard(
        title: 'Items Sold',
        value: summary.itemsSold.toString(),
        trend: '',
        isPositive: true,
        icon: Icon(AgoraIcons.package, color: context.colors.primary, size: 20),
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
        crossAxisSpacing: context.tokens.spacing.sm,
        mainAxisSpacing: context.tokens.spacing.sm,
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
          SizedBox(height: context.tokens.spacing.lg),
          productsList,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: salesChart),
        SizedBox(width: context.tokens.spacing.lg),
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
            color: context.colors.success,
          ),
          DonutData(
            label: 'Pending',
            value: status.pending,
            color: context.colors.warning,
          ),
          DonutData(
            label: 'Voided',
            value: status.voided,
            color: context.colors.destructive,
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
            color: context.colors.primary,
          ),
          DonutData(
            label: t.report.stock_status.low_stock,
            value: stock.lowStock,
            color: context.colors.warning,
          ),
          DonutData(
            label: t.report.stock_status.out_of_stock,
            value: stock.outOfStock,
            color: context.colors.destructive,
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          orderStatusChart,
          SizedBox(height: context.tokens.spacing.lg),
          stockStatusChart,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: orderStatusChart),
        SizedBox(width: context.tokens.spacing.lg),
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
          borderRadius: BorderRadius.circular(context.tokens.radius.md),
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
            priority: DataTableColumnPriority.primary,
            label: t.report.recent_order.id,
            cellBuilder: (context, item) =>
                AppText.titleMd('#${item.id ?? '-'}'),
          ),
          DataTableColumn(
            id: 'status',
            priority: DataTableColumnPriority.secondary,
            label: t.report.recent_order.status,
            cellBuilder: (context, item) =>
                _buildStatusBadge(context, item.status),
          ),
          DataTableColumn(
            id: 'orderDate',
            priority: DataTableColumnPriority.secondary,
            label: t.report.recent_order.order_date,
            cellBuilder: (context, item) => AppText.bodySm(
              _formatDateTime(item.createdAt),
              color: context.colors.mutedForeground,
            ),
          ),
          DataTableColumn(
            id: 'orderType',
            priority: DataTableColumnPriority.secondary,
            label: t.report.recent_order.order_type,
            cellBuilder: (context, item) =>
                AppText.body(_orderTypeLabel(item.orderType)),
          ),
          DataTableColumn(
            id: 'payment',
            label: t.report.recent_order.customer,
            cellBuilder: (context, item) =>
                AppText.body(item.paymentMethod ?? '—'),
          ),
          DataTableColumn(
            id: 'qty',
            priority: DataTableColumnPriority.trailing,
            showLabelOnMobile: true,
            label: t.report.recent_order.qty,
            cellBuilder: (context, item) => AppText.body(
              item.items.fold<int>(0, (sum, i) => sum + i.quantity).toString(),
            ),
          ),
          DataTableColumn(
            id: 'total',
            priority: DataTableColumnPriority.trailing,
            label: t.report.recent_order.total,
            cellBuilder: (context, item) =>
                AppText.titleMd(context.formatCurrency(item.grandTotalCents)),
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

  Widget _buildStatusBadge(BuildContext context, OrderStatus status) {
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
        horizontal: context.tokens.spacing.xs,
        vertical: context.tokens.spacing.xxxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.tokens.radius.xs),
      ),
      child: AppText.label(label, color: color),
    );
  }
}
