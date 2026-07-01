import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:ui_kit/ui_kit.dart';

class PrinterSection extends StatefulWidget {
  const PrinterSection({super.key});

  @override
  State<PrinterSection> createState() => _PrinterSectionState();
}

class _PrinterSectionState extends State<PrinterSection> {
  late final TextEditingController _receiptIpController;
  late final TextEditingController _kitchenIpController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsCubit>();
    _receiptIpController = TextEditingController(
      text: settings.getString(AppSettingsDao.keyPrinterIpReceipt) ?? '',
    );
    _kitchenIpController = TextEditingController(
      text: settings.getString(AppSettingsDao.keyPrinterIpKitchen) ?? '',
    );
  }

  @override
  void dispose() {
    _receiptIpController.dispose();
    _kitchenIpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Printer',
      actionButton: AppButton.primary(
        onPressed: _save,
        label: 'Save Changes',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _receiptIpController,
            decoration: const InputDecoration(
              labelText: 'Receipt printer IP',
              hintText: 'e.g. 192.168.1.100',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _kitchenIpController,
            decoration: const InputDecoration(
              labelText: 'Kitchen printer IP',
              hintText: 'e.g. 192.168.1.101',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final settings = context.read<SettingsCubit>();
    settings.update(
      AppSettingsDao.keyPrinterIpReceipt,
      _receiptIpController.text.trim(),
    );
    settings.update(
      AppSettingsDao.keyPrinterIpKitchen,
      _kitchenIpController.text.trim(),
    );
  }
}
