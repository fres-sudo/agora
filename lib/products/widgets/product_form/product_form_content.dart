import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/blocs/product_form/product_form_cubit.dart';
import 'package:agora/products/widgets/product_form/product_form_stepper.dart';
import 'package:agora/products/widgets/product_form/product_form_actions.dart';
import 'package:agora/products/widgets/product_form/steps/product_info_step.dart';
import 'package:agora/products/widgets/product_form/steps/pricing_step.dart';
import 'package:agora/products/widgets/product_form/steps/variants_modifiers_step.dart';
import 'package:agora/products/widgets/product_form/steps/ingredients_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main content of the product form with stepper and steps.
class ProductFormContent extends StatelessWidget {
  const ProductFormContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return BlocConsumer<ProductFormCubit, ProductFormState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (s) {
            Navigator.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: Sizes.sm),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.isNew
                                ? t.products.messages.product_added
                                : t.products.messages.product_updated,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            s.isNew
                                ? t.products.messages.product_added_desc
                                : t.products.messages.product_updated_desc,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.primary500,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          error: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: AppColors.error500,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        final isEditing = state.maybeMap(
          editing: (s) => s.isEditing,
          orElse: () => false,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _ProductFormHeader(
              title: isEditing
                  ? t.products.edit_product
                  : t.products.add_product,
            ),
            const Divider(height: 1),
            // Stepper
            const ProductFormStepper(),
            // Content
            Expanded(
              child: _buildStepContent(state),
            ),
            // Actions
            const Divider(height: 1),
            const ProductFormActions(),
          ],
        );
      },
    );
  }

  Widget _buildStepContent(ProductFormState state) {
    return state.maybeMap(
      editing: (s) {
        switch (s.currentStep) {
          case ProductFormStep.productInfo:
            return const ProductInfoStep();
          case ProductFormStep.pricing:
            return const PricingStep();
          case ProductFormStep.variantsModifiers:
            return const VariantsModifiersStep();
          case ProductFormStep.ingredients:
            return const IngredientsStep();
        }
      },
      submitting: (_) => const Center(child: CircularProgressIndicator()),
      orElse: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Form header with title and close button.
class _ProductFormHeader extends StatelessWidget {
  const _ProductFormHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
