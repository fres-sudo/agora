import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/product.dart';
import 'package:database/database.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:flutter/material.dart';

import 'package:ui_kit/ui_kit.dart';

/// A responsive grid of product/combo cards for the POS view.
/// Automatically adjusts column count based on available width.
class PosProductGrid extends StatelessWidget {
  /// List of products/combos to display, in order.
  final List<PosMenuEntry> entries;

  /// Map of productId to quantity in cart.
  final Map<int, int> productQuantities;

  /// Map of comboId to quantity in cart.
  final Map<int, int> comboQuantities;

  /// Callback when a product tile is tapped.
  final ValueChanged<Product> onProductTap;

  /// Callback when a combo tile is tapped.
  final ValueChanged<Combo> onComboTap;

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
    required this.entries,
    required this.productQuantities,
    required this.comboQuantities,
    required this.onProductTap,
    required this.onComboTap,
    this.emptyTitle = 'No Product Found',
    this.emptyDescription,
    this.emptyActionLabel,
    this.onEmptyAction,
  });

  @override
  Widget build(BuildContext context) {
    final currencySymbol =
        context.watch<SettingsCubit>().getString(SettingsKeys.currencySymbol) ??
        '€';

    if (entries.isEmpty) {
      return PosEmptyState(
        icon: AgoraIcons.package,
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
        final crossAxisCount = (constraints.maxWidth / minCardWidth)
            .floor()
            .clamp(2, 6);

        return GridView.builder(
          padding: EdgeInsets.all(context.tokens.spaceMd),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Slightly taller than wide
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return switch (entry) {
              PosMenuProductEntry(:final product) => PosProductCard(
                product: product,
                quantityInCart: productQuantities[product.id] ?? 0,
                onTap: () => onProductTap(product),
                currencySymbol: currencySymbol,
              ),
              PosMenuComboEntry(:final combo) => PosComboCard(
                combo: combo,
                quantityInCart: comboQuantities[combo.id] ?? 0,
                onTap: () => onComboTap(combo),
                currencySymbol: currencySymbol,
              ),
            };
          },
        );
      },
    );
  }
}
