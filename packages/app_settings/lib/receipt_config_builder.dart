import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:printing/printing.dart';

/// Setting keys (kept in sync with `AppSettingsDao`) that drive the receipt
/// presentation.
const _kBusinessName = 'business_name';
const _kBusinessAddress = 'business_address';
const _kReceiptHeader = 'receipt_header';
const _kReceiptFooter = 'receipt_footer';
const _kReceiptShowTax = 'receipt_show_tax';

/// Builds a [ReceiptConfig] from the current values in [settings].
///
/// Missing settings fall back to sensible defaults so a receipt can always be
/// produced, even before the operator has filled in the store details.
ReceiptConfig buildReceiptConfig(SettingsCubit settings) {
  return ReceiptConfig(
    storeName: settings.getString(_kBusinessName) ?? '',
    storeAddress: _nullIfEmpty(settings.getString(_kBusinessAddress)),
    header: _nullIfEmpty(settings.getString(_kReceiptHeader)),
    footer: _nullIfEmpty(settings.getString(_kReceiptFooter)),
    currencySymbol: settings.currencySymbol,
    showTax: settings.getBool(_kReceiptShowTax, defaultValue: true),
  );
}

String? _nullIfEmpty(String? value) =>
    (value == null || value.isEmpty) ? null : value;
