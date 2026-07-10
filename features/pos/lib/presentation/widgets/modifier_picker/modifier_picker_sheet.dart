import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';
import 'package:order_management/models/selected_modifiers.dart';
import 'package:catalog/models/modifier_group.dart';
import 'package:catalog/models/modifier_option.dart';
import 'package:catalog/models/product.dart';
import 'package:flutter/material.dart';

/// Presented before adding a product with modifier groups to the cart
/// (P3-4). Lets the operator pick, per group:
/// - exactly one option for single-select groups (`isMultiSelect == false`,
///   rendered as radio tiles; the schema has no "required" concept so the
///   first option is pre-selected by default, keeping Confirm always
///   available), or
/// - any number of options for multi-select groups (checkboxes, starting
///   unselected).
class ModifierPickerSheet extends StatefulWidget {
  const ModifierPickerSheet({super.key, required this.product});

  final Product product;

  /// Shows the sheet for [product]. Resolves with the chosen
  /// [SelectedModifiers] (already carrying the owning group's name), or
  /// `null` if the operator cancelled.
  static Future<List<SelectedModifiers>?> show(
    BuildContext context,
    Product product,
  ) {
    return AdaptiveSheet.show<List<SelectedModifiers>>(
      context: context,
      builder: (ctx, _) => ModifierPickerSheet(product: product),
    );
  }

  @override
  State<ModifierPickerSheet> createState() => _ModifierPickerSheetState();
}

class _ModifierPickerSheetState extends State<ModifierPickerSheet> {
  /// Selected option id per single-select group, keyed by group id.
  late final Map<int, int> _singleSelections;

  /// Selected option ids per multi-select group, keyed by group id.
  late final Map<int, Set<int>> _multiSelections;

  @override
  void initState() {
    super.initState();
    _singleSelections = {
      for (final group in widget.product.modifierGroups)
        if (!group.isMultiSelect && group.options.isNotEmpty)
          group.id: group.options.first.id,
    };
    _multiSelections = {
      for (final group in widget.product.modifierGroups)
        if (group.isMultiSelect) group.id: <int>{},
    };
  }

  ModifierOption? _findOption(List<ModifierOption> options, int? id) {
    if (id == null) return null;
    for (final option in options) {
      if (option.id == id) return option;
    }
    return null;
  }

  int get _extraCents {
    var total = 0;
    for (final group in widget.product.modifierGroups) {
      if (group.isMultiSelect) {
        final selectedIds = _multiSelections[group.id] ?? const <int>{};
        for (final option in group.options) {
          if (selectedIds.contains(option.id)) {
            total += option.priceChangeCents;
          }
        }
      } else {
        final option = _findOption(group.options, _singleSelections[group.id]);
        if (option != null) total += option.priceChangeCents;
      }
    }
    return total;
  }

  List<SelectedModifiers> _buildSelection() {
    final result = <SelectedModifiers>[];
    for (final group in widget.product.modifierGroups) {
      if (group.isMultiSelect) {
        final selectedIds = _multiSelections[group.id] ?? const <int>{};
        for (final option in group.options) {
          if (selectedIds.contains(option.id)) {
            result.add(
              SelectedModifiers(
                groupName: group.name,
                optionName: option.name,
                priceChangeCents: option.priceChangeCents,
              ),
            );
          }
        }
      } else {
        final option = _findOption(group.options, _singleSelections[group.id]);
        if (option != null) {
          result.add(
            SelectedModifiers(
              groupName: group.name,
              optionName: option.name,
              priceChangeCents: option.priceChangeCents,
            ),
          );
        }
      }
    }
    return result;
  }

  void _confirm() => Navigator.of(context).pop(_buildSelection());

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = widget.product.priceCents + _extraCents;

    return Material(
      color: colors.background,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.lg)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: Sizes.md),
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              AppText.headingSm(widget.product.name),
              const SizedBox(height: Sizes.md),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final group in widget.product.modifierGroups)
                        _ModifierGroupSection(
                          group: group,
                          singleSelectedId: _singleSelections[group.id],
                          multiSelectedIds:
                              _multiSelections[group.id] ?? const <int>{},
                          onSingleChanged: (optionId) => setState(
                            () => _singleSelections[group.id] = optionId,
                          ),
                          onMultiToggled: (optionId, selected) => setState(() {
                            final set = _multiSelections[group.id] ?? <int>{};
                            if (selected) {
                              set.add(optionId);
                            } else {
                              set.remove(optionId);
                            }
                            _multiSelections[group.id] = set;
                          }),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Sizes.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.titleMd('Total'),
                  AppText.headingSm(formatCents(total), color: colors.primary),
                ],
              ),
              const SizedBox(height: Sizes.md),
              AppButton.primary(
                onPressed: _confirm,
                label: 'Add to Cart',
                fullWidth: true,
              ),
              const SizedBox(height: Sizes.sm),
              AppButton.outline(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Cancel',
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModifierGroupSection extends StatelessWidget {
  const _ModifierGroupSection({
    required this.group,
    required this.singleSelectedId,
    required this.multiSelectedIds,
    required this.onSingleChanged,
    required this.onMultiToggled,
  });

  final ModifierGroup group;
  final int? singleSelectedId;
  final Set<int> multiSelectedIds;
  final ValueChanged<int> onSingleChanged;
  final void Function(int optionId, bool selected) onMultiToggled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.titleMd(group.name),
          AppText.bodySm(
            group.isMultiSelect ? 'Choose any' : 'Choose one',
            color: colors.mutedForeground,
          ),
          const SizedBox(height: Sizes.xs),
          if (group.isMultiSelect)
            ...group.options.map(
              (option) => CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: multiSelectedIds.contains(option.id),
                onChanged: (selected) =>
                    onMultiToggled(option.id, selected ?? false),
                title: AppText.body(option.name),
                secondary: option.priceChangeCents == 0
                    ? null
                    : AppText.body(
                        '+${formatCents(option.priceChangeCents)}',
                        color: colors.mutedForeground,
                      ),
              ),
            )
          else
            RadioGroup<int>(
              groupValue: singleSelectedId,
              onChanged: (value) {
                if (value != null) onSingleChanged(value);
              },
              child: Column(
                children: group.options
                    .map(
                      (option) => RadioListTile<int>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: option.id,
                        title: AppText.body(option.name),
                        secondary: option.priceChangeCents == 0
                            ? null
                            : AppText.body(
                                '+${formatCents(option.priceChangeCents)}',
                                color: colors.mutedForeground,
                              ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
