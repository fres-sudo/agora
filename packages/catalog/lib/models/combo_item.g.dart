// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ComboItem _$ComboItemFromJson(Map<String, dynamic> json) => _ComboItem(
  productId: (json['productId'] as num).toInt(),
  productName: json['productName'] as String,
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$ComboItemToJson(_ComboItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': instance.quantity,
    };
