import 'package:flutter/material.dart';
import 'package:agora/settings/widgets/settings_section_scaffold.dart';

/// Placeholder sections for future implementation.
///
/// These sections currently display placeholder text but follow the
/// same structure as fully implemented sections.

/// Modifier settings section.
class ModifierSection extends StatelessWidget {
  const ModifierSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSectionScaffold(
      title: 'Modifier',
      child: Center(child: Text('Modifier settings coming soon...')),
    );
  }
}

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

/// Receipt option settings section.
class ReceiptOptionSection extends StatelessWidget {
  const ReceiptOptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSectionScaffold(
      title: 'Receipt Option',
      child: Center(child: Text('Receipt option settings coming soon...')),
    );
  }
}

/// Printer settings section.
class PrinterSection extends StatelessWidget {
  const PrinterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSectionScaffold(
      title: 'Printer',
      child: Center(child: Text('Printer settings coming soon...')),
    );
  }
}
