import 'package:feature_settings/presentation/blocs/settings/settings_cubit.dart';
import 'package:printing/printing.dart';

ReceiptConfig buildReceiptConfig(SettingsCubit settingsCubit) {
  final businessName = settingsCubit.getString('business_name')?.trim();
  final storeName = (businessName?.isNotEmpty ?? false)
      ? businessName!
      : 'Agora POS';
  final currencySymbol = settingsCubit.getString('currency_symbol') ?? r'$';
  final header = settingsCubit.getString('receipt_header');
  final footer = settingsCubit.getString('receipt_footer');

  return ReceiptConfig(
    storeName: storeName,
    currencySymbol: currencySymbol,
    header: header,
    footer: footer,
  );
}
