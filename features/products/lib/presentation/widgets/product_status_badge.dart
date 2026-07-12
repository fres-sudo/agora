import 'package:i18n/i18n.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/product_status.dart';
import 'package:flutter/material.dart';

/// A badge displaying the status of a product (Active, Inactive, Draft).
class ProductStatusBadge extends StatelessWidget {
  const ProductStatusBadge({required this.status, super.key});

  final ProductStatus status;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    // Determine colors and label based on status
    Color backgroundColor;
    Color foregroundColor;
    String label;

    switch (status) {
      case ProductStatus.active:
        backgroundColor = AppPalette.success100;
        foregroundColor = AppPalette.success700;
        label = t.products.status.active;
        break;
      case ProductStatus.inactive:
        backgroundColor = AppPalette.error100;
        foregroundColor = AppPalette.error700;
        label = t.products.status.inactive;
        break;
      case ProductStatus.draft:
        backgroundColor = AppPalette.neutral100;
        foregroundColor = AppPalette.neutral700;
        label = t.products.status.draft;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.sm,
        vertical: context.tokens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Sizes.xs),
      ),
      child: AppText.label(
        label,
        color: foregroundColor,
        textAlign: TextAlign.center,
      ),
    );
  }
}
