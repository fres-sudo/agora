import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';

/// Pagination widget for the data table.
///
/// Displays rows per page selector and page navigation buttons.
class DataTablePagination extends StatelessWidget {
  const DataTablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.rowsPerPage,
    required this.rowsPerPageOptions,
    this.onPageChanged,
    this.onRowsPerPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final int rowsPerPage;
  final List<int> rowsPerPageOptions;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onRowsPerPageChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.lg,
        vertical: Sizes.md,
      ),
      child: Row(
        children: [
          // Rows per page
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rows per page',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.neutral500,
                    ),
              ),
              const SizedBox(width: Sizes.sm),
              DropdownButton<int>(
                value: rowsPerPage,
                onChanged: (value) {
                  if (value != null) {
                    onRowsPerPageChanged?.call(value);
                  }
                },
                underline: const SizedBox.shrink(),
                isDense: true,
                items: rowsPerPageOptions
                    .map((count) => DropdownMenuItem(
                          value: count,
                          child: Text('$count'),
                        ))
                    .toList(),
              ),
            ],
          ),
          const Spacer(),
          // Page navigation
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Previous button
              IconButton(
                onPressed: currentPage > 0
                    ? () => onPageChanged?.call(currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
              // Page numbers
              ..._buildPageNumbers(context),
              // Next button
              IconButton(
                onPressed: currentPage < totalPages - 1
                    ? () => onPageChanged?.call(currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context) {
    final List<Widget> pageButtons = [];
    const int maxVisiblePages = 5;

    if (totalPages <= maxVisiblePages) {
      // Show all pages
      for (int i = 0; i < totalPages; i++) {
        pageButtons.add(_buildPageButton(context, i));
      }
    } else {
      // Show first page
      pageButtons.add(_buildPageButton(context, 0));

      // Calculate visible range around current page
      int start = (currentPage - 1).clamp(1, totalPages - 4);
      int end = (start + 2).clamp(2, totalPages - 2);

      // Adjust start if end is at the limit
      if (end == totalPages - 2) {
        start = (end - 2).clamp(1, totalPages - 4);
      }

      // Add ellipsis if needed
      if (start > 1) {
        pageButtons.add(_buildEllipsis());
      }

      // Add middle pages
      for (int i = start; i <= end; i++) {
        pageButtons.add(_buildPageButton(context, i));
      }

      // Add ellipsis if needed
      if (end < totalPages - 2) {
        pageButtons.add(_buildEllipsis());
      }

      // Show last page
      pageButtons.add(_buildPageButton(context, totalPages - 1));
    }

    return pageButtons;
  }

  Widget _buildPageButton(BuildContext context, int page) {
    final isSelected = page == currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isSelected ? AppColors.primary500 : Colors.transparent,
        borderRadius: BorderRadius.circular(Sizes.xs),
        child: InkWell(
          onTap: isSelected ? null : () => onPageChanged?.call(page),
          borderRadius: BorderRadius.circular(Sizes.xs),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            child: Text(
              '${page + 1}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected ? Colors.white : AppColors.neutral600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '...',
        style: TextStyle(color: AppColors.neutral400),
      ),
    );
  }
}
