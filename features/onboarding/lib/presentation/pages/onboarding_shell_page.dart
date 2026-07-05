import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_onboarding/domain/models/onboarding_draft.dart';
import 'package:feature_onboarding/presentation/blocs/onboarding_cubit.dart';
import 'package:feature_onboarding/presentation/widgets/steps/onboarding_steps.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// The first-run setup wizard. A single page that walks the operator through one
/// descriptive step at a time; state lives in [OnboardingCubit]. The app-level
/// gate reacts to [OnboardingPhase.completed] to move into the app.
@RoutePage()
class OnboardingShellPage extends StatelessWidget {
  const OnboardingShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final steps = cubit.steps;
        final stepIndex = state.stepIndex.clamp(0, steps.length - 1);
        final step = steps[stepIndex];

        return AppScaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    _Progress(current: stepIndex + 1, total: steps.length),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: KeyedSubtree(
                            key: ValueKey(step),
                            child: _stepBody(step, state.draft),
                          ),
                        ),
                      ),
                    ),
                    if (state.error != null) ...[
                      const SizedBox(height: 8),
                      AppText.bodySm(state.error!, color: context.colors.destructive),
                    ],
                    const SizedBox(height: 16),
                    _NavBar(
                      cubit: cubit,
                      step: step,
                      draft: state.draft,
                      isFirst: stepIndex == 0,
                      isLast: stepIndex == steps.length - 1,
                      isSubmitting: state.isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stepBody(OnboardingStep step, OnboardingDraft draft) => switch (step) {
    OnboardingStep.welcome => const WelcomeStep(),
    OnboardingStep.businessType => BusinessTypeStep(draft: draft),
    OnboardingStep.businessDetails => BusinessDetailsStep(draft: draft),
    OnboardingStep.taxCurrency => TaxCurrencyStep(draft: draft),
    OnboardingStep.payments => PaymentsStep(draft: draft),
    OnboardingStep.team => TeamStep(draft: draft),
    OnboardingStep.menu => MenuStep(draft: draft),
    OnboardingStep.review => ReviewStep(draft: draft),
  };
}

class _Progress extends StatelessWidget {
  const _Progress({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 6,
            backgroundColor: context.colors.muted,
            valueColor: AlwaysStoppedAnimation(context.colors.primary),
          ),
        ),
        const SizedBox(height: 8),
        AppText.caption('Step $current of $total', color: context.colors.mutedForeground),
      ],
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.cubit,
    required this.step,
    required this.draft,
    required this.isFirst,
    required this.isLast,
    required this.isSubmitting,
  });

  final OnboardingCubit cubit;
  final OnboardingStep step;
  final OnboardingDraft draft;
  final bool isFirst;
  final bool isLast;
  final bool isSubmitting;

  bool get _canContinue => switch (step) {
    OnboardingStep.businessType => draft.type != null,
    OnboardingStep.businessDetails => draft.businessName.trim().isNotEmpty,
    OnboardingStep.team => draft.staff.isNotEmpty,
    _ => true,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFirst)
          Expanded(
            child: AppButton.outline(
              label: 'Back',
              onPressed: isSubmitting ? null : cubit.back,
            ),
          ),
        if (!isFirst) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: AppButton.primary(
            label: isLast ? 'Finish setup' : 'Continue',
            isLoading: isSubmitting,
            onPressed: !_canContinue || isSubmitting
                ? null
                : (isLast ? cubit.finish : cubit.next),
          ),
        ),
      ],
    );
  }
}
