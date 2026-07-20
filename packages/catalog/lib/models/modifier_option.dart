import 'package:bloc_exports/bloc_exports.dart';

part 'modifier_option.freezed.dart';
part 'modifier_option.g.dart';

@freezed
abstract class ModifierOption with _$ModifierOption {
  const factory ModifierOption({
    required int id,
    required String name,
    required int priceChangeCents,
  }) = _ModifierOption;

  factory ModifierOption.fromJson(Map<String, dynamic> json) =>
      _$ModifierOptionFromJson(json);

  String get formattedPrice => priceChangeCents > 0
      ? "+ \$${(priceChangeCents / 100.0).toStringAsFixed(2)}"
      : "";

  const ModifierOption._();
}
