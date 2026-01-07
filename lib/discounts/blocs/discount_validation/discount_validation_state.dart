part of 'discount_validation_cubit.dart';

@freezed
class DiscountValidationState with _$DiscountValidationState {
  const DiscountValidationState._();

  /// Initial/idle state.
  const factory DiscountValidationState.initial() = _Initial;

  /// Validating a code.
  const factory DiscountValidationState.validating() = _Validating;

  /// Valid discount found.
  const factory DiscountValidationState.valid({
    required Discount discount,
  }) = DiscountValidationValid;

  /// Invalid code or discount.
  const factory DiscountValidationState.invalid({
    required String reason,
  }) = _Invalid;

  /// Error during validation.
  const factory DiscountValidationState.error({
    required String message,
  }) = _Error;

  /// Returns true if a valid discount is available.
  bool get hasValidDiscount => this is DiscountValidationValid;

  /// Returns the valid discount if available.
  Discount? get discount => maybeMap(
        valid: (s) => s.discount,
        orElse: () => null,
      );
}
