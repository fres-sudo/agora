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
        AppSourcedImage(
          source: imageUrl,
          size: 40,
          borderRadius: BorderRadius.circular(Sizes.xs),
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
                SizedBox(height: context.tokens.spaceXxs),
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
