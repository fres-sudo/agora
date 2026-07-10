// The fallback `Colors.blue` is a persisted category-color DATA default written
// to the database, not a theme token — the hard-coded-color rule does not apply.
// ignore_for_file: avoid_hardcoded_colors
import 'package:database/database.dart';
import 'package:catalog/models/category.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Extension on [CategoryEntity] for converting to domain models.
extension CategoryEntityMrpper on CategoryEntity {
  /// Converts a [CategoryEntity] to a [Category] domain model.
  Category toModel() {
    final icon = IconData(
      iconCodePoint,
      fontFamily: 'AgoraIcons',
      fontPackage: 'ui_kit',
    );
    return Category(
      id: id,
      name: name,
      color: color,
      isEnabled: isEnabled,
      icon: icon,
    );
  }
}

/// Extension on [Category] for converting to database companions.
extension CategoryModelMapper on Category {
  /// Creates a [CategoriesTableCompanion] for inserting a new category.
  CategoriesTableCompanion toInsertCompanion() {
    return CategoriesTableCompanion.insert(
      name: name,
      color: color ?? Colors.blue,
      isEnabled: Value(isEnabled),
      iconCodePoint: Value(icon?.codePoint ?? AgoraIcons.categories.codePoint),
    );
  }

  /// Creates a [CategoriesTableCompanion] for updating an existing category.
  CategoriesTableCompanion toUpdateCompanion() {
    return CategoriesTableCompanion(
      name: Value(name),
      color: Value(color ?? Colors.blue),
      isEnabled: Value(isEnabled),
      iconCodePoint: Value(icon?.codePoint ?? AgoraIcons.categories.codePoint),
    );
  }
}
