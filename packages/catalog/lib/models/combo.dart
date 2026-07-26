import 'package:catalog/models/combo_item.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'combo.freezed.dart';
part 'combo.g.dart';

@freezed
abstract class Combo with _$Combo {
  const factory Combo({
    required int id,
    required String name,
    required int priceCents, // Flat price, overrides the sum of parts
    @Default(true) bool isEnabled,
    @Default([]) List<ComboItem> items,
  }) = _Combo;

  factory Combo.fromJson(Map<String, dynamic> json) => _$ComboFromJson(json);

  const Combo._();
}
