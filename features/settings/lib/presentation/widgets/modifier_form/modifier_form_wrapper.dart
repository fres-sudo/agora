import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/modifier_group.dart';
import 'package:feature_settings/presentation/widgets/modifier_form/modifier_form.dart';
import 'package:flutter/material.dart';

/// Presents [ModifierForm] as a draggable sheet on a phone and a dialog on
/// tablet/desktop, mirroring [CategoryFormWrapper].
class ModifierFormWrapper {
  const ModifierFormWrapper._();

  static Future<ModifierGroup?> showCreate(BuildContext context) {
    return _show(context, initialGroup: null);
  }

  static Future<ModifierGroup?> showEdit(
    BuildContext context,
    ModifierGroup modifierGroup,
  ) {
    return _show(context, initialGroup: modifierGroup);
  }

  static Future<ModifierGroup?> _show(
    BuildContext context, {
    ModifierGroup? initialGroup,
  }) {
    return AdaptiveModal.show<ModifierGroup?>(
      context: context,
      maxWidth: 560,
      builder: (context, scrollController) => ModifierForm(
        initialGroup: initialGroup,
        scrollController: scrollController,
      ),
    );
  }
}
