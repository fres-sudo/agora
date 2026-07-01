import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';

/// Printer configuration: the network addresses of the receipt and kitchen
/// thermal printers.
///
/// Mirrors the `printer_ip_*` keys persisted by `AppSettingsDao`. The actual
/// transport is wired by the app via the `printing` package's `PrinterService`.
class PrinterSection extends StatelessWidget {
  const PrinterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Printer',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PrinterField(label: 'Receipt Printer IP', hint: 'e.g. 192.168.1.50'),
          const SizedBox(height: 16),
          _PrinterField(label: 'Kitchen Printer IP', hint: 'e.g. 192.168.1.51'),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton.outline(
              onPressed: () {},
              label: 'Print Test Receipt',
              leadingIcon: const Icon(Icons.print_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrinterField extends StatelessWidget {
  const _PrinterField({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
