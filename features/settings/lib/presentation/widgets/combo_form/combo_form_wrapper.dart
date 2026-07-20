import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/combo.dart';
import 'package:feature_settings/presentation/widgets/combo_form/combo_form.dart';
import 'package:flutter/material.dart';

/// Presents [ComboForm] as a draggable sheet on a phone and a dialog on
/// tablet/desktop, mirroring [ModifierFormWrapper].
class ComboFormWrapper {
  const ComboFormWrapper._();

  static Future<Combo?> showCreate(BuildContext context) {
    return _show(context, initialCombo: null);
  }

  static Future<Combo?> showEdit(BuildContext context, Combo combo) {
    return _show(context, initialCombo: combo);
  }

  static Future<Combo?> _show(BuildContext context, {Combo? initialCombo}) {
    return AdaptiveModal.show<Combo?>(
      context: context,
      maxWidth: 560,
      builder: (context, scrollController) => ComboForm(
        initialCombo: initialCombo,
        scrollController: scrollController,
      ),
    );
  }
}
