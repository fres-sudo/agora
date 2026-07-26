import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Builds the sheet's expanded content. [scrollController] must be attached to
/// the content's outermost scrollable — [AppPersistentSheet] does this for you
/// unless you opt out — otherwise the sheet cannot be dragged.
typedef PersistentSheetBuilder =
    Widget Function(BuildContext context, ScrollController scrollController);

/// A bottom sheet that is always on screen and never blocks the page.
///
/// Unlike a modal sheet, it snaps between a short *peek* (a summary bar with a
/// call to action) and a near-full-height *expanded* state, and the page
/// underneath stays scrollable and tappable in both. Built for the phone POS,
/// where the cart has to stay visible while the operator keeps tapping
/// products — a modal cart would force a close/reopen per item.
///
/// ```dart
/// AppPersistentSheet(
///   body: const ProductList(),
///   peekHeight: 88,
///   peekBuilder: (context, controller) => CartSummaryBar(
///     onCheckout: controller.expand,
///   ),
///   expandedBuilder: (context, _) => const CartPanel(),
/// )
/// ```
class AppPersistentSheet extends StatefulWidget {
  const AppPersistentSheet({
    super.key,
    required this.body,
    required this.peekBuilder,
    required this.expandedBuilder,
    this.peekHeight = 88,
    this.maxSize = 0.92,
    this.isVisible = true,
    this.controller,
  });

  /// The page content. Automatically bottom-padded by [peekHeight] so nothing
  /// ends up trapped behind the peek bar.
  final Widget body;

  /// The collapsed summary bar. Gets a controller so its buttons can expand
  /// the sheet.
  final Widget Function(
    BuildContext context,
    PersistentSheetController controller,
  )
  peekBuilder;

  /// The full content, revealed as the sheet is dragged up.
  final PersistentSheetBuilder expandedBuilder;

  /// Height of the collapsed bar in logical pixels, excluding safe area.
  final double peekHeight;

  /// Fraction of the available height the expanded sheet occupies.
  final double maxSize;

  /// When false the sheet is removed entirely and [body] gets the full screen
  /// — e.g. an empty cart.
  final bool isVisible;

  final PersistentSheetController? controller;

  @override
  State<AppPersistentSheet> createState() => _AppPersistentSheetState();
}

/// Imperative handle for expanding and collapsing an [AppPersistentSheet].
class PersistentSheetController {
  _AppPersistentSheetState? _state;

  void _attach(_AppPersistentSheetState state) => _state = state;
  void _detach(_AppPersistentSheetState state) {
    if (_state == state) _state = null;
  }

  /// Animates the sheet to full height.
  void expand() => _state?.expand();

  /// Animates the sheet back down to the peek bar.
  void collapse() => _state?.collapse();

  bool get isExpanded => _state?.isExpanded ?? false;
}

class _AppPersistentSheetState extends State<AppPersistentSheet> {
  final _draggableController = DraggableScrollableController();
  late PersistentSheetController _controller;

  /// 0 = fully collapsed, 1 = fully expanded. Drives the peek bar's fade.
  final _progress = ValueNotifier<double>(0);

  double _minSize = 0.1;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PersistentSheetController();
    _controller._attach(this);
  }

  @override
  void didUpdateWidget(AppPersistentSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._detach(this);
      _controller = widget.controller ?? PersistentSheetController();
      _controller._attach(this);
    }
  }

  @override
  void dispose() {
    _controller._detach(this);
    _draggableController.dispose();
    _progress.dispose();
    super.dispose();
  }

  bool get isExpanded =>
      _draggableController.isAttached &&
      _draggableController.size > (_minSize + widget.maxSize) / 2;

  void expand() => _animateTo(widget.maxSize);

  void collapse() => _animateTo(_minSize);

  void _animateTo(double size) {
    if (!_draggableController.isAttached) return;
    _draggableController.animateTo(
      size,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _toggle() => isExpanded ? collapse() : expand();

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return widget.body;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxHeight;
        // The peek bar sits above the home indicator, so the collapsed extent
        // has to account for the bottom inset too.
        final bottomInset = MediaQuery.paddingOf(context).bottom;
        final peekExtent = widget.peekHeight + bottomInset;
        _minSize = available <= 0
            ? 0.1
            : (peekExtent / available).clamp(0.05, widget.maxSize);
        final expandedHeight = available * widget.maxSize;

        return Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: peekExtent),
                child: widget.body,
              ),
            ),
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                final span = widget.maxSize - _minSize;
                _progress.value = span <= 0
                    ? 0
                    : ((notification.extent - _minSize) / span).clamp(0.0, 1.0);
                return false;
              },
              child: DraggableScrollableSheet(
                controller: _draggableController,
                initialChildSize: _minSize,
                minChildSize: _minSize,
                maxChildSize: widget.maxSize,
                expand: true,
                snap: true,
                builder: (context, scrollController) => _SheetSurface(
                  progress: _progress,
                  expandedHeight: expandedHeight,
                  scrollController: scrollController,
                  onGrabberTap: _toggle,
                  peek: widget.peekBuilder(context, _controller),
                  expanded: widget.expandedBuilder(context, scrollController),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SheetSurface extends StatelessWidget {
  const _SheetSurface({
    required this.progress,
    required this.expandedHeight,
    required this.scrollController,
    required this.onGrabberTap,
    required this.peek,
    required this.expanded,
  });

  final ValueListenable<double> progress;
  final double expandedHeight;
  final ScrollController scrollController;
  final VoidCallback onGrabberTap;
  final Widget peek;
  final Widget expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          top: BorderSide(
            color: colors.border,
            width: context.tokens.border.hairline,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Stack(
          children: [
            // The expanded panel is hosted inside the sheet's own scroll view
            // so that a drag anywhere on it — not just on a nested list —
            // moves the sheet.
            ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              children: [
                SizedBox(
                  height: expandedHeight,
                  child: Column(
                    children: [
                      _Grabber(onTap: onGrabberTap),
                      Expanded(child: expanded),
                    ],
                  ),
                ),
              ],
            ),
            // The peek bar covers the (clipped) top of the panel while
            // collapsed, and fades out as the sheet rises.
            ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, value, child) {
                if (value >= 1) return const SizedBox.shrink();
                return IgnorePointer(
                  ignoring: value > 0.5,
                  child: Opacity(
                    opacity: (1 - value * 2).clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Grabber(onTap: onGrabberTap),
                  ColoredBox(color: colors.card, child: peek),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: context.colors.card,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: context.tokens.spacing.sm),
        child: Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
