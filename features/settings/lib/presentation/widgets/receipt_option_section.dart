import 'package:flutter/material.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';

/// Receipt presentation settings: the header/footer text printed on receipts
/// and which optional blocks (logo, tax line) are shown.
///
/// Mirrors the `receipt_*` keys persisted by `AppSettingsDao`.
class ReceiptOptionSection extends StatelessWidget {
  const ReceiptOptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Receipt Option',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReceiptField(label: 'Receipt Header', hint: 'Shown above the items (e.g. a greeting)'),
          const SizedBox(height: 16),
          _ReceiptField(
            label: 'Receipt Footer',
            hint: 'Shown at the bottom (e.g. "Thank you!")',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          const _ReceiptToggle(
            label: 'Show store logo',
            description: 'Print the store logo at the top of the receipt.',
          ),
          const Divider(height: 24),
          const _ReceiptToggle(
            label: 'Show tax breakdown',
            description: 'Include the tax line in the receipt totals.',
            initialValue: true,
          ),
        ],
      ),
    );
  }
}

class _ReceiptField extends StatelessWidget {
  const _ReceiptField({required this.label, required this.hint, this.maxLines = 1});

  final String label;
  final String hint;
  final int maxLines;

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
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class _ReceiptToggle extends StatefulWidget {
  const _ReceiptToggle({required this.label, required this.description, this.initialValue = false});

  final String label;
  final String description;
  final bool initialValue;

  @override
  State<_ReceiptToggle> createState() => _ReceiptToggleState();
}

class _ReceiptToggleState extends State<_ReceiptToggle> {
  late bool _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                widget.description,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),
        Switch(value: _value, onChanged: (value) => setState(() => _value = value)),
      ],
    );
  }
}
