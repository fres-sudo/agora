import 'package:agora/orders/models/selected_modifiers/selected_modifiers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_line_item.freezed.dart';

@freezed
abstract class OrderLineItem with _$OrderLineItem {
  const factory OrderLineItem({
    int? productId, // Nullable in case product was deleted later
    required String productName, // Snapshot name
    required int quantity,
    required int unitPriceCents, // Snapshot price
    required List<SelectedModifiers> selectedModifiers,
  }) = _OrderLineItem;

  const OrderLineItem._();
}
