import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/blocs/modifiers/modifiers_bloc.dart';
import 'package:agora/products/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 3: Variants & Modifiers selection.
class VariantsModifiersStep extends StatelessWidget {
  const VariantsModifiersStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            t.products.form.steps.variants_modifiers,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            t.products.form.steps.variants_modifiers_desc,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral500,
            ),
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
                    loading: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
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
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(Sizes.sm),
        border: Border.all(
          color: isSelected ? theme.primaryColor : AppColors.neutral200,
        ),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (_) => onToggle(),
        title: Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '$optionCount options',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.neutral500,
          ),
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Sizes.xl),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(Sizes.sm),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.tune_outlined,
            size: 48,
            color: AppColors.neutral400,
          ),
          const SizedBox(height: Sizes.md),
          Text(
            'No modifiers available',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.neutral600,
            ),
          ),
          const SizedBox(height: Sizes.xs),
          Text(
            'Create modifiers in Settings to add them here',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
