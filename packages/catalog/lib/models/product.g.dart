// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  sku: json['sku'] as String?,
  imageUrl: json['imageUrl'] as String?,
  categoryId: (json['categoryId'] as num).toInt(),
  priceCents: (json['priceCents'] as num).toInt(),
  costCents: (json['costCents'] as num).toInt(),
  taxPercent: (json['taxPercent'] as num?)?.toInt() ?? 0,
  stockQuantity: (json['stockQuantity'] as num).toInt(),
  trackStock: json['trackStock'] as bool? ?? true,
  status:
      $enumDecodeNullable(_$ProductStatusEnumMap, json['status']) ??
      ProductStatus.draft,
  modifierGroups:
      (json['modifierGroups'] as List<dynamic>?)
          ?.map((e) => ModifierGroup.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  prepStation: json['prepStation'] as String?,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'sku': instance.sku,
  'imageUrl': instance.imageUrl,
  'categoryId': instance.categoryId,
  'priceCents': instance.priceCents,
  'costCents': instance.costCents,
  'taxPercent': instance.taxPercent,
  'stockQuantity': instance.stockQuantity,
  'trackStock': instance.trackStock,
  'status': _$ProductStatusEnumMap[instance.status]!,
  'modifierGroups': instance.modifierGroups,
  'prepStation': instance.prepStation,
};

const _$ProductStatusEnumMap = {
  ProductStatus.active: 'active',
  ProductStatus.inactive: 'inactive',
  ProductStatus.draft: 'draft',
};
