import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/models/product/product_status.dart';
import 'package:flutter/material.dart';

/// A badge displaying the status of a product (Active, Inactive, Draft).
class ProductStatusBadge extends StatelessWidget {
  const ProductStatusBadge({
    required this.status,
    super.key,
  });

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
        backgroundColor = AppColors.success100;
        foregroundColor = AppColors.success700;
        label = t.products.status.active;
        break;
      case ProductStatus.inactive:
        backgroundColor = AppColors.error100;
        foregroundColor = AppColors.error700;
        label = t.products.status.inactive;
        break;
      case ProductStatus.draft:
        backgroundColor = AppColors.neutral100;
        foregroundColor = AppColors.neutral700;
        label = t.products.status.draft;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Sizes.xs),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
