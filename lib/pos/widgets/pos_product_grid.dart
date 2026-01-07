import 'package:agora/pos/widgets/pos_empty_state.dart';
import 'package:agora/pos/widgets/pos_product_card.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:flutter/material.dart';

/// A responsive grid of product cards for the POS view.
/// Automatically adjusts column count based on available width.
class PosProductGrid extends StatelessWidget {
  /// List of products to display.
  final List<Product> products;

  /// Map of productId to quantity in cart.
  final Map<int, int> cartQuantities;

  /// Callback when a product is tapped.
  final ValueChanged<Product> onProductTap;

  /// Empty state title text.
  final String emptyTitle;

  /// Empty state description text.
  final String? emptyDescription;

  /// Empty state action label.
  final String? emptyActionLabel;

  /// Empty state action callback.
  final VoidCallback? onEmptyAction;

  const PosProductGrid({
    super.key,
    required this.products,
    required this.cartQuantities,
    required this.onProductTap,
    this.emptyTitle = 'No Product Found',
    this.emptyDescription,
    this.emptyActionLabel,
    this.onEmptyAction,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return PosEmptyState(
        icon: Icons.inventory_2_outlined,
        title: emptyTitle,
        description: emptyDescription,
        actionLabel: emptyActionLabel,
        onAction: onEmptyAction,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on available width
        // Aim for cards around 150-180px wide
        final minCardWidth = 150.0;
        final crossAxisCount = (constraints.maxWidth / minCardWidth).floor().clamp(2, 6);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Slightly taller than wide
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final quantity = cartQuantities[product.id] ?? 0;

            return PosProductCard(
              product: product,
              quantityInCart: quantity,
              onTap: () => onProductTap(product),
            );
          },
        );
      },
    );
  }
}
