import 'package:auto_route/auto_route.dart';
import 'package:feature_settings/presentation/widgets/category_section.dart';
import 'package:feature_settings/presentation/widgets/danger_zone_section.dart';
import 'package:feature_settings/presentation/widgets/modifier_section.dart';
import 'package:feature_settings/presentation/widgets/payment_method_section.dart';
import 'package:feature_settings/presentation/widgets/discount_section.dart';
import 'package:feature_settings/presentation/widgets/printer_section.dart';
import 'package:feature_settings/presentation/widgets/receipt_option_section.dart';
import 'package:feature_settings/presentation/widgets/store_setting_section.dart';
import 'package:feature_settings/presentation/widgets/sync_section.dart';
import 'package:feature_settings/presentation/widgets/taxes_section.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AppShellMenuButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SectionPageLayout(
        items: [
          SectionSidebarItemData(
            icon: AgoraIcons.building,
            selectedIcon: AgoraIcons.building_solid,
            label: 'Store Setting',
            child: const StoreSettingSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.categories,
            selectedIcon: AgoraIcons.categories_solid,
            label: 'Category',
            child: const CategorySection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.filter,
            selectedIcon: AgoraIcons.filter_solid,
            label: 'Modifier',
            child: const ModifierSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.card,
            selectedIcon: AgoraIcons.card_solid,
            label: 'Payment Method',
            child: const PaymentMethodSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.discount,
            selectedIcon: AgoraIcons.discount_solid,
            label: 'Taxes',
            child: const TaxesSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.discount,
            selectedIcon: AgoraIcons.discount_solid,
            label: 'Discount & Voucher',
            child: const DiscountVoucherSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.receipt,
            selectedIcon: AgoraIcons.receipt_solid,
            label: 'Receipt Option',
            child: const ReceiptOptionSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.printer,
            selectedIcon: AgoraIcons.printer_solid,
            label: 'Printer',
            child: const PrinterSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.wifi,
            selectedIcon: AgoraIcons.wifi_solid,
            label: 'Sync',
            child: const SyncSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.alert_triangle,
            selectedIcon: AgoraIcons.alert_triangle_solid,
            label: 'Reset',
            child: const DangerZoneSection(),
          ),
        ],
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
