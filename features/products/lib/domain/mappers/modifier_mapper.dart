import 'package:database/database.dart';
import 'package:catalog/models/modifier_group.dart';
import 'package:catalog/models/modifier_option.dart';

/// Extension on [ModifierEntity] for converting to the [ModifierGroup]
/// domain model.
///
/// Shared between [ModifiersRepositoryImpl] and [ProductsRepositoryImpl] (the
/// latter uses it to hydrate `Product.modifierGroups`) so the entity->model
/// mapping only lives in one place.
extension ModifierEntityMapper on ModifierEntity {
  ModifierGroup toModel({required List<ModifierOption> options}) {
    return ModifierGroup(
      id: id,
      name: name,
      isMultiSelect: isMultiSelect,
      options: options,
    );
  }
}

/// Extension on [ModifierOptionEntity] for converting to the
/// [ModifierOption] domain model.
extension ModifierOptionEntityMapper on ModifierOptionEntity {
  ModifierOption toModel() {
    return ModifierOption(id: id, name: name, priceChangeCents: priceChange);
  }
}
