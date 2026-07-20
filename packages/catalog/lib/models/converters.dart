// This file converts persisted DATA values (a category's swatch color/icon
// glyph), not app theme tokens, so the hard-coded-color rule does not apply.
// ignore_for_file: avoid_hardcoded_colors
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// Serializes [Color] as its 32-bit ARGB int, mirroring
/// `package:database`'s Drift `ColorConverter` for the same field.
class CatalogColorConverter implements JsonConverter<Color?, int?> {
  const CatalogColorConverter();

  @override
  Color? fromJson(int? json) => json == null ? null : Color(json);

  @override
  int? toJson(Color? object) => object?.toARGB32();
}

/// Serializes [IconData] as its `codePoint` only. `fontFamily`/`fontPackage`
/// are fixed to the app's bundled `AgoraIcons` font on the way back in,
/// matching `CategoryEntityMapper.toModel()`'s reconstruction from the
/// Drift-stored code point.
class CatalogIconDataConverter implements JsonConverter<IconData?, int?> {
  const CatalogIconDataConverter();

  @override
  IconData? fromJson(int? json) => json == null
      ? null
      : IconData(json, fontFamily: 'AgoraIcons', fontPackage: 'ui_kit');

  @override
  int? toJson(IconData? object) => object?.codePoint;
}
