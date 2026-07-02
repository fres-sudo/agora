import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_inventory/feature_inventory.dart';
import 'package:feature_orders/feature_orders.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_products/feature_products.dart';
import 'package:feature_reports/feature_reports.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:feature_workforce/workforce.dart';
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
  bool _isSidebarCollapsed = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _navItems = [
    AppShellNavItem(icon: Icons.home_outlined, label: 'Point of Sale'),
    AppShellNavItem(icon: Icons.inventory_2_outlined, label: 'Orders'),
    AppShellNavItem(icon: Icons.grid_view_outlined, label: 'Products'),
    AppShellNavItem(icon: Icons.bar_chart_outlined, label: 'Reports'),
    AppShellNavItem(icon: Icons.warehouse_outlined, label: 'Inventory'),
    AppShellNavItem(icon: Icons.settings_outlined, label: 'Settings'),
    AppShellNavItem(icon: Icons.badge_outlined, label: 'Staff'),
  ];

  static final _routedIndices = <int, PageRouteInfo>{
    0: const PosRoute(),
    1: const OrdersRoute(),
    2: const ProductsRoute(),
    3: const ReportRoute(),
    4: const InventoryRoute(),
    5: const SettingsRoute(),
    6: const EmployeesRoute(),
  };

  @override
  void initState() {
    super.initState();
    // Check clock-in status for the logged-in employee.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employee = context.read<SessionCubit>().currentEmployee;
      if (employee != null) {
        context.read<ClockInCubit>().checkStatus(employee.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final employee = session is Authenticated ? session.employee : null;

    return BlocBuilder<ClockInCubit, ClockInState>(
      builder: (context, clockState) {
        final isClockedIn = clockState.maybeWhen(
          clockedIn: (_) => true,
          orElse: () => false,
        );

        return AutoTabsRouter(
          homeIndex: 0,
          routes: [
            const PosRoute(),
            const OrdersRoute(),
            const ProductsRoute(),
            const ReportRoute(),
            const InventoryRoute(),
            const SettingsRoute(),
            const EmployeesRoute(),
          ],
          builder: (context, child) {
            final tabsRouter = AutoTabsRouter.of(context);
            final currentRouteName = tabsRouter.current.name;
            final activeIndex = _routedIndices.entries
                .firstWhere(
                  (e) => e.value.routeName == currentRouteName,
                  orElse: () => MapEntry(
                    _selectedIndex,
                    _routedIndices[_selectedIndex] ?? const PosRoute(),
                  ),
                )
                .key;

            return AppShellScope(
              userName: employee?.name ?? 'Guest',
              userSubtitle: employee?.role ?? '',
              isClockedIn: isClockedIn,
              onClockInTap: () => _onClockInTap(employee?.id),
              onLogout: () => context.read<SessionCubit>().signOut(),
              currentOperator: 'Main Counter',
              onOperatorSwitchTap: () {},
              openSidebar: () => _scaffoldKey.currentState?.openDrawer(),
              child: _buildLayout(context, child, tabsRouter, activeIndex),
            );
          },
        );
      },
    );
  }

  Future<void> _onClockInTap(int? employeeId) async {
    if (employeeId == null) return;
    final cubit = context.read<ClockInCubit>();
    if (cubit.isClockedIn) {
      await cubit.clockOut(employeeId);
    } else {
      await cubit.clockIn(employeeId);
    }
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
              logo: Image.asset('assets/brand/logo.png', width: 26, height: 26),
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
                  AppIconButton.ghost(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.neutral400),
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40),
                    ),
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
