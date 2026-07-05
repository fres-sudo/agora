import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:feature_onboarding/domain/models/onboarding_draft.dart';
import 'package:feature_onboarding/domain/repositories/onboarding_repository.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required OnboardingRepository repository})
    : _repository = repository,
      super(const OnboardingState());

  final OnboardingRepository _repository;

  /// The steps visible for the current draft (the team step is skipped for
  /// single-user businesses).
  List<OnboardingStep> get steps => _stepsFor(state.draft);

  static List<OnboardingStep> _stepsFor(OnboardingDraft draft) => [
    OnboardingStep.welcome,
    OnboardingStep.businessType,
    OnboardingStep.businessDetails,
    OnboardingStep.taxCurrency,
    OnboardingStep.payments,
    if (draft.profile.requiresStaffLogin) OnboardingStep.team,
    OnboardingStep.menu,
    OnboardingStep.review,
  ];

  OnboardingStep get currentStep {
    final list = steps;
    final index = state.stepIndex.clamp(0, list.length - 1);
    return list[index];
  }

  bool get isFirstStep => state.stepIndex == 0;
  bool get isLastStep => state.stepIndex >= steps.length - 1;

  void next() {
    if (isLastStep) return;
    emit(state.copyWith(stepIndex: state.stepIndex + 1));
  }

  void back() {
    if (isFirstStep) return;
    emit(state.copyWith(stepIndex: state.stepIndex - 1));
  }

  /// Picking a type applies that profile's sensible defaults so later steps are
  /// pre-filled. Keeps the current step index valid if the step list shrinks.
  void selectType(BusinessType type) {
    final profile = BusinessProfile.forType(type);
    final draft = state.draft.copyWith(
      type: type,
      taxRate: profile.defaultTaxRate,
      cardEnabled: profile.defaultCardEnabled,
      currencySymbol: profile.defaultCurrencySymbol,
      staff: profile.requiresStaffLogin ? state.draft.staff : const [],
    );
    final newIndex = state.stepIndex.clamp(0, _stepsFor(draft).length - 1);
    emit(state.copyWith(draft: draft, stepIndex: newIndex));
  }

  void updateDraft(OnboardingDraft draft) => emit(state.copyWith(draft: draft));

  void addStaff(StaffDraft staff) {
    emit(state.copyWith(draft: state.draft.copyWith(staff: [...state.draft.staff, staff])));
  }

  void removeStaffAt(int index) {
    final list = [...state.draft.staff]..removeAt(index);
    emit(state.copyWith(draft: state.draft.copyWith(staff: list)));
  }

  void setMenuChoice(MenuChoice choice) {
    emit(state.copyWith(draft: state.draft.copyWith(menuChoice: choice)));
  }

  Future<void> finish() async {
    emit(state.copyWith(phase: OnboardingPhase.submitting));
    try {
      await _repository.complete(state.draft);
      emit(state.copyWith(phase: OnboardingPhase.completed));
    } catch (e) {
      emit(state.copyWith(phase: OnboardingPhase.editing, error: e.toString()));
    }
  }

  /// Wipe everything and return to a fresh wizard. Invoked from Settings.
  Future<void> resetEverything() async {
    emit(state.copyWith(phase: OnboardingPhase.submitting));
    try {
      await _repository.resetEverything();
      emit(const OnboardingState(phase: OnboardingPhase.needsReonboarding));
    } catch (e) {
      emit(state.copyWith(phase: OnboardingPhase.editing, error: e.toString()));
    }
  }

  /// After the gate has navigated to the wizard following a reset, drop back to
  /// the neutral editing phase.
  void acknowledgeReonboarding() {
    if (state.phase == OnboardingPhase.needsReonboarding) {
      emit(const OnboardingState());
    }
  }
}
