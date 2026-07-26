import 'package:discounts/models/discount.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

/// Create/edit form for a [Discount] (Settings → Discount & Voucher, P6-3).
///
/// Percentage discounts store the raw percent in [Discount.value]; fixed
/// discounts store cents (parsed from the euro amount the operator types).
class DiscountForm extends StatefulWidget {
  const DiscountForm({super.key, this.initialDiscount, this.scrollController});

  /// Scroll controller supplied by [AdaptiveModal] when this form is shown as
  /// a phone bottom sheet. Attaching it is what lets a drag on the fields move
  /// the sheet itself; null in the dialog presentation.
  final ScrollController? scrollController;

  final Discount? initialDiscount;

  @override
  State<DiscountForm> createState() => _DiscountFormState();
}

class _DiscountFormState extends State<DiscountForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _valueController;
  late final TextEditingController _usageLimitController;

  late DiscountType _type;
  late bool _isActive;
  DateTime? _validUntil;

  @override
  void initState() {
    super.initState();
    final discount = widget.initialDiscount;
    _type = discount?.type ?? DiscountType.percentage;
    _isActive = discount?.isActive ?? true;
    _validUntil = discount?.validUntil;

    _nameController = TextEditingController(text: discount?.name ?? '');
    _codeController = TextEditingController(text: discount?.code ?? '');
    _usageLimitController = TextEditingController(
      text: discount?.usageLimit?.toString() ?? '',
    );

    // Percentage keeps the raw number; fixed shows the euro amount.
    final initialValue = discount == null
        ? ''
        : discount.isPercentage
        ? discount.value.toString()
        : formatCents(discount.value, symbol: '');
    _valueController = TextEditingController(text: initialValue.trim());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _valueController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  String? _validateValue(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return 'Please enter a value';
    if (_type == DiscountType.percentage) {
      final percent = int.tryParse(text);
      if (percent == null || percent <= 0 || percent > 100) {
        return 'Enter a percentage between 1 and 100';
      }
    } else {
      final cents = parseCents(text);
      if (cents == null || cents <= 0) return 'Enter a valid amount';
    }
    return null;
  }

  Future<void> _pickValidUntil() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _validUntil ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _validUntil = picked);
  }

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final valueText = _valueController.text.trim();
    final value = _type == DiscountType.percentage
        ? int.parse(valueText)
        : parseCents(valueText)!;

    final code = _codeController.text.trim();
    final usageLimit = int.tryParse(_usageLimitController.text.trim());

    final discount = Discount(
      id: widget.initialDiscount?.id ?? 0,
      name: _nameController.text.trim(),
      code: code.isEmpty ? null : code,
      type: _type,
      value: value,
      isActive: _isActive,
      validUntil: _validUntil,
      usageLimit: usageLimit,
      usageCount: widget.initialDiscount?.usageCount ?? 0,
    );
    Navigator.of(context).pop(discount);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialDiscount != null;
    final isPercentage = _type == DiscountType.percentage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(context.tokens.spaceLg),
          child: AppText.headingSm(
            isEditing ? 'Edit Discount' : 'New Discount',
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 1),

        Flexible(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            padding: EdgeInsets.all(context.tokens.spaceLg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  AppTextField(
                    controller: _nameController,
                    label: 'Discount Name',
                    prefix: const Icon(AgoraIcons.tag),
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Please enter a name'
                        : null,
                  ),
                  SizedBox(height: context.tokens.spaceLg),

                  // Type
                  const AppText.titleMd('Type'),
                  SizedBox(height: context.tokens.spaceXs),
                  SegmentedButton<DiscountType>(
                    segments: const [
                      ButtonSegment(
                        value: DiscountType.percentage,
                        label: AppText.body('Percentage'),
                        icon: Icon(AgoraIcons.discount),
                      ),
                      ButtonSegment(
                        value: DiscountType.fixedAmount,
                        label: AppText.body('Fixed'),
                        icon: Icon(AgoraIcons.coin_alt),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (selection) {
                      setState(() => _type = selection.first);
                      _formKey.currentState?.validate();
                    },
                  ),
                  SizedBox(height: context.tokens.spaceLg),

                  // Value
                  AppTextField(
                    controller: _valueController,
                    label: isPercentage ? 'Percentage' : 'Amount',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    prefix: Icon(
                      isPercentage ? AgoraIcons.discount : AgoraIcons.coin_alt,
                    ),
                    suffix: AppText.body(
                      isPercentage ? '%' : context.currencySymbol,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: _validateValue,
                  ),
                  SizedBox(height: context.tokens.spaceLg),

                  // Code (optional)
                  AppTextField(
                    controller: _codeController,
                    label: 'Voucher code (optional)',
                    textCapitalization: TextCapitalization.characters,
                    prefix: const Icon(AgoraIcons.tag),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: context.tokens.spaceLg),

                  // Usage limit (optional)
                  AppTextField(
                    controller: _usageLimitController,
                    label: 'Usage limit (optional)',
                    helperText: 'Leave empty for unlimited use',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefix: const Icon(AgoraIcons.rotate_right),
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: context.tokens.spaceXs),

                  // Valid until (optional)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(AgoraIcons.calendar_01),
                    title: const AppText.body('Valid until'),
                    subtitle: AppText.bodySm(
                      _validUntil == null
                          ? 'No expiry'
                          : _formatDate(_validUntil!),
                      color: context.colors.mutedForeground,
                    ),
                    trailing: _validUntil == null
                        ? AppButton.ghost(
                            onPressed: _pickValidUntil,
                            label: 'Set date',
                            size: AppButtonSize.sm,
                          )
                        : IconButton(
                            icon: const Icon(AgoraIcons.x_mark),
                            onPressed: () => setState(() => _validUntil = null),
                          ),
                    onTap: _pickValidUntil,
                  ),

                  // Active
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const AppText.body('Active'),
                    subtitle: const AppText.caption('Available at checkout'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                  ),
                ],
              ),
            ),
          ),
        ),

        const Divider(height: 1),
        Padding(
          padding: EdgeInsets.all(context.tokens.spaceLg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.ghost(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Cancel',
              ),
              SizedBox(width: context.tokens.spaceMd),
              AppButton.primary(onPressed: _onSave, label: 'Save'),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
