import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';

/// Loading state widget that shows skeleton placeholders for the data table.
class DataTableLoadingState extends StatelessWidget {
  const DataTableLoadingState({
    super.key,
    this.rowCount = 8,
    this.columnCount = 6,
  });

  final int rowCount;
  final int columnCount;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          // Column headers
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.lg,
              vertical: Sizes.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              border: Border(
                bottom: BorderSide(color: AppColors.neutral200),
              ),
            ),
            child: Row(
              children: List.generate(
                columnCount,
                (index) => Expanded(
                  flex: index == 1 ? 2 : 1, // Product name column is wider
                  child: Skeleton.leaf(
                    child: Container(
                      height: 16,
                      margin: const EdgeInsets.only(right: Sizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.neutral300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Data rows
          ...List.generate(
            rowCount,
            (rowIndex) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.lg,
                vertical: Sizes.md,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.neutral200),
                ),
              ),
              child: Row(
                children: List.generate(
                  columnCount,
                  (colIndex) => Expanded(
                    flex: colIndex == 1 ? 2 : 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: Sizes.lg),
                      child: colIndex == 1
                          ? _buildProductCell()
                          : Skeleton.leaf(
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.neutral200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCell() {
    return Row(
      children: [
        // Image placeholder
        Skeleton.leaf(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
            ),
          ),
        ),
        const SizedBox(width: Sizes.sm),
        // Text placeholders
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton.leaf(
                child: Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Skeleton.leaf(
                child: Container(
                  height: 12,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
