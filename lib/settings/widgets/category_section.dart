import 'package:agora/settings/widgets/category_form/category_form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/widgets/confirmation_dialog.dart';
import 'package:agora/products/blocs/categories/categories_bloc.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:agora/settings/widgets/category_list_item.dart';

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
    bloc.add(
      CategoriesEvent.updated(
        category.copyWith(isEnabled: isEnabled),
      ),
    );
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
    final theme = Theme.of(context);

    return Container(
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
                  'Category',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton.icon(
                  onPressed: _onAddCategory,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add Category'),
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
                  initial: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loading: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loaded: (loaded) => _buildCategoryList(loaded.categories),
                  error: (error) => _buildErrorState(theme, error.message),
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
            Icons.category_outlined,
            size: 64,
            color: AppColors.neutral300,
          ),
          const SizedBox(height: Sizes.md),
          Text(
            'No categories yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.neutral500,
                ),
          ),
          const SizedBox(height: Sizes.sm),
          Text(
            'Add a category to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral400,
                ),
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
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error500,
          ),
          const SizedBox(height: Sizes.md),
          Text(
            'Failed to load categories',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: Sizes.sm),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          const SizedBox(height: Sizes.lg),
          FilledButton(
            onPressed: () => context
                .read<CategoriesBloc>()
                .add(const CategoriesEvent.started()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
