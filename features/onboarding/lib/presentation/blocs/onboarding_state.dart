part of 'onboarding_cubit.dart';

/// The lifecycle phase of the wizard. The app-level gate listens for
/// [completed] (proceed into the app) and [needsReonboarding] (a reset happened
/// mid-session; return to the wizard).
enum OnboardingPhase { editing, submitting, completed, needsReonboarding }

/// The ordered steps of the wizard. [team] is only present for staff-login
/// businesses; the visible list is computed in [OnboardingCubit.steps].
enum OnboardingStep {
  welcome,
  businessType,
  businessDetails,
  taxCurrency,
  payments,
  team,
  menu,
  review,
}

class OnboardingState {
  const OnboardingState({
    this.phase = OnboardingPhase.editing,
    this.draft = const OnboardingDraft(),
    this.stepIndex = 0,
    this.error,
  });

  final OnboardingPhase phase;
  final OnboardingDraft draft;
  final int stepIndex;
  final String? error;

  bool get isSubmitting => phase == OnboardingPhase.submitting;

  OnboardingState copyWith({
    OnboardingPhase? phase,
    OnboardingDraft? draft,
    int? stepIndex,
    String? error,
  }) => OnboardingState(
    phase: phase ?? this.phase,
    draft: draft ?? this.draft,
    stepIndex: stepIndex ?? this.stepIndex,
    error: error,
  );
}
