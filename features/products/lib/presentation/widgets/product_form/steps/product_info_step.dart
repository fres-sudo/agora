import 'package:i18n/i18n.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/blocs/categories/categories_bloc.dart';
import 'package:catalog/models/category.dart';
import 'package:catalog/repositories/categories_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:catalog/widgets/category_form/category_form_wrapper.dart';
import 'package:feature_products/presentation/blocs/product_form/product_form_cubit.dart';
import 'package:feature_products/presentation/widgets/product_form/product_photo_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:result/result.dart';

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
  late String _prepStation;
  List<String> _prepStationSuggestions = const [];

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
    _prepStation = formData?.prepStation ?? '';
    context.read<ProductsRepository>().getPrepStations().then((result) {
      if (!mounted) return;
      if (result case Ok<List<String>>(:final value)) {
        setState(() => _prepStationSuggestions = value);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  Future<void> _onAddCategory() async {
    final category = await CategoryFormWrapper.showCreate(context);
    if (category == null || !mounted) return;

    final result = await context.read<CategoriesRepository>().createCategory(
      category,
    );
    if (!mounted) return;

    if (result case Ok<Category>(:final value)) {
      context.read<ProductFormCubit>().updateCategory(value.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final cubit = context.read<ProductFormCubit>();

    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, formState) {
        final errors = formState.maybeMap(
          editing: (s) => s.errors,
          orElse: () => const <String, String>{},
        );
        final selectedCategoryId = formState.maybeMap(
          editing: (s) => s.formData.categoryId,
          orElse: () => null,
        );
        final imageUrl = formState.maybeMap(
          editing: (s) => s.formData.imageUrl,
          orElse: () => null,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              Center(
                child: Column(
                  children: [
                    AppSourcedImage(
                      source: imageUrl,
                      size: 72,
                      borderRadius: BorderRadius.circular(Sizes.sm),
                    ),
                    const SizedBox(height: Sizes.sm),
                    AppButton.ghost(
                      label: imageUrl == null || imageUrl.isEmpty
                          ? t.products.form.photo.add_photo
                          : t.products.form.photo.change_photo,
                      onPressed: () async {
                        final result = await AdaptiveSheet.show<String?>(
                          context: context,
                          builder: (ctx, _) =>
                              ProductPhotoPickerSheet(initialValue: imageUrl),
                        );
                        if (result == null) return;
                        cubit.updateImageUrl(result.isEmpty ? null : result);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.lg),

              // Product Name
              _FormLabel(label: t.products.form.product_name, required: true),
              const SizedBox(height: Sizes.sm),
              AppTextField(
                controller: _nameController,
                onChanged: cubit.updateName,
                hintText: t.products.form.product_name,
                errorText: errors['name'],
              ),
              const SizedBox(height: Sizes.lg),

              // Category
              _FormLabel(label: t.products.form.category, required: true),
              const SizedBox(height: Sizes.sm),
              BlocBuilder<CategoriesBloc, CategoriesState>(
                builder: (context, categoriesState) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppSelect<int>(
                          items: [
                            for (final category in categoriesState.categories)
                              AppSelectItem(
                                value: category.id,
                                label: category.name,
                              ),
                          ],
                          value: selectedCategoryId,
                          placeholder: t.products.form.select_category,
                          errorText: errors['category'],
                          onChanged: (value) => cubit.updateCategory(value),
                        ),
                      ),
                      const SizedBox(width: Sizes.sm),
                      AppIconButton.outline(
                        icon: const Icon(AgoraIcons.plus),
                        tooltip: t.products.form.add_category,
                        onPressed: _onAddCategory,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: Sizes.lg),

              // Description
              _FormLabel(label: t.products.form.description),
              const SizedBox(height: Sizes.sm),
              AppTextField(
                controller: _descriptionController,
                onChanged: cubit.updateDescription,
                maxLines: 3,
                hintText: t.products.form.description_hint,
                errorText: errors['description'],
              ),
              const SizedBox(height: Sizes.lg),

              // SKU
              _FormLabel(label: t.products.form.sku),
              const SizedBox(height: Sizes.sm),
              AppTextField(
                controller: _skuController,
                onChanged: cubit.updateSku,
                hintText: t.products.form.sku_hint,
                errorText: errors['sku'],
              ),
              const SizedBox(height: Sizes.lg),

              // Prep station (kitchen ticket routing)
              _FormLabel(label: t.products.form.prep_station),
              const SizedBox(height: Sizes.sm),
              AppCreatableCombobox<String>(
                items: [
                  for (final station in _prepStationSuggestions)
                    AppComboboxItem(value: station, label: station),
                ],
                value: _prepStation.isEmpty ? null : _prepStation,
                placeholder: t.products.form.prep_station_hint,
                optimisticValueBuilder: (query) => query,
                onCreate: (query) async {
                  setState(() {
                    if (!_prepStationSuggestions.contains(query)) {
                      _prepStationSuggestions = [
                        ..._prepStationSuggestions,
                        query,
                      ];
                    }
                  });
                  return query;
                },
                onChanged: (value) {
                  setState(() => _prepStation = value ?? '');
                  cubit.updatePrepStation(value ?? '');
                },
              ),
            ],
          ),
        );
      },
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
    return Row(
      children: [
        AppText.label(label),
        if (required) ...[
          SizedBox(width: context.tokens.spaceXxs),
          AppText.label('*', color: context.colors.destructive),
        ],
      ],
    );
  }
}
