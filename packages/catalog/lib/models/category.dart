import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    @Default(AppPalette.primary500) Color? color,
    @Default(AgoraIcons.categories) IconData? icon,
    @Default(true) bool isEnabled,
  }) = _Category;

  const Category._();
}
