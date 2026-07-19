import 'package:database/database.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/combo_item.dart';

/// Extension on [ComboEntity] for converting to the [Combo] domain model.
extension ComboEntityMapper on ComboEntity {
  Combo toModel({required List<ComboItem> items}) {
    return Combo(
      id: id,
      name: name,
      priceCents: price,
      isEnabled: isEnabled,
      items: items,
    );
  }
}

/// Extension on [ComboItemEntity] for converting to the [ComboItem] domain
/// model.
extension ComboItemEntityMapper on ComboItemEntity {
  ComboItem toModel() {
    return ComboItem(
      productId: productId,
      productName: productName,
      quantity: quantity,
    );
  }
}
