import 'package:flutter/material.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/i18n/strings.g.dart';

class TopProductsList extends StatelessWidget {
  final List<TopProductData> products;

  const TopProductsList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 300;
        final isVeryCompact = constraints.maxWidth < 240;

        return Container(
          padding: EdgeInsets.all(isCompact ? Sizes.md : Sizes.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.md),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.report.top_10_product,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                      fontSize: isCompact ? 16 : null,
                    ),
              ),
              SizedBox(height: isCompact ? Sizes.md : Sizes.xl),
              // Table header
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: isCompact ? Sizes.xs : Sizes.sm),
                child: Row(
                  children: [
                    SizedBox(width: isVeryCompact ? 50 : 80), // For Rank and Image
                    Expanded(
                      child: Text(
                        'PRODUCT',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.neutral500,
                              fontWeight: FontWeight.w600,
                              fontSize: isCompact ? 10 : null,
                            ),
                      ),
                    ),
                    Text(
                      'SALES',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.neutral500,
                            fontWeight: FontWeight.w600,
                            fontSize: isCompact ? 10 : null,
                          ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.neutral200),
              Expanded(
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: AppColors.neutral200,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isCompact ? Sizes.sm : Sizes.md,
                      ),
                      child: Row(
                        children: [
                          _buildRankBadge(index + 1, isVeryCompact),
                          SizedBox(width: isVeryCompact ? Sizes.xs : Sizes.md),
                          if (!isVeryCompact) ...[
                            _buildProductImage(product.imageUrl),
                            const SizedBox(width: Sizes.md),
                          ],
                          Expanded(
                            child: Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.neutral900,
                                fontSize: isCompact ? 12 : 14,
                              ),
                              maxLines: isVeryCompact ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: Sizes.xs),
                          Text(
                            product.sales.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                              fontSize: isCompact ? 12 : 14,
                            ),
                          ),
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

  Widget _buildRankBadge(int rank, bool isCompact) {
    Color color;
    switch (rank) {
      case 1:
        color = const Color(0xff34CB6F);
        break;
      case 2:
        color = const Color(0xffFFAB00);
        break;
      case 3:
        color = const Color(0xff1D90FB);
        break;
      default:
        color = AppColors.neutral300;
    }

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
            Icon(Icons.emoji_events, size: isCompact ? 10 : 12, color: color),
            SizedBox(width: isCompact ? 1 : 2),
            Text(
              rank.toString(),
              style: TextStyle(
                color: color,
                fontSize: isCompact ? 10 : 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(Sizes.xs),
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.xs),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            )
          : const Icon(Icons.fastfood, color: AppColors.neutral400, size: 20),
    );
  }
}

class TopProductData {
  final String name;
  final int sales;
  final String? imageUrl;

  TopProductData({
    required this.name,
    required this.sales,
    this.imageUrl,
  });
}
