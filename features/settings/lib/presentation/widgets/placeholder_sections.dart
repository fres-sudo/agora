import 'package:flutter/material.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';

/// Discount & voucher settings — placeholder until Phase 6 (P6-3).
class DiscountVoucherSection extends StatelessWidget {
  const DiscountVoucherSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSectionScaffold(
      title: 'Discount & Voucher',
      child: Center(child: Text('Discount & voucher settings coming soon...')),
    );
  }
}
