import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:feature_inventory/feature_inventory.dart';
import 'package:feature_kitchen/feature_kitchen.dart';
import 'package:feature_orders/feature_orders.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_products/feature_products.dart';
import 'package:feature_reports/feature_reports.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:feature_workforce/workforce.dart';
import 'package:result/result.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ProtectedShellPage extends StatefulWidget {
  const ProtectedShellPage({super.key});

  @override
  State<ProtectedShellPage> createState() => _ProtectedShellPageState();
}

class _ProtectedShellPageState extends State<ProtectedShellPage> {
  static const double _outerRadius = 24;
  static const double _innerRadius = 16;

  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// The navigation destinations available for [profile]. The core screens are
  /// always present; the rest are gated on business-type capabilities so the
  /// app only shows what this kind of business needs.
  static List<_NavEntry> _entriesFor(BusinessProfile profile) => [
    const _NavEntry(
      AppShellNavItem(
        icon: AgoraIcons.home_01,
        selectedIcon: AgoraIcons.home_01_solid,
        label: 'Point of Sale',
      ),
      PosRoute(),
    ),
    const _NavEntry(
      AppShellNavItem(
        icon: AgoraIcons.receipt,
        selectedIcon: AgoraIcons.receipt_solid,
        label: 'Orders',
      ),
      OrdersRoute(),
    ),
    const _NavEntry(
      AppShellNavItem(
        icon: AgoraIcons.categories,
        selectedIcon: AgoraIcons.categories_solid,
        label: 'Products',
      ),
      ProductsRoute(),
    ),
    if (profile.has(Capability.reports))
      const _NavEntry(
        AppShellNavItem(
          icon: AgoraIcons.chart,
          selectedIcon: AgoraIcons.chart_solid,
          label: 'Reports',
        ),
        ReportRoute(),
      ),
    if (profile.has(Capability.inventory))
      const _NavEntry(
        AppShellNavItem(
          icon: AgoraIcons.package,
          selectedIcon: AgoraIcons.package_solid,
          label: 'Inventory',
        ),
        InventoryRoute(),
      ),
    if (profile.has(Capability.kitchenRouting))
      const _NavEntry(
        AppShellNavItem(
          icon: AgoraIcons.chef_hat,
          selectedIcon: AgoraIcons.chef_hat_solid,
          label: 'Kitchen',
        ),
        StationQueueRoute(),
      ),
    const _NavEntry(
      AppShellNavItem(
        icon: AgoraIcons.settings_01,
        selectedIcon: AgoraIcons.settings_01_solid,
        label: 'Settings',
      ),
      SettingsRoute(),
    ),
    if (profile.has(Capability.staffLogin))
      const _NavEntry(
        AppShellNavItem(
          icon: AgoraIcons.user_add,
          selectedIcon: AgoraIcons.user_add_solid,
          label: 'Staff',
        ),
        EmployeesRoute(),
      ),
  ];

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
    final profile = context.watch<BusinessProfileCubit>().state;
    final entries = _entriesFor(profile);

    return BlocBuilder<ClockInCubit, ClockInState>(
      builder: (context, clockState) {
        final isClockedIn = clockState.maybeWhen(
          clockedIn: (_) => true,
          orElse: () => false,
        );

        return AutoTabsRouter(
          homeIndex: 0,
          routes: [
            for (final e in entries) e.route,
            // This route is not a navigation destination, but it is a child
            // of ProtectedShellRoute. AutoTabsRouter must know about every
            // child that can be resolved beneath this shell; otherwise it
            // falls back to homeIndex (the POS tab) when an order detail is
            // pushed. The placeholder argument is replaced by AutoRoute with
            // the actual pending route and its orderId before it is built.
            OrderDetailRoute(orderId: 0),
          ],
          builder: (context, child) {
            final tabsRouter = AutoTabsRouter.of(context);
            final currentRouteName = tabsRouter.current.name;
            var activeIndex = entries.indexWhere(
              (e) => e.route.routeName == currentRouteName,
            );
            if (currentRouteName == OrderDetailRoute.name) {
              activeIndex = entries.indexWhere(
                (e) => e.route.routeName == OrdersRoute.name,
              );
            }
            if (activeIndex < 0) {
              activeIndex = _selectedIndex.clamp(0, entries.length - 1);
            }

            return AppShellScope(
              userName: employee?.name ?? 'Guest',
              userSubtitle: employee?.role ?? '',
              isClockedIn: isClockedIn,
              onClockInTap: () => _onClockInTap(employee?.id),
              onLogout: () => context.read<SessionCubit>().signOut(),
              currentOperator: 'Main Counter',
              onOperatorSwitchTap: () {},
              openSidebar: () => _scaffoldKey.currentState?.openDrawer(),
              child: _buildLayout(
                context,
                child,
                tabsRouter,
                activeIndex,
                entries,
              ),
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
      await _handleClockOut(employeeId);
    } else {
      await cubit.clockIn(employeeId);
    }
  }

  /// Shows the skippable cash-count sheet before clocking out
  /// (docs/features/04-volunteer-shift-accountability.md). The count step
  /// never blocks clocking out: `clockOut` fires unconditionally regardless
  /// of whether the volunteer confirms a count, skips it, or the
  /// expected-cash lookup itself errors.
  Future<void> _handleClockOut(int employeeId) async {
    final cubit = context.read<ClockInCubit>();
    final activeRecord = cubit.state.maybeWhen(
      clockedIn: (record) => record,
      orElse: () => null,
    );

    if (activeRecord != null) {
      final workforceRepo = context.read<WorkforceRepository>();
      final expectedResult = await workforceRepo.expectedCashCentsForShift(
        activeRecord.id,
      );
      final expectedCents = expectedResult.isSuccess
          ? expectedResult.unwrap()
          : 0;

      if (!mounted) return;
      final count = await CashCountSheet.show(
        context,
        expectedCents: expectedCents,
      );
      if (count != null) {
        await workforceRepo.recordCashReconciliation(
          clockRecordId: activeRecord.id,
          expectedCents: expectedCents,
          countedCents: count.countedCents,
          note: count.note,
        );
      }
    }

    if (!mounted) return;
    await context.read<ClockInCubit>().clockOut(employeeId);
  }

  Widget _buildLayout(
    BuildContext context,
    Widget child,
    TabsRouter tabsRouter,
    int activeIndex,
    List<_NavEntry> entries,
  ) {
    final isTablet = context.isTabletOrLarger;

    if (isTablet) {
      return Scaffold(
        backgroundColor: AppColors.dark.background,
        body: ClipRRect(
          borderRadius: BorderRadius.circular(_outerRadius),
          child: ColoredBox(
            color: AppColors.dark.background,
            child: Row(
              children: [
                AppShellSidebar(
                  items: [for (final e in entries) e.item],
                  selectedIndex: activeIndex,
                  isCollapsed: _isSidebarCollapsed,
                  onCollapsedChanged: (v) =>
                      setState(() => _isSidebarCollapsed = v),
                  onItemSelected: (index) {
                    setState(() => _selectedIndex = index);
                    tabsRouter.navigate(entries[index].route);
                  },
                  logo: Image.asset(
                    'assets/brand/logo.png',
                    width: 26,
                    height: 26,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      context.tokens.spacing.sm,
                      context.tokens.spacing.sm,
                      context.tokens.spacing.sm,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_innerRadius),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildMobileDrawer(context, tabsRouter, activeIndex, entries),
      body: child,
    );
  }

  Widget _buildMobileDrawer(
    BuildContext context,
    TabsRouter tabsRouter,
    int activeIndex,
    List<_NavEntry> entries,
  ) {
    return Drawer(
      backgroundColor: AppColors.dark.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.tokens.spacing.lg,
                context.tokens.spacing.md,
                context.tokens.spacing.sm,
                context.tokens.spacing.xs,
              ),
              child: Row(
                children: [
                  Image.asset('assets/brand/logo.png', width: 26, height: 26),
                  SizedBox(width: context.tokens.spacing.xs),
                  AppText.titleLg('agora', color: AppColors.dark.foreground),
                  const Spacer(),
                  AppIconButton.ghost(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      AgoraIcons.x_mark,
                      color: AppColors.dark.mutedForeground,
                    ),
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
                items: [for (final e in entries) e.item],
                selectedIndex: activeIndex,
                isCollapsed: false,
                showHeader: false,
                showCollapseToggle: false,
                onItemSelected: (index) {
                  setState(() => _selectedIndex = index);
                  tabsRouter.navigate(entries[index].route);
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

/// Pairs a sidebar destination with the tab route it opens. The visible set is
/// derived from the active [BusinessProfile] so nav and routes stay aligned.
class _NavEntry {
  const _NavEntry(this.item, this.route);
  final AppShellNavItem item;
  final PageRouteInfo route;
}
