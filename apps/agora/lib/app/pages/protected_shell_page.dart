import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:agora/app/widgets/session_listener.dart';
import 'package:feature_orders/feature_orders.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_products/feature_products.dart';
import 'package:feature_reports/feature_reports.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ProtectedShellPage extends StatefulWidget {
  const ProtectedShellPage({super.key});

  @override
  State<ProtectedShellPage> createState() => _ProtectedShellPageState();
}

class _ProtectedShellPageState extends State<ProtectedShellPage> {
  int _selectedIndex = 0;
  bool _isClockedIn = false;
  bool _isSidebarCollapsed = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _navItems = [
    AppShellNavItem(icon: Icons.home_outlined, label: 'Point of Sale'),
    AppShellNavItem(icon: Icons.inventory_2_outlined, label: 'Orders'),
    AppShellNavItem(icon: Icons.people_outline, label: 'Customers', isEnabled: false),
    AppShellNavItem(icon: Icons.table_restaurant_outlined, label: 'Tables', isEnabled: false),
    AppShellNavItem(icon: Icons.grid_view_outlined, label: 'Products'),
    AppShellNavItem(icon: Icons.bar_chart_outlined, label: 'Reports'),
    AppShellNavItem(icon: Icons.warehouse_outlined, label: 'Inventory', isEnabled: false),
    AppShellNavItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  // Maps sidebar indices to AutoRoute routes (only enabled, routed items)
  static const _routedIndices = {
    0: PosRoute(),
    1: OrdersRoute(),
    4: ProductsRoute(),
    5: ReportRoute(),
    7: SettingsRoute(),
  };

  @override
  Widget build(BuildContext context) {
    return SessionListener(
      child: AutoTabsRouter(
        homeIndex: 0,
        routes: const [
          PosRoute(),
          OrdersRoute(),
          ProductsRoute(),
          ReportRoute(),
          SettingsRoute(),
        ],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);

          // Keep selected index in sync with the active route
          final currentRouteName = tabsRouter.current.name;
          final activeIndex = _routedIndices.entries
              .firstWhere(
                (e) => e.value.routeName == currentRouteName,
                orElse: () => MapEntry(_selectedIndex, _routedIndices[_selectedIndex] ?? const PosRoute()),
              )
              .key;

          return AppShellScope(
            userName: 'Brian Susanto',
            userSubtitle: 'JS002T',
            isClockedIn: _isClockedIn,
            onClockInTap: () => setState(() => _isClockedIn = !_isClockedIn),
            onLogout: () {
              // TODO: Implement logout
            },
            currentOperator: 'Main Counter',
            onOperatorSwitchTap: () {
              // TODO: Implement operator switch
            },
            openSidebar: () => _scaffoldKey.currentState?.openDrawer(),
            child: _buildLayout(context, child, tabsRouter, activeIndex),
          );
        },
      ),
    );
  }

  Widget _buildLayout(
    BuildContext context,
    Widget child,
    TabsRouter tabsRouter,
    int activeIndex,
  ) {
    final isTablet = context.isTabletOrLarger;

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            AppShellSidebar(
              items: _navItems,
              selectedIndex: activeIndex,
              isCollapsed: _isSidebarCollapsed,
              onCollapsedChanged: (v) => setState(() => _isSidebarCollapsed = v),
              onItemSelected: (index) {
                setState(() => _selectedIndex = index);
                final route = _routedIndices[index];
                if (route != null) tabsRouter.navigate(route);
              },
              logo: Image.asset(
                'assets/brand/logo.png',
                width: 26,
                height: 26,
              ),
            ),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildMobileDrawer(context, tabsRouter, activeIndex),
      body: child,
    );
  }

  Widget _buildMobileDrawer(
    BuildContext context,
    TabsRouter tabsRouter,
    int activeIndex,
  ) {
    return Drawer(
      backgroundColor: AppColors.neutral900,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Image.asset('assets/brand/logo.png', width: 26, height: 26),
                  const SizedBox(width: 10),
                  Text(
                    'agora',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.neutral400),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AppShellSidebar(
                items: _navItems,
                selectedIndex: activeIndex,
                isCollapsed: false,
                showHeader: false,
                showCollapseToggle: false,
                onItemSelected: (index) {
                  setState(() => _selectedIndex = index);
                  final route = _routedIndices[index];
                  if (route != null) tabsRouter.navigate(route);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
