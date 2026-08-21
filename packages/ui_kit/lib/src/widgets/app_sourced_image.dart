import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ui_kit/src/data/product_icon_catalog.dart';
import 'package:ui_kit/src/data/product_stock_gallery.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';
import 'package:ui_kit/src/widgets/app_product_icon.dart';

import 'package:ui_kit/src/theme/agora_icons.dart';

/// Resolves a nullable image source string into the right visual.
///
/// Recognizes three forms of [source]:
/// - `"icon:<type>:<codePoint>"` — an Agora icon and its selected treatment
/// - `"stock:<id>"` — a bundled stock illustration from [kProductStockGallery]
/// - an `http(s)://` URL — a remote image
/// - anything else — treated as a local file path (e.g. a user-uploaded photo)
///
/// Falls back to a muted placeholder box when [source] is null/empty or fails
/// to resolve/load.
class AppSourcedImage extends StatelessWidget {
  const AppSourcedImage({
    required this.source,
    this.size = 40,
    this.borderRadius,
    this.placeholderIcon = AgoraIcons.gallery,
    super.key,
  });

  final String? source;
  final double size;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? context.tokens.radius.borderSm;
    final value = source;

    Widget placeholder() => Icon(
      placeholderIcon,
      size: size * 0.5,
      color: context.colors.mutedForeground,
    );

    Widget content;
    if (value == null || value.isEmpty) {
      content = placeholder();
    } else if (value.startsWith(kProductIconPrefix)) {
      final icon = resolveProductIcon(value);
      final iconType = resolveProductIconType(value);
      final definition = resolveProductIconDefinition(value);
      content = icon == null
          ? placeholder()
          : definition != null && iconType != null
          ? AppProductIcon(
              icon: definition,
              type: iconType,
              size: size * 0.58,
              color: context.colors.foreground,
            )
          : Icon(icon, size: size * 0.58, color: context.colors.foreground);
    } else if (value.startsWith(kProductStockImagePrefix)) {
      final stock = resolveProductStockImage(
        value.substring(kProductStockImagePrefix.length),
      );
      content = stock == null
          ? placeholder()
          : Padding(
              padding: EdgeInsets.all(size * 0.2),
              child: SvgPicture.asset(
                stock.assetPath,
                package: 'ui_kit',
                semanticsLabel: stock.label,
                colorFilter: ColorFilter.mode(
                  context.colors.foreground,
                  BlendMode.srcIn,
                ),
              ),
            );
    } else if (value.startsWith('http://') || value.startsWith('https://')) {
      content = Image.network(
        value,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, _, _) => placeholder(),
      );
    } else {
      content = Image.file(
        File(value),
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, _, _) => placeholder(),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.muted,
        borderRadius: radius,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: content,
    );
  }
}
