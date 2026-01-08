import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/core/ui/widgets/confirmation_dialog.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_column.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_config.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_view.dart';
import 'package:agora/products/blocs/products/products_bloc.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/widgets/product_form/product_form_wrapper.dart';
import 'package:agora/products/widgets/product_name_cell.dart';
import 'package:agora/products/widgets/product_status_badge.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const Center(child: CircularProgressIndicator()),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          error: (error) => Center(child: Text(error.message)),
          loaded: (loaded) => _ProductsView(state: loaded),
        );
      },
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView({required this.state});

  final ProductsLoaded state;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    // Filter products based on search query if needed,
    // though Bloc handles search logic usually.
    // The DataTableView is designed to handle internal sorting/searching
    // BUT since we have a Bloc, we should rely on Bloc for filtering if possible.
    // However, looking at ProductsBloc, it exposes filtered products.

    return Scaffold(
      appBar: AppBar(
        title: Text(t.products.title),
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu),
        ),
      ),
      body: DataTableView<Product>(
        items: state.products,
        config: DataTableConfig(
          title: t.products.title,
          searchHint: t.products.search_hint,
          addButtonLabel: t.products.add_product,
          emptyStateTitle: t.products.empty.title,
          emptyStateSubtitle: t.products.empty.subtitle,
          sortOptions: [
            SortOption(id: 'name', label: t.products.columns.product_name),
            SortOption(id: 'price', label: t.products.columns.price),
            SortOption(id: 'stock', label: t.products.columns.stock),
          ],
        ),
        columns: [
          DataTableColumn(
            id: 'id',
            label: t.products.columns.id,
            width: 80,
            cellBuilder: (product) {
              return Text(
                product.sku?.isNotEmpty == true
                    ? product.sku!
                    : '#${product.id}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral500,
                  fontFamily: 'RobotoMono',
                ),
              );
            },
          ),
          DataTableColumn(
            id: 'name',
            label: t.products.columns.product_name,
            flex: 3,
            cellBuilder: (product) {
              return ProductNameCell(
                name: product.name,
                description: product.description,
                imageUrl: product.imageUrl,
              );
            },
            sortable: true,
          ),
          DataTableColumn(
            id: 'category',
            label: t.products.columns.category,
            flex: 1,
            cellBuilder: (product) {
              // Find category name from state.categories
              final category = state.categories.firstWhere(
                (c) => c.id == product.categoryId,
                orElse: () => Category(id: 0, name: 'Unknown'),
              );
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(Sizes.xs),
                ),
                child: Text(
                  category.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral700,
                  ),
                ),
              );
            },
          ),
          DataTableColumn(
            id: 'stock',
            label: t.products.columns.stock,
            width: 100,
            alignment: Alignment.centerRight,
            cellBuilder: (product) {
              final isLowStock = product.stockQuantity <= 10;
              final isOutOfStock = product.stockQuantity <= 0;

              Color color = AppColors.neutral700;
              if (isOutOfStock) {
                color = AppColors.error500;
              } else if (isLowStock) {
                color = AppColors.warning600;
              }

              return Text(
                '${product.stockQuantity}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
            sortable: true,
          ),
          DataTableColumn(
            id: 'price',
            label: t.products.columns.price,
            width: 100,
            alignment: Alignment.centerRight,
            cellBuilder: (product) {
              return Text(
                product.formattedPrice,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              );
            },
            sortable: true,
          ),
          DataTableColumn(
            id: 'status',
            label: t.products.columns.status,
            width: 100,
            alignment: Alignment.center,
            cellBuilder: (product) {
              return ProductStatusBadge(status: product.status);
            },
          ),
        ],
        onAdd: () async {
          final result = await ProductFormWrapper.showCreate(context);
          if (result && context.mounted) {
            // No need to manually refresh if stream is active,
            // but for good measure or if not using stream:
            // context.read<ProductsBloc>().add(const ProductsEvent.refresh());
          }
        },
        onRowTap: (product) async {
          // Edit on tap
          await ProductFormWrapper.showEdit(context, product);
        },
        onSearch: (query) {
          context.read<ProductsBloc>().add(ProductsEvent.searchChanged(query));
        },
        onRowAction: (product, action) async {
          switch (action) {
            case DataTableRowAction.edit:
              await ProductFormWrapper.showEdit(context, product);
              break;
            case DataTableRowAction.delete:
              final confirmed = await ConfirmationDialog.showDelete(
                context: context,
                title: t.products.messages.delete_confirm_title,
                message: t.products.messages.delete_confirm_message,
              );

              if (confirmed && context.mounted) {
                context.read<ProductsBloc>().add(
                  ProductsEvent.deleted(product.id),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.products.messages.product_deleted),
                    backgroundColor: AppColors.primary500,
                  ),
                );
              }
              break;
          }
        },
      ),
    );
  }
}
