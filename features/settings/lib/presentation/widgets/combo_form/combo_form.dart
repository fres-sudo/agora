import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/blocs/products/products_bloc.dart';
import 'package:catalog/models/combo.dart';
import 'package:catalog/models/combo_item.dart';
import 'package:catalog/models/product.dart';

/// Create/edit form for a [Combo] and its fixed list of constituent
/// [ComboItem]s.
///
/// Unlike [ModifierForm], a combo has no independent item lifecycle (v1 is
/// fixed-contents only) — [CombosRepository.updateCombo] replaces the whole
/// item list at once, so this form can just return the full desired [Combo]
/// as-is, no client-side diffing needed.
class ComboForm extends StatefulWidget {
  const ComboForm({super.key, this.initialCombo, this.scrollController});

  /// Scroll controller supplied by [AdaptiveModal] when this form is shown as
  /// a phone bottom sheet. Attaching it is what lets a drag on the fields move
  /// the sheet itself; null in the dialog presentation.
  final ScrollController? scrollController;

  final Combo? initialCombo;

  @override
  State<ComboForm> createState() => _ComboFormState();
}

class _ComboFormState extends State<ComboForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late bool _isEnabled;
  late List<_ComboItemDraft> _items;
  String? _itemsError;

  @override
  void initState() {
    super.initState();
    final combo = widget.initialCombo;
    _nameController = TextEditingController(text: combo?.name ?? '');
    _priceController = TextEditingController(
      text: combo == null ? '' : (combo.priceCents / 100).toStringAsFixed(2),
    );
    _isEnabled = combo?.isEnabled ?? true;
    _items = (combo?.items ?? const <ComboItem>[])
        .map(_ComboItemDraft.fromItem)
        .toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() => _items.add(_ComboItemDraft.blank()));
  }

  void _removeItem(_ComboItemDraft item) {
    setState(() => _items.remove(item));
  }

  void _onSave() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final items = _items.where((i) => i.productId != null).toList();

    setState(() {
      _itemsError = items.isEmpty ? 'Add at least one product' : null;
    });

    if (!isFormValid || items.isEmpty) return;

    final parsedPrice = double.tryParse(_priceController.text) ?? 0;
    final combo = Combo(
      id: widget.initialCombo?.id ?? 0,
      name: _nameController.text.trim(),
      priceCents: (parsedPrice * 100).round(),
      isEnabled: _isEnabled,
      items: items.map((i) => i.toComboItem()).toList(),
    );
    Navigator.of(context).pop(combo);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEditing = widget.initialCombo != null;
    final products = context.watch<ProductsBloc>().state.products;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(context.tokens.spacing.lg),
          child: AppText.headingSm(
            isEditing ? 'Edit Combo' : 'New Combo',
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 1),

        // Form Content
        Flexible(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            padding: EdgeInsets.all(context.tokens.spacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  AppTextField(
                    controller: _nameController,
                    label: 'Combo Name',
                    hintText: 'e.g. Menu Completo',
                    prefix: const Icon(AgoraIcons.gift),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.tokens.spacing.lg),

                  // Flat price field
                  AppTextField(
                    controller: _priceController,
                    label: 'Combo Price',
                    hintText: '0.00',
                    prefixText: '${context.currencySymbol} ',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      final parsed = double.tryParse(value ?? '');
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a flat price greater than 0';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.tokens.spacing.lg),

                  // Enabled toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const AppText.body('Enabled'),
                    subtitle: const AppText.caption(
                      'On: this combo appears on the POS grid. Off: hidden '
                      'from the till but not deleted.',
                    ),
                    value: _isEnabled,
                    onChanged: (value) => setState(() => _isEnabled = value),
                  ),
                  SizedBox(height: context.tokens.spacing.lg),

                  // Items section
                  const AppText.titleMd('Contents'),
                  SizedBox(height: context.tokens.spacing.sm),

                  if (_items.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.tokens.spacing.md),
                      decoration: BoxDecoration(
                        color: colors.muted,
                        borderRadius: BorderRadius.circular(
                          context.tokens.radius.sm,
                        ),
                        border: Border.all(color: colors.border),
                      ),
                      child: AppText.bodySm(
                        'No products yet. Add at least one, '
                        'e.g. "Panino" x1.',
                        color: colors.mutedForeground,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ..._items.map(
                      (item) => Padding(
                        key: item.localKey,
                        padding: EdgeInsets.only(
                          bottom: context.tokens.spacing.xs,
                        ),
                        child: _ComboItemRow(
                          item: item,
                          products: products,
                          onChanged: () => setState(() {}),
                          onRemove: () => _removeItem(item),
                        ),
                      ),
                    ),

                  if (_itemsError != null) ...[
                    SizedBox(height: context.tokens.spacing.xs),
                    AppText.bodySm(_itemsError!, color: colors.destructive),
                  ],

                  SizedBox(height: context.tokens.spacing.sm),
                  AppButton.ghost(
                    onPressed: products.isEmpty ? null : _addItem,
                    label: 'Add Product',
                    leadingIcon: const Icon(AgoraIcons.plus, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),

        const Divider(height: 1),

        // Actions
        Padding(
          padding: EdgeInsets.all(context.tokens.spacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.ghost(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Cancel',
              ),
              SizedBox(width: context.tokens.spacing.md),
              AppButton.primary(onPressed: _onSave, label: 'Save'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mutable draft of a [ComboItem] being edited. [productId]/[productName]
/// start null for a freshly-added row until a product is picked.
class _ComboItemDraft {
  _ComboItemDraft._({
    required this.localKey,
    this.productId,
    this.productName,
    this.quantity = 1,
  });

  factory _ComboItemDraft.fromItem(ComboItem item) => _ComboItemDraft._(
    localKey: ValueKey('combo_item_${item.productId}'),
    productId: item.productId,
    productName: item.productName,
    quantity: item.quantity,
  );

  factory _ComboItemDraft.blank() => _ComboItemDraft._(localKey: UniqueKey());

  final Key localKey;
  int? productId;
  String? productName;
  int quantity;

  ComboItem toComboItem() => ComboItem(
    productId: productId!,
    productName: productName!,
    quantity: quantity,
  );
}

class _ComboItemRow extends StatelessWidget {
  const _ComboItemRow({
    required this.item,
    required this.products,
    required this.onChanged,
    required this.onRemove,
  });

  final _ComboItemDraft item;
  final List<Product> products;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: AppCombobox<int>.single(
            items: [
              for (final product in products)
                AppComboboxItem(value: product.id, label: product.name),
            ],
            value: item.productId,
            placeholder: 'Select a product',
            onChanged: (productId) {
              final product = products
                  .where((p) => p.id == productId)
                  .firstOrNull;
              item.productId = productId;
              item.productName = product?.name;
              onChanged();
            },
          ),
        ),
        SizedBox(width: context.tokens.spacing.xs),
        Expanded(
          flex: 1,
          child: _QuantityStepper(
            quantity: item.quantity,
            onChanged: (value) {
              item.quantity = value;
              onChanged();
            },
          ),
        ),
        AppIconButton.ghost(
          onPressed: onRemove,
          icon: Icon(
            AgoraIcons.x_mark,
            size: 18,
            color: context.colors.mutedForeground,
          ),
          tooltip: 'Remove product',
        ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton.ghost(
          onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
          icon: const Icon(AgoraIcons.minus, size: 16),
          tooltip: 'Decrease quantity',
        ),
        AppText.body('$quantity'),
        AppIconButton.ghost(
          onPressed: () => onChanged(quantity + 1),
          icon: const Icon(AgoraIcons.plus, size: 16),
          tooltip: 'Increase quantity',
        ),
      ],
    );
  }
}
