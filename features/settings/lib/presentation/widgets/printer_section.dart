import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';
import 'package:ui_kit/ui_kit.dart';

/// Printer configuration: the network addresses of the receipt and kitchen
/// thermal printers, plus this device's kitchen prep station.
///
/// Persists the `printer_ip_*` keys via [SettingsCubit]. The actual transport
/// is wired by the app via the `printing` package's `PrinterService`.
class PrinterSection extends StatefulWidget {
  const PrinterSection({super.key});

  @override
  State<PrinterSection> createState() => _PrinterSectionState();
}

class _PrinterSectionState extends State<PrinterSection> {
  // Mirrors `kitchenStationDeviceSettingKey` in
  // `feature_kitchen/presentation/pages/station_queue_page.dart` — a plain
  // string literal, not a shared constant, since `feature_settings` and
  // `feature_kitchen` must not import each other
  // (docs/features/02-kitchen-ticket-routing.md; `features ↛ features`).
  static const _keyKitchenStationDevice = 'kitchen_station_device';

  final _receiptCtrl = TextEditingController();
  final _kitchenCtrl = TextEditingController();
  final _stationCtrl = TextEditingController();
  bool _isDirty = false;
  bool _isSaving = false;
  bool _isPrintingTest = false;

  @override
  void initState() {
    super.initState();
    _loadFromSettings();
    _receiptCtrl.addListener(_onChanged);
    _kitchenCtrl.addListener(_onChanged);
    _stationCtrl.addListener(_onChanged);
  }

  void _loadFromSettings() {
    final cubit = context.read<SettingsCubit>();
    _receiptCtrl.text =
        cubit.getString(AppSettingsDao.keyPrinterIpReceipt) ?? '';
    _kitchenCtrl.text =
        cubit.getString(AppSettingsDao.keyPrinterIpKitchen) ?? '';
    _stationCtrl.text = cubit.getString(_keyKitchenStationDevice) ?? '';
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
      cubit.update(_keyKitchenStationDevice, _stationCtrl.text.trim()),
    ]);

    if (!mounted) return;
    setState(() {
      _isDirty = false;
      _isSaving = false;
    });

    AppToast.success(context, message: 'Printer settings saved');
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
      currencySymbol: cubit.currencySymbol,
      showTax: false,
    );

    try {
      final bytes = await const ReceiptRenderer().toEscPos(receipt);
      final result = await printer.printBytes(bytes);
      if (!mounted) return;
      result.when(
        success: (_) =>
            AppToast.success(context, message: 'Test receipt sent to printer'),
        error: (_) => AppToast.error(
          context,
          message: 'Test print failed — check the printer connection',
        ),
      );
    } catch (_) {
      if (!mounted) return;
      AppToast.error(
        context,
        message: 'Test print failed — check the printer connection',
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
    _stationCtrl.removeListener(_onChanged);
    _receiptCtrl.dispose();
    _kitchenCtrl.dispose();
    _stationCtrl.dispose();
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
            SizedBox(height: context.tokens.spaceMd),
            AppTextField(
              label: "This device's station",
              hintText: 'e.g. Griglia (leave empty if this is the cash stand)',
              controller: _stationCtrl,
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
