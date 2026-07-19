import 'package:catalog/models/combo.dart';
import 'package:catalog/models/product.dart';

/// Something that can appear as a tile on the POS grid: either a plain
/// [Product] or a fixed-contents [Combo] (docs/features/03-combo-modifier-pricing.md).
/// Lets [PosProductGrid] render and tap-route both kinds through one list
/// without the grid needing to know about combos beyond this thin wrapper.
sealed class PosMenuEntry {
  const PosMenuEntry();

  String get displayName;
  int get priceCents;
}

final class PosMenuProductEntry extends PosMenuEntry {
  const PosMenuProductEntry(this.product);

  final Product product;

  @override
  String get displayName => product.name;

  @override
  int get priceCents => product.priceCents;
}

final class PosMenuComboEntry extends PosMenuEntry {
  const PosMenuComboEntry(this.combo);

  final Combo combo;

  @override
  String get displayName => combo.name;

  @override
  int get priceCents => combo.priceCents;
}
