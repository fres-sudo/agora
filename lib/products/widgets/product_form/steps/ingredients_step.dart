import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/blocs/product_form/product_form_cubit.dart';
import 'package:agora/products/blocs/products/products_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 4: Ingredients with availability toggle and ingredient selection.
class IngredientsStep extends StatefulWidget {
  const IngredientsStep({super.key});

  @override
  State<IngredientsStep> createState() => _IngredientsStepState();
}

class _IngredientsStepState extends State<IngredientsStep> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final cubit = context.read<ProductFormCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            t.products.form.steps.ingredients,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Sizes.lg),

          // Unlimited Availability Toggle
          BlocBuilder<ProductFormCubit, ProductFormState>(
            builder: (context, state) {
              final isUnlimited = state.maybeMap(
                editing: (s) => s.formData.unlimitedAvailability,
                orElse: () => false,
              );

              return Container(
                padding: const EdgeInsets.all(Sizes.md),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius: BorderRadius.circular(Sizes.sm),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.products.form.unlimited_availability,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t.products.form.unlimited_availability_desc,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isUnlimited,
                      onChanged: cubit.updateUnlimitedAvailability,
                      activeTrackColor: theme.primaryColor,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: Sizes.lg),

          // Search Ingredients
          TextField(
            controller: _searchController,
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: t.products.form.search_ingredient,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.sm),
              ),
            ),
          ),
          const SizedBox(height: Sizes.md),

          // Ingredients List
          BlocBuilder<ProductFormCubit, ProductFormState>(
            builder: (context, formState) {
              final ingredients = formState.maybeMap(
                editing: (s) => s.formData.ingredients,
                orElse: () => <int, double>{},
              );

              if (ingredients.isEmpty) {
                return _EmptyIngredientsState();
              }

              return BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, productsState) {
                  final allProducts = productsState.products;

                  return Column(
                    children: ingredients.entries.map((entry) {
                      final product = allProducts.firstWhere(
                        (p) => p.id == entry.key,
                        orElse: () => throw StateError('Product not found'),
                      );

                      return _IngredientListItem(
                        name: product.name,
                        quantity: entry.value,
                        onQuantityChanged: (qty) =>
                            cubit.updateIngredient(entry.key, qty),
                        onRemove: () => cubit.removeIngredient(entry.key),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),

          const SizedBox(height: Sizes.md),

          // Availability based on ingredients
          BlocBuilder<ProductFormCubit, ProductFormState>(
            builder: (context, state) {
              final ingredients = state.maybeMap(
                editing: (s) => s.formData.ingredients,
                orElse: () => <int, double>{},
              );

              return Container(
                padding: const EdgeInsets.all(Sizes.md),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius: BorderRadius.circular(Sizes.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.products.form.availability_based_on_ingredients,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ingredients.isEmpty ? '0' : 'Calculated',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Single ingredient list item with quantity and remove button.
class _IngredientListItem extends StatelessWidget {
  const _IngredientListItem({
    required this.name,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final String name;
  final double quantity;
  final ValueChanged<double> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.sm),
      padding: const EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(Sizes.sm),
      ),
      child: Row(
        children: [
          // Name
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.md,
                vertical: Sizes.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(Sizes.xs),
              ),
              child: Text(
                name,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(width: Sizes.md),
          // Quantity
          Expanded(
            flex: 1,
            child: TextField(
              controller: TextEditingController(text: quantity.toString()),
              onChanged: (value) {
                final parsed = double.tryParse(value) ?? 0;
                onQuantityChanged(parsed);
              },
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '${t.products.form.qty} ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.xs),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.sm,
                  vertical: Sizes.sm,
                ),
              ),
            ),
          ),
          const SizedBox(width: Sizes.sm),
          // Remove
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline),
            color: AppColors.neutral500,
          ),
        ],
      ),
    );
  }
}

/// Empty state when no ingredients added.
class _EmptyIngredientsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

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
            Icons.info_outline,
            size: 32,
            color: AppColors.neutral400,
          ),
          const SizedBox(height: Sizes.md),
          Text(
            t.products.form.search_ingredient_hint,
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
