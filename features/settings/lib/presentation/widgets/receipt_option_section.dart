import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Receipt presentation settings: header/footer text and optional-block toggles.
///
/// Persists via [SettingsCubit] using the `receipt_*` keys in [AppSettingsDao].
class ReceiptOptionSection extends StatefulWidget {
  const ReceiptOptionSection({super.key});

  @override
  State<ReceiptOptionSection> createState() => _ReceiptOptionSectionState();
}

class _ReceiptOptionSectionState extends State<ReceiptOptionSection> {
  final _headerCtrl = TextEditingController();
  final _footerCtrl = TextEditingController();
  bool _showLogo = false;
  bool _showTax = true;
  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFromSettings();
    _headerCtrl.addListener(_onChanged);
    _footerCtrl.addListener(_onChanged);
  }

  void _loadFromSettings() {
    final cubit = context.read<SettingsCubit>();
    _headerCtrl.text = cubit.getString(AppSettingsDao.keyReceiptHeader) ?? '';
    _footerCtrl.text = cubit.getString(AppSettingsDao.keyReceiptFooter) ?? '';
    _showLogo = cubit.getBool(AppSettingsDao.keyReceiptShowLogo);
    _showTax = cubit.getBool(
      AppSettingsDao.keyReceiptShowTax,
      defaultValue: true,
    );
  }

  void _onChanged() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  void _onToggleLogo(bool value) => setState(() {
    _showLogo = value;
    _isDirty = true;
  });

  void _onToggleTax(bool value) => setState(() {
    _showTax = value;
    _isDirty = true;
  });

  Future<void> _onSave() async {
    setState(() => _isSaving = true);

    final cubit = context.read<SettingsCubit>();
    await Future.wait([
      cubit.update(AppSettingsDao.keyReceiptHeader, _headerCtrl.text.trim()),
      cubit.update(AppSettingsDao.keyReceiptFooter, _footerCtrl.text.trim()),
      cubit.updateBool(AppSettingsDao.keyReceiptShowLogo, _showLogo),
      cubit.updateBool(AppSettingsDao.keyReceiptShowTax, _showTax),
    ]);

    if (!mounted) return;
    setState(() {
      _isDirty = false;
      _isSaving = false;
    });

    AppToast.success(context, message: 'Receipt options saved');
  }

  @override
  void dispose() {
    _headerCtrl.removeListener(_onChanged);
    _footerCtrl.removeListener(_onChanged);
    _headerCtrl.dispose();
    _footerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) => !prev.isLoaded && curr.isLoaded,
      listener: (context, state) => _loadFromSettings(),
      child: SettingsSectionScaffold(
        title: 'Receipt Option',
        actionButton: AppButton.primary(
          onPressed: (_isDirty && !_isSaving) ? _onSave : null,
          label: _isSaving ? 'Saving…' : 'Save Changes',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReceiptField(
              label: 'Receipt Header',
              hint: 'Shown above the items (e.g. a greeting)',
              controller: _headerCtrl,
            ),
            SizedBox(height: context.tokens.spacing.md),
            _ReceiptField(
              label: 'Receipt Footer',
              hint: 'Shown at the bottom (e.g. "Thank you!")',
              controller: _footerCtrl,
              maxLines: 3,
            ),
            SizedBox(height: context.tokens.spacing.lg),
            _ReceiptToggle(
              label: 'Show store logo',
              description: 'Print the store logo at the top of the receipt.',
              value: _showLogo,
              onChanged: _onToggleLogo,
            ),
            const Divider(height: 24),
            _ReceiptToggle(
              label: 'Show tax breakdown',
              description: 'Include the tax line in the receipt totals.',
              value: _showTax,
              onChanged: _onToggleTax,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptField extends StatelessWidget {
  const _ReceiptField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hintText: hint,
      controller: controller,
      maxLines: maxLines,
    );
  }
}

class _ReceiptToggle extends StatelessWidget {
  const _ReceiptToggle({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMd(label),
              SizedBox(height: context.tokens.spacing.xxs),
              AppText.bodySm(
                description,
                color: context.colors.mutedForeground,
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
