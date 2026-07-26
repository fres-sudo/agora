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
          padding: EdgeInsets.all(context.tokens.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductPhotoField(
                imageUrl: imageUrl,
                title: t.products.form.photo.title,
                addPhotoLabel: t.products.form.photo.add_photo,
                changePhotoLabel: t.products.form.photo.change_photo,
                onChanged: cubit.updateImageUrl,
              ),
              SizedBox(height: context.tokens.spacing.md),

              // Product Name
              _FormLabel(label: t.products.form.product_name, required: true),
              SizedBox(height: context.tokens.spacing.xs),
              AppTextField(
                controller: _nameController,
                onChanged: cubit.updateName,
                hintText: t.products.form.product_name,
                errorText: errors['name'],
              ),
              SizedBox(height: context.tokens.spacing.md),

              // Category
              _FormLabel(label: t.products.form.category, required: true),
              SizedBox(height: context.tokens.spacing.xs),
              BlocBuilder<CategoriesBloc, CategoriesState>(
                builder: (context, categoriesState) {
                  final bodyStyle = context.typography.body;
                  final categoryDropdownHeight =
                      MediaQuery.textScalerOf(
                            context,
                          ).scale(bodyStyle.fontSize ?? 14) *
                          (bodyStyle.height ?? 1.5) +
                      (context.tokens.spacing.xs * 2);

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
                                icon: category.icon ?? AgoraIcons.categories,
                                iconBackgroundColor:
                                    category.color ?? context.colors.muted,
                              ),
                          ],
                          value: selectedCategoryId,
                          placeholder: t.products.form.select_category,
                          errorText: errors['category'],
                          onChanged: (value) => cubit.updateCategory(value),
                        ),
                      ),
                      SizedBox(width: context.tokens.spacing.xs),
                      AppIconButton.outline(
                        icon: const Icon(AgoraIcons.plus),
                        tooltip: t.products.form.add_category,
                        onPressed: _onAddCategory,
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size.square(categoryDropdownHeight),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: context.tokens.spacing.md),

              // Description
              _FormLabel(label: t.products.form.description),
              SizedBox(height: context.tokens.spacing.xs),
              AppTextField(
                controller: _descriptionController,
                onChanged: cubit.updateDescription,
                maxLines: 3,
                hintText: t.products.form.description_hint,
                errorText: errors['description'],
              ),
              SizedBox(height: context.tokens.spacing.md),

              // SKU
              _FormLabel(label: t.products.form.sku),
              SizedBox(height: context.tokens.spacing.xs),
              AppTextField(
                controller: _skuController,
                onChanged: cubit.updateSku,
                hintText: t.products.form.sku_hint,
                errorText: errors['sku'],
              ),
              SizedBox(height: context.tokens.spacing.md),

              // Prep station (kitchen ticket routing)
              _FormLabel(label: t.products.form.prep_station),
              SizedBox(height: context.tokens.spacing.xs),
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

/// A visible, self-contained entry point for the optional product visual.
///
/// Keeping the preview and action together makes it clear what will change
/// before a user opens the picker, especially when editing an existing item.
class _ProductPhotoField extends StatelessWidget {
  const _ProductPhotoField({
    required this.imageUrl,
    required this.title,
    required this.addPhotoLabel,
    required this.changePhotoLabel,
    required this.onChanged,
  });

  final String? imageUrl;
  final String title;
  final String addPhotoLabel;
  final String changePhotoLabel;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = imageUrl != null && imageUrl!.isNotEmpty;

    return AppSurface(
      padding: EdgeInsets.all(context.tokens.spacing.sm),
      child: Row(
        children: [
          AppSourcedImage(
            source: imageUrl,
            size: 88,
            borderRadius: context.tokens.radius.borderMd,
          ),
          SizedBox(width: context.tokens.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleMd(title),
                SizedBox(height: context.tokens.spacing.xs),
                AppButton.outline(
                  label: hasPhoto ? changePhotoLabel : addPhotoLabel,
                  leadingIcon: Icon(
                    hasPhoto ? AgoraIcons.edit : AgoraIcons.plus,
                  ),
                  onPressed: () async {
                    final result = await AdaptiveModal.show<String?>(
                      context: context,
                      style: AdaptiveModalStyle.sideSheet,
                      builder: (ctx, scrollController) =>
                          ProductPhotoPickerSheet(
                            initialValue: imageUrl,
                            scrollController: scrollController,
                          ),
                    );
                    if (result == null) return;
                    onChanged(result.isEmpty ? null : result);
                  },
                ),
              ],
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
    return Row(
      children: [
        AppText.label(label),
        if (required) ...[
          SizedBox(width: context.tokens.spacing.xxs),
          AppText.label('*', color: context.colors.destructive),
        ],
      ],
    );
  }
}
