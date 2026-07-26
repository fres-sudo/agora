import 'package:app_settings/app_settings.dart';
import 'package:i18n/i18n.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_products/presentation/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_exports/bloc_exports.dart';

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
    final t = Translations.of(context);
    final currencySymbol = context.currencySymbol;

    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, formState) {
        final errors = formState.maybeMap(
          editing: (s) => s.errors,
          orElse: () => const <String, String>{},
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              AppText.titleMd(t.products.form.steps.pricing),
              const SizedBox(height: Sizes.lg),

              // Price
              _FormLabel(label: t.products.form.price, required: true),
              const SizedBox(height: Sizes.sm),
              AppTextField(
                controller: _priceController,
                onChanged: _onPriceChanged,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                prefixText: '$currencySymbol ',
                hintText: '0.00',
                errorText: errors['price'],
              ),
              const SizedBox(height: Sizes.lg),

              // Tax
              _FormLabel(label: t.products.form.tax),
              const SizedBox(height: Sizes.sm),
              AppTextField(
                controller: _taxController,
                onChanged: _onTaxChanged,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                prefixText: '% ',
                hintText: '0',
                errorText: errors['tax'],
              ),
            ],
          ),
        );
      },
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
    return Row(
      children: [
        AppText.label(label),
        if (required) ...[
          SizedBox(width: context.tokens.spaceXxs),
          AppText.label('*', color: context.colors.destructive),
        ],
      ],
    );
  }
}
