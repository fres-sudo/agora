import 'package:flutter/material.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';

/// Placeholder sections for future implementation.
///
/// These sections currently display placeholder text but follow the
/// same structure as fully implemented sections.

/// Payment method settings section.
class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSectionScaffold(
      title: 'Payment Method',
      child: Center(child: Text('Payment method settings coming soon...')),
    );
  }
}

/// Taxes settings section.
class TaxesSection extends StatelessWidget {
  const TaxesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSectionScaffold(
      title: 'Taxes',
      child: Center(child: Text('Taxes settings coming soon...')),
    );
  }
}

/// Discount and voucher settings section.
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
