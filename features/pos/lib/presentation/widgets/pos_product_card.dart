import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/product.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

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

  /// Currency symbol to display.
  final String currencySymbol;

  const PosProductCard({
    super.key,
    required this.product,
    this.quantityInCart = 0,
    required this.onTap,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.card,
      borderRadius: context.tokens.radius.borderLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: quantityInCart > 0
                ? Border.all(color: colors.primary, width: 2)
                : Border.all(color: colors.border, width: 1),
            borderRadius: context.tokens.radius.borderLg,
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
                      child: LayoutBuilder(
                        builder: (context, constraints) => Center(
                          child: AppSourcedImage(
                            source: product.imageUrl,
                            size: constraints.biggest.shortestSide,
                            borderRadius: BorderRadius.zero,
                            placeholderIcon: AgoraIcons.burger,
                          ),
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
                padding: EdgeInsets.all(context.tokens.spacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    AppText.titleMd(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.tokens.spacing.xxs),
                    // Price row
                    Row(
                      children: [
                        AppText.body(
                          formatCents(
                            product.priceCents,
                            symbol: currencySymbol,
                          ),
                          color: colors.mutedForeground,
                        ),
                        if (quantityInCart > 0) ...[
                          SizedBox(width: context.tokens.spacing.xs),
                          AppText.bodySm('x', color: colors.mutedForeground),
                          SizedBox(width: context.tokens.spacing.xxs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.tokens.spacing.xs,
                              vertical: context.tokens.spacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: context.tokens.radius.borderLg,
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
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spacing.xs,
        vertical: context.tokens.spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: context.tokens.radius.borderLg,
      ),
      child: AppText.label('$quantity', color: colors.primaryForeground),
    );
  }
}
