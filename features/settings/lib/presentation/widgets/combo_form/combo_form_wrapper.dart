import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/combo.dart';
import 'package:feature_settings/presentation/widgets/combo_form/combo_form.dart';
import 'package:flutter/material.dart';

/// Shows the [ComboForm] responsively — a bottom sheet on mobile, a
/// centered dialog on tablet/desktop — mirroring [ModifierFormWrapper].
class ComboFormWrapper {
  const ComboFormWrapper._();

  static Future<Combo?> showCreate(BuildContext context) {
    return _show(context, initialCombo: null);
  }

  static Future<Combo?> showEdit(BuildContext context, Combo combo) {
    return _show(context, initialCombo: combo);
  }

  static Future<Combo?> _show(
    BuildContext context, {
    Combo? initialCombo,
  }) async {
    if (context.isMobile) {
      return showModalBottomSheet<Combo?>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => ComboForm(initialCombo: initialCombo),
      );
    } else {
      return showDialog<Combo?>(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.tokens.borderRadiusLg,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560, maxHeight: 760),
            child: ComboForm(initialCombo: initialCombo),
          ),
        ),
      );
    }
  }
}
