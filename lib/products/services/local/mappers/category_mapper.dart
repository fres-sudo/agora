import 'package:agora/core/database/database.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

/// Extension on [CategoryEntity] for converting to domain models.
extension CategoryEntityMapper on CategoryEntity {
  /// Converts a [CategoryEntity] to a [Category] domain model.
  Category toModel() {
    return Category(
      id: id,
      name: name,
      color: color,
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
    );
  }

  /// Creates a [CategoriesTableCompanion] for updating an existing category.
  CategoriesTableCompanion toUpdateCompanion() {
    return CategoriesTableCompanion(
      name: Value(name),
      color: Value(color ?? Colors.blue),
    );
  }
}
