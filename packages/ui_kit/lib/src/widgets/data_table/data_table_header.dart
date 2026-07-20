import 'package:flutter/material.dart';
import 'package:ui_kit/src/overlays/app_dropdown_option_row.dart';
import 'package:ui_kit/src/overlays/app_popover.dart';
import 'package:ui_kit/ui_kit.dart';

/// Header widget for the data table view.
///
/// Contains the title, search field, sort button, filter button, and add
/// button. On a phone the single wide row would overflow, so the controls
/// collapse to icons beside the title and the search field takes its own
/// full-width line beneath.
class DataTableHeader extends StatelessWidget {
  const DataTableHeader({
    super.key,
    required this.title,
    required this.searchHint,
    required this.addButtonLabel,
    required this.sortOptions,
    this.currentSort,
    this.searchController,
    this.hasActiveFilters = false,
    this.onSearch,
    this.onSort,
    this.onFilter,
    this.onAdd,
  });

  final String title;
  final String searchHint;
  final String addButtonLabel;
  final List<SortOption> sortOptions;
  final SortOption? currentSort;
  final TextEditingController? searchController;
  final bool hasActiveFilters;
  final ValueChanged<String>? onSearch;
  final ValueChanged<SortOption>? onSort;
  final VoidCallback? onFilter;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(mobile: _buildMobile, desktop: _buildDesktop);
  }

  /// One control row: search takes the width, everything else is an icon. The
  /// title is deliberately absent — on a phone the page's [AdaptiveAppBar]
  /// already names the screen, and repeating it would cost a whole line.
  Widget _buildMobile(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        tokens.spaceMd,
        tokens.spaceSm,
        tokens.spaceSm,
        tokens.spaceSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: searchController,
              onChanged: onSearch,
              hintText: searchHint,
              prefix: const Icon(AgoraIcons.search),
            ),
          ),
          if (sortOptions.isNotEmpty)
            _SortButton(
              sortOptions: sortOptions,
              currentSort: currentSort,
              onSort: onSort,
              compact: true,
            ),
          AppIconButton.ghost(
            onPressed: onFilter,
            icon: Badge(
              isLabelVisible: hasActiveFilters,
              smallSize: 8,
              child: Icon(AgoraIcons.filter, size: tokens.iconMd),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Row(
        children: [
          // Title
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // Search field
          SizedBox(
            width: 240,
            child: AppTextField(
              controller: searchController,
              onChanged: onSearch,
              hintText: searchHint,
              prefix: const Icon(AgoraIcons.search),
            ),
          ),
          const SizedBox(width: Sizes.sm),
          // Sort button
          if (sortOptions.isNotEmpty) ...[
            _SortButton(
              sortOptions: sortOptions,
              currentSort: currentSort,
              onSort: onSort,
            ),
            const SizedBox(width: Sizes.sm),
          ],
          // Filter button
          AppButton.outline(
            onPressed: onFilter,
            label: 'Filter',
            leadingIcon: Badge(
              isLabelVisible: hasActiveFilters,
              smallSize: 8,
              child: const Icon(AgoraIcons.filter, size: 18),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.foreground,
              side: BorderSide(color: context.colors.border),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.md,
                vertical: Sizes.sm,
              ),
            ),
          ),
          const SizedBox(width: Sizes.sm),
          // Add button
          AppButton.primary(
            onPressed: onAdd,
            label: addButtonLabel,
            leadingIcon: const Icon(AgoraIcons.plus, size: 18),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.primaryForeground,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.md,
                vertical: Sizes.sm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.sortOptions,
    this.currentSort,
    this.onSort,
    this.compact = false,
  });

  final List<SortOption> sortOptions;
  final SortOption? currentSort;
  final ValueChanged<SortOption>? onSort;

  /// Drops the label and renders icon-only, for the phone header where four
  /// labelled controls cannot share a row.
  final bool compact;

  IconData get _icon => currentSort == null
      ? AgoraIcons.chevron_up_down
      : currentSort!.direction == SortDirection.ascending
      ? AgoraIcons.chevron_up
      : AgoraIcons.chevron_down;

  @override
  Widget build(BuildContext context) {
    if (compact) return _buildCompact(context);
    return AppPopoverAnchor(
      minWidth: 160,
      triggerBuilder: (triggerContext, controller) {
        return AppButton.outline(
          onPressed: controller.toggle,
          label: currentSort == null ? 'Sort' : currentSort!.label,
          leadingIcon: Icon(_icon, size: 18),
          style: OutlinedButton.styleFrom(
            foregroundColor: triggerContext.colors.foreground,
            disabledForegroundColor: triggerContext.colors.foreground,
            side: BorderSide(color: triggerContext.colors.border),
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.md,
              vertical: Sizes.sm,
            ),
          ),
        );
      },
      contentBuilder: _buildOptions,
    );
  }

  /// Icon-only trigger for the phone header, same popover content.
  Widget _buildCompact(BuildContext context) {
    return AppPopoverAnchor(
      minWidth: 180,
      triggerBuilder: (triggerContext, controller) => AppIconButton.ghost(
        onPressed: controller.toggle,
        icon: Icon(_icon, size: triggerContext.tokens.iconMd),
      ),
      contentBuilder: _buildOptions,
    );
  }

  Widget _buildOptions(
    BuildContext contentContext,
    AppPopoverController controller,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: contentContext.tokens.spaceXxs),
        itemCount: sortOptions.length,
        itemBuilder: (context, index) {
          final option = sortOptions[index];
          final isSelected = currentSort?.id == option.id;
          return AppDropdownOptionRow(
            label: option.label,
            selected: isSelected,
            leadingIcon: isSelected
                ? (currentSort!.direction == SortDirection.ascending
                      ? AgoraIcons.chevron_up
                      : AgoraIcons.chevron_down)
                : null,
            onTap: () {
              onSort?.call(option);
              controller.close();
            },
          );
        },
      ),
    );
  }
}
