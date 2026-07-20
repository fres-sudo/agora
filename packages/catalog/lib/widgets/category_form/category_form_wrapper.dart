import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/category.dart';
import 'package:catalog/widgets/category_form/category_form.dart';
import 'package:flutter/material.dart';

/// Presents [CategoryForm] as a draggable sheet on a phone and a dialog on
/// tablet/desktop. See [AdaptiveModal].
class CategoryFormWrapper {
  const CategoryFormWrapper._();

  static Future<Category?> showCreate(BuildContext context) {
    return _show(context, initialCategory: null);
  }

  static Future<Category?> showEdit(BuildContext context, Category category) {
    return _show(context, initialCategory: category);
  }

  static Future<Category?> _show(
    BuildContext context, {
    Category? initialCategory,
  }) {
    return AdaptiveModal.show<Category?>(
      context: context,
      maxWidth: 500,
      builder: (context, scrollController) => CategoryForm(
        initialCategory: initialCategory,
        scrollController: scrollController,
      ),
    );
  }
}
