import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Signature for building adaptive sheet content.
/// [scrollController] is provided only when displayed as a bottom sheet;
/// connect it to inner scrollable widgets to enable proper dragging.
typedef AdaptiveSheetBuilder =
    Widget Function(BuildContext context, ScrollController? scrollController);

/// Shows content as a bottom sheet on mobile and a right side sheet on
/// tablet/desktop, with a slide-in animation.
class AdaptiveSheet {
  const AdaptiveSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required AdaptiveSheetBuilder builder,
    bool barrierDismissible = true,
    double sideSheetWidth = 480,
  }) {
    if (context.isMobile) {
      return _showBottomSheet<T>(
        context: context,
        builder: builder,
        isDismissible: barrierDismissible,
      );
    }
    return _showSideSheet<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      width: sideSheetWidth,
    );
  }

  static Future<T?> _showBottomSheet<T>({
    required BuildContext context,
    required AdaptiveSheetBuilder builder,
    required bool isDismissible,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AdaptiveBottomSheet(builder: builder),
    );
  }

  static Future<T?> _showSideSheet<T>({
    required BuildContext context,
    required AdaptiveSheetBuilder builder,
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
      pageBuilder: (ctx, _, _) => Align(
        alignment: Alignment.centerRight,
        child: _AdaptiveSideSheet(width: width, builder: builder),
      ),
    );
  }
}

class _AdaptiveBottomSheet extends StatelessWidget {
  const _AdaptiveBottomSheet({required this.builder});

  final AdaptiveSheetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) => builder(ctx, scrollController),
      ),
    );
  }
}

class _AdaptiveSideSheet extends StatelessWidget {
  const _AdaptiveSideSheet({required this.width, required this.builder});

  final double width;
  final AdaptiveSheetBuilder builder;

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
