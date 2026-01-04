import 'package:freezed_annotation/freezed_annotation.dart';

part 'pos_settings.freezed.dart';

@freezed
abstract class PosSettings with _$PosSettings {
  const factory PosSettings({
    required String currencySymbol,
    required double taxRate, // e.g., 0.08 for 8%
    required String? receiptHeader,
    required String? printerIp,
    required bool showImages,
  }) = _PosSettings;

  const PosSettings._();
}
