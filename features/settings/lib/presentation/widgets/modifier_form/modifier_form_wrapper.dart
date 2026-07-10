import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/modifier_group.dart';
import 'package:feature_settings/presentation/widgets/modifier_form/modifier_form.dart';
import 'package:flutter/material.dart';

/// Shows the [ModifierForm] responsively — a bottom sheet on mobile, a
/// centered dialog on tablet/desktop — mirroring [CategoryFormWrapper].
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
  }) async {
    if (context.isMobile) {
      return showModalBottomSheet<ModifierGroup?>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => ModifierForm(initialGroup: initialGroup),
      );
    } else {
      return showDialog<ModifierGroup?>(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560, maxHeight: 760),
            child: ModifierForm(initialGroup: initialGroup),
          ),
        ),
      );
    }
  }
}
