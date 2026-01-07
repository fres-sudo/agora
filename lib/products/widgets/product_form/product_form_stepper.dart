import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Horizontal stepper showing form progress.
class ProductFormStepper extends StatelessWidget {
  const ProductFormStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    final steps = [
      _StepData(
        title: t.products.form.steps.product_info,
        description: t.products.form.steps.product_info_desc,
      ),
      _StepData(
        title: t.products.form.steps.pricing,
        description: t.products.form.steps.pricing_desc,
      ),
      _StepData(
        title: t.products.form.steps.variants_modifiers,
        description: t.products.form.steps.variants_modifiers_desc,
      ),
      _StepData(
        title: t.products.form.steps.ingredients,
        description: t.products.form.steps.ingredients_desc,
      ),
    ];

    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {
        final currentIndex = state.currentStepIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.lg,
            vertical: Sizes.md,
          ),
          child: Row(
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                Expanded(
                  child: _StepIndicator(
                    data: steps[i],
                    index: i,
                    isCompleted: i < currentIndex,
                    isCurrent: i == currentIndex,
                    onTap: i < currentIndex
                        ? () => context
                            .read<ProductFormCubit>()
                            .goToStep(ProductFormStep.values[i])
                        : null,
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: _StepConnector(
                      isCompleted: i < currentIndex,
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StepData {
  const _StepData({required this.title, required this.description});
  final String title;
  final String description;
}

/// Individual step indicator with circle and label.
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.data,
    required this.index,
    required this.isCompleted,
    required this.isCurrent,
    this.onTap,
  });

  final _StepData data;
  final int index;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle indicator
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted || isCurrent
                  ? theme.primaryColor
                  : AppColors.neutral200,
              shape: BoxShape.circle,
              border: isCurrent && !isCompleted
                  ? Border.all(color: theme.primaryColor, width: 2)
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : isCurrent
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
            ),
          ),
          const SizedBox(height: Sizes.sm),
          // Title
          Text(
            data.title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isCurrent || isCompleted
                  ? AppColors.neutral900
                  : AppColors.neutral500,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Description (only show on tablet)
          if (!context.isMobile) ...[
            const SizedBox(height: 2),
            Text(
              data.description,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.neutral400,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Connector line between steps.
class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        height: 2,
        color: isCompleted ? AppColors.primary500 : AppColors.neutral200,
      ),
    );
  }
}
