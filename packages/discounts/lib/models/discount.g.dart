// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Discount _$DiscountFromJson(Map<String, dynamic> json) => _Discount(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  code: json['code'] as String?,
  type: $enumDecode(_$DiscountTypeEnumMap, json['type']),
  value: (json['value'] as num).toInt(),
  isActive: json['isActive'] as bool? ?? true,
  validUntil: json['validUntil'] == null
      ? null
      : DateTime.parse(json['validUntil'] as String),
  usageLimit: (json['usageLimit'] as num?)?.toInt(),
  usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DiscountToJson(_Discount instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'type': _$DiscountTypeEnumMap[instance.type]!,
  'value': instance.value,
  'isActive': instance.isActive,
  'validUntil': instance.validUntil?.toIso8601String(),
  'usageLimit': instance.usageLimit,
  'usageCount': instance.usageCount,
};

const _$DiscountTypeEnumMap = {
  DiscountType.percentage: 0,
  DiscountType.fixedAmount: 1,
};
