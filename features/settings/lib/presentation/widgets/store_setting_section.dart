import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Store settings section for configuring store information and currency.
///
/// Persists via [SettingsCubit] using the keys defined in [AppSettingsDao].
class StoreSettingSection extends StatefulWidget {
  const StoreSettingSection({super.key});

  @override
  State<StoreSettingSection> createState() => _StoreSettingSectionState();
}

class _StoreSettingSectionState extends State<StoreSettingSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _currencyCtrl = TextEditingController();

  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFromSettings();
  }

  void _loadFromSettings() {
    final cubit = context.read<SettingsCubit>();
    _nameCtrl.text = cubit.getString(AppSettingsDao.keyBusinessName) ?? '';
    _phoneCtrl.text = cubit.getString(AppSettingsDao.keyBusinessPhone) ?? '';
    _emailCtrl.text = cubit.getString(AppSettingsDao.keyBusinessEmail) ?? '';
    _cityCtrl.text = cubit.getString(AppSettingsDao.keyBusinessCity) ?? '';
    _countryCtrl.text =
        cubit.getString(AppSettingsDao.keyBusinessCountry) ?? '';
    _addressCtrl.text =
        cubit.getString(AppSettingsDao.keyBusinessAddress) ?? '';
    _currencyCtrl.text =
        cubit.getString(AppSettingsDao.keyCurrencySymbol) ?? '€';

    for (final ctrl in _controllers) {
      ctrl.addListener(_onChanged);
    }
  }

  List<TextEditingController> get _controllers => [
    _nameCtrl,
    _phoneCtrl,
    _emailCtrl,
    _cityCtrl,
    _countryCtrl,
    _addressCtrl,
    _currencyCtrl,
  ];

  void _onChanged() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final cubit = context.read<SettingsCubit>();
    await Future.wait([
      cubit.update(AppSettingsDao.keyBusinessName, _nameCtrl.text.trim()),
      cubit.update(AppSettingsDao.keyBusinessPhone, _phoneCtrl.text.trim()),
      cubit.update(AppSettingsDao.keyBusinessEmail, _emailCtrl.text.trim()),
      cubit.update(AppSettingsDao.keyBusinessCity, _cityCtrl.text.trim()),
      cubit.update(AppSettingsDao.keyBusinessCountry, _countryCtrl.text.trim()),
      cubit.update(AppSettingsDao.keyBusinessAddress, _addressCtrl.text.trim()),
      cubit.update(
        AppSettingsDao.keyCurrencySymbol,
        _currencyCtrl.text.trim().isEmpty ? '€' : _currencyCtrl.text.trim(),
      ),
    ]);

    if (!mounted) return;
    setState(() {
      _isDirty = false;
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: AppText.body('Store settings saved')),
    );
  }

  @override
  void dispose() {
    for (final ctrl in _controllers) {
      ctrl.removeListener(_onChanged);
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reload fields if settings are updated externally (e.g. first load).
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) => !prev.isLoaded && curr.isLoaded,
      listener: (context, state) => _loadFromSettings(),
      child: SettingsSectionScaffold(
        title: 'Store Setting',
        actionButton: AppButton.primary(
          onPressed: (_isDirty && !_isSaving) ? _onSave : null,
          label: _isSaving ? 'Saving…' : 'Save Changes',
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FormField(label: 'Store Name', controller: _nameCtrl),
              SizedBox(height: context.tokens.spaceMd),
              Row(
                children: [
                  Expanded(
                    child: _FormField(label: 'Phone', controller: _phoneCtrl),
                  ),
                  SizedBox(width: context.tokens.spaceMd),
                  Expanded(
                    child: _FormField(label: 'Email', controller: _emailCtrl),
                  ),
                ],
              ),
              SizedBox(height: context.tokens.spaceMd),
              Row(
                children: [
                  Expanded(
                    child: _FormField(label: 'City', controller: _cityCtrl),
                  ),
                  SizedBox(width: context.tokens.spaceMd),
                  Expanded(
                    child: _FormField(
                      label: 'Country',
                      controller: _countryCtrl,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.tokens.spaceMd),
              _FormField(
                label: 'Full Address',
                controller: _addressCtrl,
                maxLines: 3,
              ),
              const Divider(height: 32),
              _FormField(
                label: 'Currency Symbol',
                controller: _currencyCtrl,
                hint: 'e.g. € or \$',
              ),
              SizedBox(height: context.tokens.spaceXxs),
              AppText.bodySm(
                'Symbol shown on prices and receipts across the app.',
                color: context.colors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hintText: hint ?? 'Enter $label',
      controller: controller,
      maxLines: maxLines,
    );
  }
}
