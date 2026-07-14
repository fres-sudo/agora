import 'package:ui_kit/ui_kit.dart';
import 'package:feature_products/presentation/blocs/product_form/product_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

/// Compact dot stepper showing form progress.
class ProductFormStepper extends StatelessWidget {
  const ProductFormStepper({super.key});

  static final int _stepCount = ProductFormStep.values.length;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      builder: (context, state) {
        final currentIndex = state.currentStepIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.lg,
            vertical: Sizes.sm,
          ),
          child: Row(
            children: [
              for (int i = 0; i < _stepCount; i++) ...[
                _StepDot(isActive: i <= currentIndex),
                if (i < _stepCount - 1)
                  Expanded(
                    child: _StepConnector(isCompleted: i < currentIndex),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor
            : context.colors.border,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color: isCompleted
          ? Theme.of(context).primaryColor
          : context.colors.border,
    );
  }
}
