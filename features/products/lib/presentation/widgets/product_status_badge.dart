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
        backgroundColor = context.colors.success.withValues(alpha: 0.12);
        foregroundColor = context.colors.success;
        label = t.products.status.active;
        break;
      case ProductStatus.inactive:
        backgroundColor = context.colors.destructive.withValues(alpha: 0.12);
        foregroundColor = context.colors.destructive;
        label = t.products.status.inactive;
        break;
      case ProductStatus.draft:
        backgroundColor = context.colors.muted;
        foregroundColor = context.colors.foreground;
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
