part of 'modifiers_bloc.dart';

@freezed
class ModifiersState with _$ModifiersState {
  const ModifiersState._();

  /// Initial state.
  const factory ModifiersState.initial() = _Initial;

  /// Loading modifiers.
  const factory ModifiersState.loading() = _Loading;

  /// Loaded with modifiers.
  const factory ModifiersState.loaded({
    required List<ModifierGroup> modifiers,
  }) = ModifiersLoaded;

  /// Error state.
  const factory ModifiersState.error({
    required String message,
    ModifiersLoaded? previousState,
  }) = _Error;

  /// Returns the modifiers list if loaded.
  List<ModifierGroup> get modifiers => maybeMap(
        loaded: (s) => s.modifiers,
        error: (s) => s.previousState?.modifiers ?? [],
        orElse: () => [],
      );
}
