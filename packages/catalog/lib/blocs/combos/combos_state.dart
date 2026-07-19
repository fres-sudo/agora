part of 'combos_bloc.dart';

@freezed
class CombosState with _$CombosState {
  const CombosState._();

  /// Initial state.
  const factory CombosState.initial() = _Initial;

  /// Loading combos.
  const factory CombosState.loading() = _Loading;

  /// Loaded with combos.
  const factory CombosState.loaded({required List<Combo> combos}) =
      CombosLoaded;

  /// Error state.
  const factory CombosState.error({
    required String message,
    CombosLoaded? previousState,
  }) = _Error;

  /// Returns the combos list if loaded.
  List<Combo> get combos => maybeMap(
    loaded: (s) => s.combos,
    error: (s) => s.previousState?.combos ?? [],
    orElse: () => [],
  );
}
