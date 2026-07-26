import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Phone presentation of [SectionPageLayout]: an index of sections that pushes
/// the chosen one as its own screen.
///
/// A bottom tab bar cannot carry the dozen sections a settings screen has, and
/// showing sidebar and content side by side needs width a phone doesn't have.
/// The list-then-detail pattern is the phone-native answer.
///
/// Navigation is handled by a [Navigator] local to this widget rather than by
/// app routes: the sections are already child widgets of the host page, so
/// there is nothing to deep-link to, and keeping it local means the desktop
/// router stays untouched. System back is forwarded to that inner navigator by
/// the enclosing [PopScope].
class SectionMobileNavigator extends StatefulWidget {
  const SectionMobileNavigator({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.title,
  });

  final List<SectionSidebarItemData> items;
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;

  /// Title shown in the index screen's app bar.
  final String? title;

  @override
  State<SectionMobileNavigator> createState() => _SectionMobileNavigatorState();
}

class _SectionMobileNavigatorState extends State<SectionMobileNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  void _open(int index) {
    widget.onItemSelected?.call(index);
    final item = widget.items[index];
    _navigatorKey.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => _SectionDetailScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Back should first unwind the section stack; only once it is empty does
      // the gesture belong to the app router.
      canPop: !(_navigatorKey.currentState?.canPop() ?? false),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _navigatorKey.currentState?.maybePop();
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => _SectionIndex(
            items: widget.items,
            title: widget.title,
            onTap: _open,
          ),
        ),
      ),
    );
  }
}

class _SectionIndex extends StatelessWidget {
  const _SectionIndex({
    required this.items,
    required this.title,
    required this.onTap,
  });

  final List<SectionSidebarItemData> items;
  final String? title;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppAppBar(title: title, leading: const AppShellDrawerButton()),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: tokens.spacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, _) => Divider(
          height: tokens.border.hairline,
          thickness: tokens.border.hairline,
          indent: tokens.spacing.xxl + tokens.spacing.md,
          color: context.colors.border,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return _SectionRow(item: item, onTap: () => onTap(index));
        },
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.item, required this.onTap});

  final SectionSidebarItemData item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.lg,
          vertical: tokens.spacing.md,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: tokens.iconSize.md,
              color: colors.mutedForeground,
            ),
            SizedBox(width: tokens.spacing.md),
            Expanded(child: AppText.body(item.label)),
            Icon(
              AgoraIcons.chevron_right,
              size: tokens.iconSize.sm,
              color: colors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionDetailScreen extends StatelessWidget {
  const _SectionDetailScreen({required this.item});

  final SectionSidebarItemData item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppAppBar(
        title: item.label,
        leading: AppIconButton.ghost(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            AgoraIcons.chevron_left,
            size: context.tokens.iconSize.lg,
            color: context.colors.foreground,
          ),
        ),
      ),
      body: item.child,
    );
  }
}
