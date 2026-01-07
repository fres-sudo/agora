import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:agora/core/ui/widgets/section_page_layout/section_page_layout_module.dart';
import 'package:agora/settings/widgets/widgets.dart';

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu),
        ),
        title: Text('Settings'),
      ),
      body: SectionPageLayout(
        items: [
          SectionSidebarItemData(
            icon: Icons.store_outlined,
            label: 'Store Setting',
            child: const StoreSettingSection(),
          ),
          SectionSidebarItemData(
            icon: Icons.category_outlined,
            label: 'Category',
            child: const CategorySection(),
          ),
          SectionSidebarItemData(
            icon: Icons.tune_outlined,
            label: 'Modifier',
            child: const ModifierSection(),
          ),
          SectionSidebarItemData(
            icon: Icons.payment_outlined,
            label: 'Payment Method',
            child: const PaymentMethodSection(),
          ),
          SectionSidebarItemData(
            icon: Icons.percent_outlined,
            label: 'Taxes',
            child: const TaxesSection(),
          ),
          SectionSidebarItemData(
            icon: Icons.local_offer_outlined,
            label: 'Discount & Voucher',
            child: const DiscountVoucherSection(),
          ),
          SectionSidebarItemData(
            icon: Icons.receipt_long_outlined,
            label: 'Receipt Option',
            child: const ReceiptOptionSection(),
          ),
          SectionSidebarItemData(
            icon: Icons.print_outlined,
            label: 'Printer',
            child: const PrinterSection(),
          ),
        ],
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
