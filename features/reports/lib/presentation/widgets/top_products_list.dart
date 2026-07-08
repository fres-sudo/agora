import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:i18n/i18n.dart';

class TopProductsList extends StatelessWidget {
  final List<TopProductData> products;

  const TopProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 300;
        final isVeryCompact = constraints.maxWidth < 240;

        final colors = context.colors;
        return Container(
          padding: EdgeInsets.all(isCompact ? Sizes.md : Sizes.lg),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(Sizes.md),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.headingSm(t.report.top_10_product),
              SizedBox(height: isCompact ? Sizes.md : Sizes.xl),
              // Table header
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isCompact ? Sizes.xs : Sizes.sm,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: isVeryCompact ? 50 : 80,
                    ), // For Rank and Image
                    Expanded(
                      child: AppText.caption(
                        'PRODUCT',
                        color: colors.mutedForeground,
                      ),
                    ),
                    AppText.caption('SALES', color: colors.mutedForeground),
                  ],
                ),
              ),
              const Divider(color: AppPalette.neutral200),
              Expanded(
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: AppPalette.neutral200, height: 1),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isCompact ? Sizes.sm : Sizes.md,
                      ),
                      child: Row(
                        children: [
                          _buildRankBadge(context, index + 1, isVeryCompact),
                          SizedBox(width: isVeryCompact ? Sizes.xs : Sizes.md),
                          if (!isVeryCompact) ...[
                            AppSourcedImage(
                              source: product.imageUrl,
                              size: 40,
                              borderRadius: BorderRadius.circular(Sizes.xs),
                              placeholderIcon: AgoraIcons.burger,
                            ),
                            const SizedBox(width: Sizes.md),
                          ],
                          Expanded(
                            child: AppText.body(
                              product.name,
                              maxLines: isVeryCompact ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: Sizes.xs),
                          AppText.titleMd(product.sales.toString()),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRankBadge(BuildContext context, int rank, bool isCompact) {
    final colors = context.colors;
    final Color color = switch (rank) {
      1 => colors.primary,
      2 => colors.warning,
      3 => colors.info,
      _ => AppPalette.neutral300,
    };

    final width = isCompact ? 26.0 : 32.0;
    final height = isCompact ? 20.0 : 24.0;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AgoraIcons.trophy, size: isCompact ? 10 : 12, color: color),
            SizedBox(width: isCompact ? 1 : 2),
            AppText.caption(rank.toString(), color: color),
          ],
        ),
      ),
    );
  }
}

class TopProductData {
  final String name;
  final int sales;
  final String? imageUrl;

  TopProductData({required this.name, required this.sales, this.imageUrl});
}
