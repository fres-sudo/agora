import 'package:feature_discounts/domain/models/discount.dart';
import 'package:feature_settings/presentation/widgets/discount_form/discount_form.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Presents [DiscountForm] as a bottom sheet on mobile / dialog on desktop.
/// Mirrors [CategoryFormWrapper].
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
    if (context.isMobile) {
      return showModalBottomSheet<Discount?>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => DiscountForm(initialDiscount: initialDiscount),
      );
    }
    return showDialog<Discount?>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 760),
          child: DiscountForm(initialDiscount: initialDiscount),
        ),
      ),
    );
  }
}
