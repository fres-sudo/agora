// This model's default `color` is a persisted DATA value (a category's
// swatch), not an app theme token, so the hard-coded-color rule does not
// apply here.
// ignore_for_file: avoid_hardcoded_colors
import 'package:catalog/models/converters.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    @CatalogColorConverter() @Default(Color(0xff34CB6F)) Color? color,
    @CatalogIconDataConverter() @Default(AgoraIcons.categories) IconData? icon,
    @Default(true) bool isEnabled,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  const Category._();
}
