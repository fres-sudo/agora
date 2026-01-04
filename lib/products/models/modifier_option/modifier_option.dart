import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier_option.freezed.dart';

@freezed
abstract class ModifierOption with _$ModifierOption {
  const factory ModifierOption({
    required int id,
    required String name,
    required int priceChangeCents,
  }) = _ModifierOption;

  String get formattedPrice => priceChangeCents > 0
      ? "+ \$${(priceChangeCents / 100.0).toStringAsFixed(2)}"
      : "";

  const ModifierOption._();
}
