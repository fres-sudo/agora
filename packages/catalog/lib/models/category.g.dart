// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  color: json['color'] == null
      ? const Color(0xff34CB6F)
      : const CatalogColorConverter().fromJson(
          (json['color'] as num?)?.toInt(),
        ),
  icon: json['icon'] == null
      ? AgoraIcons.categories
      : const CatalogIconDataConverter().fromJson(
          (json['icon'] as num?)?.toInt(),
        ),
  isEnabled: json['isEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': const CatalogColorConverter().toJson(instance.color),
  'icon': const CatalogIconDataConverter().toJson(instance.icon),
  'isEnabled': instance.isEnabled,
};
