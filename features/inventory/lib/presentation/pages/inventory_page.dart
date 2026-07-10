import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:inventory_contracts/repositories/inventory_repository.dart';
import 'package:feature_inventory/presentation/blocs/stock_adjustment/stock_adjustment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Basic inventory management (P7-8).
///
/// Lists every product with its current stock level, highlights low stock,
/// and offers quick ±1 adjustments plus an absolute "Set" action. Writes go
/// through [StockAdjustmentCubit] (which records a `StockMovementsTable` row);
/// the list is driven reactively by [InventoryRepository.watchStockLevels].
@RoutePage()
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  static const _defaultThreshold = 10;

  late final DataTableController<StockLevel> _tableController;
  String _search = '';
  bool _lowStockOnly = false;
  int _threshold = _defaultThreshold;

  @override
  void initState() {
    super.initState();
    _tableController = DataTableController<StockLevel>(rowsPerPage: 10);
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  List<StockLevel> _visible(List<StockLevel> levels) {
    final query = _search.trim().toLowerCase();
    return levels.where((level) {
      if (_lowStockOnly &&
          !(level.trackStock && level.quantity <= _threshold)) {
        return false;
      }
      if (query.isEmpty) return true;
      return level.name.toLowerCase().contains(query);
    }).toList();
  }

  bool _isLow(StockLevel level) =>
      level.trackStock && level.quantity <= _threshold;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockAdjustmentCubit, StockAdjustmentState>(
      listener: (context, state) {
        state.maybeWhen(
          error: (message, _, _) =>
              showAppSnackBar(context, message, isError: true),
          orElse: () {},
        );
      },
      child: Scaffold(
        floatingActionButton: const AppShellMenuButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: StreamBuilder<List<StockLevel>>(
          stream: context.read<InventoryRepository>().watchStockLevels(),
          builder: (context, snapshot) {
            final levels = _visible(snapshot.data ?? const []);

            return AnimatedBuilder(
              animation: _tableController,
              builder: (context, _) => DataTableView<StockLevel>(
                controller: _tableController,
                items: levels,
                isLoading:
                    snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData,
                showAddButton: false,
                showEditAction: false,
                showDeleteAction: false,
                config: const DataTableConfig(
                  title: 'Inventory',
                  searchHint: 'Search products...',
                  emptyStateTitle: 'No products',
                  emptyStateSubtitle: 'Add products to start tracking stock',
                  emptyStateIcon: AgoraIcons.package,
                ),
                onSearch: (query) => setState(() => _search = query),
                onFilter: _showFilterDialog,
                columns: [
                  DataTableColumn(
                    id: 'name',
                    label: 'Product',
                    flex: 3,
                    cellBuilder: (level) => Row(
                      children: [
                        Flexible(
                          child: AppText.titleMd(
                            level.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!level.trackStock) ...[
                          const SizedBox(width: Sizes.sm),
                          _Tag(
                            label: 'Not tracked',
                            color: AppPalette.neutral500,
                          ),
                        ],
                      ],
                    ),
                  ),
                  DataTableColumn(
                    id: 'quantity',
                    label: 'In stock',
                    width: 130,
                    alignment: Alignment.centerLeft,
                    cellBuilder: (level) {
                      final low = _isLow(level);
                      return _Tag(
                        label: '${level.quantity}',
                        color: low
                            ? AppPalette.error500
                            : AppPalette.primary500,
                        icon: low ? AgoraIcons.alert_triangle : null,
                      );
                    },
                  ),
                  DataTableColumn(
                    id: 'adjust',
                    label: 'Adjust',
                    width: 190,
                    alignment: Alignment.centerRight,
                    cellBuilder: (level) => Align(
                      alignment: Alignment.centerRight,
                      child: QuantityButton(
                        quantity: level.quantity,
                        min: 0,
                        onChanged: (value) => _onQuickAdjust(level, value),
                      ),
                    ),
                  ),
                  DataTableColumn(
                    id: 'set',
                    label: '',
                    width: 72,
                    alignment: Alignment.centerRight,
                    cellBuilder: (level) => AppIconButton.ghost(
                      onPressed: () => _showSetDialog(level),
                      icon: const Icon(AgoraIcons.pencil, size: 18),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onQuickAdjust(StockLevel level, int newValue) {
    final delta = newValue - level.quantity;
    if (delta == 0) return;
    context.read<StockAdjustmentCubit>().adjust(
      productId: level.productId,
      delta: delta,
    );
  }

  Future<void> _showSetDialog(StockLevel level) async {
    final controller = TextEditingController(text: '${level.quantity}');
    final cubit = context.read<StockAdjustmentCubit>();

    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText.titleLg('Set stock — ${level.name}'),
        content: AppTextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          label: 'Quantity',
        ),
        actions: [
          AppButton.ghost(
            onPressed: () => Navigator.of(context).pop(),
            label: 'Cancel',
          ),
          AppButton.primary(
            onPressed: () {
              final parsed = int.tryParse(controller.text.trim());
              Navigator.of(context).pop(parsed);
            },
            label: 'Save',
          ),
        ],
      ),
    );

    if (value != null && value >= 0) {
      await cubit.setQuantity(productId: level.productId, quantity: value);
    }
  }

  Future<void> _showFilterDialog() async {
    var lowOnly = _lowStockOnly;
    final thresholdController = TextEditingController(text: '$_threshold');

    await DataTableFilterDialog.show(
      context: context,
      title: 'Inventory filters',
      onApply: () {
        setState(() {
          _lowStockOnly = lowOnly;
          _threshold =
              int.tryParse(thresholdController.text.trim()) ?? _threshold;
        });
      },
      child: StatefulBuilder(
        builder: (context, setLocalState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const AppText.body('Low stock only'),
              value: lowOnly,
              onChanged: (v) => setLocalState(() => lowOnly = v),
            ),
            const SizedBox(height: Sizes.sm),
            AppTextField(
              controller: thresholdController,
              keyboardType: TextInputType.number,
              label: 'Low stock threshold',
            ),
          ],
        ),
      ),
    );
  }
}

/// Small rounded label used for stock counts and status tags.
class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.sm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          AppText.label(label, color: color),
        ],
      ),
    );
  }
}
