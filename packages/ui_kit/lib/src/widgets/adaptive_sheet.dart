import 'package:flutter/widgets.dart';
import 'package:ui_kit/ui_kit.dart';

/// Signature for building adaptive sheet content.
@Deprecated('Use AdaptiveModalBuilder from adaptive_modal.dart instead.')
typedef AdaptiveSheetBuilder = AdaptiveModalBuilder;

/// Bottom sheet on mobile, right side sheet on tablet/desktop.
@Deprecated(
  'Use AdaptiveModal.show(style: AdaptiveModalStyle.sideSheet) instead. '
  'AdaptiveModal is the single modal entry point and also supports dialogs.',
)
class AdaptiveSheet {
  const AdaptiveSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required AdaptiveModalBuilder builder,
    bool barrierDismissible = true,
    double sideSheetWidth = 480,
  }) {
    return AdaptiveModal.show<T>(
      context: context,
      builder: builder,
      style: AdaptiveModalStyle.sideSheet,
      barrierDismissible: barrierDismissible,
      sideSheetWidth: sideSheetWidth,
    );
  }
}
