import 'package:bloc_exports/bloc_exports.dart';

part 'combo_line_component.freezed.dart';

/// One constituent product of a combo cart line, resolved against the live
/// product catalog at add-to-cart time (same liveness convention a plain
/// product line already uses for its own `Product.priceCents`/`prepStation`
/// — not stored on the `Combo` definition itself).
///
/// Only populated pre-persist on [OrderLineItem.comboComponents]; once the
/// order is persisted, each component becomes its own [OrderLineItem] row
/// (see `OrdersRepositoryImpl._insertComboLine`) and this list is emptied.
@freezed
abstract class ComboLineComponent with _$ComboLineComponent {
  const factory ComboLineComponent({
    required int productId,
    required String productName,
    @Default(1) int quantity, // Per one unit of the combo
    @Default(0) int unitCostPriceCents, // Product.costCents at add-to-cart time
    String? prepStation, // Product.prepStation at add-to-cart time
  }) = _ComboLineComponent;

  const ComboLineComponent._();
}
