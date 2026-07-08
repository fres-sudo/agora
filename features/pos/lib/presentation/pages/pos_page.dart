// assets.gen.dart is app-level; logo path inlined below
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_orders/domain/models/order_type.dart';
import 'package:feature_orders/presentation/blocs/active_order/active_order_bloc.dart';
import 'package:feature_orders/presentation/utils/receipt_config_builder.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:feature_products/presentation/blocs/products/products_bloc.dart';
import 'package:feature_products/domain/models/product.dart';
import 'package:feature_products/presentation/widgets/product_form/product_form.dart';
import 'package:feature_settings/feature_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

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

  Future<void> _onProductTap(Product product) async {
    if (product.modifierGroups.isNotEmpty) {
      final selected = await ModifierPickerSheet.show(context, product);
      if (selected == null || !mounted) return;
      context.read<ActiveOrderBloc>().add(
        ActiveOrderEvent.itemAdded(product: product, modifiers: selected),
      );
    } else {
      context.read<ActiveOrderBloc>().add(
        ActiveOrderEvent.itemAdded(product: product),
      );
    }
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

  void _onOrderTypeChanged(OrderType type) {
    setState(() => _orderType = type);
    // Persist the selection into the cart so the completed order carries it.
    context.read<ActiveOrderBloc>().add(
      ActiveOrderEvent.orderTypeChanged(type),
    );
  }

  Future<void> _onDiscountTap() async {
    final discount = await DiscountSheet.show(context);
    if (discount == null || !mounted) return;
    context.read<ActiveOrderBloc>().add(
      ActiveOrderEvent.discountApplied(discount),
    );
  }

  void _onRemoveDiscount() {
    context.read<ActiveOrderBloc>().add(
      const ActiveOrderEvent.discountRemoved(),
    );
  }

  Future<void> _onProcessTransaction() async {
    final activeState = context.read<ActiveOrderBloc>().state;
    final order = activeState.currentOrder;
    if (order == null || order.items.isEmpty) return;

    final receiptConfig = buildReceiptConfig(context.read<SettingsCubit>());
    final completedOrder = await CheckoutSheet.show(
      context,
      order,
      receiptConfig: receiptConfig,
      appliedDiscount: activeState.appliedDiscount,
    );
    if (!mounted) return;

    if (completedOrder != null) {
      // Sale finalised: clear the cart and confirm.
      context.read<ActiveOrderBloc>().add(const ActiveOrderEvent.cleared());

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(AgoraIcons.check, color: context.colors.successForeground),
                const SizedBox(width: Sizes.sm),
                AppText.body(
                  completedOrder.id != null
                      ? 'Order #${completedOrder.id} completed'
                      : 'Order completed',
                  color: context.colors.successForeground,
                ),
              ],
            ),
            backgroundColor: context.colors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

      // Close the mobile cart drawer if it is open.
      final scaffold = Scaffold.maybeOf(context);
      if (scaffold?.isEndDrawerOpen ?? false) {
        Navigator.of(context).pop();
      }
    }
  }

  void _onItemRemoved(int lineItemId) {
    context.read<ActiveOrderBloc>().add(
      ActiveOrderEvent.itemRemoved(lineItemId),
    );
  }

  void _onItemQuantityChanged(int lineItemId, int quantity) {
    context.read<ActiveOrderBloc>().add(
      ActiveOrderEvent.itemQuantityChanged(
        lineItemId: lineItemId,
        quantity: quantity,
      ),
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

    // Surface errors emitted by the active-order bloc (e.g. submit guards).
    // Checkout success/failure is handled inline by the checkout sheet, so the
    // previously-broken `submitted` state listener has been removed (P1-7).
    return EffectListener<ActiveOrderBloc, ActiveOrderEffect>(
      filter: (effect) => effect is ActiveOrderShowError,
      onEffect: (context, effect) {
        if (effect is ActiveOrderShowError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: AppText.body(
                  effect.message,
                  color: context.colors.destructiveForeground,
                ),
                backgroundColor: context.colors.destructive,
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Scaffold(
        floatingActionButton: const AppShellMenuButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        drawer: isTabletOrLarger ? null : _buildMobileDrawer(context),
        endDrawer: isTabletOrLarger ? null : _buildOrderDrawer(context),
        body: isTabletOrLarger
            ? _TabletLayout(
                orderType: _orderType,
                onOrderTypeChanged: _onOrderTypeChanged,
                onProductTap: _onProductTap,
                onCategorySelected: _onCategorySelected,
                onSearch: _onSearch,
                onClearOrder: _onClearOrder,
                onProcessTransaction: _onProcessTransaction,
                onItemRemoved: _onItemRemoved,
                onItemQuantityChanged: _onItemQuantityChanged,
                onDiscountTap: _onDiscountTap,
                onRemoveDiscount: _onRemoveDiscount,
                buildCartQuantities: _buildCartQuantities,
              )
            : Stack(
                children: [
                  _MobileLayout(
                    orderType: _orderType,
                    onOrderTypeChanged: _onOrderTypeChanged,
                    onProductTap: _onProductTap,
                    onCategorySelected: _onCategorySelected,
                    onSearch: _onSearch,
                    onClearOrder: _onClearOrder,
                    onProcessTransaction: _onProcessTransaction,
                    onItemRemoved: _onItemRemoved,
                    onItemQuantityChanged: _onItemQuantityChanged,
                    buildCartQuantities: _buildCartQuantities,
                  ),
                  // Cart access moves off the (removed) app bar into a floating
                  // button mirroring the menu button on the opposite side.
                  const Align(
                    alignment: Alignment.topRight,
                    child: _PosCartButton(),
                  ),
                ],
              ),
      ),
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
              onOrderTypeChanged: _onOrderTypeChanged,
              onClearOrder: _onClearOrder,
              onProcessTransaction: _onProcessTransaction,
              onItemRemoved: _onItemRemoved,
              onItemQuantityChanged: _onItemQuantityChanged,
              appliedDiscount: state.appliedDiscount,
              onDiscountTap: _onDiscountTap,
              onRemoveDiscount: _onRemoveDiscount,
            ),
          ),
        );
      },
    );
  }
}

/// Floating cart button for the mobile POS layout. Replaces the cart action
/// that used to live in the app bar; opens the order panel end-drawer and
/// shows a live item-count badge. Styled to match [AppShellMenuButton].
class _PosCartButton extends StatelessWidget {
  const _PosCartButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.sm),
        child: BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
          builder: (context, state) {
            return Material(
              color: context.colors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.borderRadius),
                side: BorderSide(color: context.colors.border),
              ),
              elevation: 2,
              child: InkWell(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                borderRadius: BorderRadius.circular(Sizes.borderRadius),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        AgoraIcons
                            .bag, // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.shopping_cart_outlined
                        size: 22,
                        color: context.colors.foreground,
                      ),
                      if (state.itemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: context.colors.primary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: AppText.caption(
                              '${state.itemCount}',
                              color: context.colors.primaryForeground,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
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
  final void Function(int lineItemId, int quantity) onItemQuantityChanged;
  final VoidCallback onDiscountTap;
  final VoidCallback onRemoveDiscount;
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
    required this.onItemQuantityChanged,
    required this.onDiscountTap,
    required this.onRemoveDiscount,
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
            border: Border(left: BorderSide(color: AppPalette.neutral200)),
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
                onItemQuantityChanged: onItemQuantityChanged,
                appliedDiscount: state.appliedDiscount,
                onDiscountTap: onDiscountTap,
                onRemoveDiscount: onRemoveDiscount,
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
  final void Function(int lineItemId, int quantity) onItemQuantityChanged;
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
    required this.onItemQuantityChanged,
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
                    onEmptyAction: () => ProductFormWrapper.showCreate(context),
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
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Center(
          child: isSelected
              ? AppText.titleMd(label, color: colors.primaryForeground)
              : AppText.body(label, color: colors.mutedForeground),
        ),
      ),
    );
  }
}
