import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/combo.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

/// A combo card widget for the POS product grid. Near-copy of
/// [PosProductCard] styling, with a distinct "COMBO" badge so the cashier
/// can tell a combo tile from a product tile at a glance
/// (docs/features/03-combo-modifier-pricing.md).
class PosComboCard extends StatelessWidget {
  /// The combo to display.
  final Combo combo;

  /// Quantity of this combo in the current cart.
  /// If greater than 0, a badge is shown.
  final int quantityInCart;

  /// Callback when the card is tapped.
  final VoidCallback onTap;

  /// Currency symbol to display.
  final String currencySymbol;

  const PosComboCard({
    super.key,
    required this.combo,
    this.quantityInCart = 0,
    required this.onTap,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.card,
      borderRadius: context.tokens.borderRadiusLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: quantityInCart > 0
                ? Border.all(color: colors.primary, width: 2)
                : Border.all(color: colors.secondary, width: 1),
            borderRadius: context.tokens.borderRadiusLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Expanded(
                child: Stack(
                  children: [
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
                          AgoraIcons.gift,
                          size: 48,
                          color: colors.mutedForeground,
                        ),
                      ),
                    ),
                    // COMBO badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.tokens.spaceXs,
                          vertical: context.tokens.spaceXxs,
                        ),
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          borderRadius: context.tokens.borderRadiusLg,
                        ),
                        child: AppText.label(
                          'COMBO',
                          color: colors.secondaryForeground,
                        ),
                      ),
                    ),
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
                padding: EdgeInsets.all(context.tokens.spaceSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.titleMd(
                      combo.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.tokens.spaceXxs),
                    Row(
                      children: [
                        AppText.body(
                          formatCents(combo.priceCents, symbol: currencySymbol),
                          color: colors.mutedForeground,
                        ),
                        if (quantityInCart > 0) ...[
                          SizedBox(width: context.tokens.spaceXs),
                          AppText.bodySm('x', color: colors.mutedForeground),
                          SizedBox(width: context.tokens.spaceXxs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.tokens.spaceXs,
                              vertical: context.tokens.spaceXxs,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: context.tokens.borderRadiusLg,
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
        horizontal: context.tokens.spaceXs,
        vertical: context.tokens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: context.tokens.borderRadiusLg,
      ),
      child: AppText.label('$quantity', color: colors.primaryForeground),
    );
  }
}
