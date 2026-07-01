import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Printer configuration: the network addresses of the receipt and kitchen
/// thermal printers.
///
/// Persists the `printer_ip_*` keys via [SettingsCubit]. The actual transport
/// is wired by the app via the `printing` package's `PrinterService`.
class PrinterSection extends StatefulWidget {
  const PrinterSection({super.key});

  @override
  State<PrinterSection> createState() => _PrinterSectionState();
}

class _PrinterSectionState extends State<PrinterSection> {
  final _receiptCtrl = TextEditingController();
  final _kitchenCtrl = TextEditingController();
  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFromSettings();
    _receiptCtrl.addListener(_onChanged);
    _kitchenCtrl.addListener(_onChanged);
  }

  void _loadFromSettings() {
    final cubit = context.read<SettingsCubit>();
    _receiptCtrl.text = cubit.getString(AppSettingsDao.keyPrinterIpReceipt) ?? '';
    _kitchenCtrl.text = cubit.getString(AppSettingsDao.keyPrinterIpKitchen) ?? '';
  }

  void _onChanged() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  Future<void> _onSave() async {
    setState(() => _isSaving = true);

    final cubit = context.read<SettingsCubit>();
    await Future.wait([
      cubit.update(AppSettingsDao.keyPrinterIpReceipt, _receiptCtrl.text.trim()),
      cubit.update(AppSettingsDao.keyPrinterIpKitchen, _kitchenCtrl.text.trim()),
    ]);

    if (!mounted) return;
    setState(() {
      _isDirty = false;
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Printer settings saved')),
    );
  }

  @override
  void dispose() {
    _receiptCtrl.removeListener(_onChanged);
    _kitchenCtrl.removeListener(_onChanged);
    _receiptCtrl.dispose();
    _kitchenCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) => !prev.isLoaded && curr.isLoaded,
      listener: (context, state) => _loadFromSettings(),
      child: SettingsSectionScaffold(
        title: 'Printer',
        actionButton: AppButton.primary(
          onPressed: (_isDirty && !_isSaving) ? _onSave : null,
          label: _isSaving ? 'Saving…' : 'Save Changes',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PrinterField(
              label: 'Receipt Printer IP',
              hint: 'e.g. 192.168.1.50',
              controller: _receiptCtrl,
            ),
            const SizedBox(height: 16),
            _PrinterField(
              label: 'Kitchen Printer IP',
              hint: 'e.g. 192.168.1.51',
              controller: _kitchenCtrl,
            ),
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
      ),
    );
  }
}

class _PrinterField extends StatelessWidget {
  const _PrinterField({
    required this.label,
    required this.hint,
    required this.controller,
  });

  final String label;
  final String hint;
  final TextEditingController controller;

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
          controller: controller,
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
