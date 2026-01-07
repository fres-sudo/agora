import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/blocs/categories/categories_bloc.dart';
import 'package:agora/products/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 1: Product Info - name, category, description, SKU.
class ProductInfoStep extends StatefulWidget {
  const ProductInfoStep({super.key});

  @override
  State<ProductInfoStep> createState() => _ProductInfoStepState();
}

class _ProductInfoStepState extends State<ProductInfoStep> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _skuController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProductFormCubit>().state;
    context.read<CategoriesBloc>().fetch();
    final formData = state.maybeMap(
      editing: (s) => s.formData,
      orElse: () => null,
    );
    _nameController = TextEditingController(text: formData?.name ?? '');
    _descriptionController = TextEditingController(
      text: formData?.description ?? '',
    );
    _skuController = TextEditingController(text: formData?.sku ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final cubit = context.read<ProductFormCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          _FormLabel(label: t.products.form.product_name, required: true),
          const SizedBox(height: Sizes.sm),
          TextField(
            controller: _nameController,
            onChanged: cubit.updateName,
            decoration: InputDecoration(
              hintText: t.products.form.product_name,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.sm),
              ),
            ),
          ),
          const SizedBox(height: Sizes.lg),

          // Category
          _FormLabel(label: t.products.form.category, required: true),
          const SizedBox(height: Sizes.sm),
          BlocBuilder<ProductFormCubit, ProductFormState>(
            builder: (context, state) {
              final selectedCategoryId = state.maybeMap(
                editing: (s) => s.formData.categoryId,
                orElse: () => null,
              );

              return BlocBuilder<CategoriesBloc, CategoriesState>(
                builder: (context, categoriesState) {
                  final categories = categoriesState.categories;

                  return DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      hintText: t.products.form.select_category,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.sm),
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) => cubit.updateCategory(value),
                  );
                },
              );
            },
          ),
          const SizedBox(height: Sizes.lg),

          // Description
          _FormLabel(label: t.products.form.description),
          const SizedBox(height: Sizes.sm),
          TextField(
            controller: _descriptionController,
            onChanged: cubit.updateDescription,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: t.products.form.description_hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.sm),
              ),
            ),
          ),
          const SizedBox(height: Sizes.lg),

          // SKU
          _FormLabel(label: t.products.form.sku),
          const SizedBox(height: Sizes.sm),
          TextField(
            controller: _skuController,
            onChanged: cubit.updateSku,
            decoration: InputDecoration(
              hintText: t.products.form.sku_hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Form label widget with optional required indicator.
class _FormLabel extends StatelessWidget {
  const _FormLabel({required this.label, this.required = false});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.error500,
            ),
          ),
        ],
      ],
    );
  }
}
