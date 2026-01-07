import 'package:flutter/material.dart';
import 'package:agora/settings/widgets/settings_section_scaffold.dart';

/// Store settings section for configuring store information.
class StoreSettingSection extends StatelessWidget {
  const StoreSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Store Setting',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormField(label: 'Store Name'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _FormField(label: 'Phone')),
              const SizedBox(width: 16),
              Expanded(child: _FormField(label: 'Email')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _FormField(label: 'City')),
              const SizedBox(width: 16),
              Expanded(child: _FormField(label: 'Country')),
            ],
          ),
          const SizedBox(height: 16),
          _FormField(label: 'Full Address', maxLines: 3),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    this.maxLines = 1,
  });

  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
