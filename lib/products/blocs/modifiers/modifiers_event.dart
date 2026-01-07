part of 'modifiers_bloc.dart';

@freezed
sealed class ModifiersEvent with _$ModifiersEvent {
  /// Start watching modifiers.
  const factory ModifiersEvent.started() = _Started;

  /// Create a new modifier group.
  const factory ModifiersEvent.created(ModifierGroup modifierGroup) = _Created;

  /// Update an existing modifier group.
  const factory ModifiersEvent.updated(ModifierGroup modifierGroup) = _Updated;

  /// Delete a modifier group by ID.
  const factory ModifiersEvent.deleted(int id) = _Deleted;

  /// Link a modifier to a product.
  const factory ModifiersEvent.linkedToProduct({
    required int productId,
    required int modifierId,
  }) = _LinkedToProduct;

  /// Unlink a modifier from a product.
  const factory ModifiersEvent.unlinkedFromProduct({
    required int productId,
    required int modifierId,
  }) = _UnlinkedFromProduct;
}
