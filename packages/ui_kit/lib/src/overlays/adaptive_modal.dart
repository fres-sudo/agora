import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// How an [AdaptiveModal] presents itself on tablet/desktop. Phones always get
/// a bottom sheet regardless of this setting.
enum AdaptiveModalStyle {
  /// A centred, width-constrained dialog. The default, and the right choice
  /// for short forms and confirmations.
  dialog,

  /// A full-height panel anchored to the right edge. Suits long forms with
  /// many fields where the surrounding page is useful context.
  sideSheet,
}

/// How the modal is currently being presented. Published to the subtree so
/// [AppSheetScaffold] can adapt its chrome (grabber vs close button, sticky
/// footer vs inline actions) without its callers passing the mode down.
enum AdaptiveModalPresentation { bottomSheet, dialog, sideSheet }

/// Signature for building adaptive modal content. [scrollController] is
/// supplied only for the bottom-sheet presentation; attach it to the content's
/// primary scrollable so drag-to-dismiss and drag-to-expand work.
typedef AdaptiveModalBuilder =
    Widget Function(BuildContext context, ScrollController? scrollController);

/// Inherited marker describing the enclosing modal.
class AdaptiveModalScope extends InheritedWidget {
  const AdaptiveModalScope({
    super.key,
    required this.presentation,
    required super.child,
  });

  final AdaptiveModalPresentation presentation;

  static AdaptiveModalPresentation? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AdaptiveModalScope>()
      ?.presentation;

  @override
  bool updateShouldNotify(AdaptiveModalScope oldWidget) =>
      presentation != oldWidget.presentation;
}

/// The single entry point for modal content in this app.
///
/// On a phone the content is presented as an iOS-style draggable bottom sheet
/// (grabber, rounded top, snaps between [initialSize] and full height). On
/// tablet and desktop it becomes a dialog or a right-hand side sheet depending
/// on [style].
///
/// Pair it with [AppSheetScaffold] for the title/close/footer chrome:
///
/// ```dart
/// AdaptiveModal.show<Category?>(
///   context: context,
///   style: AdaptiveModalStyle.dialog,
///   builder: (ctx, scrollController) => AppSheetScaffold(
///     title: 'New category',
///     scrollController: scrollController,
///     body: const CategoryFormFields(),
///     actions: [AppButton.primary(onPressed: save, label: 'Save')],
///   ),
/// );
/// ```
class AdaptiveModal {
  const AdaptiveModal._();

  static Future<T?> show<T>({
    required BuildContext context,
    required AdaptiveModalBuilder builder,
    AdaptiveModalStyle style = AdaptiveModalStyle.dialog,
    bool barrierDismissible = true,
    double maxWidth = 560,
    double sideSheetWidth = 480,

    /// Fraction of the screen the phone sheet occupies when it opens.
    double initialSize = 0.92,

    /// Smallest fraction the phone sheet can be dragged to before it closes.
    double minSize = 0.4,
  }) {
    if (context.isMobile) {
      return _showBottomSheet<T>(
        context: context,
        builder: builder,
        isDismissible: barrierDismissible,
        initialSize: initialSize,
        minSize: minSize,
      );
    }
    return switch (style) {
      AdaptiveModalStyle.dialog => _showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible,
        maxWidth: maxWidth,
      ),
      AdaptiveModalStyle.sideSheet => _showSideSheet<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible,
        width: sideSheetWidth,
      ),
    };
  }

  static Future<T?> _showBottomSheet<T>({
    required BuildContext context,
    required AdaptiveModalBuilder builder,
    required bool isDismissible,
    required double initialSize,
    required double minSize,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AdaptiveModalScope(
        presentation: AdaptiveModalPresentation.bottomSheet,
        child: _BottomSheetSurface(
          builder: builder,
          initialSize: initialSize,
          minSize: minSize,
        ),
      ),
    );
  }

  static Future<T?> _showDialog<T>({
    required BuildContext context,
    required AdaptiveModalBuilder builder,
    required bool barrierDismissible,
    required double maxWidth,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => AdaptiveModalScope(
        presentation: AdaptiveModalPresentation.dialog,
        child: Dialog(
          backgroundColor: ctx.colors.popover,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: ctx.tokens.radius.borderLg,
            side: BorderSide(
              color: ctx.colors.border,
              width: ctx.tokens.border.hairline,
            ),
          ),
          child: ConstrainedBox(
            // Height is bounded so a long form scrolls inside the dialog
            // rather than overflowing off-screen.
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.85,
            ),
            child: builder(ctx, null),
          ),
        ),
      ),
    );
  }

  static Future<T?> _showSideSheet<T>({
    required BuildContext context,
    required AdaptiveModalBuilder builder,
    required bool barrierDismissible,
    required double width,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
      pageBuilder: (ctx, _, _) => AdaptiveModalScope(
        presentation: AdaptiveModalPresentation.sideSheet,
        child: Align(
          alignment: Alignment.centerRight,
          child: _SideSheetSurface(width: width, builder: builder),
        ),
      ),
    );
  }
}

/// Draggable phone sheet surface. Snaps between [initialSize] and full height
/// so a drag upward commits to the expanded state instead of settling
/// mid-flight.
class _BottomSheetSurface extends StatelessWidget {
  const _BottomSheetSurface({
    required this.builder,
    required this.initialSize,
    required this.minSize,
  });

  final AdaptiveModalBuilder builder;
  final double initialSize;
  final double minSize;

  @override
  Widget build(BuildContext context) {
    const maxSize = 0.96;
    final snapSizes = <double>{
      if (initialSize > minSize && initialSize < maxSize) initialSize,
    }.toList();

    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: minSize,
      maxChildSize: maxSize,
      expand: false,
      snap: true,
      snapSizes: snapSizes,
      builder: (ctx, scrollController) => DecoratedBox(
        decoration: BoxDecoration(
          color: ctx.colors.popover,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(
            color: ctx.colors.border,
            width: ctx.tokens.border.hairline,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: builder(ctx, scrollController),
        ),
      ),
    );
  }
}

class _SideSheetSurface extends StatelessWidget {
  const _SideSheetSurface({required this.width, required this.builder});

  final double width;
  final AdaptiveModalBuilder builder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      child: DecoratedBox(
        // Depth reads as a crisp hard-edged offset, not a soft Material blur.
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 0,
              offset: const Offset(-4, 0),
            ),
          ],
        ),
        child: Material(
          elevation: 0,
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(6)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: width,
            height: double.infinity,
            child: builder(context, null),
          ),
        ),
      ),
    );
  }
}
