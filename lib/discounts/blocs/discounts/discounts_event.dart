part of 'discounts_bloc.dart';

@freezed
sealed class DiscountsEvent with _$DiscountsEvent {
  /// Start watching discounts.
  const factory DiscountsEvent.started() = _Started;

  /// Create a new discount.
  const factory DiscountsEvent.created(Discount discount) = _Created;

  /// Update an existing discount.
  const factory DiscountsEvent.updated(Discount discount) = _Updated;

  /// Toggle discount active status.
  const factory DiscountsEvent.toggled({
    required int id,
    required bool isActive,
  }) = _Toggled;

  /// Delete a discount.
  const factory DiscountsEvent.deleted(int id) = _Deleted;

  /// Change filter to show active only.
  const factory DiscountsEvent.filterChanged({
    required bool activeOnly,
  }) = _FilterChanged;
}
