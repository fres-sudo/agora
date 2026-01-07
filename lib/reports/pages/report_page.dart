import 'package:agora/orders/models/order_line_item/order_line_item.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/reports/widgets/summary_card.dart';
import 'package:agora/reports/widgets/sales_overview_chart.dart';
import 'package:agora/reports/widgets/status_donut_chart.dart';
import 'package:agora/reports/widgets/top_products_list.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_view.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_column.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_config.dart';
import 'package:agora/orders/models/order/order.dart';

@RoutePage()
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  // Breakpoints for responsive layout
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu_rounded),
        ),
        title: Text(t.report.title),
        actions: [
          _buildPeriodDropdown(context),
          const SizedBox(width: Sizes.md),
          _buildDownloadButton(context),
          const SizedBox(width: Sizes.lg),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isMobile = width < _mobileBreakpoint;
          final isTabletPortrait =
              width >= _mobileBreakpoint && width < _tabletBreakpoint;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? Sizes.md : Sizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards - Responsive grid
                _buildSummaryCards(context, width),
                const SizedBox(height: Sizes.xl),

                // Sales Overview & Top Products - Stack on narrow screens
                _buildSalesAndProductsSection(
                    context, isMobile, isTabletPortrait),
                const SizedBox(height: Sizes.xl),

                // Status Donut Charts - Stack on mobile
                _buildStatusChartsSection(context, isMobile),
                const SizedBox(height: Sizes.xl),

                // Recent Orders Table
                _buildRecentOrdersTable(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'last_6_month',
          icon: const Icon(Icons.keyboard_arrow_down),
          style: Theme.of(context).textTheme.bodyMedium,
          items: [
            DropdownMenuItem(
              value: 'last_6_month',
              child: Text(t.report.last_6_month),
            ),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.download_outlined, size: 20),
      label: Text(t.report.download),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.neutral700,
        side: const BorderSide(color: AppColors.neutral200),
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

  Widget _buildSummaryCards(BuildContext context, double availableWidth) {
    final cards = [
      SummaryCard(
        title: t.report.total_order,
        value: '72,099',
        trend: '+7%',
        isPositive: true,
        icon: const Icon(
          Icons.shopping_bag_outlined,
          color: AppColors.primary500,
          size: 20,
        ),
      ),
      SummaryCard(
        title: t.report.total_revenue,
        value: '\$ 349,005',
        trend: '+12%',
        isPositive: true,
        icon: const Icon(
          Icons.attach_money,
          color: AppColors.primary500,
          size: 20,
        ),
      ),
      SummaryCard(
        title: t.report.total_customer,
        value: '50,921',
        trend: '+4%',
        isPositive: true,
        icon: const Icon(
          Icons.people_outline,
          color: AppColors.primary500,
          size: 20,
        ),
      ),
      SummaryCard(
        title: t.report.new_customer,
        value: '6,007',
        trend: '-5%',
        isPositive: false,
        icon: const Icon(
          Icons.person_add_alt_1_outlined,
          color: AppColors.error500,
          size: 20,
        ),
      ),
    ];

    // Determine number of columns based on width
    int crossAxisCount;
    double childAspectRatio;

    if (availableWidth < _mobileBreakpoint) {
      // Mobile: 1 column
      crossAxisCount = 1;
      childAspectRatio = 3.0;
    } else if (availableWidth < _tabletBreakpoint) {
      // Tablet Portrait: 2 columns
      crossAxisCount = 2;
      childAspectRatio = 2.2;
    } else {
      // Desktop: 4 columns
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
      BuildContext context, bool isMobile, bool isTabletPortrait) {
    final salesChart = SizedBox(
      height: isMobile ? 300 : 400,
      child: const SalesOverviewChart(),
    );

    final productsList = SizedBox(
      height: isMobile ? 350 : 400,
      child: TopProductsList(products: _mockTopProducts),
    );

    // Stack vertically on mobile and tablet portrait
    if (isMobile || isTabletPortrait) {
      return Column(
        children: [
          salesChart,
          const SizedBox(height: Sizes.xl),
          productsList,
        ],
      );
    }

    // Side by side on desktop/tablet landscape
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: salesChart),
        const SizedBox(width: Sizes.xl),
        Expanded(child: productsList),
      ],
    );
  }

  Widget _buildStatusChartsSection(BuildContext context, bool isMobile) {
    final productStatusChart = SizedBox(
      height: isMobile ? 320 : 350,
      child: StatusDonutChart(
        title: t.report.product_status.title,
        totalLabel: t.report.product_status.total,
        totalValue: 61,
        onShowAll: () {},
        data: [
          DonutData(
            label: t.report.product_status.active,
            value: 52,
            color: AppColors.primary500,
          ),
          DonutData(
            label: t.report.product_status.inactive,
            value: 7,
            color: AppColors.warning500,
          ),
          DonutData(
            label: t.report.product_status.draft,
            value: 2,
            color: AppColors.info500,
          ),
        ],
      ),
    );

    final stockStatusChart = SizedBox(
      height: isMobile ? 320 : 350,
      child: StatusDonutChart(
        title: t.report.stock_status.title,
        totalLabel: t.report.stock_status.total,
        totalValue: 36,
        onShowAll: () {},
        data: [
          DonutData(
            label: t.report.stock_status.in_stock,
            value: 32,
            color: AppColors.primary500,
          ),
          DonutData(
            label: t.report.stock_status.low_stock,
            value: 1,
            color: AppColors.warning500,
          ),
          DonutData(
            label: t.report.stock_status.out_of_stock,
            value: 3,
            color: AppColors.error500,
          ),
        ],
      ),
    );

    // Stack vertically on mobile
    if (isMobile) {
      return Column(
        children: [
          productStatusChart,
          const SizedBox(height: Sizes.xl),
          stockStatusChart,
        ],
      );
    }

    // Side by side on tablet/desktop
    return Row(
      children: [
        Expanded(child: productStatusChart),
        const SizedBox(width: Sizes.xl),
        Expanded(child: stockStatusChart),
      ],
    );
  }

  Widget _buildRecentOrdersTable(BuildContext context) {
    return SizedBox(
      height: 500,
      child: DataTableView<Order>(
        items: _mockOrders,
        columns: [
          DataTableColumn(
            id: 'id',
            label: t.report.recent_order.id,
            cellBuilder: (item) => Text(
              '#${item.id ?? "2010E10"}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataTableColumn(
            id: 'status',
            label: t.report.recent_order.status,
            cellBuilder: (item) => _buildStatusBadge(item.status),
          ),
          DataTableColumn(
            id: 'orderDate',
            label: t.report.recent_order.order_date,
            cellBuilder: (item) => Text(
              'Oct 16, 2024\n09:31 AM',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
            ),
          ),
          DataTableColumn(
            id: 'customer',
            label: t.report.recent_order.customer,
            cellBuilder: (item) => Text(
              item.note ?? 'Dian Rahmani',
              style: const TextStyle(color: AppColors.neutral700),
            ),
          ),
          DataTableColumn(
            id: 'orderType',
            label: t.report.recent_order.order_type,
            cellBuilder: (item) => const Text('Dine In'),
          ),
          DataTableColumn(
            id: 'qty',
            label: t.report.recent_order.qty,
            cellBuilder: (item) => Text(item.items.length.toString()),
          ),
          DataTableColumn(
            id: 'total',
            label: t.report.recent_order.total,
            cellBuilder: (item) => Text(
              '\$${(item.grandTotalCents / 100).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        config: DataTableConfig(title: t.report.recent_order.title),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    String label;
    switch (status) {
      case OrderStatus.pending:
        color = AppColors.warning500;
        label = 'In Progress';
        break;
      case OrderStatus.completed:
        color = AppColors.primary500;
        label = 'Completed';
        break;
      case OrderStatus.voided:
        color = AppColors.error500;
        label = 'Voided';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.sm,
        vertical: Sizes.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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

  static final _mockTopProducts = [
    TopProductData(name: 'Special Crispyburger', sales: 9778),
    TopProductData(name: 'Double Cheeseburger', sales: 7640),
    TopProductData(name: 'Chocolate Milkshake', sales: 7620),
    TopProductData(name: 'Combo Drumstick & French fries', sales: 7184),
    TopProductData(name: 'Coca cola', sales: 4659),
    TopProductData(name: 'Cheeseburger Deluxe', sales: 3880),
    TopProductData(name: 'Vanilla Sundae', sales: 3783),
    TopProductData(name: 'Spicy Chicken Burger', sales: 3366),
    TopProductData(name: '3 Cheese Wings', sales: 1278),
    TopProductData(name: 'Sprite', sales: 808),
  ];

  static final _mockOrders = List.generate(
    5,
    (index) => Order(
      id: 2000 + index,
      createdAt: DateTime.now(),
      status: index % 3 == 0
          ? OrderStatus.completed
          : (index % 3 == 1 ? OrderStatus.pending : OrderStatus.voided),
      items: List.generate(
        index + 1,
        (i) => OrderLineItem.fake(),
      ), // Mocking line item
      note: index % 2 == 0 ? 'John Doe' : 'Jane Smith',
      subtotalCents: 1000,
      taxCents: 100,
      discountCents: 0,
      grandTotalCents: 1100,
    ),
  );
}

// Simple mock for OrderLineItem since I don't want to import it all if it's complex
class ImageFileOrderLineItem {
  const ImageFileOrderLineItem();
}
