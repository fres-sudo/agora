import 'package:auto_route/auto_route.dart';
import 'package:feature_settings/presentation/widgets/category_section.dart';
import 'package:feature_settings/presentation/widgets/danger_zone_section.dart';
import 'package:feature_settings/presentation/widgets/modifier_section.dart';
import 'package:feature_settings/presentation/widgets/payment_method_section.dart';
import 'package:feature_settings/presentation/widgets/discount_section.dart';
import 'package:feature_settings/presentation/widgets/printer_section.dart';
import 'package:feature_settings/presentation/widgets/receipt_option_section.dart';
import 'package:feature_settings/presentation/widgets/store_setting_section.dart';
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
            icon: AgoraIcons
                .garage, // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.store_outlined
            label: 'Store Setting',
            child: const StoreSettingSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons
                .square, // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.category_outlined
            label: 'Category',
            child: const CategorySection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.filter,
            label: 'Modifier',
            child: const ModifierSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.creditCard,
            label: 'Payment Method',
            child: const PaymentMethodSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.discount,
            label: 'Taxes',
            child: const TaxesSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.discount,
            label: 'Discount & Voucher',
            child: const DiscountVoucherSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.receipt,
            label: 'Receipt Option',
            child: const ReceiptOptionSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.printer,
            label: 'Printer',
            child: const PrinterSection(),
          ),
          SectionSidebarItemData(
            icon: AgoraIcons.alert,
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
