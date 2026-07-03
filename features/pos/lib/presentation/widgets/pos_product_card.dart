import 'package:ui_kit/ui_kit.dart';
import 'package:feature_products/domain/models/product.dart';
import 'package:flutter/material.dart';

/// A product card widget for the POS product grid.
/// Displays product image, name, price, and optional quantity badge.
class PosProductCard extends StatelessWidget {
  /// The product to display.
  final Product product;

  /// Quantity of this product in the current cart.
  /// If greater than 0, a badge is shown.
  final int quantityInCart;

  /// Callback when the card is tapped.
  final VoidCallback onTap;

  /// Currency symbol to display. Defaults to '$'.
  final String currencySymbol;

  const PosProductCard({
    super.key,
    required this.product,
    this.quantityInCart = 0,
    required this.onTap,
    this.currencySymbol = '€',
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.card,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: quantityInCart > 0
                ? Border.all(color: colors.primary, width: 2)
                : Border.all(color: colors.border, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Expanded(
                child: Stack(
                  children: [
                    // Product image or placeholder
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.muted,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.fastfood_outlined,
                          size: 48,
                          color: colors.mutedForeground,
                        ),
                      ),
                    ),
                    // Quantity badge
                    if (quantityInCart > 0)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: _QuantityBadge(quantity: quantityInCart),
                      ),
                  ],
                ),
              ),
              // Info section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    AppText.titleMd(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price row
                    Row(
                      children: [
                        AppText.body(
                          '$currencySymbol ${(product.priceCents / 100).toStringAsFixed(2)}',
                          color: colors.mutedForeground,
                        ),
                        if (quantityInCart > 0) ...[
                          const SizedBox(width: 8),
                          AppText.bodySm('x', color: colors.mutedForeground),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: AppText.label(
                              '$quantityInCart',
                              color: colors.primaryForeground,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityBadge extends StatelessWidget {
  final int quantity;

  const _QuantityBadge({required this.quantity});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText.label('$quantity', color: colors.primaryForeground),
    );
  }
}
