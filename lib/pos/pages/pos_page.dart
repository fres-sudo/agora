import 'package:agora/core/gen/assets.gen.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/orders/blocs/active_order/active_order_bloc.dart';
import 'package:agora/pos/widgets/pos_category_list.dart';
import 'package:agora/pos/widgets/pos_order_panel.dart';
import 'package:agora/pos/widgets/pos_order_type_selector.dart';
import 'package:agora/pos/widgets/pos_product_grid.dart';
import 'package:agora/pos/widgets/pos_search_bar.dart';
import 'package:agora/products/blocs/products/products_bloc.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/widgets/product_form/product_form.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  OrderType _orderType = OrderType.dineIn;

  @override
  void initState() {
    super.initState();
    // Start the products bloc
    context.read<ProductsBloc>().add(const ProductsEvent.started());
    // Start the active order bloc
    context.read<ActiveOrderBloc>().add(const ActiveOrderEvent.started());
  }

  void _onProductTap(Product product) {
    context.read<ActiveOrderBloc>().add(
      ActiveOrderEvent.itemAdded(product: product),
    );
  }

  void _onCategorySelected(int? categoryId) {
    context.read<ProductsBloc>().add(
      ProductsEvent.categoryFilterChanged(categoryId),
    );
  }

  void _onSearch(String query) {
    context.read<ProductsBloc>().add(ProductsEvent.searchChanged(query));
  }

  void _onClearOrder() {
    context.read<ActiveOrderBloc>().add(const ActiveOrderEvent.cleared());
  }

  void _onProcessTransaction() {
    context.read<ActiveOrderBloc>().add(const ActiveOrderEvent.submitted());
  }

  void _onItemRemoved(int productId) {
    context.read<ActiveOrderBloc>().add(
      ActiveOrderEvent.itemRemoved(productId),
    );
  }

  /// Build cart quantities map from order items
  Map<int, int> _buildCartQuantities(ActiveOrderState state) {
    final Map<int, int> quantities = {};
    final order = state.currentOrder;
    if (order == null) return quantities;

    for (final item in order.items) {
      if (item.productId != null) {
        quantities[item.productId!] =
            (quantities[item.productId!] ?? 0) + item.quantity;
      }
    }
    return quantities;
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = context.isTabletOrLarger;

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: isTabletOrLarger ? null : _buildMobileDrawer(context),
      endDrawer: isTabletOrLarger ? null : _buildOrderDrawer(context),
      body: isTabletOrLarger
          ? _TabletLayout(
              orderType: _orderType,
              onOrderTypeChanged: (type) => setState(() => _orderType = type),
              onProductTap: _onProductTap,
              onCategorySelected: _onCategorySelected,
              onSearch: _onSearch,
              onClearOrder: _onClearOrder,
              onProcessTransaction: _onProcessTransaction,
              onItemRemoved: _onItemRemoved,
              buildCartQuantities: _buildCartQuantities,
            )
          : _MobileLayout(
              orderType: _orderType,
              onOrderTypeChanged: (type) => setState(() => _orderType = type),
              onProductTap: _onProductTap,
              onCategorySelected: _onCategorySelected,
              onSearch: _onSearch,
              onClearOrder: _onClearOrder,
              onProcessTransaction: _onProcessTransaction,
              onItemRemoved: _onItemRemoved,
              buildCartQuantities: _buildCartQuantities,
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(Icons.menu_rounded),
      ),
      title: Row(
        spacing: Sizes.sm,
        children: [
          Assets.brand.logo.image(width: 32, height: 32),
          const Text('agora'),
        ],
      ),
      actions: context.isTabletOrLarger
          ? null
          : [
              BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                      if (state.itemCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary500,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${state.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        final selectedCategoryId = state is ProductsLoaded
            ? state.selectedCategoryId
            : null;

        return Drawer(
          child: SafeArea(
            child: PosCategoryList(
              categories: state.categories,
              selectedCategoryId: selectedCategoryId,
              onCategorySelected: (id) {
                _onCategorySelected(id);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderDrawer(BuildContext context) {
    return BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
      builder: (context, state) {
        return Drawer(
          width: MediaQuery.of(context).size.width * 0.85,
          child: SafeArea(
            child: PosOrderPanel(
              currentOrder: state.currentOrder,
              orderType: _orderType,
              onOrderTypeChanged: (type) => setState(() => _orderType = type),
              onClearOrder: _onClearOrder,
              onProcessTransaction: _onProcessTransaction,
              onItemRemoved: _onItemRemoved,
            ),
          ),
        );
      },
    );
  }
}

/// Tablet layout with three columns: Categories | Products | Order
class _TabletLayout extends StatelessWidget {
  final OrderType orderType;
  final ValueChanged<OrderType> onOrderTypeChanged;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<int?> onCategorySelected;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearOrder;
  final VoidCallback onProcessTransaction;
  final ValueChanged<int> onItemRemoved;
  final Map<int, int> Function(ActiveOrderState) buildCartQuantities;

  const _TabletLayout({
    required this.orderType,
    required this.onOrderTypeChanged,
    required this.onProductTap,
    required this.onCategorySelected,
    required this.onSearch,
    required this.onClearOrder,
    required this.onProcessTransaction,
    required this.onItemRemoved,
    required this.buildCartQuantities,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left: Category sidebar
        SizedBox(
          width: 120,
          child: BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              final selectedCategoryId = state is ProductsLoaded
                  ? state.selectedCategoryId
                  : null;

              return PosCategoryList(
                categories: state.categories,
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: onCategorySelected,
              );
            },
          ),
        ),
        // Center: Product grid with search
        Expanded(
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: PosSearchBar(onSearch: onSearch),
              ),
              // Product grid
              Expanded(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, productsState) {
                    return BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
                      builder: (context, orderState) {
                        return PosProductGrid(
                          products: productsState.products,
                          cartQuantities: buildCartQuantities(orderState),
                          onProductTap: onProductTap,
                          emptyDescription:
                              'Product from your store will show here. Tap button below to add your product now',
                          emptyActionLabel: 'Add Product',
                          onEmptyAction: () =>
                              ProductFormWrapper.showCreate(context),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Right: Order panel
        Container(
          width: 320,
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: AppColors.neutral200)),
          ),
          child: BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
            builder: (context, state) {
              return PosOrderPanel(
                currentOrder: state.currentOrder,
                orderType: orderType,
                onOrderTypeChanged: onOrderTypeChanged,
                onClearOrder: onClearOrder,
                onProcessTransaction: onProcessTransaction,
                onItemRemoved: onItemRemoved,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Mobile layout with single column and drawers
class _MobileLayout extends StatelessWidget {
  final OrderType orderType;
  final ValueChanged<OrderType> onOrderTypeChanged;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<int?> onCategorySelected;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearOrder;
  final VoidCallback onProcessTransaction;
  final ValueChanged<int> onItemRemoved;
  final Map<int, int> Function(ActiveOrderState) buildCartQuantities;

  const _MobileLayout({
    required this.orderType,
    required this.onOrderTypeChanged,
    required this.onProductTap,
    required this.onCategorySelected,
    required this.onSearch,
    required this.onClearOrder,
    required this.onProcessTransaction,
    required this.onItemRemoved,
    required this.buildCartQuantities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: PosSearchBar(onSearch: onSearch),
        ),
        // Horizontal category scroll
        SizedBox(
          height: 60,
          child: BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              final selectedCategoryId = state is ProductsLoaded
                  ? state.selectedCategoryId
                  : null;

              return _HorizontalCategoryList(
                categories: state.categories,
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: onCategorySelected,
              );
            },
          ),
        ),
        // Product grid
        Expanded(
          child: BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, productsState) {
              return BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
                builder: (context, orderState) {
                  return PosProductGrid(
                    products: productsState.products,
                    cartQuantities: buildCartQuantities(orderState),
                    onProductTap: onProductTap,
                    emptyDescription:
                        'Product from your store will show here. Tap button below to add your product now',
                    emptyActionLabel: 'Add Product',
                    onEmptyAction: () {
                      // TODO: Navigate to add product
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Horizontal scrolling category list for mobile
class _HorizontalCategoryList extends StatelessWidget {
  final List<dynamic> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategorySelected;

  const _HorizontalCategoryList({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // All Menu chip
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _CategoryChip(
            label: 'All Menu',
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),
        ),
        // Category chips
        ...categories.map(
          (category) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _CategoryChip(
              label: category.name,
              isSelected: selectedCategoryId == category.id,
              onTap: () => onCategorySelected(category.id),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary500 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary500 : AppColors.neutral300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : AppColors.neutral600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
