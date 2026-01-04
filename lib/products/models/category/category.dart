import 'dart:ui';

import 'package:agora/core/ui/theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    @Default(AppColors.primary500) Color? color,
  }) = _Category;

  const Category._();
}
