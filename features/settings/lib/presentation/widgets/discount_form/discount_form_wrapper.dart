import 'package:discounts/models/discount.dart';
import 'package:feature_settings/presentation/widgets/discount_form/discount_form.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Presents [DiscountForm] as a draggable sheet on a phone and a dialog on
/// tablet/desktop, mirroring [CategoryFormWrapper].
class DiscountFormWrapper {
  const DiscountFormWrapper._();

  static Future<Discount?> showCreate(BuildContext context) =>
      _show(context, initialDiscount: null);

  static Future<Discount?> showEdit(BuildContext context, Discount discount) =>
      _show(context, initialDiscount: discount);

  static Future<Discount?> _show(
    BuildContext context, {
    Discount? initialDiscount,
  }) {
    return AdaptiveModal.show<Discount?>(
      context: context,
      maxWidth: 500,
      builder: (context, scrollController) => DiscountForm(
        initialDiscount: initialDiscount,
        scrollController: scrollController,
      ),
    );
  }
}
