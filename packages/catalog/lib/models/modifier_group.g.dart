// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModifierGroup _$ModifierGroupFromJson(Map<String, dynamic> json) =>
    _ModifierGroup(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isMultiSelect: json['isMultiSelect'] as bool,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => ModifierOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ModifierGroupToJson(_ModifierGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isMultiSelect': instance.isMultiSelect,
      'options': instance.options,
    };
