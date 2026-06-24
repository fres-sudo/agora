import 'package:feature_orders/domain/models/selected_modifiers.dart';
import 'package:bloc_exports/bloc_exports.dart';

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

  static OrderLineItem fake() => OrderLineItem(
    productId: 1,
    productName: 'Product Name',
    quantity: 1,
    unitPriceCents: 100,
    selectedModifiers: [],
  );
}
