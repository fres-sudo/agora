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

  static const _menuItems = [
    MenuDrawerItemData(icon: Icons.home_outlined, label: 'Point of Sale', route: PosRoute()),
    MenuDrawerItemData(icon: Icons.inventory_2_outlined, label: 'Order', route: OrdersRoute()),
    MenuDrawerItemData(icon: Icons.people_outline, label: 'Customer'),
    MenuDrawerItemData(icon: Icons.table_restaurant_outlined, label: 'Tables'),
    MenuDrawerItemData(icon: Icons.grid_view_outlined, label: 'Product', route: ProductsRoute()),
    MenuDrawerItemData(icon: Icons.bar_chart_outlined, label: 'Report', route: ReportRoute()),
    MenuDrawerItemData(icon: Icons.warehouse_outlined, label: 'Inventory'),
    MenuDrawerItemData(icon: Icons.settings_outlined, label: 'Setting', route: SettingsRoute()),
  ];

  @override
  Widget build(BuildContext context) {
    return SessionListener(
      child: AutoTabsRouter(
        homeIndex: 0,
        routes: const [PosRoute(), OrdersRoute(), ProductsRoute(), ReportRoute(), SettingsRoute()],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          // Find the index in _menuItems that matches the current active tab's route
          final currentRouteName = tabsRouter.current.name;
          final drawerIndex = _menuItems.indexWhere(
            (item) => item.route?.routeName == currentRouteName,
          );

          return Scaffold(
            drawer: AppMenuDrawer(
              appName: 'agora',
              logo: Icon(Icons.bolt, color: AppColors.primary500, size: 28),
              items: _menuItems,
              selectedIndex: drawerIndex != -1 ? drawerIndex : _selectedIndex,
              onItemSelected: (index) {
                setState(() => _selectedIndex = index);
                final item = _menuItems[index];
                if (item.route != null) {
                  tabsRouter.navigate(item.route!);
                }
              },
              userName: 'Brian Susanto',
              userSubtitle: 'JS002T',
              showClockIn: true,
              isClockedIn: _isClockedIn,
              onClockInTap: () {
                setState(() => _isClockedIn = !_isClockedIn);
              },
              onLogout: () {
                // TODO: Implement logout logic
              },
            ),
            body: child,
          );
        },
      ),
    );
  }
}
