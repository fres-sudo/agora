import 'package:agora/core/ui/device.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:agora/settings/widgets/category_form/category_form.dart';
import 'package:flutter/material.dart';

class CategoryFormWrapper {
  const CategoryFormWrapper._();

  static Future<Category?> showCreate(BuildContext context) {
    return _show(context, initialCategory: null);
  }

  static Future<Category?> showEdit(
    BuildContext context,
    Category category,
  ) {
    return _show(context, initialCategory: category);
  }

  static Future<Category?> _show(
    BuildContext context, {
    Category? initialCategory,
  }) async {
    if (context.isMobile) {
      return showModalBottomSheet<Category?>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => CategoryForm(
          initialCategory: initialCategory,
        ),
      );
    } else {
      return showDialog<Category?>(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 700,
            ),
            child: CategoryForm(
              initialCategory: initialCategory,
            ),
          ),
        ),
      );
    }
  }
}
