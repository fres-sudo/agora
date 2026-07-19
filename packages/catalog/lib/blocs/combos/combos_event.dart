part of 'combos_bloc.dart';

@freezed
sealed class CombosEvent with _$CombosEvent {
  /// Start watching combos.
  const factory CombosEvent.started() = _Started;

  /// Create a new combo.
  const factory CombosEvent.created(Combo combo) = _Created;

  /// Update an existing combo (replaces its item list entirely).
  const factory CombosEvent.updated(Combo combo) = _Updated;

  /// Delete a combo by ID.
  const factory CombosEvent.deleted(int id) = _Deleted;
}
