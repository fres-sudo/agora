import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Open/close state for an [AppPopoverAnchor].
///
/// A plain [ChangeNotifier] rather than a Cubit: this is ephemeral,
/// per-widget UI state with no async/persistence dependency, so a full
/// freezed/bloc setup would be disproportionate ceremony for a boolean.
class AppPopoverController extends ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void open() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  void toggle() => _isOpen ? close() : open();
}

/// Internal building block behind the `AppSelect`/`AppMultiSelect`/
/// `AppCombobox`/`AppCreatableCombobox` family. Not exported from the
/// package barrel — it has no standalone public use case yet.
///
/// Anchors [contentBuilder]'s panel to [triggerBuilder]'s trigger via
/// [CompositedTransformTarget]/[CompositedTransformFollower], flipping above
/// the trigger when there isn't enough room below, and animating open/close
/// with a fade + scale using the design system's motion tokens. Dismisses on
/// an outside tap (via a transparent full-screen barrier — shadcn popovers
/// dismiss invisibly, unlike a modal sheet's visible scrim) or Escape.
class AppPopoverAnchor extends StatefulWidget {
  const AppPopoverAnchor({
    super.key,
    required this.triggerBuilder,
    required this.contentBuilder,
    this.controller,
    this.width,
    this.minWidth,
    this.barrierDismissible = true,
    this.estimatedContentHeight = 320,
    this.autoFocusContent = true,
    this.onOpen,
    this.onClose,
  });

  final Widget Function(BuildContext context, AppPopoverController controller)
  triggerBuilder;
  final Widget Function(BuildContext context, AppPopoverController controller)
  contentBuilder;

  /// Externally-owned controller; when omitted the anchor creates and
  /// disposes its own.
  final AppPopoverController? controller;

  /// Popover width; defaults to matching the trigger's width.
  final double? width;
  final double? minWidth;
  final bool barrierDismissible;

  /// Only used to decide whether to flip the popover above the trigger when
  /// there isn't enough room below — the content still lays out and scrolls
  /// on its own regardless of this estimate.
  final double estimatedContentHeight;

  /// Forcibly moves keyboard focus into the popover content once it opens
  /// (Flutter's `autofocus` only claims focus if nothing else already holds
  /// it, and the just-tapped trigger typically does — so autofocus alone
  /// isn't enough here). Set to `false` when [contentBuilder] already
  /// autofocuses something itself (e.g. a combobox's search field), so this
  /// primitive doesn't fight it for focus.
  final bool autoFocusContent;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  @override
  State<AppPopoverAnchor> createState() => _AppPopoverAnchorState();
}

class _AppPopoverAnchorState extends State<AppPopoverAnchor>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late final AppPopoverController _controller =
      widget.controller ?? AppPopoverController();
  late final bool _ownsController = widget.controller == null;
  // AppTokens.durationFast is 120ms in both light and dark — theme-invariant,
  // so it's safe to hardcode here rather than needing a themed BuildContext.
  late final AnimationController _animController;
  late final FocusNode _contentFocusNode;

  OverlayEntry? _barrierEntry;
  OverlayEntry? _followerEntry;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    // Created eagerly (not lazily on first open) so that if the popover is
    // disposed without ever having been opened, dispose() isn't the first
    // access — creating a ticker there would look up an already-deactivated
    // element's ancestor and throw.
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _contentFocusNode = FocusNode(debugLabel: 'AppPopoverAnchor content');
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    if (_controller.isOpen) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_followerEntry != null) {
      // A close was still animating out — reuse the existing entries rather
      // than inserting duplicates.
      _animController.forward();
      widget.onOpen?.call();
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;

    final triggerSize = renderBox.size;
    final triggerTopLeft = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.sizeOf(context);
    final screenHeight = screenSize.height;
    final spaceBelow = screenHeight - (triggerTopLeft.dy + triggerSize.height);
    final spaceAbove = triggerTopLeft.dy;
    _flipped =
        spaceBelow < widget.estimatedContentHeight && spaceAbove > spaceBelow;

    final resolvedWidth = widget.width ?? triggerSize.width;
    final effectiveWidth =
        widget.minWidth != null && resolvedWidth < widget.minWidth!
        ? widget.minWidth!
        : resolvedWidth;

    // Clamp horizontally so the panel never spills past either screen edge
    // (e.g. a trigger sitting near the right edge of a narrow viewport).
    const edgePadding = 8.0;
    final maxDx = screenSize.width - edgePadding - effectiveWidth;
    final minDx = edgePadding - triggerTopLeft.dx;
    var horizontalOffset = 0.0;
    if (maxDx < minDx) {
      // Panel is wider than the viewport minus padding — pin to the left
      // edge rather than producing a negative-width overflow.
      horizontalOffset = minDx;
    } else {
      horizontalOffset = (triggerTopLeft.dx > maxDx)
          ? maxDx - triggerTopLeft.dx
          : 0.0;
      horizontalOffset = horizontalOffset < minDx ? minDx : horizontalOffset;
    }

    final tokens = context.tokens;
    final colors = context.colors;
    final gap = tokens.spaceXxs;

    final overlay = Overlay.of(context);

    _barrierEntry = OverlayEntry(
      builder: (overlayContext) => Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.barrierDismissible ? _controller.close : null,
        ),
      ),
    );

    _followerEntry = OverlayEntry(
      builder: (overlayContext) {
        return CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: _flipped ? Alignment.topLeft : Alignment.bottomLeft,
          followerAnchor: _flipped ? Alignment.bottomLeft : Alignment.topLeft,
          offset: Offset(horizontalOffset, _flipped ? -gap : gap),
          // Overlay gives non-Positioned entries the same tight,
          // full-screen constraints as the app root, so without this the
          // panel below would be force-stretched to fill the screen instead
          // of sizing to its own content.
          child: UnconstrainedBox(
            alignment: _flipped ? Alignment.bottomLeft : Alignment.topLeft,
            child: FadeTransition(
              opacity: _animController,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1).animate(
                  CurvedAnimation(
                    parent: _animController,
                    curve: Curves.easeOut,
                    reverseCurve: Curves.easeIn,
                  ),
                ),
                alignment: _flipped
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                child: Focus(
                  focusNode: _contentFocusNode,
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.escape) {
                      _controller.close();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: SizedBox(
                    width: effectiveWidth,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.popover,
                        borderRadius: tokens.borderRadiusMd,
                        border: Border.all(
                          color: colors.border,
                          width: tokens.borderHairline,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: tokens.borderRadiusMd,
                        // Popover content lives in its own OverlayEntry, a
                        // sibling subtree of the app's Scaffold — without its
                        // own Material ancestor here, Text/InkWell/Icon
                        // inside contentBuilder would fall back to
                        // debug-mode's oversized warning style and lose ink
                        // splash support.
                        child: Material(
                          type: MaterialType.transparency,
                          child: widget.contentBuilder(
                            overlayContext,
                            _controller,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_barrierEntry!);
    overlay.insert(_followerEntry!, above: _barrierEntry);
    _animController.forward(from: 0);
    widget.onOpen?.call();

    if (widget.autoFocusContent) {
      // Regular `autofocus` only claims focus if nothing else already has
      // it, and the just-tapped trigger typically still does — so force it
      // once the entry has actually mounted.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.isOpen) {
          _contentFocusNode.requestFocus();
        }
      });
    }
  }

  Future<void> _hideOverlay() async {
    if (_followerEntry == null) return;
    try {
      await _animController.reverse();
    } catch (_) {
      // Controller was disposed mid-animation (trigger removed while closing).
    }
    if (!mounted) return;
    _removeEntries();
    widget.onClose?.call();
  }

  void _removeEntries() {
    _barrierEntry?.remove();
    _followerEntry?.remove();
    _barrierEntry = null;
    _followerEntry = null;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    // Force-remove synchronously (no animation) so no OverlayEntry is ever
    // leaked past this widget's lifetime, e.g. between widget tests.
    _removeEntries();
    _contentFocusNode.dispose();
    _animController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.triggerBuilder(context, _controller),
    );
  }
}
