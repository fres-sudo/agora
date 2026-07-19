import 'package:order_management/models/combo_line_component.dart';
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

    /// Prep-station snapshot (from `Product.prepStation` at the moment this
    /// line was added). Null = never ticketed, stays on the customer
    /// receipt only (docs/features/02-kitchen-ticket-routing.md).
    String? prepStation,

    // Combo support (docs/features/03-combo-modifier-pricing.md). A combo
    // is one cart line pre-persist (productId null, comboComponents
    // populated) that fans out into one OrderItemsTable row per constituent
    // at persist time — see OrdersRepositoryImpl._insertComboLine. Once
    // persisted/rehydrated, each constituent is its own OrderLineItem with
    // a real productId, comboComponents empty, and a shared comboLineId.
    int? comboId,
    String? comboName, // Snapshot of the combo's name
    @Default([]) List<ComboLineComponent> comboComponents, // Pre-persist only
    int? comboLineId, // Non-null only post-persist; groups sibling rows
    // Lead row only, non-null only post-persist: how many combo units were
    // sold on this line, as opposed to `quantity` (how many of *this*
    // constituent to make) — the two diverge once a combo's own constituent
    // quantities aren't all 1. Read by the receipt mapper's grouping pass.
    int? comboSaleQuantity,
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
