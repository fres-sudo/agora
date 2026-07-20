// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogSnapshot _$CatalogSnapshotFromJson(Map<String, dynamic> json) =>
    _CatalogSnapshot(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      modifierGroups:
          (json['modifierGroups'] as List<dynamic>?)
              ?.map((e) => ModifierGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      combos:
          (json['combos'] as List<dynamic>?)
              ?.map((e) => Combo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CatalogSnapshotToJson(_CatalogSnapshot instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'modifierGroups': instance.modifierGroups,
      'products': instance.products,
      'combos': instance.combos,
    };
