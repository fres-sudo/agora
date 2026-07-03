import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

/// A table cell widget displaying product image, name, and description.
class ProductNameCell extends StatelessWidget {
  const ProductNameCell({
    required this.name,
    this.description,
    this.imageUrl,
    super.key,
  });

  final String name;
  final String? description;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Product Image
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppPalette.neutral100,
            borderRadius: BorderRadius.circular(Sizes.xs),
            image: imageUrl != null && imageUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                    onError:
                        (exception, stackTrace) {}, // Fallback handled by color
                  )
                : null,
          ),
          child: imageUrl == null || imageUrl!.isEmpty
              ? Icon(
                  Icons.image_outlined,
                  size: 20,
                  color: AppPalette.neutral400,
                )
              : null,
        ),
        const SizedBox(width: Sizes.md),

        // Name and Description
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMd(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (description != null && description!.isNotEmpty) ...[
                const SizedBox(height: 2),
                AppText.bodySm(
                  description!,
                  color: context.colors.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
