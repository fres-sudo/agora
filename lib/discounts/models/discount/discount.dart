import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount.freezed.dart';
part 'discount.g.dart';

enum DiscountType {
  @JsonValue(0)
  percentage,
  @JsonValue(1)
  fixedAmount,
}

@freezed
abstract class Discount with _$Discount {
  const factory Discount({
    required int id,
    required String name,
    String? code,
    required DiscountType type,
    required int value,
    @Default(true) bool isActive,
    DateTime? validUntil,
    int? usageLimit,
    @Default(0) int usageCount,
  }) = _Discount;

  factory Discount.fromJson(Map<String, dynamic> json) => _$DiscountFromJson(json);

  const Discount._();

  bool get isPercentage => type == DiscountType.percentage;
  bool get isFixedAmount => type == DiscountType.fixedAmount;

  bool get isValid {
    if (!isActive) return false;
    if (validUntil != null && validUntil!.isBefore(DateTime.now())) return false;
    if (usageLimit != null && usageCount >= usageLimit!) return false;
    return true;
  }
}
