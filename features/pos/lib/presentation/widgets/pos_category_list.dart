import 'package:feature_pos/feature_pos.dart';
import 'package:catalog/models/category.dart';
import 'package:flutter/material.dart';

import 'package:ui_kit/ui_kit.dart';

/// A vertical list of category items for the POS sidebar.
/// Includes an "All Menu" option at the top.
class PosCategoryList extends StatelessWidget {
  /// List of categories to display.
  final List<Category> categories;

  /// Currently selected category ID. Null means "All Menu".
  final int? selectedCategoryId;

  /// Callback when a category is selected.
  final ValueChanged<int?> onCategorySelected;

  /// Size of each category item. Defaults to 100.
  final double itemSize;

  /// "All Menu" label text.
  final String allMenuLabel;

  const PosCategoryList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.itemSize = 100,
    this.allMenuLabel = 'All Menu',
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: context.tokens.spaceXs),
      child: Column(
        children: [
          // "All Menu" option
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.tokens.spaceXs,
              vertical: context.tokens.spaceXxs,
            ),
            child: MenuCategoryItem(
              title: allMenuLabel,
              icon: AgoraIcons.restaurant,
              isSelected: selectedCategoryId == null,
              onTap: () => onCategorySelected(null),
              size: itemSize,
            ),
          ),
          // Category items
          ...categories.map(
            (category) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.tokens.spaceXs,
                vertical: context.tokens.spaceXxs,
              ),
              child: MenuCategoryItem(
                title: category.name,
                icon: category.icon ?? AgoraIcons.categories,
                isSelected: selectedCategoryId == category.id,
                onTap: () => onCategorySelected(category.id),
                size: itemSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
