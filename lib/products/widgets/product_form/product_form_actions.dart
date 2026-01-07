import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/ui/device.dart';
import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Action buttons at the bottom of the form.
class ProductFormActions extends StatelessWidget {
  const ProductFormActions({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {
        final cubit = context.read<ProductFormCubit>();
        final isFirstStep = state.isFirstStep;
        final isLastStep = state.isLastStep;
        final isSubmitting = state.maybeMap(
          submitting: (_) => true,
          orElse: () => false,
        );

        return Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Row(
            children: [
              // Cancel
              OutlinedButton(
                onPressed: isSubmitting
                    ? null
                    : () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.neutral700,
                  side: const BorderSide(color: AppColors.neutral300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.lg,
                    vertical: Sizes.md,
                  ),
                ),
                child: Text(t.cancel),
              ),
              const SizedBox(width: Sizes.sm),
              // Save as Draft
              OutlinedButton(
                onPressed: isSubmitting ? null : cubit.saveAsDraft,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.neutral700,
                  side: const BorderSide(color: AppColors.neutral300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.lg,
                    vertical: Sizes.md,
                  ),
                ),
                child: Text(t.products.actions.save_as_draft),
              ),
              const Spacer(),
              // Back
              if (!isFirstStep) ...[
                OutlinedButton(
                  onPressed: isSubmitting ? null : cubit.previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.neutral700,
                    side: const BorderSide(color: AppColors.neutral300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.lg,
                      vertical: Sizes.md,
                    ),
                  ),
                  child: Text(t.back),
                ),
                const SizedBox(width: Sizes.sm),
              ],
              // Next / Add / Save
              FilledButton(
                onPressed: isSubmitting
                    ? null
                    : isLastStep
                        ? () => cubit.submit()
                        : cubit.nextStep,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.xl,
                    vertical: Sizes.md,
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isLastStep
                            ? (state.maybeMap(
                                editing: (s) =>
                                    s.isEditing ? t.save : t.add,
                                orElse: () => t.add,
                              ))
                            : t.next,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
