// assets.gen.dart is app-level; logo path inlined below
import 'package:ui_kit/ui_kit.dart';
import 'package:order_management/models/order_type.dart';
import 'package:order_management/blocs/active_order/active_order_bloc.dart';
import 'package:feature_pos/feature_pos.dart';
import 'package:catalog/blocs/combos/combos_bloc.dart';
import 'package:catalog/blocs/products/products_bloc.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/product.dart';
import 'package:order_management/models/combo_line_component.dart';
import 'package:feature_products/presentation/widgets/product_form/product_form.dart';
import 'package:app_settings/app_settings.dart';
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

  /// Drives the phone cart sheet so a completed sale can drop it back to the
  /// peek bar. Unused on tablet/desktop, where the cart is a fixed column.
  final _cartSheetController = PersistentSheetController();

  @override
  void initState() {
    super.initState();
    // Start the products bloc
    context.read<ProductsBloc>().add(const ProductsEvent.started());
    // Start the combos bloc
    context.read<CombosBloc>().add(const CombosEvent.started());
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

  /// Resolves each of [combo]'s constituent products against the live
  /// catalog (same liveness convention [_onProductTap] uses for a plain
  /// product's price/prepStation) before adding the combo to the cart. If a
  /// constituent product was soft-deleted, degrade gracefully rather than
  /// blocking the add — prepStation stays unticketed and cost falls back to
  /// 0, falling back to the combo definition's denormalized name
  /// (docs/features/03-combo-modifier-pricing.md).
  void _onComboTap(Combo combo) {
    final products = context.read<ProductsBloc>().state.products;
    final components = combo.items.map((item) {
      final product = products.where((p) => p.id == item.productId).firstOrNull;
      return ComboLineComponent(
        productId: item.productId,
        productName: product?.name ?? item.productName,
        quantity: item.quantity,
        unitCostPriceCents: product?.costCents ?? 0,
        prepStation: product?.prepStation,
      );
    }).toList();
    context.read<ActiveOrderBloc>().add(
      ActiveOrderEvent.comboAdded(combo: combo, components: components),
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

      AppToast.success(
        context,
        message: completedOrder.id != null
            ? 'Order #${completedOrder.id} completed'
            : 'Order completed',
      );

      // Drop the phone cart sheet back to its peek state, ready for the next
      // customer.
      _cartSheetController.collapse();
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

  /// Build product-tile cart quantities map from order items, keyed by
  /// productId. Combo lines (comboId != null) are excluded — see
  /// [_buildComboQuantities].
  Map<int, int> _buildCartQuantities(ActiveOrderState state) {
    final Map<int, int> quantities = {};
    final order = state.currentOrder;
    if (order == null) return quantities;

    for (final item in order.items) {
      if (item.productId != null && item.comboId == null) {
        quantities[item.productId!] =
            (quantities[item.productId!] ?? 0) + item.quantity;
      }
    }
    return quantities;
  }

  /// Build combo-tile cart quantities map from order items, keyed by
  /// comboId. Reads pre-persist cart lines (one line per combo add, per
  /// docs/features/03-combo-modifier-pricing.md's cart-UX decision), so
  /// there's exactly one matching item per combo in the cart.
  Map<int, int> _buildComboQuantities(ActiveOrderState state) {
    final Map<int, int> quantities = {};
    final order = state.currentOrder;
    if (order == null) return quantities;

    for (final item in order.items) {
      if (item.comboId != null) {
        quantities[item.comboId!] =
            (quantities[item.comboId!] ?? 0) + item.quantity;
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
          AppToast.error(context, message: effect.message);
        }
      },
      child: Scaffold(
        appBar: AdaptiveAppBar.of(context, title: 'Point of Sale'),
        body: isTabletOrLarger
            ? _TabletLayout(
                orderType: _orderType,
                onOrderTypeChanged: _onOrderTypeChanged,
                onProductTap: _onProductTap,
                onComboTap: _onComboTap,
                onCategorySelected: _onCategorySelected,
                onSearch: _onSearch,
                onClearOrder: _onClearOrder,
                onProcessTransaction: _onProcessTransaction,
                onItemRemoved: _onItemRemoved,
                onItemQuantityChanged: _onItemQuantityChanged,
                onDiscountTap: _onDiscountTap,
                onRemoveDiscount: _onRemoveDiscount,
                buildCartQuantities: _buildCartQuantities,
                buildComboQuantities: _buildComboQuantities,
              )
            : _buildMobileBody(context),
      ),
    );
  }

  /// Phone POS: the product list keeps the whole screen and the cart rides
  /// along in a persistent sheet. The sheet is non-modal on purpose — at a
  /// sagra stand the operator adds items while the customer is still talking,
  /// so the cart has to stay glanceable without ever blocking the menu.
  Widget _buildMobileBody(BuildContext context) {
    final products = _MobileLayout(
      onProductTap: _onProductTap,
      onComboTap: _onComboTap,
      onCategorySelected: _onCategorySelected,
      onSearch: _onSearch,
      buildCartQuantities: _buildCartQuantities,
      buildComboQuantities: _buildComboQuantities,
    );

    return BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
      builder: (context, state) {
        final currencySymbol = context.currencySymbol;

        return AppPersistentSheet(
          controller: _cartSheetController,
          // With an empty cart there is nothing to summarise, so the sheet
          // gets out of the way entirely.
          isVisible: state.itemCount > 0,
          peekHeight: 76,
          body: products,
          peekBuilder: (context, controller) => PosCartPeekBar(
            itemCount: state.itemCount,
            totalCents: state.currentOrder?.grandTotalCents ?? 0,
            currencySymbol: currencySymbol,
            onExpand: controller.expand,
          ),
          expandedBuilder: (context, _) => PosOrderPanel(
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
  final ValueChanged<Combo> onComboTap;
  final ValueChanged<int?> onCategorySelected;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearOrder;
  final VoidCallback onProcessTransaction;
  final ValueChanged<int> onItemRemoved;
  final void Function(int lineItemId, int quantity) onItemQuantityChanged;
  final VoidCallback onDiscountTap;
  final VoidCallback onRemoveDiscount;
  final Map<int, int> Function(ActiveOrderState) buildCartQuantities;
  final Map<int, int> Function(ActiveOrderState) buildComboQuantities;

  const _TabletLayout({
    required this.orderType,
    required this.onOrderTypeChanged,
    required this.onProductTap,
    required this.onComboTap,
    required this.onCategorySelected,
    required this.onSearch,
    required this.onClearOrder,
    required this.onProcessTransaction,
    required this.onItemRemoved,
    required this.onItemQuantityChanged,
    required this.onDiscountTap,
    required this.onRemoveDiscount,
    required this.buildCartQuantities,
    required this.buildComboQuantities,
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
                padding: EdgeInsets.all(context.tokens.spacing.md),
                child: PosSearchBar(onSearch: onSearch),
              ),
              // Product grid
              Expanded(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, productsState) {
                    return BlocBuilder<CombosBloc, CombosState>(
                      builder: (context, combosState) {
                        return BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
                          builder: (context, orderState) {
                            final selectedCategoryId =
                                productsState is ProductsLoaded
                                ? productsState.selectedCategoryId
                                : null;
                            final entries = <PosMenuEntry>[
                              ...productsState.products.map(
                                PosMenuProductEntry.new,
                              ),
                              // Combos have no categoryId in v1 — only show
                              // them under the unfiltered "All" view.
                              if (selectedCategoryId == null)
                                ...combosState.combos
                                    .where((c) => c.isEnabled)
                                    .map(PosMenuComboEntry.new),
                            ];
                            return PosProductGrid(
                              entries: entries,
                              productQuantities: buildCartQuantities(
                                orderState,
                              ),
                              comboQuantities: buildComboQuantities(orderState),
                              onProductTap: onProductTap,
                              onComboTap: onComboTap,
                              emptyDescription:
                                  'Product from your store will show here. Tap button below to add your product now',
                              emptyActionLabel: 'Add Product',
                              onEmptyAction: () =>
                                  ProductFormWrapper.showCreate(context),
                            );
                          },
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
            border: Border(left: BorderSide(color: context.colors.border)),
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

/// Phone menu column: search, a pinned horizontal category strip, then the
/// products. The cart is not part of this tree — it lives in the persistent
/// sheet layered over it (see `_PosPageState._buildMobileBody`).
class _MobileLayout extends StatelessWidget {
  final ValueChanged<Product> onProductTap;
  final ValueChanged<Combo> onComboTap;
  final ValueChanged<int?> onCategorySelected;
  final ValueChanged<String> onSearch;
  final Map<int, int> Function(ActiveOrderState) buildCartQuantities;
  final Map<int, int> Function(ActiveOrderState) buildComboQuantities;

  const _MobileLayout({
    required this.onProductTap,
    required this.onComboTap,
    required this.onCategorySelected,
    required this.onSearch,
    required this.buildCartQuantities,
    required this.buildComboQuantities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.tokens.spacing.md,
            context.tokens.spacing.sm,
            context.tokens.spacing.md,
            context.tokens.spacing.sm,
          ),
          child: PosSearchBar(onSearch: onSearch),
        ),
        // Horizontal category scroll — stays pinned while products scroll.
        SizedBox(
          height: 52,
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
              return BlocBuilder<CombosBloc, CombosState>(
                builder: (context, combosState) {
                  return BlocBuilder<ActiveOrderBloc, ActiveOrderState>(
                    builder: (context, orderState) {
                      final selectedCategoryId = productsState is ProductsLoaded
                          ? productsState.selectedCategoryId
                          : null;
                      final entries = <PosMenuEntry>[
                        ...productsState.products.map(PosMenuProductEntry.new),
                        // Combos have no categoryId in v1 — only show them
                        // under the unfiltered "All" view.
                        if (selectedCategoryId == null)
                          ...combosState.combos
                              .where((c) => c.isEnabled)
                              .map(PosMenuComboEntry.new),
                      ];
                      return PosProductGrid(
                        entries: entries,
                        productQuantities: buildCartQuantities(orderState),
                        comboQuantities: buildComboQuantities(orderState),
                        onProductTap: onProductTap,
                        onComboTap: onComboTap,
                        emptyDescription:
                            'Product from your store will show here. Tap button below to add your product now',
                        emptyActionLabel: 'Add Product',
                        onEmptyAction: () =>
                            ProductFormWrapper.showCreate(context),
                      );
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
      padding: EdgeInsets.symmetric(horizontal: context.tokens.spacing.md),
      children: [
        // All Menu chip
        Padding(
          padding: EdgeInsets.only(right: context.tokens.spacing.xs),
          child: _CategoryChip(
            label: 'All Menu',
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),
        ),
        // Category chips
        ...categories.map(
          (category) => Padding(
            padding: EdgeInsets.only(right: context.tokens.spacing.xs),
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
        padding: EdgeInsets.symmetric(
          horizontal: context.tokens.spacing.md,
          vertical: context.tokens.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.card,
          borderRadius: context.tokens.radius.borderFull,
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
