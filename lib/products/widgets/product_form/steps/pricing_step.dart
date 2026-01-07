import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Step 2: Pricing - price, tax.
class PricingStep extends StatefulWidget {
  const PricingStep({super.key});

  @override
  State<PricingStep> createState() => _PricingStepState();
}

class _PricingStepState extends State<PricingStep> {
  late TextEditingController _priceController;
  late TextEditingController _taxController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProductFormCubit>().state;
    final formData = state.maybeMap(
      editing: (s) => s.formData,
      orElse: () => null,
    );

    final priceDollars = (formData?.priceCents ?? 0) / 100.0;
    _priceController = TextEditingController(
      text: priceDollars > 0 ? priceDollars.toStringAsFixed(2) : '',
    );
    _taxController = TextEditingController(
      text: formData?.taxPercent.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _onPriceChanged(String value) {
    final cubit = context.read<ProductFormCubit>();
    final parsed = double.tryParse(value) ?? 0;
    cubit.updatePrice((parsed * 100).round());
  }

  void _onTaxChanged(String value) {
    final cubit = context.read<ProductFormCubit>();
    final parsed = int.tryParse(value) ?? 0;
    cubit.updateTaxPercent(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            t.products.form.steps.pricing,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Sizes.lg),

          // Price
          _FormLabel(label: t.products.form.price, required: true),
          const SizedBox(height: Sizes.sm),
          TextField(
            controller: _priceController,
            onChanged: _onPriceChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              prefixText: '\$ ',
              hintText: '0.00',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.sm),
              ),
            ),
          ),
          const SizedBox(height: Sizes.lg),

          // Tax
          _FormLabel(label: t.products.form.tax),
          const SizedBox(height: Sizes.sm),
          TextField(
            controller: _taxController,
            onChanged: _onTaxChanged,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              prefixText: '% ',
              hintText: '0',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Sizes.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Form label widget with optional required indicator.
class _FormLabel extends StatelessWidget {
  const _FormLabel({required this.label, this.required = false});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.error500,
            ),
          ),
        ],
      ],
    );
  }
}
