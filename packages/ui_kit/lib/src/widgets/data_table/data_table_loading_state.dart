import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ui_kit/ui_kit.dart';

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
            padding: EdgeInsets.symmetric(
              horizontal: context.tokens.spacing.md,
              vertical: context.tokens.spacing.sm,
            ),
            decoration: BoxDecoration(
              color: context.colors.muted,
              border: Border(bottom: BorderSide(color: context.colors.border)),
            ),
            child: Row(
              children: List.generate(
                columnCount,
                (index) => Expanded(
                  flex: index == 1 ? 2 : 1, // Product name column is wider
                  child: Skeleton.leaf(
                    child: Container(
                      height: 16,
                      margin: EdgeInsets.only(right: context.tokens.spacing.md),
                      decoration: BoxDecoration(
                        color: context.colors.border,
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
              padding: EdgeInsets.symmetric(
                horizontal: context.tokens.spacing.md,
                vertical: context.tokens.spacing.sm,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.colors.border),
                ),
              ),
              child: Row(
                children: List.generate(
                  columnCount,
                  (colIndex) => Expanded(
                    flex: colIndex == 1 ? 2 : 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: context.tokens.spacing.md,
                      ),
                      child: colIndex == 1
                          ? _buildProductCell(context)
                          : Skeleton.leaf(
                              child: Container(
                                height: 14,
                                decoration: BoxDecoration(
                                  color: context.colors.muted,
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

  Widget _buildProductCell(BuildContext context) {
    return Row(
      children: [
        // Image placeholder
        Skeleton.leaf(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.muted,
              borderRadius: BorderRadius.circular(context.tokens.radius.xs),
            ),
          ),
        ),
        SizedBox(width: context.tokens.spacing.xs),
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
                    color: context.colors.muted,
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
                    color: context.colors.muted,
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
