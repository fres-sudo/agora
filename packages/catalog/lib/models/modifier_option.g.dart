// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModifierOption _$ModifierOptionFromJson(Map<String, dynamic> json) =>
    _ModifierOption(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      priceChangeCents: (json['priceChangeCents'] as num).toInt(),
    );

Map<String, dynamic> _$ModifierOptionToJson(_ModifierOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priceChangeCents': instance.priceChangeCents,
    };
