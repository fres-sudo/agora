import 'package:order_management/models/selected_modifiers.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'order_line_item.freezed.dart';

@freezed
abstract class OrderLineItem with _$OrderLineItem {
  const factory OrderLineItem({
    /// Cart-local unique identifier (assigned by [ActiveOrderBloc] when the
    /// line is added). Not persisted as-is — `OrderItemsTable` assigns its
    /// own DB id on insert — but needed so the cart can address a specific
    /// line (remove/quantity-change) once more than one line can share the
    /// same [productId] (e.g. the same product added with different
    /// modifier selections).
    required int id,
    int? productId, // Nullable in case product was deleted later
    required String productName, // Snapshot name
    required int quantity,
    required int unitPriceCents, // Snapshot price
    required List<SelectedModifiers> selectedModifiers,
  }) = _OrderLineItem;

  const OrderLineItem._();

  static OrderLineItem fake() => OrderLineItem(
    id: 1,
    productId: 1,
    productName: 'Product Name',
    quantity: 1,
    unitPriceCents: 100,
    selectedModifiers: [],
  );
}
