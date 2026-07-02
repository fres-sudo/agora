import 'package:feature_settings/presentation/widgets/modifier_form/modifier_form_wrapper.dart';
import 'package:feature_settings/presentation/widgets/modifier_list_item.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_products/presentation/blocs/modifiers/modifiers_bloc.dart';
import 'package:feature_products/domain/models/modifier_group.dart';

/// Modifier settings section for managing modifier groups (Settings ->
/// Modifier). Mirrors [CategorySection]'s pattern, with the added wrinkle
/// that a modifier group owns a nested, independently-persisted list of
/// options (see [ModifierForm] for why edits are diffed client-side).
class ModifierSection extends StatefulWidget {
  const ModifierSection({super.key});

  @override
  State<ModifierSection> createState() => _ModifierSectionState();
}

class _ModifierSectionState extends State<ModifierSection> {
  @override
  void initState() {
    super.initState();
    context.read<ModifiersBloc>().add(const ModifiersEvent.started());
  }

  Future<void> _onAddModifier() async {
    final result = await ModifierFormWrapper.showCreate(context);
    if (result != null && mounted) {
      // createModifier cascades option creation, so the full group
      // (including options with id == 0) can be sent as-is.
      context.read<ModifiersBloc>().add(ModifiersEvent.created(result));
    }
  }

  Future<void> _onEditModifier(ModifierGroup original) async {
    final result = await ModifierFormWrapper.showEdit(context, original);
    if (result == null || !mounted) return;

    final bloc = context.read<ModifiersBloc>();

    // Group-level fields (name / isMultiSelect) persist via `updated`.
    bloc.add(ModifiersEvent.updated(result));

    // `updateModifier` does not touch options, so diff them client-side and
    // dispatch the dedicated option events.
    final originalById = {for (final o in original.options) o.id: o};
    final resultIds = result.options.map((o) => o.id).toSet();

    for (final option in result.options) {
      if (option.id == 0) {
        bloc.add(
          ModifiersEvent.optionCreated(modifierId: original.id, option: option),
        );
        continue;
      }

      final before = originalById[option.id];
      if (before != null &&
          (before.name != option.name ||
              before.priceChangeCents != option.priceChangeCents)) {
        bloc.add(ModifiersEvent.optionUpdated(option));
      }
    }

    for (final before in original.options) {
      if (!resultIds.contains(before.id)) {
        bloc.add(ModifiersEvent.optionDeleted(before.id));
      }
    }
  }

  Future<void> _onDeleteModifier(ModifierGroup modifierGroup) async {
    final confirmed = await ConfirmationDialog.showDelete(
      context: context,
      title: 'Delete Modifier?',
      message:
          'Are you sure you want to delete this modifier? It will be removed '
          'from every product it is currently linked to.',
    );

    if (confirmed && mounted) {
      context.read<ModifiersBloc>().add(
        ModifiersEvent.deleted(modifierGroup.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return EffectListener<ModifiersBloc, ModifiersEffect>(
      onEffect: (context, effect) {
        if (effect is ModifiersShowError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(effect.message),
                backgroundColor: AppPalette.error500,
              ),
            );
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modifier',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppButton.primary(
                    onPressed: _onAddModifier,
                    label: 'Add Modifier',
                    leadingIcon: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: BlocBuilder<ModifiersBloc, ModifiersState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (loaded) => _buildModifierList(loaded.modifiers),
                    error: (error) => _buildErrorState(theme, error.message),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModifierList(List<ModifierGroup> modifiers) {
    if (modifiers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: modifiers.length,
      separatorBuilder: (context, index) => const SizedBox(height: Sizes.md),
      itemBuilder: (context, index) {
        final modifierGroup = modifiers[index];
        return ModifierListItem(
          modifierGroup: modifierGroup,
          onTap: () => _onEditModifier(modifierGroup),
          onDelete: () => _onDeleteModifier(modifierGroup),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tune_outlined, size: 64, color: AppPalette.neutral300),
          const SizedBox(height: Sizes.md),
          Text(
            'No modifiers yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppPalette.neutral500),
          ),
          const SizedBox(height: Sizes.sm),
          Text(
            'Add a modifier (e.g. "Size" or "Milk Option") to get started',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppPalette.neutral400),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppPalette.error500),
          const SizedBox(height: Sizes.md),
          Text('Failed to load modifiers', style: theme.textTheme.titleMedium),
          const SizedBox(height: Sizes.sm),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppPalette.neutral500,
            ),
          ),
          const SizedBox(height: Sizes.lg),
          AppButton.primary(
            onPressed: () =>
                context.read<ModifiersBloc>().add(const ModifiersEvent.started()),
            label: 'Retry',
          ),
        ],
      ),
    );
  }
}
