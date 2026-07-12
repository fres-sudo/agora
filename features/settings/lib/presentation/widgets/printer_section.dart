import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';
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
  bool _isPrintingTest = false;

  @override
  void initState() {
    super.initState();
    _loadFromSettings();
    _receiptCtrl.addListener(_onChanged);
    _kitchenCtrl.addListener(_onChanged);
  }

  void _loadFromSettings() {
    final cubit = context.read<SettingsCubit>();
    _receiptCtrl.text =
        cubit.getString(AppSettingsDao.keyPrinterIpReceipt) ?? '';
    _kitchenCtrl.text =
        cubit.getString(AppSettingsDao.keyPrinterIpKitchen) ?? '';
  }

  void _onChanged() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  Future<void> _onSave() async {
    setState(() => _isSaving = true);

    final cubit = context.read<SettingsCubit>();
    await Future.wait([
      cubit.update(
        AppSettingsDao.keyPrinterIpReceipt,
        _receiptCtrl.text.trim(),
      ),
      cubit.update(
        AppSettingsDao.keyPrinterIpKitchen,
        _kitchenCtrl.text.trim(),
      ),
    ]);

    if (!mounted) return;
    setState(() {
      _isDirty = false;
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: AppText.body('Printer settings saved')),
    );
  }

  /// Builds a small sample [Receipt], renders it to ESC/POS bytes and sends it
  /// through the configured [PrinterService] so staff can verify a printer
  /// before relying on it during service.
  Future<void> _onPrintTestReceipt() async {
    setState(() => _isPrintingTest = true);

    final cubit = context.read<SettingsCubit>();
    final printer = context.read<PrinterService>();
    final receipt = Receipt(
      storeName:
          _nullIfEmpty(cubit.getString(AppSettingsDao.keyBusinessName)) ??
          'Test Store',
      storeAddress: _nullIfEmpty(
        cubit.getString(AppSettingsDao.keyBusinessAddress),
      ),
      header: 'Test Receipt',
      footer: 'Printer configuration OK',
      orderNumber: 'TEST',
      createdAt: DateTime.now(),
      lines: const [
        ReceiptLine(name: 'Sample Item', quantity: 1, unitPriceCents: 500),
      ],
      subtotalCents: 500,
      taxCents: 0,
      discountCents: 0,
      totalCents: 500,
      currencySymbol:
          _nullIfEmpty(cubit.getString(AppSettingsDao.keyCurrencySymbol)) ??
          '€',
      showTax: false,
    );

    try {
      final bytes = await const ReceiptRenderer().toEscPos(receipt);
      final result = await printer.printBytes(bytes);
      if (!mounted) return;
      result.when(
        success: (_) =>
            showAppSnackBar(context, 'Test receipt sent to printer'),
        error: (_) => showAppSnackBar(
          context,
          'Test print failed — check the printer connection',
          isError: true,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Test print failed — check the printer connection',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isPrintingTest = false);
    }
  }

  static String? _nullIfEmpty(String? value) =>
      (value == null || value.isEmpty) ? null : value;

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
            SizedBox(height: context.tokens.spaceMd),
            _PrinterField(
              label: 'Kitchen Printer IP',
              hint: 'e.g. 192.168.1.51',
              controller: _kitchenCtrl,
            ),
            SizedBox(height: context.tokens.spaceLg),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton.outline(
                onPressed: _isPrintingTest ? null : _onPrintTestReceipt,
                isLoading: _isPrintingTest,
                label: 'Print Test Receipt',
                leadingIcon: const Icon(AgoraIcons.printer, size: 20),
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
    return AppTextField(
      label: label,
      hintText: hint,
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }
}
