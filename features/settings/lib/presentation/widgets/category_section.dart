import 'package:feature_settings/presentation/widgets/category_form/category_form_wrapper.dart';
import 'package:feature_settings/presentation/widgets/category_list_item.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_products/presentation/blocs/categories/categories_bloc.dart';
import 'package:feature_products/domain/models/category.dart';

/// Category settings section for managing product categories.
class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesBloc>().add(const CategoriesEvent.started());
  }

  Future<void> _onAddCategory() async {
    final result = await CategoryFormWrapper.showCreate(context);
    if (result != null && mounted) {
      context.read<CategoriesBloc>().add(CategoriesEvent.created(result));
    }
  }

  Future<void> _onEditCategory(Category category) async {
    final result = await CategoryFormWrapper.showEdit(context, category);
    if (result != null && mounted) {
      context.read<CategoriesBloc>().add(CategoriesEvent.updated(result));
    }
  }

  void _onToggleCategory(Category category, bool isEnabled) {
    final bloc = context.read<CategoriesBloc>();
    bloc.add(CategoriesEvent.updated(category.copyWith(isEnabled: isEnabled)));
  }

  Future<void> _onDeleteCategory(Category category) async {
    final confirmed = await ConfirmationDialog.showDelete(
      context: context,
      title: 'Delete Category?',
      message:
          'Are you sure you want to delete this category? All products that have already been added will be affected.',
    );

    if (confirmed && mounted) {
      context.read<CategoriesBloc>().add(CategoriesEvent.deleted(category.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText.headingSm('Category'),
                AppButton.primary(
                  onPressed: _onAddCategory,
                  label: 'Add Category',
                  leadingIcon: const Icon(AgoraIcons.plus, size: 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                return state.map(
                  initial: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  loading: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (loaded) => _buildCategoryList(loaded.categories),
                  error: (error) => _buildErrorState(error.message),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    if (categories.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: Sizes.md),
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryListItem(
          category: category,
          onToggle: (isEnabled) => _onToggleCategory(category, isEnabled),
          onTap: () => _onEditCategory(category),
          onDelete: () => _onDeleteCategory(category),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AgoraIcons.square,
            size: 64,
            color: AppPalette.neutral300,
          ), // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.category_outlined
          const SizedBox(height: Sizes.md),
          AppText.titleMd(
            'No categories yet',
            color: context.colors.mutedForeground,
          ),
          const SizedBox(height: Sizes.sm),
          AppText.body(
            'Add a category to get started',
            color: context.colors.mutedForeground,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AgoraIcons.alert, size: 48, color: AppPalette.error500),
          const SizedBox(height: Sizes.md),
          const AppText.titleMd('Failed to load categories'),
          const SizedBox(height: Sizes.sm),
          Builder(
            builder: (context) =>
                AppText.body(message, color: context.colors.mutedForeground),
          ),
          const SizedBox(height: Sizes.lg),
          AppButton.primary(
            onPressed: () => context.read<CategoriesBloc>().add(
              const CategoriesEvent.started(),
            ),
            label: 'Retry',
          ),
        ],
      ),
    );
  }
}
