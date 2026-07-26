import 'package:i18n/i18n.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:feature_products/presentation/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

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
          padding: EdgeInsets.symmetric(
            horizontal: context.tokens.spacing.md,
            vertical: context.tokens.spacing.sm,
          ),
          child: Row(
            children: [
              // Cancel
              AppButton.outline(
                onPressed: isSubmitting
                    ? null
                    : () => Navigator.of(context).pop(false),
                label: t.cancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colors.foreground,
                  side: BorderSide(color: context.colors.border),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.tokens.spacing.md,
                    vertical: context.tokens.spacing.sm,
                  ),
                ),
              ),
              SizedBox(width: context.tokens.spacing.xs),
              // Save as Draft
              AppButton.outline(
                onPressed: isSubmitting ? null : cubit.saveAsDraft,
                label: t.products.actions.save_as_draft,
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colors.foreground,
                  side: BorderSide(color: context.colors.border),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.tokens.spacing.md,
                    vertical: context.tokens.spacing.sm,
                  ),
                ),
              ),
              const Spacer(),
              // Back (chevron)
              if (!isFirstStep) ...[
                AppIconButton.outline(
                  onPressed: isSubmitting ? null : cubit.previousStep,
                  icon: const Icon(AgoraIcons.chevron_left),
                ),
                SizedBox(width: context.tokens.spacing.xxs),
              ],
              // Next / Add / Save
              AppButton.primary(
                onPressed: isLastStep ? () => cubit.submit() : cubit.nextStep,
                isLoading: isSubmitting,
                label: isLastStep
                    ? state.maybeMap(
                        editing: (s) => s.isEditing ? t.save : t.add,
                        orElse: () => t.add,
                      )
                    : t.next,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.tokens.spacing.lg,
                    vertical: context.tokens.spacing.sm,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
