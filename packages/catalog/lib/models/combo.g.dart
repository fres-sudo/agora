// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Combo _$ComboFromJson(Map<String, dynamic> json) => _Combo(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  priceCents: (json['priceCents'] as num).toInt(),
  isEnabled: json['isEnabled'] as bool? ?? true,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ComboItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ComboToJson(_Combo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'priceCents': instance.priceCents,
  'isEnabled': instance.isEnabled,
  'items': instance.items,
};
