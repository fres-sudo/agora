import 'package:bloc_exports/bloc_exports.dart';

part 'combo_item.freezed.dart';

@freezed
abstract class ComboItem with _$ComboItem {
  const factory ComboItem({
    required int productId,
    required String productName, // Denormalized for display without a join
    @Default(1) int quantity,
  }) = _ComboItem;

  const ComboItem._();
}
