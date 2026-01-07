part of 'discounts_bloc.dart';

@freezed
class DiscountsState with _$DiscountsState {
  const DiscountsState._();

  /// Initial state.
  const factory DiscountsState.initial() = _Initial;

  /// Loading discounts.
  const factory DiscountsState.loading() = _Loading;

  /// Loaded with discounts.
  const factory DiscountsState.loaded({
    required List<Discount> discounts,
    @Default(false) bool showActiveOnly,
  }) = DiscountsLoaded;

  /// Error state.
  const factory DiscountsState.error({
    required String message,
    DiscountsLoaded? previousState,
  }) = _Error;

  /// Returns discounts if loaded.
  List<Discount> get discounts => maybeMap(
        loaded: (s) => s.discounts,
        error: (s) => s.previousState?.discounts ?? [],
        orElse: () => [],
      );

  /// Returns count of active discounts.
  int get activeCount => discounts.where((d) => d.isActive).length;
}
