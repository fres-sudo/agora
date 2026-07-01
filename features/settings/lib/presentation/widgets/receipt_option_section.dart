import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:ui_kit/ui_kit.dart';

class ReceiptOptionSection extends StatefulWidget {
  const ReceiptOptionSection({super.key});

  @override
  State<ReceiptOptionSection> createState() => _ReceiptOptionSectionState();
}

class _ReceiptOptionSectionState extends State<ReceiptOptionSection> {
  late final TextEditingController _businessNameController;
  late final TextEditingController _currencySymbolController;
  late final TextEditingController _headerController;
  late final TextEditingController _footerController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsCubit>();
    _businessNameController = TextEditingController(
      text: settings.getString(AppSettingsDao.keyBusinessName) ?? '',
    );
    _currencySymbolController = TextEditingController(
      text: settings.getString(AppSettingsDao.keyCurrencySymbol) ?? r'$',
    );
    _headerController = TextEditingController(
      text: settings.getString(AppSettingsDao.keyReceiptHeader) ?? '',
    );
    _footerController = TextEditingController(
      text: settings.getString(AppSettingsDao.keyReceiptFooter) ?? '',
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _currencySymbolController.dispose();
    _headerController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Receipt Option',
      actionButton: AppButton.primary(
        onPressed: _save,
        label: 'Save Changes',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _businessNameController,
            decoration: const InputDecoration(
              labelText: 'Business name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _currencySymbolController,
            decoration: const InputDecoration(
              labelText: 'Currency symbol',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _headerController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Receipt header',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _footerController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Receipt footer',
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
      AppSettingsDao.keyBusinessName,
      _businessNameController.text.trim(),
    );
    settings.update(
      AppSettingsDao.keyCurrencySymbol,
      _currencySymbolController.text.trim().isEmpty
          ? r'$'
          : _currencySymbolController.text.trim(),
    );
    settings.update(
      AppSettingsDao.keyReceiptHeader,
      _headerController.text.trim(),
    );
    settings.update(
      AppSettingsDao.keyReceiptFooter,
      _footerController.text.trim(),
    );
  }
}
