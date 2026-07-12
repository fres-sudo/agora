import 'package:i18n/i18n.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/blocs/products/products_bloc.dart';
import 'package:catalog/models/category.dart';
import 'package:catalog/models/product.dart';
import 'package:feature_products/presentation/widgets/product_form/product_form_wrapper.dart';
import 'package:feature_products/presentation/widgets/product_name_cell.dart';
import 'package:feature_products/presentation/widgets/product_status_badge.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

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
          error: (error) => Center(child: AppText.body(error.message)),
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

    // Filter products based on search query if needed,
    // though Bloc handles search logic usually.
    // The DataTableView is designed to handle internal sorting/searching
    // BUT since we have a Bloc, we should rely on Bloc for filtering if possible.
    // However, looking at ProductsBloc, it exposes filtered products.

    return Scaffold(
      floatingActionButton: const AppShellMenuButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
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
              return AppText.mono(
                product.sku?.isNotEmpty == true
                    ? product.sku!
                    : '#${product.id}',
                color: context.colors.mutedForeground,
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
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.sm,
                  vertical: context.tokens.spaceXxs,
                ),
                decoration: BoxDecoration(
                  color: context.colors.muted,
                  borderRadius: BorderRadius.circular(Sizes.xs),
                ),
                child: AppText.bodySm(category.name),
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

              Color color = AppPalette.neutral700;
              if (isOutOfStock) {
                color = AppPalette.error500;
              } else if (isLowStock) {
                color = AppPalette.warning600;
              }

              return AppText.titleMd('${product.stockQuantity}', color: color);
            },
            sortable: true,
          ),
          DataTableColumn(
            id: 'price',
            label: t.products.columns.price,
            width: 100,
            alignment: Alignment.centerRight,
            cellBuilder: (product) {
              return AppText.titleMd(product.formattedPrice);
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
            case DataTableRowAction.reprint:
              // Not applicable to products (reprint is order-only).
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
                    content: AppText.body(
                      t.products.messages.product_deleted,
                      color: context.colors.primaryForeground,
                    ),
                    backgroundColor: context.colors.primary,
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
