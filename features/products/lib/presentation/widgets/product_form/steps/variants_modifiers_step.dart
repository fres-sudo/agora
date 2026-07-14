import 'package:i18n/i18n.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/blocs/modifiers/modifiers_bloc.dart';
import 'package:feature_products/presentation/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

/// Step 3: Variants & Modifiers selection.
class VariantsModifiersStep extends StatelessWidget {
  const VariantsModifiersStep({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          AppText.titleMd(t.products.form.steps.variants_modifiers),
          AppText.bodySm(
            t.products.form.steps.variants_modifiers_desc,
            color: context.colors.mutedForeground,
          ),
          const SizedBox(height: Sizes.lg),

          // Modifier Groups List
          BlocBuilder<ProductFormCubit, ProductFormState>(
            builder: (context, formState) {
              final selectedIds = formState.maybeMap(
                editing: (s) => s.formData.selectedModifierIds,
                orElse: () => <int>[],
              );

              return BlocBuilder<ModifiersBloc, ModifiersState>(
                builder: (context, state) {
                  return state.maybeMap(
                    loaded: (s) {
                      if (s.modifiers.isEmpty) {
                        return _EmptyModifiersState();
                      }

                      return Column(
                        children: s.modifiers.map((modifier) {
                          final isSelected = selectedIds.contains(modifier.id);

                          return _ModifierGroupTile(
                            name: modifier.name,
                            optionCount: modifier.options.length,
                            isSelected: isSelected,
                            onToggle: () => context
                                .read<ProductFormCubit>()
                                .toggleModifier(modifier.id),
                          );
                        }).toList(),
                      );
                    },
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    orElse: () => _EmptyModifiersState(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Single modifier group tile with checkbox.
class _ModifierGroupTile extends StatelessWidget {
  const _ModifierGroupTile({
    required this.name,
    required this.optionCount,
    required this.isSelected,
    required this.onToggle,
  });

  final String name;
  final int optionCount;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.sm),
      decoration: BoxDecoration(
        color: context.colors.muted,
        borderRadius: BorderRadius.circular(Sizes.sm),
        border: Border.all(
          color: isSelected ? theme.primaryColor : context.colors.border,
        ),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (_) => onToggle(),
        title: AppText.titleMd(name),
        subtitle: AppText.bodySm(
          '$optionCount options',
          color: context.colors.mutedForeground,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.sm),
        ),
      ),
    );
  }
}

/// Empty state when no modifiers exist.
class _EmptyModifiersState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(Sizes.xl),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(Sizes.sm),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Icon(AgoraIcons.filter, size: 48, color: colors.mutedForeground),
          const SizedBox(height: Sizes.md),
          AppText.titleMd(
            'No modifiers available',
            color: colors.mutedForeground,
          ),
          const SizedBox(height: Sizes.xs),
          AppText.bodySm(
            'Create modifiers in Settings to add them here',
            color: colors.mutedForeground,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
