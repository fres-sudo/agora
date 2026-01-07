import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_config.dart';

/// Header widget for the data table view.
///
/// Contains the title, search field, sort button, filter button, and add button.
class DataTableHeader extends StatelessWidget {
  const DataTableHeader({
    super.key,
    required this.title,
    required this.searchHint,
    required this.addButtonLabel,
    required this.sortOptions,
    this.currentSort,
    this.searchController,
    this.hasActiveFilters = false,
    this.onSearch,
    this.onSort,
    this.onFilter,
    this.onAdd,
  });

  final String title;
  final String searchHint;
  final String addButtonLabel;
  final List<SortOption> sortOptions;
  final SortOption? currentSort;
  final TextEditingController? searchController;
  final bool hasActiveFilters;
  final ValueChanged<String>? onSearch;
  final ValueChanged<SortOption>? onSort;
  final VoidCallback? onFilter;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Row(
        children: [
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          // Search field
          SizedBox(
            width: 240,
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: searchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.md,
                  vertical: Sizes.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  borderSide: const BorderSide(color: AppColors.neutral300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  borderSide: const BorderSide(color: AppColors.neutral300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  borderSide: const BorderSide(color: AppColors.primary500),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: Sizes.sm),
          // Sort button
          if (sortOptions.isNotEmpty) ...[
            _SortButton(
              sortOptions: sortOptions,
              currentSort: currentSort,
              onSort: onSort,
            ),
            const SizedBox(width: Sizes.sm),
          ],
          // Filter button
          OutlinedButton.icon(
            onPressed: onFilter,
            icon: Badge(
              isLabelVisible: hasActiveFilters,
              smallSize: 8,
              child: const Icon(Icons.filter_list_rounded, size: 18),
            ),
            label: const Text('Filter'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.neutral700,
              side: const BorderSide(color: AppColors.neutral300),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.md,
                vertical: Sizes.sm,
              ),
            ),
          ),
          const SizedBox(width: Sizes.sm),
          // Add button
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: Text(addButtonLabel),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.md,
                vertical: Sizes.sm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.sortOptions,
    this.currentSort,
    this.onSort,
  });

  final List<SortOption> sortOptions;
  final SortOption? currentSort;
  final ValueChanged<SortOption>? onSort;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      onSelected: onSort,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      itemBuilder: (context) => sortOptions.map((option) {
        final isSelected = currentSort?.id == option.id;
        return PopupMenuItem<SortOption>(
          value: option,
          child: Row(
            children: [
              Text(
                option.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary500 : null,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Icon(
                  currentSort!.direction == SortDirection.ascending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: AppColors.primary500,
                ),
              ],
            ],
          ),
        );
      }).toList(),
      child: OutlinedButton.icon(
        onPressed: null, // Handled by PopupMenuButton
        icon: const Icon(Icons.sort_rounded, size: 18),
        label: const Text('Sort'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neutral700,
          disabledForegroundColor: AppColors.neutral700,
          side: const BorderSide(color: AppColors.neutral300),
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.md,
            vertical: Sizes.sm,
          ),
        ),
      ),
    );
  }
}
