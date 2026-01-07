import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/models/product/product.dart';
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
    this.currencySymbol = '\$',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: quantityInCart > 0
                ? Border.all(color: AppColors.primary500, width: 2)
                : Border.all(color: AppColors.neutral200, width: 1),
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
                        color: AppColors.neutral100,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.fastfood_outlined,
                          size: 48,
                          color: AppColors.neutral300,
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
                    Text(
                      product.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price row
                    Row(
                      children: [
                        Text(
                          '$currencySymbol ${(product.priceCents / 100).toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral600,
                          ),
                        ),
                        if (quantityInCart > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            'x',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.neutral400,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$quantityInCart',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$quantity',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
