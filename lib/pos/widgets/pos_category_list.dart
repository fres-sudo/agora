import 'package:agora/pos/widgets/menu_category.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // "All Menu" option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: MenuCategoryItem(
              title: allMenuLabel,
              icon: Icons.restaurant_menu,
              isSelected: selectedCategoryId == null,
              onTap: () => onCategorySelected(null),
              size: itemSize,
            ),
          ),
          // Category items
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: MenuCategoryItem(
                title: category.name,
                icon: category.icon ?? Icons.grid_view,
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
