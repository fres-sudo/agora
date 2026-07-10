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

  /// Create a new option under an existing modifier group.
  ///
  /// [ModifiersRepository.updateModifier] only persists the group's own
  /// fields (name/isMultiSelect) — option changes must go through these
  /// dedicated option events instead.
  const factory ModifiersEvent.optionCreated({
    required int modifierId,
    required ModifierOption option,
  }) = _OptionCreated;

  /// Update an existing option (name and/or price change).
  const factory ModifiersEvent.optionUpdated(ModifierOption option) =
      _OptionUpdated;

  /// Delete an option by ID.
  const factory ModifiersEvent.optionDeleted(int id) = _OptionDeleted;
}
