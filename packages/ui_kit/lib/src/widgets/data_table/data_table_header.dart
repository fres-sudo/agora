import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

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
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
                prefixIcon: const Icon(
                  AgoraIcons.eye,
                  size: 20,
                ), // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.search
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.md,
                  vertical: Sizes.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  borderSide: const BorderSide(color: AppPalette.neutral300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  borderSide: const BorderSide(color: AppPalette.neutral300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  borderSide: const BorderSide(color: AppPalette.primary500),
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
          AppButton.outline(
            onPressed: onFilter,
            label: 'Filter',
            leadingIcon: Badge(
              isLabelVisible: hasActiveFilters,
              smallSize: 8,
              child: const Icon(AgoraIcons.filter, size: 18),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppPalette.neutral700,
              side: const BorderSide(color: AppPalette.neutral300),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.md,
                vertical: Sizes.sm,
              ),
            ),
          ),
          const SizedBox(width: Sizes.sm),
          // Add button
          AppButton.primary(
            onPressed: onAdd,
            label: addButtonLabel,
            leadingIcon: const Icon(AgoraIcons.plus, size: 18),
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.primary500,
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
  const _SortButton({required this.sortOptions, this.currentSort, this.onSort});

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
                  color: isSelected ? AppPalette.primary500 : null,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Icon(
                  currentSort!.direction == SortDirection.ascending
                      ? AgoraIcons.caretUp
                      : AgoraIcons.caretDown,
                  size: 16,
                  color: AppPalette.primary500,
                ),
              ],
            ],
          ),
        );
      }).toList(),
      child: AppButton.outline(
        onPressed: null, // Handled by PopupMenuButton
        label: 'Sort',
        leadingIcon: const Icon(AgoraIcons.sort, size: 18),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.neutral700,
          disabledForegroundColor: AppPalette.neutral700,
          side: const BorderSide(color: AppPalette.neutral300),
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.md,
            vertical: Sizes.sm,
          ),
        ),
      ),
    );
  }
}
