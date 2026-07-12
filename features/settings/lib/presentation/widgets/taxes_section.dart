import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';

/// Tax-rate configuration section.
///
/// Stores a single inclusive tax rate (percentage, 0–100) via [SettingsCubit]
/// under the key [AppSettingsDao.keyTaxRate]. The active-order bloc reads
/// this value when building order totals.
class TaxesSection extends StatefulWidget {
  const TaxesSection({super.key});

  @override
  State<TaxesSection> createState() => _TaxesSectionState();
}

class _TaxesSectionState extends State<TaxesSection> {
  final _formKey = GlobalKey<FormState>();
  final _rateCtrl = TextEditingController();

  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFromSettings();
    _rateCtrl.addListener(_onChanged);
  }

  void _loadFromSettings() {
    final cubit = context.read<SettingsCubit>();
    final rate = cubit.getDouble(AppSettingsDao.keyTaxRate) ?? 0.0;
    _rateCtrl.text = rate == 0.0 ? '' : _formatRate(rate);
  }

  String _formatRate(double rate) {
    // Show as integer when whole number (e.g. 22.0 → "22"), otherwise decimal.
    return rate == rate.truncateToDouble()
        ? rate.toInt().toString()
        : rate.toString();
  }

  void _onChanged() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final raw = _rateCtrl.text.trim();
    final rate = raw.isEmpty ? 0.0 : (double.tryParse(raw) ?? 0.0);

    final cubit = context.read<SettingsCubit>();
    await cubit.updateDouble(AppSettingsDao.keyTaxRate, rate);

    if (!mounted) return;
    setState(() {
      _isDirty = false;
      _isSaving = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: AppText.body('Tax rate saved')));
  }

  @override
  void dispose() {
    _rateCtrl.removeListener(_onChanged);
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) => !prev.isLoaded && curr.isLoaded,
      listener: (context, state) => _loadFromSettings(),
      child: SettingsSectionScaffold(
        title: 'Taxes',
        actionButton: AppButton.primary(
          onPressed: (_isDirty && !_isSaving) ? _onSave : null,
          label: _isSaving ? 'Saving…' : 'Save Changes',
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText.label('Tax Rate (%)'),
              SizedBox(height: context.tokens.spaceXs),
              SizedBox(
                width: 220,
                child: AppTextField(
                  controller: _rateCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  hintText: '0',
                  suffixText: '%',
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final v = double.tryParse(value);
                    if (v == null) return 'Enter a valid number';
                    if (v < 0 || v > 100) return 'Must be between 0 and 100';
                    return null;
                  },
                ),
              ),
              SizedBox(height: context.tokens.spaceSm),
              AppText.bodySm(
                'Applied to each order total. Set to 0 to disable tax.',
                color: context.colors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
