import 'package:feature_discounts/domain/models/discount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

/// Create/edit form for a [Discount] (Settings → Discount & Voucher, P6-3).
///
/// Percentage discounts store the raw percent in [Discount.value]; fixed
/// discounts store cents (parsed from the euro amount the operator types).
class DiscountForm extends StatefulWidget {
  const DiscountForm({super.key, this.initialDiscount});

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
    final theme = Theme.of(context);
    final isEditing = widget.initialDiscount != null;
    final isPercentage = _type == DiscountType.percentage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            isEditing ? 'Edit Discount' : 'New Discount',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 1),

        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Discount Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Please enter a name'
                        : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Type
                  Text(
                    'Type',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<DiscountType>(
                    segments: const [
                      ButtonSegment(
                        value: DiscountType.percentage,
                        label: Text('Percentage'),
                        icon: Icon(Icons.percent),
                      ),
                      ButtonSegment(
                        value: DiscountType.fixedAmount,
                        label: Text('Fixed'),
                        icon: Icon(Icons.euro),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (selection) {
                      setState(() => _type = selection.first);
                      _formKey.currentState?.validate();
                    },
                  ),
                  const SizedBox(height: 20),

                  // Value
                  TextFormField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      labelText: isPercentage ? 'Percentage' : 'Amount',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        isPercentage ? Icons.percent : Icons.euro,
                      ),
                      suffixText: isPercentage ? '%' : '€',
                    ),
                    validator: _validateValue,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Code (optional)
                  TextFormField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Voucher code (optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.confirmation_number_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Usage limit (optional)
                  TextFormField(
                    controller: _usageLimitController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Usage limit (optional)',
                      helperText: 'Leave empty for unlimited use',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.repeat),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 8),

                  // Valid until (optional)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_outlined),
                    title: const Text('Valid until'),
                    subtitle: Text(
                      _validUntil == null
                          ? 'No expiry'
                          : _formatDate(_validUntil!),
                    ),
                    trailing: _validUntil == null
                        ? TextButton(
                            onPressed: _pickValidUntil,
                            child: const Text('Set date'),
                          )
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () =>
                                setState(() => _validUntil = null),
                          ),
                    onTap: _pickValidUntil,
                  ),

                  // Active
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Active'),
                    subtitle: const Text('Available at checkout'),
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
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.ghost(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Cancel',
              ),
              const SizedBox(width: 16),
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
